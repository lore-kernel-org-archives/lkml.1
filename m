Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbYCKXy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbYCKXy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYCKXyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:54:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:33096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYCKXyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:54:17 -0400
Date: Wed, 12 Mar 2008 00:55:49 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080311235548.GA4089@homac>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de> <47C6804A.50705@gmail.com> <20080228110927.GA5745@homac.suse.de> <47C6B1B1.2040602@gmail.com> <20080228155817.GB5593@homac.suse.de> <20080228183243.GA6146@homac.suse.de> <20080228233610.GA3808@homac> <47CCCC46.6070908@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <47CCCC46.6070908@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 04. Mar - 13:12:54, Tejun Heo wrote:
> Holger Macht wrote:
> > On Thu 28. Feb - 19:32:43, Holger Macht wrote:
> >> On Thu 28. Feb - 16:58:17, Holger Macht wrote:
> >>> On Thu 28. Feb - 22:05:53, Tejun Heo wrote:
> >>>> Holger Macht wrote:
> >>>>> On Thu 28. Feb - 18:35:06, Tejun Heo wrote:
> >>>>>> Holger Macht wrote:
> >>>>>>> The hotplug handler is only called if the device is actually inside the
> >>>>>>> dock station. If it is not, nothing will happen. I hope that I got your
> >>>>>>> question right?
> >>>>>> Yes, right.
> >>>>>>
> >>>>>>> However, if this would be helpful, it would be easy to add something like
> >>>>>>> a am_I_on_dock_station?(...) function to the dock driver.
> >>>>>> Hmm.. as long as the event is only delivered when the device is actually
> >>>>>> connected behind dock, I think it's okay.
> >>>>> The dock driver also export a is_dock_device(acpi_handle) function, which
> >>>>> could be used to make more fine-grained decisions, but it shouldn't be
> >>>>> needed here.
> >>>>>
> >>>>>> Does the attached patch fix the previous undock problem?  It now
> >>>>>> explicitly tells libata EH to detach the notified devices on
> >>>>>> EJECT_REQUEST and wait for EH to complete such that control is returned
> >>>>>> to ACPI after all notified devices are actually detached.
> >>>>> No it does not. Apparently, it freezes faster (from 1 second down to
> >>>>> immediately). Before, it just froze when someone (in this case HAL) tried
> >>>>> to access the device. The "echo 1 > undock" call does not even return, so
> >>>>> it might have introduced another problem.
> >>>> The code should be in generally right direction.  Can you be persuaded
> >>>> into tracking down what's going on?
> >>> I had a quick glance with adding some printk's. Now I got a different
> >>> behaviour once. System did not freeze, but were certainly confused. The
> >>> last thing which got printed to messages was exactly before
> >>> spin_lock_irqsave(ap->lock, flags); at the beginning of ata_acpi_handle_hotplug(...)
> >>>
> >>> The printk immediately after this call didn't come through anymore (with
> >>> being able to use the system for a short time afterwards).
> >> Ok, it seems that there is something broken somewhere else in
> >> 2.6.25.rc3. Not sure at all if it's your patch freezing the machine. I'll
> >> give 2.6.24.3 a try...
> > 
> > So once again...
> > 
> > After applying your patch, I got the OOPS seen in attachment
> > 'oops-undock-1'. After changing the following, which is hopefully
> > correct...
> > 
> > --- ../orig/linux-2.6.24.3/drivers/ata/libata-acpi.c	2008-02-29 00:31:44.000000000 +0100
> > +++ drivers/ata/libata-acpi.c	2008-02-29 00:32:26.000000000 +0100
> > @@ -123,7 +123,7 @@
> >  {
> >  	char event_string[12];
> >  	char *envp[] = { event_string, NULL };
> > -	struct ata_eh_info *ehi = &ap->link.eh_info;
> > +	struct ata_eh_info *ehi;
> >  	struct kobject *kobj = NULL;
> >  	int wait = 0;
> >  	unsigned long flags;
> > @@ -131,6 +131,8 @@
> >  	if (!ap)
> >  		ap = dev->link->ap;
> >  
> > +	ehi = &ap->link.eh_info;
> > +
> >  	spin_lock_irqsave(ap->lock, flags);
> >  
> >  	switch (event) {
> > 
> > 
> > ...I got both an oops when docking (attachments oops-dock) and when undocking
> > (attachment oops-undock2).
> 
> Yeah, that was one mistake.  There's another.
> 
> +#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
> +				/* we might be on a docking station */
> +				register_hotplug_dock_device(ap->acpi_handle,
> +							     ata_acpi_dev_notify,
> +							     ap);
> +#endif
> 
> dev_notify is being registered with a pointer to ap.  No wonder it causes

It seems this change is missing from your patch. I've attached a fixed
version...

> strange dereferences later on.  Attached is the fixed patch.  Can you
> please give it a shot?

...and now the good news...the new patch works flawlessly with
2.6.25-rc5...

undocking...
ata5.00: disabled
ata5.00: detaching (SCSI 4:0:0:0)
ACPI: \_SB_.GDCK - undocking
usb 1-6: USB disconnect, address 5

docking...
ACPI: \_SB_.GDCK - docking
ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xa frozen
ata5: ACPI event
ata5: soft resetting link
ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-4083N, 1.08, max UDMA/33
ata5.00: configured for UDMA/33
ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x1 t4
ata5: ACPI event
ata5: soft resetting link
ata5.00: configured for UDMA/33
ata5: EH complete
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4083N 1.08 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5

Thanks,
	Holger

--2B/JsCI69OhZNC5r
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="libata-add-hotplug-support.patch"

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9e8ec19..ea01875 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,45 +118,77 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 				    u32 event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-
-	if (event == 0 || event == 1) {
-	       unsigned long flags;
-	       spin_lock_irqsave(ap->lock, flags);
-	       ata_ehi_clear_desc(ehi);
-	       ata_ehi_push_desc(ehi, "ACPI event");
-	       ata_ehi_hotplugged(ehi);
-	       ata_port_freeze(ap);
-	       spin_unlock_irqrestore(ap->lock, flags);
+	struct ata_eh_info *ehi;
+	struct kobject *kobj = NULL;
+	int wait = 0;
+	unsigned long flags;
+
+	if (!ap)
+		ap = dev->link->ap;
+	ehi = &ap->link.eh_info;
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
+
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
 
-	if (dev->sdev)
-		kobj = &dev->sdev->sdev_gendev.kobj;
-
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
@@ -191,20 +223,30 @@ void ata_acpi_associate(struct ata_host *host)
 		else
 			ata_acpi_associate_ide_port(ap);
 
-		if (ap->acpi_handle)
-			acpi_install_notify_handler (ap->acpi_handle,
-						     ACPI_SYSTEM_NOTIFY,
-						     ata_acpi_ap_notify,
-						     ap);
+		if (ap->acpi_handle) {
+			acpi_install_notify_handler(ap->acpi_handle,
+						    ACPI_SYSTEM_NOTIFY,
+						    ata_acpi_ap_notify, ap);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+			/* we might be on a docking station */
+			register_hotplug_dock_device(ap->acpi_handle,
+						     ata_acpi_ap_notify, ap);
+#endif
+		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
 			struct ata_device *dev = &ap->link.device[j];
 
-			if (dev->acpi_handle)
-				acpi_install_notify_handler (dev->acpi_handle,
-							     ACPI_SYSTEM_NOTIFY,
-							     ata_acpi_dev_notify,
-							     dev);
+			if (dev->acpi_handle) {
+				acpi_install_notify_handler(dev->acpi_handle,
+						ACPI_SYSTEM_NOTIFY,
+						ata_acpi_dev_notify, dev);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+				/* we might be on a docking station */
+				register_hotplug_dock_device(dev->acpi_handle,
+						ata_acpi_dev_notify, dev);
+#endif
+			}
 		}
 	}
 }

--2B/JsCI69OhZNC5r--
