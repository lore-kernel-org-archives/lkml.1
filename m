Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZHMU4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZHMU4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZHMU4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:56:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZHMU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:56:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH update 2x] PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
Date: Thu, 13 Aug 2009 22:56:42 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl>
In-Reply-To: <200908092313.05541.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132256.42941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 16)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Special thanks to Alan Stern for his help with the design and
multiple detailed reviews of the pereceding versions of this patch
and to Magnus Damm for testing feedback.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  378 +++++++++++++
 drivers/base/dd.c                  |   11 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |   22 
 drivers/base/power/power.h         |   31 -
 drivers/base/power/runtime.c       | 1011 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |  101 +++
 include/linux/pm_runtime.h         |  114 ++++
 kernel/power/Kconfig               |   14 
 kernel/power/main.c                |   17 
 10 files changed, 1689 insertions(+), 11 deletions(-)

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
@@ -22,6 +22,10 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/timer.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -165,6 +169,28 @@ typedef struct pm_message {
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
@@ -182,6 +208,9 @@ struct dev_pm_ops {
 	int (*thaw_noirq)(struct device *dev);
 	int (*poweroff_noirq)(struct device *dev);
 	int (*restore_noirq)(struct device *dev);
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+	void (*runtime_idle)(struct device *dev);
 };
 
 /*
@@ -329,14 +358,80 @@ enum dpm_state {
 	DPM_OFF_IRQ,
 };
 
+/**
+ * Device run-time power management status.
+ *
+ * These status labels are used internally by the PM core to indicate the
+ * current status of a device with respect to the PM core operations.  They do
+ * not reflect the actual power state of the device or its status as seen by the
+ * driver.
+ *
+ * RPM_ACTIVE		Device is fully operational.  Indicates that the device
+ *			bus type's ->runtime_resume() callback has completed
+ *			successfully.
+ *
+ * RPM_SUSPENDED	Device bus type's ->runtime_suspend() callback has
+ *			completed successfully.  The device is regarded as
+ *			suspended.
+ *
+ * RPM_RESUMING		Device bus type's ->runtime_resume() callback is being
+ *			executed.
+ *
+ * RPM_SUSPENDING	Device bus type's ->runtime_suspend() callback is being
+ *			executed.
+ */
+
+enum rpm_status {
+	RPM_ACTIVE = 0,
+	RPM_RESUMING,
+	RPM_SUSPENDED,
+	RPM_SUSPENDING,
+};
+
+/**
+ * Device run-time power management request types.
+ *
+ * RPM_REQ_NONE		Do nothing.
+ *
+ * RPM_REQ_IDLE		Run the device bus type's ->runtime_idle() callback
+ *
+ * RPM_REQ_SUSPEND	Run the device bus type's ->runtime_suspend() callback
+ *
+ * RPM_REQ_RESUME	Run the device bus type's ->runtime_resume() callback
+ */
+
+enum rpm_request {
+	RPM_REQ_NONE = 0,
+	RPM_REQ_IDLE,
+	RPM_REQ_SUSPEND,
+	RPM_REQ_RESUME,
+};
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
+	struct timer_list	suspend_timer;
+	unsigned long		timer_expires;
+	struct work_struct	work;
+	wait_queue_head_t	wait_queue;
+	spinlock_t		lock;
+	atomic_t		usage_count;
+	atomic_t		child_count;
+	unsigned int		disable_depth:3;
+	unsigned int		ignore_children:1;
+	unsigned int		idle_notification:1;
+	unsigned int		request_pending:1;
+	unsigned int		deferred_resume:1;
+	enum rpm_request	request;
+	enum rpm_status		runtime_status;
+	int			runtime_error;
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
@@ -0,0 +1,1011 @@
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
+static int __pm_runtime_resume(struct device *dev, bool from_wq);
+static int __pm_request_idle(struct device *dev);
+static int __pm_request_resume(struct device *dev);
+
+/**
+ * pm_runtime_deactivate_timer - Deactivate given device's suspend timer.
+ * @dev: Device to handle.
+ */
+static void pm_runtime_deactivate_timer(struct device *dev)
+{
+	if (dev->power.timer_expires > 0) {
+		del_timer(&dev->power.suspend_timer);
+		dev->power.timer_expires = 0;
+	}
+}
+
+/**
+ * pm_runtime_cancel_pending - Deactivate suspend timer and cancel requests.
+ * @dev: Device to handle.
+ */
+static void pm_runtime_cancel_pending(struct device *dev)
+{
+	pm_runtime_deactivate_timer(dev);
+	/*
+	 * In case there's a request pending, make sure its work function will
+	 * return without doing anything.
+	 */
+	dev->power.request = RPM_REQ_NONE;
+}
+
+/**
+ * __pm_runtime_idle - Notify device bus type if the device can be suspended.
+ * @dev: Device to notify the bus type about.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+static int __pm_runtime_idle(struct device *dev)
+	__releases(&dev->power.lock) __acquires(&dev->power.lock)
+{
+	int retval = 0;
+
+	dev_dbg(dev, "__pm_runtime_idle()!\n");
+
+	if (dev->power.runtime_error)
+		retval = -EINVAL;
+	else if (dev->power.idle_notification)
+		retval = -EINPROGRESS;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0
+	    || dev->power.runtime_status != RPM_ACTIVE)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		goto out;
+
+	if (dev->power.request_pending) {
+		/*
+		 * If an idle notification request is pending, cancel it.  Any
+		 * other pending request takes precedence over us.
+		 */
+		if (dev->power.request == RPM_REQ_IDLE) {
+			dev->power.request = RPM_REQ_NONE;
+		} else if (dev->power.request != RPM_REQ_NONE) {
+			retval = -EAGAIN;
+			goto out;
+		}
+	}
+
+	dev->power.idle_notification = true;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle) {
+		spin_unlock_irq(&dev->power.lock);
+
+		dev->bus->pm->runtime_idle(dev);
+
+		spin_lock_irq(&dev->power.lock);
+	}
+
+	dev->power.idle_notification = false;
+	wake_up_all(&dev->power.wait_queue);
+
+ out:
+	dev_dbg(dev, "__pm_runtime_idle() returns %d!\n", retval);
+
+	return retval;
+}
+
+/**
+ * pm_runtime_idle - Notify device bus type if the device can be suspended.
+ * @dev: Device to notify the bus type about.
+ */
+int pm_runtime_idle(struct device *dev)
+{
+	int retval;
+
+	spin_lock_irq(&dev->power.lock);
+	retval = __pm_runtime_idle(dev);
+	spin_unlock_irq(&dev->power.lock);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_idle);
+
+/**
+ * __pm_runtime_suspend - Carry out run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @from_wq: If set, the function has been called via pm_wq.
+ *
+ * Check if the device can be suspended and run the ->runtime_suspend() callback
+ * provided by its bus type.  If another suspend has been started earlier, wait
+ * for it to finish.  If an idle notification or suspend request is pending or
+ * scheduled, cancel it.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+int __pm_runtime_suspend(struct device *dev, bool from_wq)
+	__releases(&dev->power.lock) __acquires(&dev->power.lock)
+{
+	struct device *parent = NULL;
+	bool notify = false;
+	int retval = 0;
+
+	dev_dbg(dev, "__pm_runtime_suspend()%s!\n",
+		from_wq ? " from workqueue" : "");
+
+ repeat:
+	if (dev->power.runtime_error) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	/* Pending resume requests take precedence over us. */
+	if (dev->power.request_pending
+	    && dev->power.request == RPM_REQ_RESUME) {
+		retval = -EAGAIN;
+		goto out;
+	}
+
+	/* Other scheduled or pending requests need to be canceled. */
+	pm_runtime_cancel_pending(dev);
+
+	if (dev->power.runtime_status == RPM_SUSPENDED)
+		retval = 1;
+	else if (dev->power.runtime_status == RPM_RESUMING
+	    || dev->power.disable_depth > 0
+	    || atomic_read(&dev->power.usage_count) > 0)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		goto out;
+
+	if (dev->power.runtime_status == RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		if (from_wq) {
+			retval = -EINPROGRESS;
+			goto out;
+		}
+
+		/* Wait for the other suspend running in parallel with us. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (dev->power.runtime_status != RPM_SUSPENDING)
+				break;
+
+			spin_unlock_irq(&dev->power.lock);
+
+			schedule();
+
+			spin_lock_irq(&dev->power.lock);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+		goto repeat;
+	}
+
+	dev->power.runtime_status = RPM_SUSPENDING;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->bus->pm->runtime_suspend(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
+	} else {
+		retval = -ENOSYS;
+	}
+
+	if (retval) {
+		dev->power.runtime_status = RPM_ACTIVE;
+		pm_runtime_cancel_pending(dev);
+		dev->power.deferred_resume = false;
+
+		if (retval == -EAGAIN || retval == -EBUSY) {
+			notify = true;
+			dev->power.runtime_error = 0;
+		}
+	} else {
+		dev->power.runtime_status = RPM_SUSPENDED;
+
+		if (dev->parent) {
+			parent = dev->parent;
+			atomic_add_unless(&parent->power.child_count, -1, 0);
+		}
+	}
+	wake_up_all(&dev->power.wait_queue);
+
+	if (dev->power.deferred_resume) {
+		dev->power.deferred_resume = false;
+		__pm_runtime_resume(dev, false);
+		retval = -EAGAIN;
+		goto out;
+	}
+
+	if (notify)
+		__pm_runtime_idle(dev);
+
+	if (parent && !parent->power.ignore_children) {
+		spin_unlock_irq(&dev->power.lock);
+
+		pm_request_idle(parent);
+
+		spin_lock_irq(&dev->power.lock);
+	}
+
+ out:
+	dev_dbg(dev, "__pm_runtime_suspend() returns %d!\n", retval);
+
+	return retval;
+}
+
+/**
+ * pm_runtime_suspend - Carry out run-time suspend of given device.
+ * @dev: Device to suspend.
+ */
+int pm_runtime_suspend(struct device *dev)
+{
+	int retval;
+
+	spin_lock_irq(&dev->power.lock);
+	retval = __pm_runtime_suspend(dev, false);
+	spin_unlock_irq(&dev->power.lock);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_suspend);
+
+/**
+ * __pm_runtime_resume - Carry out run-time resume of given device.
+ * @dev: Device to resume.
+ * @from_wq: If set, the function has been called via pm_wq.
+ *
+ * Check if the device can be woken up and run the ->runtime_resume() callback
+ * provided by its bus type.  If another resume has been started earlier, wait
+ * for it to finish.  If there's a suspend running in parallel with this
+ * function, wait for it to finish and resume the device.  Cancel any scheduled
+ * or pending requests.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+int __pm_runtime_resume(struct device *dev, bool from_wq)
+	__releases(&dev->power.lock) __acquires(&dev->power.lock)
+{
+	struct device *parent = NULL;
+	int retval = 0;
+
+	dev_dbg(dev, "__pm_runtime_resume()%s!\n",
+		from_wq ? " from workqueue" : "");
+
+ repeat:
+	if (dev->power.runtime_error) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	pm_runtime_cancel_pending(dev);
+
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		retval = 1;
+	else if (dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+	if (retval)
+		goto out;
+
+	if (dev->power.runtime_status == RPM_RESUMING
+	    || dev->power.runtime_status == RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		if (from_wq) {
+			if (dev->power.runtime_status == RPM_SUSPENDING)
+				dev->power.deferred_resume = true;
+			retval = -EINPROGRESS;
+			goto out;
+		}
+
+		/* Wait for the operation carried out in parallel with us. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (dev->power.runtime_status != RPM_RESUMING
+			    && dev->power.runtime_status != RPM_SUSPENDING)
+				break;
+
+			spin_unlock_irq(&dev->power.lock);
+
+			schedule();
+
+			spin_lock_irq(&dev->power.lock);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+		goto repeat;
+	}
+
+	if (!parent && dev->parent) {
+		/*
+		 * Increment the parent's resume counter and resume it if
+		 * necessary.
+		 */
+		parent = dev->parent;
+		spin_unlock_irq(&dev->power.lock);
+
+		pm_runtime_get_noresume(parent);
+
+		spin_lock_irq(&parent->power.lock);
+		/*
+		 * We can resume if the parent's run-time PM is disabled or it
+		 * is set to ignore children.
+		 */
+		if (!parent->power.disable_depth
+		    && !parent->power.ignore_children) {
+			__pm_runtime_resume(parent, false);
+			if (parent->power.runtime_status != RPM_ACTIVE)
+				retval = -EBUSY;
+		}
+		spin_unlock_irq(&parent->power.lock);
+
+		spin_lock_irq(&dev->power.lock);
+		if (retval)
+			goto out;
+		goto repeat;
+	}
+
+	dev->power.runtime_status = RPM_RESUMING;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->bus->pm->runtime_resume(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
+	} else {
+		retval = -ENOSYS;
+	}
+
+	if (retval) {
+		dev->power.runtime_status = RPM_SUSPENDED;
+		pm_runtime_cancel_pending(dev);
+	} else {
+		dev->power.runtime_status = RPM_ACTIVE;
+		if (parent)
+			atomic_inc(&parent->power.child_count);
+	}
+	wake_up_all(&dev->power.wait_queue);
+
+	if (!retval)
+		__pm_request_idle(dev);
+
+ out:
+	if (parent) {
+		spin_unlock_irq(&dev->power.lock);
+
+		pm_runtime_put(parent);
+
+		spin_lock_irq(&dev->power.lock);
+	}
+
+	dev_dbg(dev, "__pm_runtime_resume() returns %d!\n", retval);
+
+	return retval;
+}
+
+/**
+ * pm_runtime_resume - Carry out run-time resume of given device.
+ * @dev: Device to suspend.
+ */
+int pm_runtime_resume(struct device *dev)
+{
+	int retval;
+
+	spin_lock_irq(&dev->power.lock);
+	retval = __pm_runtime_resume(dev, false);
+	spin_unlock_irq(&dev->power.lock);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_resume);
+
+/**
+ * pm_runtime_work - Universal run-time PM work function.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the work is to be done for, determine what
+ * is to be done and execute the appropriate run-time PM function.
+ */
+static void pm_runtime_work(struct work_struct *work)
+{
+	struct device *dev = container_of(work, struct device, power.work);
+	enum rpm_request req;
+
+	spin_lock_irq(&dev->power.lock);
+
+	if (!dev->power.request_pending)
+		goto out;
+
+	req = dev->power.request;
+	dev->power.request = RPM_REQ_NONE;
+	dev->power.request_pending = false;
+
+	switch (req) {
+	case RPM_REQ_NONE:
+		break;
+	case RPM_REQ_IDLE:
+		__pm_runtime_idle(dev);
+		break;
+	case RPM_REQ_SUSPEND:
+		__pm_runtime_suspend(dev, true);
+		break;
+	case RPM_REQ_RESUME:
+		__pm_runtime_resume(dev, true);
+		break;
+	}
+
+ out:
+	spin_unlock_irq(&dev->power.lock);
+}
+
+/**
+ * __pm_request_idle - Submit an idle notification request for given device.
+ * @dev: Device to handle.
+ *
+ * Check if the device's run-time PM status is correct for suspending the device
+ * and queue up a request to run __pm_runtime_idle() for it.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+static int __pm_request_idle(struct device *dev)
+{
+	int retval = 0;
+
+	if (dev->power.runtime_error)
+		retval = -EINVAL;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0
+	    || dev->power.runtime_status == RPM_SUSPENDED
+	    || dev->power.runtime_status == RPM_SUSPENDING)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		return retval;
+
+	if (dev->power.request_pending) {
+		/* Any requests other then RPM_REQ_IDLE take precedence. */
+		if (dev->power.request == RPM_REQ_NONE)
+			dev->power.request = RPM_REQ_IDLE;
+		else if (dev->power.request != RPM_REQ_IDLE)
+			retval = -EAGAIN;
+		return retval;
+	}
+
+	dev->power.request = RPM_REQ_IDLE;
+	dev->power.request_pending = true;
+	queue_work(pm_wq, &dev->power.work);
+
+	return retval;
+}
+
+/**
+ * pm_request_idle - Submit an idle notification request for given device.
+ * @dev: Device to handle.
+ */
+int pm_request_idle(struct device *dev)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	retval = __pm_request_idle(dev);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_request_idle);
+
+/**
+ * __pm_request_suspend - Submit a suspend request for given device.
+ * @dev: Device to suspend.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+static int __pm_request_suspend(struct device *dev)
+{
+	int retval = 0;
+
+	if (dev->power.runtime_error)
+		return -EINVAL;
+
+	if (dev->power.runtime_status == RPM_SUSPENDED)
+		retval = 1;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+	else if (dev->power.runtime_status == RPM_SUSPENDING)
+		retval = -EINPROGRESS;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval < 0)
+		return retval;
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		/*
+		 * Pending resume requests take precedence over us, but we can
+		 * overtake any other pending request.
+		 */
+		if (dev->power.request == RPM_REQ_RESUME)
+			retval = -EAGAIN;
+		else if (dev->power.request != RPM_REQ_SUSPEND)
+			dev->power.request = retval ?
+						RPM_REQ_NONE : RPM_REQ_SUSPEND;
+		return retval;
+	} else if (retval) {
+		return retval;
+	}
+
+	dev->power.request = RPM_REQ_SUSPEND;
+	dev->power.request_pending = true;
+	queue_work(pm_wq, &dev->power.work);
+
+	return 0;
+}
+
+/**
+ * pm_suspend_timer_fn - Timer function for pm_schedule_suspend().
+ * @data: Device pointer passed by pm_schedule_suspend().
+ *
+ * Check if the time is right and execute __pm_request_suspend() in that case.
+ */
+static void pm_suspend_timer_fn(unsigned long data)
+{
+	struct device *dev = (struct device *)data;
+	unsigned long flags;
+	unsigned long expires;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	expires = dev->power.timer_expires;
+	/* If 'expire' is after 'jiffies' we've been called too early. */
+	if (expires > 0 && !time_after(expires, jiffies)) {
+		dev->power.timer_expires = 0;
+		__pm_request_suspend(dev);
+	}
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+
+/**
+ * pm_schedule_suspend - Set up a timer to submit a suspend request in future.
+ * @dev: Device to suspend.
+ * @delay: Time to wait before submitting a suspend request, in milliseconds.
+ */
+int pm_schedule_suspend(struct device *dev, unsigned int delay)
+{
+	unsigned long flags;
+	int retval = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_error) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (!delay) {
+		retval = __pm_request_suspend(dev);
+		goto out;
+	}
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		/*
+		 * Pending resume requests take precedence over us, but any
+		 * other pending requests have to be canceled.
+		 */
+		if (dev->power.request == RPM_REQ_RESUME) {
+			retval = -EAGAIN;
+			goto out;
+		}
+		dev->power.request = RPM_REQ_NONE;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDED)
+		retval = 1;
+	else if (dev->power.runtime_status == RPM_SUSPENDING)
+		retval = -EINPROGRESS;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		goto out;
+
+	dev->power.timer_expires = jiffies + msecs_to_jiffies(delay);
+	mod_timer(&dev->power.suspend_timer, dev->power.timer_expires);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_schedule_suspend);
+
+/**
+ * pm_request_resume - Submit a resume request for given device.
+ * @dev: Device to resume.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+static int __pm_request_resume(struct device *dev)
+{
+	int retval = 0;
+
+	if (dev->power.runtime_error)
+		return -EINVAL;
+
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		retval = 1;
+	else if (dev->power.runtime_status == RPM_RESUMING)
+		retval = -EINPROGRESS;
+	else if (dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+	if (retval < 0)
+		return retval;
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		/* If non-resume request is pending, we can overtake it. */
+		dev->power.request = retval ? RPM_REQ_NONE : RPM_REQ_RESUME;
+		return retval;
+	} else if (retval) {
+		return retval;
+	}
+
+	dev->power.request = RPM_REQ_RESUME;
+	dev->power.request_pending = true;
+	queue_work(pm_wq, &dev->power.work);
+
+	return retval;
+}
+
+/**
+ * pm_request_resume - Submit a resume request for given device.
+ * @dev: Device to resume.
+ */
+int pm_request_resume(struct device *dev)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	retval = __pm_request_resume(dev);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_request_resume);
+
+/**
+ * __pm_runtime_get - Reference count a device and wake it up, if necessary.
+ * @dev: Device to handle.
+ * @sync: If set and the device is suspended, resume it synchronously.
+ *
+ * Increment the usage count of the device and if it was zero previously,
+ * resume it or submit a resume request for it, depending on the value of @sync.
+ */
+int __pm_runtime_get(struct device *dev, bool sync)
+{
+	int retval = 1;
+
+	if (atomic_add_return(1, &dev->power.usage_count) == 1)
+		retval = sync ? pm_runtime_resume(dev) : pm_request_resume(dev);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_get);
+
+/**
+ * __pm_runtime_put - Decrement the device's usage counter and notify its bus.
+ * @dev: Device to handle.
+ * @sync: If the device's bus type is to be notified, do that synchronously.
+ *
+ * Decrement the usage count of the device and if it reaches zero, carry out a
+ * synchronous idle notification or submit an idle notification request for it,
+ * depending on the value of @sync.
+ */
+int __pm_runtime_put(struct device *dev, bool sync)
+{
+	int retval = 0;
+
+	if (atomic_dec_and_test(&dev->power.usage_count))
+		retval = sync ? pm_runtime_idle(dev) : pm_request_idle(dev);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_put);
+
+/**
+ * __pm_runtime_set_status - Set run-time PM status of a device.
+ * @dev: Device to handle.
+ * @status: New run-time PM status of the device.
+ *
+ * If run-time PM of the device is disabled or its power.runtime_error field is
+ * different from zero, the status may be changed either to RPM_ACTIVE, or to
+ * RPM_SUSPENDED, as long as that reflects the actual state of the device.
+ * However, if the device has a parent and the parent is not active, and the
+ * parent's power.ignore_children flag is unset, the device's status cannot be
+ * set to RPM_ACTIVE, so -EBUSY is returned in that case.
+ *
+ * If successful, __pm_runtime_set_status() clears the power.runtime_error field
+ * and the device parent's counter of unsuspended children is modified to
+ * reflect the new status.  If the new status is RPM_SUSPENDED, an idle
+ * notification request for the parent is submitted.
+ */
+int __pm_runtime_set_status(struct device *dev, unsigned int status)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	bool notify_parent = false;
+	int error = 0;
+
+	if (status != RPM_ACTIVE && status != RPM_SUSPENDED)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!dev->power.runtime_error && !dev->power.disable_depth) {
+		error = -EAGAIN;
+		goto out;
+	}
+
+	if (dev->power.runtime_status == status)
+		goto out_set;
+
+	if (status == RPM_SUSPENDED) {
+		/* It always is possible to set the status to 'suspended'. */
+		if (parent) {
+			atomic_add_unless(&parent->power.child_count, -1, 0);
+			notify_parent = !parent->power.ignore_children;
+		}
+		goto out_set;
+	}
+
+	if (parent) {
+		spin_lock_irq(&parent->power.lock);
+
+		/*
+		 * It is invalid to put an active child under a parent that is
+		 * not active, has run-time PM enabled and the
+		 * 'power.ignore_children' flag unset.
+		 */
+		if (!parent->power.disable_depth
+		    && !parent->power.ignore_children
+		    && parent->power.runtime_status != RPM_ACTIVE) {
+			error = -EBUSY;
+		} else {
+			if (dev->power.runtime_status == RPM_SUSPENDED)
+				atomic_inc(&parent->power.child_count);
+		}
+
+		spin_unlock_irq(&parent->power.lock);
+
+		if (error)
+			goto out;
+	}
+
+ out_set:
+	dev->power.runtime_status = status;
+	dev->power.runtime_error = 0;
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	if (notify_parent)
+		pm_request_idle(parent);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(__pm_runtime_set_status);
+
+/**
+ * __pm_runtime_barrier - Cancel pending requests and wait for completions.
+ * @dev: Device to handle.
+ *
+ * Flush all pending requests for the device from pm_wq and wait for all
+ * run-time PM operations involving the device in progress to complete.
+ *
+ * Should be called under dev->power.lock with interrupts disabled.
+ */
+static void __pm_runtime_barrier(struct device *dev)
+{
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		dev->power.request = RPM_REQ_NONE;
+		spin_unlock_irq(&dev->power.lock);
+
+		cancel_work_sync(&dev->power.work);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.request_pending = false;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDING
+	    || dev->power.runtime_status == RPM_RESUMING
+	    || dev->power.idle_notification) {
+		DEFINE_WAIT(wait);
+
+		/* Suspend, wake-up or idle notification in progress. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (dev->power.runtime_status != RPM_SUSPENDING
+			    && dev->power.runtime_status != RPM_RESUMING
+			    && !dev->power.idle_notification)
+				break;
+			spin_unlock_irq(&dev->power.lock);
+
+			schedule();
+
+			spin_lock_irq(&dev->power.lock);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+	}
+}
+
+/**
+ * pm_runtime_barrier - Flush pending requests and wait for completions.
+ * @dev: Device to handle.
+ *
+ * Prevent the device from being suspended by incrementing its usage counter and
+ * if there's a pending resume request for the device, wake the device up.
+ * Next, make sure that all pending requests for the device have been flushed
+ * from pm_wq and wait for all run-time PM operations involving the device in
+ * progress to complete.
+ *
+ * Return value:
+ * 1, if there was a resume request pending and the device had to be woken up,
+ * 0, otherwise
+ */
+int pm_runtime_barrier(struct device *dev)
+{
+	int retval = 0;
+
+	pm_runtime_get_noresume(dev);
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.request_pending
+	    && dev->power.request == RPM_REQ_RESUME) {
+		__pm_runtime_resume(dev, false);
+		retval = 1;
+	}
+
+	__pm_runtime_barrier(dev);
+
+	spin_unlock_irq(&dev->power.lock);
+	pm_runtime_put_noidle(dev);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_barrier);
+
+/**
+ * __pm_runtime_disable - Disable run-time PM of a device.
+ * @dev: Device to handle.
+ * @check_resume: If set, check if there's a resume request for the device.
+ *
+ * Increment power.disable_depth for the device and if was zero previously,
+ * cancel all pending run-time PM requests for the device and wait for all
+ * operations in progress to complete.  The device can be either active or
+ * suspended after its run-time PM has been disabled.
+ *
+ * If @check_resume is set and there's a resume request pending when
+ * __pm_runtime_disable() is called and power.disable_depth is zero, the
+ * function will wake up the device before disabling its run-time PM.
+ */
+void __pm_runtime_disable(struct device *dev, bool check_resume)
+{
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.disable_depth > 0) {
+		dev->power.disable_depth++;
+		goto out;
+	}
+
+	/*
+	 * Wake up the device if there's a resume request pending, because that
+	 * means there probably is some I/O to process and disabling run-time PM
+	 * shouldn't prevent the device from processing the I/O.
+	 */
+	if (check_resume && dev->power.request_pending
+	    && dev->power.request == RPM_REQ_RESUME) {
+		/*
+		 * Prevent suspends and idle notifications from being carried
+		 * out after we have woken up the device.
+		 */
+		pm_runtime_get_noresume(dev);
+
+		__pm_runtime_resume(dev, false);
+
+		pm_runtime_put_noidle(dev);
+	}
+
+	if (!dev->power.disable_depth++)
+		__pm_runtime_barrier(dev);
+
+ out:
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
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
+	if (dev->power.disable_depth > 0)
+		dev->power.disable_depth--;
+	else
+		dev_warn(dev, "Unbalanced %s!\n", __func__);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_enable);
+
+/**
+ * pm_runtime_init - Initialize run-time PM fields in given device object.
+ * @dev: Device object to initialize.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	spin_lock_init(&dev->power.lock);
+
+	dev->power.runtime_status = RPM_SUSPENDED;
+	dev->power.idle_notification = false;
+
+	dev->power.disable_depth = 1;
+	atomic_set(&dev->power.usage_count, 0);
+
+	dev->power.runtime_error = 0;
+
+	atomic_set(&dev->power.child_count, 0);
+	pm_suspend_ignore_children(dev, false);
+
+	dev->power.request_pending = false;
+	dev->power.request = RPM_REQ_NONE;
+	dev->power.deferred_resume = false;
+	INIT_WORK(&dev->power.work, pm_runtime_work);
+
+	dev->power.timer_expires = 0;
+	setup_timer(&dev->power.suspend_timer, pm_suspend_timer_fn,
+			(unsigned long)dev);
+
+	init_waitqueue_head(&dev->power.wait_queue);
+}
+
+/**
+ * pm_runtime_remove - Prepare for removing a device from device hierarchy.
+ * @dev: Device object being removed from device hierarchy.
+ */
+void pm_runtime_remove(struct device *dev)
+{
+	__pm_runtime_disable(dev, false);
+
+	/* Change the status back to 'suspended' to match the initial status. */
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		pm_runtime_set_suspended(dev);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,114 @@
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
+extern int pm_runtime_idle(struct device *dev);
+extern int pm_runtime_suspend(struct device *dev);
+extern int pm_runtime_resume(struct device *dev);
+extern int pm_request_idle(struct device *dev);
+extern int pm_schedule_suspend(struct device *dev, unsigned int delay);
+extern int pm_request_resume(struct device *dev);
+extern int __pm_runtime_get(struct device *dev, bool sync);
+extern int __pm_runtime_put(struct device *dev, bool sync);
+extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
+extern int pm_runtime_barrier(struct device *dev);
+extern void pm_runtime_enable(struct device *dev);
+extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+
+static inline bool pm_children_suspended(struct device *dev)
+{
+	return dev->power.ignore_children
+		|| !atomic_read(&dev->power.child_count);
+}
+
+static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
+{
+	dev->power.ignore_children = enable;
+}
+
+static inline void pm_runtime_get_noresume(struct device *dev)
+{
+	atomic_inc(&dev->power.usage_count);
+}
+
+static inline void pm_runtime_put_noidle(struct device *dev)
+{
+	atomic_add_unless(&dev->power.usage_count, -1, 0);
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static inline int pm_runtime_idle(struct device *dev) { return -ENOSYS; }
+static inline int pm_runtime_suspend(struct device *dev) { return -ENOSYS; }
+static inline int pm_runtime_resume(struct device *dev) { return 0; }
+static inline int pm_request_idle(struct device *dev) { return -ENOSYS; }
+static inline int pm_schedule_suspend(struct device *dev, unsigned int delay)
+{
+	return -ENOSYS;
+}
+static inline int pm_request_resume(struct device *dev) { return 0; }
+static inline int __pm_runtime_get(struct device *dev, bool sync) { return 1; }
+static inline int __pm_runtime_put(struct device *dev, bool sync) { return 0; }
+static inline int __pm_runtime_set_status(struct device *dev,
+					    unsigned int status) { return 0; }
+static inline int pm_runtime_barrier(struct device *dev) { return 0; }
+static inline void pm_runtime_enable(struct device *dev) {}
+static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+
+static inline bool pm_children_suspended(struct device *dev) { return false; }
+static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
+static inline void pm_runtime_get_noresume(struct device *dev) {}
+static inline void pm_runtime_put_noidle(struct device *dev) {}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+static inline int pm_runtime_get(struct device *dev)
+{
+	return __pm_runtime_get(dev, false);
+}
+
+static inline int pm_runtime_get_sync(struct device *dev)
+{
+	return __pm_runtime_get(dev, true);
+}
+
+static inline int pm_runtime_put(struct device *dev)
+{
+	return __pm_runtime_put(dev, false);
+}
+
+static inline int pm_runtime_put_sync(struct device *dev)
+{
+	return __pm_runtime_put(dev, true);
+}
+
+static inline int pm_runtime_set_active(struct device *dev)
+{
+	return __pm_runtime_set_status(dev, RPM_ACTIVE);
+}
+
+static inline void pm_runtime_set_suspended(struct device *dev)
+{
+	__pm_runtime_set_status(dev, RPM_SUSPENDED);
+}
+
+static inline void pm_runtime_disable(struct device *dev)
+{
+	__pm_runtime_disable(dev, true);
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
+ * @dev: Device object being initialized.
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
@@ -105,6 +116,7 @@ void device_pm_remove(struct device *dev
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+	pm_runtime_remove(dev);
 }
 
 /**
@@ -512,6 +524,7 @@ static void dpm_complete(pm_message_t st
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
+			pm_runtime_put_noidle(dev);
 
 			mutex_lock(&dpm_list_mtx);
 		}
@@ -757,7 +770,14 @@ static int dpm_prepare(pm_message_t stat
 		dev->power.status = DPM_PREPARING;
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_prepare(dev, state);
+		pm_runtime_get_noresume(dev);
+		if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
+			/* Wake-up requested during system sleep transition. */
+			pm_runtime_put_noidle(dev);
+			error = -EBUSY;
+		} else {
+			error = device_prepare(dev, state);
+		}
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
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
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_barrier(dev);
 	ret = really_probe(dev, drv);
+	pm_runtime_put_sync(dev);
 
 	return ret;
 }
@@ -245,7 +249,9 @@ int device_attach(struct device *dev)
 			ret = 0;
 		}
 	} else {
+		pm_runtime_get_noresume(dev);
 		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
+		pm_runtime_put_sync(dev);
 	}
 	up(&dev->sem);
 	return ret;
@@ -306,6 +312,9 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_get_noresume(dev);
+		pm_runtime_barrier(dev);
+
 		driver_sysfs_remove(dev);
 
 		if (dev->bus)
@@ -324,6 +333,8 @@ static void __device_release_driver(stru
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
+
+		pm_runtime_put_sync(dev);
 	}
 }
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -1,7 +1,14 @@
-static inline void device_pm_init(struct device *dev)
-{
-	dev->power.status = DPM_ON;
-}
+#ifdef CONFIG_PM_RUNTIME
+
+extern void pm_runtime_init(struct device *dev);
+extern void pm_runtime_remove(struct device *dev);
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static inline void pm_runtime_init(struct device *dev) {}
+static inline void pm_runtime_remove(struct device *dev) {}
+
+#endif /* !CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
 
@@ -16,23 +23,33 @@ static inline struct device *to_device(s
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
+
+static inline void device_pm_init(struct device *dev)
+{
+	pm_runtime_init(dev);
+}
+
+static inline void device_pm_remove(struct device *dev)
+{
+	pm_runtime_remove(dev);
+}
 
 static inline void device_pm_add(struct device *dev) {}
-static inline void device_pm_remove(struct device *dev) {}
 static inline void device_pm_move_before(struct device *deva,
 					 struct device *devb) {}
 static inline void device_pm_move_after(struct device *deva,
 					struct device *devb) {}
 static inline void device_pm_move_last(struct device *dev) {}
 
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM
 
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
+  them to be synchronized with system-wide power transitions (suspend to RAM,
+  hibernation and resume from system sleep states).  pm_wq is declared in
+  include/linux/pm_runtime.h and defined in kernel/power/main.c.
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
+The run-time PM callbacks present in 'struct dev_pm_ops', the device run-time PM
+fields of 'struct dev_pm_info' and the core helper functions provided for
+run-time PM are described below.
+
+2. Device Run-time PM Callbacks
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
+The ->runtime_suspend() callback is executed by the PM core for the bus type of
+the device being suspended.  The bus type's callback is then _entirely_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's own ->runtime_suspend() callback (from the
+PM core's point of view it is not necessary to implement a ->runtime_suspend()
+callback in a device driver as long as the bus type's ->runtime_suspend() knows
+what to do to handle the device).
+
+  * Once the bus type's ->runtime_suspend() callback has completed successfully
+    for given device, the PM core regards the device as suspended, which need
+    not mean that the device has been put into a low power state.  It is
+    supposed to mean, however, that the device will not process data and will
+    not communicate with the CPU(s) and RAM until its bus type's
+    ->runtime_resume() callback is executed for it.  The run-time PM status of
+    a device after successful execution of its bus type's ->runtime_suspend()
+    callback is 'suspended'.
+
+  * If the bus type's ->runtime_suspend() callback returns -EBUSY or -EAGAIN,
+    the device's run-time PM status is supposed to be 'active', which means that
+    the device _must_ be fully operational afterwards.
+
+  * If the bus type's ->runtime_suspend() callback returns an error code
+    different from -EBUSY or -EAGAIN, the PM core regards this as a fatal
+    error and will refuse to run the helper functions described in Section 4
+    for the device, until the status of it is directly set either to 'active'
+    or to 'suspended' (the PM core provides special helper functions for this
+    purpose).
+
+In particular, if the driver requires remote wakeup capability for proper
+functioning and device_may_wakeup() returns 'false' for the device, then
+->runtime_suspend() should return -EBUSY.  On the other hand, if
+device_may_wakeup() returns 'true' for the device and the device is put
+into a low power state during the execution of its bus type's
+->runtime_suspend(), it is expected that remote wake-up (i.e. hardware mechanism
+allowing the device to request a change of its power state, such as PCI PME)
+will be enabled for the device.  Generally, remote wake-up should be enabled
+for all input devices put into a low power state at run time.
+
+The ->runtime_resume() callback is executed by the PM core for the bus type of
+the device being woken up.  The bus type's callback is then _entirely_
+_responsible_ for handling the device as appropriate, which may, but need not
+include executing the device driver's own ->runtime_resume() callback (from the
+PM core's point of view it is not necessary to implement a ->runtime_resume()
+callback in a device driver as long as the bus type's ->runtime_resume() knows
+what to do to handle the device).
+
+  * Once the bus type's ->runtime_resume() callback has completed successfully,
+    the PM core regards the device as fully operational, which means that the
+    device _must_ be able to complete I/O operations as needed.  The run-time
+    PM status of the device is then 'active'.
+
+  * If the bus type's ->runtime_resume() callback returns an error code, the PM
+    core regards this as a fatal error and will refuse to run the helper
+    functions described in Section 4 for the device, until its status is
+    directly set either to 'active' or to 'suspended' (the PM core provides
+    special helper functions for this purpose).
+
+The ->runtime_idle() callback is executed by the PM core for the bus type of
+given device whenever the device appears to be idle, which is indicated to the
+PM core by two counters, the device's usage counter and the counter of 'active'
+children of the device.
+
+  * If any of these counters is decreased using a helper function provided by
+    the PM core and it turns out to be equal to zero, the other counter is
+    checked.  If that counter also is equal to zero, the PM core executes the
+    device bus type's ->runtime_idle() callback (with the device as an
+    argument).
+
+The action performed by a bus type's ->runtime_idle() callback is totally
+dependent on the bus type in question, but the expected and recommended action
+is to check if the device can be suspended (i.e. if all of the conditions
+necessary for suspending the device are satisfied) and to queue up a suspend
+request for the device in that case.
+
+The helper functions provided by the PM core, described in Section 4, guarantee
+that the following constraints are met with respect to the bus type's run-time
+PM callbacks:
+
+(1) The callbacks are mutually exclusive (e.g. it is forbidden to execute
+    ->runtime_suspend() in parallel with ->runtime_resume() or with another
+    instance of ->runtime_suspend() for the same device) with the exception that
+    ->runtime_suspend() or ->runtime_resume() can be executed in parallel with
+    ->runtime_idle() (although ->runtime_idle() will not be started while any
+    of the other callbacks is being executed for the same device).
+
+(2) ->runtime_idle() and ->runtime_suspend() can only be executed for 'active'
+    devices (i.e. the PM core will only execute ->runtime_idle() or
+    ->runtime_suspend() for the devices the run-time PM status of which is
+    'active').
+
+(3) ->runtime_idle() and ->runtime_suspend() can only be executed for a device
+    the usage counter of which is equal to zero _and_ either the counter of
+    'active' children of which is equal to zero, or the 'power.ignore_children'
+    flag of which is set.
+
+(4) ->runtime_resume() can only be executed for 'suspended' devices  (i.e. the
+    PM core will only execute ->runtime_resume() for the devices the run-time
+    PM status of which is 'suspended').
+
+Additionally, the helper functions provided by the PM core obey the following
+rules:
+
+  * If ->runtime_suspend() is about to be executed or there's a pending request
+    to execute it, ->runtime_idle() will not be executed for the same device.
+
+  * A request to execute or to schedule the execution of ->runtime_suspend()
+    will cancel any pending requests to execute ->runtime_idle() for the same
+    device.
+
+  * If ->runtime_resume() is about to be executed or there's a pending request
+    to execute it, the other callbacks will not be executed for the same device.
+
+  * A request to execute ->runtime_resume() will cancel any pending or
+    scheduled requests to execute the other callbacks for the same device.
+
+3. Run-time PM Device Fields
+
+The following device run-time PM fields are present in 'struct dev_pm_info', as
+defined in include/linux/pm.h:
+
+  struct timer_list suspend_timer;
+    - timer used for scheduling (delayed) suspend request
+
+  unsigned long timer_expires;
+    - timer expiration time, in jiffies (if this is different from zero, the
+      timer is running and will expire at that time, otherwise the timer is not
+      running)
+
+  struct work_struct work;
+    - work structure used for queuing up requests (i.e. work items in pm_wq)
+
+  wait_queue_head_t wait_queue;
+    - wait queue used if any of the helper functions needs to wait for another
+      one to complete
+
+  spinlock_t lock;
+    - lock used for synchronisation
+
+  atomic_t usage_count;
+    - the usage counter of the device
+
+  atomic_t child_count;
+    - the count of 'active' children of the device
+
+  unsigned int ignore_children;
+    - if set, the value of child_count is ignored (but still updated)
+
+  unsigned int disable_depth;
+    - used for disabling the helper funcions (they work normally if this is
+      equal to zero); the initial value of it is 1 (i.e. run-time PM is
+      initially disabled for all devices)
+
+  unsigned int runtime_error;
+    - if set, there was a fatal error (one of the callbacks returned error code
+      as described in Section 2), so the helper funtions will not work until
+      this flag is cleared; this is the error code returned by the failing
+      callback
+
+  unsigned int idle_notification;
+    - if set, ->runtime_idle() is being executed
+
+  unsigned int request_pending;
+    - if set, there's a pending request (i.e. a work item queued up into pm_wq)
+
+  enum rpm_request request;
+    - type of request that's pending (valid if request_pending is set)
+
+  unsigned int deferred_resume;
+    - set if ->runtime_resume() is about to be run while ->runtime_suspend() is
+      being executed for that device and it is not practical to wait for the
+      suspend to complete; means "start a resume as soon as you've suspended"
+
+  enum rpm_status runtime_status;
+    - the run-time PM status of the device; this field's initial value is
+      RPM_SUSPENDED, which means that each device is initially regarded by the
+      PM core as 'suspended', regardless of its real hardware status
+
+All of the above fields are members of the 'power' member of 'struct device'.
+
+4. Run-time PM Device Helper Functions
+
+The following run-time PM helper functions are defined in
+drivers/base/power/runtime.c and include/linux/pm_runtime.h:
+
+  void pm_runtime_init(struct device *dev);
+    - initialize the device run-time PM fields in 'struct dev_pm_info'
+
+  void pm_runtime_remove(struct device *dev);
+    - make sure that the run-time PM of the device will be disabled after
+      removing the device from device hierarchy
+
+  int pm_runtime_idle(struct device *dev);
+    - execute ->runtime_idle() for the device's bus type; returns 0 on success
+      or error code on failure, where -EINPROGRESS means that ->runtime_idle()
+      is already being executed
+
+  int pm_runtime_suspend(struct device *dev);
+    - execute ->runtime_suspend() for the device's bus type; returns 0 on
+      success, 1 if the device's run-time PM status was already 'suspended', or
+      error code on failure, where -EAGAIN or -EBUSY means it is safe to attempt
+      to suspend the device again in future
+
+  int pm_runtime_resume(struct device *dev);
+    - execute ->runtime_resume() for the device's bus type; returns 0 on
+      success, 1 if the device's run-time PM status was already 'active' or
+      error code on failure, where -EAGAIN means it may be safe to attempt to
+      resume the device again in future, but 'power.runtime_error' should be
+      checked additionally
+
+  int pm_request_idle(struct device *dev);
+    - submit a request to execute ->runtime_idle() for the device's bus type
+      (the request is represented by a work item in pm_wq); returns 0 on success
+      or error code if the request has not been queued up
+
+  int pm_schedule_suspend(struct device *dev, unsigned int delay);
+    - schedule the execution of ->runtime_suspend() for the device's bus type
+      in future, where 'delay' is the time to wait before queuing up a suspend
+      work item in pm_wq, in milliseconds (if 'delay' is zero, the work item is
+      queued up immediately); returns 0 on success, 1 if the device's PM
+      run-time status was already 'suspended', or error code if the request
+      hasn't been scheduled (or queued up if 'delay' is 0); if the execution of
+      ->runtime_suspend() is already scheduled and not yet expired, the new
+      value of 'delay' will be used as the time to wait
+
+  int pm_request_resume(struct device *dev);
+    - submit a request to execute ->runtime_resume() for the device's bus type
+      (the request is represented by a work item in pm_wq); returns 0 on
+      success, 1 if the device's run-time PM status was already 'active', or
+      error code if the request hasn't been queued up
+
+  void pm_runtime_get_noresume(struct device *dev);
+    - increment the device's usage counter
+
+  int pm_runtime_get(struct device *dev);
+    - increment the device's usage counter, run pm_request_resume(dev) and
+      return its result
+
+  int pm_runtime_get_sync(struct device *dev);
+    - increment the device's usage counter, run pm_runtime_resume(dev) and
+      return its result
+
+  void pm_runtime_put_noidle(struct device *dev);
+    - decrement the device's usage counter
+
+  int pm_runtime_put(struct device *dev);
+    - decrement the device's usage counter, run pm_request_idle(dev) and return
+      its result
+
+  int pm_runtime_put_sync(struct device *dev);
+    - decrement the device's usage counter, run pm_runtime_idle(dev) and return
+      its result
+
+  void pm_runtime_enable(struct device *dev);
+    - enable the run-time PM helper functions to run the device bus type's
+      run-time PM callbacks described in Section 2
+
+  int pm_runtime_disable(struct device *dev);
+    - prevent the run-time PM helper functions from running the device bus
+      type's run-time PM callbacks, make sure that all of the pending run-time
+      PM operations on the device are either completed or canceled; returns
+      1 if there was a resume request pending and it was necessary to execute
+      ->runtime_resume() for the device's bus type to satisfy that request,
+      otherwise 0 is returned
+
+  void pm_suspend_ignore_children(struct device *dev, bool enable);
+    - set/unset the power.ignore_children flag of the device
+
+  int pm_runtime_set_active(struct device *dev);
+    - clear the device's 'power.runtime_error' flag, set the device's run-time
+      PM status to 'active' and update its parent's counter of 'active'
+      children as appropriate (it is only valid to use this function if
+      'power.runtime_error' is set or 'power.disable_depth' is greater than
+      zero); it will fail and return error code if the device has a parent
+      which is not active and the 'power.ignore_children' flag of which is unset
+
+  void pm_runtime_set_suspended(struct device *dev);
+    - clear the device's 'power.runtime_error' flag, set the device's run-time
+      PM status to 'suspended' and update its parent's counter of 'active'
+      children as appropriate (it is only valid to use this function if
+      'power.runtime_error' is set or 'power.disable_depth' is greater than
+      zero)
+
+It is safe to execute the following helper functions from interrupt context:
+
+pm_request_idle()
+pm_schedule_suspend()
+pm_request_resume()
+pm_runtime_get_noresume()
+pm_runtime_get()
+pm_runtime_put_noidle()
+pm_runtime_put()
+pm_suspend_ignore_children()
+pm_runtime_set_active()
+pm_runtime_set_suspended()
+pm_runtime_enable()
+
+5. Run-time PM Initialization, Device Probing and Removal
+
+Initially, the run-time PM is disabled for all devices, which means that the
+majority of the run-time PM helper funtions described in Section 4 will return
+-EAGAIN until pm_runtime_enable() is called for the device.
+
+In addition to that, the initial run-time PM status of all devices is
+'suspended', but it need not reflect the actual physical state of the device.
+Thus, if the device is initially active (i.e. it is able to process I/O), its
+run-time PM status must be changed to 'active', with the help of
+pm_runtime_set_active(), before pm_runtime_enable() is called for the device.
+
+However, if the device has a parent and the parent's run-time PM is enabled,
+calling pm_runtime_set_active() for the device will affect the parent, unless
+the parent's 'power.ignore_children' flag is set.  Namely, in that case the
+parent won't be able to suspend at run time, using the PM core's helper
+functions, as long as the child's status is 'active', even if the child's
+run-time PM is still disabled (i.e. pm_runtime_enable() hasn't been called for
+the child yet or pm_runtime_disable() has been called for it).  For this reason,
+once pm_runtime_set_active() has been called for the device, pm_runtime_enable()
+should be called for it too as soon as reasonably possible or its run-time PM
+status should be changed back to 'suspended' with the help of
+pm_runtime_set_suspended().
+
+If the default initial run-time PM status of the device (i.e. 'suspended')
+reflects the actual state of the device, its bus type's or its driver's
+->probe() callback will likely need to wake it up using one of the PM core's
+helper functions described in Section 4.  In that case, pm_runtime_resume()
+should be used.  Of course, for this purpose the device's run-time PM has to be
+enabled earlier by calling pm_runtime_enable().
+
+If the device bus type's or driver's ->probe() or ->remove() callback runs
+pm_runtime_suspend() or pm_runtime_idle() or their asynchronous counterparts,
+they will fail returning -EAGAIN, because the device's usage counter is
+incremented by the core before executing ->probe() and ->remove().  Still, it
+may be desirable to suspend the device as soon as ->probe() or ->remove() has
+finished, so the PM core uses pm_runtime_idle_sync() to invoke the device bus
+type's ->runtime_idle() callback at that time.
