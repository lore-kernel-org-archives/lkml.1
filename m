Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZFNJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZFNJ6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZFNJ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:58:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZFNJ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:58:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [linux-pm] [PATCH] PM: Introduce core framework for run-time PM of I/O devices
Date: Sun, 14 Jun 2009 11:58:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <200906140023.36147.rjw@sisk.pl>
In-Reply-To: <200906140023.36147.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141158.50171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> Below is the current version of my "run-time PM for I/O devices" patch.
> 
> I've done my best to address the comments received during the recent
> discussions, but at the same time I've tried to make the patch only contain
> the most essential things.  For this reason, for example, the sysfs interface
> is not there and it's going to be added in a separate patch.
> 
> Please let me know if you want me to change anything in this patch or to add
> anything new to it.  [Magnus, I remember you wanted something like
> ->runtime_wakeup() along with ->runtime_idle(), but I'm not sure it's really
> necessary.  Please let me know if you have any particular usage scenario for
> it.]

Sorry, I sent an outdated version of the patch.  The current one is below.

Best,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce a core framework for run-time power management of I/O
devices.  Add device run-time PM fields to 'struct dev_pm_info'
and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
a run-time PM workqueue and define some device run-time PM helper
functions at the core level.  Document all these things.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  250 ++++++++++++++++++++
 drivers/base/dd.c                  |    9 
 drivers/base/power/Makefile        |    1 
 drivers/base/power/main.c          |    5 
 drivers/base/power/runtime.c       |  461 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   98 +++++++
 include/linux/pm_runtime.h         |   63 +++++
 kernel/power/Kconfig               |   14 +
 kernel/power/main.c                |   17 +
 9 files changed, 915 insertions(+), 3 deletions(-)

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
@@ -165,6 +168,26 @@ typedef struct pm_message {
  * It is allowed to unregister devices while the above callbacks are being
  * executed.  However, it is not allowed to unregister a device from within any
  * of its own callbacks.
+ *
+ * There also are the following callbacks related to run-time power management
+ * of devices:
+ *
+ * @runtime_suspend: Prepare the device for a condition in which it won't be
+ *	able to communicate with the CPU(s) and RAM due to power management.
+ *	This need not mean that the device should be put into a low power state,
+ *	like for example when the device is behind a link, represented by a
+ *	separate device object, that is going to be turned off for power
+ *	management purposes.
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
@@ -182,6 +205,11 @@ struct dev_pm_ops {
 	int (*thaw_noirq)(struct device *dev);
 	int (*poweroff_noirq)(struct device *dev);
 	int (*restore_noirq)(struct device *dev);
+#ifdef CONFIG_PM_RUNTIME
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+	void (*runtime_idle)(struct device *dev);
+#endif
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
+#define RPM_ERROR	(-1)
+
+#define RPM_IN_SUSPEND	(RPM_SUSPENDING | RPM_SUSPENDED)
+#define RPM_INACTIVE	(RPM_IDLE | RPM_IN_SUSPEND)
+#define RPM_NO_SUSPEND	(RPM_WAKE | RPM_RESUMING)
+#define RPM_IN_PROGRESS	(RPM_SUSPENDING | RPM_RESUMING)
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
+	struct delayed_work	runtime_work;
+	struct completion	work_done;
+	unsigned int		suspend_skip_children:1;
+	unsigned int		suspend_aborted:1;
+	unsigned int		runtime_status:5;
+	int			runtime_error;
+	atomic_t		depth;
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
@@ -0,0 +1,461 @@
+/*
+ * drivers/base/power/runtime.c - Helper functions for device run-time PM
+ *
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/pm_runtime.h>
+
+/**
+ * pm_runtime_reset - Clear all of the device run-time PM flags.
+ * @dev: Device object to clear the flags for.
+ */
+static void pm_runtime_reset(struct device *dev)
+{
+	dev->power.suspend_aborted = false;
+	dev->power.runtime_status = RPM_ACTIVE;
+}
+
+/**
+ * pm_device_suspended - Check if given device has been suspended at run time.
+ * @dev: Device to check.
+ * @data: Ignored.
+ *
+ * Returns 0 if the device has been suspended and it hasn't been requested to
+ * resume or -EBUSY otherwise.
+ */
+static int pm_device_suspended(struct device *dev, void *data)
+{
+	return dev->power.runtime_status == RPM_SUSPENDED ? 0 : -EBUSY;
+}
+
+/**
+ * pm_check_children - Check if all children of a device have been suspended.
+ * @dev: Device to check.
+ *
+ * Returns 0 if all children of the device have been suspended or -EBUSY
+ * otherwise.
+ */
+static int pm_check_children(struct device *dev)
+{
+	return dev->power.suspend_skip_children ? 0 :
+			device_for_each_child(dev, NULL, pm_device_suspended);
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
+	if (atomic_read(&dev->power.depth) > 0 || pm_check_children(dev))
+		return;
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		dev->bus->pm->runtime_idle(dev);
+}
+
+/**
+ * pm_runtime_suspend - Run a device bus type's runtime_suspend() callback.
+ * @dev: Device to suspend.
+ *
+ * Check if the status of the device is appropriate and run the
+ * ->runtime_suspend() callback provided by the device's bus type driver.
+ * Update the run-time PM flags in the device object to reflect the current
+ * status of the device.
+ */
+int pm_runtime_suspend(struct device *dev)
+{
+	int error = 0;
+
+	if (atomic_read(&dev->power.depth) > 0)
+		return -EBUSY;
+
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status & RPM_SUSPENDED) {
+		goto out;
+	} else if (dev->power.runtime_status & RPM_NO_SUSPEND) {
+		/* Device is resuming or there's a resume request pending. */
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_IDLE
+	    && dev->power.suspend_aborted) {
+		dev->power.suspend_aborted = false;
+		dev->power.runtime_status = RPM_ACTIVE;
+		goto out;
+	} else if (pm_check_children(dev)) {
+		/*
+		 * We can only suspend the device if all of its children have
+		 * been suspended.
+		 */
+		error = -EAGAIN;
+		goto out;
+	} else if (dev->power.runtime_status == RPM_SUSPENDING) {
+		spin_unlock(&dev->power.lock);
+
+		/*
+		 * Another suspend is running in parallel with us.  Wait for it
+		 * to complete and return.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_error;
+	}
+
+	dev->power.runtime_status = RPM_SUSPENDING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock(&dev->power.lock);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
+		error = dev->bus->pm->runtime_suspend(dev);
+
+	spin_lock(&dev->power.lock);
+
+	/*
+	 * Resume request might have been queued in the meantime, in which case
+	 * the RPM_WAKE bit is also set in runtime_status.
+	 */
+	dev->power.runtime_status &= ~RPM_SUSPENDING;
+	switch (error) {
+	case 0:
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
+	complete(&dev->power.work_done);
+
+	if (!error && !(dev->power.runtime_status & RPM_WAKE) && dev->parent) {
+		spin_unlock(&dev->power.lock);
+
+		pm_runtime_notify_idle(dev->parent);
+
+		return 0;
+	}
+
+ out:
+	spin_unlock(&dev->power.lock);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_suspend);
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
+	pm_runtime_suspend(pm_work_to_device(work));
+}
+
+/**
+ * pm_request_suspend - Schedule run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @delay: Time, in jiffies, to wait before attempting to suspend the device.
+ */
+void pm_request_suspend(struct device *dev, unsigned long delay)
+{
+	unsigned long flags;
+
+	if (atomic_read(&dev->power.depth) > 0)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status != RPM_ACTIVE)
+		goto out;
+
+	dev->power.runtime_status = RPM_IDLE;
+	dev->power.suspend_aborted = false;
+	INIT_DELAYED_WORK(&dev->power.runtime_work, pm_runtime_suspend_work);
+	queue_delayed_work(pm_wq, &dev->power.runtime_work, delay);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_request_suspend);
+
+/**
+ * pm_cancel_suspend - Cancel a pending suspend request for given device.
+ * @dev: Device to cancel the suspend request for.
+ *
+ * Should be called under pm_lock_device() and only if we are sure that the
+ * ->autosuspend() callback hasn't started to yet.
+ */
+static void pm_cancel_suspend(struct device *dev)
+{
+	dev->power.suspend_aborted = true;
+	cancel_delayed_work(&dev->power.runtime_work);
+	dev->power.runtime_status = RPM_ACTIVE;
+}
+
+/**
+ * pm_runtime_resume - Run a device bus type's runtime_resume() callback.
+ * @dev: Device to resume.
+ *
+ * Check if the device is really suspended and run the ->runtime_resume()
+ * callback provided by the device's bus type driver.  Update the run-time PM
+ * flags in the device object to reflect the current status of the device.  If
+ * runtime suspend is in progress while this function is being run, wait for it
+ * to finish before resuming the device.  If runtime suspend is scheduled, but
+ * it hasn't started yet, cancel it and we're done.
+ */
+int pm_runtime_resume(struct device *dev)
+{
+	int error = 0;
+
+ repeat:
+	if (atomic_read(&dev->power.depth) > 0)
+		return -EBUSY;
+
+	if (dev->parent)
+		spin_lock(&dev->parent->power.lock);
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status == RPM_ACTIVE) {
+		goto out_unlock;
+	} else if (dev->power.runtime_status == RPM_IDLE) {
+		/* ->runtime_suspend() hasn't started yet, no need to resume. */
+		pm_cancel_suspend(dev);
+		goto out_unlock;
+	}
+
+	if (dev->power.runtime_status & RPM_SUSPENDING) {
+		spin_unlock(&dev->power.lock);
+		if (dev->parent)
+			spin_unlock(&dev->parent->power.lock);
+
+		/*
+		 * A suspend is running in parallel with us.  Wait for it to
+		 * complete and repeat.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		goto repeat;
+	} else if (dev->power.runtime_status == RPM_SUSPENDED && dev->parent
+	    && dev->parent->power.runtime_status != RPM_ACTIVE) {
+		spin_unlock(&dev->power.lock);
+		spin_unlock(&dev->parent->power.lock);
+
+		/* The device's parent is not active.  Resume it and repeat. */
+		error = pm_runtime_resume(dev->parent);
+		if (error)
+			return error;
+
+		goto repeat;
+	}
+
+	if (dev->power.runtime_status == RPM_RESUMING) {
+		spin_unlock(&dev->power.lock);
+		if (dev->parent)
+			spin_unlock(&dev->parent->power.lock);
+
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete and return.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_error;
+	}
+
+	dev->power.runtime_status = RPM_RESUMING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock(&dev->power.lock);
+	if (dev->parent)
+		spin_unlock(&dev->parent->power.lock);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
+		error = dev->bus->pm->runtime_resume(dev);
+
+	spin_lock(&dev->power.lock);
+
+	switch (error) {
+	case 0:
+		dev->power.runtime_status = RPM_ACTIVE;
+		break;
+	case -EAGAIN:
+	case -EBUSY:
+		dev->power.runtime_status = RPM_SUSPENDED;
+		break;
+	default:
+		dev->power.runtime_status = RPM_ERROR;
+	}
+	dev->power.runtime_error = error;
+	complete(&dev->power.work_done);
+
+ out:
+	spin_unlock(&dev->power.lock);
+
+	return error;
+
+ out_unlock:
+	if (dev->parent)
+		spin_unlock(&dev->parent->power.lock);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(pm_runtime_resume);
+
+/**
+ * pm_runtime_resume_work - Run pm_runtime_resume() for a device.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the resume has been scheduled for and run
+ * pm_runtime_resume() for it.
+ */
+static void pm_runtime_resume_work(struct work_struct *work)
+{
+	pm_runtime_resume(pm_work_to_device(work));
+}
+
+/**
+ * pm_request_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ */
+void pm_request_resume(struct device *dev)
+{
+	unsigned long parent_flags = 0, flags;
+
+ repeat:
+	if (atomic_read(&dev->power.depth) > 0)
+		return;
+
+	if (dev->parent)
+		spin_lock_irqsave(&dev->parent->power.lock, parent_flags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (dev->power.runtime_status == RPM_IDLE) {
+		/* Autosuspend request is pending, no need to resume. */
+		pm_cancel_suspend(dev);
+		goto out;
+	} else if (!(dev->power.runtime_status & RPM_IN_SUSPEND)) {
+		goto out;
+	} else if (dev->parent
+	    && (dev->parent->power.runtime_status & RPM_INACTIVE)) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
+
+		/* We have to resume the parent first. */
+		pm_request_resume(dev->parent);
+
+		goto repeat;
+	}
+
+	/*
+	 * The device may be suspending at the moment and we can't clear the
+	 * RPM_SUSPENDING bit in its runtime_status just yet.
+	 */
+	dev->power.runtime_status |= RPM_WAKE;
+	INIT_WORK(&dev->power.runtime_work.work, pm_runtime_resume_work);
+	queue_work(pm_wq, &dev->power.runtime_work.work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (dev->parent)
+		spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
+}
+EXPORT_SYMBOL_GPL(pm_request_resume);
+
+/**
+ * pm_cancel_runtime_suspend - Cancel a pending suspend request for a device.
+ * @dev: Device to handle.
+ *
+ * This routine is only supposed to be called when the run-time PM workqueue is
+ * frozen (i.e. during system-wide suspend or hibernation) when it is guaranteed
+ * that no work items are being executed.
+ */
+void pm_cancel_runtime_suspend(struct device *dev)
+{
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status == RPM_IDLE) {
+		cancel_delayed_work(&dev->power.runtime_work);
+		pm_runtime_reset(dev);
+	}
+
+	spin_unlock(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_cancel_runtime_suspend);
+
+/**
+ * pm_cancel_runtime_resume - Cancel a pending resume request for a device.
+ * @dev: Device to handle.
+ *
+ * This routine is only supposed to be called when the run-time PM workqueue is
+ * frozen (i.e. during system-wide suspend or hibernation) when it is guaranteed
+ * that no work items are being executed.
+ */
+void pm_cancel_runtime_resume(struct device *dev)
+{
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status & RPM_WAKE) {
+		work_clear_pending(&dev->power.runtime_work.work);
+		pm_runtime_reset(dev);
+	}
+
+	spin_unlock(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_cancel_runtime_resume);
+
+/**
+ * pm_runtime_disable - Disable run-time power management for given device.
+ * @dev: Device to handle.
+ *
+ * Increase the depth field in the device's dev_pm_info structure, which will
+ * cause the run-time PM functions above to return without doing anything.
+ * If there is a run-time PM operation in progress, wait for it to complete.
+ */
+void pm_runtime_disable(struct device *dev)
+{
+	might_sleep();
+
+	atomic_inc(&dev->power.depth);
+
+	if (dev->power.runtime_status & RPM_IN_PROGRESS)
+		wait_for_completion(&dev->power.work_done);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
+
+/**
+ * pm_runtime_enable - Disable run-time power management for given device.
+ * @dev: Device to handle.
+ *
+ * Enable run-time power management for given device by decreasing the depth
+ * field in its dev_pm_info structure.
+ */
+void pm_runtime_enable(struct device *dev)
+{
+	if (!atomic_add_unless(&dev->power.depth, -1, 0))
+		dev_warn(dev, "PM: Excessive pm_runtime_enable()!\n");
+}
+EXPORT_SYMBOL_GPL(pm_runtime_enable);
+
+/**
+ * pm_runtime_init - Initialize run-time PM fields in given device object.
+ * @dev: Device object to handle.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	pm_runtime_reset(dev);
+	spin_lock_init(&dev->power.lock);
+	atomic_set(&dev->power.depth, 1);
+	pm_suspend_check_children(dev, true);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,63 @@
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
+extern int pm_runtime_suspend(struct device *dev);
+extern void pm_request_suspend(struct device *dev, unsigned long delay);
+extern int pm_runtime_resume(struct device *dev);
+extern void pm_request_resume(struct device *dev);
+extern void pm_cancel_runtime_suspend(struct device *dev);
+extern void pm_cancel_runtime_resume(struct device *dev);
+extern void pm_runtime_disable(struct device *dev);
+extern void pm_runtime_enable(struct device *dev);
+
+static inline struct device *pm_work_to_device(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(dw, struct dev_pm_info, runtime_work);
+	return container_of(dpi, struct device, power);
+}
+
+static inline void pm_suspend_check_children(struct device *dev, bool enable)
+{
+	dev->power.suspend_skip_children = !enable;
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static inline void pm_runtime_init(struct device *dev) {}
+static inline int pm_runtime_suspend(struct device *dev) { return -ENOSYS; }
+static inline void pm_request_suspend(struct device *dev, unsigned long delay)
+{
+}
+static inline int pm_runtime_resume(struct device *dev) { return -ENOSYS; }
+static inline void pm_request_resume(struct device *dev) {}
+static inline void pm_cancel_runtime_suspend(struct device *dev) {}
+static inline void pm_cancel_runtime_resume(struct device *dev) {}
+static inline void pm_runtime_disable(struct device *dev) {}
+static inline void pm_runtime_enable(struct device *dev) {}
+
+static inline void pm_suspend_check_children(struct device *dev, bool enable)
+{
+}
+
+#endif /* !CONFIG_PM_RUNTIME */
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
@@ -0,0 +1,250 @@
+Run-time Power Management Framework for I/O Devices
+
+(C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+
+1. Introduction
+
+The support for run-time power management (run-time PM) of I/O devices is
+provided at the power management core (PM core) level by means of:
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
+The device run-time PM fields defined in 'struct dev_pm_info', the helper
+functions and the run-time PM callbacks defined in 'struct dev_pm_ops' are
+described in what follows.
+
+2. Run-time PM Helper Functions and Device Fields
+
+The following helper functions are defined in drivers/base/power/runtime.c
+and include/linux/pm_runtime.h:
+
+* void pm_runtime_init(struct device *dev);
+* void pm_runtime_enable(struct device *dev);
+* void pm_runtime_disable(struct device *dev);
+* int pm_runtime_suspend(struct device *dev);
+* void pm_request_suspend(struct device *dev, unsigned long delay);
+* int pm_runtime_resume(struct device *dev);
+* void pm_request_resume(struct device *dev);
+* void pm_cancel_runtime_suspend(struct device *dev);
+* void pm_cancel_runtime_resume(struct device *dev);
+* void pm_suspend_check_children(struct device *dev, bool enable);
+
+pm_runtime_init() initializes the run-time PM fields in the 'power' member of
+the device object.  It is called during the initialization of the device object,
+in drivers/base/power/main.c:device_pm_add().
+
+pm_runtime_enable() and pm_runtime_disable() are used to enable and disable,
+respectively, pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
+and pm_request_resume().  They do it by decreasing and increasing, respectively,
+the 'power.depth' field of 'struct device'.  If the value of this field is
+greater than 0, pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
+and pm_request_resume() return immediately without doing anything and -EBUSY is
+returned by pm_runtime_suspend() and pm_runtime_resume().  Therefore, if
+pm_runtime_disable() is called several times in a row for the same device, it
+has to be balanced by the appropriate number of pm_runtime_enable() calls so
+that the other run-time PM functions can be used for that device.  The initial
+value of 'power.depth', as set by pm_runtime_init(), is 1.
+
+pm_runtime_disable() and pm_runtime_enable() are used by the device core to
+disable the run-time PM of the device temporarily during device probe and
+removal as well as during system-wide power transitions (i.e. system-wide
+suspend or hibernation, or resume from a system sleep state).
+
+pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
+and pm_request_resume() use the 'power.runtime_status' and
+'power.suspend_aborted' fields of 'struct device' for mutual synchronization.
+These fields are initialized by pm_runtime_init() and set to RPM_ACTIVE and
+'false', respectively.
+
+pm_request_suspend() is used to queue up a suspend request for an active device.
+If the run-time PM status of the device (i.e. the value of the
+'power.runtime_status' field in 'struct device') is different from RPM_ACTIVE,
+it returns immediately.  Otherwise, it changes the device's run-time PM status
+to RPM_IDLE and puts a request to execute pm_runtime_suspend() into pm_wq.  The
+'delay' argument is used to specify time to wait before the request will be
+completed, in jiffies.
+
+pm_runtime_suspend() is used to carry out a run-time suspend of an active
+device.  It is called either by the PM core, to complete a request queued up by
+pm_request_suspend(), or directly by a bus type or device driver.
+* It returns immediately if the RPM_SUSPENDED bit is set in the device's
+  run-time PM status field ('power.runtime_status').
+* It returns -EAGAIN if at least one of the RPM_WAKE and RPM_RESUMING bits is
+  set the device's run-time PM status field.
+* If the device's run-time PM status is RPM_IDLE and 'power.suspend_aborted'
+  flag is set for it, the device's run-time PM status is set to RPM_ACTIVE and
+  the function returns success.
+* If the device's children are not suspended and the
+  'power.suspend_skip_children' flag is not set for it, -EAGAIN is returned.
+* If the device's run-time PM status is RPM_SUSPENDING, which means that another
+  instance of pm_runtime_suspend() is running at the same time for the same
+  device, the function waits for the other instance to complete and returns the
+  error code (or success) returned by it.
+If none of the above takes place, the device's run-time PM status is set to
+RPM_SUSPENDING and the device bus type's ->runtime_suspend() callback is
+executed, which is responsible for handling the device as appropriate (for
+example, it may choose to execute the device driver's ->runtime_suspend()
+callback or to carry out any other suitable action depending on the bus type).
+Next:
+* If it completes successfully, the RPM_SUSPENDED bit is set and the
+  RPM_SUSPENDING bit is cleared in the device's run-time PM status field.  Once
+  that has happened, the device is regarded by the PM core as suspended, but it
+  need not mean that the device has been put into a low power state.  What
+  really occurs to the device at this point totally depends on its bus type (it
+  may depend on the device's driver if the bus type chooses to call it).
+  Additionally, if the device bus type's ->runtime_suspend() callback completes
+  successfully, the device bus type's ->runtime_idle() callback is executed for
+  the device's parent if there is one and if all of its children are suspended
+  (or the 'power.suspend_skip_children' flag is set for it).
+* If either -EBUSY or -EAGAIN is returned, the device's run-time PM status is
+  set to RPM_ACTIVE.
+* If another error code is returned, the device's run-time PM status is set to
+  RPM_ERROR and the PM core will refuse to run pm_runtime_suspend(),
+  pm_request_suspend(), pm_runtime_resume(), and pm_request_resume() until the
+  status is changed to either RPM_ACTIVE or RPM_SUSPENDED by the device's bus
+  type or driver.
+Finally, pm_runtime_suspend() returns the error code (or success) returned by
+the device bus type's ->runtime_suspend() callback.
+
+pm_request_resume() is used to queue up a resume request for a device that is
+suspended, suspending or has a suspend request pending.
+* If a suspend request is pending for the device (i.e. the device's run-time PM
+  status is RPM_IDLE), it is cancelled and the function returns.
+* If the device is not suspended or suspending (i.e. none of the RPM_SUSPENDED
+  and RPM_SUSPENDING bits is set in the device's run-time PM status field), the
+  function returns.
+* If the device's parent is inactive, a resume request is scheduled for the
+  parent and the function is restarted.
+If none of the above happens, the RPM_WAKE bit is set in the device's run-time
+PM status field and the request to execute pm_runtime_resume() is put into
+pm_wq.
+
+pm_runtime_resume() is used to carry out a run-time resume of a device that is
+suspended, suspending or has a suspend request pending.  It is called either by
+the PM core, to complete a request queued up by pm_request_resume(), or
+directly by a bus type or device driver.
+* It returns immediately if the device's run-time PM status is RPM_ACTIVE.
+* If there's a suspend request pending for the device (i.e. the device's
+  run-time PM status is RPM_IDLE), it is cancelled and the function returns
+  success.
+* If the device is suspending (i.e. the RPM_SUSPENDING bit is set in the
+  device's run-time PM status field), the function waits for the suspend
+  operation to complete and restarts itself.
+* If the device is suspended (i.e. the RPM_SUSPENDED bit is set in the device's
+  run-time PM status field), the device's parent exists and is not active (i.e.
+  the parent's run-time PM status is not RPM_ACTIVE), pm_runtime_resume() is
+  called (recursively) for the parent and the function is restarted.
+* If the device is resuming (i.e. the device's run-time PM status is
+  RPM_RESUMING), which means that another instance of pm_runtime_resume() is
+  running at the same time for the same device, the function waits for the other
+  instance to complete and returns the result returned by it.
+If none of the above happens, the device's run-time PM status is set to
+RPM_RESUMING and the device bus type's ->runtime_resume() callback is executed,
+which is responsible for handling the device as appropriate (for example, it may
+choose to execute the device driver's ->runtime_resume() callback or to carry
+out any other suitable action depending on the bus type).  Next:
+* If it completes successfully, the device's run-time PM status is set to
+  RPM_ACTIVE, which means that the device is fully operational.  Thus, the
+  device bus type's ->runtime_resume() callback, when it is about to return
+  success, _must_ _ensure_ that this really is the case (i.e. when it returns,
+  the device _must_ be able to complete I/O operations as needed).
+* If either -EBUSY or -EAGAIN is returned, the device's run-time PM status is
+  set to RPM_SUSPENDED.
+* If another error code is returned, the device's run-time PM status is set to
+  RPM_ERROR and the PM core will refuse to run pm_runtime_suspend(),
+  pm_request_suspend(), pm_runtime_resume(), and pm_request_resume() until the
+  status is changed to either RPM_ACTIVE or RPM_SUSPENDED by the device's bus
+  type or driver.
+Finally, pm_runtime_resume() returns the error code (or success) returned by
+the device bus type's ->runtime_resume() callback.
+
+pm_cancel_runtime_suspend() is used to cancel a pending suspend request for an
+active device, but it can only be called when the run-time PM of the device
+is disabled.  It is supposed to be used during system-wide power transitions.
+
+pm_cancel_runtime_resume() is used to cancel a pending suspend request for
+a suspended device.  It can only be called when the run-time PM of the device
+is disabled and it is supposed to be used during system-wide power transitions.
+
+pm_suspend_check_children() is used to set or unset the
+'power.suspend_skip_children' flag in 'struct device'.  If the 'enabled'
+argument is 'true', the field is set to 0, and if 'enable' is 'false', the field
+is set to 1.  The default value of 'power.suspend_skip_children', as set by
+pm_runtime_init(), is 0.
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
