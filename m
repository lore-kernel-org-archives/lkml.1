Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYFCS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYFCS1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYFCS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:27:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:34568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYFCS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:27:42 -0400
Date: Tue, 3 Jun 2008 20:27:59 +0200
From: Holger Macht <hmacht@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080603182759.GB3556@homac>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4845886E.2010505@garzik.org>
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

Previous patch differences:
 * Remove one call to ata_port_freeze
 * Add some documentation from Tejun

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index dbf6ca7..3ff8b14 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,12 +118,62 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
-				    *dev, u32 event)
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
+/* @ap and @dev are the same as ata_acpi_handle_hotplug() */
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
+	ata_port_schedule_eh(ap);
+}
+
+/**
+ * ata_acpi_handle_hotplug - ACPI event handler backend
+ * @ap: ATA port ACPI event occurred
+ * @dev: ATA device ACPI event occurred (can be NULL)
+ * @event: ACPI event which occurred
+ * @is_dock_event: boolean indicating whether the event was a dock one
+ *
+ * All ACPI bay / device realted events end up in this function.  If
+ * the event is port-wide @dev is NULL.  If the event is specific to a
+ * device, @dev points to it.
+ *
+ * Hotplug (as opposed to unplug) notification is always handled as
+ * port-wide while unplug only kills the target device on device-wide
+ * event.
+ *
+ * LOCKING:
+ * ACPI notify handler context.  May sleep.
+ */
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
+				    u32 event, int is_dock_event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
-	struct ata_eh_info *ehi;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct kobject *kobj = NULL;
 	int wait = 0;
 	unsigned long flags;
@@ -131,87 +181,100 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
 	unsigned long sta;
 	acpi_status status;
 
-	if (!ap)
-		ap = dev->link->ap;
-	ehi = &ap->link.eh_info;
-
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
+			ata_port_printk(ap, KERN_ERR,
+				"acpi: failed to determine bay status (0x%x)\n",
+				status);
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
 
+	/* make sure kobj doesn't go away while ap->lock is released */
+	kobject_get(kobj);
+
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		ata_acpi_eject_device(handle);
+	}
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
-		kobj = &ap->dev->kobj;
-
-	if (kobj) {
+	if (kobj && !is_dock_event) {
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+
+	kobject_put(kobj);
+}
+
+static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_device *dev = data;
+
+	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 1);
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
+	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 0);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, NULL, event);
+	ata_acpi_handle_hotplug(ap, NULL, event, 0);
 }
 
 /**
@@ -252,7 +315,7 @@ void ata_acpi_associate(struct ata_host *host)
 						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
-						     ata_acpi_ap_notify, ap);
+					     ata_acpi_ap_notify_dock, ap);
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -264,7 +327,7 @@ void ata_acpi_associate(struct ata_host *host)
 						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
-						ata_acpi_dev_notify, dev);
+					     ata_acpi_dev_notify_dock, dev);
 			}
 		}
 	}
