Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZIIXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZIIXl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZIIXlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:41:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZIIXlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:41:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/9] PM: Asynchronous resume of devices
Date: Thu, 10 Sep 2009 01:35:12 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl>
In-Reply-To: <200909100127.11252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100135.12689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Theoretically, the total time of system sleep transitions (suspend
to RAM, hibernation) can be reduced by running suspend and resume
callbacks of device drivers in parallel with each other.  However,
there are dependencies between devices such that, for example, we may
not be allowed to put one device into a low power state before
anohter one has been suspended (e.g. we cannot suspend a bridge
before suspending all devices behind it).  In particular, we're not
allowed to suspend the parent of a device before suspending the
device itself.  Analogously, we're not allowed to resume a device
before resuming its parent.

Thus, to make it possible to execute suspend and resume callbacks
provided by device drivers in parallel with each other, we need to
provide a synchronization mechanism preventing the dependencies
between devices from being violated.

The patch below allows some devices to be resumed asynchronously,
with the following rules:
(1) There is a wait queue head, dev->power.wait_queue, and an
    "operation complete" flag, dev->power.op_complete for each device
    object.
(2) All of the power.op_complete flags are reset before suspend as
    well as after each resume stage (dpm_resume_noirq(),
    dpm_resume()).
(3) If power.async_suspend is set for dev or for one of devices it
    depends on, the PM core waits for the "master" device's
    power.op_complete flag to be set before attempting to run the
    resume callbacks, appropriate for this particular stage of
    resume, for dev.
(4) dev->power.op_complete is set for each device after running its
    resume callbacks at each stage of resume (dpm_resume_noirq(),
    dpm_resume()) and all threads waiting in the devices wait
    queue are woken up.

With this mechanism in place, the drivers wanting their resume
callbacks to be executed asynchronously can set
dev->power.async_suspend for them, with the help of
device_enable_async_suspend().  In addition to that, the PM off-tree
dependencies between devices have to be represented by
'struct pm_link' objects introduced by the previous patch.

In this version of the patch the async threads started to execute
the resume callbacks of specific device don't exit immediately having
done that, but search dpm_list for devices whose PM dependencies have
already been satisfied and execute their callbacks without waiting.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/common.c |    5 
 drivers/base/power/main.c   |  327 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/device.h      |    6 
 include/linux/pm.h          |    6 
 4 files changed, 329 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
+#include <linux/completion.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -409,20 +410,23 @@ enum rpm_request {
 
 struct dev_pm_info {
 	spinlock_t		lock;
+	wait_queue_head_t	wait_queue;
 	struct list_head	master_links;
 	struct list_head	slave_links;
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
+	unsigned int		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
+	unsigned int		op_started:1;
+	unsigned int		op_complete:1;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
 	unsigned long		timer_expires;
 	struct work_struct	work;
-	wait_queue_head_t	wait_queue;
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -472,6 +472,12 @@ static inline int device_is_registered(s
 	return dev->kobj.state_in_sysfs;
 }
 
+static inline void device_enable_async_suspend(struct device *dev, bool enable)
+{
+	if (dev->power.status == DPM_ON)
+		dev->power.async_suspend = enable;
+}
+
 void driver_init(void);
 
 /*
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -26,6 +26,8 @@
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/async.h>
+#include <linux/completion.h>
 
 #include "../base.h"
 #include "power.h"
@@ -43,6 +45,7 @@
 LIST_HEAD(dpm_list);
 
 static DEFINE_MUTEX(dpm_list_mtx);
+static pm_message_t pm_transition;
 
 /*
  * Set once the preparation of devices for a PM transition has started, reset
@@ -145,6 +148,131 @@ void device_pm_move_last(struct device *
 }
 
 /**
+ * dpm_reset - Clear power.op_started and power.op_complete for given device.
+ * @dev: Device to handle.
+ */
+static void dpm_reset(struct device *dev)
+{
+	dev->power.op_started = false;
+	dev->power.op_complete = false;
+}
+
+/**
+ * dpm_reset_all - Call dpm_reset() for all devices.
+ */
+static void dpm_reset_all(void)
+{
+	struct device *dev;
+
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		dpm_reset(dev);
+}
+
+/**
+ * dpm_synchronize_noirq - Wait for "late" or "early" PM callbacks to complete.
+ *
+ * Wait for the "late" or "early" suspend/resume callbacks of all devices to
+ * complete and clear power.op_started and power.op_complete for all devices.
+ */
+static void dpm_synchronize_noirq(void)
+{
+	async_synchronize_full();
+	dpm_reset_all();
+}
+
+/**
+ * dpm_synchronize_noirq - Wait for PM callbacks to complete.
+ *
+ * Wait for the "regular" suspend/resume callbacks of all devices to complete
+ * and clear power.op_started and power.op_complete for all devices.
+ */
+static void dpm_synchronize(void)
+{
+	async_synchronize_full();
+	mutex_lock(&dpm_list_mtx);
+	dpm_reset_all();
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ * device_pm_wait - Wait for a PM operation to complete.
+ * @sub: "Slave" device.
+ * @dev: Device to wait for.
+ *
+ * Wait for a PM operation carried out for @dev to complete, unless both @sub
+ * and @dev have to be handled synchronously (in such a case they are going to
+ * be handled in the right order anyway thanks to the pm_list ordering).
+ */
+static void device_pm_wait(struct device *sub, struct device *dev)
+{
+	if (!dev)
+		return;
+
+	if (!(sub->power.async_suspend || dev->power.async_suspend))
+		return;
+
+	if (!dev->power.op_complete) {
+		dev_dbg(sub, "PM: Waiting for %s %s\n", dev_driver_string(dev),
+			dev_name(dev));
+		wait_event(dev->power.wait_queue, !!dev->power.op_complete);
+	}
+}
+
+/**
+ * device_pm_wait_fn - Wrapper for device_pm_wait().
+ * @dev: Device to wait for.
+ * @data: Pointer to the "slave" device object.
+ */
+static int device_pm_wait_fn(struct device *dev, void *data)
+{
+	device_pm_wait((struct device *)data, dev);
+	return 0;
+}
+
+/**
+ * device_pm_wait_for_masters - Wait for all masters of given device.
+ * @slave: Device to wait for the masters of.
+ */
+static void device_pm_wait_for_masters(struct device *slave)
+{
+	if (!pm_trace_enabled)
+		device_for_each_master(slave, slave, device_pm_wait_fn);
+}
+
+/**
+ * device_pm_check - Check the power.op_complete flag of given device.
+ * @dev: Device to check.
+ */
+static bool device_pm_check(struct device *dev)
+{
+	int ret = 0;
+
+	if (dev)
+		ret = !dev->power.op_complete;
+
+	return ret;
+}
+
+/**
+ * device_pm_check_fn - Wrapper for device_pm_check().
+ * @dev: Device to check.
+ * @data: Ignored.
+ */
+static int device_pm_check_fn(struct device *dev, void *data)
+{
+	return device_pm_check(dev);
+}
+
+/**
+ * device_pm_check_masters - Check power.op_complete for masters of a device.
+ * @slave: Device to check the masters of.
+ */
+static int device_pm_check_masters(struct device *slave)
+{
+	return device_for_each_master(slave, NULL, device_pm_check_fn);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -269,6 +397,24 @@ static int pm_noirq_op(struct device *de
 	return error;
 }
 
+/**
+ * pm_op_started - Mark the beginning of a PM operation for given device.
+ * @dev: Device to handle.
+ */
+static bool pm_op_started(struct device *dev)
+{
+	bool ret = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.op_started)
+		ret = true;
+	else
+		dev->power.op_started = true;
+	spin_unlock_irq(&dev->power.lock);
+
+	return ret;
+}
+
 static char *pm_verb(int event)
 {
 	switch (event) {
@@ -310,33 +456,102 @@ static void pm_dev_err(struct device *de
 /*------------------------- Resume routines -------------------------*/
 
 /**
- * device_resume_noirq - Execute an "early resume" callback for given device.
+ * __device_resume_noirq - Execute an "early resume" callback for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  *
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_resume_noirq(struct device *dev, pm_message_t state)
+static int __device_resume_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (!dev->bus)
-		goto End;
-
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
- End:
+
+	dev->power.op_complete = true;
+	wake_up_all(&dev->power.wait_queue);
+
 	TRACE_RESUME(error);
 	return error;
 }
 
 /**
+ * async_device_resume_noirq - Wrapper of __device_resume_noirq().
+ * @dev: Device to resume.
+ */
+static void async_device_resume_noirq(struct device *dev)
+{
+	int error;
+
+	pm_dev_dbg(dev, pm_transition, "async EARLY ");
+	error = __device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async EARLY", error);
+}
+
+/**
+ * async_resume_noirq - Execute "early" resume callbacks asynchronously.
+ * @data: Pointer to the first device to resume.
+ * @cookie: Ignored.
+ *
+ * The execution of this function is scheduled with async_schedule(), so it runs
+ * in its own kernel thread.  It first calls the "early" resume callback for the
+ * device passed to it as @data.  Next, it walks dpm_list looking for devices
+ * that can be resumed without waiting for their "masters".  If such a device is
+ * found, its "early" resume callback is run.
+ */
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+
+	device_pm_wait_for_masters(dev);
+	async_device_resume_noirq(dev);
+
+	list_for_each_entry_continue(dev, &dpm_list, power.entry) {
+		if (!dev->power.async_suspend || dev->power.status <= DPM_OFF)
+			continue;
+
+		if (device_pm_check_masters(dev))
+			continue;
+
+		if (pm_op_started(dev))
+			continue;
+
+		pm_dev_dbg(dev, pm_transition, "out of order EARLY ");
+		async_device_resume_noirq(dev);
+	}
+}
+
+/**
+ * device_resume_noirq - Execute or schedule "early" resume callback.
+ * @dev: Device to resume.
+ *
+ * If @dev can be resumed asynchronously, schedule the execution of
+ * async_resume_noirq() for it.  Otherwise, execute its "early" resume callback
+ * directly.
+ */
+static int device_resume_noirq(struct device *dev)
+{
+	if (pm_op_started(dev))
+		return 0;
+
+	if (dev->power.async_suspend && !pm_trace_enabled) {
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	device_pm_wait_for_masters(dev);
+	return __device_resume_noirq(dev, pm_transition);
+}
+
+/**
  * dpm_resume_noirq - Execute "early resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
  *
@@ -349,26 +564,28 @@ void dpm_resume_noirq(pm_message_t state
 
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
+	pm_transition = state;
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
 			dev->power.status = DPM_OFF;
-			error = device_resume_noirq(dev, state);
+			error = device_resume_noirq(dev);
 			if (error)
-				pm_dev_err(dev, state, " early", error);
+				pm_dev_err(dev, state, " EARLY", error);
 		}
+	dpm_synchronize_noirq();
 	mutex_unlock(&dpm_list_mtx);
 	resume_device_irqs();
 }
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
- * device_resume - Execute "resume" callbacks for given device.
+ * __device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_resume(struct device *dev, pm_message_t state)
+static int __device_resume(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -409,12 +626,92 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	dev->power.op_complete = true;
+	wake_up_all(&dev->power.wait_queue);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
 /**
+ * async_device_resume - Wrapper of __device_resume().
+ * @dev: Device to resume.
+ */
+static void async_device_resume(struct device *dev)
+{
+	int error;
+
+	pm_dev_dbg(dev, pm_transition, "async ");
+	error = __device_resume(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+}
+
+/**
+ * async_resume - Execute resume callbacks asynchronously.
+ * @data: Pointer to the first device to resume.
+ * @cookie: Ignored.
+ *
+ * The execution of this function is scheduled with async_schedule(), so it runs
+ * in its own kernel thread.  It first calls the resume callbacks for the device
+ * passed to it as @data.  Next, it walks dpm_list looking for devices that can
+ * be resumed without waiting for their "masters".  If such a device is found,
+ * its resume callbacks are run.
+ */
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+
+	device_pm_wait_for_masters(dev);
+
+ repeat:
+	async_device_resume(dev);
+	put_device(dev);
+
+	mutex_lock(&dpm_list_mtx);
+	if (dev->power.status < DPM_OFF)
+		dev = to_device(dpm_list.next);
+	list_for_each_entry_continue(dev, &dpm_list, power.entry) {
+		if (!dev->power.async_suspend || dev->power.status < DPM_OFF)
+			continue;
+
+		if (device_pm_check_masters(dev))
+			continue;
+
+		if (pm_op_started(dev))
+			continue;
+
+		get_device(dev);
+		mutex_unlock(&dpm_list_mtx);
+		pm_dev_dbg(dev, pm_transition, "out of order ");
+		goto repeat;
+	}
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ * device_resume - Execute or schedule resume callbacks for given device.
+ * @dev: Device to resume.
+ *
+ * If @dev can be resumed asynchronously, schedule the execution of
+ * async_resume() for it.  Otherwise, execute its resume callbacks directly.
+ */
+static int device_resume(struct device *dev)
+{
+	if (pm_op_started(dev))
+		return 0;
+
+	if (dev->power.async_suspend && !pm_trace_enabled) {
+		get_device(dev);
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	device_pm_wait_for_masters(dev);
+	return __device_resume(dev, pm_transition);
+}
+
+/**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
  *
@@ -427,6 +724,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -437,7 +735,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -452,6 +750,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	dpm_synchronize();
 }
 
 /**
@@ -775,8 +1074,10 @@ static int dpm_prepare(pm_message_t stat
 			break;
 		}
 		dev->power.status = DPM_SUSPENDING;
-		if (!list_empty(&dev->power.entry))
+		if (!list_empty(&dev->power.entry)) {
 			list_move_tail(&dev->power.entry, &list);
+			dpm_reset(dev);
+		}
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
Index: linux-2.6/drivers/base/power/common.c
===================================================================
--- linux-2.6.orig/drivers/base/power/common.c
+++ linux-2.6/drivers/base/power/common.c
@@ -19,10 +19,11 @@
  */
 void device_pm_init(struct device *dev)
 {
-	dev->power.status = DPM_ON;
 	spin_lock_init(&dev->power.lock);
+	init_waitqueue_head(&dev->power.wait_queue);
 	INIT_LIST_HEAD(&dev->power.master_links);
 	INIT_LIST_HEAD(&dev->power.slave_links);
+	dev->power.status = DPM_ON;
 	pm_runtime_init(dev);
 }
 
@@ -117,6 +118,8 @@ int pm_link_add(struct device *slave, st
 	return 0;
 
  err_link:
+	master->power.async_suspend = false;
+	slave->power.async_suspend = false;
 	error = -ENOMEM;
 	put_device(slave);
 
