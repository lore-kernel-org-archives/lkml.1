Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZFVXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZFVXVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFVXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:21:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZFVXVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:21:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 3)
Date: Tue, 23 Jun 2009 01:21:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230121.18932.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below is a new revision of the patch introducing the run-time PM framework.

The most visible changes from the last version:

* I realized that if child_count is atomic, we can drop the parent locking from
  all of the functions, so I did that.

* Introduced pm_runtime_put() that decrements the resume counter and queues
  up an idle notification if the counter went down to 0 (and wasn't 0 previously).
  Using asynchronous notification makes it possible to call pm_runtime_put()
  from interrupt context, if necessary.

* Changed the meaning of the RPM_WAKE bit slightly (it is now also used for
  disabling run-time PM for a device along with the resume counter).

Please let me know if I've overlooked anything. :-)

Best,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 3)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  434 ++++++++++++++++++++++
 drivers/base/dd.c                  |    9 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |   16 
 drivers/base/power/power.h         |   11 
 drivers/base/power/runtime.c       |  711 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   96 ++++
 include/linux/pm_runtime.h         |  141 +++++++
 kernel/power/Kconfig               |   14 
 kernel/power/main.c                |   17 
 10 files changed, 1440 insertions(+), 10 deletions(-)

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
@@ -315,14 +343,76 @@ enum dpm_state {
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
+	unsigned int		notify_running:1;
+	unsigned int		runtime_status:5;
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
@@ -0,0 +1,711 @@
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
+		dev_warn(dev, "Unbalanced %s!\n", __func__);
+}
+
+/**
+ * pm_runtime_notify_idle - Run a device bus type's runtime_idle() callback.
+ * @dev: Device to notify.
+ */
+static void pm_runtime_notify_idle(struct device *dev)
+{
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+}
+
+/**
+ * pm_runtime_notify_work - Run pm_runtime_notify_idle() for a device.
+ *
+ * Use @work to get the device object to run the notification for and execute
+ * pm_runtime_notify_idle().
+ */
+static void pm_runtime_notify_work(struct work_struct *work)
+{
+	struct device *dev = resume_work_to_device(work);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	dev->power.runtime_status &= ~RPM_WAKE;
+	dev->power.notify_running = true;
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	pm_runtime_notify_idle(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	dev->power.notify_running = false;
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+
+/**
+ * pm_runtime_put - Decrement the resume counter and run idle notification.
+ * @dev: Device to handle.
+ *
+ * Decrement the resume counter of the device, check if it is possible to
+ * suspend it and notify its bus type in that case.
+ */
+void pm_runtime_put(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!__pm_runtime_put(dev)) {
+		dev_warn(dev, "Unbalanced %s!\n", __func__);
+		goto out;
+	}
+
+	if (!pm_suspend_possible(dev))
+		goto out;
+
+	/* Do not schedule a notification if one is already in progress. */
+	if ((dev->power.runtime_status & RPM_WAKE) || dev->power.notify_running)
+		goto out;
+
+	/*
+	 * The notification is asynchronous, so that this function can be called
+	 * from interrupt context.  Set the run-time PM status to RPM_WAKE to
+	 * prevent resume_work from being reused for a resume request and to let
+	 * pm_runtime_close() know it has a request to cancel.  It also prevents
+	 * suspends from running or being scheduled until the work function is
+	 * executed.
+	 */
+	dev->power.runtime_status = RPM_WAKE;
+	INIT_WORK(&dev->power.resume_work, pm_runtime_notify_work);
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_put);
+
+/**
+ * pm_runtime_idle - Check if device can be suspended and notify its bus type.
+ * @dev: Device to check.
+ */
+void pm_runtime_idle(struct device *dev)
+{
+	if (pm_suspend_possible(dev))
+		pm_runtime_notify_idle(dev);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_idle);
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
+	    || (dev->power.runtime_status & (RPM_WAKE | RPM_RESUMING))
+	    || (!sync && (dev->power.runtime_status & RPM_IDLE)
+	    && dev->power.suspend_aborted)) {
+		/*
+		 * We're forbidden to suspend the device (eg. it may be
+		 * resuming) or a pending suspend request has just been
+		 * cancelled and we're running as a result of that request.
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
+		/* Repeat if anyone else has cleared the status. */
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
+		if (!atomic_read(&parent->power.resume_count)
+		    && !atomic_read(&parent->power.child_count)
+		    && !parent->power.ignore_children)
+			pm_runtime_notify_idle(parent);
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
+	__pm_runtime_get(dev);
+
+ repeat:
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+ repeat_locked:
+	if (dev->power.runtime_status == RPM_ERROR) {
+		goto out;
+	} else if (dev->power.runtime_status & ~RPM_WAKE) {
+		/*
+		 * If RPM_WAKE is the only bit set in runtime_status, an idle
+		 * notification is scheduled for the device which is active.
+		 */
+		error = 0;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_IDLE
+	    && !dev->power.suspend_aborted) {
+		/* Suspend request is pending, so cancel it. */
+		dev->power.suspend_aborted = true;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+		/* Repeat if anyone else has cleared the status. */
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
+		/* Resume request is pending, so let it run. */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
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
+
+		wait_for_completion(&dev->power.work_done);
+
+		goto repeat;
+	} else if (!put_parent && parent
+	    && dev->power.runtime_status == RPM_SUSPENDED) {
+		/*
+		 * Increase the parent's resume counter and request that it be
+		 * woken up if necessary.
+		 */
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		error = pm_runtime_resume(parent);
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
+
+	dev->power.runtime_status = RPM_RESUMING;
+	init_completion(&dev->power.work_done);
+
+ unlock:
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
+
+	if (put_parent)
+		__pm_runtime_put(parent);
+
+ out_put:
+	/*
+	 * If we're running from pm_wq, the resume counter has been incremented
+	 * by pm_request_resume() too, so decrement it.
+	 */
+	if (error || !sync)
+		__pm_runtime_put(dev);
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
+	__pm_runtime_resume(resume_work_to_device(work), false);
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
+	/* Return if someone else has already dealt with the suspend request. */
+	if (dev->power.runtime_status != (RPM_IDLE | RPM_WAKE)
+	    || !dev->power.suspend_aborted)
+		goto out;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	cancel_delayed_work_sync(&dev->power.suspend_work);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* Clear the status if someone else hasn't done it already. */
+	if (dev->power.runtime_status == (RPM_IDLE | RPM_WAKE)
+	    && dev->power.suspend_aborted)
+		dev->power.runtime_status = RPM_ACTIVE;
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+
+/**
+ * __pm_request_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ * @get: If set, always increment the device's resume counter.
+ *
+ * Schedule run-time resume of given device and increment its resume counter.
+ * If @get is set, the counter is incremented even if error code is going to be
+ * returned, and if it's unset, the counter is only incremented if resume
+ * request has been queued up (0 is returned in such a case).
+ */
+int __pm_request_resume(struct device *dev, bool get)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	int error = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (get)
+		__pm_runtime_get(dev);
+
+	if (dev->power.runtime_status == RPM_ERROR)
+		error = -EINVAL;
+	else if (dev->power.runtime_status & ~RPM_WAKE)
+		error = -EBUSY;
+	else if (dev->power.runtime_status & (RPM_WAKE | RPM_RESUMING))
+		error = -EINPROGRESS;
+	if (error)
+		goto out;
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
+	INIT_WORK(&dev->power.resume_work, pm_runtime_resume_work);
+	if (!get)
+		__pm_runtime_get(dev);
+
+ queue:
+	/*
+	 * The device may be suspending at the moment or there may be a resume
+	 * request pending for it and we can't clear the RPM_SUSPENDING and
+	 * RPM_IDLE bits in its runtime_status just yet.
+	 */
+	dev->power.runtime_status |= RPM_WAKE;
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_request_resume);
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
+	if (dev->power.runtime_status != RPM_ERROR) {
+		dev->power.runtime_status = RPM_ACTIVE;
+		if (dev->parent)
+			__pm_put_child(dev->parent);
+	}
+	__pm_runtime_put(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_enable);
+
+/**
+ * pm_runtime_disable - Disable run-time PM of a device.
+ * @dev: Device to handle.
+ */
+void pm_runtime_disable(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	do {
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		pm_runtime_resume(dev);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+
+	} while (!__pm_runtime_put(dev));
+
+	if (dev->power.runtime_status == RPM_ERROR) {
+		dev->power.runtime_status = RPM_WAKE;
+		if (dev->parent)
+			__pm_get_child(dev->parent);
+	}
+	__pm_runtime_get(dev);
+
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
+	/*
+	 * Make any attempts to suspend the device or resume it, or to put a
+	 * request for it into pm_wq terminate immediately.
+	 */
+	dev->power.runtime_status = RPM_WAKE;
+	atomic_set(&dev->power.resume_count, 1);
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
+	dev->power.notify_running = false;
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend_work);
+
+	if (dev->parent)
+		__pm_get_child(dev->parent);
+}
+
+/**
+ * pm_runtime_remove - Prepare for the removal of a device object.
+ * @dev: Device object being removed.
+ */
+void pm_runtime_remove(struct device *dev)
+{
+	unsigned long flags;
+	unsigned int status;
+
+	/* This makes __pm_runtime_suspend() return immediately. */
+	__pm_runtime_get(dev);
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	/* Cancel any pending requests. */
+	if ((dev->power.runtime_status & RPM_WAKE)
+	    || dev->power.notify_running) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_work_sync(&dev->power.resume_work);
+	} else if (dev->power.runtime_status == RPM_IDLE) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		cancel_delayed_work_sync(&dev->power.suspend_work);
+	}
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	while (dev->power.runtime_status & (RPM_SUSPENDING | RPM_RESUMING)) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+
+		wait_for_completion(&dev->power.work_done);
+
+		spin_lock_irqsave(&dev->power.lock, flags);
+	}
+	status = dev->power.runtime_status;
+
+	/* This makes the run-time PM functions above return immediately. */
+	dev->power.runtime_status = RPM_WAKE;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (status != RPM_SUSPENDED && dev->parent)
+		__pm_put_child(dev->parent);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,141 @@
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
+extern void pm_runtime_put(struct device *dev);
+extern void pm_runtime_idle(struct device *dev);
+extern int __pm_runtime_suspend(struct device *dev, bool sync);
+extern void pm_request_suspend(struct device *dev, unsigned int msec);
+extern int __pm_runtime_resume(struct device *dev, bool sync);
+extern int __pm_request_resume(struct device *dev, bool get);
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
+static inline struct device *resume_work_to_device(struct work_struct *work)
+{
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(work, struct dev_pm_info, resume_work);
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
+static inline void pm_runtime_add(struct device *dev) {}
+static inline void pm_runtime_remove(struct device *dev) {}
+static inline void pm_runtime_put(struct device *dev) {}
+static inline void pm_runtime_idle(struct device *dev) {}
+static inline void pm_runtime_put_notify(struct device *dev) {}
+static inline int __pm_runtime_suspend(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline void pm_request_suspend(struct device *dev, unsigned int msec) {}
+static inline int __pm_runtime_resume(struct device *dev, bool sync)
+{
+	return -ENOSYS;
+}
+static inline int __pm_request_resume(struct device *dev, bool get)
+{
+	return -ENOSYS;
+}
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
 
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -0,0 +1,434 @@
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
+* void pm_runtime_put(struct device *dev);
+* void pm_runtime_idle(struct device *dev);
+* int pm_runtime_suspend(struct device *dev);
+* void pm_request_suspend(struct device *dev, unsigned int msec);
+* int pm_runtime_resume(struct device *dev);
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
+in drivers/base/core.c:device_initialize().
+
+pm_runtime_add() updates the run-time PM fields in the 'power' member of a
+device object while the device is being added to the device hierarchy.  It is
+called from drivers/base/power/main.c:device_pm_add().
+
+pm_runtime_remove() disables the run-time PM of a device and updates the 'power'
+member of its parent's device object to take the removal of the device into
+account.  It cancels all of the run-time PM requests pending and waits for all
+of the run-time PM operations to complete.  It is called from
+drivers/base/power/main.c:device_pm_remove().
+
+pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
+pm_request_resume(), and pm_request_resume_get() use the 'power.runtime_status',
+'power.resume_count', 'power.suspend_aborted', and 'power.child_count' fields of
+'struct device' for mutual cooperation.  In what follows the
+'power.runtime_status', 'power.resume_count', and 'power.child_count' fields are
+referred to as the device's run-time PM status, the device's resume counter, and
+the counter of unsuspended children of the device, respectively.  They are set
+to RPM_WAKE, 1 and 0, respectively, by pm_runtime_init().
+
+pm_runtime_put() decrements the device's resume counter unless it's already 0.
+If the counter was not zero before the decrementation, the function checks if
+the device can be suspended using pm_suspend_possible() and if that returns
+'true', it sets the RPM_WAKE bit in the device's run-time PM status field and
+queues up a request to execute the ->runtime_idle() callback provided by the
+device's bus type.  The work function of this request clears the RPM_WAKE bit
+before executing the bus type's ->runtime_idle() callback.  It is valid to call
+pm_runtime_put() from interrupt context.
+
+It is anticipated that pm_runtime_put() will be called after
+pm_runtime_resume(), pm_request_resume() or pm_request_resume_get(), when all of
+the I/O operations involving the device have been completed, in order to
+decrement the device's resume counter that was previously incremented by one of
+these functions.  Moreover, unbalanced calls to pm_runtime_put() are invalid, so
+drivers should ensure that pm_runtime_put() be only run after a function that
+increments the device's resume counter.
+
+pm_runtime_idle() uses pm_suspend_possible() to check if it is possible to
+suspend a device and if so, it executes the ->runtime_idle() callback provided
+by the device's bus type.
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
+  * If the device's resume counter is greater than 0 or the device is resuming,
+    or it has a resume request pending (i.e. at least one of the RPM_WAKE and
+    RPM_RESUMING bits are set in the device's run-time PM status field), or the
+    function has been called via pm_wq as a result of a cancelled suspend
+    request (the RPM_IDLE bit is set in the device's run-time PM status field
+    and its 'power.suspend_aborted' flag is set), -EAGAIN is returned.
+
+  * If the device is suspending (i.e. the RPM_SUSPENDING bit is set in its
+    run-time PM status field), which means that another instance of
+    __pm_runtime_suspend() is running at the same time for the same device, the
+    function waits for the other instance to complete and returns the result
+    returned by it.
+
+  * If the device has a pending suspend request (i.e. the device's run-time PM
+    status is RPM_IDLE) and the function hasn't been called as a result of that
+    request, it cancels the request (synchronously).  Next, if a concurrent
+    thread changed the device's run-time PM status while the request was being
+    waited for to cancel, the function is restarted.
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
+pm_runtime_resume() is used to increment the resume counter of a device and, if
+necessary, to wake the device up (that happens if the device is suspended,
+suspending or has a suspend request pending).  It is called directly by a bus
+type or device driver, but internally it calls __pm_runtime_resume() that is
+also used for asynchronous resuming of devices (i.e. to complete requests queued
+up by pm_request_resume()).
+
+__pm_runtime_resume() first increments the device's resume counter to prevent
+new suspend requests from being queued up and to make subsequent attempts to
+suspend the device fail.  The device's resume counter will be decremented on
+return if error code is about to be returned or the function has been called via
+pm_wq.  After incrementing the device's run-time PM counter the function
+proceeds as follows.
+
+  * If the device is active (i.e. all of the bits in its run-time PM status are
+    unset, possibly except for RPM_WAKE, which means that an idle notification
+    is pending for it), success is returned.
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
+    its run-time PM status is RPM_SUSPENDED), and it has a parent,
+    pm_runtime_resume() is called (recursively) for the parent.  If the parent's
+    resume is successful, the function notes that the parent's resume counter
+    will have to be decremented and restarts itself.  Otherwise, it returns the
+    error code returned by the instance of pm_runtime_resume_get() handling the
+    parent.
+
+  * If the device is resuming (i.e. the device's run-time PM status is
+    RPM_RESUMING), which means that another instance of __pm_runtime_resume() is
+    running at the same time for the same device, the function waits for the
+    other instance to complete and returns the result returned by it.
+
+If none of the above happens, the function checks if the device's run-time PM
+status is RPM_SUSPENDED, which means that the device doesn't have a resume
+request pending, and if it has a parent.  If that is the case, the parent's
+counter of unsuspended children is incremented.  Next, the device's run-time PM
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
+type's ->runtime_resume() callback.  If the device's bus type doesn't implement
+->runtime_resume(), -EINVAL is returned and the device's run-time PM status is
+set to RPM_ERROR.  If __pm_runtime_resume() returns success and it hasn't been
+called via pm_wq, it leaves the device's resume counter incremented, so the
+counter has to be decremented, with the help of pm_runtime_put(), so that it's
+possible to suspend the device.  If __pm_runtime_resume() has been called via
+pm_wq, as a result of a resume request queued up by pm_request_resume(), the
+device's resume counter is left incremented regardless of whether or not the
+attempt to wake up the device has been successful.
+
+pm_request_resume_get() is used to increment the resume counter of a device
+and, if necessary, to queue up a resume request for the device (this happens if
+the device is suspended, suspending or has a suspend request pending).
+pm_request_resume() is used the to queue up a resume request for the device
+and it increments the device's resume counter if the request has been queued up
+successfully.  Internally both of them call __pm_request_resume() that first
+increments the device's resume counter in the pm_request_resume_get() case and
+then proceeds as follows.
+
+* If the run-time PM status of the device is RPM_ACTIVE or the only bit set in
+  it is RPM_WAKE (i.e. the idle notification has been queued up for the device
+  by pm_runtime_put()), -EBUSY is returned.
+
+* If the device is resuming or has a resume request pending (i.e. at least one
+  of the RPM_WAKE and RPM_RESUMING bits is set in the device's run-time PM
+  status field, but RPM_WAKE is not the only bit set), -EINPROGRESS is returned.
+
+* If the device's run-time status is RPM_IDLE (i.e. a suspend request is pending
+  for it) and the 'power.suspend_aborted' flag is set (i.e. the pending request
+  is being cancelled), -EBUSY is returned.
+
+* If the device's run-time status is RPM_IDLE (i.e. a suspend request is pending
+  for it) and the 'power.suspend_aborted' flag is not set, the device's
+  'power.suspend_aborted' flag is set, a request to cancel the pending
+  suspend request is queued up and -EBUSY is returned.
+
+If none of the above happens, the function checks if the device's run-time PM
+status is RPM_SUSPENDED and if it has a parent, in which case the parent's
+counter of unsuspended children is incremented.  Next, the RPM_WAKE bit is set
+in the device's run-time PM status field and the request to execute
+__pm_runtime_resume() is put into pm_wq (the device's resume counter is then
+incremented in the pm_request_resume() case).  Finally, the function returns 0,
+which means that the resume request has been successfully queued up.
+
+pm_request_resume_get() leaves the device's resume counter incremented even if
+an error code is returned.  Thus, after pm_request_resume_get() has returned, it
+is necessary to decrement the device's resume counter, with the help of
+pm_runtime_put(), before it's possible to suspend the device again.
+
+It is valid to call pm_request_resume() and pm_request_resume_get() from
+interrupt context.
+
+Note that it usually is _not_ safe to access the device for I/O purposes
+immediately after pm_request_resume() has returned, unless the returned result
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
+particular moment.  It checks the device's resume counter, the counter of
+unsuspended children, and the run-time PM status.  It returns 'false' if any of
+the counters is greater than 0 or the RPM_WAKE bit is set in the device's
+run-time PM status field.  Otherwise, 'true' is returned.
+
+pm_runtime_enable() and pm_runtime_disable() are used to enable and disable,
+respectively, all of the run-time PM core operations.  For this purpose
+pm_runtime_disable() calls pm_runtime_resume() to put the device into the
+active state, sets the RPM_WAKE bit in the device's run-time PM status field
+and increments the device's resume counter.  In turn, pm_runtime_enable() resets
+the RPM_WAKE bit and decrements the device's resume counter.  Therefore, if
+pm_runtime_disable() is called several times in a row for the same device, it
+has to be balanced by the appropriate number of pm_runtime_enable() calls so
+that the other run-time PM core functions work for that device.  The initial
+values of the device's resume counter and run-time PM status, as set by
+pm_runtime_init(), are 1 and RPM_WAKE, respectively (i.e. the device's run-time
+PM is initially disabled).
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
+field from RPM_ERROR to RPM_SUSPENDED.  If the device has a parent, the function
+additionally decrements the parent's counter of unsuspended children, although
+the parent's bus type is not notified if the counter becomes 0.  It is valid to
+call this function from interrupt context.
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
+type of the device being suspended.  The bus type's callback is then _entirely_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's ->runtime_suspend() callback (from the PM
+core's point of view it is not necessary to implement a ->runtime_suspend()
+callback in a device driver as long as the bus type's ->runtime_suspend() knows
+what to do to handle the device).
+
+  * Once the bus type's ->runtime_suspend() callback has returned successfully,
+    the PM core regards the device as suspended, which need not mean that the
+    device has been put into a low power state.  It is supposed to mean,
+    however, that the device will not communicate with the CPU(s) and RAM until
+    the bus type's ->runtime_resume() callback is executed for it.
+
+  * If the bus type's ->runtime_suspend() callback returns -EBUSY or -EAGAIN,
+    the device's run-time PM status is set to RPM_ACTIVE, which means that the
+    device _must_ be fully operational one this has happened.
+
+  * If the bus type's ->runtime_suspend() callback returns an error code
+    different from -EBUSY or -EAGAIN, the PM core regards this as an
+    unrecoverable error and will refuse to run the helper functions described in
+    Section 1 until the status is changed with the help of either
+    pm_runtime_clear_active(), or pm_runtime_clear_suspended() by the device's
+    bus type or driver.
+
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
+type of the device being woken up.  The bus type's callback is then _entirely_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's ->runtime_resume() callback (from the PM
+core's point of view it is not necessary to implement a ->runtime_resume()
+callback in a device driver as long as the bus type's ->runtime_resume() knows
+what to do to handle the device).
+
+  * Once the bus type's ->runtime_resume() callback has returned successfully,
+    the PM core regards the device as fully operational, which means that the
+    device _must_ be able to complete I/O operations as needed.
+
+  * If the bus type's ->runtime_resume() callback returns an error code, the PM
+    core regards this as an unrecoverable error and will refuse to run the
+    helper functions described in Section 1 until the status is changed with the
+    help of either pm_runtime_clear_active(), or pm_runtime_clear_suspended() by
+    the device's bus type or driver.
+
+The ->runtime_idle() callback is executed by pm_runtime_suspend() for the bus
+type of a device the children of which are all suspended (and which has the
+'power.ignore_children' flag unset).  It also is executed if a device's resume
+counter is decremented with the help of pm_runtime_put() and it becomes 0.  The
+action carried out by this callback is totally dependent on the bus type in
+question, but the expected and recommended action is to check if the device can
+be suspended (i.e. if all of the conditions necessary for suspending the device
+are met) and to queue up a suspend request for the device if that is the case.
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
 
