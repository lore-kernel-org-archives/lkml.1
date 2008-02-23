Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbYBWUpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbYBWUpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYBWUpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:45:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYBWUpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:45:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julian Blake Kongslie <jblake@omgwallhack.org>
Subject: Re: Hang on suspend
Date: Sat, 23 Feb 2008 21:43:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
In-Reply-To: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232143.31903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Julian Blake Kongslie wrote:
> I'm getting a hang at suspend on 2.6.25-rc2. Booting with
> no_console_suspend let me catch the error, which I photographed and
> transcribed (hopefully without error) below.
> 
> This is a Lenovo Thinkpad T43p.
> 
> I've attached my config and a partial dmesg (this machine generates a
> lot of messages at boot, and overfills the buffer before klogd gets to
> it).

Can you please apply the appened patch and retest?

Thanks,
Rafael

---
 drivers/base/power/main.c |   84 ++--------------------------------------------
 1 file changed, 4 insertions(+), 80 deletions(-)

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
@@ -461,8 +416,8 @@ static int dpm_suspend(pm_message_t stat
 	int error = 0;
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry = dpm_active.prev;
 		struct device *dev = to_device(entry);
 
 		list_del_init(&dev->power.entry);
@@ -478,7 +433,7 @@ static int dpm_suspend(pm_message_t stat
 					""));
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_locked);
+				list_add_tail(&dev->power.entry, &dpm_active);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);
@@ -491,36 +446,6 @@ static int dpm_suspend(pm_message_t stat
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
@@ -533,7 +458,6 @@ int device_suspend(pm_message_t state)
 
 	might_sleep();
 	down_write(&pm_sleep_rwsem);
-	lock_all_devices();
 	error = dpm_suspend(state);
 	if (error)
 		device_resume();
