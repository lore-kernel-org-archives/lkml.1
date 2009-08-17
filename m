Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZHQAWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZHQAWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZHQAW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:22:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZHQAW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 4/7] PM: Asynchronous suspend of I/O devices
Date: Mon, 17 Aug 2009 02:19:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl>
In-Reply-To: <200908170215.21173.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170219.36268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below extends the mechanism introduced by the previous
patch to the suspend part of the PM core.

Asynchronous suspend is slightly more complicated, because if any of
the suspend callbacks executed asynchronously returns error code, the
entire suspend has to be terminated and rolled back.
---
 drivers/base/power/main.c |   99 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -195,6 +195,11 @@ static void device_pm_wait_for_masters(s
 	device_for_each_master(slave, slave, device_pm_wait_fn);
 }
 
+static void device_pm_wait_for_slaves(struct device *master)
+{
+	device_for_each_slave(master, master, device_pm_wait_fn);
+}
+
 /**
  * pm_op - Execute the PM operation appropiate for given PM event.
  * @dev: Device to handle.
@@ -637,6 +642,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_end);
 
 /*------------------------- Suspend routines -------------------------*/
 
+static atomic_t async_error;
+
 /**
  * resume_event - Return a "resume" message for given "suspend" sleep state.
  * @sleep_state: PM message representing a sleep state.
@@ -666,20 +673,52 @@ static pm_message_t resume_event(pm_mess
  * The driver of @dev will not receive interrupts while this fuction is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
+	device_pm_wait_for_slaves(dev);
 
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
+
+	complete_all(&dev->power.comp);
+
 	return error;
 }
 
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = atomic_read(&async_error);
+
+	if (error)
+		return;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async LATE ");
+	error = __device_suspend_noirq(dev, dev->power.async_state);
+	if (error) {
+		pm_dev_err(dev, dev->power.async_state, " async LATE", error);
+		dev->power.status = DPM_OFF;
+		atomic_set(&async_error, error);
+	}
+	put_device(dev);
+}
+
+static int device_suspend_noirq(struct device *dev, pm_message_t state)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+
+	return __device_suspend_noirq(dev, state);
+}
+
 /**
  * dpm_suspend_noirq - Execute "late suspend" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -695,13 +734,18 @@ int dpm_suspend_noirq(pm_message_t state
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+		dev->power.status = DPM_OFF_IRQ;
 		error = device_suspend_noirq(dev, state);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
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
@@ -714,10 +758,11 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
+	device_pm_wait_for_slaves(dev);
 	down(&dev->sem);
 
 	if (dev->class) {
@@ -754,10 +799,44 @@ static int device_suspend(struct device 
 	}
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.comp);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = atomic_read(&async_error);
+
+	if (error)
+		return;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async ");
+
+	error = __device_suspend(dev, dev->power.async_state);
+	if (error) {
+		pm_dev_err(dev, dev->power.async_state, " async", error);
+		mutex_lock(&dpm_list_mtx);
+		dev->power.status = DPM_SUSPENDING;
+		mutex_unlock(&dpm_list_mtx);
+		atomic_set(&async_error, error);
+	}
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev, pm_message_t state)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	return __device_suspend(dev, state);
+}
+
 /**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -773,6 +852,7 @@ static int dpm_suspend(pm_message_t stat
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_suspend(dev, state);
@@ -780,16 +860,20 @@ static int dpm_suspend(pm_message_t stat
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
 
@@ -848,6 +932,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	atomic_set(&async_error, 0);
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
