Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZF0Vvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZF0Vvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZF0Vvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 17:51:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZF0Vva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:51:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 7)
Date: Sat, 27 Jun 2009 23:51:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906271042450.12287-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906271042450.12287-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906272351.26489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 June 2009, Alan Stern wrote:
> On Sat, 27 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > Speaking of races, have you noticed that the way power.work_done gets 
> > > used is racy?
> > 
> > Not really. :-)
> > 
> > > You can't wait for the completion before releasing the 
> > > lock, but then anything could happen.
> > > 
> > > A safer approach would be to use a wait_queue.
> > 
> > I'm not sure what you mean exactly.  What's the race?
> 
> Come to think of it, there really is a problem here.  Because the
> wait_for_completion call occurs outside the spinlock, it can race with
> the init_completion call.

I don't really think it can, because if either __pm_runtime_suspend(), or
__pm_runtime_resume() finds RPM_SUSPENDING set in the status, it will wait for
the completion and won't reinitialize it until it's been completed.

> It's not good for both of them to run at the same time; the completion's
> internal spinlock and list pointers could get corrupted.

Nevertheless, I reworked the patch to use a wait queue instead of the
completion.  This also helps pm_runtime_disable() to ensure that
->runtime_idle() won't be running after it returns.

> Therefore I stand by my original assertion: The struct completion 
> should be replaced with a wait_queue.  Set the runtime_error field to 
> -EINPROGRESS initially, and make other threads wait until the value 
> changes.

Since runtime_error only changes along with the status, I think it's sufficient
to wait for the status to change.

The updated patch below also addresses some other comments from your previous
messages and from Magnus.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 7)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/dd.c            |   10 
 drivers/base/power/Makefile  |    1 
 drivers/base/power/main.c    |   16 
 drivers/base/power/power.h   |   11 
 drivers/base/power/runtime.c |  846 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |  117 +++++
 include/linux/pm_runtime.h   |  124 ++++++
 kernel/power/Kconfig         |   14 
 kernel/power/main.c          |   17 
 9 files changed, 1145 insertions(+), 11 deletions(-)

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
+	  responsible for the actual handling of the autosuspend requests and
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
+#include <linux/wait.h>
 
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
+ *	off, the device may remain at full power.  If the device does go to low
+ *	power and if device_may_wakeup(dev) is true, remote wake-up (i.e., a
+ *	hardware mechanism allowing the device to request a change of its power
+ *	state, such as PCI PME) should be enabled for it.
+ *
+ * @runtime_resume: Put the device into the fully active state in response to a
+ *	wake-up event generated by hardware or at the request of software.  If
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
@@ -315,14 +343,97 @@ enum dpm_state {
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
+ * RPM_NOTIFY		Idle notification has been scheduled for the device.
+ *
+ * RPM_NOTIFYING	Device bus type's ->runtime_idle() callback is being
+ *			executed (as a result of a scheduled idle notification
+ *			request).
+ *
+ * RPM_IDLE		It has been requested that the device be suspended.
+ *			Suspend request has been put into the run-time PM
+ *			workqueue and it's pending execution.
+ *
+ * RPM_SUSPEND		Attempt to suspend the device has started (as a result
+ *			of a scheduled request or synchronously), but the device
+ *			bus type's ->runtime_suspend() callback has not been
+ *			executed yet.
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
+ * RPM_RESUME		Attempt to wake up the device has started (as a result
+ *			of a scheduled request or synchronously), but the device
+ *			bus type's ->runtime_resume() callback has not been
+ *			executed yet.
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
+
+#define RPM_NOTIFY	0x001
+#define RPM_NOTIFYING	0x002
+#define RPM_IDLE	0x004
+#define RPM_SUSPEND	0x008
+#define RPM_SUSPENDING	0x010
+#define RPM_SUSPENDED	0x020
+#define RPM_WAKE	0x040
+#define RPM_RESUME	0x080
+#define RPM_RESUMING	0x100
+
+#define RPM_ERROR	0x1FF
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
+	wait_queue_head_t	wait_queue;
+	unsigned int		ignore_children:1;
+	unsigned int		runtime_disabled:1;
+	unsigned int		runtime_status;
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
@@ -0,0 +1,846 @@
+/*
+ * drivers/base/power/runtime.c - Helper functions for device run-time PM
+ *
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/sched.h>
+#include <linux/pm_runtime.h>
+#include <linux/jiffies.h>
+
+static struct device *suspend_work_to_device(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+
+	return container_of(dw, struct device, power.suspend_work);
+}
+
+static struct device *pm_work_to_device(struct work_struct *work)
+{
+	return container_of(work, struct device, power.work);
+}
+
+/**
+ * pm_runtime_idle - Notify device bus type if the device can be suspended.
+ * @dev: Device to notify the bus type about.
+ *
+ * It is possible that suspend request was scheduled and resume was requested
+ * before this function has a chance to run.  If there's a suspend request
+ * pending only, return doing nothing, but if resume was requested in addition
+ * to it, cancel the suspend request.
+ */
+void pm_runtime_idle(struct device *dev)
+{
+	unsigned long flags;
+
+	might_sleep();
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR)
+		goto out;
+
+	if (dev->power.runtime_status & ~(RPM_NOTIFY|RPM_WAKE))
+		/*
+		 * Device suspended or run-time PM operation in progress. The
+		 * RPM_NOTIFY bit should have been cleared in that case.
+		 */
+		goto out;
+
+	dev->power.runtime_status &= ~RPM_NOTIFY;
+
+	if (dev->power.runtime_status == RPM_WAKE) {
+		/*
+		 * Resume has been requested, and because all of the suspend
+		 * status bits are clear, there must be a suspend request
+		 * pending (otherwise, the resume request would have been
+		 * rejected).  We have to cancel that request.
+		 */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/*
+		 * Return if someone else has changed the status.  Otherwise,
+		 * the idle notification may still be worth running.
+		 */
+		if (dev->power.runtime_status != RPM_WAKE)
+			goto out;
+	}
+
+	if (!pm_suspend_possible(dev))
+		goto out;
+
+	/*
+	 * The role of the RPM_NOTIFYING bit is to prevent ->runtime_idle() from
+	 * running in parallel with itself and to help pm_runtime_disable() make
+	 * sure that the ->runtime_idle() callback will not be running after it
+	 * returns.
+	 */
+	dev->power.runtime_status = RPM_NOTIFYING;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* The status might have been changed while executing runtime_idle(). */
+	dev->power.runtime_status &= ~RPM_NOTIFYING;
+	wake_up_all(&dev->power.wait_queue);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_idle);
+
+/**
+ * pm_runtime_idle_work - Run pm_runtime_idle() via pm_wq.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the idle notification has been scheduled
+ * for and run pm_runtime_idle() for it.
+ */
+static void pm_runtime_idle_work(struct work_struct *work)
+{
+	pm_runtime_idle(pm_work_to_device(work));
+}
+
+/**
+ * pm_runtime_put_atomic - Decrement resume counter and queue idle notification.
+ * @dev: Device to handle.
+ *
+ * Decrement the device's resume counter, check if the device's run-time PM
+ * status is right for suspending and queue up a request to run
+ * pm_runtime_idle() for it.
+ */
+void pm_runtime_put_atomic(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!__pm_runtime_put(dev)) {
+		dev_WARN(dev, "Unbalanced %s", __func__);
+		goto out;
+	}
+
+	if (dev->power.runtime_status != RPM_ACTIVE)
+		goto out;
+
+	/*
+	 * The notification is asynchronous so that this function can be called
+	 * from interrupt context.
+	 */
+	dev->power.runtime_status = RPM_NOTIFY;
+	INIT_WORK(&dev->power.work, pm_runtime_idle_work);
+	queue_work(pm_wq, &dev->power.work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put_atomic);
+
+/**
+ * pm_runtime_put - Decrement resume counter and run idle notification.
+ * @dev: Device to handle.
+ *
+ * Decrement the device's resume counter and run pm_runtime_idle() for it.
+ */
+void pm_runtime_put(struct device *dev)
+{
+	if (!__pm_runtime_put(dev)) {
+		dev_WARN(dev, "Unbalanced %s", __func__);
+		return;
+	}
+
+	pm_runtime_idle(dev);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put);
+
+/**
+ * __pm_runtime_suspend - Carry out run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the device can be suspended and run the ->runtime_suspend() callback
+ * provided by its bus type.  If another suspend has been started earlier, wait
+ * for it to finish.  If there's an idle notification pending, cancel it.  If
+ * there's a suspend request scheduled while this function is running and @sync
+ * is 'true', cancel that request.
+ */
+int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	struct device *parent = NULL;
+	unsigned long flags;
+	bool cancel_pending = false;
+	int error = -EINVAL;
+
+	might_sleep();
+
+ repeat:
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR)
+		goto out;
+
+	if (dev->power.runtime_status & RPM_SUSPENDED) {
+		/* Device suspended, nothing to do. */
+		error = 0;
+		goto out;
+	}
+
+	if (dev->power.runtime_status & RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		/* Another suspend is running in parallel with us. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!(dev->power.runtime_status & RPM_SUSPENDING))
+				break;
+
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+
+			schedule();
+
+			spin_lock_irqsave(&dev->power.lock, flags);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+		error = dev->power.runtime_error;
+		goto out;
+	}
+
+	if (dev->power.runtime_status & (RPM_WAKE|RPM_RESUME|RPM_RESUMING)) {
+		/* Resume is scheduled or in progress. */
+		error = -EAGAIN;
+		goto out;
+	}
+
+	/*
+	 * If there's a suspend request pending and we're not running as a
+	 * result of it, the request has to be cancelled, because it may be
+	 * scheduled in the future and we can't leave it behind us.
+	 */
+	if (sync && (dev->power.runtime_status & RPM_IDLE))
+		cancel_pending = true;
+
+	/* Clear the suspend status bits in case we have to return. */
+	dev->power.runtime_status &= ~(RPM_IDLE|RPM_SUSPEND);
+
+	if (atomic_read(&dev->power.resume_count) > 0
+	    || dev->power.runtime_disabled) {
+		/* We are forbidden to suspend. */
+		error = -EAGAIN;
+		goto out;
+	}
+
+	if (!pm_children_suspended(dev)) {
+		/*
+		 * We can only suspend the device if all of its children have
+		 * been suspended.
+		 */
+		error = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * Set RPM_SUSPEND in case we have to start over, to prevent idle
+	 * notifications from happening and new suspend requests from being
+	 * scheduled.
+	 */
+	dev->power.runtime_status |= RPM_SUSPEND;
+
+	if (cancel_pending) {
+		/* Cancel the concurrent pending suspend request. */
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+		goto repeat;
+	}
+
+	if (dev->power.runtime_status & RPM_NOTIFY) {
+		/* Idle notification is pending, cancel it. */
+		dev->power.runtime_status &= ~RPM_NOTIFY;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_work_sync(&dev->power.work);
+		goto repeat;
+	}
+
+	dev->power.runtime_status &= ~RPM_SUSPEND;
+	dev->power.runtime_status |= RPM_SUSPENDING;
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
+		dev->power.runtime_status &= ~RPM_SUSPENDING;
+		dev->power.runtime_status |= RPM_SUSPENDED;
+		break;
+	case -EAGAIN:
+	case -EBUSY:
+		dev->power.runtime_status &= RPM_NOTIFYING;
+		break;
+	default:
+		dev->power.runtime_status = RPM_ERROR;
+	}
+	dev->power.runtime_error = error;
+	wake_up_all(&dev->power.wait_queue);
+
+	if (!error && !(dev->power.runtime_status & RPM_WAKE) && dev->parent) {
+		parent = dev->parent;
+		atomic_dec(&parent->power.child_count);
+	}
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (parent && !parent->power.ignore_children)
+		pm_runtime_idle(parent);
+
+	if (error == -EBUSY || error == -EAGAIN)
+		pm_runtime_idle(dev);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_suspend);
+
+/**
+ * pm_runtime_suspend_work - Run __pm_runtime_suspend() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the work has been scheduled for and run
+ * __pm_runtime_suspend() for it.
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
+int pm_request_suspend(struct device *dev, unsigned int msec)
+{
+	unsigned long flags;
+	unsigned long delay = msecs_to_jiffies(msec);
+	int error = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_ERROR)
+		error = -EINVAL;
+	else if (dev->power.runtime_status & RPM_SUSPENDED)
+		/* Device is suspended, nothing to do. */
+		error = -ECANCELED;
+	else if (atomic_read(&dev->power.resume_count) > 0
+	    || dev->power.runtime_disabled
+	    || (dev->power.runtime_status & (RPM_WAKE|RPM_RESUME|RPM_RESUMING)))
+		/* Can't suspend now. */
+		error = -EAGAIN;
+	else if (dev->power.runtime_status &
+				(RPM_IDLE|RPM_SUSPEND|RPM_SUSPENDING))
+		/* Already suspending or suspend request pending. */
+		error = -EINPROGRESS;
+	else if (!pm_children_suspended(dev))
+		error = -EBUSY;
+	if (error)
+		goto out;
+
+	dev->power.runtime_status |= RPM_IDLE;
+	queue_delayed_work(pm_wq, &dev->power.suspend_work, delay);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_request_suspend);
+
+/**
+ * __pm_runtime_resume - Carry out run-time resume of given device.
+ * @dev: Device to resume.
+ * @sync: If unset, the funtion has been called via pm_wq.
+ *
+ * Check if the device can be woken up and run the ->runtime_resume() callback
+ * provided by its bus type.  If another resume has been started earlier, wait
+ * for it to finish.  If there's a suspend running in parallel with this
+ * function, wait for it to finish and resume the device.  If there's a suspend
+ * request or idle notification pending, cancel it.  If there's a resume request
+ * scheduled while this function is running and @sync is 'true', cancel that
+ * request.
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
+	if (dev->power.runtime_status == RPM_ERROR)
+		goto out;
+
+	if (!(dev->power.runtime_status & ~RPM_NOTIFYING)) {
+		/* Device is operational, nothing to do. */
+		error = 0;
+		goto out;
+	}
+
+	if (dev->power.runtime_status & RPM_RESUMING) {
+		DEFINE_WAIT(wait);
+
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete and return.
+		 */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!(dev->power.runtime_status & RPM_RESUMING))
+				break;
+
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+
+			schedule();
+
+			spin_lock_irqsave(&dev->power.lock, flags);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+		error = dev->power.runtime_error;
+		goto out;
+	}
+
+	if (dev->power.runtime_disabled) {
+		/* Clear the resume flags before returning. */
+		dev->power.runtime_status &= ~(RPM_WAKE|RPM_RESUME);
+		error = -EAGAIN;
+		goto out;
+	}
+
+	/*
+	 * Set RPM_RESUME in case we have to start over, to prevent suspends and
+	 * idle notifications from happening and new resume requests from being
+	 * queued up.
+	 */
+	dev->power.runtime_status |= RPM_RESUME;
+
+	if (dev->power.runtime_status & RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		/*
+		 * Suspend is running in parallel with us.  Wait for it to
+		 * complete and repeat.
+		 */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!(dev->power.runtime_status & RPM_SUSPENDING))
+				break;
+
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+
+			schedule();
+
+			spin_lock_irqsave(&dev->power.lock, flags);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+		goto repeat_locked;
+	}
+
+	if ((dev->power.runtime_status & (RPM_IDLE|RPM_WAKE))
+	    && !(dev->power.runtime_status &
+				(RPM_SUSPEND|RPM_SUSPENDING|RPM_SUSPENDED))) {
+		/* Suspend request is pending that we're supposed to cancel. */
+		dev->power.runtime_status &= ~RPM_IDLE;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+		goto repeat;
+	}
+
+	/*
+	 * Clear RPM_SUSPEND in case we've been running in parallel with
+	 * __pm_runtime_suspend().
+	 */
+	dev->power.runtime_status &= ~RPM_SUSPEND;
+
+	if ((sync && (dev->power.runtime_status & RPM_WAKE))
+	    || (dev->power.runtime_status & RPM_NOTIFY)) {
+		/*
+		 * Idle notification is pending and since we're running the
+		 * device is not idle, or there's a resume request pending and
+		 * we're not running as a result of it.  In both cases it's
+		 * better to cancel the request.
+		 */
+		dev->power.runtime_status &= ~(RPM_NOTIFY|RPM_WAKE);
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_work_sync(&dev->power.work);
+		goto repeat;
+	}
+
+	/* Clear the resume status flags in case we have to return. */
+	dev->power.runtime_status &= ~(RPM_WAKE|RPM_RESUME);
+
+	if (!(dev->power.runtime_status & RPM_SUSPENDED)) {
+		/*
+		 * If the device is not suspended at this point, we have
+		 * nothing to do.
+		 */
+		error = 0;
+		goto out;
+	}
+
+	if (!put_parent && parent) {
+		/*
+		 * Increase the parent's resume counter and request that it be
+		 * woken up if necessary.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		put_parent = true;
+		error = pm_runtime_get_and_resume(parent);
+		if (error)
+			goto out_parent;
+
+		error = -EINVAL;
+		dev->power.runtime_status |= RPM_RESUME;
+		goto repeat;
+	}
+
+	dev->power.runtime_status &= ~RPM_SUSPENDED;
+
+	if (parent)
+		atomic_inc(&parent->power.child_count);
+
+	dev->power.runtime_status |= RPM_RESUMING;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
+		error = dev->bus->pm->runtime_resume(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	dev->power.runtime_status &= ~RPM_RESUMING;
+	if (error)
+		dev->power.runtime_status = RPM_ERROR;
+	dev->power.runtime_error = error;
+	wake_up_all(&dev->power.wait_queue);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+ out_parent:
+	if (put_parent)
+		pm_runtime_put(parent);
+
+	if (!error)
+		pm_runtime_idle(dev);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_resume);
+
+/**
+ * pm_runtime_resume_work - Run __pm_runtime_resume() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the work has been scheduled for and run
+ * __pm_runtime_resume() for it.
+ */
+static void pm_runtime_resume_work(struct work_struct *work)
+{
+	__pm_runtime_resume(pm_work_to_device(work), false);
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
+	} else if (!(dev->power.runtime_status & ~RPM_NOTIFYING)) {
+		/* Device is operational, nothing to do. */
+		error = -ECANCELED;
+	} else if (dev->power.runtime_status & RPM_NOTIFY) {
+		/*
+		 * Device has an idle notification pending, which is not a
+		 * problem unless there's a suspend request pending in addition
+		 * to it.  In that case, ask the idle notification work function
+		 * to cancel the suspend request.
+		 */
+		if (dev->power.runtime_status & RPM_IDLE) {
+			dev->power.runtime_status &= ~RPM_IDLE;
+			dev->power.runtime_status |= RPM_WAKE;
+			error = -EALREADY;
+		} else {
+			error = -ECANCELED;
+		}
+	} else if (dev->power.runtime_status &
+				(RPM_WAKE|RPM_RESUME|RPM_RESUMING)) {
+		error = -EINPROGRESS;
+	}
+	if (error)
+		goto out;
+
+	if (dev->power.runtime_status & RPM_IDLE) {
+		/* Suspend request is pending.  Make sure it won't run. */
+		dev->power.runtime_status &= ~RPM_IDLE;
+		INIT_WORK(&dev->power.work, pm_runtime_idle_work);
+		error = -EALREADY;
+		goto queue;
+	}
+
+	if ((dev->power.runtime_status & RPM_SUSPENDED) && parent)
+		atomic_inc(&parent->power.child_count);
+
+	INIT_WORK(&dev->power.work, pm_runtime_resume_work);
+
+ queue:
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
+ * __pm_runtime_set_status - Set run-time PM status of a device.
+ * @dev: Device to handle.
+ * @status: New run-time PM status of the device.
+ *
+ * If run-time PM of the device is disabled or its run-time PM status is
+ * RPM_ERROR, the status may be set either to RPM_ACTIVE, or to RPM_SUSPENDED,
+ * as long as that reflects the actual state of the device.
+ */
+void __pm_runtime_set_status(struct device *dev, unsigned int status)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+
+	if (status & ~RPM_SUSPENDED)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == status)
+		goto out;
+
+	if (dev->power.runtime_status != RPM_ERROR
+	    && !dev->power.runtime_disabled)
+		goto out;
+
+	if (parent) {
+		if (status == RPM_SUSPENDED)
+			atomic_dec(&parent->power.child_count);
+		else if (dev->power.runtime_status == RPM_SUSPENDED)
+			atomic_inc(&parent->power.child_count);
+	}
+	dev->power.runtime_status = status;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_set_status);
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
+		dev_WARN(dev, "Unbalanced %s", __func__);
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
+	pm_runtime_get(dev);
+
+	if (dev->power.runtime_disabled)
+		goto out;
+
+	dev->power.runtime_disabled = true;
+
+	if (dev->power.runtime_status != RPM_ERROR
+	    && (dev->power.runtime_status & (RPM_IDLE|RPM_WAKE))
+	    && !(dev->power.runtime_status &
+				(RPM_SUSPEND|RPM_SUSPENDING|RPM_SUSPENDED))) {
+		/* Suspend request pending. */
+		dev->power.runtime_status &= ~RPM_IDLE;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+	}
+
+	if (dev->power.runtime_status != RPM_ERROR
+	    && (dev->power.runtime_status & (RPM_WAKE|RPM_NOTIFY))) {
+		/* Resume request or idle notification pending. */
+		dev->power.runtime_status &= ~(RPM_WAKE|RPM_NOTIFY);
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_work_sync(&dev->power.work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+	}
+
+	if (dev->power.runtime_status != RPM_ERROR
+	    && (dev->power.runtime_status & (RPM_SUSPENDING|RPM_RESUMING))) {
+		DEFINE_WAIT(wait);
+
+		/* Suspend or wake-up in progress. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!(dev->power.runtime_status &
+					(RPM_SUSPENDING|RPM_RESUMING)))
+				break;
+
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+
+			schedule();
+
+			spin_lock_irqsave(&dev->power.lock, flags);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+	}
+
+	if (dev->power.runtime_status != RPM_ERROR
+	    && (dev->power.runtime_status & RPM_NOTIFYING)) {
+		DEFINE_WAIT(wait);
+
+		/* Idle notification in progress. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!(dev->power.runtime_status & RPM_NOTIFYING))
+				break;
+
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+
+			schedule();
+
+			spin_lock_irqsave(&dev->power.lock, flags);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
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
+
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend_work);
+	init_waitqueue_head(&dev->power.wait_queue);
+}
+
+/**
+ * pm_runtime_add - Update run-time PM fields of a device while adding it.
+ * @dev: Device object being added to device hierarchy.
+ */
+void pm_runtime_add(struct device *dev)
+{
+	if (dev->parent)
+		atomic_inc(&dev->parent->power.child_count);
+}
+
+/**
+ * pm_runtime_remove - Prepare for removing a device from device hierarchy.
+ * @dev: Device object being removed from device hierarchy.
+ */
+void pm_runtime_remove(struct device *dev)
+{
+	struct device *parent = dev->parent;
+
+	pm_runtime_disable(dev);
+
+	if (dev->power.runtime_status != RPM_SUSPENDED && parent) {
+		atomic_dec(&parent->power.child_count);
+		if (!parent->power.ignore_children)
+			pm_runtime_idle(parent);
+	}
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,124 @@
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
+extern void pm_runtime_remove(struct device *dev);
+extern void pm_runtime_idle(struct device *dev);
+extern void pm_runtime_put_atomic(struct device *dev);
+extern void pm_runtime_put(struct device *dev);
+extern int __pm_runtime_suspend(struct device *dev, bool sync);
+extern int pm_request_suspend(struct device *dev, unsigned int msec);
+extern int __pm_runtime_resume(struct device *dev, bool sync);
+extern int pm_request_resume(struct device *dev);
+extern void __pm_runtime_set_status(struct device *dev, unsigned int status);
+extern void pm_runtime_enable(struct device *dev);
+extern void pm_runtime_disable(struct device *dev);
+
+static inline void pm_runtime_get(struct device *dev)
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
+static inline void pm_runtime_remove(struct device *dev) {}
+static inline void pm_runtime_idle(struct device *dev) {}
+static inline void pm_runtime_put_atomic(struct device *dev) {}
+static inline void pm_runtime_put(struct device *dev) {}
+static inline int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline int pm_request_suspend(struct device *dev, unsigned int msec)
+{
+	return -ENOSYS;
+}
+static inline int __pm_runtime_resume(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline int pm_request_resume(struct device *dev)
+{
+	return -ENOSYS;
+}
+static inline void __pm_runtime_set_status(struct device *dev,
+					    unsigned int status) {}
+static inline void pm_runtime_enable(struct device *dev) {}
+static inline void pm_runtime_disable(struct device *dev) {}
+
+static inline void pm_runtime_get(struct device *dev) {}
+static inline bool __pm_runtime_put(struct device *dev) { return true; }
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
+	return __pm_runtime_resume(dev, true);
+}
+
+static inline int pm_runtime_get_and_resume(struct device *dev)
+{
+	pm_runtime_get(dev);
+	return __pm_runtime_resume(dev, true);
+}
+
+static inline void pm_runtime_set_active(struct device *dev)
+{
+	__pm_runtime_set_status(dev, RPM_ACTIVE);
+}
+
+static inline void pm_runtime_set_suspended(struct device *dev)
+{
+	__pm_runtime_set_status(dev, RPM_SUSPENDED);
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
@@ -202,7 +203,10 @@ int driver_probe_device(struct device_dr
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
-	ret = really_probe(dev, drv);
+	ret = pm_runtime_get_and_resume(dev);
+	if (!ret)
+		ret = really_probe(dev, drv);
+	__pm_runtime_put(dev);
 
 	return ret;
 }
@@ -306,6 +310,8 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_disable(dev);
+
 		driver_sysfs_remove(dev);
 
 		if (dev->bus)
@@ -324,6 +330,8 @@ static void __device_release_driver(stru
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
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
 
