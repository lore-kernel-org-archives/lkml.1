Return-Path: <linux-kernel-owner+w=401wt.eu-S934138AbZLFUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbZLFUgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZLFUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:36:37 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48235 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757539AbZLFUgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:36:37 -0500
Date: Sun, 6 Dec 2009 15:36:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <20091206113555.5a646713@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0912061534120.7903-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Arjan van de Ven wrote:

> btw I instrumented both the suspend and resume, and made graphs out of
> it for my laptop (modern laptop with Intel cpu/wifi/graphics of course).
> 
> http://www.fenrus.org/graphs/suspend.svg
> http://www.fenrus.org/graphs/resume.svg
> 
> (also attached for convenience)
> 
> the resume clearly shows that all this talking about PCI stuff is
> completely without practical merit.. it's the USB stuff where the time
> is spent.

Arjan, can you try testing the USB timings again with the patch below 
(for vanilla 2.6.32)?

Fair warning: I just composed this and haven't tried it out myself.

Thanks,

Alan Stern



Index: 2.6.32/drivers/usb/core/driver.c
===================================================================
--- 2.6.32.orig/drivers/usb/core/driver.c
+++ 2.6.32/drivers/usb/core/driver.c
@@ -1313,8 +1313,9 @@ static int usb_resume_both(struct usb_de
 			 * then we're stuck. */
 			status = usb_resume_device(udev, msg);
 		}
-	} else if (udev->reset_resume)
+	} else {
 		status = usb_resume_device(udev, msg);
+	}
 
 	if (status == 0 && udev->actconfig) {
 		for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
Index: 2.6.32/drivers/usb/core/hub.c
===================================================================
--- 2.6.32.orig/drivers/usb/core/hub.c
+++ 2.6.32/drivers/usb/core/hub.c
@@ -1674,7 +1674,7 @@ static int usb_configure_device_otg(stru
 		 * (Includes HNP test device.)
 		 */
 		if (udev->bus->b_hnp_enable || udev->bus->is_b_host) {
-			err = usb_port_suspend(udev, PMSG_SUSPEND);
+			err = usb_port_suspend(udev, PMSG_AUTO_SUSPEND);
 			if (err < 0)
 				dev_dbg(&udev->dev, "HNP fail, %d\n", err);
 		}
@@ -2060,6 +2060,7 @@ static int check_port_resume_type(struct
 /*
  * usb_port_suspend - suspend a usb device's upstream port
  * @udev: device that's no longer in active use, not a root hub
+ * @msg: Power Management message describing this state transition
  * Context: must be able to sleep; device not locked; pm locks held
  *
  * Suspends a USB device that isn't in active use, conserving power.
@@ -2107,7 +2108,7 @@ int usb_port_suspend(struct usb_device *
 {
 	struct usb_hub	*hub = hdev_to_hub(udev->parent);
 	int		port1 = udev->portnum;
-	int		status;
+	int		status = 0;
 
 	// dev_dbg(hub->intfdev, "suspend port %d\n", port1);
 
@@ -2128,6 +2129,13 @@ int usb_port_suspend(struct usb_device *
 					status);
 	}
 
+	/* For system sleep transitions we don't actually need to suspend
+	 * the port.  The device will suspend itself when the entire bus
+	 * is suspended.
+	 */
+	if (!(msg.event & (PM_EVENT_USER | PM_EVENT_REMOTE | PM_EVENT_AUTO)))
+		return status;
+
 	/* see 7.1.7.6 */
 	status = set_port_feature(hub->hdev, port1, USB_PORT_FEAT_SUSPEND);
 	if (status) {
@@ -2231,6 +2239,7 @@ static int finish_port_resume(struct usb
 /*
  * usb_port_resume - re-activate a suspended usb device's upstream port
  * @udev: device to re-activate, not a root hub
+ * @msg: Power Management message describing this state transition
  * Context: must be able to sleep; device not locked; pm locks held
  *
  * This will re-activate the suspended device, increasing power usage

