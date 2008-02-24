Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYBXNem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYBXNem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYBXNea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:34:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYBXNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:34:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sun, 24 Feb 2008 14:33:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241433.20755.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Alan Stern wrote:
> On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
> 
> > On Sunday, 24 of February 2008, Alan Stern wrote:
> > > On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> > > 
> > > > Ultimately no, it's not.  However, we are now late in the -rc2 time frame and
> > > > the release of -rc3 seems to be imminent.  At this point, IMO, that's the
> > > > safest thing to do.  BTW, appended is the patch I'd like to get applied.
> > > 
> > > In the interest of having a safe release, I guess you're right.
> > 
> > That's what I'm concerned about at the moment.  I'm afraid there won't be
> > enough time to nail down all the issues (there may be some we're not even
> > aware of).
> 
> All right.  You'll need to enlarge your big reversal patch by reverting 
> commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f.

Thanks for the hint.

In fact, I had to add a couple of fixes in device_power_down() and
dpm_suspend().  The entire patch is appended.

I'll comment your new patch in a separate message.

Thanks,
Rafael

---
 drivers/base/power/main.c |   97 +++-------------------------------------------
 drivers/usb/core/usb.c    |    2 
 2 files changed, 8 insertions(+), 91 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -48,7 +48,6 @@
  */
 
 LIST_HEAD(dpm_active);
-static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
 static LIST_HEAD(dpm_destroy);
@@ -81,28 +80,6 @@ void device_pm_add(struct device *dev)
  */
 void device_pm_remove(struct device *dev)
 {
-	/*
-	 * If this function is called during a suspend, it will be blocked,
-	 * because we're holding the device's semaphore at that time, which may
-	 * lead to a deadlock.  In that case we want to print a warning.
-	 * However, it may also be called by unregister_dropped_devices() with
-	 * the device's semaphore released, in which case the warning should
-	 * not be printed.
-	 */
-	if (down_trylock(&dev->sem)) {
-		if (down_read_trylock(&pm_sleep_rwsem)) {
-			/* No suspend in progress, wait on dev->sem */
-			down(&dev->sem);
-			up_read(&pm_sleep_rwsem);
-		} else {
-			/* Suspend in progress, we may deadlock */
-			dev_warn(dev, "Suspicious %s during suspend\n",
-				__FUNCTION__);
-			dump_stack();
-			/* The user has been warned ... */
-			down(&dev->sem);
-		}
-	}
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -110,7 +87,6 @@ void device_pm_remove(struct device *dev
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	up(&dev->sem);
 }
 
 /**
@@ -266,7 +242,7 @@ static void dpm_resume(void)
 		struct list_head *entry = dpm_off.next;
 		struct device *dev = to_device(entry);
 
-		list_move_tail(entry, &dpm_locked);
+		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
@@ -275,25 +251,6 @@ static void dpm_resume(void)
 }
 
 /**
- *	unlock_all_devices - Release each device's semaphore
- *
- *	Go through the dpm_off list.  Put each device on the dpm_active
- *	list and unlock it.
- */
-static void unlock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
-		struct device *dev = to_device(entry);
-
-		list_move(entry, &dpm_active);
-		up(&dev->sem);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	unregister_dropped_devices - Unregister devices scheduled for removal
  *
  *	Unregister all devices on the dpm_destroy list.
@@ -305,7 +262,6 @@ static void unregister_dropped_devices(v
 		struct list_head *entry = dpm_destroy.next;
 		struct device *dev = to_device(entry);
 
-		up(&dev->sem);
 		mutex_unlock(&dpm_list_mtx);
 		/* This also removes the device from the list */
 		device_unregister(dev);
@@ -324,7 +280,6 @@ void device_resume(void)
 {
 	might_sleep();
 	dpm_resume();
-	unlock_all_devices();
 	unregister_dropped_devices();
 	up_write(&pm_sleep_rwsem);
 }
@@ -388,18 +343,15 @@ int device_power_down(pm_message_t state
 		struct list_head *entry = dpm_off.prev;
 		struct device *dev = to_device(entry);
 
-		list_del_init(&dev->power.entry);
 		error = suspend_device_late(dev, state);
 		if (error) {
 			printk(KERN_ERR "Could not power down device %s: "
 					"error %d\n",
 					kobject_name(&dev->kobj), error);
-			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_off);
 			break;
 		}
-		if (list_empty(&dev->power.entry))
-			list_add(&dev->power.entry, &dpm_off_irq);
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off_irq);
 	}
 
 	if (!error)
@@ -461,11 +413,10 @@ static int dpm_suspend(pm_message_t stat
 	int error = 0;
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry = dpm_active.prev;
 		struct device *dev = to_device(entry);
 
-		list_del_init(&dev->power.entry);
 		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		if (error) {
@@ -476,14 +427,11 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
-			mutex_lock(&dpm_list_mtx);
-			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_locked);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);
-		if (list_empty(&dev->power.entry))
-			list_add(&dev->power.entry, &dpm_off);
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off);
 	}
 	mutex_unlock(&dpm_list_mtx);
 
@@ -491,36 +439,6 @@ static int dpm_suspend(pm_message_t stat
 }
 
 /**
- *	lock_all_devices - Acquire every device's semaphore
- *
- *	Go through the dpm_active list. Carefully lock each device's
- *	semaphore and put it in on the dpm_locked list.
- */
-static void lock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active)) {
-		struct list_head *entry = dpm_active.next;
-		struct device *dev = to_device(entry);
-
-		/* Required locking order is dev->sem first,
-		 * then dpm_list_mutex.  Hence this awkward code.
-		 */
-		get_device(dev);
-		mutex_unlock(&dpm_list_mtx);
-		down(&dev->sem);
-		mutex_lock(&dpm_list_mtx);
-
-		if (list_empty(entry))
-			up(&dev->sem);		/* Device was removed */
-		else
-			list_move_tail(entry, &dpm_locked);
-		put_device(dev);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	device_suspend - Save state and stop all devices in system.
  *	@state: new power management state
  *
@@ -533,7 +451,6 @@ int device_suspend(pm_message_t state)
 
 	might_sleep();
 	down_write(&pm_sleep_rwsem);
-	lock_all_devices();
 	error = dpm_suspend(state);
 	if (error)
 		device_resume();
Index: linux-2.6/drivers/usb/core/usb.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/usb.c
+++ linux-2.6/drivers/usb/core/usb.c
@@ -234,7 +234,7 @@ static int ksuspend_usb_init(void)
 	 * singlethreaded.  Its job doesn't justify running on more
 	 * than one CPU.
 	 */
-	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
+	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
 	if (!ksuspend_usb_wq)
 		return -ENOMEM;
 	return 0;
