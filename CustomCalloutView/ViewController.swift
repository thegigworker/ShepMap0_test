//
//  ViewController.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/9/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//


import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var coordinates: [[Double]]!
    var names:[String]!
    var addresses:[String]!
    var phones:[String]!

    @objc func callPhoneNumber(sender: UIButton) {
        let v = sender.superview as! CustomCalloutView
        if let url = URL(string: "telprompt://\(v.starbucksPhone.text!)"), UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get data set
        coordinates = [[48.85672,2.35501],[48.85196,2.33944],[48.85376,2.33953]]// Latitude,Longitude
        names = ["Coffee Shop · Rue de Rivoli","Cafe · Boulevard Saint-Germain","Coffee Shop · Rue Saint-André des Arts"]
        addresses = ["46 Rue de Rivoli, 75004 Paris, France","91 Boulevard Saint-Germain, 75006 Paris, France","62 Rue Saint-André des Arts, 75006 Paris, France"]
        phones = ["+33144789478","+33146345268","+33146340672"]
        //
        self.mapView.delegate = self
        // count the data set and act accordingly
        for i in 0...2
        {
            let coordinate = coordinates[i]
            let point = ShepSingleAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] , longitude: coordinate[1] ))
            point.image = UIImage(named: "starbucks-\(i+1).jpg")
            point.name = names[i]
            point.address = addresses[i]
            point.phone = phones[i]
            self.mapView.addAnnotation(point)
        }
        // set the display region
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.3522219000000177), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "starbuckpin")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let ShepSingleAnnotation = view.annotation as! ShepSingleAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = ShepSingleAnnotation.name
        calloutView.starbucksAddress.text = ShepSingleAnnotation.address
        calloutView.starbucksPhone.text = ShepSingleAnnotation.phone
        
        //
        let button = UIButton(frame: calloutView.starbucksPhone.frame)
        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        calloutView.starbucksImage.image = ShepSingleAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// --------------------------------------------------------
// from ShepMap2 (Trax)
// inside:  class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate
//
//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationViewReuseIdentifier)
//    //
//    let reuseId = "temp" // Constants.AnnotationViewReuseIdentifier
//    
//    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//    if pinView == nil {
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView!.canShowCallout = true
//        pinView!.animatesDrop = true
//        pinView!.pinTintColor = .purple
//        // pinView!.pinTintColor = GPX.shepSingleAnnotationData.pinTintColor(GPX.shepSingleAnnotationData)()
//    } else {
//        pinView!.pinTintColor = .green
//        pinView!.annotation = annotation
//    }
//    //        if annotation is GPX.shepSingleAnnotationData {
//    //            let shepsPinView: MKPinAnnotationView  = MKPinAnnotationView.redPinColor()
//    //            shepsPinView.pinTintColor = .purple // annotation.pinTintColor()
//    //            // shepsPinView.pinTintColor = annotation.pinTintColor() as! UIColor
//    //        }
//    if view == nil {
//        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
//        view.canShowCallout = true
//    } else {
//        view.annotation = annotation
//    }
//    view.isDraggable = annotation is EditableWaypoint
//    view.leftCalloutAccessoryView = nil
//    view.rightCalloutAccessoryView = nil
//    if let waypoint = annotation as? shepDataSource.shepSingleAnnotation {
//        if waypoint.thumbnailURL != nil {
//            view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
//        }
//        if waypoint is EditableWaypoint {
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//    }
//    
//    return view
//}


// --------------------------------------------------------
// from ShepMap3 (Honolulu)
// inside:  extension ViewController: MKMapViewDelegate {
// which is extension for:  class ViewController: UIViewController {
//
//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    if let annotation = annotation as? ShepSingleAnnotationData {
//        let identifier = "artPin"
//        var view: MKPinAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKPinAnnotationView { // 2
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 3
//            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//            
//            //view.annotationImage = UIImage(named: <#T##String#>)
//            //view.leftCalloutAccessoryView = UILabel(.text("Hello"))as UIView
//        }
//        
//        // annotation.
//        view.pinTintColor = annotation.pinTintColor()
//        return view
//    }
//    return nil
//}


// --------------------------------------------------------
// from ShepMap4 (MapKitDirectionDemo)
// inside:  class MapViewController: UIViewController, MKMapViewDelegate {
//
//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    let identifier = "MyPin"
//    
//    if annotation is MKUserLocation {
//        return nil
//    }
//    
//    // Reuse the annotation if possible
//    var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
//    
//    if annotationView == nil {
//        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        annotationView?.canShowCallout = true
//    }
//    
//    if let currentPlacemarkCoordinate = currentPlacemark?.location?.coordinate {
//        if currentPlacemarkCoordinate.latitude == annotation.coordinate.latitude &&
//            currentPlacemarkCoordinate.longitude == annotation.coordinate.longitude {
//            
//            let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
//            leftIconView.image = UIImage(named: restaurant.image)!
//            annotationView?.leftCalloutAccessoryView = leftIconView
//            
//            // Pin color customization
//            if #available(iOS 9.0, *) {
//                annotationView?.pinTintColor = UIColor.green
//            }
//        } else {
//            // Pin color customization
//            if #available(iOS 9.0, *) {
//                annotationView?.pinTintColor = UIColor.red
//            }
//        }
//    }
//    
//    annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//    
//    return annotationView
//}

// --------------------------------------------------------
