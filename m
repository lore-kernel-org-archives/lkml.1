Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYBWXb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYBWXb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbYBWX3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:29:15 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1175 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758442AbYBWX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:29:12 -0500
Date: Sat, 23 Feb 2008 18:29:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802232116.54188.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802231805120.20022-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:

> Ultimately no, it's not.  However, we are now late in the -rc2 time frame and
> the release of -rc3 seems to be imminent.  At this point, IMO, that's the
> safest thing to do.  BTW, appended is the patch I'd like to get applied.

In the interest of having a safe release, I guess you're right.  It's 
unfortunate, though -- there's no good way to get thorough testing 
without putting the code in Linus's tree.

> > How would we then learn about drivers trying to register or unregister a
> > device during a sleep transition?
> 
> I think we should fix the ones we know about and try to reintroduce this
> change in the 2.6.26 time frame.  It also seems reasonable to reconsider what
> we want to achieve, as there may be a better way to do that.

Below is my suggested approach, based on yours.  It might even solve
the MMC problem, who knows?  And it adds some potentially useful
debugging, although it would be better to dump just the stack of
suspending_task.  Do you know how to do that from within a timer
routine?

I still have no clear idea about what's going on with the ACPI bug in 
#9874.  However perhaps the bug wouldn't occur if we blocked device 
registration until after the resume was finished, instead of failing it 
outright.  Since the registration in this case was done in a workqueue 
thread, blocking wouldn't cause an immediate deadlock.

Alan Stern



Index: usb-2.6/drivers/base/power/main.c
===================================================================
--- usb-2.6.orig/drivers/base/power/main.c
+++ usb-2.6/drivers/base/power/main.c
@@ -25,6 +25,7 @@
 #include <linux/pm.h>
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
+#include <linux/sched.h>
 
 #include "../base.h"
 #include "power.h"
@@ -59,6 +60,13 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
+static struct task_struct *suspending_task;
+
+bool in_suspend_context(void)
+{
+	return (suspending_task == current);
+}
+
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
@@ -94,14 +102,15 @@ void device_pm_remove(struct device *dev
 			/* No suspend in progress, wait on dev->sem */
 			down(&dev->sem);
 			up_read(&pm_sleep_rwsem);
-		} else {
-			/* Suspend in progress, we may deadlock */
+		} else if (!in_suspend_context()) {
+			/* Suspending in another task, we may deadlock */
 			dev_warn(dev, "Suspicious %s during suspend\n",
 				__FUNCTION__);
 			dump_stack();
 			/* The user has been warned ... */
 			down(&dev->sem);
 		}
+			/* Otherwise we're okay */
 	}
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
@@ -272,6 +281,7 @@ static void dpm_resume(void)
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	suspending_task = NULL;
 }
 
 /**
@@ -410,6 +420,17 @@ int device_power_down(pm_message_t state
 }
 EXPORT_SYMBOL_GPL(device_power_down);
 
+/* Provide debugging info if we hang or deadlock during suspend */
+static struct timer_list suspend_timer;
+
+static void suspend_timeout(unsigned long _dev)
+{
+	struct device *dev = (struct device *) _dev;
+
+	dev_err(dev, "deadlock during suspend!\n");
+	show_state();
+}
+
 /**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
@@ -419,6 +440,10 @@ int suspend_device(struct device *dev, p
 {
 	int error = 0;
 
+	/* Provide debugging output in case of a deadlock */
+	setup_timer(&suspend_timer, suspend_timeout, (unsigned long) dev);
+	mod_timer(&suspend_timer, jiffies + 5*HZ);
+
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -441,6 +466,8 @@ int suspend_device(struct device *dev, p
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
+
+	del_timer_sync(&suspend_timer);
 	return error;
 }
 
@@ -460,6 +487,7 @@ static int dpm_suspend(pm_message_t stat
 {
 	int error = 0;
 
+	suspending_task = current;
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_locked)) {
 		struct list_head *entry = dpm_locked.prev;
Index: usb-2.6/drivers/base/power/power.h
===================================================================
--- usb-2.6.orig/drivers/base/power/power.h
+++ usb-2.6/drivers/base/power/power.h
@@ -11,6 +11,7 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
+extern bool in_suspend_context(void);
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern int pm_sleep_lock(void);
@@ -18,6 +19,10 @@ extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
+static inline bool in_suspend_context(void)
+{
+	return false;
+}
 
 static inline void device_pm_add(struct device *dev)
 {
Index: usb-2.6/drivers/base/dd.c
===================================================================
--- usb-2.6.orig/drivers/base/dd.c
+++ usb-2.6/drivers/base/dd.c
@@ -325,10 +325,18 @@ void device_release_driver(struct device
 	 * If anyone calls device_release_driver() recursively from
 	 * within their ->remove callback for the same device, they
 	 * will deadlock right here.
+	 *
+	 * We avoid locking dev->sem if we are in the context of a
+	 * task doing a system suspend, in order that drivers can
+	 * unregister devices from within their suspend() methods.
+	 * This is okay because the suspending task will already own
+	 * all the device semaphores.
 	 */
-	down(&dev->sem);
+	if (!in_suspend_context())
+		down(&dev->sem);
 	__device_release_driver(dev);
-	up(&dev->sem);
+	if (!in_suspend_context())
+		up(&dev->sem);
 }
 EXPORT_SYMBOL_GPL(device_release_driver);
 

