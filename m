Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYB1Jf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYB1Jf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYB1JfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:35:17 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:7664 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYB1JfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:35:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=iqgmi/Lc954N5AanyYpC5XNKB8OZs90POWbNExyiszaWuuKFRUc+uoS/dLFE+az7ts6XaaaGlblKUdR0yRwnjZj9E4zjfCCLsisGjJC3M83YFo15kMCk/LqVnfk74j/+eWrp7DqxqaHBHFuN82cw9pI0QXx40WCLL9FNbKA6YMg=
Message-ID: <47C6804A.50705@gmail.com>
Date: Thu, 28 Feb 2008 18:35:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is	inside
 a dock station
References: <20080214124048.GB9708@homac.suse.de> <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de>
In-Reply-To: <20080226101551.GB10721@homac.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------060804070902010603020600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060804070902010603020600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Holger Macht wrote:
> The hotplug handler is only called if the device is actually inside the
> dock station. If it is not, nothing will happen. I hope that I got your
> question right?

Yes, right.

> However, if this would be helpful, it would be easy to add something like
> a am_I_on_dock_station?(...) function to the dock driver.

Hmm.. as long as the event is only delivered when the device is actually
connected behind dock, I think it's okay.

Does the attached patch fix the previous undock problem?  It now
explicitly tells libata EH to detach the notified devices on
EJECT_REQUEST and wait for EH to complete such that control is returned
to ACPI after all notified devices are actually detached.

Thanks.

-- 
tejun

--------------060804070902010603020600
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9e8ec19..e1bdca1 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,45 +118,76 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 				    u32 event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
 	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct kobject *kobj = NULL;
+	int wait = 0;
+	unsigned long flags;
+
+	if (!ap)
+		ap = dev->link->ap;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	switch (event) {
+	case ACPI_NOTIFY_BUS_CHECK:
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		ata_ehi_push_desc(ehi, "ACPI event");
+		ata_ehi_hotplugged(ehi);
+		ata_port_freeze(ap);
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
+		if (dev)
+			dev->flags |= ATA_DFLAG_DETACH;
+		else {
+			struct ata_link *tlink;
+			struct ata_device *tdev;
+
+			ata_port_for_each_link(tlink, ap)
+				ata_link_for_each_dev(tdev, tlink)
+					tdev->flags |= ATA_DFLAG_DETACH;
+		}
 
-	if (event == 0 || event == 1) {
-	       unsigned long flags;
-	       spin_lock_irqsave(ap->lock, flags);
-	       ata_ehi_clear_desc(ehi);
-	       ata_ehi_push_desc(ehi, "ACPI event");
-	       ata_ehi_hotplugged(ehi);
-	       ata_port_freeze(ap);
-	       spin_unlock_irqrestore(ap->lock, flags);
+		ata_port_schedule_eh(ap);
+		wait = 1;
+		break;
 	}
 
+	if (dev) {
+		if (dev->sdev)
+			kobj = &dev->sdev->sdev_gendev.kobj;
+	} else
+		kobj = &ap->dev->kobj;
+
 	if (kobj) {
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (wait)
+		ata_port_wait_eh(ap);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
-	struct kobject *kobj = NULL;
-
-	if (dev->sdev)
-		kobj = &dev->sdev->sdev_gendev.kobj;
 
-	ata_acpi_handle_hotplug(dev->link->ap, kobj, event);
+	ata_acpi_handle_hotplug(NULL, dev, event);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, &ap->dev->kobj, event);
+	ata_acpi_handle_hotplug(ap, NULL, event);
 }
 
 /**
@@ -191,20 +222,33 @@ void ata_acpi_associate(struct ata_host *host)
 		else
 			ata_acpi_associate_ide_port(ap);
 
-		if (ap->acpi_handle)
+		if (ap->acpi_handle) {
 			acpi_install_notify_handler (ap->acpi_handle,
 						     ACPI_SYSTEM_NOTIFY,
 						     ata_acpi_ap_notify,
 						     ap);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+			/* we might be on a docking station */
+			register_hotplug_dock_device(ap->acpi_handle,
+						     ata_acpi_ap_notify, ap);
+#endif
+		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
 			struct ata_device *dev = &ap->link.device[j];
 
-			if (dev->acpi_handle)
+			if (dev->acpi_handle) {
 				acpi_install_notify_handler (dev->acpi_handle,
 							     ACPI_SYSTEM_NOTIFY,
 							     ata_acpi_dev_notify,
 							     dev);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+				/* we might be on a docking station */
+				register_hotplug_dock_device(ap->acpi_handle,
+							     ata_acpi_dev_notify,
+							     ap);
+#endif
+			}
 		}
 	}
 }

--------------060804070902010603020600--
