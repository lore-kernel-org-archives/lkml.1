Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbXE2Ufp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbXE2Ufp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932475AbXE2Ue5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:34:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49133 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932460AbXE2Uez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:34:55 -0400
Date: Tue, 29 May 2007 16:34:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: [PATCH] USB: replace flush_workqueue with cancel_sync_work
In-Reply-To: <alpine.LFD.0.98.0705291221480.26602@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0705291628230.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as912) replaces a couple of calls to flush_workqueue()
with cancel_sync_work() and cancel_rearming_delayed_work().  Using a
more directed approach allows us to avoid some nasty deadlocks.  The
prime example occurs when a first-level device (the parent is a root
hub) is removed while at the same time the root hub gets a remote
wakeup request.  khubd would try to flush the autosuspend workqueue
while holding the root-hub's lock, and the remote-wakeup workqueue
routine would be waiting to lock the root hub.

The patch also reorganizes the power management portion of
usb_disconnect(), separating it out into its own routine.  The
autosuspend workqueue entry is cancelled immediately instead of
waiting for the device's release routine.  In addition,
synchronization with the autosuspend thread is carried out even for
root hubs (an oversight in the original code).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---


On Tue, 29 May 2007, Linus Torvalds wrote:

> Ok, let's merge the fix them. Alan, can you send it up-stream with the 
> proper commit message and sign-off?

Here it is.  This will apply to 2.6.22-rc3.  I'll let you duke it out 
with Greg and Andrew to see who wants to apply it where.  :-)

Alan Stern


Index: 2.6.22-rc3/drivers/usb/core/hub.c
===================================================================
--- 2.6.22-rc3.orig/drivers/usb/core/hub.c
+++ 2.6.22-rc3/drivers/usb/core/hub.c
@@ -1158,6 +1158,30 @@ static void release_address(struct usb_d
 	}
 }
 
+#ifdef	CONFIG_USB_SUSPEND
+
+static void usb_stop_pm(struct usb_device *udev)
+{
+	/* Synchronize with the ksuspend thread to prevent any more
+	 * autosuspend requests from being submitted, and decrement
+	 * the parent's count of unsuspended children.
+	 */
+	usb_pm_lock(udev);
+	if (udev->parent && !udev->discon_suspended)
+		usb_autosuspend_device(udev->parent);
+	usb_pm_unlock(udev);
+
+	/* Stop any autosuspend requests already submitted */
+	cancel_rearming_delayed_work(&udev->autosuspend);
+}
+
+#else
+
+static inline void usb_stop_pm(struct usb_device *udev)
+{ }
+
+#endif
+
 /**
  * usb_disconnect - disconnect a device (usbcore-internal)
  * @pdev: pointer to device being disconnected
@@ -1224,13 +1248,7 @@ void usb_disconnect(struct usb_device **
 	*pdev = NULL;
 	spin_unlock_irq(&device_state_lock);
 
-	/* Decrement the parent's count of unsuspended children */
-	if (udev->parent) {
-		usb_pm_lock(udev);
-		if (!udev->discon_suspended)
-			usb_autosuspend_device(udev->parent);
-		usb_pm_unlock(udev);
-	}
+	usb_stop_pm(udev);
 
 	put_device(&udev->dev);
 }
Index: 2.6.22-rc3/drivers/usb/core/usb.c
===================================================================
--- 2.6.22-rc3.orig/drivers/usb/core/usb.c
+++ 2.6.22-rc3/drivers/usb/core/usb.c
@@ -184,10 +184,6 @@ static void usb_release_dev(struct devic
 
 	udev = to_usb_device(dev);
 
-#ifdef	CONFIG_USB_SUSPEND
-	cancel_delayed_work(&udev->autosuspend);
-	flush_workqueue(ksuspend_usb_wq);
-#endif
 	usb_destroy_configuration(udev);
 	usb_put_hcd(bus_to_hcd(udev->bus));
 	kfree(udev->product);
Index: 2.6.22-rc3/drivers/usb/core/hcd.c
===================================================================
--- 2.6.22-rc3.orig/drivers/usb/core/hcd.c
+++ 2.6.22-rc3/drivers/usb/core/hcd.c
@@ -1681,7 +1681,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	spin_unlock_irq (&hcd_root_hub_lock);
 
 #ifdef CONFIG_PM
-	flush_workqueue(ksuspend_usb_wq);
+	cancel_work_sync(&hcd->wakeup_work);
 #endif
 
 	mutex_lock(&usb_bus_list_lock);

