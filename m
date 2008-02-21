Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYBUNIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYBUNIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYBUNGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:06:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43081 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754750AbYBUNGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:06:06 -0500
Date: Thu, 21 Feb 2008 12:57:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Harvey Harrison <harvey.harrison@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: Feature Removal - power_state
Message-ID: <20080221115729.GA7857@elf.ucw.cz>
References: <1201742999.8837.31.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201742999.8837.31.camel@brick>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi Pavel, is this entry still valid in feature-removal-schedule.txt?

Yes, I'd like to get rid of that.

> What:	dev->power.power_state
> When:	July 2007
> Why:	Broken design for runtime control over driver power states,
> confusing
> 	driver-internal runtime power management with:  mechanisms to support
> 	system-wide sleep state transitions; event codes that distinguish
> 	different phases of swsusp "sleep" transitions; and userspace policy
> 	inputs.  This framework was never widely used, and most attempts to
> 	use it were broken.  Drivers should instead be exposing domain-specific
> 	interfaces either to kernel or to userspace.
> Who:	Pavel Machek <pavel@suse.cz>

...but it is not easy. Most uses are write only (and easy to kill),
but at least radeon driver uses it for real.

This is what I came up with so far:

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b4985bc..a31572d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6542,8 +6542,6 @@ int ata_host_suspend(struct ata_host *ho
 	ata_lpm_enable(host);
 
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
 	return rc;
 }
 
@@ -6562,7 +6560,6 @@ void ata_host_resume(struct ata_host *ho
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
-	host->dev->power.power_state = PMSG_ON;
 
 	/* reenable link pm */
 	ata_lpm_disable(host);
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d180795..268855d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -421,11 +421,6 @@ int suspend_device(struct device *dev, p
 {
 	int error = 0;
 
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 2763394..3816e44 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -895,13 +895,8 @@ #ifdef CONFIG_PM
 
 static int i8042_suspend(struct platform_device *dev, pm_message_t state)
 {
-	if (dev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
-			i8042_controller_reset();
-
-		dev->dev.power.power_state = state;
-	}
-
+	if (state.event == PM_EVENT_SUSPEND)
+		i8042_controller_reset();
 	return 0;
 }
 
@@ -914,12 +909,6 @@ static int i8042_resume(struct platform_
 {
 	int error;
 
-/*
- * Do not bother with restoring state if we haven't suspened yet
- */
-	if (dev->dev.power.power_state.event == PM_EVENT_ON)
-		return 0;
-
 	error = i8042_controller_check();
 	if (error)
 		return error;
@@ -954,9 +943,6 @@ static int i8042_resume(struct platform_
 		i8042_enable_kbd_port();
 
 	i8042_interrupt(0, NULL);
-
-	dev->dev.power.power_state = PMSG_ON;
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 7f52938..0673f3a 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -912,13 +912,8 @@ #endif /* CONFIG_HOTPLUG */
 #ifdef CONFIG_PM
 static int serio_suspend(struct device *dev, pm_message_t state)
 {
-	if (dev->power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
-			serio_cleanup(to_serio_port(dev));
-
-		dev->power.power_state = state;
-	}
-
+	if (state.event == PM_EVENT_SUSPEND)
+		serio_cleanup(to_serio_port(dev));
 	return 0;
 }
 
@@ -926,8 +921,7 @@ static int serio_resume(struct device *d
 {
 	struct serio *serio = to_serio_port(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON &&
-	    serio_reconnect_driver(serio)) {
+	if (serio_reconnect_driver(serio)) {
 		/*
 		 * Driver re-probing can take a while, so better let kseriod
 		 * deal with it.
@@ -935,8 +929,6 @@ static int serio_resume(struct device *d
 		serio_rescan(serio);
 	}
 
-	dev->power.power_state = PMSG_ON;
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 801b6f1..eeb8115 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -794,8 +794,6 @@ static int usb_suspend_device(struct usb
 
  done:
 	dev_vdbg(&udev->dev, "%s: status %d\n", __FUNCTION__, status);
-	if (status == 0)
-		udev->dev.power.power_state.event = msg.event;
 	return status;
 }
 
@@ -826,7 +824,6 @@ static int usb_resume_device(struct usb_
 	dev_vdbg(&udev->dev, "%s: status %d\n", __FUNCTION__, status);
 	if (status == 0) {
 		udev->autoresume_disabled = 0;
-		udev->dev.power.power_state.event = PM_EVENT_ON;
 	}
 	return status;
 }
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 84760dd..739407b 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -73,7 +73,6 @@ int usb_hcd_pci_probe(struct pci_dev *de
 	if (pci_enable_device(dev) < 0)
 		return -ENODEV;
 	dev->current_state = PCI_D0;
-	dev->dev.power.power_state = PMSG_ON;
 
 	if (!dev->irq) {
 		dev_err(&dev->dev,
@@ -302,8 +301,6 @@ int usb_hcd_pci_suspend(struct pci_dev *
 
 done:
 	if (retval == 0) {
-		dev->dev.power.power_state = PMSG_SUSPEND;
-
 #ifdef CONFIG_PPC_PMAC
 		/* Disable ASIC clocks for USB */
 		if (machine_is(powermac)) {
@@ -406,8 +403,6 @@ #endif
 	pci_set_master(dev);
 	pci_restore_state(dev);
 
-	dev->dev.power.power_state = PMSG_ON;
-
 	clear_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
 
 	if (hcd->driver->resume) {
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 2375194..1bf8ccb 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -114,13 +114,11 @@ static inline int is_usb_device_driver(s
 static inline void mark_active(struct usb_interface *f)
 {
 	f->is_active = 1;
-	f->dev.power.power_state.event = PM_EVENT_ON;
 }
 
 static inline void mark_quiesced(struct usb_interface *f)
 {
 	f->is_active = 0;
-	f->dev.power.power_state.event = PM_EVENT_SUSPEND;
 }
 
 static inline int is_active(const struct usb_interface *f)
diff --git a/include/linux/pm.h b/include/linux/pm.h
index ef877fb..46d2306 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -174,7 +174,6 @@ #define PMSG_SUSPEND	((struct pm_message
 #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 
 struct dev_pm_info {
-	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 1a47f5d..81d7f5f 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -231,18 +231,14 @@ static int rfkill_suspend(struct device 
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	if (dev->power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND) {
-			mutex_lock(&rfkill->mutex);
-
-			if (rfkill->state == RFKILL_STATE_ON)
-				rfkill->toggle_radio(rfkill->data,
-						     RFKILL_STATE_OFF);
+	if (state.event == PM_EVENT_SUSPEND) {
+		mutex_lock(&rfkill->mutex);
 
-			mutex_unlock(&rfkill->mutex);
-		}
+		if (rfkill->state == RFKILL_STATE_ON)
+			rfkill->toggle_radio(rfkill->data,
+					     RFKILL_STATE_OFF);
 
-		dev->power.power_state = state;
+		mutex_unlock(&rfkill->mutex);
 	}
 
 	return 0;
@@ -252,16 +248,12 @@ static int rfkill_resume(struct device *
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON) {
-		mutex_lock(&rfkill->mutex);
+	mutex_lock(&rfkill->mutex);
 
-		if (rfkill->state == RFKILL_STATE_ON)
-			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
+	if (rfkill->state == RFKILL_STATE_ON)
+		rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
 
-		mutex_unlock(&rfkill->mutex);
-	}
-
-	dev->power.power_state = PMSG_ON;
+	mutex_unlock(&rfkill->mutex);
 	return 0;
 }
 #else



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
