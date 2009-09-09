Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZIIXm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZIIXm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZIIXmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:42:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZIIXly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:41:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/9] PM: Asynchronous suspend of devices
Date: Thu, 10 Sep 2009 01:36:04 +0200
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
Message-Id: <200909100136.04609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Extend the approach used in the previous patch to the suspend part of
the PM core.

Asynchronous suspend is slightly more complicated, because if any of
the suspend callbacks executed asynchronously returns error code, the
entire suspend has to be terminated and rolled back.  Apart from
this, it's completely analogous to the asynchronous resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |  225 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 214 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -240,6 +240,15 @@ static void device_pm_wait_for_masters(s
 }
 
 /**
+ * device_pm_wait_for_slaves - Wait for all slaves of given device.
+ * @slave: Device to wait for the slaves of.
+ */
+static void device_pm_wait_for_slaves(struct device *master)
+{
+	device_for_each_slave(master, master, device_pm_wait_fn);
+}
+
+/**
  * device_pm_check - Check the power.op_complete flag of given device.
  * @dev: Device to check.
  */
@@ -273,6 +282,15 @@ static int device_pm_check_masters(struc
 }
 
 /**
+ * device_pm_check_slaves - Check power.op_complete for slaves of a device.
+ * @slave: Device to check the slaves of.
+ */
+static int device_pm_check_slaves(struct device *master)
+{
+	return device_for_each_slave(master, NULL, device_pm_check_fn);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -832,6 +850,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_end);
 
 /*------------------------- Suspend routines -------------------------*/
 
+static atomic_t async_error;
+
 /**
  * resume_event - Return a "resume" message for given "suspend" sleep state.
  * @sleep_state: PM message representing a sleep state.
@@ -861,21 +881,100 @@ static pm_message_t resume_event(pm_mess
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
-
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
+
+	dev->power.op_complete = true;
+	wake_up_all(&dev->power.wait_queue);
+
 	return error;
 }
 
 /**
+ * async_device_suspend_noirq - Wrapper of __device_suspend_noirq().
+ * @dev: Device to suspend.
+ *
+ * Execute __device_suspend_noirq() for given device unless async_error is
+ * set and if that returns error code, copy it to async_error and change the
+ * PM status of @dev to DPM_OFF.
+ */
+static void async_device_suspend_noirq(struct device *dev)
+{
+	int error = atomic_read(&async_error);
+
+	if (error)
+		return;
+	pm_dev_dbg(dev, pm_transition, "async LATE ");
+	error = __device_suspend_noirq(dev, pm_transition);
+	if (!error)
+		return;
+	pm_dev_err(dev, pm_transition, " async LATE", error);
+	dev->power.status = DPM_OFF;
+	atomic_set(&async_error, error);
+}
+
+/**
+ * async_suspend_noirq - Execute "late" suspend callbacks asynchronously.
+ * @data: Pointer to the first device to suspend.
+ * @cookie: Ignored.
+ *
+ * The execution of this function is scheduled with async_schedule(), so it runs
+ * in its own kernel thread.  It first calls the "late" suspend callback for the
+ * device passed to it as @data.  Next, it walks dpm_list looking for devices
+ * that can be suspended without waiting for their "slaves".  If such a device
+ * is found, its "late" suspend callback is run.
+ */
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+
+	device_pm_wait_for_slaves(dev);
+	async_device_suspend_noirq(dev);
+
+	list_for_each_entry_continue_reverse(dev, &dpm_list, power.entry) {
+		if (!dev->power.async_suspend)
+			continue;
+
+		if (device_pm_check_slaves(dev))
+			continue;
+
+		if (pm_op_started(dev))
+			continue;
+
+		pm_dev_dbg(dev, pm_transition, "out of order LATE ");
+		async_device_suspend_noirq(dev);
+	}
+}
+
+/**
+ * device_suspend_noirq - Execute or schedule "late" suspend callback.
+ * @dev: Device to suspend.
+ *
+ * If @dev can be resumed asynchronously, schedule the execution of
+ * async_suspend_noirq() for it.  Otherwise, execute its "late" suspend callback
+ * directly.
+ */
+static int device_suspend_noirq(struct device *dev)
+{
+	if (pm_op_started(dev))
+		return 0;
+
+	if (dev->power.async_suspend) {
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+
+	device_pm_wait_for_slaves(dev);
+	return __device_suspend_noirq(dev, pm_transition);
+}
+
+/**
  * dpm_suspend_noirq - Execute "late suspend" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
  *
@@ -889,14 +988,20 @@ int dpm_suspend_noirq(pm_message_t state
 
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
-		error = device_suspend_noirq(dev, state);
+		dev->power.status = DPM_OFF_IRQ;
+		error = device_suspend_noirq(dev);
 		if (error) {
-			pm_dev_err(dev, state, " late", error);
+			pm_dev_err(dev, state, " LATE", error);
+			dev->power.status = DPM_OFF;
 			break;
 		}
-		dev->power.status = DPM_OFF_IRQ;
+		error = atomic_read(&async_error);
+		if (error)
+			break;
 	}
+	dpm_synchronize_noirq();
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
@@ -909,7 +1014,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -949,11 +1054,102 @@ static int device_suspend(struct device 
 	}
  End:
 	up(&dev->sem);
+	dev->power.op_complete = true;
+	wake_up_all(&dev->power.wait_queue);
 
 	return error;
 }
 
 /**
+ * async_device_suspend - Wrapper of __device_suspend().
+ * @dev: Device to suspend.
+ *
+ * Execute __device_suspend() for given device unless async_error is set and if
+ * that returns error code, copy it to async_error and change the PM status of
+ * @dev to DPM_SUSPENDING.
+ */
+static void async_device_suspend(struct device *dev)
+{
+	int error = atomic_read(&async_error);
+
+	if (error)
+		return;
+	pm_dev_dbg(dev, pm_transition, "async ");
+	error = __device_suspend(dev, pm_transition);
+	if (!error)
+		return;
+	pm_dev_err(dev, pm_transition, " async", error);
+	mutex_lock(&dpm_list_mtx);
+	dev->power.status = DPM_SUSPENDING;
+	atomic_set(&async_error, error);
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ * async_suspend - Execute suspend callbacks asynchronously.
+ * @data: Pointer to the first device to resume.
+ * @cookie: Ignored.
+ *
+ * The execution of this function is scheduled with async_schedule(), so it runs
+ * in its own kernel thread.  It first calls the suspend callbacks for the
+ * device passed to it as @data.  Next, it walks dpm_list looking for devices
+ * that can be suspended without waiting for their "slaves".  If such a device
+ * is found, its suspend callbacks are run.
+ */
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+
+	device_pm_wait_for_slaves(dev);
+
+ repeat:
+	async_device_suspend(dev);
+	put_device(dev);
+
+	mutex_lock(&dpm_list_mtx);
+	if (dev->power.status >= DPM_OFF)
+		dev = to_device(dpm_list.prev);
+	list_for_each_entry_continue_reverse(dev, &dpm_list, power.entry) {
+		if (!dev->power.async_suspend)
+			continue;
+
+		if (device_pm_check_slaves(dev))
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
+ * device_suspend - Execute or schedule suspend callbacks for given device.
+ * @dev: Device to suspend.
+ *
+ * If @dev can be suspended asynchronously, schedule the execution of
+ * async_suspend() for it.  Otherwise, execute its suspend callbacks directly.
+ */
+static int device_suspend(struct device *dev)
+{
+	if (pm_op_started(dev))
+		return 0;
+
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	device_pm_wait_for_slaves(dev);
+	return __device_suspend(dev, pm_transition);
+}
+
+/**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
  */
@@ -964,27 +1160,33 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend(dev, state);
+		error = device_suspend(dev);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, "", error);
+			dev->power.status = DPM_SUSPENDING;
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_OFF;
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &list);
 		put_device(dev);
+		error = atomic_read(&async_error);
+		if (error)
+			break;
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+	dpm_synchronize();
 	return error;
 }
 
@@ -1043,6 +1245,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	atomic_set(&async_error, 0);
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
