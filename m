Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYBXD0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYBXD0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYBXDZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:25:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1364 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750746AbYBXDZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:25:49 -0500
Date: Sat, 23 Feb 2008 22:25:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802240119.51935.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> On Sunday, 24 of February 2008, Alan Stern wrote:
> > On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > > Ultimately no, it's not.  However, we are now late in the -rc2 time frame and
> > > the release of -rc3 seems to be imminent.  At this point, IMO, that's the
> > > safest thing to do.  BTW, appended is the patch I'd like to get applied.
> > 
> > In the interest of having a safe release, I guess you're right.
> 
> That's what I'm concerned about at the moment.  I'm afraid there won't be
> enough time to nail down all the issues (there may be some we're not even
> aware of).

All right.  You'll need to enlarge your big reversal patch by reverting 
commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f.

> > Below is my suggested approach, based on yours.  It might even solve
> > the MMC problem, who knows?  And it adds some potentially useful
> > debugging, although it would be better to dump just the stack of
> > suspending_task.  Do you know how to do that from within a timer
> > routine?
> 
> No, I don't.

On further checking the answer turns out to be sched_show_task().  
That's the routine which gets called for each process when you type 
Alt-SysRq-t.

> > I still have no clear idea about what's going on with the ACPI bug in 
> > #9874.
> 
> It seems that the ACPI code is not prepared to cope with a failing device
> registration, in which case it'd need fixing.  Frankly, I'm afraid there may
> be more issues like this throughout the tree.

The fact remains that it is unsafe to register a device during a sleep 
transition, although if the device's driver doesn't have a suspend or 
resume method you can probably get away with it.

> > However perhaps the bug wouldn't occur if we blocked device  
> > registration until after the resume was finished, instead of failing it 
> > outright.  Since the registration in this case was done in a workqueue 
> > thread, blocking wouldn't cause an immediate deadlock.
> 
> No, it wouldn't, but the fact that it happens in the ACPI code makes me worry.

It happened in a workqueue.  There could be lots of similar cases: Some 
interrupt-driven event causes a hotplug action.  Since the action can't 
be carried out in interrupt context, the driver has no choice but to 
defer it to a workqueue or kernel thread.  Blocking that workqueue or 
kernel thread won't cause a problem _unless_ the driver's 
suspend/resume methods try to synchronize with it.  That's the 
difficult case.

> If we block that code and the things it's supposed to do turn out to be
> necessary for suspending later on, we'll be in trouble.

Exactly.

> > @@ -94,14 +102,15 @@ void device_pm_remove(struct device *dev
> >  			/* No suspend in progress, wait on dev->sem */
> >  			down(&dev->sem);
> >  			up_read(&pm_sleep_rwsem);
> > -		} else {
> > -			/* Suspend in progress, we may deadlock */
> > +		} else if (!in_suspend_context()) {
> > +			/* Suspending in another task, we may deadlock */
> 
> Well, that shouldn't really deadlock.  If it does, there is a potential design
> issue somewhere.  I think it might be better to set up a timer in here too.

At this point the driver core owns the device semaphore, so the 
unregistration task will block until the sleep is over.  If the 
driver's resume method has to synchronize with the unregistration task 
then it will deadlock.  I agree, it would be a design issue.  In fact, 
it's the same design issue described earlier in this email.

> Although IMO it would be even better to just set up a timer and remove the
> warning altogehter.

That warning was just for debugging purposes.  A timer in the resume
path could do the same thing with fewer false alarms, just like the 
timer in the suspend path.  I have added it to the new patch.

> >  			dev_warn(dev, "Suspicious %s during suspend\n",
> >  				__FUNCTION__);
> >  			dump_stack();
> >  			/* The user has been warned ... */
> >  			down(&dev->sem);
> >  		}
> > +			/* Otherwise we're okay */
> >  	}
> >  	pr_debug("PM: Removing info for %s:%s\n",
> >  		 dev->bus ? dev->bus->name : "No Bus",
> 
> There's a problem here, because we shouldn't release the semaphore if we're
> in the suspend context.

Yes, you're right.  It's fixed in the new version.

> > +static void suspend_timeout(unsigned long _dev)
> > +{
> > +	struct device *dev = (struct device *) _dev;
> > +
> > +	dev_err(dev, "deadlock during suspend!\n");
> > +	show_state();
> 
> The show_state() seems to be overkill and won't really help if the user can't
> collect the output on the fly using a serial console or something like this.
> [The debug stuff printed here should fit a typical laptop screen, ideally.]

Changed.

> I'd prefer
> 
> 	if (in_suspend_context()) {
> 		__device_release_driver(dev);
> 	} else {
> 		down(&dev->sem);
> 		__device_release_driver(dev);
> 		up(&dev->sem);
> 	}

Okay.

You know, with this new patch we probably don't need 
device_pm_schedule_removal() any more.  However I have left it in for 
now.

> Well, I'd really feel much more comfortable if we removed the troublesome code
> for 2.6.25 and reintroduced it along with the above safeguards for 2.6.26.
> 
> Of course, this doesn't mean we can't send debug patches for testing to the
> users who have alraedy reported problems with it. :-)

Certainly!

Here's the new version.  Zdenek, could you try it out with none of 
Rafael's patches installed?

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
@@ -82,27 +90,14 @@ void device_pm_add(struct device *dev)
 void device_pm_remove(struct device *dev)
 {
 	/*
-	 * If this function is called during a suspend, it will be blocked,
-	 * because we're holding the device's semaphore at that time, which may
-	 * lead to a deadlock.  In that case we want to print a warning.
-	 * However, it may also be called by unregister_dropped_devices() with
-	 * the device's semaphore released, in which case the warning should
-	 * not be printed.
+	 * If this function is called during a sleep then it will block
+	 * because we're holding the device's semaphore at that time;
+	 * this may lead to a deadlock.  But if the calling thread is
+	 * the same as the thread doing the sleep then it already owns
+	 * all the device semaphores, so we make an exception.
 	 */
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
+	if (!in_suspend_context())
+		down(&dev->sem);
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -110,7 +105,8 @@ void device_pm_remove(struct device *dev
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	up(&dev->sem);
+	if (!in_suspend_context())
+		up(&dev->sem);
 }
 
 /**
@@ -157,6 +153,18 @@ void pm_sleep_unlock(void)
 }
 
 
+/* Provide debugging info if we hang or deadlock during suspend/resume */
+static struct timer_list method_timer;
+
+static void method_timeout(unsigned long _dev)
+{
+	struct device *dev = (struct device *) _dev;
+
+	dev_err(dev, "deadlock during suspend or resume!\n");
+	sched_show_task(suspending_task);
+}
+
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -230,6 +238,10 @@ static int resume_device(struct device *
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	/* Provide debugging output in case of a deadlock */
+	setup_timer(&method_timer, method_timeout, (unsigned long) dev);
+	mod_timer(&method_timer, jiffies + 5*HZ);
+
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
 		error = dev->bus->resume(dev);
@@ -245,6 +257,8 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
+	del_timer_sync(&method_timer);
+
 	TRACE_RESUME(error);
 	return error;
 }
@@ -272,6 +286,7 @@ static void dpm_resume(void)
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	suspending_task = NULL;
 }
 
 /**
@@ -419,6 +434,10 @@ int suspend_device(struct device *dev, p
 {
 	int error = 0;
 
+	/* Provide debugging output in case of a deadlock */
+	setup_timer(&method_timer, method_timeout, (unsigned long) dev);
+	mod_timer(&method_timer, jiffies + 5*HZ);
+
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -441,6 +460,8 @@ int suspend_device(struct device *dev, p
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
+
+	del_timer_sync(&method_timer);
 	return error;
 }
 
@@ -460,6 +481,7 @@ static int dpm_suspend(pm_message_t stat
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
@@ -325,10 +325,20 @@ void device_release_driver(struct device
 	 * If anyone calls device_release_driver() recursively from
 	 * within their ->remove callback for the same device, they
 	 * will deadlock right here.
+	 *
+	 * We avoid locking dev->sem if we are in the context of a
+	 * task doing a system sleep, in order that drivers can
+	 * unregister devices from within their suspend() methods.
+	 * This is okay because the suspending task will already own
+	 * all the device semaphores.
 	 */
-	down(&dev->sem);
-	__device_release_driver(dev);
-	up(&dev->sem);
+	if (in_suspend_context()) {
+		__device_release_driver(dev);
+	} else {
+		down(&dev->sem);
+		__device_release_driver(dev);
+		up(&dev->sem);
+	}
 }
 EXPORT_SYMBOL_GPL(device_release_driver);
 

