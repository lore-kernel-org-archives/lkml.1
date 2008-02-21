Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbYBUNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbYBUNHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbYBUNGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:06:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43075 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755062AbYBUNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:06:05 -0500
Date: Thu, 21 Feb 2008 14:01:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Greg KH <greg@kroah.com>, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org
Subject: power_state: remove it from usb
Message-ID: <20080221130145.GA3789@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


power_state is scheduled for removal, and it is used only write-only
by USB. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

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


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
