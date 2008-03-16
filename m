Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYCPX06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYCPX06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYCPX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:26:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYCPX0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:26:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks
Date: Mon, 17 Mar 2008 00:22:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
References: <200803170020.55473.rjw@sisk.pl>
In-Reply-To: <200803170020.55473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170022.30345.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce 'struct pm_ops' representing a set of suspend and
hibernation operations for bus types, device classes and device
types.

Modify the PM core to use 'struct pm_ops' objects, if defined, instead
of the ->suspend(), ->resume(), ->suspend_late(), ->resume_early()
callbacks that will be considered as legacy and gradually phased out.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 arch/x86/kernel/apm_32.c  |    4 
 drivers/base/power/main.c |  453 +++++++++++++++++++++++++++++++++++-----------
 include/linux/device.h    |    8 
 include/linux/pm.h        |  241 +++++++++++++++++++++---
 kernel/power/disk.c       |   14 -
 kernel/power/main.c       |    4 
 6 files changed, 583 insertions(+), 141 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -114,7 +114,9 @@ typedef struct pm_message {
 	int event;
 } pm_message_t;
 
-/*
+/**
+ * struct pm_ops - device PM callbacks
+ *
  * Several driver power state transitions are externally visible, affecting
  * the state of pending I/O queues and (for drivers that touch hardware)
  * interrupts, wakeups, DMA, and other hardware state.  There may also be
@@ -122,6 +124,213 @@ typedef struct pm_message {
  * to the rest of the driver stack (such as a driver that's ON gating off
  * clocks which are not in active use).
  *
+ * The externally visible transitions are handled with the help of the following
+ * callbacks included in this structure:
+ *
+ * @prepare: Prepare the device for the upcoming transition, but do NOT change
+ *	its hardware state.  Prevent new children of the device from being
+ *	registered and prevent new calls to the probe method from being made
+ *	after @prepare() returns.  Also, if a concurrent child registration
+ *	or a call to the probe method already in progress is detected by
+ *	@prepare(), it may return -EAGAIN, so that the PM core can execute it
+ *	once again (e.g. after suspending the newly registered child) to recover
+ *	from the race condition. This method is executed for all kinds of
+ *	suspend transitions and is immediately followed by one of the suspend
+ *	callbacks: @suspend(), @freeze(), @poweroff(), or @quiesce().
+ *
+ * @complete: Undo the changes made by @prepare().  This method is executed for
+ *	all kinds of resume transitions, immediately following one of the resume
+ *	callbacks: @resume(), @thaw(), @restore(), or @recover().  Also executed
+ *	if a suspend callback (@suspend(), @freeze(), @poweroff(), @quiesce())
+ *	immediately following a successful @prepare() fails OR if a new child
+ *	of the device has been registered during @prepare().
+ *
+ * @suspend: Executed before putting the system into a sleep state in which the
+ *	contents of main memory are preserved.  Quiesce the device, put it into
+ *	a low power state appropriate for the upcoming system state (such as
+ *	PCI_D3hot), and enable wakeup events as appropriate.
+ *
+ * @resume: Executed after waking the system up from a sleep state in which the
+ *	contents of main memory were preserved.  Put the device into the
+ *	appropriate state, according to the information saved in memory by the
+ *	preceding @suspend().  The driver starts working again, responding to
+ *	hardware events and software requests.  The hardware may have gone
+ *	through a power-off reset, or it may have maintained state from the
+ *	previous suspend() which the driver may rely on while resuming.  On most
+ *	platforms, there are no restrictions on availability of resources like
+ *	clocks during @resume().
+ *
+ * @freeze: Hibernation-specific, executed before creating a hibernation image.
+ *	Quiesce operations so that a consistent image can be created, but do NOT
+ *	otherwise put the device into a low power device state and do NOT emit
+ *	system wakeup events.  Save in main memory the device settings to be
+ *	used by @restore() during the subsequent resume from hibernation.
+ *
+ * @thaw: Hibernation-specific, executed after creating a hibernation image.
+ *	Undo the changes made by the preceding @freeze(), so the device can be
+ *	operated in the same way as immediately before the call to @freeze().
+ *
+ * @poweroff: Hibernation-specific, executed after saving a hibernation image.
+ *	Quiesce the device, put it into a low power state appropriate for the
+ *	upcoming system state (such as PCI_D3hot), and enable wakeup events as
+ *	appropriate.
+ *
+ * @quiesce: Hibernation-specific, executed after loading a hibernation image
+ *	and before restoring the contents of main memory from it.  Quiesce
+ *	operations so that the contents of main memory can be restored from the
+ *	image in a consistent way, but do NOT otherwise put the device into a
+ *	low power state and do NOT emit system wakeup events.  Do NOT save any
+ *	device settings in main memory.
+ *
+ * @restore: Hibernation-specific, executed after restoring the contents of main
+ *	memory from a hibernation image.  Driver starts working again,
+ *	responding to hardware events and software requests.  Do NOT make ANY
+ *	assumptions about the hardware state right prior to @restore().  On most
+ *	platforms, there are no restrictions on availability of resources like
+ *	clocks during @restore().
+ *
+ * @recover: Hibernation-specific, executed after a failing creation of a
+ *	hibernation image OR after a failing attempt to restore the contents of
+ *	main memory from such an image.  Undo the changes made by the preceding
+ *	@freeze() or @quiesce(), so the device can be operated in the same way
+ *	as immediately before the failing transition.
+ *
+ * struct pm_ops is also used for defining driver PM operations to be carried
+ * out with interrupts disabled.  In this case, however, there is only one
+ * active CPU while the operations are being performed, so they are executed by
+ * the PM core in a more straightforward way.  In particular, the failure of
+ * @prepare() carried out with interrupts disabled causes the entire PM
+ * transition to fail, regardless of the error code returned by it.
+ *
+ * All of the above callbacks, except for @complete(), return error codes.
+ * However, the error codes returned by resume operations, @resume(), @thaw(),
+ * @restore(), and @recover(), are only printed in the system logs, since the
+ * PM core cannot do anything else about them.
+ */
+
+struct pm_ops {
+#ifdef CONFIG_PM_SLEEP
+	int (*prepare)(struct device *dev);
+	void (*complete)(struct device *dev);
+#endif
+#ifdef CONFIG_SUSPEND
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
+#endif
+#ifdef CONFIG_HIBERNATION
+	int (*freeze)(struct device *dev);
+	int (*thaw)(struct device *dev);
+	int (*poweroff)(struct device *dev);
+	int (*quiesce)(struct device *dev);
+	int (*restore)(struct device *dev);
+	int (*recover)(struct device *dev);
+#endif
+};
+
+/**
+ * PM_EVENT_ messages
+ *
+ * The following PM_EVENT_ messages are defined for the internal use of the PM
+ * core, in order to provide a mechanism allowing the high level suspend and
+ * hibernation code to convey the necessary information to the device PM core
+ * code:
+ *
+ * ON		No transition.
+ *
+ * FREEZE 	System is going to hibernate, call ->prepare() and ->freeze()
+ *		for all devices.
+ *
+ * SUSPEND	System is going to suspend, call ->prepare() and ->suspend()
+ *		for all devices.
+ *
+ * HIBERNATE	Hibernation image has been saved, call ->prepare() and
+ *		->poweroff() for all devices.
+ *
+ * QUIESCE	Contents of main memory are going to be restored from a (loaded)
+ *		hibernation image, call ->prepare() and ->quiesce() for all
+ *		devices.
+ *
+ * RESUME	System is resuming, call ->resume() and ->complete() for all
+ *		devices.
+ *
+ * THAW		Hibernation image has been created, call ->thaw() and
+ *		->complete() for all devices.
+ *
+ * RESTORE	Contents of main memory have been restored from a hibernation
+ *		image, call ->restore() and ->complete() for all devices.
+ *
+ * RECOVER	Creation of a hibernation image or restoration of the main
+ *		memory contents from a hibernation image has failed, call
+ *		->recover() and ->complete() for all devices.
+ */
+
+#define PM_EVENT_ON		0x0000
+#define PM_EVENT_FREEZE 	0x0001
+#define PM_EVENT_SUSPEND	0x0002
+#define PM_EVENT_HIBERNATE	0x0004
+#define PM_EVENT_QUIESCE	0x0008
+#define PM_EVENT_RESUME		0x0010
+#define PM_EVENT_THAW		0x0020
+#define PM_EVENT_RESTORE	0x0040
+#define PM_EVENT_RECOVER	0x0080
+
+#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
+
+#define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
+#define PMSG_QUIESCE	((struct pm_message){ .event = PM_EVENT_QUIESCE, })
+#define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
+#define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
+#define PMSG_RESUME	((struct pm_message){ .event = PM_EVENT_RESUME, })
+#define PMSG_THAW	((struct pm_message){ .event = PM_EVENT_THAW, })
+#define PMSG_RESTORE	((struct pm_message){ .event = PM_EVENT_RESTORE, })
+#define PMSG_RECOVER	((struct pm_message){ .event = PM_EVENT_RECOVER, })
+#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
+
+/**
+ * Device power management states
+ *
+ * These state labels are used internally by the PM core to indicate the current
+ * status of a device with respect to the PM core operations.
+ *
+ * DPM_ON		Device is regarded as operational.  Set this way
+ *			initially and when ->resume(), ->thaw(), ->restore(),
+ *			->recover(), or ->complete() is about to be called.
+ *			Also set when ->prepare() fails.
+ *
+ * DPM_SUSPENDING	Device is currently being suspended.  Set when
+ *			->prepare() is about to be called.
+ *
+ * DPM_OFF		Device is regarded as suspended.  Set when ->suspend(),
+ *			->freeze(), ->poweroff(), or ->quiesce() is about to be
+ *			called.
+ */
+
+enum dpm_state {
+	DPM_ON,
+	DPM_SUSPENDING,
+	DPM_OFF,
+};
+
+struct dev_pm_info {
+	pm_message_t		power_state;
+	unsigned		can_wakeup:1;
+	unsigned		should_wakeup:1;
+	enum dpm_state		status:2;	/* Owned by the PM core */
+#ifdef	CONFIG_PM_SLEEP
+	struct list_head	entry;
+#endif
+};
+
+/*
+ * The PM_EVENT_ messages are also used by drivers implementing the legacy
+ * suspend framework, based on the ->suspend() and ->resume() callbacks common
+ * for suspend and hibernation transitions, according to the rules below.
+ */
+
+/* Necessary, because several drivers use PM_EVENT_PRETHAW */
+#define PM_EVENT_PRETHAW PM_EVENT_QUIESCE
+
+/*
  * One transition is triggered by resume(), after a suspend() call; the
  * message is implicit:
  *
@@ -166,35 +375,11 @@ typedef struct pm_message {
  * or from system low-power states such as standby or suspend-to-RAM.
  */
 
-#define PM_EVENT_ON 0
-#define PM_EVENT_FREEZE 1
-#define PM_EVENT_SUSPEND 2
-#define PM_EVENT_HIBERNATE 4
-#define PM_EVENT_PRETHAW 8
-
-#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
-
-#define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
-#define PMSG_PRETHAW	((struct pm_message){ .event = PM_EVENT_PRETHAW, })
-#define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
-#define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
-#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
-
-struct dev_pm_info {
-	pm_message_t		power_state;
-	unsigned		can_wakeup:1;
-	unsigned		should_wakeup:1;
-	bool			sleeping:1;	/* Owned by the PM core */
-#ifdef	CONFIG_PM_SLEEP
-	struct list_head	entry;
-#endif
-};
+#ifdef CONFIG_PM_SLEEP
+extern void device_power_up(pm_message_t state);
+extern void device_resume(pm_message_t state);
 
 extern int device_power_down(pm_message_t state);
-extern void device_power_up(void);
-extern void device_resume(void);
-
-#ifdef CONFIG_PM_SLEEP
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -69,22 +69,30 @@ int device_pm_add(struct device *dev)
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
-		if (dev->parent->power.sleeping)
-			dev_warn(dev,
-				"parent %s is sleeping, will not add\n",
+	if (all_sleeping) {
+		dev_warn(dev, "all devices are sleeping, will not add\n");
+		goto Refuse;
+	}
+	if (dev->parent)
+		switch (dev->parent->power.status) {
+		case DPM_OFF:
+			dev_warn(dev, "parent %s is sleeping, will not add\n",
 				dev->parent->bus_id);
-		else
-			dev_warn(dev, "devices are sleeping, will not add\n");
-		WARN_ON(true);
-		error = -EBUSY;
-	} else {
-		error = dpm_sysfs_add(dev);
-		if (!error)
-			list_add_tail(&dev->power.entry, &dpm_active);
-	}
+			goto Refuse;
+		case DPM_SUSPENDING:
+			dev->parent->power.status = DPM_ON;
+			break;
+		}
+	error = dpm_sysfs_add(dev);
+	if (!error)
+		list_add_tail(&dev->power.entry, &dpm_active);
+ End:
 	mutex_unlock(&dpm_list_mtx);
 	return error;
+ Refuse:
+	WARN_ON(true);
+	error = -EBUSY;
+	goto End;
 }
 
 /**
@@ -122,26 +130,135 @@ void device_pm_schedule_removal(struct d
 }
 EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
 
+/**
+ *	pm_op - execute the PM operation appropiate for given PM event
+ *	@dev:	Device.
+ *	@ops:	PM operations to choose from.
+ *	@state:	PM event message.
+ */
+static int pm_op(struct device *dev, struct pm_ops *ops, pm_message_t state)
+{
+	int error = 0;
+
+	switch (state.event) {
+#ifdef CONFIG_SUSPEND
+	case PM_EVENT_SUSPEND:
+		if (ops->suspend) {
+			error = ops->suspend(dev);
+			suspend_report_result(ops->suspend, error);
+		}
+		break;
+	case PM_EVENT_RESUME:
+		if (ops->resume) {
+			error = ops->resume(dev);
+			suspend_report_result(ops->resume, error);
+		}
+		break;
+#endif /* CONFIG_SUSPEND */
+#ifdef CONFIG_HIBERNATION
+	case PM_EVENT_FREEZE:
+		if (ops->freeze) {
+			error = ops->freeze(dev);
+			suspend_report_result(ops->freeze, error);
+		}
+		break;
+	case PM_EVENT_QUIESCE:
+		if (ops->quiesce) {
+			error = ops->quiesce(dev);
+			suspend_report_result(ops->quiesce, error);
+		}
+		break;
+	case PM_EVENT_HIBERNATE:
+		if (ops->poweroff) {
+			error = ops->poweroff(dev);
+			suspend_report_result(ops->poweroff, error);
+		}
+		break;
+	case PM_EVENT_THAW:
+		if (ops->thaw) {
+			error = ops->thaw(dev);
+			suspend_report_result(ops->thaw, error);
+		}
+		break;
+	case PM_EVENT_RESTORE:
+		if (ops->restore) {
+			error = ops->restore(dev);
+			suspend_report_result(ops->restore, error);
+		}
+		break;
+	case PM_EVENT_RECOVER:
+		if (ops->recover) {
+			error = ops->recover(dev);
+			suspend_report_result(ops->recover, error);
+		}
+		break;
+#endif /* CONFIG_HIBERNATION */
+	default:
+		error = -EINVAL;
+	}
+	return error;
+}
+
+static char *pm_verb(int event)
+{
+	switch (event) {
+	case PM_EVENT_SUSPEND:
+		return "suspend";
+	case PM_EVENT_RESUME:
+		return "resume";
+	case PM_EVENT_FREEZE:
+		return "freeze";
+	case PM_EVENT_QUIESCE:
+		return "quiesce";
+	case PM_EVENT_HIBERNATE:
+		return "hibernate";
+	case PM_EVENT_THAW:
+		return "thaw";
+	case PM_EVENT_RESTORE:
+		return "restore";
+	default:
+		return "(unknown PM event)";
+	}
+}
+
+static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
+{
+	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
+		((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
+		", may wakeup" : "");
+}
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
- *	resume_device_early - Power on one device (early resume).
+ *	resume_device_noirq - Power on one device (early resume).
  *	@dev:	Device.
+ *	@state: Operation to carry out.
  *
  *	Must be called with interrupts disabled.
  */
-static int resume_device_early(struct device *dev)
+static int resume_device_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev, "EARLY resume\n");
+	if (!dev->bus)
+		goto End;
+
+	if (dev->bus->pm_noirq) {
+		struct pm_ops *ops = dev->bus->pm_noirq;
+
+		pm_dev_dbg(dev, state, "EARLY ");
+		error = pm_op(dev, ops, state);
+		if (ops->complete)
+			ops->complete(dev);
+	} else if (dev->bus->resume_early) {
+		pm_dev_dbg(dev, state, "legacy EARLY ");
 		error = dev->bus->resume_early(dev);
 	}
-
+ End:
 	TRACE_RESUME(error);
 	return error;
 }
@@ -156,7 +273,7 @@ static int resume_device_early(struct de
  *
  *	Must be called with interrupts disabled and only one CPU running.
  */
-static void dpm_power_up(void)
+static void dpm_power_up(pm_message_t state)
 {
 
 	while (!list_empty(&dpm_off_irq)) {
@@ -164,7 +281,7 @@ static void dpm_power_up(void)
 		struct device *dev = to_device(entry);
 
 		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
+		resume_device_noirq(dev, state);
 	}
 }
 
@@ -176,19 +293,46 @@ static void dpm_power_up(void)
  *
  *	Must be called with interrupts disabled.
  */
-void device_power_up(void)
+void device_power_up(pm_message_t state)
 {
 	sysdev_resume();
-	dpm_power_up();
+	dpm_power_up(state);
 }
 EXPORT_SYMBOL_GPL(device_power_up);
 
 /**
+ *	complete_device - Complete a PM transition for given device
+ *	@dev:	Device.
+ *	@state:	Power transition we are completing.
+ */
+static void complete_device(struct device *dev, pm_message_t state)
+{
+	down(&dev->sem);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->complete) {
+		pm_dev_dbg(dev, state, "completing ");
+		dev->bus->pm->complete(dev);
+	}
+
+	if (dev->type && dev->type->pm && dev->type->pm->complete) {
+		pm_dev_dbg(dev, state, "completing type ");
+		dev->type->pm->complete(dev);
+	}
+
+	if (dev->class && dev->class->pm && dev->class->pm->complete) {
+		pm_dev_dbg(dev, state, "completing class ");
+		dev->class->pm->complete(dev);
+	}
+
+	up(&dev->sem);
+}
+
+/**
  *	resume_device - Restore state for one device.
  *	@dev:	Device.
- *
+ *	@state:	Operation to carry out.
  */
-static int resume_device(struct device *dev)
+static int resume_device(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -197,21 +341,40 @@ static int resume_device(struct device *
 
 	down(&dev->sem);
 
-	if (dev->bus && dev->bus->resume) {
-		dev_dbg(dev,"resuming\n");
-		error = dev->bus->resume(dev);
+	if (dev->bus) {
+		if (dev->bus->pm) {
+			pm_dev_dbg(dev, state, "");
+			error = pm_op(dev, dev->bus->pm, state);
+		} else if (dev->bus->resume) {
+			pm_dev_dbg(dev, state, "legacy ");
+			error = dev->bus->resume(dev);
+		}
+		if (error)
+			goto End;
 	}
 
-	if (!error && dev->type && dev->type->resume) {
-		dev_dbg(dev,"resuming\n");
-		error = dev->type->resume(dev);
+	if (dev->type) {
+		if (dev->type->pm) {
+			pm_dev_dbg(dev, state, "type ");
+			error = pm_op(dev, dev->type->pm, state);
+		} else if (dev->type->resume) {
+			pm_dev_dbg(dev, state, "legacy type ");
+			error = dev->type->resume(dev);
+		}
+		if (error)
+			goto End;
 	}
 
-	if (!error && dev->class && dev->class->resume) {
-		dev_dbg(dev,"class resume\n");
-		error = dev->class->resume(dev);
+	if (dev->class) {
+		if (dev->class->pm) {
+			pm_dev_dbg(dev, state, "class ");
+			error = pm_op(dev, dev->class->pm, state);
+		} else if (dev->class->resume) {
+			pm_dev_dbg(dev, state, "legacy class ");
+			error = dev->class->resume(dev);
+		}
 	}
-
+ End:
 	up(&dev->sem);
 
 	TRACE_RESUME(error);
@@ -226,9 +389,9 @@ static int resume_device(struct device *
  *	went through the early resume.
  *
  *	Take devices from the dpm_off_list, resume them,
- *	and put them on the dpm_locked list.
+ *	and put them on the dpm_active list.
  */
-static void dpm_resume(void)
+static void dpm_resume(pm_message_t state)
 {
 	mutex_lock(&dpm_list_mtx);
 	all_sleeping = false;
@@ -237,9 +400,10 @@ static void dpm_resume(void)
 		struct device *dev = to_device(entry);
 
 		list_move_tail(entry, &dpm_active);
-		dev->power.sleeping = false;
+		dev->power.status = DPM_ON;
 		mutex_unlock(&dpm_list_mtx);
-		resume_device(dev);
+		resume_device(dev, state);
+		complete_device(dev, state);
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
@@ -267,14 +431,15 @@ static void unregister_dropped_devices(v
 
 /**
  *	device_resume - Restore state of each device in system.
+ *	@state: Operation to carry out.
  *
  *	Resume all the devices, unlock them all, and allow new
  *	devices to be registered once again.
  */
-void device_resume(void)
+void device_resume(pm_message_t state)
 {
 	might_sleep();
-	dpm_resume();
+	dpm_resume(state);
 	unregister_dropped_devices();
 }
 EXPORT_SYMBOL_GPL(device_resume);
@@ -282,37 +447,52 @@ EXPORT_SYMBOL_GPL(device_resume);
 
 /*------------------------- Suspend routines -------------------------*/
 
-static inline char *suspend_verb(u32 event)
+/**
+ *	resume_event - return a PM message representing the resume event
+ *	               corresponding to given sleep state.
+ *	@sleep_state - PM message representing a sleep state
+ */
+static pm_message_t resume_event(pm_message_t sleep_state)
 {
-	switch (event) {
-	case PM_EVENT_SUSPEND:	return "suspend";
-	case PM_EVENT_FREEZE:	return "freeze";
-	case PM_EVENT_PRETHAW:	return "prethaw";
-	default:		return "(unknown suspend event)";
+	switch (sleep_state.event) {
+	case PM_EVENT_SUSPEND:
+		return PMSG_RESUME;
+	case PM_EVENT_FREEZE:
+	case PM_EVENT_QUIESCE:
+		return PMSG_RECOVER;
+	case PM_EVENT_HIBERNATE:
+		return PMSG_RESTORE;
 	}
-}
-
-static void
-suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
-{
-	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
-		((state.event == PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
-		", may wakeup" : "");
+	return PMSG_ON;
 }
 
 /**
- *	suspend_device_late - Shut down one device (late suspend).
+ *	suspend_device_noirq - Shut down one device (late suspend).
  *	@dev:	Device.
- *	@state:	Power state device is entering.
+ *	@state:	PM message representing the operation to perform.
  *
  *	This is called with interrupts off and only a single CPU running.
  */
-static int suspend_device_late(struct device *dev, pm_message_t state)
+static int suspend_device_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
+	if (!dev->bus)
+		return 0;
+
+	if (dev->bus->pm_noirq) {
+		struct pm_ops *ops = dev->bus->pm_noirq;
+
+		pm_dev_dbg(dev, state, "LATE ");
+		if (ops->prepare)
+			error = ops->prepare(dev);
+		if (!error) {
+			error = pm_op(dev, ops, state);
+			if (error && ops->complete)
+				ops->complete(dev);
+		}
+	} else if (dev->bus->suspend_late) {
+		pm_dev_dbg(dev, state, "legacy LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);
 	}
@@ -321,7 +501,7 @@ static int suspend_device_late(struct de
 
 /**
  *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
+ *	@state:	PM message representing the operation to perform.
  *
  *	Power down devices that require interrupts to be disabled
  *	and move them from the dpm_off list to the dpm_off_irq list.
@@ -337,7 +517,7 @@ int device_power_down(pm_message_t state
 		struct list_head *entry = dpm_off.prev;
 		struct device *dev = to_device(entry);
 
-		error = suspend_device_late(dev, state);
+		error = suspend_device_noirq(dev, state);
 		if (error) {
 			printk(KERN_ERR "Could not power down device %s: "
 					"error %d\n",
@@ -351,12 +531,50 @@ int device_power_down(pm_message_t state
 	if (!error)
 		error = sysdev_suspend(state);
 	if (error)
-		dpm_power_up();
+		dpm_power_up(resume_event(state));
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_power_down);
 
 /**
+ *	prepare_device - Execute the ->prepare() callback(s) for given device.
+ *	@dev:	Device.
+ *	@state: PM operation we are preparing for.
+ */
+static int prepare_device(struct device *dev, pm_message_t state)
+{
+	int error = 0;
+
+	down(&dev->sem);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->prepare) {
+		pm_dev_dbg(dev, state, "preparing ");
+		error = dev->bus->pm->prepare(dev);
+		suspend_report_result(dev->bus->pm->prepare, error);
+		if (error)
+			goto End;
+	}
+
+	if (dev->type && dev->type->pm && dev->type->pm->prepare) {
+		pm_dev_dbg(dev, state, "preparing type ");
+		error = dev->type->pm->prepare(dev);
+		suspend_report_result(dev->type->pm->prepare, error);
+		if (error)
+			goto End;
+	}
+
+	if (dev->class && dev->class->pm && dev->class->pm->prepare) {
+		pm_dev_dbg(dev, state, "preparing class ");
+		error = dev->class->pm->prepare(dev);
+		suspend_report_result(dev->class->pm->prepare, error);
+	}
+ End:
+	up(&dev->sem);
+
+	return error;
+}
+
+/**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
  *	@state:	Power state device is entering.
@@ -367,29 +585,43 @@ static int suspend_device(struct device 
 
 	down(&dev->sem);
 
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
-	if (dev->class && dev->class->suspend) {
-		suspend_device_dbg(dev, state, "class ");
-		error = dev->class->suspend(dev, state);
-		suspend_report_result(dev->class->suspend, error);
+	if (dev->class) {
+		if (dev->class->pm) {
+			pm_dev_dbg(dev, state, "class ");
+			error = pm_op(dev, dev->class->pm, state);
+		} else if (dev->class->suspend) {
+			pm_dev_dbg(dev, state, "legacy class ");
+			error = dev->class->suspend(dev, state);
+			suspend_report_result(dev->class->suspend, error);
+		}
+		if (error)
+			goto End;
 	}
 
-	if (!error && dev->type && dev->type->suspend) {
-		suspend_device_dbg(dev, state, "type ");
-		error = dev->type->suspend(dev, state);
-		suspend_report_result(dev->type->suspend, error);
+	if (dev->type) {
+		if (dev->type->pm) {
+			pm_dev_dbg(dev, state, "type ");
+			error = pm_op(dev, dev->type->pm, state);
+		} else if (dev->type->suspend) {
+			pm_dev_dbg(dev, state, "legacy type ");
+			error = dev->type->suspend(dev, state);
+			suspend_report_result(dev->type->suspend, error);
+		}
+		if (error)
+			goto End;
 	}
 
-	if (!error && dev->bus && dev->bus->suspend) {
-		suspend_device_dbg(dev, state, "");
-		error = dev->bus->suspend(dev, state);
-		suspend_report_result(dev->bus->suspend, error);
+	if (dev->bus) {
+		if (dev->bus->pm) {
+			pm_dev_dbg(dev, state, "");
+			error = pm_op(dev, dev->bus->pm, state);
+		} else if (dev->bus->suspend) {
+			pm_dev_dbg(dev, state, "legacy ");
+			error = dev->bus->suspend(dev, state);
+			suspend_report_result(dev->bus->suspend, error);
+		}
 	}
-
+ End:
 	up(&dev->sem);
 
 	return error;
@@ -399,13 +631,8 @@ static int suspend_device(struct device 
  *	dpm_suspend - Suspend every device.
  *	@state:	Power state to put each device in.
  *
- *	Walk the dpm_locked list.  Suspend each device and move it
+ *	Walk the dpm_active list.  Suspend each device and move it
  *	to the dpm_off list.
- *
- *	(For historical reasons, if it returns -EAGAIN, that used to mean
- *	that the device would be called again with interrupts disabled.
- *	These days, we use the "suspend_late()" callback for that, so we
- *	print a warning and consider it an error).
  */
 static int dpm_suspend(pm_message_t state)
 {
@@ -416,30 +643,53 @@ static int dpm_suspend(pm_message_t stat
 		struct list_head *entry = dpm_active.prev;
 		struct device *dev = to_device(entry);
 
-		WARN_ON(dev->parent && dev->parent->power.sleeping);
+		WARN_ON(dev->parent && dev->parent->power.status == DPM_OFF);
+		dev->power.status = DPM_SUSPENDING;
+		mutex_unlock(&dpm_list_mtx);
+
+		error = prepare_device(dev, state);
 
-		dev->power.sleeping = true;
+		mutex_lock(&dpm_list_mtx);
+		if (error) {
+			dev->power.status = DPM_ON;
+			if (error == -EAGAIN)
+				continue;
+			printk(KERN_ERR "Could not prepare device %s "
+				"for suspend: error %d\n",
+				kobject_name(&dev->kobj), error);
+			goto Unlock;
+		}
+		if (dev->power.status == DPM_ON) {
+			/* Child added during prepare_device() */
+			mutex_unlock(&dpm_list_mtx);
+
+			complete_device(dev, resume_event(state));
+
+			mutex_lock(&dpm_list_mtx);
+			continue;
+		}
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
+
 		error = suspend_device(dev, state);
+
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
+			dev->power.status = DPM_ON;
 			printk(KERN_ERR "Could not suspend device %s: "
-					"error %d%s\n",
-					kobject_name(&dev->kobj),
-					error,
-					(error == -EAGAIN ?
-					" (please convert to suspend_late)" :
-					""));
-			dev->power.sleeping = false;
-			break;
+				"error %d\n", kobject_name(&dev->kobj), error);
+			mutex_unlock(&dpm_list_mtx);
+
+			complete_device(dev, resume_event(state));
+			goto End;
 		}
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_off);
 	}
-	if (!error)
-		all_sleeping = true;
+	all_sleeping = true;
+ Unlock:
 	mutex_unlock(&dpm_list_mtx);
-
+ End:
 	return error;
 }
 
@@ -447,8 +697,7 @@ static int dpm_suspend(pm_message_t stat
  *	device_suspend - Save state and stop all devices in system.
  *	@state: new power management state
  *
- *	Prevent new devices from being registered, then lock all devices
- *	and suspend them.
+ *	Prepare and suspend all devices.
  */
 int device_suspend(pm_message_t state)
 {
@@ -457,7 +706,7 @@ int device_suspend(pm_message_t state)
 	might_sleep();
 	error = dpm_suspend(state);
 	if (error)
-		device_resume();
+		device_resume(resume_event(state));
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_suspend);
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -69,6 +69,9 @@ struct bus_type {
 	int (*resume_early)(struct device *dev);
 	int (*resume)(struct device *dev);
 
+	struct pm_ops *pm;
+	struct pm_ops *pm_noirq;
+
 	struct bus_type_private *p;
 };
 
@@ -202,6 +205,8 @@ struct class {
 
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+
+	struct pm_ops *pm;
 };
 
 extern int __must_check class_register(struct class *class);
@@ -345,8 +350,11 @@ struct device_type {
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	void (*release)(struct device *dev);
+
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+
+	struct pm_ops *pm;
 };
 
 /* interface for exporting device attributes */
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -224,7 +224,7 @@ static int create_image(int platform_mod
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
-	device_power_up();
+	device_power_up(in_suspend ? PMSG_RECOVER : PMSG_RESTORE);
  Enable_irqs:
 	local_irq_enable();
 	return error;
@@ -280,7 +280,7 @@ int hibernation_snapshot(int platform_mo
  Finish:
 	platform_finish(platform_mode);
  Resume_devices:
-	device_resume();
+	device_resume(in_suspend ? PMSG_RECOVER : PMSG_RESTORE);
  Resume_console:
 	resume_console();
  Close:
@@ -301,7 +301,7 @@ static int resume_target_kernel(void)
 	int error;
 
 	local_irq_disable();
-	error = device_power_down(PMSG_PRETHAW);
+	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
@@ -329,7 +329,7 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
-	device_power_up();
+	device_power_up(PMSG_THAW);
  Enable_irqs:
 	local_irq_enable();
 	return error;
@@ -350,7 +350,7 @@ int hibernation_restore(int platform_mod
 
 	pm_prepare_console();
 	suspend_console();
-	error = device_suspend(PMSG_PRETHAW);
+	error = device_suspend(PMSG_QUIESCE);
 	if (error)
 		goto Finish;
 
@@ -362,7 +362,7 @@ int hibernation_restore(int platform_mod
 		enable_nonboot_cpus();
 	}
 	platform_restore_cleanup(platform_mode);
-	device_resume();
+	device_resume(PMSG_RECOVER);
  Finish:
 	resume_console();
 	pm_restore_console();
@@ -419,7 +419,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
-	device_resume();
+	device_resume(PMSG_RESTORE);
  Resume_console:
 	resume_console();
  Close:
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -239,7 +239,7 @@ static int suspend_enter(suspend_state_t
 	if (!suspend_test(TEST_CORE))
 		error = suspend_ops->enter(state);
 
-	device_power_up();
+	device_power_up(PMSG_RESUME);
  Done:
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
@@ -291,7 +291,7 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
-	device_resume();
+	device_resume(PMSG_RESUME);
  Resume_console:
 	resume_console();
  Close:
Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -1208,9 +1208,9 @@ static int suspend(int vetoable)
 	if (err != APM_SUCCESS)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
-	device_power_up();
+	device_power_up(PMSG_RESUME);
 	local_irq_enable();
-	device_resume();
+	device_resume(PMSG_RESUME);
 	queue_event(APM_NORMAL_RESUME, NULL);
  out:
 	spin_lock(&user_list_lock);

