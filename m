Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbZGVPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbZGVPBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZGVPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:01:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZGVPBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:01:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 10)
Date: Wed, 22 Jul 2009 17:01:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221701.50449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below is rev. 10 of the run-time PM framework patch.

The most visible change from the previous one is that the documentation is now
present again. :-)

Second, there's a check in pm_runtime_add() that will only increment the
parent's counter of 'active' children if the device current status is not
'suspended'.

Comments welcome.

Best,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 10)

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  341 +++++++++++++
 drivers/base/dd.c                  |    7 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |   22 
 drivers/base/power/power.h         |   11 
 drivers/base/power/runtime.c       |  959 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |  102 +++
 include/linux/pm_runtime.h         |  113 ++++
 kernel/power/Kconfig               |   14 
 kernel/power/main.c                |   17 
 10 files changed, 1576 insertions(+), 11 deletions(-)

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
 
 /**
@@ -315,14 +344,81 @@ enum dpm_state {
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
+	unsigned int		runtime_failure:1;
+	unsigned int		idle_notification:1;
+	unsigned int		request_pending:1;
+	unsigned int		deferred_resume:1;
+	enum rpm_request	request;
+	enum rpm_status		runtime_status;
+	int			last_error;
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
@@ -0,0 +1,959 @@
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
+	 * If there's a request pending, make sure its work function will return
+	 * without doing anything.
+	 */
+	if (dev->power.request_pending)
+		dev->power.request = RPM_REQ_NONE;
+}
+
+/**
+ * __pm_runtime_idle - Notify device bus type if the device can be suspended.
+ * @dev: Device to notify the bus type about.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+static int __pm_runtime_idle(struct device *dev)
+{
+	int retval = 0;
+
+	if (dev->power.runtime_failure)
+		retval = -EINVAL;
+	else if (dev->power.idle_notification)
+		retval = -EINPROGRESS;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0
+	    || dev->power.timer_expires > 0
+	    || dev->power.runtime_status == RPM_SUSPENDED
+	    || dev->power.runtime_status == RPM_SUSPENDING)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		return retval;
+
+	if (dev->power.request_pending) {
+		/*
+		 * If an idle notification request is pending, cancel it.  Any
+		 * other pending request takes precedence over us.
+		 */
+		if (dev->power.request == RPM_REQ_IDLE)
+			dev->power.request = RPM_REQ_NONE;
+		else if (dev->power.request != RPM_REQ_NONE)
+			return -EAGAIN;
+	}
+
+	dev->power.idle_notification = true;
+
+	spin_unlock_irq(&dev->power.lock);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+
+	spin_lock_irq(&dev->power.lock);
+
+	dev->power.idle_notification = false;
+	wake_up_all(&dev->power.wait_queue);
+
+	return 0;
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
+ * @from_wq: If set, the funtion has been called via pm_wq.
+ *
+ * Check if the device can be suspended and run the ->runtime_suspend() callback
+ * provided by its bus type.  If another suspend has been started earlier, wait
+ * for it to finish.  If there's an idle notification pending, cancel it.  If
+ * there's a suspend request scheduled while this function is running and @sync
+ * is 'true', cancel that request.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+int __pm_runtime_suspend(struct device *dev, bool from_wq)
+{
+	struct device *parent = NULL;
+	bool notify = false;
+	int retval = 0;
+
+ repeat:
+	if (dev->power.runtime_failure)
+		return -EINVAL;
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		/* Pending resume requests take precedence over us. */
+		if (dev->power.request == RPM_REQ_RESUME)
+			return -EAGAIN;
+		/* Other pending requests need to be canceled. */
+		dev->power.request = RPM_REQ_NONE;
+	}
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
+		return retval;
+
+	if (dev->power.runtime_status == RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		if (from_wq)
+			return -EINPROGRESS;
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
+	spin_unlock_irq(&dev->power.lock);
+
+	retval = dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend ?
+		dev->bus->pm->runtime_suspend(dev) : -ENOSYS;
+
+	spin_lock_irq(&dev->power.lock);
+
+	if (retval) {
+		dev->power.runtime_status = RPM_ACTIVE;
+		pm_runtime_cancel_pending(dev);
+		dev->power.deferred_resume = false;
+
+		if (retval == -EAGAIN || retval == -EBUSY) {
+			notify = true;
+		} else {
+			dev->power.runtime_failure = true;
+			dev->power.last_error = retval;
+		}
+	} else {
+		dev->power.runtime_status = RPM_SUSPENDED;
+
+		if (dev->parent) {
+			parent = dev->parent;
+			atomic_add_unless(&parent->power.child_count, -1, 0);
+		}
+
+	}
+	wake_up_all(&dev->power.wait_queue);
+
+	if (dev->power.deferred_resume) {
+		__pm_request_resume(dev);
+		dev->power.deferred_resume = false;
+	}
+
+	spin_unlock_irq(&dev->power.lock);
+
+	if (parent && !parent->power.ignore_children)
+		pm_request_idle(parent);
+
+	if (notify)
+		pm_runtime_idle(dev);
+
+	spin_lock_irq(&dev->power.lock);
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
+ * @from_wq: If set, the funtion has been called via pm_wq.
+ *
+ * Check if the device can be woken up and run the ->runtime_resume() callback
+ * provided by its bus type.  If another resume has been started earlier, wait
+ * for it to finish.  If there's a suspend running in parallel with this
+ * function, wait for it to finish and resume the device.  If there's a suspend
+ * request or idle notification pending, cancel it.  If there's a resume request
+ * scheduled while this function is running, cancel that request.
+ *
+ * This function must be called under dev->power.lock with interrupts disabled.
+ */
+int __pm_runtime_resume(struct device *dev, bool from_wq)
+{
+	struct device *parent = NULL;
+	int retval = 0;
+
+ repeat:
+	if (dev->power.runtime_failure)
+		return -EINVAL;
+
+	pm_runtime_cancel_pending(dev);
+
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		retval = 1;
+	else if (dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+	if (retval)
+		return retval;
+
+	if (dev->power.runtime_status == RPM_RESUMING
+	    || dev->power.runtime_status == RPM_SUSPENDING) {
+		DEFINE_WAIT(wait);
+
+		if (from_wq) {
+			if (dev->power.runtime_status == RPM_SUSPENDING)
+				dev->power.deferred_resume = true;
+			return -EINPROGRESS;
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
+		spin_unlock_irq(&dev->power.lock);
+
+		parent = dev->parent;
+		retval = pm_runtime_get_sync(parent);
+		if (retval < 0)
+			goto out_parent;
+
+		spin_lock_irq(&dev->power.lock);
+		retval = 0;
+		goto repeat;
+	}
+
+	dev->power.runtime_status = RPM_RESUMING;
+
+	spin_unlock_irq(&dev->power.lock);
+
+	retval = dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume ?
+		dev->bus->pm->runtime_resume(dev) : -ENOSYS;
+
+	spin_lock_irq(&dev->power.lock);
+
+	if (retval) {
+		dev->power.runtime_status = RPM_SUSPENDED;
+
+		dev->power.runtime_failure = true;
+		dev->power.last_error = retval;
+
+		pm_runtime_cancel_pending(dev);
+	} else {
+		dev->power.runtime_status = RPM_ACTIVE;
+
+		if (parent)
+			atomic_inc(&parent->power.child_count);
+	}
+	wake_up_all(&dev->power.wait_queue);
+
+	spin_unlock_irq(&dev->power.lock);
+
+ out_parent:
+	if (parent)
+		pm_runtime_put(parent);
+
+	if (!retval)
+		pm_request_idle(dev);
+
+	spin_lock_irq(&dev->power.lock);
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
+ * pm_request_idle - Submit an idle notification request for given device.
+ * @dev: Device to handle.
+ *
+ * Check if the device's run-time PM status is correct for suspending the device
+ * and queue up a request to run __pm_runtime_idle() for it.
+ */
+int pm_request_idle(struct device *dev)
+{
+	unsigned long flags;
+	int retval = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_failure)
+		retval = -EINVAL;
+	else if (atomic_read(&dev->power.usage_count) > 0
+	    || dev->power.disable_depth > 0
+	    || dev->power.timer_expires > 0
+	    || dev->power.runtime_status == RPM_SUSPENDED
+	    || dev->power.runtime_status == RPM_SUSPENDING)
+		retval = -EAGAIN;
+	else if (!pm_children_suspended(dev))
+		retval = -EBUSY;
+	if (retval)
+		goto out;
+
+	if (dev->power.request_pending && dev->power.request != RPM_REQ_NONE) {
+		/* Any requests other then RPM_REQ_IDLE take precedence. */
+		if (dev->power.request != RPM_REQ_IDLE)
+			retval = -EAGAIN;
+		goto out;
+	}
+
+	dev->power.request = RPM_REQ_IDLE;
+	if (dev->power.request_pending)
+		goto out;
+
+	dev->power.request_pending = true;
+	queue_work(pm_wq, &dev->power.work);
+
+ out:
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
+	if (dev->power.runtime_failure)
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
+
+		if (dev->power.request == RPM_REQ_SUSPEND)
+			return 0;
+	}
+
+	if (retval)
+		return retval;
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
+	if (dev->power.runtime_failure) {
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
+int __pm_request_resume(struct device *dev)
+{
+	int retval = 0;
+
+	if (dev->power.runtime_failure)
+		return -EINVAL;
+
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		retval = 1;
+	else if (dev->power.runtime_status == RPM_RESUMING)
+		retval = -EINPROGRESS;
+	else if (dev->power.disable_depth > 0)
+		retval = -EAGAIN;
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		/* If non-resume request is pending, we can overtake it. */
+		dev->power.request = retval ? RPM_REQ_NONE : RPM_REQ_RESUME;
+		/* There's nothing to do if resume request is pending. */
+		if (dev->power.request == RPM_REQ_RESUME)
+			return 0;
+	}
+
+	if (retval)
+		return retval;
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
+ * If run-time PM of the device is disabled or its power.runtime_failure flag is
+ * set, the status may be changed either to RPM_ACTIVE, or to RPM_SUSPENDED, as
+ * long as that reflects the actual state of the device.  However, if the device
+ * has a parent and the parent is not active, and the parent's
+ * power.ignore_children flag is unset, the device's status cannot be set to
+ * RPM_ACTIVE, so -EBUSY is returned in that case.
+ *
+ * If successful, __pm_runtime_set_status() clears the power.runtime_failure
+ * flag and the device parent's counter of unsuspended children is modified to
+ * reflect the new status.
+ */
+int __pm_runtime_set_status(struct device *dev, unsigned int status)
+{
+	struct device *parent = dev->parent;
+	unsigned long flags;
+	int error = 0;
+
+	if (status != RPM_ACTIVE && status != RPM_SUSPENDED)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!dev->power.runtime_failure && !dev->power.disable_depth)
+		goto out;
+
+	if (dev->power.runtime_status == status)
+		goto out_clear;
+
+	if (status == RPM_SUSPENDED) {
+		/* It always is possible to set the status to 'suspended'. */
+		if (parent)
+			atomic_add_unless(&parent->power.child_count, -1, 0);
+		dev->power.runtime_status = status;
+		goto out_clear;
+	}
+
+	if (parent) {
+		spin_lock_irq(&parent->power.lock);
+
+		/*
+		 * It is invalid to put an active child under a suspended parent
+		 * that has run-time PM enabled and the 'power.ignore_children'
+		 * flag unset.
+		 */
+		if (!parent->power.disable_depth
+		    && parent->power.runtime_status == RPM_SUSPENDED
+		    && !parent->power.ignore_children) {
+			error = -EBUSY;
+		} else {
+			if (dev->power.runtime_status == RPM_SUSPENDED)
+				atomic_inc(&parent->power.child_count);
+			dev->power.runtime_status = status;
+		}
+
+		spin_unlock_irq(&parent->power.lock);
+
+		if (error)
+			goto out;
+	} else {
+		dev->power.runtime_status = status;
+	}
+
+ out_clear:
+	dev->power.runtime_failure = false;
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
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
+	if (dev->power.disable_depth > 0)
+		dev->power.disable_depth--;
+	else
+		dev_warn(dev, "Unbalanced %s!", __func__);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_enable);
+
+/**
+ * pm_runtime_disable - Disable run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Increment power.disable_depth for the device and if was zero previously,
+ * cancel all pending run-time PM requests for the device and wait for all
+ * operations in progress to complete.  The device can be either active or
+ * suspended after its run-time PM has been disabled.
+ *
+ * If there's a resume request pending when pm_runtime_disable() is called and
+ * power.disable_depth is zero, the function will wake up the device before
+ * disabling its run-time PM and will return 1.  Otherwise, 0 is returned.
+ */
+int pm_runtime_disable(struct device *dev)
+{
+	int retval = 0;
+
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
+	if (dev->power.request_pending
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
+		retval = 1;
+	}
+
+	if (dev->power.disable_depth++ > 0)
+		goto out;
+
+	if (dev->power.runtime_failure)
+		goto out;
+
+	pm_runtime_deactivate_timer(dev);
+
+	if (dev->power.request_pending) {
+		dev->power.request = RPM_REQ_NONE;
+
+		spin_unlock_irq(&dev->power.lock);
+
+		cancel_work_sync(&dev->power.work);
+
+		spin_lock_irq(&dev->power.lock);
+
+		dev->power.request_pending = false;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDING
+	    || dev->power.runtime_status == RPM_RESUMING) {
+		DEFINE_WAIT(wait);
+
+		/* Suspend or wake-up in progress. */
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (dev->power.runtime_status != RPM_SUSPENDING
+			    && dev->power.runtime_status != RPM_RESUMING)
+				break;
+
+			spin_unlock_irq(&dev->power.lock);
+
+			schedule();
+
+			spin_lock_irq(&dev->power.lock);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+	}
+
+	if (dev->power.runtime_failure)
+		goto out;
+
+	if (dev->power.idle_notification) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&dev->power.wait_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!dev->power.idle_notification)
+				break;
+
+			spin_unlock_irq(&dev->power.lock);
+
+			schedule();
+
+			spin_lock_irq(&dev->power.lock);
+		}
+		finish_wait(&dev->power.wait_queue, &wait);
+	}
+
+ out:
+	spin_unlock_irq(&dev->power.lock);
+
+	return retval;
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
+	dev->power.idle_notification = false;
+
+	dev->power.disable_depth = 1;
+	atomic_set(&dev->power.usage_count, 0);
+
+	dev->power.runtime_failure = false;
+	dev->power.last_error = 0;
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
+	dev->power.suspend_timer.expires = jiffies;
+	dev->power.suspend_timer.data = (unsigned long)dev;
+	dev->power.suspend_timer.function = pm_suspend_timer_fn;
+
+	init_waitqueue_head(&dev->power.wait_queue);
+}
+
+/**
+ * pm_runtime_add - Update run-time PM fields of a device while adding it.
+ * @dev: Device object being added to device hierarchy.
+ */
+void pm_runtime_add(struct device *dev)
+{
+	if (!dev->parent)
+		return;
+
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.runtime_status != RPM_SUSPENDED)
+		atomic_inc(&dev->parent->power.child_count);
+
+	spin_unlock_irq(&dev->power.lock);
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
+		atomic_add_unless(&parent->power.child_count, -1, 0);
+		if (!parent->power.ignore_children)
+			pm_request_idle(parent);
+	}
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,113 @@
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
+extern int pm_runtime_idle(struct device *dev);
+extern int pm_runtime_suspend(struct device *dev);
+extern int pm_runtime_resume(struct device *dev);
+extern int pm_request_idle(struct device *dev);
+extern int pm_schedule_suspend(struct device *dev, unsigned int delay);
+extern int pm_request_resume(struct device *dev);
+extern int __pm_runtime_get(struct device *dev, bool sync);
+extern int __pm_runtime_put(struct device *dev, bool sync);
+extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
+extern void pm_runtime_enable(struct device *dev);
+extern int pm_runtime_disable(struct device *dev);
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
+static inline void pm_runtime_init(struct device *dev) {}
+static inline void pm_runtime_add(struct device *dev) {}
+static inline void pm_runtime_remove(struct device *dev) {}
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
+static inline void pm_runtime_enable(struct device *dev) {}
+static inline int pm_runtime_disable(struct device *dev) { return 0; }
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
@@ -89,6 +100,8 @@ void device_pm_add(struct device *dev)
 
 	list_add_tail(&dev->power.entry, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+
+	pm_runtime_add(dev);
 }
 
 /**
@@ -105,6 +118,8 @@ void device_pm_remove(struct device *dev
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+
+	pm_runtime_remove(dev);
 }
 
 /**
@@ -512,6 +527,7 @@ static void dpm_complete(pm_message_t st
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
+			pm_runtime_enable(dev);
 
 			mutex_lock(&dpm_list_mtx);
 		}
@@ -757,11 +773,15 @@ static int dpm_prepare(pm_message_t stat
 		dev->power.status = DPM_PREPARING;
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_prepare(dev, state);
+		if (pm_runtime_disable(dev) && device_may_wakeup(dev))
+			error = -EBUSY;
+		else
+			error = device_prepare(dev, state);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			dev->power.status = DPM_ON;
+			pm_runtime_enable(dev);
 			if (error == -EAGAIN) {
 				put_device(dev);
 				error = 0;
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
@@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
+	pm_runtime_get_noresume(dev);
 	ret = really_probe(dev, drv);
+	pm_runtime_put_noidle(dev);
 
 	return ret;
 }
@@ -306,6 +309,8 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_disable(dev);
+
 		driver_sysfs_remove(dev);
 
 		if (dev->bus)
@@ -324,6 +329,8 @@ static void __device_release_driver(stru
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
 
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -0,0 +1,341 @@
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
+In particular, it is recommended that ->runtime_suspend() return -EBUSY if
+device_may_wakeup() returns 'false' for the device.  On the other hand, if
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
+  * If ->runtime_suspend() is about to be executed or the execution of it is
+    scheduled or there's a pending request to execute it, ->runtime_idle() will
+    not be executed for the same device.
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
+      equal to zero)
+
+  unsigned int runtime_failure;
+    - if set, there was a fatal error (one of the callbacks returned error code
+      as described in Section 2), so the helper funtions will not work until
+      this flag is cleared
+
+  int last_error;
+    - if runtime_failure is set, this is the error code returned by the
+      failing callback
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
+      suspend to complete; means "queue up a resume request as soon as you've
+      suspended"
+
+  enum rpm_status runtime_status;
+    - the run-time PM status of the device
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
+  void pm_runtime_add(struct device *dev);
+    - prepare the device run-time PM fields for adding the device to device
+      hierarchy
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
+      resume the device again in future, but 'power.runtime_failure' should be
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
+      work item in pm_wq, in miliseconds (if 'delay' is zero, the work item is
+      queued up immediately); returns 0 on success, 1 if the device's PM
+      run-time status was already 'suspended', or error code if the request
+      hasn't been scheduled (or queued up if 'delay' is 0)
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
+    - increment the device's usage counter, run pm_rutime_resume(dev) and return
+      its result
+
+  void pm_runtime_put_noidle(struct device *dev);
+    - decrement the device's usage counter
+
+  int pm_runtime_put(struct device *dev);
+    - decrement the device's usage counter, run pm_request_idle(dev) and return
+      its result
+
+  int pm_runtime_put_sync(struct device *dev);
+    - decrement the device's usage counter, run pm_rutime_idle(dev) and return
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
+      'power.runtime_failure' is set or 'power.disable_depth' is greater than
+      zero); it will fail and return error code if the device has a parent
+      which is suspended and the 'power.ignore_children' flag of which is unset
+
+  void pm_runtime_set_suspended(struct device *dev);
+    - clear the device's 'power.runtime_error' flag, set the device's run-time
+      PM status to 'suspended' and update its parent's counter of 'active'
+      children as appropriate (it is only valid to use this function if
+      'power.runtime_failure' is set or 'power.disable_depth' is greater than
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
