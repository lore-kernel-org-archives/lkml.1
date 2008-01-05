Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbYAEV4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbYAEV4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYAEV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:56:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbYAEV4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:56:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sat, 5 Jan 2008 22:58:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801051634500.29588-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801051634500.29588-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801052258.52272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Alan Stern wrote:
> On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> 
> > On Saturday, 5 of January 2008, Alan Stern wrote:
> > > On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> > > 
> > > > > Another thing to watch out for: Just in case somebody ends up calling
> > > > > destroy_suspended_device(dev) from within dev's own resume method, you 
> > > > > should interchange the resume_device() and the list_move_tail() 
> > > > > calls in dpm_resume().
> > > > 
> > > > However, if we unregister them all at once after releasing pm_sleep_rwsem,
> > > > that shouldn't be necessary, right?
> > > 
> > > It's still necessary, because destroy_suspended_device() still has to
> > > move the device from one list to another.  You don't want it to end up 
> > > on the dpm_locked list.
> > 
> > Hmm.  That means we'd have to do the same thing in dpm_power_up() in case
> > someone calls destroy_suspended_device() from resume_device_early(dev).
> 
> Yes.
> 
> > Still, even doing that is not enough, since someone can call
> > destroy_suspended_device() from a .suspend() routine and then the device
> > will end up on a wrong list just as well.
> 
> That should never happen.  The whole idea of destroy_suspended_device()
> is that the device couldn't be resumed and in fact should be
> unregistered because it is no longer working or no longer present.  A
> suspend routine won't detect this sort of thing since it doesn't try to
> resume the device.
> 
> But it wouldn't hurt to mention in the kerneldoc that 
> destroy_suspended_device() is meant to be called only during a system 
> resume.

Hmm.  Please have a look at the appended patch.

I have removed the warning from device_del() and used list_empty() to detect
removed devices in the .suspend() routines.  Is that viable?

Rafael


---
 arch/x86/kernel/cpuid.c    |    6 
 arch/x86/kernel/msr.c      |    6 
 drivers/base/core.c        |   67 +++++-
 drivers/base/power/main.c  |  454 ++++++++++++++++++++++++++-------------------
 drivers/base/power/power.h |   12 +
 include/linux/device.h     |    8 
 6 files changed, 354 insertions(+), 199 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -726,11 +726,20 @@ int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
-	int error = -EINVAL;
+	int error;
+
+	error = pm_sleep_lock();
+	if (error) {
+		dev_warn(dev, "Illegal %s during suspend\n", __FUNCTION__);
+		dump_stack();
+		return error;
+	}
 
 	dev = get_device(dev);
-	if (!dev || !strlen(dev->bus_id))
-		goto Error;
+	if (!dev || !strlen(dev->bus_id)) {
+		error = -EINVAL;
+		goto Done;
+	}
 
 	pr_debug("DEV: registering device: ID = '%s'\n", dev->bus_id);
 
@@ -795,6 +804,7 @@ int device_add(struct device *dev)
 	}
  Done:
 	put_device(dev);
+	pm_sleep_unlock();
 	return error;
  BusError:
 	device_pm_remove(dev);
@@ -1156,14 +1173,11 @@ error:
 EXPORT_SYMBOL_GPL(device_create);
 
 /**
- * device_destroy - removes a device that was created with device_create()
+ * find_device - finds a device that was created with device_create()
  * @class: pointer to the struct class that this device was registered with
  * @devt: the dev_t of the device that was previously registered
- *
- * This call unregisters and cleans up a device that was created with a
- * call to device_create().
  */
-void device_destroy(struct class *class, dev_t devt)
+static struct device *find_device(struct class *class, dev_t devt)
 {
 	struct device *dev = NULL;
 	struct device *dev_tmp;
@@ -1176,12 +1190,49 @@ void device_destroy(struct class *class,
 		}
 	}
 	up(&class->sem);
+	return dev;
+}
+
+/**
+ * device_destroy - removes a device that was created with device_create()
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call unregisters and cleans up a device that was created with a
+ * call to device_create().
+ */
+void device_destroy(struct class *class, dev_t devt)
+{
+	struct device *dev;
 
+	dev = find_device(class, devt);
 	if (dev)
 		device_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
+#ifdef CONFIG_PM_SLEEP
+/**
+ * destroy_suspended_device - asks the PM core to remove a suspended device
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call causes the PM core to release and unregister a suspended device
+ * created with a call to device_create() (devices cannot be unregistered
+ * directly while suspended, since the PM core holds their semaphores at that
+ * time).
+ */
+void destroy_suspended_device(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev = find_device(class, devt);
+	if (dev)
+		device_pm_destroy_suspended(dev);
+}
+EXPORT_SYMBOL_GPL(destroy_suspended_device);
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -521,6 +521,14 @@ extern struct device *device_create(stru
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf,4,5)));
 extern void device_destroy(struct class *cls, dev_t devt);
+#ifdef CONFIG_PM_SLEEP
+extern void destroy_suspended_device(struct class *cls, dev_t devt);
+#else /* !CONFIG_PM_SLEEP */
+static inline void destroy_suspended_device(struct class *cls, dev_t devt)
+{
+	device_destroy(cls, devt);
+}
+#endif /* !CONFIG_PM_SLEEP */
 
 /*
  * Platform "fixup" functions - allow the platform to have their say
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -20,6 +20,9 @@ static inline struct device *to_device(s
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
+extern void device_pm_destroy_suspended(struct device *);
+extern int pm_sleep_lock(void);
+extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
@@ -32,6 +35,15 @@ static inline void device_pm_remove(stru
 {
 }
 
+static inline int pm_sleep_lock(void)
+{
+	return 0;
+}
+
+static inline void pm_sleep_unlock(void)
+{
+}
+
 #endif
 
 #ifdef CONFIG_PM
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -24,17 +24,38 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/resume-trace.h>
+#include <linux/rwsem.h>
 
 #include "../base.h"
 #include "power.h"
 
+/*
+ * The entries in the dpm_active list are in a depth first order, simply
+ * because children are guaranteed to be discovered after parents, and
+ * are inserted at the back of the list on discovery.
+ *
+ * All the other lists are kept in the same order, for consistency.
+ * However the lists aren't always traversed in the same order.
+ * Semaphores must be acquired from the top (i.e., front) down
+ * and released in the opposite order.  Devices must be suspended
+ * from the bottom (i.e., end) up and resumed in the opposite order.
+ * That way no parent will be suspended while it still has an active
+ * child.
+ *
+ * Since device_pm_add() may be called with a device semaphore held,
+ * we must never try to acquire a device semaphore while holding
+ * dpm_list_mutex.
+ */
+
 LIST_HEAD(dpm_active);
+static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
 
-static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
 
+static DECLARE_RWSEM(pm_sleep_rwsem);
+
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
@@ -53,29 +74,124 @@ void device_pm_remove(struct device *dev
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+
+	/* Don't remove a device while the PM core has it locked for suspend */
+	down(&dev->sem);
 	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+	up(&dev->sem);
+}
+
+void device_pm_destroy_suspended(struct device *dev)
+{
+	pr_debug("PM: Removing suspended device %s:%s\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	mutex_lock(&dpm_list_mtx);
+	list_del_init(&dev->power.entry);
+	mutex_unlock(&dpm_list_mtx);
+	up(&dev->sem);
+	device_unregister(dev);
+}
+
+/**
+ *	pm_sleep_lock - mutual exclusion for registration and suspend
+ *
+ *	Returns 0 if no suspend is underway and device registration
+ *	may proceed, otherwise -EBUSY.
+ */
+int pm_sleep_lock(void)
+{
+	if (down_read_trylock(&pm_sleep_rwsem))
+		return 0;
+	return -EBUSY;
+}
+
+/**
+ *	pm_sleep_unlock - mutual exclusion for registration and suspend
+ *
+ *	This routine undoes the effect of device_pm_add_lock
+ *	when a device's registration is complete.
+ */
+void pm_sleep_unlock(void)
+{
+	up_read(&pm_sleep_rwsem);
 }
 
 
 /*------------------------- Resume routines -------------------------*/
 
 /**
- *	resume_device - Restore state for one device.
+ *	resume_device_early - Power on one device (early resume).
  *	@dev:	Device.
  *
+ *	Must be called with interrupts disabled.
  */
-
-static int resume_device(struct device * dev)
+static int resume_device_early(struct device *dev)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	down(&dev->sem);
+	if (dev->bus && dev->bus->resume_early) {
+		dev_dbg(dev,"EARLY resume\n");
+		error = dev->bus->resume_early(dev);
+	}
+
+	TRACE_RESUME(error);
+	return error;
+}
+
+/**
+ *	dpm_power_up - Power on all regular (non-sysdev) devices.
+ *
+ *	Walk the dpm_off_irq list and power each device up. This
+ *	is used for devices that required they be powered down with
+ *	interrupts disabled. As devices are powered on, they are moved
+ *	to the dpm_off list.
+ *
+ *	Interrupts must be disabled when calling this.
+ */
+static void dpm_power_up(void)
+{
+	while (!list_empty(&dpm_off_irq)) {
+		struct list_head *entry = dpm_off_irq.next;
+		struct device *dev = to_device(entry);
+
+		list_move_tail(entry, &dpm_off);
+		resume_device_early(dev);
+	}
+}
+
+/**
+ *	device_power_up - Turn on all devices that need special attention.
+ *
+ *	Power on system devices, then devices that required we shut them down
+ *	with interrupts disabled.
+ *
+ *	Must be called with interrupts disabled.
+ */
+void device_power_up(void)
+{
+	sysdev_resume();
+	dpm_power_up();
+}
+EXPORT_SYMBOL_GPL(device_power_up);
+
+/**
+ *	resume_device - Restore state for one device.
+ *	@dev:	Device.
+ *
+ */
+static int resume_device(struct device *dev)
+{
+	int error = 0;
+
+	TRACE_DEVICE(dev);
+	TRACE_RESUME(0);
 
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
@@ -92,126 +208,68 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
-	up(&dev->sem);
-
 	TRACE_RESUME(error);
 	return error;
 }
 
-
-static int resume_device_early(struct device * dev)
+/**
+ *	dpm_resume - Resume every device.
+ *
+ *	Resume the devices that have either not gone through
+ *	the late suspend, or that did go through it but also
+ *	went through the early resume.
+ *
+ *	Take devices from the dpm_off_list, resume them,
+ *	and put them on the dpm_locked list.
+ */
+static void dpm_resume(void)
 {
-	int error = 0;
+	while(!list_empty(&dpm_off)) {
+		struct list_head *entry = dpm_off.next;
+		struct device *dev = to_device(entry);
 
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
-		error = dev->bus->resume_early(dev);
+		resume_device(dev);
+		list_move_tail(entry, &dpm_locked);
 	}
-	TRACE_RESUME(error);
-	return error;
 }
 
-/*
- * Resume the devices that have either not gone through
- * the late suspend, or that did go through it but also
- * went through the early resume
+/**
+ *	unlock_all_devices - Release each device's semaphore
+ *
+ *	Go through the dpm_off list.  Put each device on the dpm_active
+ *	list and unlock it.
  */
-static void dpm_resume(void)
+static void unlock_all_devices(void)
 {
 	mutex_lock(&dpm_list_mtx);
-	while(!list_empty(&dpm_off)) {
-		struct list_head * entry = dpm_off.next;
-		struct device * dev = to_device(entry);
-
-		get_device(dev);
-		list_move_tail(entry, &dpm_active);
-
-		mutex_unlock(&dpm_list_mtx);
-		resume_device(dev);
-		mutex_lock(&dpm_list_mtx);
-		put_device(dev);
-	}
+ 	while (!list_empty(&dpm_locked)) {
+ 		struct list_head *entry = dpm_locked.prev;
+ 		struct device *dev = to_device(entry);
+
+ 		list_move(entry, &dpm_active);
+ 		up(&dev->sem);
+ 	}
 	mutex_unlock(&dpm_list_mtx);
 }
 
-
 /**
  *	device_resume - Restore state of each device in system.
  *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.
+ *	Resume all the devices, unlock them all, and allow new
+ *	devices to be registered once again.
  */
-
 void device_resume(void)
 {
 	might_sleep();
-	mutex_lock(&dpm_mtx);
 	dpm_resume();
-	mutex_unlock(&dpm_mtx);
+	unlock_all_devices();
+	up_write(&pm_sleep_rwsem);
 }
-
 EXPORT_SYMBOL_GPL(device_resume);
 
 
-/**
- *	dpm_power_up - Power on some devices.
- *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_active list.
- *
- *	Interrupts must be disabled when calling this.
- */
-
-static void dpm_power_up(void)
-{
-	while(!list_empty(&dpm_off_irq)) {
-		struct list_head * entry = dpm_off_irq.next;
-		struct device * dev = to_device(entry);
-
-		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
-	}
-}
-
-
-/**
- *	device_power_up - Turn on all devices that need special attention.
- *
- *	Power on system devices then devices that required we shut them down
- *	with interrupts disabled.
- *	Called with interrupts disabled.
- */
-
-void device_power_up(void)
-{
-	sysdev_resume();
-	dpm_power_up();
-}
-
-EXPORT_SYMBOL_GPL(device_power_up);
-
-
 /*------------------------- Suspend routines -------------------------*/
 
-/*
- * The entries in the dpm_active list are in a depth first order, simply
- * because children are guaranteed to be discovered after parents, and
- * are inserted at the back of the list on discovery.
- *
- * All list on the suspend path are done in reverse order, so we operate
- * on the leaves of the device tree (or forests, depending on how you want
- * to look at it ;) first. As nodes are removed from the back of the list,
- * they are inserted into the front of their destintation lists.
- *
- * Things are the reverse on the resume path - iterations are done in
- * forward order, and nodes are inserted at the back of their destination
- * lists. This way, the ancestors will be accessed before their descendents.
- */
-
 static inline char *suspend_verb(u32 event)
 {
 	switch (event) {
@@ -222,7 +280,6 @@ static inline char *suspend_verb(u32 eve
 	}
 }
 
-
 static void
 suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
 {
@@ -232,16 +289,70 @@ suspend_device_dbg(struct device *dev, p
 }
 
 /**
- *	suspend_device - Save state of one device.
+ *	suspend_device_late - Shut down one device (late suspend).
  *	@dev:	Device.
  *	@state:	Power state device is entering.
+ *
+ *	This is called with interrupts off and only a single CPU running.
  */
+static int suspend_device_late(struct device *dev, pm_message_t state)
+{
+	int error = 0;
 
-static int suspend_device(struct device * dev, pm_message_t state)
+	if (dev->bus && dev->bus->suspend_late) {
+		suspend_device_dbg(dev, state, "LATE ");
+		error = dev->bus->suspend_late(dev, state);
+		suspend_report_result(dev->bus->suspend_late, error);
+	}
+	return error;
+}
+
+/**
+ *	device_power_down - Shut down special devices.
+ *	@state:		Power state to enter.
+ *
+ *	Power down devices that require interrupts to be disabled
+ *	and move them from the dpm_off list to the dpm_off_irq list.
+ *	Then power down system devices.
+ *
+ *	Must be called with interrupts disabled and only one CPU running.
+ */
+int device_power_down(pm_message_t state)
+{
+	int error = 0;
+
+	while (!list_empty(&dpm_off)) {
+		struct list_head *entry = dpm_off.prev;
+		struct device *dev = to_device(entry);
+
+		error = suspend_device_late(dev, state);
+		if (error) {
+			printk(KERN_ERR "Could not power down device %s: "
+					"error %d\n",
+					kobject_name(&dev->kobj), error);
+			break;
+		}
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off_irq);
+	}
+
+	if (!error)
+		error = sysdev_suspend(state);
+	if (error)
+		dpm_power_up();
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_power_down);
+
+/**
+ *	suspend_device - Save state of one device.
+ *	@dev:	Device.
+ *	@state:	Power state device is entering.
+ */
+int suspend_device(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	down(&dev->sem);
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -264,123 +375,96 @@ static int suspend_device(struct device 
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
-	up(&dev->sem);
 	return error;
 }
 
-
-/*
- * This is called with interrupts off, only a single CPU
- * running. We can't acquire a mutex or semaphore (and we don't
- * need the protection)
+/**
+ *	dpm_suspend - Suspend every device.
+ *	@state:	Power state to put each device in.
+ *
+ *	Walk the dpm_locked list.  Suspend each device and move it
+ *	to the dpm_off list.
+ *
+ *	(For historical reasons, if it returns -EAGAIN, that used to mean
+ *	that the device would be called again with interrupts disabled.
+ *	These days, we use the "suspend_late()" callback for that, so we
+ *	print a warning and consider it an error).
  */
-static int suspend_device_late(struct device *dev, pm_message_t state)
+static int dpm_suspend(pm_message_t state)
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
-		error = dev->bus->suspend_late(dev, state);
-		suspend_report_result(dev->bus->suspend_late, error);
+	while (!list_empty(&dpm_locked)) {
+		struct list_head *entry = dpm_locked.prev;
+		struct device *dev = to_device(entry);
+
+		error = suspend_device(dev, state);
+		if (error) {
+			printk(KERN_ERR "Could not suspend device %s: "
+					"error %d%s\n",
+					kobject_name(&dev->kobj),
+					error,
+					(error == -EAGAIN ?
+					" (please convert to suspend_late)" :
+					""));
+			break;
+		}
+		if (!list_empty(&dev->power.entry))
+ 			list_move(&dev->power.entry, &dpm_off);
 	}
+
 	return error;
 }
 
 /**
- *	device_suspend - Save state and stop all devices in system.
- *	@state:		Power state to put each device in.
- *
- *	Walk the dpm_active list, call ->suspend() for each device, and move
- *	it to the dpm_off list.
- *
- *	(For historical reasons, if it returns -EAGAIN, that used to mean
- *	that the device would be called again with interrupts disabled.
- *	These days, we use the "suspend_late()" callback for that, so we
- *	print a warning and consider it an error).
- *
- *	If we get a different error, try and back out.
- *
- *	If we hit a failure with any of the devices, call device_resume()
- *	above to bring the suspended devices back to life.
+ *	lock_all_devices - Acquire every device's semaphore
  *
+ *	Go through the dpm_active list. Carefully lock each device's
+ *	semaphore and put it in on the dpm_locked list.
  */
-
-int device_suspend(pm_message_t state)
+static void lock_all_devices(void)
 {
-	int error = 0;
-
-	might_sleep();
-	mutex_lock(&dpm_mtx);
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active) && error == 0) {
-		struct list_head * entry = dpm_active.prev;
-		struct device * dev = to_device(entry);
-
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry = dpm_active.next;
+		struct device *dev = to_device(entry);
+
+		/* Required locking order is dev->sem first,
+		 * then dpm_list_mutex.  Hence this awkward code.
+		 */
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
-
-		error = suspend_device(dev, state);
-
+		down(&dev->sem);
 		mutex_lock(&dpm_list_mtx);
 
-		/* Check if the device got removed */
-		if (!list_empty(&dev->power.entry)) {
-			/* Move it to the dpm_off list */
-			if (!error)
-				list_move(&dev->power.entry, &dpm_off);
-		}
-		if (error)
-			printk(KERN_ERR "Could not suspend device %s: "
-				"error %d%s\n",
-				kobject_name(&dev->kobj), error,
-				error == -EAGAIN ? " (please convert to suspend_late)" : "");
+		if (list_empty(entry))
+			up(&dev->sem);		/* Device was removed */
+		else
+			list_move_tail(entry, &dpm_locked);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
-		dpm_resume();
-
-	mutex_unlock(&dpm_mtx);
-	return error;
 }
 
-EXPORT_SYMBOL_GPL(device_suspend);
-
 /**
- *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
+ *	device_suspend - Save state and stop all devices in system.
  *
- *	Walk the dpm_off_irq list, calling ->power_down() for each device that
- *	couldn't power down the device with interrupts enabled. When we're
- *	done, power down system devices.
+ *	Prevent new devices from being registered, then lock all devices
+ *	and suspend them.
  */
-
-int device_power_down(pm_message_t state)
+int device_suspend(pm_message_t state)
 {
-	int error = 0;
-	struct device * dev;
-
-	while (!list_empty(&dpm_off)) {
-		struct list_head * entry = dpm_off.prev;
-
-		dev = to_device(entry);
-		error = suspend_device_late(dev, state);
-		if (error)
-			goto Error;
-		list_move(&dev->power.entry, &dpm_off_irq);
-	}
+	int error;
 
-	error = sysdev_suspend(state);
- Done:
+	might_sleep();
+	down_write(&pm_sleep_rwsem);
+	lock_all_devices();
+	error = dpm_suspend(state);
+	if (error)
+		device_resume();
 	return error;
- Error:
-	printk(KERN_ERR "Could not power down device %s: "
-		"error %d\n", kobject_name(&dev->kobj), error);
-	dpm_power_up();
-	goto Done;
 }
-
-EXPORT_SYMBOL_GPL(device_power_down);
+EXPORT_SYMBOL_GPL(device_suspend);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
Index: linux-2.6/arch/x86/kernel/msr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/msr.c
+++ linux-2.6/arch/x86/kernel/msr.c
@@ -155,15 +155,15 @@ static int __cpuinit msr_class_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		msr_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
Index: linux-2.6/arch/x86/kernel/cpuid.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpuid.c
+++ linux-2.6/arch/x86/kernel/cpuid.c
@@ -157,15 +157,15 @@ static int __cpuinit cpuid_class_cpu_cal
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = cpuid_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		cpuid_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
