Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZFXAgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZFXAgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFXAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:36:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZFXAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:36:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 4)
Date: Wed, 24 Jun 2009 02:36:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906231303390.3209-100000@iolanthe.rowland.org> <200906240208.23482.rjw@sisk.pl>
In-Reply-To: <200906240208.23482.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906240236.41526.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Rafael J. Wysocki wrote:
> On Tuesday 23 June 2009, Alan Stern wrote:
> > On Tue, 23 Jun 2009, Rafael J. Wysocki wrote:
> > 
> > > Hi,
> > > 
> > > Below is a new revision of the patch introducing the run-time PM framework.
> > > 
> > > The most visible changes from the last version:
> > > 
> > > * I realized that if child_count is atomic, we can drop the parent locking from
> > >   all of the functions, so I did that.
> > > 
> > > * Introduced pm_runtime_put() that decrements the resume counter and queues
> > >   up an idle notification if the counter went down to 0 (and wasn't 0 previously).
> > >   Using asynchronous notification makes it possible to call pm_runtime_put()
> > >   from interrupt context, if necessary.
> > > 
> > > * Changed the meaning of the RPM_WAKE bit slightly (it is now also used for
> > >   disabling run-time PM for a device along with the resume counter).
> > > 
> > > Please let me know if I've overlooked anything. :-)
> > 
> > This first thing to strike me was that you moved the idle notifications 
> > into the workqueue.
> 
> Yes, I did.
>  
> > Is that really needed?  Would we be better off just make the idle
> > callbacks directly from pm_runtime_put?  They would run in whatever
> > context the driver happened to be in at the time.
> > 
> > It's not clear exactly how much work the idle callbacks will need to 
> > do, but it seems likely that they won't have to do too much more than 
> > call pm_request_suspend.  And of course, that can be done in_interrupt.
> 
> I just don't want to put any constraints on the implementation of
> ->runtime_idle().  The requirement that it be suitable for calling from
> interrupt context may be quite inconvenient for some drivers and I'm afraid
> they may have problems with meeting it.

BTW, appended is a new update.  Hopefully, the majority of bugs were found
and fixed this time.

I dropped the documentation for now, until the code settles down.

Also, I removed the automatic incrementing and decrementing of resume_count
in __pm_runtime_resume() and pm_request_resume().

Description of RPM_NOTIFY is missing (sorry for that).  It's set when idle
notification has been scheduled for the device and reset before running
pm_runtime_idle() by the work function.

Comments welcome.

Best,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 4)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/dd.c            |    9 
 drivers/base/power/Makefile  |    1 
 drivers/base/power/main.c    |   16 
 drivers/base/power/power.h   |   11 
 drivers/base/power/runtime.c |  709 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |   98 +++++
 include/linux/pm_runtime.h   |  136 ++++++++
 kernel/power/Kconfig         |   14 
 kernel/power/main.c          |   17 +
 9 files changed, 1001 insertions(+), 10 deletions(-)

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
@@ -315,14 +343,78 @@ enum dpm_state {
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
+#define RPM_NOTIFY	0x20
+#define RPM_ERROR	0x3F
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
+	struct work_struct	work;
+	struct completion	work_done;
+	unsigned int		ignore_children:1;
+	unsigned int		runtime_break:1;
+	unsigned int		runtime_busy:1;
+	unsigned int		runtime_disabled:1;
+	unsigned int		runtime_status:6;
+	int			runtime_error;
+	atomic_t		resume_count;
+	atomic_t		child_count;
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
@@ -0,0 +1,709 @@
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
+ * pm_runtime_idle - Check if device can be suspended and notify its bus type.
+ * @dev: Device to notify.
+ */
+void pm_runtime_idle(struct device *dev)
+{
+	if (!pm_suspend_possible(dev))
+		return;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_idle);
+
+/**
+ * __pm_get_child - Increment the counter of unsuspended children of a device.
+ * @dev: Device to handle;
+ */
+static void __pm_get_child(struct device *dev)
+{
+	atomic_inc(&dev->power.child_count);
+}
+
+/**
+ * __pm_put_child - Decrement the counter of unsuspended children of a device.
+ * @dev: Device to handle;
+ */
+static void __pm_put_child(struct device *dev)
+{
+	if (!atomic_add_unless(&dev->power.child_count, -1, 0))
+		dev_WARN(dev, "Unbalanced counter decrementation");
+}
+
+/**
+ * __pm_runtime_suspend - Run a device bus type's runtime_suspend() callback.
+ * @dev: Device to suspend.
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the run-time PM status of the device is appropriate and run the
+ * ->runtime_suspend() callback provided by the device's bus type.  Update the
+ * run-time PM flags in the device object to reflect the current status of the
+ * device.
+ */
+int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	struct device *parent = NULL;
+	unsigned long flags;
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
+	    || dev->power.runtime_disabled
+	    || (dev->power.runtime_status & (RPM_WAKE|RPM_RESUMING))
+	    || (!sync && dev->power.runtime_status == RPM_IDLE
+	    && dev->power.runtime_break)) {
+		/*
+		 * We're forbidden to suspend the device, it is resuming or has
+		 * a resume request pending, or a pending suspend request has
+		 * just been cancelled and we're running as a result of that
+		 * request.
+		 */
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status & RPM_SUSPENDING) {
+		/* Another suspend is running in parallel with us. */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_error;
+	} else if (dev->power.runtime_status & RPM_NOTIFY) {
+		/*
+		 * Idle notification is pending for the device, so preempt it.
+		 * There also may be a suspend request pending, but the idle
+		 * notification work function will run earlier, so make it
+		 * cancel that request for us.
+		 */
+		if (dev->power.runtime_status & RPM_IDLE)
+			dev->power.runtime_status |= RPM_WAKE;
+		dev->power.runtime_break = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		flush_work(&dev->power.work);
+
+		goto repeat;
+	} else if (sync && dev->power.runtime_status == RPM_IDLE
+	    && !dev->power.runtime_break) {
+		/*
+		 * Suspend request is pending, but we're not running as a result
+		 * of that request, so cancel it.  Since we're not clearing the
+		 * RPM_IDLE bit now, no new suspend requests will be queued up
+		 * while the cancelled pending one is waited for.
+		 */
+		dev->power.runtime_break = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Repeat if anyone else has already cleared the status. */
+		if (dev->power.runtime_status != RPM_IDLE
+		    || !dev->power.runtime_break)
+			goto repeat;
+
+		dev->power.runtime_break = false;
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
+
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
+	if (!error && !(dev->power.runtime_status & RPM_WAKE) && dev->parent)
+		parent = dev->parent;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (parent) {
+		__pm_put_child(parent);
+
+		if (!parent->power.ignore_children)
+			pm_runtime_idle(parent);
+	}
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
+	if (atomic_read(&dev->power.resume_count) > 0)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* There may be an idle notification in progress, so be careful. */
+	if (!(dev->power.runtime_status & ~RPM_NOTIFY)
+	    || dev->power.runtime_disabled)
+		goto out;
+
+	dev->power.runtime_status |= RPM_IDLE;
+	dev->power.runtime_break = false;
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
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the device is really suspended and run the ->runtime_resume()
+ * callback provided by the device's bus type driver.  Update the run-time PM
+ * flags in the device object to reflect the current status of the device.  If
+ * runtime suspend is in progress while this function is being run, wait for it
+ * to finish before resuming the device.  If runtime suspend is scheduled, but
+ * it hasn't started yet, cancel it and we're done.
+ */
+int __pm_runtime_resume(struct device *dev, bool sync)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	bool put_parent = false;
+	int error = -EINVAL;
+
+	might_sleep();
+
+ repeat:
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+ repeat_locked:
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_disabled) {
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_ACTIVE) {
+		error = 0;
+		goto out;
+	} else if (dev->power.runtime_status & RPM_NOTIFY) {
+		/*
+		 * Device has an idle notification pending, preempt it.
+		 * There also may be a suspend request pending, but the idle
+		 * notification function will run earlier, so make it cancel
+		 * that request for us.
+		 */
+		if (dev->power.runtime_status & RPM_IDLE)
+			dev->power.runtime_status |= RPM_WAKE;
+		dev->power.runtime_break = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		flush_work(&dev->power.work);
+		goto repeat;
+	} else if (dev->power.runtime_status == RPM_IDLE
+	    && !dev->power.runtime_break) {
+		/* Suspend request is pending, not yet aborted, so cancel it. */
+		dev->power.runtime_break = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Repeat if anyone else has already changed the status. */
+		if (dev->power.runtime_status != RPM_IDLE
+		    || !dev->power.runtime_break)
+			goto repeat_locked;
+
+		/* The RPM_IDLE bit is still set, so clear it and return. */
+		dev->power.runtime_status = RPM_ACTIVE;
+		error = 0;
+		goto out;
+	} else if (sync && (dev->power.runtime_status & RPM_WAKE)) {
+		/* Resume request is pending, so let it run. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		flush_work(&dev->power.work);
+		goto repeat;
+	} else if (dev->power.runtime_status & RPM_SUSPENDING) {
+		/*
+		 * Suspend is running in parallel with us.  Wait for it to
+		 * complete and repeat.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+		goto repeat;
+	} else if (!put_parent && parent
+	    && dev->power.runtime_status == RPM_SUSPENDED) {
+		/*
+		 * Increase the parent's resume counter and request that it be
+		 * woken up if necessary.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		__pm_runtime_get(parent);
+		error = pm_runtime_resume(parent);
+		if (error) {
+			__pm_runtime_put(parent);
+			return error;
+		}
+
+		put_parent = true;
+		error = -EINVAL;
+		goto repeat;
+	} else if (dev->power.runtime_status == RPM_RESUMING) {
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete and return.
+		 */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+		error = dev->power.runtime_error;
+		goto out_parent;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+
+	dev->power.runtime_status = RPM_RESUMING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	/*
+	 * We can decrement the parent's resume counter right now, because it
+	 * can't be suspended anyway after the __pm_get_child() above.
+	 */
+	if (put_parent) {
+		__pm_runtime_put(parent);
+		put_parent = false;
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
+
+ out_parent:
+	if (put_parent)
+		__pm_runtime_put(parent);
+
+	if (!sync && !error)
+		pm_runtime_idle(dev);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_resume);
+
+/**
+ * pm_runtime_work - Run __pm_runtime_resume() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the resume has been scheduled for and run
+ * __pm_runtime_resume() for it.
+ */
+static void pm_runtime_work(struct work_struct *work)
+{
+	__pm_runtime_resume(work_to_device(work), false);
+}
+
+/**
+ * pm_notify_or_cancel_work - Run pm_runtime_idle() or cancel a suspend request.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to find a device and either execute pm_runtime_idle() for that
+ * device, or cancel a pending suspend request for it depending on the device's
+ * run-time PM status.
+ */
+static void pm_notify_or_cancel_work(struct work_struct *work)
+{
+	struct device *dev = work_to_device(work);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/*
+	 * There are three situations in which this function is run.  First, if
+	 * there's a request to notify the device's bus type that the device is
+	 * idle.  Second, if there's a request to cancel a pending suspend
+	 * request.  Finally, if the previous two happen at the same time.
+	 * However, we only need to run pm_runtime_idle() in the first
+	 * situation, because in the last one the request to suspend being
+	 * cancelled must have happened after the request to run idle
+	 * notification, which means that runtime_break is set.  In addition to
+	 * that, runtime_break will be set if synchronous suspend or resume has
+	 * run before us.
+	 */
+	dev->power.runtime_status &= ~RPM_NOTIFY;
+	if (!dev->power.runtime_break)
+		goto notify;
+
+	if (dev->power.runtime_status == (RPM_IDLE|RPM_WAKE)) {
+		/* We have a suspend request to cancel. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Clear the status if someone else hasn't done it yet. */
+		if (dev->power.runtime_status != (RPM_IDLE|RPM_WAKE)
+		    || !dev->power.runtime_break)
+			goto out;
+	}
+
+	dev->power.runtime_status = RPM_ACTIVE;
+	dev->power.runtime_break = false;
+	goto out;
+
+ notify:
+	dev->power.runtime_busy = true;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	pm_runtime_idle(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	dev->power.runtime_busy = false;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+
+/**
+ * pm_request_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ */
+int pm_request_resume(struct device *dev)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	int error = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR) {
+		error = -EINVAL;
+	} else if (dev->power.runtime_disabled) {
+		error = -EAGAIN;
+	} else if (dev->power.runtime_status == RPM_ACTIVE) {
+		error = -EBUSY;
+	} else if (dev->power.runtime_status & RPM_NOTIFY) {
+		/*
+		 * Device has an idle notification pending, so make it fail.
+		 * It may also have a suspend request pending, but the idle
+		 * notification work function will run before it and can cancel
+		 * it for us just fine.
+		 */
+		dev->power.runtime_status |= RPM_WAKE;
+		dev->power.runtime_break = true;
+		error = -EBUSY;
+	} else if (dev->power.runtime_status & (RPM_WAKE|RPM_RESUMING)) {
+		error = -EINPROGRESS;
+	}
+	if (error)
+		goto out;
+
+	if (dev->power.runtime_status == RPM_IDLE) {
+		error = -EBUSY;
+
+		/* Check if the suspend is being cancelled already. */
+		if (dev->power.runtime_break)
+			goto out;
+
+		/* Suspend request is pending.  Queue a request to cancel it. */
+		dev->power.runtime_break = true;
+		INIT_WORK(&dev->power.work, pm_notify_or_cancel_work);
+		goto queue;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED && parent)
+		__pm_get_child(parent);
+
+	INIT_WORK(&dev->power.work, pm_runtime_work);
+
+ queue:
+	/*
+	 * The device may be suspending at the moment or there may be a resume
+	 * request pending for it and we can't clear the RPM_SUSPENDING and
+	 * RPM_IDLE bits in its runtime_status just yet.
+	 */
+	dev->power.runtime_status |= RPM_WAKE;
+	queue_work(pm_wq, &dev->power.work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_request_resume);
+
+/**
+ * pm_runtime_put - Decrement the resume counter and run idle notification.
+ * @dev: Device to handle.
+ *
+ * Decrement the device's resume counter, check if it is possible to suspend the
+ * device and notify its bus type in that case.
+ */
+void pm_runtime_put(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!__pm_runtime_put(dev)) {
+		dev_WARN(dev, "Unbalanced counter decrementation");
+		goto out;
+ 	}
+
+	if (!pm_suspend_possible(dev))
+		goto out;
+
+	/* Do not queue up a notification if one is already in progress. */
+	if ((dev->power.runtime_status & RPM_NOTIFY) || dev->power.runtime_busy)
+		goto out;
+
+	/*
+	 * The notification is asynchronous so that this function can be called
+	 * from interrupt context.
+	 */
+	dev->power.runtime_status = RPM_NOTIFY;
+	dev->power.runtime_break = false;
+	INIT_WORK(&dev->power.work, pm_notify_or_cancel_work);
+	queue_work(pm_wq, &dev->power.work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put);
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
+	unsigned long flags;
+
+	if (status & ~RPM_SUSPENDED)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status != RPM_ERROR)
+		goto out;
+
+	dev->power.runtime_status = status;
+	if (status == RPM_SUSPENDED && parent)
+		__pm_put_child(parent);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_clear_status);
+
+/**
+ * pm_runtime_enable - Enable run-time PM of a device.
+ * @dev: Device to handle.
+ */
+void pm_runtime_enable(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!dev->power.runtime_disabled)
+		goto out;
+
+	if (!__pm_runtime_put(dev))
+		dev_WARN(dev, "Unbalanced counter decrementation");
+
+	if (!atomic_read(&dev->power.resume_count))
+		dev->power.runtime_disabled = false;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_enable);
+
+/**
+ * pm_runtime_disable - Disable run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Set the power.runtime_disabled flag for the device, cancel all pending
+ * run-time PM requests for it and wait for operations in progress to complete.
+ * The device can be either active or suspended after its run-time PM has been
+ * disabled.
+ */
+void pm_runtime_disable(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	__pm_runtime_get(dev);
+
+	if (dev->power.runtime_disabled)
+		goto out;
+
+	dev->power.runtime_disabled = true;
+
+	if ((dev->power.runtime_status & (RPM_WAKE|RPM_NOTIFY))
+	    || dev->power.runtime_busy) {
+		/* Resume request or idle notification pending. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_work_sync(&dev->power.work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		dev->power.runtime_status &= ~(RPM_WAKE|RPM_NOTIFY);
+		dev->power.runtime_busy = false;
+	}
+
+	if (dev->power.runtime_status & RPM_IDLE) {
+		/* Suspend request pending. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		dev->power.runtime_status &= ~RPM_IDLE;
+	} else if (dev->power.runtime_status & (RPM_SUSPENDING|RPM_RESUMING)) {
+		/* Suspend or wake-up in progress. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+		return;
+	}
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
+
+/**
+ * pm_runtime_init - Initialize run-time PM fields in given device object.
+ * @dev: Device object to initialize.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	spin_lock_init(&dev->power.lock);
+
+	dev->power.runtime_status = RPM_ACTIVE;
+	dev->power.runtime_disabled = true;
+	atomic_set(&dev->power.resume_count, 1);
+
+	atomic_set(&dev->power.child_count, 0);
+	pm_suspend_ignore_children(dev, false);
+}
+
+/**
+ * pm_runtime_add - Update run-time PM fields of a device while adding it.
+ * @dev: Device object being added to device hierarchy.
+ */
+void pm_runtime_add(struct device *dev)
+{
+	dev->power.runtime_busy = false;
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend_work);
+
+	if (dev->parent)
+		__pm_get_child(dev->parent);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,136 @@
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
+extern void pm_runtime_add(struct device *dev);
+extern void pm_runtime_put(struct device *dev);
+extern void pm_runtime_idle(struct device *dev);
+extern int __pm_runtime_suspend(struct device *dev, bool sync);
+extern void pm_request_suspend(struct device *dev, unsigned int msec);
+extern int __pm_runtime_resume(struct device *dev, bool sync);
+extern int pm_request_resume(struct device *dev);
+extern void __pm_runtime_clear_status(struct device *dev, unsigned int status);
+extern void pm_runtime_enable(struct device *dev);
+extern void pm_runtime_disable(struct device *dev);
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
+static inline struct device *work_to_device(struct work_struct *work)
+{
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(work, struct dev_pm_info, work);
+	return container_of(dpi, struct device, power);
+}
+
+static inline void __pm_runtime_get(struct device *dev)
+{
+	atomic_inc(&dev->power.resume_count);
+}
+
+static inline bool __pm_runtime_put(struct device *dev)
+{
+	return !!atomic_add_unless(&dev->power.resume_count, -1, 0);
+}
+
+static inline bool pm_children_suspended(struct device *dev)
+{
+	return dev->power.ignore_children
+		|| !atomic_read(&dev->power.child_count);
+}
+
+static inline bool pm_suspend_possible(struct device *dev)
+{
+	return pm_children_suspended(dev)
+		&& !atomic_read(&dev->power.resume_count)
+		&& !(dev->power.runtime_status & ~RPM_NOTIFY)
+		&& !dev->power.runtime_disabled;
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
+static inline void pm_runtime_add(struct device *dev) {}
+static inline void pm_runtime_put(struct device *dev) {}
+static inline void pm_runtime_idle(struct device *dev) {}
+static inline int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline void pm_request_suspend(struct device *dev, unsigned int msec) {}
+static inline int __pm_runtime_resume(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline int pm_request_resume(struct device *dev) { return -ENOSYS; }
+static inline void __pm_runtime_clear_status(struct device *dev,
+					      unsigned int status) {}
+static inline void pm_runtime_enable(struct device *dev) {}
+static inline void pm_runtime_disable(struct device *dev) {}
+
+static inline void __pm_runtime_get(struct device *dev) {}
+static inline bool __pm_runtime_put(struct device *dev) { return true; }
+static inline bool pm_children_suspended(struct device *dev) { return false; }
+static inline bool pm_suspend_possible(struct device *dev) { return false; }
+static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+static inline void pm_runtime_get(struct device *dev)
+{
+	__pm_runtime_get(dev);
+}
+
+static inline int pm_runtime_suspend(struct device *dev)
+{
+	return __pm_runtime_suspend(dev, true);
+}
+
+static inline int pm_runtime_resume(struct device *dev)
+{
+	return __pm_runtime_resume(dev, true);
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
+static inline void pm_runtime_remove(struct device *dev)
+{
+	pm_runtime_disable(dev);
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
@@ -49,6 +50,16 @@ static DEFINE_MUTEX(dpm_list_mtx);
 static bool transition_started;
 
 /**
+ * device_pm_init - Initialize the PM-related part of a device object
+ * @dev: Device object to initialize.
+ */
+void device_pm_init(struct device *dev)
+{
+	dev->power.status = DPM_ON;
+	pm_runtime_init(dev);
+}
+
+/**
  *	device_pm_lock - lock the list of active devices used by the PM core
  */
 void device_pm_lock(void)
@@ -88,6 +99,7 @@ void device_pm_add(struct device *dev)
 	}
 
 	list_add_tail(&dev->power.entry, &dpm_list);
+	pm_runtime_add(dev);
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -104,6 +116,7 @@ void device_pm_remove(struct device *dev
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
+	pm_runtime_remove(dev);
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -507,6 +520,7 @@ static void dpm_complete(pm_message_t st
 		get_device(dev);
 		if (dev->power.status > DPM_ON) {
 			dev->power.status = DPM_ON;
+			pm_runtime_enable(dev);
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
@@ -753,6 +767,7 @@ static int dpm_prepare(pm_message_t stat
 
 		get_device(dev);
 		dev->power.status = DPM_PREPARING;
+		pm_runtime_disable(dev);
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);
@@ -760,6 +775,7 @@ static int dpm_prepare(pm_message_t stat
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
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -1,8 +1,3 @@
-static inline void device_pm_init(struct device *dev)
-{
-	dev->power.status = DPM_ON;
-}
-
 #ifdef CONFIG_PM_SLEEP
 
 /*
@@ -16,14 +11,16 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
+extern void device_pm_init(struct device *dev);
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern void device_pm_move_before(struct device *, struct device *);
 extern void device_pm_move_after(struct device *, struct device *);
 extern void device_pm_move_last(struct device *);
 
-#else /* CONFIG_PM_SLEEP */
+#else /* !CONFIG_PM_SLEEP */
 
+static inline void device_pm_init(struct device *dev) {}
 static inline void device_pm_add(struct device *dev) {}
 static inline void device_pm_remove(struct device *dev) {}
 static inline void device_pm_move_before(struct device *deva,
@@ -32,7 +29,7 @@ static inline void device_pm_move_after(
 					struct device *devb) {}
 static inline void device_pm_move_last(struct device *dev) {}
 
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM
 
