Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZFTXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZFTXjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZFTXjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:39:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZFTXjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:39:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [patch update 3] PM: Introduce core framework for run-time PM of I/O devices
Date: Sun, 21 Jun 2009 01:38:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906210138.53682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009, Alan Stern wrote:
> On Sat, 20 Jun 2009, Rafael J. Wysocki wrote:
> 
> > I think we can grab a reference when queuing up a resume request and drop
> > it on the completion of it.  This way, suspend will be locked while we're
> > waiting for the resume to run, which I think is what we want.
> 
> But suspend is already blocked from the time a resume request is queued 
> until the resume completes, unless the suspend was underway when the 
> request was made.  So that doesn't seem to make sense.
> 
> This really all depends on how drivers use async autoresume.  Here's 
> one possible way they could be written:
> 
> irq_handler() {
> 	status = pm_request_resume();
> 	if (status indicates the device is currently resumed)
> 		handle_the_IO();
> 	else
> 		save_the_IO();
> }
> 
> runtime_resume_method() {
> 	handle_saved_IO();
> 	pm_request_suspend();	/* Could call pm_notify_idle instead */
> }
> 
> The implications of this design are:
> 
> 	pm_request_resume should return one code if the status already
> 	is RPM_WAKE and a different code if the resume request had to
> 	be queued (or one was already queued).

I did something like this in the patch below.

> 	pm_request_suspend should run very quickly, since it will be
> 	called after every I/O operation.  Likewise, pm_request_resume
> 	should run very quickly if the status is RPM_ACTIVE or 
> 	RPM_IDLE.

Hmm.  pm_request_suspend() is really short, so it should be fast.
pm_request_resume() is a bit more complicated, though (it takes two spinlocks,
increases an atomic counter, possibly twice, and queues up a work item, also
in the RPM_IDLE case).

> 	In order to prevent autosuspends from occurring while I/O is
> 	in progress, the pm_request_resume call should increment the
> 	usage counter (if it had to queue the request) and the 
> 	pm_request_suspend call should decrement it (maybe after
> 	waiting for the delay).

I don't want like pm_request_suspend() to do that, because it's valid to
call it many times in a row. (only the first request will be queued in such a
case).

I'd prefer the caller to do pm_request_resume_get() (please see the patch
below) to put a resume request into the queue and then pm_runtime_put_notify()
when it's done with the I/O.  That will result in ->runtime_idle() being called
automatically if the device may be suspended.

> > OK, I think I'll try to do the counting, although it may be difficult to handle
> > all of the corner cases.
> 
> No, I agree it's not worth worrying about for now.  It can always be 
> added later.

Well, I've done it already, so I'd prefer to keep it, unless it's broken. ;-)

> > > > > There might be some obscure other reason, but in general depth going
> > > > > to 0 means a delayed autosuspend request should be queued.
> > > > 
> > > > OK there, but pm_runtime_disable() is called by the core in some places where
> > > > we'd rather not want the device to be suspended (like during a system-wide
> > > > power transitions).
> > > 
> > > I'm not sure what you mean.  I was talking about pm_runtime_enable
> > > (which decrements depth), not pm_runtime_disable (which increments it).  
> > > When pm_runtime_enable finds that depth has gone to 0, it should queue
> > > a delayed autosuspend request.
> > 
> > OK, but I don't think that queuing a request without notifying the bus type is
> > the right thing to do.  IMO it's better to use ->runtime_idle() in that case
> > (in analogy with the situation in which the last child of a device has been
> > suspended).
> 
> Agreed.
> 
> 
> > > Autosuspend is disallowed if:
> > > 
> > > 	the driver doesn't support autosuspend;
> > > 
> > > 	the usage counter is > 0;
> > > 
> > > 	autosuspend has been disabled for this device;
> > > 
> > > 	the driver requires remote wakeup during autosuspend
> > > 	but the user has disallowed wakeup.
> > 
> > That's probably universal for all bus types and devices.
> 
> Probably.  But you haven't provided a way for the driver to indicate 
> that it requires wakeup.  It's not a big deal, since the 
> runtime_suspend method can do its own checking.
> 
> > > If everything else is okay but not enough time has elapsed since the
> > > device was last used, another delayed autosuspend request is queued and
> > > the current one fails with -EAGAIN.
> > 
> > I wouldn't like to do the automatic queuing at the core level, simply because
> > the core may not have enough information to make a correct decision.
> 
> Calling the notify_idle method would be good enough.
> 
> > > The model for asynchronous operation is that the usage counter remains
> > > always at 0, and the driver updates the time-of-last-use field whenever
> > > an I/O operation starts or completes.  The core keeps a delayed
> > > autosuspend request queued; each time the request runs it checks
> > > whether the device has been idle sufficiently long.  If not it
> > > requeues itself; otherwise it carries out an autosuspend.
> > 
> > Again, I think it's a bus type's decision whether or not to use such a
> > "permanent" suspend request.
> 
> Ironically, this model is different from the one I outlined above.  
> There's more than one way to do this, it's not clear which is best, and 
> AFAIK none of them have been implemented in a real driver yet.
> 
> > I think it probably is a good idea to store the time of last use in 'struct
> > device', so that bus types don't need to duplicate that field (all of them will
> > likely use it).  I'm not sure about the delay, though.  Well, I need some time
> > to think about it. :-)
> 
> All bus types will want to implement _some_ delay; it doesn't make
> sense to power down a device immediately after every operation and then
> power it back up for the next operation.

Sure.  But you can use the pm_request_resume()'s delay to achieve that
without storing the delay in 'struct device'.  It seems.

> But the time scales of the delays may vary widely.  Some devices might 
> be able to power up in a millisecond or less; others will require 
> seconds.  The delays should be set accordingly.

Agreed.

OK

Below is a new patch.  It's been reworked quite a bit since the previous
version I sent and I don't think there's anything I'd like to add to it at this
point, unless something is evidently wrong.

Best,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 2)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  416 ++++++++++++++++++++++++
 drivers/base/dd.c                  |    9 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |    6 
 drivers/base/power/runtime.c       |  617 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   95 +++++
 include/linux/pm_runtime.h         |  148 ++++++++
 kernel/power/Kconfig               |   14 
 kernel/power/main.c                |   17 +
 9 files changed, 1320 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -208,3 +208,17 @@ config APM_EMULATION
 	  random kernel OOPSes or reboots that don't seem to be related to
 	  anything, try disabling/enabling this option (or disabling/enabling
 	  APM in your BIOS).
+
+config PM_RUNTIME
+	bool "Run-time PM core functionality"
+	depends on PM
+	---help---
+	  Enable functionality allowing I/O devices to be put into energy-saving
+	  (low power) states at run time (or autosuspended) after a specified
+	  period of inactivity and woken up in response to a hardware-generated
+	  wake-up event or a driver's request.
+
+	  Hardware support is generally required for this functionality to work
+	  and the bus type drivers of the buses the devices are on are
+	  responsibile for the actual handling of the autosuspend requests and
+	  wake-up events.
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -11,6 +11,7 @@
 #include <linux/kobject.h>
 #include <linux/string.h>
 #include <linux/resume-trace.h>
+#include <linux/workqueue.h>
 
 #include "power.h"
 
@@ -217,8 +218,24 @@ static struct attribute_group attr_group
 	.attrs = g,
 };
 
+#ifdef CONFIG_PM_RUNTIME
+struct workqueue_struct *pm_wq;
+
+static int __init pm_start_workqueue(void)
+{
+	pm_wq = create_freezeable_workqueue("pm");
+
+	return pm_wq ? 0 : -ENOMEM;
+}
+#else
+static inline int pm_start_workqueue(void) { return 0; }
+#endif
+
 static int __init pm_init(void)
 {
+	int error = pm_start_workqueue();
+	if (error)
+		return error;
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -22,6 +22,9 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -165,6 +168,28 @@ typedef struct pm_message {
  * It is allowed to unregister devices while the above callbacks are being
  * executed.  However, it is not allowed to unregister a device from within any
  * of its own callbacks.
+ *
+ * There also are the following callbacks related to run-time power management
+ * of devices:
+ *
+ * @runtime_suspend: Prepare the device for a condition in which it won't be
+ *	able to communicate with the CPU(s) and RAM due to power management.
+ *	This need not mean that the device should be put into a low power state.
+ *	For example, if the device is behind a link which is about to be turned
+ *	off, the device may remain at full power.  Still, if the device does go
+ *	to low power and if device_may_wakeup(dev) is true, remote wake-up
+ *	(i.e. hardware mechanism allowing the device to request a change of its
+ *	power state, such as PCI PME) should be enabled for it.
+ *
+ * @runtime_resume: Put the device into the fully active state in response to a
+ *	wake-up event generated by hardware or at a request of software.  If
+ *	necessary, put the device into the full power state and restore its
+ *	registers, so that it is fully operational.
+ *
+ * @runtime_idle: Device appears to be inactive and it might be put into a low
+ *	power state if all of the necessary conditions are satisfied.  Check
+ *	these conditions and handle the device as appropriate, possibly queueing
+ *	a suspend request for it.
  */
 
 struct dev_pm_ops {
@@ -182,6 +207,9 @@ struct dev_pm_ops {
 	int (*thaw_noirq)(struct device *dev);
 	int (*poweroff_noirq)(struct device *dev);
 	int (*restore_noirq)(struct device *dev);
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+	void (*runtime_idle)(struct device *dev);
 };
 
 /**
@@ -315,14 +343,75 @@ enum dpm_state {
 	DPM_OFF_IRQ,
 };
 
+/**
+ * Device run-time power management state.
+ *
+ * These state labels are used internally by the PM core to indicate the current
+ * status of a device with respect to the PM core operations.  They do not
+ * reflect the actual power state of the device or its status as seen by the
+ * driver.
+ *
+ * RPM_ACTIVE		Device is fully operational, no run-time PM requests are
+ *			pending for it.
+ *
+ * RPM_IDLE		It has been requested that the device be suspended.
+ *			Suspend request has been put into the run-time PM
+ *			workqueue and it's pending execution.
+ *
+ * RPM_SUSPENDING	Device bus type's ->runtime_suspend() callback is being
+ *			executed.
+ *
+ * RPM_SUSPENDED	Device bus type's ->runtime_suspend() callback has
+ *			completed successfully.  The device is regarded as
+ *			suspended.
+ *
+ * RPM_WAKE		It has been requested that the device be woken up.
+ *			Resume request has been put into the run-time PM
+ *			workqueue and it's pending execution.
+ *
+ * RPM_RESUMING		Device bus type's ->runtime_resume() callback is being
+ *			executed.
+ *
+ * RPM_ERROR		Represents a condition from which the PM core cannot
+ *			recover by itself.  If the device's run-time PM status
+ *			field has this value, all of the run-time PM operations
+ *			carried out for the device by the core will fail, until
+ *			the status field is changed to either RPM_ACTIVE or
+ *			RPM_SUSPENDED (it is not valid to use the other values
+ *			in such a situation) by the device's driver or bus type.
+ *			This happens when the device bus type's
+ *			->runtime_suspend() or ->runtime_resume() callback
+ *			returns error code different from -EAGAIN or -EBUSY.
+ */
+
+#define RPM_ACTIVE	0
+#define RPM_IDLE	0x01
+#define RPM_SUSPENDING	0x02
+#define RPM_SUSPENDED	0x04
+#define RPM_WAKE	0x08
+#define RPM_RESUMING	0x10
+#define RPM_ERROR	0x1F
+
 struct dev_pm_info {
 	pm_message_t		power_state;
-	unsigned		can_wakeup:1;
-	unsigned		should_wakeup:1;
+	unsigned int		can_wakeup:1;
+	unsigned int		should_wakeup:1;
 	enum dpm_state		status;		/* Owned by the PM core */
-#ifdef	CONFIG_PM_SLEEP
+#ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
 #endif
+#ifdef CONFIG_PM_RUNTIME
+	struct delayed_work	suspend_work;
+	struct work_struct	resume_work;
+	struct completion	work_done;
+	unsigned int		ignore_children:1;
+	unsigned int		suspend_aborted:1;
+	unsigned int		runtime_status:5;
+	int			runtime_error;
+	atomic_t		resume_count;
+	int			child_count;
+	spinlock_t		lock;
+#endif
 };
 
 /*
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_PM)	+= sysfs.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o
+obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/runtime.c
@@ -0,0 +1,617 @@
+/*
+ * drivers/base/power/runtime.c - Helper functions for device run-time PM
+ *
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/pm_runtime.h>
+#include <linux/jiffies.h>
+
+/**
+ * __pm_get_child - Increment the counter of unsuspended children of a device.
+ * @dev: Device to handle;
+ */
+static void __pm_get_child(struct device *dev)
+{
+	dev->power.child_count++;
+}
+
+/**
+ * __pm_put_child - Decrement the counter of unsuspended children of a device.
+ * @dev: Device to handle;
+ */
+static void __pm_put_child(struct device *dev)
+{
+	if (dev->power.child_count > 0)
+		dev->power.child_count--;
+	else
+		dev_warn(dev, "Excessive %s!\n", __FUNCTION__);
+}
+
+/**
+ * pm_runtime_notify_idle - Run a device bus type's runtime_idle() callback.
+ * @dev: Device to notify.
+ *
+ * Check if all children of given device are suspended and call the device bus
+ * type's ->runtime_idle() callback if that's the case.
+ */
+static void pm_runtime_notify_idle(struct device *dev)
+{
+	if (atomic_read(&dev->power.resume_count) > 0)
+		return;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+}
+
+/**
+ * pm_runtime_put - Decrement the resume counter of a device.
+ * @dev: Device to handle.
+ *
+ * Decrement the resume counter of a device, check if it went down to zero and
+ * notify the device's bus type in that case.
+ */
+void pm_runtime_put_notify(struct device *dev)
+{
+	pm_runtime_put(dev);
+
+	if (pm_children_suspended(dev))
+		pm_runtime_notify_idle(dev);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put_notify);
+
+/**
+ * __pm_runtime_suspend - Run a device bus type's runtime_suspend() callback.
+ * @dev: Device to suspend.
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the status of the device is appropriate and run the
+ * ->runtime_suspend() callback provided by the device's bus type driver.
+ * Update the run-time PM flags in the device object to reflect the current
+ * status of the device.
+ */
+int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	struct device *parent = NULL;
+	unsigned long parflags = 0, flags;
+	int error = -EINVAL;
+
+	might_sleep();
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+ repeat:
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_status & RPM_SUSPENDED) {
+		error = 0;
+		goto out;
+	} else if (atomic_read(&dev->power.resume_count) > 0
+	    || (!sync && dev->power.runtime_status == RPM_IDLE
+	    && dev->power.suspend_aborted)) {
+		/*
+		 * We're forbidden to suspend the device (eg. it may be
+		 * resuming) or a pending suspend request has just been
+		 * cancelled (by a concurrent suspend) and we're running as a
+		 * result of that request.
+		 */
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status & RPM_SUSPENDING) {
+		/*
+		 * Another suspend is running in parallel with us.  Wait for it
+		 * to complete and return.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_error;
+	} else if (sync && dev->power.runtime_status == RPM_IDLE
+	    && !dev->power.suspend_aborted) {
+		/*
+		 * Suspend request is pending, but we're not running as a result
+		 * of that request, so cancel it.  Since we're not clearing the
+		 * RPM_IDLE bit now, no new suspend requests will be queued up
+		 * while the pending one is waited for to finish.
+		 */
+		dev->power.suspend_aborted = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Repeat if anything has changed. */
+		if (dev->power.runtime_status != RPM_IDLE
+		    || !dev->power.suspend_aborted)
+			goto repeat;
+	}
+
+	if (!pm_children_suspended(dev)) {
+		/*
+		 * We can only suspend the device if all of its children have
+		 * been suspended.
+		 */
+		dev->power.runtime_status = RPM_ACTIVE;
+		error = -EBUSY;
+		goto out;
+	}
+
+	dev->power.runtime_status = RPM_SUSPENDING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
+		error = dev->bus->pm->runtime_suspend(dev);
+	parent = dev->parent;
+
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	switch (error) {
+	case 0:
+		/*
+		 * Resume request might have been queued up in the meantime, in
+		 * which case the RPM_WAKE bit is also set in runtime_status.
+		 */
+		dev->power.runtime_status &= ~RPM_SUSPENDING;
+		dev->power.runtime_status |= RPM_SUSPENDED;
+		break;
+	case -EAGAIN:
+	case -EBUSY:
+		dev->power.runtime_status = RPM_ACTIVE;
+		break;
+	default:
+		dev->power.runtime_status = RPM_ERROR;
+	}
+	dev->power.runtime_error = error;
+	complete_all(&dev->power.work_done);
+
+	if (!error && !(dev->power.runtime_status & RPM_WAKE) && parent) {
+		__pm_put_child(parent);
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		if (!parent->power.child_count
+		    && !parent->power.ignore_children)
+			pm_runtime_notify_idle(parent);
+
+		return 0;
+	}
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent)
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_suspend);
+
+/**
+ * pm_runtime_suspend_work - Run pm_runtime_suspend() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the suspend has been scheduled for and
+ * run pm_runtime_suspend() for it.
+ */
+static void pm_runtime_suspend_work(struct work_struct *work)
+{
+	__pm_runtime_suspend(suspend_work_to_device(work), false);
+}
+
+/**
+ * pm_request_suspend - Schedule run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @msec: Time to wait before attempting to suspend the device, in milliseconds.
+ */
+void pm_request_suspend(struct device *dev, unsigned int msec)
+{
+	unsigned long flags;
+	unsigned long delay = msecs_to_jiffies(msec);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status != RPM_ACTIVE
+	    || atomic_read(&dev->power.resume_count) > 0)
+		goto out;
+
+	dev->power.runtime_status = RPM_IDLE;
+	dev->power.suspend_aborted = false;
+	queue_delayed_work(pm_wq, &dev->power.suspend_work, delay);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_request_suspend);
+
+/**
+ * __pm_runtime_resume - Run a device bus type's runtime_resume() callback.
+ * @dev: Device to resume.
+ * @get: If set, increment the device's resume counter.
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the device is really suspended and run the ->runtime_resume()
+ * callback provided by the device's bus type driver.  Update the run-time PM
+ * flags in the device object to reflect the current status of the device.  If
+ * runtime suspend is in progress while this function is being run, wait for it
+ * to finish before resuming the device.  If runtime suspend is scheduled, but
+ * it hasn't started yet, cancel it and we're done.
+ */
+int __pm_runtime_resume(struct device *dev, bool get, bool sync)
+{
+	struct device *parent = dev->parent;
+	unsigned long parflags = 0, flags;
+	bool put_parent = false;
+	unsigned int status;
+	int error = -EINVAL;
+
+	might_sleep();
+
+	/*
+	 * This makes concurrent __pm_runtime_suspend() and pm_request_suspend()
+	 * started after us, or restarted, return immediately, so only the ones
+	 * started before us can execute ->runtime_suspend().
+	 */
+	pm_runtime_get(dev);
+
+ repeat:
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+ repeat_locked:
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_status == RPM_ACTIVE) {
+		error = 0;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_IDLE
+	    && !dev->power.suspend_aborted) {
+		/* Suspend request is pending, so cancel it. */
+		dev->power.suspend_aborted = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		if (parent)
+			spin_lock_irqsave(&parent->power.lock, parflags);
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Repeat if anything has changed. */
+		if (dev->power.runtime_status != RPM_IDLE
+		    || !dev->power.suspend_aborted)
+			goto repeat_locked;
+
+		/*
+		 * Suspend request has been cancelled and there's nothing more
+		 * to do.  Clear the RPM_IDLE bit and return.
+		 */
+		dev->power.runtime_status = RPM_ACTIVE;
+		error = 0;
+		goto out;
+	}
+
+	if (sync && (dev->power.runtime_status & RPM_WAKE)) {
+		/*
+		 * Resume request is pending, so let it run, because it has to
+		 * decrement the resume counter of the device.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		flush_work(&dev->power.resume_work);
+
+		goto repeat;
+	} else if (dev->power.runtime_status & RPM_SUSPENDING) {
+		/*
+		 * Suspend is running in parallel with us.  Wait for it to
+		 * complete and repeat.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		goto repeat;
+	} else if (!put_parent && dev->power.runtime_status == RPM_SUSPENDED
+	    && parent && parent->power.runtime_status != RPM_ACTIVE) {
+		/* The parent has to be resumed before we can continue. */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		error = pm_runtime_resume_get(parent);
+		if (error)
+			return error;
+
+		put_parent = true;
+		error = -EINVAL;
+		goto repeat;
+	}
+
+	status = dev->power.runtime_status;
+	if (status == RPM_RESUMING)
+		goto unlock;
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+	dev->power.runtime_status = RPM_RESUMING;
+	init_completion(&dev->power.work_done);
+
+ unlock:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent) {
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+		/*
+		 * We can decrement the parent's resume counter right now,
+		 * because it can't be suspended anyway after the
+		 * __pm_get_child() above.
+		 */
+		if (put_parent)
+			pm_runtime_put(parent);
+		parent = NULL;
+	}
+
+	if (status == RPM_RESUMING) {
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete and return.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		error = dev->power.runtime_error;
+		goto out_put;
+	}
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
+		error = dev->bus->pm->runtime_resume(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	dev->power.runtime_status = error ? RPM_ERROR : RPM_ACTIVE;
+	dev->power.runtime_error = error;
+	complete_all(&dev->power.work_done);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent) {
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+		if (put_parent)
+			pm_runtime_put(parent);
+	}
+
+ out_put:
+	/* Allow suspends to run if we are supposed to. */
+	if (!get || error)
+		pm_runtime_put_notify(dev);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_resume);
+
+/**
+ * pm_runtime_resume_work - Run __pm_runtime_resume() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the resume has been scheduled for and run
+ * __pm_runtime_resume() for it.
+ */
+static void pm_runtime_resume_work(struct work_struct *work)
+{
+	struct device *dev = resume_work_to_device(work);
+
+	__pm_runtime_resume(dev, false, false);
+	pm_runtime_put_notify(dev);
+}
+
+/**
+ * pm_cancel_suspend_work - Cancel a pending suspend request.
+ *
+ * Use @work to get the device object the work item has been scheduled for and
+ * cancel a pending suspend request for it.
+ */
+static void pm_cancel_suspend_work(struct work_struct *work)
+{
+	struct device *dev = resume_work_to_device(work);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status != RPM_IDLE
+	    || !dev->power.suspend_aborted)
+		goto out;
+	/*
+	 * Suspend request is pending, so cancel it.  __pm_runtime_resume() and
+	 * __pm_request_resume() will notice that suspend_aborted is true, so
+	 * they will return immediately.  Suspend requests and direct attempts
+	 * to suspend are blocked by the increased resume counter.
+	 */
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	cancel_delayed_work_sync(&dev->power.suspend_work);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* Clear the status if someone else hasn't done it already. */
+	if (dev->power.runtime_status == RPM_IDLE && dev->power.suspend_aborted)
+		dev->power.runtime_status = RPM_ACTIVE;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	pm_runtime_put_notify(dev);
+}
+
+/**
+ * __pm_request_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ */
+int __pm_request_resume(struct device *dev, bool get)
+{
+	struct device *parent = dev->parent;
+	unsigned long parflags = 0, flags;
+	int error = 0;
+
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (get)
+		pm_runtime_get(dev);
+
+	if (dev->power.runtime_status == RPM_ACTIVE) {
+		error = -EBUSY;
+		goto out;
+	} else if (dev->power.runtime_status & (RPM_WAKE | RPM_RESUMING)) {
+		error = -EINPROGRESS;
+		goto out;
+	}
+
+	if (dev->power.runtime_status == RPM_IDLE) {
+		error = -EBUSY;
+
+		if (dev->power.suspend_aborted)
+			goto out;
+
+		/* Suspend request is pending.  Queue a request to cancel it. */
+		dev->power.suspend_aborted = true;
+		INIT_WORK(&dev->power.resume_work, pm_cancel_suspend_work);
+		goto queue;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+
+	/*
+	 * The device may be suspending at the moment and we can't clear the
+	 * RPM_SUSPENDING bit in its runtime_status just yet.
+	 */
+	dev->power.runtime_status |= RPM_WAKE;
+	INIT_WORK(&dev->power.resume_work, pm_runtime_resume_work);
+
+ queue:
+	pm_runtime_get(dev);
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent)
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(__pm_request_resume);
+
+/**
+ * __pm_runtime_clear_status - Change the run-time PM status of a device.
+ * @dev: Device to handle.
+ * @status: New value of the device's run-time PM status.
+ *
+ * Change the run-time PM status of the device to @status, which must be
+ * either RPM_ACTIVE or RPM_SUSPENDED, if its current value is equal to
+ * RPM_ERROR.
+ */
+void __pm_runtime_clear_status(struct device *dev, unsigned int status)
+{
+	struct device *parent = dev->parent;
+	unsigned long parflags = 0, flags;
+
+	if (status & ~RPM_SUSPENDED)
+		return;
+
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status != RPM_ERROR)
+		goto out;
+
+	dev->power.runtime_status = status;
+	if (parent && status == RPM_SUSPENDED)
+		__pm_put_child(parent);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent)
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_clear_status);
+
+/**
+ * pm_runtime_init - Initialize run-time PM fields in given device object.
+ * @dev: Device object to initialize.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	struct device *parent = dev->parent;
+
+	spin_lock_init(&dev->power.lock);
+
+	dev->power.runtime_status = RPM_ACTIVE;
+	atomic_set(&dev->power.resume_count, 1);
+	pm_suspend_ignore_children(dev, false);
+	dev->power.child_count = 0;
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend_work);
+
+	if (parent) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&parent->power.lock, flags);
+		__pm_get_child(parent);
+		spin_unlock_irqrestore(&parent->power.lock, flags);
+	}
+}
+
+/**
+ * pm_runtime_close - Prepare for the removal of a device object.
+ * @dev: Device object being removed.
+ */
+void pm_runtime_close(struct device *dev)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	unsigned int status;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* This makes __pm_runtime_suspend() return immediately. */
+	pm_runtime_get(dev);
+
+	while (dev->power.runtime_status & (RPM_SUSPENDING | RPM_RESUMING)) {
+		spin_unlock_irqrestore(&parent->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+	}
+	status = dev->power.runtime_status;
+
+	/* This makes __pm_runtime_resume() return immediately. */
+	dev->power.runtime_status = RPM_ACTIVE;
+
+	spin_unlock_irqrestore(&parent->power.lock, flags);
+
+	if (status != RPM_SUSPENDED && parent) {
+		spin_lock_irqsave(&parent->power.lock, flags);
+		__pm_put_child(parent);
+		spin_unlock_irqrestore(&parent->power.lock, flags);
+	}
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,148 @@
+/*
+ * pm_runtime.h - Device run-time power management helper functions.
+ *
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_PM_RUNTIME_H
+#define _LINUX_PM_RUNTIME_H
+
+#include <linux/device.h>
+#include <linux/pm.h>
+
+#ifdef CONFIG_PM_RUNTIME
+
+extern struct workqueue_struct *pm_wq;
+
+extern void pm_runtime_init(struct device *dev);
+extern void pm_runtime_close(struct device *dev);
+extern void pm_runtime_put_notify(struct device *dev);
+extern int __pm_runtime_suspend(struct device *dev, bool sync);
+extern void pm_request_suspend(struct device *dev, unsigned int msec);
+extern int __pm_runtime_resume(struct device *dev, bool get, bool sync);
+extern int __pm_request_resume(struct device *dev, bool);
+extern void __pm_runtime_clear_status(struct device *dev, unsigned int status);
+
+static inline struct device *suspend_work_to_device(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(dw, struct dev_pm_info, suspend_work);
+	return container_of(dpi, struct device, power);
+}
+
+static inline struct device *resume_work_to_device(struct work_struct *work)
+{
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(work, struct dev_pm_info, resume_work);
+	return container_of(dpi, struct device, power);
+}
+
+static inline void pm_runtime_get(struct device *dev)
+{
+	atomic_inc(&dev->power.resume_count);
+}
+
+static inline void pm_runtime_put(struct device *dev)
+{
+	if (!atomic_add_unless(&dev->power.resume_count, -1, 0))
+		dev_warn(dev, "Excessive %s!\n", __FUNCTION__);
+}
+
+static inline bool pm_children_suspended(struct device *dev)
+{
+	return dev->power.ignore_children || !dev->power.child_count;
+}
+
+static inline bool pm_suspend_possible(struct device *dev)
+{
+	return pm_children_suspended(dev)
+		&& !atomic_read(&dev->power.resume_count)
+		&& !(dev->power.runtime_status & RPM_WAKE);
+}
+
+static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
+{
+	dev->power.ignore_children = enable;
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static inline void pm_runtime_init(struct device *dev) {}
+static inline void pm_runtime_close(struct device *dev) {}
+static inline void pm_runtime_put_notify(struct device *dev) {}
+static inline int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline void pm_request_suspend(struct device *dev, unsigned int msec) {}
+static inline int __pm_runtime_resume(struct device *dev, bool get, bool sync)
+{
+	return -ENOSYS;
+}
+static inline int __pm_request_resume(struct device *dev, bool get)
+{
+	return -ENOSYS;
+}
+static inline void __pm_runtime_clear_status(struct device *dev,
+					      unsigned int status) {}
+
+static inline void pm_runtime_get(struct device *dev) {}
+static inline bool pm_children_suspended(struct device *dev) { return false; }
+static inline bool pm_suspend_possible(struct device *dev) { return false; }
+static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
+static inline void pm_runtime_put(struct device *dev) {}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+static inline int pm_runtime_suspend(struct device *dev)
+{
+	return __pm_runtime_suspend(dev, true);
+}
+
+static inline int pm_runtime_resume(struct device *dev)
+{
+	return __pm_runtime_resume(dev, false, true);
+}
+
+static inline int pm_runtime_resume_get(struct device *dev)
+{
+	return __pm_runtime_resume(dev, true, true);
+}
+
+static inline int pm_request_resume(struct device *dev)
+{
+	return __pm_request_resume(dev, false);
+}
+
+static inline int pm_request_resume_get(struct device *dev)
+{
+	return __pm_request_resume(dev, true);
+}
+
+static inline void pm_runtime_clear_active(struct device *dev)
+{
+	__pm_runtime_clear_status(dev, RPM_ACTIVE);
+}
+
+static inline void pm_runtime_clear_suspended(struct device *dev)
+{
+	__pm_runtime_clear_status(dev, RPM_SUSPENDED);
+}
+
+static inline void pm_runtime_enable(struct device *dev)
+{
+	pm_runtime_put(dev);
+}
+
+static inline void pm_runtime_disable(struct device *dev)
+{
+	pm_runtime_get(dev);
+	pm_runtime_resume(dev);
+}
+
+#endif
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -21,6 +21,7 @@
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
@@ -88,6 +89,7 @@ void device_pm_add(struct device *dev)
 	}
 
 	list_add_tail(&dev->power.entry, &dpm_list);
+	pm_runtime_init(dev);
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -104,6 +106,7 @@ void device_pm_remove(struct device *dev
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
+	pm_runtime_close(dev);
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -507,6 +510,7 @@ static void dpm_complete(pm_message_t st
 		get_device(dev);
 		if (dev->power.status > DPM_ON) {
 			dev->power.status = DPM_ON;
+			pm_runtime_enable(dev);
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
@@ -753,6 +757,7 @@ static int dpm_prepare(pm_message_t stat
 
 		get_device(dev);
 		dev->power.status = DPM_PREPARING;
+		pm_runtime_disable(dev);
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);
@@ -760,6 +765,7 @@ static int dpm_prepare(pm_message_t stat
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			dev->power.status = DPM_ON;
+			pm_runtime_enable(dev);
 			if (error == -EAGAIN) {
 				put_device(dev);
 				continue;
Index: linux-2.6/drivers/base/dd.c
===================================================================
--- linux-2.6.orig/drivers/base/dd.c
+++ linux-2.6/drivers/base/dd.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
+#include <linux/pm_runtime.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -202,8 +203,12 @@ int driver_probe_device(struct device_dr
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
+	pm_runtime_disable(dev);
+
 	ret = really_probe(dev, drv);
 
+	pm_runtime_enable(dev);
+
 	return ret;
 }
 
@@ -306,6 +311,8 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_disable(dev);
+
 		driver_sysfs_remove(dev);
 
 		if (dev->bus)
@@ -320,6 +327,8 @@ static void __device_release_driver(stru
 		devres_release_all(dev);
 		dev->driver = NULL;
 		klist_remove(&dev->p->knode_driver);
+
+		pm_runtime_enable(dev);
 	}
 }
 
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -0,0 +1,416 @@
+Run-time Power Management Framework for I/O Devices
+
+(C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+
+1. Introduction
+
+Support for run-time power management (run-time PM) of I/O devices is provided
+at the power management core (PM core) level by means of:
+
+* The power management workqueue pm_wq in which bus types and device drivers can
+  put their PM-related work items.  It is strongly recommended that pm_wq be
+  used for queuing all work items related to run-time PM, because this allows
+  them to be synchronized with system-wide power transitions.  pm_wq is declared
+  in include/linux/pm_runtime.h and defined in kernel/power/main.c.
+
+* A number of run-time PM fields in the 'power' member of 'struct device' (which
+  is of the type 'struct dev_pm_info', defined in include/linux/pm.h) that can
+  be used for synchronizing run-time PM operations with one another.
+
+* Three device run-time PM callbacks in 'struct dev_pm_ops' (defined in
+  include/linux/pm.h).
+
+* A set of helper functions defined in drivers/base/power/runtime.c that can be
+  used for carrying out run-time PM operations in such a way that the
+  synchronization between them is taken care of by the PM core.  Bus types and
+  device drivers are encouraged to use these functions.
+
+The device run-time PM fields of 'struct dev_pm_info', the helper functions
+using them and the run-time PM callbacks present in 'struct dev_pm_ops' are
+described below.
+
+2. Run-time PM Helper Functions and Device Fields
+
+The following helper functions are defined in drivers/base/power/runtime.c
+and include/linux/pm_runtime.h:
+
+* void pm_runtime_init(struct device *dev);
+* void pm_runtime_close(struct device *dev);
+
+* void pm_runtime_get(struct device *dev);
+* void pm_runtime_put(struct device *dev);
+* void pm_runtime_put_notify(struct device *dev);
+* int pm_runtime_suspend(struct device *dev);
+* void pm_request_suspend(struct device *dev, unsigned int msec);
+* int pm_runtime_resume(struct device *dev);
+* int pm_runtime_resume_get(struct device *dev);
+* void pm_request_resume(struct device *dev);
+
+* bool pm_suspend_possible(struct device *dev);
+
+* void pm_runtime_enable(struct device *dev);
+* void pm_runtime_disable(struct device *dev);
+
+* void pm_suspend_ignore_children(struct device *dev, bool enable);
+
+* void pm_runtime_clear_active(struct device *dev) {}
+* void pm_runtime_clear_suspended(struct device *dev) {}
+
+pm_runtime_init() initializes the run-time PM fields in the 'power' member of
+a device object.  It is called during the initialization of the device object,
+in drivers/base/power/main.c:device_pm_add().
+
+pm_runtime_close() disables the run-time PM of a device and updates the 'power'
+member of its parent's device object to take the removal of the device into
+account.  It is called during the destruction of the device object, in
+drivers/base/power/main.c:device_pm_remove().
+
+pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
+pm_runtime_resume_get(), pm_request_resume(), and pm_request_resume_get()
+use the 'power.runtime_status', 'power.resume_count', 'power.suspend_aborted',
+and 'power.child_count' fields of 'struct device' for mutual cooperation.  In
+what follows the 'power.runtime_status', 'power.resume_count', and
+'power.child_count' fields are referred to as the device's run-time PM status,
+the device's resume counter, and the counter of unsuspended children of the
+device, respectively.  They are set to RPM_ACTIVE, 1 and 0, respectively, by
+pm_runtime_init().
+
+pm_runtime_get() is used to increase the device's resume counter by 1.  If the
+resume counter of the device is greater than 0, it will cause the PM core to
+refuse to suspend the device or to queue up a suspend request for it.  This may
+be useful if the device is resumed for a specific task and it shouldn't be
+suspended until the task is complete, but there are many potential sources of
+suspend requests that could disturb it.  It is valid to call this function from
+interrupt context.
+
+pm_runtime_put() is used to decrease the device's resume counter by 1 if it's
+greater than 0.  pm_runtime_put_notify() additionally checks if the device's
+resume counter is equal to zero (after it's just been decreased) and if all
+children of the device are suspended (or it has the 'power.ignore_children' flag
+set).  If that is the case, the ->runtime_idle() callback provided by the
+device's bus type is executed for it.
+
+pm_runtime_suspend() is used to carry out a run-time suspend of an active
+device.  It is called directly by a bus type or device driver, but internally
+it calls __pm_runtime_suspend() that is also used for asynchronous suspending of
+devices (i.e. to complete requests queued up by pm_request_suspend()) and works
+as follows.
+
+  * If the device is suspended (i.e. the RPM_SUSPENDED bit is set in the
+    device's run-time PM status field, 'power.runtime_status'), success is
+    returned.
+
+  * If the device's resume counter is greater than 0 or the function has been
+    called via pm_wq as a result of a cancelled suspend request (the RPM_IDLE
+    bit is set in the device's run-time PM status field and its
+    'power.suspend_aborted' flag is set), -EAGAIN is returned.
+
+  * If the device is suspending (i.e. the RPM_SUSPENDING bit is set in its
+    run-time PM status field), which means that another instance of
+    __pm_runtime_suspend() is running at the same time for the same device, the
+    function waits for the other instance to complete and returns the result
+    returned by it.
+
+  * If the device has a pending suspend request (i.e. the RPM_IDLE bit is set in
+    its run-time PM status) and the function hasn't been called as a result of
+    that request, it cancels the request (synchronously) and restarts itself if
+    a concurrent suspend or resume is running in parallel with it or a resume
+    request has just been queued up.
+
+  * If the children of the device are not suspended and the
+    'power.ignore_children' flag is not set for it, the device's run-time PM
+    status is set to RPM_ACTIVE and -EAGAIN is returned.
+
+If none of the above takes place, or a pending suspend request has been
+successfully cancelled, the device's run-time PM status is set to RPM_SUSPENDING
+and its bus type's ->runtime_suspend() callback is executed.  This callback is
+entirely responsible for handling the device as appropriate (for example, it may
+choose to execute the device driver's ->runtime_suspend() callback or to carry
+out any other suitable action depending on the bus type).
+
+  * If it completes successfully, the RPM_SUSPENDING bit is cleared and the
+    RPM_SUSPENDED bit is set in the device's run-time PM status field.  Once
+    that has happened, the device is regarded by the PM core as suspended, but
+    it _need_ _not_ mean that the device has been put into a low power state.
+    What really occurs to the device at this point entirely depends on its bus
+    type (it may depend on the device's driver if the bus type chooses to call
+    it).  Additionally, if the device bus type's ->runtime_suspend() callback
+    completes successfully and there's no resume request pending for the device
+    (i.e. the RPM_WAKE flag is not set in its run-time PM status field), and the
+    device has a parent, the parent's counter of unsuspended children (i.e. the
+    'power.child_count' field) is decremented.  If that counter turns out to be
+    equal to zero (i.e. the device was the last unsuspended child of its parent)
+    and the parent's 'power.ignore_children' flag is unset, and the parent's
+    resume counter is equal to 0, its bus type's ->runtime_idle() callback is
+    executed for it.
+
+  * If either -EBUSY or -EAGAIN is returned, the device's run-time PM status is
+    set to RPM_ACTIVE.
+
+  * If another error code is returned, the device's run-time PM status is set to
+    RPM_ERROR, which makes the PM core refuse to carry out any run-time PM
+    operations for it until the status is cleared by its bus type or driver with
+    the help of pm_runtime_clear_active() or pm_runtime_clear_suspended().
+
+Finally, pm_runtime_suspend() returns the result returned by the device bus
+type's ->runtime_suspend() callback.  If the device's bus type doesn't implement
+->runtime_suspend(), -EINVAL is returned and the device's run-time PM status is
+set to RPM_ERROR.
+
+pm_request_suspend() is used to queue up a suspend request for an active device.
+If the run-time PM status of the device (i.e. the value of the
+'power.runtime_status' field in 'struct device') is different from RPM_ACTIVE
+or its resume counter is greater than 0 (i.e. the device is not active from the
+PM core standpoint), the function returns immediately.  Otherwise, it changes
+the device's run-time PM status to RPM_IDLE and puts a request to suspend the
+device into pm_wq.  The 'msec' argument is used to specify the time to wait
+before the request will be completed, in milliseconds.  It is valid to call this
+function from interrupt context.
+
+pm_runtime_resume() and pm_runtime_resume_get() are used to carry out a
+run-time resume of a device that is suspended, suspending or has a suspend
+request pending.  They are called directly by a bus type or device driver and
+the difference between them is that pm_runtime_resume_get() leaves the device's
+resume counter incremented.  Internally, however, they both call
+__pm_runtime_resume() that is also used for asynchronous resuming of devices
+(i.e. to complete requests queued up by pm_request_resume() or
+pm_request_resume_get()).  It first increments the device's resume counter to
+prevent new suspend requests from being queued up and to make subsequent
+attempts to suspend the device fail.  The device's resume counter will be
+decremented on return, unless success is about to be returned and the function
+is requested to hold a reference to the device (i.e. in the
+pm_runtime_resume_get() case).
+
+After incrementing the device's run-time PM counter __pm_runtime_resume()
+proceeds as follows.
+
+  * If the device is active (i.e. all of the bits in its run-time PM status are
+    unset), success is returned.
+
+  * If there's a suspend request pending for the device (i.e. the RPM_IDLE bit
+    is set in the device's run-time PM status field), the
+    'power.suspend_aborted' flag is set for the device and the request is
+    cancelled (synchronously).  Then, the function restarts itself if the
+    device's RPM_IDLE bit was cleared or the 'power.suspend_aborted' flag was
+    unset in the meantime by a concurrent thread.  Otherwise, the device's
+    run-time PM status is cleared to RPM_ACTIVE and the function returns
+    success.
+
+  * If the device has a pending resume request (i.e. the RPM_WAKE bit is set in
+    its run-time PM status field), but the function hasn't been called as a
+    result of that request, the request is waited for to complete and the
+    function restarts itself.
+
+  * If the device is suspending (i.e. the RPM_SUSPENDING bit is set in its
+    run-time PM status field), the function waits for the suspend operation to
+    complete and restarts itself.
+
+  * If the device is suspended and doesn't have a pending resume request (i.e.
+    its run-time PM status is RPM_SUSPENDED), and it has a parent that is not
+    active (i.e. the parent's run-time PM status is not RPM_ACTIVE),
+    pm_runtime_resume_get() is called (recursively) for the parent.  If the
+    parent's resume is successful, the function notes that the parent's resume
+    counter will have to be decremented and restarts itself.  Otherwise, it
+    returns the error code returned by the instance of pm_runtime_resume_get()
+    handling the device's parent.
+
+  * If the device is resuming (i.e. the device's run-time PM status is
+    RPM_RESUMING), which means that another instance of __pm_runtime_resume() is
+    running at the same time for the same device, the function waits for the
+    other instance to complete and returns the result returned by it.
+
+If none of the above happens, the function checks if the device's run-time PM
+status is RPM_SUSPENDED, which means that the device doesn't have a resume
+request pending, and if it has a parent.  If that is the case, the parent's
+counter of unsuspended children is increased.  Next, the device's run-time PM
+status is set to RPM_RESUMING and its bus type's ->runtime_resume() callback is
+executed.  This callback is entirely responsible for handling the device as
+appropriate (for example, it may choose to execute the device driver's
+->runtime_resume() callback or to carry out any other suitable action depending
+on the bus type).
+
+  * If it completes successfully, the device's run-time PM status is set to
+    RPM_ACTIVE, which means that the device is fully operational.  Thus, the
+    device bus type's ->runtime_resume() callback, when it is about to return
+    success, _must_ _ensure_ that this really is the case (i.e. when it returns
+    success, the device _must_ be able to carry out I/O operations as needed).
+
+  * If an error code is returned, the device's run-time PM status is set to
+    RPM_ERROR, which makes the PM core refuse to carry out any run-time PM
+    operations for the device until the status is cleared by its bus type or
+    driver with the help of either pm_runtime_clear_active(), or
+    pm_runtime_clear_suspended().  Thus, it is strongly recommended that bus
+    types' ->runtime_resume() callbacks only return error codes in fatal error
+    conditions, when it is impossible to bring the device back to the
+    operational state by any available means.  Inability to wake up a suspended
+    device usually means a service loss and it may very well result in a data
+    loss to the user, so it _must_ be regarded as a severe problem and avoided
+    if at all possible.
+
+Finally, __pm_runtime_resume() returns the result returned by the device bus
+type's ->runtime_resume() callback.  The device's resume counter is decremented
+right before the function returns, unless success is about to be returned and
+the function is requested to hold a reference to the device (i.e. in the
+pm_runtime_resume_get() case).  If the device's bus type doesn't implement
+->runtime_resume(), -EINVAL is returned and the device's run-time PM status is
+set to RPM_ERROR.
+
+pm_request_resume() and pm_request_resume_get() are used to queue up a resume
+request for a device that is suspended, suspending or has a suspend request
+pending.  The difference between them is that pm_request_resume_get() leaves the
+device's resume counter incremented, so the device cannot be suspended by
+__pm_runtime_suspend() after it has run.  Internally, they both call
+__pm_request_resume() which works as follows.
+
+* If the function is requested to take a reference to the device (i.e. in the
+  pm_request_resume_get() case), the device's resume counter is incremented.
+
+* If the run-time PM status of the device is RPM_ACTIVE, -EBUSY is returned.
+
+* If the device is resuming or has a resume request pending (i.e. at least one
+  of the RPM_WAKE and RPM_RESUMING bits is set in the device's run-time PM
+  status field), -EINPROGRESS is returned.
+
+* If the device's run-time status is RPM_IDLE (i.e. a suspend request is pending
+  for it) and the 'power.suspend_aborted' flag is set (i.e. the pending request
+  is being cancelled), -EBUSY is returned.
+
+* If the device's run-time status is RPM_IDLE (i.e. a suspend request is pending
+  for it) and the 'power.suspend_aborted' flag is not set, the device's
+  'power.suspend_aborted' flag is set, a request to cancel the pending suspend
+  request is queued up and the device's resume counter is increased (it will be
+  decreased by the work function when it's done its job).  Finally, -EBUSY is
+  returned.
+
+If none of the above happens, the function checks if the device's run-time PM
+status is RPM_SUSPENDED and if it has a parent, in which case the parent's
+counter of unsuspended children is incremented.  Next, the function grabs a
+reference to the device by increasing its resume counter (this reference is
+going to be dropped automatically after the __pm_runtime_resume() handling the
+request has run), the RPM_WAKE bit is set in the device's run-time PM status
+field and the request to execute __pm_runtime_resume() is put into pm_wq.
+Finally, the function returns 0, which means that the resume request has been
+successfully queued up.  It is valid to call this function from interrupt
+context.
+
+Note that it usually is _not_ safe to access the device for I/O purposes
+immediately after __pm_request_resume() has returned, unless the returned result
+is -EBUSY, which means that it wasn't necessary to resume the device.
+
+Note also that only one suspend request or one resume request may be queued up
+at any given moment.  Moreover, a resume request cannot be queued up along with
+a suspend request.  Still, if it's necessary to queue up a request to cancel a
+pending suspend request, these two requests will be present in pm_wq at the
+same time.  In that case, regardless of which request is attempted to complete
+first, the device's run-time PM status will be set to RPM_ACTIVE as a final
+result.
+
+pm_suspend_possible() is used to check if the device may be suspended at this
+particular moment.  It checks the device's resume counter and the counter of
+unsuspended children.  It returns 'false' if any of these counters is greater
+than 0 or 'true' otherwise.
+
+pm_runtime_enable() and pm_runtime_disable() are used to enable and disable,
+respectively, all of the run-time PM core operations.  They do it by
+decrementing and incrementing, respectively, the device's resume counter, which
+also is done by pm_runtime_get() and pm_runtime_put().  However,
+pm_runtime_enable() doesn't notify the device's bus type of its resume counter
+reaching 0 and pm_runtime_disable() additionally calls pm_runtime_resume() for
+the device after incrementing its resume counter to ensure that it will not be
+suspended while its run-time PM is disabled.  Therefore, if pm_runtime_disable()
+is called several times in a row for the same device, it has to be balanced by
+the appropriate number of pm_runtime_enable() calls so that the other run-time
+PM core functions work for that device.  The initial value of the device's
+resume counter, as set by pm_runtime_init(), is 1 (i.e. the device's run-time PM
+is initially disabled).
+
+pm_runtime_disable() and pm_runtime_enable() are used by the device core to
+disable the run-time power management of devices temporarily during device probe
+and removal as well as during system-wide power transitions (i.e. system-wide
+suspend or hibernation, or resume from a system sleep state).
+
+pm_suspend_ignore_children() is used to set or unset the
+'power.ignore_children' flag in 'struct device'.  If the 'enabled'
+argument is 'true', the field is set to 1, and if 'enable' is 'false', the field
+is set to 0.  The default value of 'power.ignore_children', as set by
+pm_runtime_init(), is 0.
+
+pm_runtime_clear_active() is used to change the device's run-time PM status
+field from RPM_ERROR to RPM_ACTIVE.  It is valid to call this function from
+interrupt context.
+
+pm_runtime_clear_suspended() is used to change the device's run-time PM status
+field from RPM_ERROR to RPM_SUSPENDED.  If the device has a parent, it the
+function additionally decrements the parent's counter of unsuspended children,
+although the parent's bus type is not notified if the counter becomes 0.  It is
+valid to call this function from interrupt context.
+
+3. Device Run-time PM Callbacks
+
+There are three device run-time PM callbacks defined in 'struct dev_pm_ops':
+
+struct dev_pm_ops {
+	...
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+	void (*runtime_idle)(struct device *dev);
+	...
+};
+
+The ->runtime_suspend() callback is executed by pm_runtime_suspend() for the bus
+type of the device being suspended.  The bus type's callback is then _fully_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's ->runtime_suspend() callback (from the PM
+core's point of view it is not necessary to implement a ->runtime_suspend()
+callback in a device driver as long as the bus type's ->runtime_suspend() knows
+what to do to handle the device).
+* Once the bus type's ->runtime_suspend() callback has returned successfully,
+  the PM core regards the device as suspended, which need not mean that the
+  device has been put into a low power state.  It is supposed to mean, however,
+  that the device will not communicate with the CPU(s) and RAM until the bus
+  type's ->runtime_resume() callback is executed for it.
+* If the bus type's ->runtime_suspend() callback returns -EBUSY or -EAGAIN, the
+  device's run-time PM status is set to RPM_ACTIVE, which means that the device
+  _must_ be fully operational one this has happened.
+* If the bus type's ->runtime_suspend() callback returns an error code different
+  from -EBUSY or -EAGAIN, the PM core regards this as an unrecoverable error and
+  will refuse to run the helper functions described in Section 1 until the
+  status is changed to either RPM_SUSPENDED or RPM_ACTIVE by the device's bus
+  type or driver.
+In particular, it is recommended that ->runtime_suspend() return -EBUSY or
+-EAGAIN if device_may_wakeup() returns 'false' for the device.  On the other
+hand, if device_may_wakeup() returns 'true' for the device and the device is put
+into a low power state during the execution of ->runtime_suspend(), it is
+expected that remote wake-up (i.e. hardware mechanism allowing the device to
+request a change of its power state, such as PCI PME) will be enabled for the
+device.  Generally, remote wake-up should be enabled whenever the device is put
+into a low power state at run time and is expected to receive input from the
+outside of the system.
+
+The ->runtime_resume() callback is executed by pm_runtime_resume() for the bus
+type of the device being woken up.  The bus type's callback is then _fully_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's ->runtime_resume() callback (from the PM
+core's point of view it is not necessary to implement a ->runtime_resume()
+callback in a device driver as long as the bus type's ->runtime_resume() knows
+what to do to handle the device).
+* Once the bus type's ->runtime_resume() callback has returned successfully,
+  the PM core regards the device as fully operational, which means that the
+  device _must_ be able to complete I/O operations as needed.
+* If the bus type's ->runtime_resume() callback returns -EBUSY or -EAGAIN, the
+  device's run-time PM status is set to RPM_SUSPENDED, which is supposed to mean
+  that the device will not communicate with the CPU(s) and RAM until the bus
+  type's ->runtime_resume() callback is executed for it.
+* If the bus type's ->runtime_resume() callback returns an error code different
+  from -EBUSY or -EAGAIN, the PM core regards this as an unrecoverable error and
+  will refuse to run the helper functions described in Section 1 until the
+  status is changed to either RPM_SUSPENDED or RPM_ACTIVE by the device's bus
+  type or driver.
+
+The ->runtime_idle() callback is executed by pm_runtime_suspend() for the bus
+type of a device the children of which are all suspended (or which has the
+'power.suspend_skip_children' flag set).  The action carried out by this
+callback is totally dependent on the bus type in question, but the expected
+action is to check if the device can be suspended (i.e. if all of the conditions
+necessary for suspending the device are met) and to queue up a suspend request
+for the device if that is the case.
