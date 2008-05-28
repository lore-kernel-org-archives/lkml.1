Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbYE1Ogb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbYE1Ogb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE1OgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:36:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:54880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYE1OgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:36:07 -0400
Date: Wed, 28 May 2008 16:38:57 +0200
From: Holger Macht <hmacht@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, akpm@linux-foundation.org
Subject: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080528143857.GB5585@homac.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

* Call ACPI _EJ0 for detached devices

Signed-off-by: Holger Macht <hmacht@suse.de>
---

Changes regarding the previous patch:

 * Make sure kobj does not go away outside locking
 * Coding style cleanups
 * Call _EJ0 for detached devices

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index dbf6ca7..e0e49fd 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,8 +118,40 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
+static void ata_acpi_eject_device(acpi_handle handle)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = 1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_EJ0",
+					      &arg_list, NULL)))
+		printk(KERN_ERR "Failed to evaluate _EJ0!\n");
+}
+
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
+				tdev->flags |= ATA_DFLAG_DETACH;
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
@@ -135,83 +167,98 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
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
-	if (ACPI_FAILURE(status)) {
-		/* This device is not ejectable */
-		spin_unlock_irqrestore(ap->lock, flags);
+	if (ACPI_FAILURE(status))
+		/* This device does not support hotplug */
 		return;
-	}
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status)) {
-		printk ("Unable to determine bay status\n");
-		spin_unlock_irqrestore(ap->lock, flags);
-		return;
-	}
+	spin_lock_irqsave(ap->lock, flags);
 
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
-	}
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
 
-	spin_unlock_irqrestore(ap->lock, flags);
+		if (!is_dock_event)
+			break;
 
-	if (wait)
-		ata_port_wait_eh(ap);
+		/* undock event - immediate unplug */
+		ata_acpi_detach_device(ap, dev);
+		wait = 1;
+		break;
+	}
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
-		kobj = &ap->dev->kobj;
+	/* make sure kobj doesn't go away while ap->lock is released */
+	kobject_get(kobj);
+
+	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (kobj) {
+	if (kobj && !is_dock_event) {
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+
+	kobject_put(kobj);
+
+	if (wait) {
+		ata_port_wait_eh(ap);
+		ata_acpi_eject_device(handle);
+	}
+}
+
+static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_device *dev = data;
+
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
@@ -252,7 +299,7 @@ void ata_acpi_associate(struct ata_host *host)
 						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
-						     ata_acpi_ap_notify, ap);
+					     ata_acpi_ap_notify_dock, ap);
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -264,7 +311,7 @@ void ata_acpi_associate(struct ata_host *host)
 						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
-						ata_acpi_dev_notify, dev);
+					     ata_acpi_dev_notify_dock, dev);
 			}
 		}
 	}

