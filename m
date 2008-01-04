Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYADWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYADWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYADWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:03:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYADWDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:03:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] PM: Introduce destroy_suspended_device()
Date: Fri, 4 Jan 2008 23:05:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0801021122070.5062-100000@iolanthe.rowland.org> <200801021750.16359.rjw@sisk.pl>
In-Reply-To: <200801021750.16359.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042305.35089.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Rafael J. Wysocki wrote:
> On Wednesday, 2 of January 2008, Alan Stern wrote:
> > On Wed, 2 Jan 2008, Rafael J. Wysocki wrote:
> > 
> > > On Wednesday, 2 of January 2008, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > It sometimes is necessary to destroy a device object during a suspend or
> > > > hibernation, but the PM core is supposed to control all device objects in that
> > > > cases.  For this reason, it is necessary to introduce a mechanism allowing one
> > > > to ask the PM core to remove a device object corresponding to a suspended
> > > > device on one's behalf.
> > > > 
> > > > Define function destroy_suspended_device() that will schedule the removal of
> > > > a device object corresponding to a suspended device by the PM core during the
> > > > subsequent resume.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Sorry, a small fix is needed for this patch.  Namely, dpm_sysfs_remove(dev)
> > > should not be called by device_pm_schedule_removal(), because it will be called
> > > anyway from device_pm_remove() when the device object is finally unregistered
> > > (we're talking here about unlikely error paths only, but still).
> > 
> > The situation is a little confusing, because the source files under 
> > drivers/base/power are maintained in Greg's tree and he already has 
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch 
> > installed.  That patch conflicts with this one.
> > 
> > One of the these two patches will have to be rewritten to apply on top 
> > of the other.  Which do you think should be changed?
> 
> Well, from the bisectability point of view, it would be better to adjust
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch and let the
> $subject patch series go first, if you don't mind.

I have rebased gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
on top of the $subject series, the result is appended.  It has only been
compilation tested for now, but I'll be testing it for the next couple of days.

Please review.

Thanks,
Rafael

---
From: Alan Stern <stern@rowland.harvard.edu>, Rafael J. Wysocki <rjw@sisk.pl>

This patch reorganizes the way suspend and resume notifications are
sent to drivers.  The major changes are that now the PM core acquires
every device semaphore before calling the methods, and calls to
device_add() during suspends will fail.
---
 drivers/base/core.c        |   13 -
 drivers/base/power/main.c  |  452 ++++++++++++++++++++++++++-------------------
 drivers/base/power/power.h |   11 +
 3 files changed, 290 insertions(+), 186 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -726,11 +726,17 @@ int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
-	int error = -EINVAL;
+	int error;
+
+	error = pm_sleep_lock();
+	if (error)
+		return error;
 
 	dev = get_device(dev);
-	if (!dev || !strlen(dev->bus_id))
-		goto Error;
+	if (!dev || !strlen(dev->bus_id)) {
+		error = -EINVAL;
+		goto Done;
+	}
 
 	pr_debug("DEV: registering device: ID = '%s'\n", dev->bus_id);
 
@@ -795,6 +801,7 @@ int device_add(struct device *dev)
 	}
  Done:
 	put_device(dev);
+	pm_sleep_unlock();
 	return error;
  BusError:
 	device_pm_remove(dev);
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -24,18 +24,39 @@
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
 static LIST_HEAD(dpm_destroy);
 
-static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
 
+static DECLARE_RWSEM(pm_sleep_rwsem);
+
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
@@ -54,12 +75,23 @@ void device_pm_remove(struct device *dev
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
 }
 
+/**
+ *	device_pm_schedule_removal - Schedule device for removal
+ *
+ *	Move the device to the list of devices to be removed during the
+ *	subsequent resume.  To be called when pm_sleep_rwsem is held for
+ *	writing and all devices' semaphores are locked.
+ */
 void device_pm_schedule_removal(struct device *dev)
 {
 	pr_debug("PM: Removing info for %s:%s\n",
@@ -70,23 +102,102 @@ void device_pm_schedule_removal(struct d
 	mutex_unlock(&dpm_list_mtx);
 }
 
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
+}
+
 
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
+		resume_device_early(dev);
+		list_move_tail(entry, &dpm_off);
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
@@ -103,132 +214,83 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
-	up(&dev->sem);
-
-	TRACE_RESUME(error);
-	return error;
-}
-
-
-static int resume_device_early(struct device * dev)
-{
-	int error = 0;
-
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
-		error = dev->bus->resume_early(dev);
-	}
 	TRACE_RESUME(error);
 	return error;
 }
 
 /**
- *	dpm_resume - Restore state of each device in system.
+ *	dpm_resume - Resume every device.
+ *
+ *	Resume the devices that have either not gone through
+ *	the late suspend, or that did go through it but also
+ *	went through the early resume.
  *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.  Unregister devices scheduled for
- *	removal.
+ *	Take devices from the dpm_off_list, resume them,
+ *	and put them on the dpm_locked list.
  */
-
 static void dpm_resume(void)
 {
-	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
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
-	mutex_unlock(&dpm_list_mtx);
-	/* Unregister devices scheduled for removal */
-	while (!list_empty(&dpm_destroy)) {
-		struct list_head *entry = dpm_destroy.next;
+		struct list_head *entry = dpm_off.next;
 		struct device *dev = to_device(entry);
 
-		device_unregister(dev);
+		resume_device(dev);
+		list_move_tail(entry, &dpm_locked);
 	}
 }
 
 /**
- *	device_resume - Invoke dpm_resume() under dpm_mtx.
+ *	unlock_all_devices - Release each device's semaphore
+ *
+ *	Go through the dpm_off list.  Put each device on the dpm_active
+ *	list and unlock it.
  */
-
-void device_resume(void)
+static void unlock_all_devices(void)
 {
-	might_sleep();
-	mutex_lock(&dpm_mtx);
-	dpm_resume();
-	mutex_unlock(&dpm_mtx);
+	mutex_lock(&dpm_list_mtx);
+ 	while (!list_empty(&dpm_locked)) {
+ 		struct list_head *entry = dpm_locked.prev;
+ 		struct device *dev = to_device(entry);
+
+ 		list_move(entry, &dpm_active);
+ 		up(&dev->sem);
+ 	}
+	mutex_unlock(&dpm_list_mtx);
 }
 
-EXPORT_SYMBOL_GPL(device_resume);
-
-
 /**
- *	dpm_power_up - Power on some devices.
- *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_active list.
- *
- *	Interrupts must be disabled when calling this.
+ *	unregister_dropped_devices - Unregister devices scheduled for removal
  */
-
-static void dpm_power_up(void)
+static void unregister_dropped_devices(void)
 {
-	while(!list_empty(&dpm_off_irq)) {
-		struct list_head * entry = dpm_off_irq.next;
-		struct device * dev = to_device(entry);
+	while (!list_empty(&dpm_destroy)) {
+		struct list_head *entry = dpm_destroy.next;
+		struct device *dev = to_device(entry);
 
-		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
+ 		up(&dev->sem);
+		device_unregister(dev);
 	}
 }
 
-
 /**
- *	device_power_up - Turn on all devices that need special attention.
+ *	device_resume - Restore state of each device in system.
  *
- *	Power on system devices then devices that required we shut them down
- *	with interrupts disabled.
- *	Called with interrupts disabled.
+ *	Resume all the devices, unlock them all, and allow new
+ *	devices to be registered once again.
  */
-
-void device_power_up(void)
+void device_resume(void)
 {
-	sysdev_resume();
-	dpm_power_up();
+	might_sleep();
+	dpm_resume();
+	unlock_all_devices();
+	unregister_dropped_devices();
+	up_write(&pm_sleep_rwsem);
 }
-
-EXPORT_SYMBOL_GPL(device_power_up);
+EXPORT_SYMBOL_GPL(device_resume);
 
 
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
@@ -239,7 +301,6 @@ static inline char *suspend_verb(u32 eve
 	}
 }
 
-
 static void
 suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
 {
@@ -249,16 +310,69 @@ suspend_device_dbg(struct device *dev, p
 }
 
 /**
- *	suspend_device - Save state of one device.
+ *	suspend_device_late - Shut down one device (late suspend).
  *	@dev:	Device.
  *	@state:	Power state device is entering.
+ *
+ *	This is called with interrupts off and only a single CPU running.
+ */
+static int suspend_device_late(struct device *dev, pm_message_t state)
+{
+	int error = 0;
+
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
  */
+int device_power_down(pm_message_t state)
+{
+	int error = 0;
+
+	while (!list_empty(&dpm_off)) {
+		struct list_head *entry = dpm_off.prev;
+		struct device *dev = to_device(entry);
 
-static int suspend_device(struct device * dev, pm_message_t state)
+		error = suspend_device_late(dev, state);
+		if (error) {
+			printk(KERN_ERR "Could not power down device %s: "
+					"error %d\n",
+					kobject_name(&dev->kobj), error);
+			break;
+		}
+		list_move(&dev->power.entry, &dpm_off_irq);
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
@@ -281,123 +395,95 @@ static int suspend_device(struct device 
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
+ 		list_move(&dev->power.entry, &dpm_off);
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
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry = dpm_active.next;
+		struct device *dev = to_device(entry);
 
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
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -21,6 +21,8 @@ static inline struct device *to_device(s
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern void device_pm_schedule_removal(struct device *);
+extern int pm_sleep_lock(void);
+extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
@@ -33,6 +35,15 @@ static inline void device_pm_remove(stru
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
