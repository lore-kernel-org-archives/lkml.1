Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbXEWSli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbXEWSli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXEWSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:41:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49110 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755898AbXEWSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:41:30 -0400
Date: Wed, 23 May 2007 14:41:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070523162125.GA321@tv-sign.ru>
Message-ID: <Pine.LNX.4.44L0.0705231439530.3673-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Oleg Nesterov wrote:

> On 05/23, Alan Stern wrote:
> >
> > Okay, it's clear that the two threads are in deadlock.  It's not clear 
> > how the deadlock arose to begin with -- apparently there was a remote 
> > wakeup request for a root hub at the same time as a device below that 
> > root hub was disconnected, which doesn't make much sense.
> 
> Please note that this flush_workqueue() was not safe anyway. We are freezing
> tasks, and ksuspend_usb_wq is freezeable. So, it could be frozen before
> "khubd" task, and we have another deadlock.

Correct.  I was planning to replace the flush_workqueue() anyway for 
that very reason; this is a good excuse to do it.

> > Anyway, this looks like a good place to use cancel_work_sync().  The
> 
> Could you use cancel_rearming_delayed_work() ? (It should be renamed to
> cancel_delayed_work_sync()).

Good idea.  Here's a revised patch.

Alan Stern


Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -1228,6 +1228,30 @@ static void release_address(struct usb_d
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
@@ -1294,14 +1318,7 @@ void usb_disconnect(struct usb_device **
 	*pdev = NULL;
 	spin_unlock_irq(&device_state_lock);
 
-	/* Synchronize with the ksuspend thread to prevent any more
-	 * autosuspend requests from being submitted, and decrement
-	 * the parent's count of unsuspended children.
-	 */
-	usb_pm_lock(udev);
-	if (udev->parent && !udev->discon_suspended)
-		usb_autosuspend_device(udev->parent);
-	usb_pm_unlock(udev);
+	usb_stop_pm(udev);
 
 	put_device(&udev->dev);
 }
Index: usb-2.6/drivers/usb/core/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/usb.c
+++ usb-2.6/drivers/usb/core/usb.c
@@ -184,10 +184,6 @@ static void usb_release_dev(struct devic
 
 	udev = to_usb_device(dev);
 
-#ifdef	CONFIG_USB_SUSPEND
-	cancel_delayed_work(&udev->autosuspend);
-	flush_workqueue(ksuspend_usb_wq);
-#endif
 	usb_destroy_configuration(udev);
 	usb_put_hcd(bus_to_hcd(udev->bus));
 	kfree(udev->product);
Index: usb-2.6/drivers/usb/core/hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hcd.c
+++ usb-2.6/drivers/usb/core/hcd.c
@@ -1683,7 +1683,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	spin_unlock_irq (&hcd_root_hub_lock);
 
 #ifdef CONFIG_PM
-	flush_workqueue(ksuspend_usb_wq);
+	cancel_work_sync(&hcd->wakeup_work);
 #endif
 
 	mutex_lock(&usb_bus_list_lock);

