Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbYETN4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbYETN4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYETNz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:55:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:59438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbYETNzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:55:54 -0400
Date: Tue, 20 May 2008 15:58:30 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixups to ATA ACPI hotplug
Message-ID: <20080520135828.GA3167@homac>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080506081347.GA8688@homac> <20080506082110.GA10355@srcf.ucam.org> <48201987.4020009@gmail.com> <20080506092653.GB4378@homac> <20080506093628.GA12469@srcf.ucam.org> <20080519162934.GA15623@srcf.ucam.org> <20080520074442.GA14417@homac> <20080520102038.GA2441@srcf.ucam.org> <20080520131831.GA568@homac> <20080520132217.GA5633@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520132217.GA5633@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20. May - 14:22:17, Matthew Garrett wrote:
> On Tue, May 20, 2008 at 03:18:32PM +0200, Holger Macht wrote:
> 
> > +	if (kobj && !is_dock_event) {
> > +		sprintf(event_string, "BAY_EVENT=%d", event);
> > +		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
> 
> I think we want to do the _EJ0 checking before this, otherwise we'll 
> generate two uevents for the same removal on some hardware. Otherwise, 
> looks good.

So once again:

Handle bay devices in dock stations

* Differentiate between bay devices in dock stations and others:

 - When an ACPI_NOTIFY_EJECT_REQUEST appears, just signal uevent to
   userspace (that is when the optional eject button on a bay device is
   pressed/pulled) giving the possibility to unmount file systems and to
   clean up. Also, only send uevent in case we get an EJECT_REQUEST
   without doing anything else. In other cases, you'll get an add/remove
   event because libata attaches/detaches the device.

 - In case of a dock event, which in turn signals an
   ACPI_NOTIFY_EJECT_REQUEST, immediately detach the device, because it
   may already have been gone

* In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
  the device has been plugged or unplugged. If plugged, hotplug it, if
  unplugged, just signal event to userspace
  (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)

Signed-off-by: Holger Macht <hmacht@suse.de>
---

--- linux-2.6.25/drivers/ata/libata-acpi.c.orig	2008-05-20 13:25:50.000000000 +0200
+++ linux-2.6.25/drivers/ata/libata-acpi.c	2008-05-20 15:56:38.000000000 +0200
@@ -118,8 +118,25 @@ static void ata_acpi_associate_ide_port(
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
+static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
+{
+	if (dev)
+		dev->flags |= ATA_DFLAG_DETACH;
+	else {
+		struct ata_link *tlink;
+		struct ata_device *tdev;
+
+		ata_port_for_each_link(tlink, ap)
+			ata_link_for_each_dev(tdev, tlink)
+			tdev->flags |= ATA_DFLAG_DETACH;
+	}
+
+	ata_port_freeze(ap);
+	ata_port_schedule_eh(ap);
+}
+
 static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
-				    *dev, u32 event)
+				    *dev, u32 event, int is_dock_event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
@@ -135,83 +152,92 @@ static void ata_acpi_handle_hotplug(stru
 		ap = dev->link->ap;
 	ehi = &ap->link.eh_info;
 
-	spin_lock_irqsave(ap->lock, flags);
-
-	if (dev)
+	if (dev) {
+		if (dev->sdev)
+			kobj = &dev->sdev->sdev_gendev.kobj;
 		handle = dev->acpi_handle;
-	else
+	} else {
+		kobj = &ap->dev->kobj;
 		handle = ap->acpi_handle;
+	}
 
 	status = acpi_get_handle(handle, "_EJ0", &tmphandle);
 	if (ACPI_FAILURE(status)) {
-		/* This device is not ejectable */
-		spin_unlock_irqrestore(ap->lock, flags);
+		/* This device does not support hotplug */
 		return;
 	}
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status)) {
-		printk ("Unable to determine bay status\n");
-		spin_unlock_irqrestore(ap->lock, flags);
-		return;
+	if (kobj && !is_dock_event) {
+		sprintf(event_string, "BAY_EVENT=%d", event);
+		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
 
+	spin_lock_irqsave(ap->lock, flags);
+
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
-		if (!sta) {
-                /* Device has been unplugged */
-			if (dev)
-				dev->flags |= ATA_DFLAG_DETACH;
-			else {
-				struct ata_link *tlink;
-				struct ata_device *tdev;
-
-				ata_port_for_each_link(tlink, ap) {
-					ata_link_for_each_dev(tdev, tlink) {
-						tdev->flags |=
-							ATA_DFLAG_DETACH;
-					}
-				}
-			}
-			ata_port_schedule_eh(ap);
-			wait = 1;
-		} else {
+
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_ERR "Unable to determine bay status\n");
+			break;
+		}
+
+		if (sta) {
 			ata_ehi_hotplugged(ehi);
 			ata_port_freeze(ap);
+		} else {
+			/* The device has gone - unplug it */
+			ata_acpi_detach_device(ap, dev);
+			wait = 1;
 		}
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
+
+		if (!is_dock_event)
+			break;
+
+		/* undock event - immediate unplug */
+		ata_acpi_detach_device(ap, dev);
+		wait = 1;
+		break;
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (wait)
 		ata_port_wait_eh(ap);
+}
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
-		kobj = &ap->dev->kobj;
+static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_device *dev = data;
 
-	if (kobj) {
-		sprintf(event_string, "BAY_EVENT=%d", event);
-		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
-	}
+	ata_acpi_handle_hotplug(NULL, dev, event, 1);
+}
+
+static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_port *ap = data;
+
+	ata_acpi_handle_hotplug(ap, NULL, event, 1);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
 
-	ata_acpi_handle_hotplug(NULL, dev, event);
+	ata_acpi_handle_hotplug(NULL, dev, event, 0);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, NULL, event);
+	ata_acpi_handle_hotplug(ap, NULL, event, 0);
 }
 
 /**
@@ -252,7 +278,7 @@ void ata_acpi_associate(struct ata_host
 						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
-						     ata_acpi_ap_notify, ap);
+					     ata_acpi_ap_notify_dock, ap);
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -264,7 +290,7 @@ void ata_acpi_associate(struct ata_host
 						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
-						ata_acpi_dev_notify, dev);
+					     ata_acpi_dev_notify_dock, dev);
 			}
 		}
 	}

