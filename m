Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZFKNqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZFKNqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZFKNqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:46:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZFKNqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:46:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 15:46:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906110001.20718.rjw@sisk.pl> <200906110107.23023.oliver@neukum.org>
In-Reply-To: <200906110107.23023.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111546.27927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Oliver Neukum wrote:
> Am Donnerstag, 11. Juni 2009 00:01:20 schrieb Rafael J. Wysocki:
> > We have queued up resume requests for the device's parent, its parent etc.,
> > the topmost one goes first.  The workqueue is singlethread, so
> > pm_autoresume() is going to be run for all parents before the device
> > itself, so if that were the only resume mechanism, it would be enough to
> > check if the parent is RPM_ACTIVE.
> 
>             A (IDLE)
>     /                                \
> B (SUSPENDED)         C (SUSPENDED)
> 
> Suppose C is to be resumed. This means first in case of A the request
> to suspend would be cancelled. Here you drop the locks:
> 
> +           && (dev->parent->power.runtime_status == RPM_IDLE
> +             || dev->parent->power.runtime_status == RPM_SUSPENDING
> +             || dev->parent->power.runtime_status == RPM_SUSPENDED)) {
> +               spin_unlock_irqrestore(&dev->power.lock, flags);
> +               spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
> +
> +               /* We have to resume the parent first. */
> +               pm_request_resume(dev->parent);
> 
> But after pm_request_resume() returns there's no means to make sure
> nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
> you because you've scheduled nothing by that time. The suspension will
> work because C is still in RPM_SUSPENDED.

That exactly is the bug I told you about in one of the previous messages. :-)

The solution I used in the current version of the patch (appended) is to have
separate bits for RPM_WAKE and RPM_SUSPENDED (and for the other status
constants), so that they both can be set at a time.

Well, there probably still are some bugs lurking in it ...

Best,
Rafael

---
 drivers/base/power/Makefile  |    1 
 drivers/base/power/main.c    |    2 
 drivers/base/power/runtime.c |  415 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |   82 ++++++++
 include/linux/pm_runtime.h   |   50 +++++
 kernel/power/Kconfig         |   14 +
 kernel/power/main.c          |   17 +
 7 files changed, 578 insertions(+), 3 deletions(-)

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
@@ -165,6 +168,15 @@ typedef struct pm_message {
  * It is allowed to unregister devices while the above callbacks are being
  * executed.  However, it is not allowed to unregister a device from within any
  * of its own callbacks.
+ *
+ * There also are two callbacks related to run-time power management of devices:
+ *
+ * @autosuspend: Save the device registers and put it into an energy-saving (low
+ *	power) state at run-time, enable wake-up events as appropriate.
+ *
+ * @autoresume: Put the device into the full power state and restore its
+ *	registers (if applicable) at run time, in response to a wake-up event
+ *	generated by hardware or at a request of software.
  */
 
 struct dev_pm_ops {
@@ -182,6 +194,10 @@ struct dev_pm_ops {
 	int (*thaw_noirq)(struct device *dev);
 	int (*poweroff_noirq)(struct device *dev);
 	int (*restore_noirq)(struct device *dev);
+#ifdef CONFIG_PM_RUNTIME
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+#endif
 };
 
 /**
@@ -315,14 +331,74 @@ enum dpm_state {
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
+
+#define RPM_IN_SUSPEND	(RPM_SUSPENDING | RPM_SUSPENDED)
+#define RPM_INACTIVE	(RPM_IDLE | RPM_IN_SUSPEND)
+#define RPM_ERROR	(-1)
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
+	unsigned int		suspend_aborted:1;
+	unsigned int		runtime_status:5;
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
@@ -0,0 +1,415 @@
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
+	return device_for_each_child(dev, NULL, pm_device_suspended);
+}
+
+/**
+ * pm_runtime_suspend - Run a device bus type's runtime_suspend() callback.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the suspend has been scheduled for,
+ * check if the suspend request hasn't been cancelled and run the
+ * ->runtime_suspend() callback provided by the device's bus type driver.
+ * Update the run-time PM flags in the device object to reflect the current
+ * status of the device.
+ */
+static void pm_runtime_suspend(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct device *dev = suspend_work_to_device(dw);
+	int error = 0;
+
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.suspend_aborted) {
+		dev->power.runtime_status = RPM_ACTIVE;
+		goto out;
+	} else if (dev->power.runtime_status != RPM_IDLE) {
+		goto out;
+	} else if (pm_check_children(dev)) {
+		/*
+		 * We can only suspend the device if all of its children have
+		 * been suspended.
+		 */
+		goto out;
+	}
+
+	dev->power.runtime_status = RPM_SUSPENDING;
+	init_completion(&dev->power.work_done);
+
+	spin_unlock(&dev->power.lock);
+
+	if (dev && dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
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
+	complete(&dev->power.work_done);
+
+ out:
+	spin_unlock(&dev->power.lock);
+}
+
+/**
+ * pm_request_suspend - Schedule run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @delay: Time to wait before attempting to suspend the device.
+ */
+void pm_request_suspend(struct device *dev, unsigned long delay)
+{
+	unsigned long flags;
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
+	cancel_delayed_work(&dev->power.suspend_work);
+	dev->power.runtime_status = RPM_ACTIVE;
+}
+
+/**
+ * pm_runtime_resume - Run a device bus type's runtime_resume() callback.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the resume has been scheduled for,
+ * check if the device is really suspended and run the ->runtime_resume()
+ * callback provided by the device's bus type driver.  Update the run-time PM
+ * flags in the device object to reflect the current status of the device.
+ */
+static void pm_runtime_resume(struct work_struct *work)
+{
+	struct device *dev = resume_work_to_device(work);
+	int error = 0;
+
+	if (dev->parent)
+		spin_lock(&dev->parent->power.lock);
+	spin_lock(&dev->power.lock);
+
+	/*
+	 * Since the PM workqueue is singlethread, this function cannot run
+	 * in parallel with pm_runtime_suspend().  For this reason it is not
+	 * necessary to check if RPM_SUSPENDING is set in runtime_status of the
+	 * device.
+	 */
+ repeat:
+	if (!(dev->power.runtime_status & RPM_WAKE)) {
+		if (dev->parent)
+			spin_unlock(&dev->parent->power.lock);
+		goto out;
+	} else if (dev->parent
+	    && dev->parent->power.runtime_status != RPM_ACTIVE) {
+		/*
+		 * Although this function cannot run in parallel with another
+		 * instance of itself, it may be running in parallel with the
+		 * synchronous resume of another device.  In particular, that
+		 * may be the device's parent.
+		 */
+		if (dev->parent->power.runtime_status & RPM_RESUMING) {
+			spin_unlock(&dev->power.lock);
+			spin_unlock(&dev->parent->power.lock);
+
+			wait_for_completion(&dev->parent->power.work_done);
+
+			spin_lock(&dev->parent->power.lock);
+			spin_lock(&dev->power.lock);
+		}
+		if (dev->parent->power.runtime_status != RPM_ACTIVE) {
+			spin_unlock(&dev->parent->power.lock);
+			goto out;
+		}
+		goto repeat;
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
+	complete(&dev->power.work_done);
+
+ out:
+	spin_unlock(&dev->power.lock);
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
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	if (dev->parent)
+		spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
+}
+
+/**
+ * pm_resume_sync - Resume given device waiting for the operation to complete.
+ * @dev: Device to resume.
+ *
+ * Resume the device synchronously, waiting for the operation to complete.  If
+ * autosuspend is in progress while this function is being run, wait for it to
+ * finish before resuming the device.  If the autosuspend is scheduled, but it
+ * hasn't started yet, cancel it and we're done.
+ */
+int pm_resume_sync(struct device *dev)
+{
+	int error = 0;
+
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status == RPM_ACTIVE) {
+		goto out;
+	} if (dev->power.runtime_status == RPM_IDLE) {
+		/* ->runtime_suspend() hasn't started yet, no need to resume. */
+		pm_cancel_suspend(dev);
+		goto out;
+	}
+
+	if (dev->power.runtime_status & RPM_SUSPENDING) {
+		spin_unlock(&dev->power.lock);
+
+		/*
+		 * The ->runtime_suspend() callback is being executed right now,
+		 * wait for it to complete.
+		 */
+		wait_for_completion(&dev->power.work_done);
+	} else if (dev->power.runtime_status == RPM_SUSPENDED && dev->parent) {
+		spin_unlock(&dev->power.lock);
+
+		/* The device's parent may also be suspended.  Resume it. */
+		error = pm_resume_sync(dev->parent);
+		if (error)
+			return error;
+	} else {
+		spin_unlock(&dev->power.lock);
+	}
+
+	if (dev->parent)
+		spin_lock(&dev->parent->power.lock);
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status & RPM_WAKE) {
+		/* There's a pending resume request that can be cancelled. */
+		work_clear_pending(&dev->power.resume_work);
+	} else if (dev->power.runtime_status == RPM_RESUMING) {
+		spin_unlock(&dev->power.lock);
+		if (dev->parent)
+			spin_unlock(&dev->parent->power.lock);
+
+		/*
+		 * There's another resume running in parallel with us. Wait for
+		 * it to complete.
+		 */
+		wait_for_completion(&dev->power.work_done);
+
+		return dev->power.runtime_status == RPM_ACTIVE ? 0 : -EAGAIN;
+	} else if (!(dev->power.runtime_status & RPM_SUSPENDED)) {
+		error = -EINVAL;
+		if (dev->parent)
+			spin_unlock(&dev->parent->power.lock);
+		goto out;
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
+	complete(&dev->power.work_done);
+
+ out:
+	spin_unlock(&dev->power.lock);
+
+	return error;
+}
+
+/**
+ * pm_cancel_autosuspend - Cancel a pending autosuspend request for given device
+ * @dev: Device to handle.
+ *
+ * This routine is only supposed to be called when the run-time PM workqueue is
+ * frozen (i.e. during system-wide suspend or hibernation) when it is guaranteed
+ * that no work items are being executed.
+ */
+void pm_cancel_autosuspend(struct device *dev)
+{
+	spin_lock(&dev->power.lock);
+
+	cancel_delayed_work(&dev->power.suspend_work);
+	pm_runtime_reset(dev);
+
+	spin_unlock(&dev->power.lock);
+}
+
+/**
+ * pm_cancel_autoresume - Cancel a pending autoresume request for given device
+ * @dev: Device to handle.
+ *
+ * This routine is only supposed to be called when the run-time PM workqueue is
+ * frozen (i.e. during system-wide suspend or hibernation) when it is guaranteed
+ * that no work items are being executed.
+ */
+void pm_cancel_autoresume(struct device *dev)
+{
+	spin_lock(&dev->power.lock);
+
+	work_clear_pending(&dev->power.resume_work);
+	pm_runtime_reset(dev);
+
+	spin_unlock(&dev->power.lock);
+}
+
+/**
+ * pm_runtime_init - Initialize run-time PM fields in given device object.
+ * @dev: Device object to handle.
+ */
+void pm_runtime_init(struct device *dev)
+{
+	pm_runtime_reset(dev);
+	spin_lock_init(&dev->power.lock);
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_runtime_suspend);
+	INIT_WORK(&dev->power.resume_work, pm_runtime_resume);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,50 @@
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
+extern struct workqueue_struct *pm_wq;
+
+extern void pm_runtime_init(struct device *dev);
+extern void pm_request_suspend(struct device *dev, unsigned long delay);
+extern void pm_request_resume(struct device *dev);
+extern int pm_resume_sync(struct device *dev);
+extern void pm_cancel_autosuspend(struct device *dev);
+extern void pm_cancel_autoresume(struct device *dev);
+
+static inline struct device *suspend_work_to_device(struct delayed_work *work)
+{
+	struct dev_pm_info *dpi;
+
+	dpi = container_of(work, struct dev_pm_info, suspend_work);
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
+#else /* !CONFIG_PM_RUNTIME */
+static inline void pm_runtime_init(struct device *dev) {}
+static inline void pm_request_suspend(struct device *dev, unsigned long delay);
+static inline void pm_request_resume(struct device *dev) {}
+static inline int pm_resume_sync(struct device *dev) { return -ENOSYS; }
+static inline void pm_cancel_autosuspend(struct device *dev) {}
+static inline void pm_cancel_autoresume(struct device *dev) {}
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
 
