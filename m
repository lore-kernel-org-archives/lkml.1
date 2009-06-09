Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbZFIXKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbZFIXKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZFIXJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:09:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZFIXJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:09:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 00:57:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100057.04473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, Alan Stern wrote:
> On Mon, 8 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > Use of the RPM_UNKNOWN state isn't good.  A bus may have valid reasons 
> > > of its own for not carrying out an autosuspend.  When this happens the 
> > > device's state isn't unknown.
> > 
> > I'm not sure what you mean exactly.
> > 
> > If ->autosuspend() fails, the device power state may be known, but the core
> > can't be sure if the device is active.  This information is available to the
> > driver and/or the bus type, which should change the status to whatever is
> > appropriate.
> 
> But no matter what the driver or bus type sets the state to, your 
> pm_autosuspend() will change it to one of RPM_UNKNOWN or RPM_SUSPENDED.  
> Neither might be right.

The idea is that if ->autosuspend() or ->autoresume() returns an error code,
this is a situation the PM core cannot recover from by itself, so it shouldn't
pretend it knows what's happened.  Instead, it marks the device as "I don't
know if it is safe to touch this" and won't handle it until the device driver
or bus type clears the status.

> > The name of this constant may be confusing, but I didn't have any better ideas.
> 
> It's not clear what RPM_ACTIVE, RPM_IDLE, and RPM_SUSPENDED are 
> supposed to mean; this should be documented in the code.  Also, why 
> isn't there RPM_RESUMING?

Yes, there should be.  In fact it's in the current version of the patch, which
is appended.  Also, there's a comment explaining the meaning of the RPM_*
constants in pm.h .

> By the way, a legitimate reason for aborting an autosuspend is if the
> device's driver requires remote wakeup to be enabled during suspend but
> the user has disabled it.

Do you mean the user has disabled the remote wakeup?

> > > The scheme doesn't include any mechanism for communicating runtime
> > > power information up the device tree.  When a device is autosuspended,
> > > its parent's driver should be told so that the driver can consider
> > > autosuspending the parent.
> > 
> > I thought the bus type's ->autosuspend() callback could take care of this.
> 
> Shouldn't this happen after the device's state has changed to 
> RPM_SUSPENDED?  That's not until after the callback returns.

OK, I tried to address the issue of parent suspend/resume in the new
version of the patch below (I'm not sure if I did the nesting of spinlocks in
pm_request_resume() correctly).

> > > There should be a sysfs interface (like the one in USB) to allow
> > > userspace to prevent a device from being autosuspended -- and perhaps
> > > also to force it to be suspended.
> > 
> > To prevent a device from being suspended - yes.  To force it to stay suspended
> > - I'm not sure.
> 
> I'm not sure either.  Oliver Neukum requested it originally and it has
> been useful for debugging, but I haven't seen many places where it
> would come in useful in practice.

The problem with it is that the user space may not know if it is safe to keep
a device suspended and if it is not, the kernel will have to ignore the setting
anyway, so I'm not sure what's the point (except for debugging).

> > > What about devices that have more than two runtime power states?  For
> > > example, you can't squeeze PCI's {D0,D1,D2,D3hot} range into {running,
> > > suspended}.
> > 
> > That has to be bus type-specific.
> > 
> > In the case of PCI all of the low power states (D1-D3) are in fact substates of
> > "suspended", because we generally need to quiesce the device before putting
> > it into any of these states.
> > 
> > I'm not sure if we can introduce more "levels of suspension", so to speak, at
> > the core level, but in any case we can easily distinguish between "device
> > quiesced and in a low power state" and "device fully active".
> > 
> > So, in this picture the device is "suspended" from the core's point of view
> > once it's bus type's ->autosuspend() callback has been successfully executed. 
> 
> This too should be documented in the code.  Or in a Documentation file.

OK

I tried to address your comments and the Oliver's comments too in the new
version of the patch below.  Please have a look and tell me what you think.

Best,
Rafael

---
 drivers/base/power/Makefile  |    1 
 drivers/base/power/main.c    |    2 
 drivers/base/power/runtime.c |  318 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |   76 ++++++++++
 include/linux/pm_runtime.h   |   50 ++++++
 kernel/power/Kconfig         |   14 +
 kernel/power/main.c          |   17 ++
 7 files changed, 476 insertions(+), 2 deletions(-)

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
+	int (*autosuspend)(struct device *dev);
+	int (*autoresume)(struct device *dev);
+#endif
 };
 
 /**
@@ -315,14 +331,70 @@ enum dpm_state {
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
+ * RPM_SUSPENDING	Device bus type's ->autosuspend() callback is being
+ *			executed.
+ *
+ * RPM_SUSPENDED	Device bus type's ->autosuspend() callback has completed
+ *			successfully.  The device is regarded as suspended.
+ *
+ * RPM_WAKE		It has been requested that the device be woken up.
+ *			Resume request has been put into the run-time PM
+ *			workqueue and it's pending execution.
+ *
+ * RPM_RESUMING		Device bus type's ->autoresume() callback is being
+ *			executed.
+ *
+ * RPM_ERROR		Represents a condition from which the PM core cannot
+ *			recover by itself.  If the device's run-time PM status
+ *			field has this value, all of the run-time PM operations
+ *			carried out for the device by the core will fail, until
+ *			the status field is changed to either RPM_ACTIVE or
+ *			RPM_SUSPENDED (it is not valid to use the other values
+ *			in such a situation) by the device's driver or bus type.
+ *			This happens when the device bus type's ->autosuspend()
+ *			or ->autoresume() callback returns error code.
+ */
+enum rpm_state {
+	RPM_ERROR = -1,
+	RPM_ACTIVE,
+	RPM_IDLE,
+	RPM_SUSPENDING,
+	RPM_SUSPENDED,
+	RPM_WAKE,
+	RPM_RESUMING,
+};
+
 struct dev_pm_info {
 	pm_message_t		power_state;
-	unsigned		can_wakeup:1;
-	unsigned		should_wakeup:1;
+	unsigned int		can_wakeup:1;
+	unsigned int		should_wakeup:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
 	struct list_head	entry;
 #endif
+#ifdef	CONFIG_PM_RUNTIME
+	struct delayed_work	suspend_work;
+	struct completion	suspend_done;
+	unsigned int		suspend_aborted:1;
+	struct work_struct	resume_work;
+	enum rpm_state		runtime_status;
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
@@ -0,0 +1,318 @@
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
+ * Returns 0 if the device has been suspended or -EBUSY otherwise.
+ */
+static int pm_device_suspended(struct device *dev, void *data)
+{
+	int ret;
+
+	spin_lock(&dev->power.lock);
+
+	ret = dev->power.runtime_status == RPM_SUSPENDED ? 0 : -EBUSY;
+
+	spin_unlock(&dev->power.lock);
+
+	return ret;
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
+ * pm_autosuspend - Run autosuspend callback of given device object's bus type.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the suspend has been scheduled for,
+ * check if the suspend request hasn't been cancelled and run the
+ * ->autosuspend() callback from the device's bus type driver.  Update the
+ * run-time PM flags in the device object to reflect the current status of the
+ * device.
+ */
+static void pm_autosuspend(struct work_struct *work)
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
+	init_completion(&dev->power.suspend_done);
+
+	spin_unlock(&dev->power.lock);
+
+	if (dev && dev->bus && dev->bus->pm && dev->bus->pm->autosuspend)
+		error = dev->bus->pm->autosuspend(dev);
+
+	spin_lock(&dev->power.lock);
+
+	dev->power.runtime_status = error ? RPM_ERROR : RPM_SUSPENDED;
+	complete(&dev->power.suspend_done);
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
+ * pm_autoresume - Run autoresume callback of given device object's bus type.
+ * @work: Work structure used for scheduling the execution of this function.
+ *
+ * Use @work to get the device object the resume has been scheduled for,
+ * check if the device is really suspended and run the ->autoresume() callback
+ * from the device's bus type driver.  Update the run-time PM flags in the
+ * device object to reflect the current status of the device.
+ */
+static void pm_autoresume(struct work_struct *work)
+{
+	struct device *dev = resume_work_to_device(work);
+	int error = 0;
+
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status != RPM_WAKE)
+		goto out;
+
+	dev->power.runtime_status = RPM_RESUMING;
+
+	spin_unlock(&dev->power.lock);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->autoresume)
+		error = dev->bus->pm->autoresume(dev);
+
+	spin_lock(&dev->power.lock);
+
+	dev->power.runtime_status = error ? RPM_ERROR : RPM_ACTIVE;
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
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->parent->power.lock, flags);
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status == RPM_IDLE) {
+		/* ->autosuspend() hasn't started yet, no need to resume. */
+		pm_cancel_suspend(dev);
+		goto out;
+	} else if (dev->power.runtime_status != RPM_SUSPENDING
+	    && dev->power.runtime_status != RPM_SUSPENDED) {
+		goto out;
+	}
+
+	dev->power.runtime_status = RPM_WAKE;
+	queue_work(pm_wq, &dev->power.resume_work);
+
+ out:
+	spin_unlock(&dev->power.lock);
+	spin_unlock_irqrestore(&dev->parent->power.lock, flags);
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
+		/* ->autosuspend() hasn't started yet, no need to resume. */
+		pm_cancel_suspend(dev);
+		goto out;
+	}
+
+	if (dev->power.runtime_status == RPM_SUSPENDING) {
+		spin_unlock(&dev->power.lock);
+
+		/*
+		 * The ->autosuspend() callback is being executed right now,
+		 * wait for it to complete.
+		 */
+		wait_for_completion(&dev->power.suspend_done);
+	} else if (dev->power.runtime_status == RPM_SUSPENDED) {
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
+	spin_lock(&dev->parent->power.lock);
+	spin_lock(&dev->power.lock);
+
+	if (dev->power.runtime_status == RPM_RESUMING)
+		/* There's another resume running in parallel with us. */
+		error = -EAGAIN;
+	else if (dev->power.runtime_status != RPM_SUSPENDED)
+		error = -EINVAL;
+	if (error) {
+		spin_unlock(&dev->parent->power.lock);
+		goto out;
+	}
+
+	dev->power.runtime_status = RPM_RESUMING;
+
+	spin_unlock(&dev->power.lock);
+	spin_unlock(&dev->parent->power.lock);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->autoresume)
+		error = dev->bus->pm->autoresume(dev);
+
+	spin_lock(&dev->power.lock);
+
+	dev->power.runtime_status = error ? RPM_ERROR : RPM_ACTIVE;
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
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_autosuspend);
+	INIT_WORK(&dev->power.resume_work, pm_autoresume);
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
 

