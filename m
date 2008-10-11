Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbYJKGpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbYJKGpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYJKGhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:35 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbYJKGhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:15 -0400
Date: Sat, 11 Oct 2008 02:35:54 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 34/85] libata: remove functions now handed by ACPI dock driver
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <f730ae1838635a02aa60834762c61566911d004c.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

dock driver can handle ata(bay) hotplug now. dock driver already handles
_EJ0 and _STA, so remove them. Also libata doesn't need register
notification handler anymore.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c       |    3 +-
 drivers/ata/libata-acpi.c |  107 ++++++---------------------------------------
 2 files changed, 16 insertions(+), 94 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 4b395b1..f19f643 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -738,7 +738,8 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 		/* Fall back */
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		begin_undock(ds);
-		if (immediate_undock || surprise_removal)
+		if ((immediate_undock && !(ds->flags & DOCK_IS_ATA))
+		   || surprise_removal)
 			handle_eject_request(ds, event);
 		else
 			dock_event(ds, event, UNDOCK_EVENT);
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9330b79..97727be 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -120,21 +120,6 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_eject_device(acpi_handle handle)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = 1;
-
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_EJ0",
-					      &arg_list, NULL)))
-		printk(KERN_ERR "Failed to evaluate _EJ0!\n");
-}
-
 /* @ap and @dev are the same as ata_acpi_handle_hotplug() */
 static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
 {
@@ -157,7 +142,6 @@ static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
  * @ap: ATA port ACPI event occurred
  * @dev: ATA device ACPI event occurred (can be NULL)
  * @event: ACPI event which occurred
- * @is_dock_event: boolean indicating whether the event was a dock one
  *
  * All ACPI bay / device realted events end up in this function.  If
  * the event is port-wide @dev is NULL.  If the event is specific to a
@@ -171,115 +155,58 @@ static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
  * ACPI notify handler context.  May sleep.
  */
 static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
-				    u32 event, int is_dock_event)
+				    u32 event)
 {
-	char event_string[12];
-	char *envp[] = { event_string, NULL };
 	struct ata_eh_info *ehi = &ap->link.eh_info;
-	struct kobject *kobj = NULL;
 	int wait = 0;
 	unsigned long flags;
-	acpi_handle handle, tmphandle;
-	unsigned long sta;
-	acpi_status status;
+	acpi_handle handle;
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
+	if (dev)
 		handle = dev->acpi_handle;
-	} else {
-		kobj = &ap->dev->kobj;
+	else
 		handle = ap->acpi_handle;
-	}
-
-	status = acpi_get_handle(handle, "_EJ0", &tmphandle);
-	if (ACPI_FAILURE(status))
-		/* This device does not support hotplug */
-		return;
-
-	if (event == ACPI_NOTIFY_BUS_CHECK ||
-	    event == ACPI_NOTIFY_DEVICE_CHECK)
-		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
 
 	spin_lock_irqsave(ap->lock, flags);
-
+	/*
+	 * When dock driver calls into the routine, it will always use
+	 * ACPI_NOTIFY_BUS_CHECK/ACPI_NOTIFY_DEVICE_CHECK for add and
+	 * ACPI_NOTIFY_EJECT_REQUEST for remove
+	 */
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
 
-		if (ACPI_FAILURE(status)) {
-			ata_port_printk(ap, KERN_ERR,
-				"acpi: failed to determine bay status (0x%x)\n",
-				status);
-			break;
-		}
-
-		if (sta) {
-			ata_ehi_hotplugged(ehi);
-			ata_port_freeze(ap);
-		} else {
-			/* The device has gone - unplug it */
-			ata_acpi_detach_device(ap, dev);
-			wait = 1;
-		}
+		ata_ehi_hotplugged(ehi);
+		ata_port_freeze(ap);
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		ata_ehi_push_desc(ehi, "ACPI event");
 
-		if (!is_dock_event)
-			break;
-
-		/* undock event - immediate unplug */
 		ata_acpi_detach_device(ap, dev);
 		wait = 1;
 		break;
 	}
 
-	/* make sure kobj doesn't go away while ap->lock is released */
-	kobject_get(kobj);
-
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait) {
+	if (wait)
 		ata_port_wait_eh(ap);
-		ata_acpi_eject_device(handle);
-	}
-
-	if (kobj && !is_dock_event) {
-		sprintf(event_string, "BAY_EVENT=%d", event);
-		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
-	}
-
-	kobject_put(kobj);
 }
 
 static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
 
-	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 1);
+	ata_acpi_handle_hotplug(dev->link->ap, dev, event);
 }
 
 static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, NULL, event, 1);
-}
-
-static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
-{
-	struct ata_device *dev = data;
-
-	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 0);
-}
-
-static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
-{
-	struct ata_port *ap = data;
-
-	ata_acpi_handle_hotplug(ap, NULL, event, 0);
+	ata_acpi_handle_hotplug(ap, NULL, event);
 }
 
 /**
@@ -315,9 +242,6 @@ void ata_acpi_associate(struct ata_host *host)
 			ata_acpi_associate_ide_port(ap);
 
 		if (ap->acpi_handle) {
-			acpi_install_notify_handler(ap->acpi_handle,
-						    ACPI_SYSTEM_NOTIFY,
-						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
 					     ata_acpi_ap_notify_dock, ap);
@@ -327,9 +251,6 @@ void ata_acpi_associate(struct ata_host *host)
 			struct ata_device *dev = &ap->link.device[j];
 
 			if (dev->acpi_handle) {
-				acpi_install_notify_handler(dev->acpi_handle,
-						ACPI_SYSTEM_NOTIFY,
-						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
 					     ata_acpi_dev_notify_dock, dev);
-- 
1.5.5.1

