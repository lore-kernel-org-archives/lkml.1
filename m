Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZFSAim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZFSAim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZFSAib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:38:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZFSAi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:38:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 2 fix] PM: Introduce core framework for run-time PM of I/O devices
Date: Fri, 19 Jun 2009 02:38:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906181336500.1445-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906181336500.1445-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906190238.33576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 June 2009, Alan Stern wrote:
> On Thu, 18 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Not only then.  The dev->power.depth counter was meant to be a "disable
> > everything" one, because there are situations in which we don't want even
> > resume to run (probe, release, system-wide suspend, hibernation, resume from
> > a system sleep state, possibly others).
> > 
> > That said, I overlooked some problems related to it.  So, I think to disable
> > the runtime PM of given device, it will be necessary to run a synchronous
> > runtime resume with taking a ref to block suspend.
> 
> There should also be an async version, which increases depth while
> submitting a resume request.
> 
> In fact, maybe it would be best if pm_request_resume always increments
> depth (unless it fails for some other reason) and __pm_runtime_resume
> increments depth whenever called synchronously.  And likewise for the
> suspend paths.

And how exactly are we going to check if pm_request_resume() was successful?

We'd have to be able to do that in a code path different from the one that has
called pm_request_resume().

> > > Instead of a costly device_for_each_child(), would it be better to
> > > maintain a counter with the number of unsuspended children?
> > 
> > Hmm.  How exactly are we going to count them?  The only way I see at the moment
> > would be to increase this number by one when running pm_runtime_init() for a
> > new child.  Seems doable.
> 
> That's right.  You also have to decrement the number when an
> unsuspended child device is removed, obviously.

I forgot about that, so it is not done in the patch below.

BTW, is it just me, or are we overcomplicating that thing beyond any
reasonable limit?

I think I'll just do the device_for_each_child() for now, because IMO this
optimization isn't just worth complications resulting from it, because,
realistically, how many children is a parent going to have in a notmal system?

> The one thing to watch out for is what happens if a device is removed while
> its runtime_resume callback is running.  :-)

I don't think it's possible.

> > > > +	spin_lock(&dev->power.lock);
> > > 
> > > Should be spin_lock_irq().  Same in other places.
> > 
> > OK, I wasn't sure about that.
> 
> The reasoning isn't complicated.  If a spinlock can be taken by an
> interrupt handler (or any other code that might run in interrupt
> context) then you have the possibility of a deadlock as follows:
> 
> 	spin_lock(&lock);
> 	<Interrupt occurs>
> 		irq_handler() {
> 			spin_lock(&lock);
> 
> The handler can't acquire the lock because it is already in use, and
> it can't be released until the handler returns.
> 
> As a result, if a spinlock is ever taken within an interrupt handler
> then it always has to be acquired with interrupts disabled.
> Similarly, if it is never taken within an interrupt handler but it is
> taken within a bottom-half routine, then it always has to be acquired
> with bottom halves disabled.
> 
> > From the functionality point of view, nothing wrong happens if runtime suspend
> > fails as long as an error code is returned and the caller has to be prepared
> > for a failure anyway.  Moreover, we never know why the resume is carried out,
> > so it's not clear whether it will be valid to carry out the suspend after that.
> 
> Your first point certainly is correct.  As for the second point, if
> whoever did the resume doesn't want the device suspended again, he
> should have incremented depth.  So making the suspend wait until the
> resume is finished and then failing because the depth is positive
> would be a valid approach.
> 
> However there's no use worrying about this until we have some real
> examples.
> 
> > > > +		spin_unlock(&dev->parent->power.lock);
> > > > +
> > > > +		/* The device's parent is not active.  Resume it and repeat. */
> > > > +		error = __pm_runtime_resume(dev->parent, false);
> > > > +		if (error)
> > > > +			return error;
> > > 
> > > Need to reset error to -EINVAL.
> > 
> > Why -EINVAL?
> 
> We have lost the context because of email trimming.  Briefly, when you
> jump back to "repeat:", the code there expects error to have been
> initialized to -EINVAL.  Some of the pathways will return error
> unchanged, expecting it to have that value.
> 
> Alternatively, you could have those pathways set error and then you
> wouldn't have to initialize it.  Either way.

Ah, OK

> > > The equivalent code in USB does this automatically.  The
> > > runtime-disable routine does a resume if the depth value was
> > > originally 0,
> > 
> > Yes, we should do that in general.
> > 
> > > and the runtime-enable routine queues a delayed autosuspend request if the
> > > final depth value is 0.
> > 
> > I don't like this.
> 
> I guess this a question of how you view things.  My view has been that
> whever depth (or pm_usage_cnt in the USB code) is 0, it means neither
> the driver nor anyone else has any reason to keep the device at full
> power.  By definition, since that's what depth is -- a count of the
> reasons for not suspending.
> 
> There might be some obscure other reason, but in general depth going
> to 0 means a delayed autosuspend request should be queued.

OK there, but pm_runtime_disable() is called by the core in some places where
we'd rather not want the device to be suspended (like during a system-wide
power transitions).

> Which reminds me... Something to think about: In an async call to
> __pm_runtime_suspend, if the runtime_suspend callback returns -EBUSY
> then perhaps your code should automatically requeue a new delayed
> autosuspend request.  Which implies, of course, that the autosuspend
> delay has to be stored in the dev_pm_info structure.  This isn't a bad
> thing, since exposing the value in sysfs gives userspace a consistent
> way to set the delay.

I think that functionality can be added later.  Let's keep things as simple
as possible initially, or we won't be able to make any progress.

Below is a new version of the patch.  Unfortunately, it is a major rework.
In short, I tried to address some of your recent comments and my observations.
It doesn't use depth any more, there's another counter (called resume_count)
instead, also playing the role of the RPM_GRACE bit from the previous version.

I've just finished it, so it may be still missing something apart from the
updating child_count on removal of an unsuspended child.

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

Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  378 ++++++++++++++++++++++++++
 drivers/base/dd.c                  |    9 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |    5 
 drivers/base/power/runtime.c       |  533 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   95 ++++++
 include/linux/pm_runtime.h         |  115 +++++++
 kernel/power/Kconfig               |   14 
 kernel/power/main.c                |   17 +
 9 files changed, 1164 insertions(+), 3 deletions(-)

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
+	int			resume_count;
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
@@ -0,0 +1,533 @@
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
+	if (!pm_children_suspended(dev))
+		return;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+}
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
+ repeat:
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_status & RPM_SUSPENDED) {
+		error = 0;
+		goto out;
+	} else if ((dev->power.runtime_status & (RPM_WAKE | RPM_RESUMING))
+	    || dev->power.resume_count > 0
+	    || (!sync && dev->power.suspend_aborted)) {
+		/*
+		 * Device is resuming, there's a resume request pending for it,
+		 * the device's resume counter is greater than 0, or a pending
+		 * suspend request has just been cancelled and we're running as
+		 * a result of that request.
+		 */
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_SUSPENDING) {
+		/*
+		 * Another suspend is running in parallel with us.  Wait for it
+		 * to complete and return.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_error;
+	} else if (sync && dev->power.runtime_status == RPM_IDLE) {
+		/*
+		 * Suspend request is pending, but we're not running as a result
+		 * of it, so cancel it and repeat.
+		 */
+		dev->power.suspend_aborted = true;
+		dev->power.runtime_status = RPM_ACTIVE;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		goto repeat;
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
+		 * Resume request might have been queued in the meantime, in
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
+		pm_runtime_notify_idle(parent);
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
+	if (dev->power.runtime_status != RPM_ACTIVE)
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
+ * __pm_runtime_get - Increment the resume counter of given device.
+ * @dev: Device to handle.
+ */
+static void __pm_runtime_get(struct device *dev)
+{
+	dev->power.resume_count++;
+}
+
+/**
+ * __pm_runtime_put - Decrement the resume counter of given device.
+ * @dev: Device to handle.
+ */
+static void __pm_runtime_put(struct device *dev)
+{
+	if (dev->power.resume_count > 0)
+		dev->power.resume_count--;
+	else
+		dev_warn(dev, "Excessive %s!\n", __FUNCTION__);
+}
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
+	int error = -EINVAL;
+
+	might_sleep();
+
+ repeat:
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_status == RPM_ACTIVE) {
+		error = 0;
+		goto out;
+	}
+
+	if (dev->power.runtime_status & RPM_IDLE) {
+		/* Only a suspend request is pending, cancel it and repeat. */
+		dev->power.suspend_aborted = true;
+		dev->power.runtime_status &= ~RPM_IDLE;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		goto repeat;
+	} else if (sync && (dev->power.runtime_status & RPM_WAKE)) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		/*
+		 * Resume request is pending, but we're not running as a result
+		 * of it, so it has to run before we continue in case it's
+		 * going to increment the device's resume counter.
+		 */
+		flush_work(&dev->power.resume_work);
+
+		goto repeat;
+	} else if (dev->power.runtime_status & RPM_SUSPENDING) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent)
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		/*
+		 * A suspend is running in parallel with us.  Wait for it to
+		 * complete and repeat.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		goto repeat;
+	} else if (dev->power.runtime_status == RPM_SUSPENDED && parent
+	    && parent->power.runtime_status != RPM_ACTIVE) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		/* The parent as to be resumed before we continue. */
+		error = pm_runtime_resume_get(parent);
+		if (error)
+			return error;
+
+		put_parent = true;
+		error = -EINVAL;
+		goto repeat;
+	}
+
+	if (dev->power.runtime_status == RPM_RESUMING) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		if (parent) {
+			if (put_parent)
+				__pm_runtime_put(parent);
+			spin_unlock_irqrestore(&parent->power.lock, parflags);
+			parent = NULL;
+		}
+
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete and return.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		error = dev->power.runtime_error;
+		goto out;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+
+	dev->power.runtime_status = RPM_RESUMING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent) {
+		if (put_parent)
+			__pm_runtime_put(parent);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+		parent = NULL;
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
+	if (!error && get)
+		__pm_runtime_get(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent) {
+		if (put_parent)
+			__pm_runtime_put(parent);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+	}
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
+	__pm_runtime_resume(resume_work_to_device(work), false, false);
+}
+
+/**
+ * pm_request_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ */
+void pm_request_resume(struct device *dev)
+{
+	struct device *parent = dev->parent;
+	unsigned long parflags = 0, flags;
+
+ repeat:
+	if (parent)
+		spin_lock_irqsave(&parent->power.lock, parflags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if ((dev->power.runtime_status & RPM_WAKE)
+	    || !(dev->power.runtime_status &
+			(RPM_SUSPENDING | RPM_SUSPENDED))) {
+		goto out;
+	} else if (parent && !(parent->power.runtime_status & RPM_WAKE)
+	    && (parent->power.runtime_status &
+			(RPM_IDLE | RPM_SUSPENDING | RPM_SUSPENDED))) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+
+		pm_request_resume(parent);
+
+		goto repeat;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+
+	/*
+	 * The device may be suspending at the moment or a suspend request may
+	 * be pending for it and we can't clear the RPM_IDLE or RPM_SUSPENDING
+	 * bit in its runtime_status just yet.
+	 */
+	dev->power.runtime_status |= RPM_WAKE;
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (parent)
+		spin_unlock_irqrestore(&parent->power.lock, parflags);
+}
+EXPORT_SYMBOL_GPL(pm_request_resume);
+
+/**
+ * pm_runtime_put - Decrement the resume counter of a device under 'power.lock'.
+ * @dev: Device to handle.
+ */
+void pm_runtime_put(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	__pm_runtime_put(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put);
+
+/**
+ * pm_runtime_disable - Disable run-time suspend and resume of a device.
+ * @dev: Device to handle.
+ *
+ * Increase the resume counter of given device, so that it cannot be suspended
+ * at run time, and run pm_runtime_resume() for it to put it into the RPM_ACTIVE
+ * state, which also blocks run-time resume of it.
+ */
+void pm_runtime_disable(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	__pm_runtime_get(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	pm_runtime_resume(dev);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
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
+ * @dev: Device object to handle.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	struct device *parent = dev->parent;
+
+	spin_lock_init(&dev->power.lock);
+
+	dev->power.runtime_status = RPM_ACTIVE;
+	dev->power.resume_count = 1;
+	pm_suspend_ignore_children(dev, false);
+	dev->power.child_count = 0;
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend_work);
+	INIT_WORK(&dev->power.resume_work, pm_runtime_resume_work);
+
+	if (parent) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&parent->power.lock, flags);
+
+		__pm_get_child(parent);
+
+		spin_unlock_irqrestore(&parent->power.lock, flags);
+	}
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,115 @@
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
+extern int __pm_runtime_suspend(struct device *dev, bool sync);
+extern void pm_request_suspend(struct device *dev, unsigned int msec);
+extern int __pm_runtime_resume(struct device *dev, bool get, bool sync);
+extern void pm_request_resume(struct device *dev);
+extern void pm_runtime_put(struct device *dev);
+extern void pm_runtime_disable(struct device *dev);
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
+static inline bool pm_children_suspended(struct device *dev)
+{
+	return dev->power.ignore_children || !dev->power.child_count;
+}
+
+static inline bool pm_suspend_possible(struct device *dev)
+{
+	return pm_children_suspended(dev) && !(dev->power.resume_count > 0
+		|| (dev->power.runtime_status & (RPM_WAKE | RPM_RESUMING)));
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
+static inline int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline void pm_request_suspend(struct device *dev, unsigned int msec) {}
+static inline int __pm_runtime_resume(struct device *dev, bool get, bool sync)
+{
+	return -ENOSYS;
+}
+static inline void pm_request_resume(struct device *dev) {}
+static inline void pm_runtime_put(struct device *dev) {}
+static inline void pm_runtime_disable(struct device *dev) {}
+static inline void __pm_runtime_clear_status(struct device *dev,
+					      unsigned int status) {}
+
+static inline bool pm_children_suspended(struct device *dev) { return false; }
+static inline bool pm_suspend_possible(struct device *dev) { return false; }
+static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
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
 
@@ -507,6 +509,7 @@ static void dpm_complete(pm_message_t st
 		get_device(dev);
 		if (dev->power.status > DPM_ON) {
 			dev->power.status = DPM_ON;
+			pm_runtime_enable(dev);
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
@@ -753,6 +756,7 @@ static int dpm_prepare(pm_message_t stat
 
 		get_device(dev);
 		dev->power.status = DPM_PREPARING;
+		pm_runtime_disable(dev);
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);
@@ -760,6 +764,7 @@ static int dpm_prepare(pm_message_t stat
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
@@ -0,0 +1,378 @@
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
+
+* int pm_runtime_suspend(struct device *dev);
+* void pm_request_suspend(struct device *dev, unsigned int msec);
+* int pm_runtime_resume(struct device *dev);
+* int pm_runtime_resume_get(struct device *dev);
+* void pm_request_resume(struct device *dev);
+* void pm_runtime_put(struct device *dev);
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
+pm_runtime_suspend() is used to carry out a run-time suspend of an active
+device.  It is called directly by a bus type or device driver.  There also is
+an asynchronous version of it, which is executed by the PM core to complete a
+request queued up by pm_request_suspend().  However, the only difference between
+them is the handling of situations in which a queued up suspend request has just
+been cancelled.  Apart from this, they work in the same way.
+
+  * If the device is suspended (i.e. the RPM_SUSPENDED bit is set in the
+    device's run-time PM status field, 'power.runtime_status'), success is
+    returned.
+
+  * If the device is about to resume (i.e. at least one of the RPM_WAKE and
+    RPM_RESUMING bits are set in its run-time PM status field) or its resume
+    counter is greater than 0, or the function has been called via pm_wq as a
+    result of a cancelled suspend request (the 'power.suspend_aborted' field is
+    used to signal the termination of a suspend request), -EAGAIN is returned.
+
+  * If the device is suspending (i.e. its run-time PM status is RPM_SUSPENDING),
+    which means that another instance of pm_runtime_suspend() is running at the
+    same time for the same device, the function waits for the other instance to
+    complete and returns the error code (or success) returned by it.
+
+  * If the device has a pending suspend request (i.e. the RPM_IDLE bit is set in
+    its run-time PM status) and the function hasn't been called as a result of
+    that request, it cancels the request and restarts itself in case another
+    suspend is running in parallel with it.
+
+  * If the children of the device are not suspended and the
+    'power.ignore_children' flag is not set for it, the device's run-time PM
+    status is set to RPM_ACTIVE and -EAGAIN is returned.
+
+If none of the above takes place, the device's run-time PM status is set to
+RPM_SUSPENDING and its bus type's ->runtime_suspend() callback is executed.
+This callback is responsible for handling the device as appropriate (for
+example, it may choose to execute the device driver's ->runtime_suspend()
+callback or to carry out any other suitable action depending on the bus type).
+
+  * If it completes successfully, the RPM_SUSPENDING bit is cleared and the
+    RPM_SUSPENDED bit is set in the device's run-time PM status field.  Once
+    that has happened, the device is regarded by the PM core as suspended, but
+    it _need_ _not_ mean that the device has been put into a low power state.
+    What really occurs to the device at this point totally depends on its bus
+    type (it may depend on the device's driver if the bus type chooses to call
+    it).  Additionally, if the device bus type's ->runtime_suspend() callback
+    completes successfully and there's no resume request pending for the device
+    (i.e. the RPM_WAKE flag is not set in its run-time PM status field), and the
+    device has a parent, the parent's counter of unsuspended children (i.e. the
+    'power.child_count' field) is decremented.  Next, if it turns out to be
+    equal to zero (i.e. all children of the device's parent have been suspended)
+    or the parent has the 'power.ignore_children' flag set, the parent's bus
+    type's ->runtime_idle() callback is executed.
+
+  * If either -EBUSY or -EAGAIN is returned, the device's run-time PM status is
+    set to RPM_ACTIVE.
+
+  * If another error code is returned, the device's run-time PM status is set to
+    RPM_ERROR, which makes the PM core refuse to carry out any run-time PM
+    operations for it until the status is cleared by its bus type or driver with
+    the help of pm_runtime_clear_active() or pm_runtime_clear_suspended().
+
+Finally, pm_runtime_suspend() returns the error code (or success) returned by
+the device bus type's ->runtime_suspend() callback.  If the device's bus type
+doesn't implement ->runtime_suspend(), -EINVAL is returned and the device's
+run-time PM status is set to RPM_ERROR.
+
+pm_request_suspend() is used to queue up a suspend request for an active device.
+If the run-time PM status of the device (i.e. the value of the
+'power.runtime_status' field in 'struct device') is different from RPM_ACTIVE
+(i.e. the device is not active from the PM core standpoint), the function
+returns immediately.  Otherwise, it changes the device's run-time PM status to
+RPM_IDLE and puts a request to suspend the device into pm_wq.  The 'msec'
+argument is used to specify the time to wait before the request will be
+completed, in milliseconds.  It is valid to call this function from interrupt
+context.
+
+pm_runtime_resume() and pm_runtime_resume_get() are used to carry out a
+run-time resume of a device that is suspended, suspending or has a suspend
+request pending.  They are called directly by a bus type or device driver.
+The difference between them is that pm_request_resume_get() increments the
+device's resume counter, which prevents the PM core from suspending the device
+or queuing up a suspend request for it until its resume counter is decreased
+down to 0 with the help of pm_runtime_put().  Apart from this, they work in the
+same way.  There also is an asynchronous version of pm_runtime_resume(), called
+by the PM core as a result of a resume request queued up by pm_request_resume(),
+which doesn't check if there's a concurrent pending resume request for the
+device.
+
+  * If the device is active (i.e. all of the bits in its run-time PM status are
+    unset), success is returned (pm_request_resume_get() increments the device's
+    resume counter in that case).
+
+  * If there's a suspend request pending for the device (i.e. the device's
+    run-time PM status is RPM_IDLE), it is cancelled, the
+    'power.suspend_aborted' flag is set for the device, the RPM_IDLE bit is
+    cleared in its run-time PM status field and the function restarts itself.
+
+  * If the device has a pending resume request (i.e. the RPM_WAKE bit is set in
+    its run-time PM status field), but the function hasn't been called as a
+    result of that request, the function waits for that request to complete
+    (in case it's going to increment the device's resume counter) and restarts
+    itself.
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
+    RPM_RESUMING), which means that another instance of pm_runtime_resume() or
+    pm_runtime_resume_get() is running at the same time for the same device, the
+    function waits for the other instance to complete and returns the result
+    returned by it (pm_runtime_resume_get() increments the device's resume
+    counter if success is returned).
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
+    pm_runtime_clear_suspended().  Thus, it is strongly recommended that the
+    device bus type's ->runtime_resume() callback only return error codes in
+    fatal error conditions, when it is impossible to bring the device back to
+    the operational state by any available means.  Inability to wake up a
+    suspended device usually means a service loss and it may very well result in
+    a data loss to the user, so it _must_ be avoided if at all possible.
+
+Finally, pm_runtime_resume() and pm_runtime_resume_get() return the error code
+(or success) returned by the device bus type's ->runtime_resume() callback
+(pm_runtime_resume_get() increments the device's resume counter if success is
+returned).  If the device's bus type doesn't implement ->runtime_resume(),
+-EINVAL is returned and the device's run-time PM status is set to RPM_ERROR.
+
+pm_request_resume() is used to queue up a resume request for a device that is
+suspended, suspending or has a suspend request pending.
+
+  * If the device has a resume request pending (i.e. the RPM_WAKE bit is set in
+    its run-time PM status field) or the device is not suspended or suspending
+    (i.e. none of the RPM_SUSPENDED and RPM_SUSPENDING bits is set in its
+    run-time PM status field), the function returns.
+
+  * If the device has a parent and the parent is inactive (i.e. at least one of
+    the RPM_IDLE, RPM_SUSPENDING, and RPM_SUSPENDED bits is set in its run-time
+    PM status field), and the parent doesn't have a resume request pending
+    (i.e. the RPM_WAKE bit is not set in the parent's run-time PM status field),
+    a resume request is scheduled for the parent with the help of
+    pm_request_resume() (i.e. recursively) and the function is restarted.
+
+If none of the above happens, the function checks if the device's run-time PM
+status is RPM_SUSPENDED, which means that the device is not suspending at the
+moment, and if it has a parent.  If that is the case, the parent's counter of
+unsuspended children is increased.  Next, the RPM_WAKE bit is set in the
+device's run-time PM status field and the request to execute the asynchronous
+version of pm_runtime_resume() is put into pm_wq.  It is valid to call this
+function from interrupt context.
+
+Note that it is possible to have a resume request and a suspend request queued
+up at the same time.  In that case, if the suspend request is attempted to
+complete first, the asynchronous version of pm_runtime_suspend() run as a result
+of it will notice that the RPM_WAKE bit is set in the device's run-time PM
+status field and will return -EAGAIN as a result without doing anything else.
+Then, the subsequent resume carried out as a result of the queued up request
+will notice that the RPM_IDLE bit is set in the device's run-time PM status
+field, so it will try to cancel the suspend request and the run-time PM status
+of the device will be set to RPM_ACTIVE.  On the other hand, if the resume
+request is attempted to complete first, which is more likely, it will cancel the
+pending suspend request the run-time PM status of the device will be set to
+RPM_ACTIVE.
+
+pm_runtime_put() is used to decrease the device's resume counter by 1.  If the
+resume counter of the device is greater than 0, it causes the PM core to refuse
+to suspend the device or to queue up a suspend request for it.  In particular,
+it causes pm_runtime_suspend() to return -EAGAIN without doing anything else.
+This may be useful if the device is resumed for a specific task and it shouldn't
+be suspended until the task is complete, but there are many potential sources of
+suspend requests that could disturb it.  It is valid to call this function from
+interrupt context.
+
+pm_suspend_possible() is used to check if the device may be suspended at this
+particular moment.  It checks the device's run-time PM status, resume counter,
+and the counter of unsuspended children.  It returns 'false' if the device's
+counter of unsuspended children is greater than 0 or the device's resume counter
+is greater than 0, or at least one of the RPM_WAKE and RPM_RESUMING bits is set
+in its run-time PM status field.  It is valid to call this function from
+interrupt context.
+
+pm_runtime_enable() and pm_runtime_disable() are used to enable and disable,
+respectively, all of the run-time PM core operations.  They do it by decreasing
+and increasing, respectively, the device's resume counter, but
+pm_runtime_disable() additionally calls pm_runtime_resume() for the device to
+make sure that the device will not be suspended while its run-time power
+management is disabled.  Therefore, if pm_runtime_disable() is called several
+times in a row for the same device, it has to be balanced by the appropriate
+number of pm_runtime_enable() calls so that the other run-time PM core functions
+can be used for that device.  The initial value of the device's resume counter,
+as set by pm_runtime_init(), is 1 (i.e. the device's run-time power management
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
+function additionally decrements the parent's counter of unsuspended children.
+It is valid to call this function from interrupt context.
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
