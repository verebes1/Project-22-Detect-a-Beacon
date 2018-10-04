//
//  ViewController.swift
//  Project-22-Detect-a-Beacon
//
//  Created by verebes on 04/10/2018.
//  Copyright © 2018 A&D Progress. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var distanceInMetres: UILabel!
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.gray
    }
    
    //MARK: LOCATION MANAGER DELEGATE METHODS
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
//                    print("RANGING AVAILABLE WE ARE IN BUSINESS")
//                    distanceReading.text = "CHECK OK"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

    //MARK: SCANNING FOR BEACONS
    
    func startScanning() {
        guard let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") else { fatalError("COULD NOT SET UUID FOR BEACON TO SEARCH") }
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    //MARK: UPDATING UI WITH INFO FROM SCANNING
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }

}

