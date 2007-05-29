Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXE2VUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXE2VUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXE2VTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:19:54 -0400
Received: from rtr.ca ([64.26.128.89]:3582 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbXE2VTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:19:53 -0400
Message-ID: <465C98F6.10806@rtr.ca>
Date: Tue, 29 May 2007 17:19:50 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [PATCH] USB: replace flush_workqueue with cancel_sync_work
References: <Pine.LNX.4.44L0.0705291628230.2974-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705291628230.2974-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again, Alan!

From: Alan Stern <stern@rowland.harvard.edu>
>
>This patch (as912) replaces a couple of calls to flush_workqueue()
>with cancel_sync_work() and cancel_rearming_delayed_work().  Using a
>more directed approach allows us to avoid some nasty deadlocks.  The
>prime example occurs when a first-level device (the parent is a root
>hub) is removed while at the same time the root hub gets a remote
>wakeup request.  khubd would try to flush the autosuspend workqueue
>while holding the root-hub's lock, and the remote-wakeup workqueue
>routine would be waiting to lock the root hub.
>
>The patch also reorganizes the power management portion of
>usb_disconnect(), separating it out into its own routine.  The
>autosuspend workqueue entry is cancelled immediately instead of
>waiting for the device's release routine.  In addition,
>synchronization with the autosuspend thread is carried out even for
>root hubs (an oversight in the original code).
>
>Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Mark Lord <mlord@pobox.com>

---

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

-
