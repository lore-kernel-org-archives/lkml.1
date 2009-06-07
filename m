Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZFGVrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZFGVrC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZFGVqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:46:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbZFGVqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:46:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Sun, 7 Jun 2009 23:46:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072347.00580.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Alan Stern wrote:
> On Sun, 7 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > Here's something I wanted to do quite some time ago.
> > 
> > kernel/power/main.c becomes more and more difficult to maintain over time,
> > since it contains both the suspend to RAM core code and some common PM code
> > that is also used for hibernation.  For this reason [1/2] separates the suspend
> > to RAM code from main.c and puts it into two new files (the test facility is,
> > again, separated from the core code for clarity).
> > 
> > [2/2] renames kernel/power/disk.c to kernel/power/hibernate.c, because the role
> > of this file is analogous to kernel/power/suspend.c (introduced by [1/2]).
> > 
> > Comments welcome.
> 
> Looks like a good idea to me.

Great, thanks for your feedback! :-)

BTW, I've been considering the run-time PM a bit recently and the result is
below (on top of this series).

I noticed that since resume can be scheduled while suspend is in progress,
we need two work structures in struct device, one for suspend and one for
resume.  Also, in theory, we may want to resume the device before the suspend
has a chance to run, so there should be some synchronization between them,
which is done with the help of the spinlock in dev_pm_info.

The general idea is that drivers or bus types may use pm_schedule_suspend()
to put a suspend request into the work queue and pm_schedule_resume() to
queue a resume request or cancel a pending suspend request.  There's no
requirement to use these functions, but I think they may be helpful in some
simple cases.

It may be necessary to resume a device synchronously, but I'm still thinking
how to implement that.

Please have a look.

Best,
Rafael

---
 drivers/base/power/Makefile  |    1 
 drivers/base/power/main.c    |    6 +
 drivers/base/power/runtime.c |  163 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |   36 ++++++++-
 include/linux/pm_runtime.h   |   82 +++++++++++++++++++++
 kernel/power/Kconfig         |   14 +++
 kernel/power/main.c          |   17 ++++
 7 files changed, 316 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -204,3 +204,17 @@ config APM_EMULATION
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
@@ -22,6 +22,8 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -165,6 +167,15 @@ typedef struct pm_message {
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
@@ -182,6 +193,10 @@ struct dev_pm_ops {
 	int (*thaw_noirq)(struct device *dev);
 	int (*poweroff_noirq)(struct device *dev);
 	int (*restore_noirq)(struct device *dev);
+#ifdef CONFIG_PM_RUNTIME
+	int (*autosuspend)(struct device *dev);
+	int (*autoresume)(struct device *dev);
+#endif
 };
 
 /**
@@ -315,14 +330,31 @@ enum dpm_state {
 	DPM_OFF_IRQ,
 };
 
+enum rpm_state {
+	RPM_UNKNOWN = -1,
+	RPM_ACTIVE,
+	RPM_IDLE,
+	RPM_SUSPENDING,
+	RPM_SUSPENDED,
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
+	struct work_struct	resume_work;
+	unsigned int		suspend_autocancel:1;
+	unsigned int		resume_autocancel:1;
+	unsigned int		suspend_aborted:1;
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
@@ -0,0 +1,163 @@
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
+	dev->power.resume_autocancel = false;
+	dev->power.suspend_autocancel = false;
+	dev->power.suspend_aborted = false;
+	dev->power.runtime_status = RPM_ACTIVE;
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
+	pm_lock_device(dev);
+	if (dev->power.suspend_aborted) {
+		dev->power.runtime_status = RPM_ACTIVE;
+		goto out;
+	}
+	dev->power.suspend_autocancel = false;
+	dev->power.runtime_status = RPM_SUSPENDING;
+	pm_unlock_device(dev);
+
+	if (dev && dev->bus && dev->bus->pm && dev->bus->pm->autosuspend)
+		error = dev->bus->pm->autosuspend(dev);
+
+	pm_lock_device(dev);
+	dev->power.runtime_status = error ? RPM_UNKNOWN : RPM_SUSPENDED;
+ out:
+	pm_unlock_device(dev);
+}
+
+/**
+ * __pm_schedule_suspend - Schedule run-time suspend of given device.
+ * @dev: Device to suspend.
+ * @delay: Time to wait before attempting to suspend the device.
+ * @autocancel: If set, the request will be cancelled during a resume from a
+ *	system-wide sleep state if it happens before @delay elapses.
+ */
+void __pm_schedule_suspend(struct device *dev, unsigned long delay,
+			   bool autocancel)
+{
+	pm_lock_device(dev);
+	if (dev->power.runtime_status != RPM_ACTIVE)
+		goto out;
+	dev->power.suspend_autocancel = autocancel;
+	dev->power.suspend_aborted = false;
+	dev->power.runtime_status = RPM_IDLE;
+	INIT_DELAYED_WORK(&dev->power.suspend_work, pm_autosuspend);
+	queue_delayed_work(pm_wq, &dev->power.suspend_work, delay);
+ out:
+	pm_unlock_device(dev);
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
+	pm_lock_device(dev);
+	dev->power.resume_autocancel = false;
+	if (dev->power.runtime_status != RPM_SUSPENDED)
+		goto out;
+	pm_unlock_device(dev);
+
+	if (dev && dev->bus && dev->bus->pm && dev->bus->pm->autoresume)
+		error = dev->bus->pm->autoresume(dev);
+
+	pm_lock_device(dev);
+	dev->power.runtime_status = error ? RPM_UNKNOWN : RPM_ACTIVE;
+ out:
+	pm_unlock_device(dev);
+}
+
+/**
+ * __pm_schedule_resume - Schedule run-time resume of given device.
+ * @dev: Device to resume.
+ * @autocancel: If set, the request will be cancelled during a resume from a
+ *	system-wide sleep state if it happens before pm_autoresume() can be run.
+ */
+void __pm_schedule_resume(struct device *dev, bool autocancel)
+{
+	pm_lock_device(dev);
+	if (dev->power.runtime_status == RPM_IDLE) {
+		dev->power.suspend_autocancel = false;
+		dev->power.suspend_aborted = true;
+		cancel_delayed_work(&dev->power.suspend_work);
+		dev->power.runtime_status = RPM_ACTIVE;
+	} else if (dev->power.runtime_status != RPM_ACTIVE) {
+		dev->power.resume_autocancel = autocancel;
+		INIT_WORK(&dev->power.resume_work, pm_autoresume);
+		queue_work(pm_wq, &dev->power.resume_work);
+	}
+	pm_unlock_device(dev);
+}
+
+/**
+ * pm_runtime_autocancel - Cancel run-time PM requests during system resume.
+ * @dev: Device to handle.
+ *
+ * If dev->power.suspend_autocancel is set during resume from a system sleep
+ * state, there is a run-time suspend request pending that has to be cancelled,
+ * so cancel it, and analogously for pending run-time resume requests.
+ *
+ * This function is only called by the PM core and must not be used by bus types
+ * and device drivers.  Moreover, it is called when the workqueue is frozen, so
+ * it is guaranteed that the autosuspend callbacks are not running at that time.
+ */
+void pm_runtime_autocancel(struct device *dev)
+{
+	pm_lock_device(dev);
+	if (dev->power.suspend_autocancel) {
+		cancel_delayed_work(&dev->power.suspend_work);
+		pm_runtime_reset(dev);
+	} else if (dev->power.resume_autocancel) {
+		work_clear_pending(&dev->power.resume_work);
+		pm_runtime_reset(dev);
+	}
+	pm_unlock_device(dev);
+}
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_runtime.h
@@ -0,0 +1,82 @@
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
+extern void __pm_schedule_suspend(struct device *dev, unsigned long delay,
+				   bool autocancel);
+extern void __pm_schedule_resume(struct device *dev, bool autocancel);
+extern void pm_runtime_autocancel(struct device *dev);
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
+static inline void pm_lock_device(struct device *dev)
+{
+	spin_lock(&dev->power.lock);
+}
+
+static inline void pm_unlock_device(struct device *dev)
+{
+	spin_unlock(&dev->power.lock);
+}
+#else /* !CONFIG_PM_RUNTIME */
+static inline void pm_runtime_init(struct device *dev) {}
+static inline void __pm_schedule_suspend(struct device *dev,
+					  unsigned long delay,
+					  bool autocancel) {}
+static inline void __pm_schedule_resume(struct device *dev, bool autocancel) {}
+static inline void pm_runtime_autocancel(struct device *dev) {}
+
+static inline void pm_lock_device(struct device *dev) {}
+static inline void pm_unlock_device(struct device *dev) {}
+#endif /* !CONFIG_PM_RUNTIME */
+
+static inline void pm_schedule_suspend(struct device *dev, unsigned long delay)
+{
+	__pm_schedule_suspend(dev, delay, false);
+}
+
+static inline void pm_schedule_suspend_autocancel(struct device *dev,
+						   unsigned long delay)
+{
+	__pm_schedule_suspend(dev, delay, true);
+}
+
+static inline void pm_schedule_resume(struct device *dev)
+{
+	__pm_schedule_resume(dev, false);
+}
+
+static inline void pm_schedule_resume_autocancel(struct device *dev)
+{
+	__pm_schedule_resume(dev, true);
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
 
@@ -355,7 +357,7 @@ void dpm_resume_noirq(pm_message_t state
 	struct device *dev;
 
 	mutex_lock(&dpm_list_mtx);
-	list_for_each_entry(dev, &dpm_list, power.entry)
+	list_for_each_entry(dev, &dpm_list, power.entry) {
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
@@ -364,6 +366,8 @@ void dpm_resume_noirq(pm_message_t state
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+		pm_runtime_autocancel(dev);
+	}
 	mutex_unlock(&dpm_list_mtx);
 	resume_device_irqs();
 }
