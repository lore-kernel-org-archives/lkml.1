Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZHLUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZHLUVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZHLUVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:21:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZHLUVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:21:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/3] PM: Asynchronous suspend of devices
Date: Wed, 12 Aug 2009 22:21:20 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl>
In-Reply-To: <200908122218.13975.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122221.20568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below extends the mechanism introduced by the previous
patch to the suspend part of the PM core.

Asynchronous suspend is slightly more complicated, because in this
case child devices need to be waited for by their parents, so each
parent has to wait on power.comp for each of its children.  Apart
from this, if any of the suspend callbacks executed asynchronously
returns error code, the entire suspend has to be terminated and
rolled back.
---
 drivers/base/power/main.c |  133 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 119 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -194,6 +194,19 @@ static void device_pm_wait(struct device
 		wait_for_completion(&master->power.comp);
 }
 
+static int device_pm_wait_wrapper(struct device *dev, void *data)
+{
+	struct device *parent = (struct device *)data;
+
+	device_pm_wait(parent, dev);
+	return 0;
+}
+
+static void device_pm_wait_for_children(struct device *parent)
+{
+	device_for_each_child(parent, parent, device_pm_wait_wrapper);
+}
+
 /**
  *	pm_op - execute the PM operation appropiate for given PM event
  *	@dev:	Device.
@@ -639,6 +652,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_end);
 
 /*------------------------- Suspend routines -------------------------*/
 
+static int async_error;
+
 /**
  *	resume_event - return a PM message representing the resume event
  *	               corresponding to given sleep state.
@@ -659,26 +674,61 @@ static pm_message_t resume_event(pm_mess
 }
 
 /**
- *	device_suspend_noirq - Shut down one device (late suspend).
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * __device_suspend_noirq - Execute a "late" suspend callback for given device.
+ * @dev: Device to suspend.
+ * @state: PM transition of the system being carried out.
  *
- *	This is called with interrupts off and only a single CPU running.
+ * The driver of the device won't receive interrupts while this function is
+ * being executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
+	device_pm_wait_for_children(dev);
 
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
+	int error = async_error;
+
+	if (error)
+		return;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async LATE ");
+	error = __device_suspend_noirq(dev, dev->power.async_state);
+	if (error) {
+		pm_dev_err(dev, dev->power.async_state, " async LATE", error);
+		dev->power.status = DPM_OFF;
+	}
+	put_device(dev);
+
+	if (error && !async_error)
+		async_error = error;
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
  *	dpm_suspend_noirq - Power down all regular (non-sysdev) devices.
  *	@state: PM transition of the system being carried out.
@@ -696,13 +746,19 @@ int dpm_suspend_noirq(pm_message_t state
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+		dev->power.status = DPM_OFF_IRQ;
 		error = device_suspend_noirq(dev, state);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
+			dev->power.status = DPM_OFF;
+			break;
+		}
+		if (async_error) {
+			error = async_error;
 			break;
 		}
-		dev->power.status = DPM_OFF_IRQ;
 	}
+	dpm_synchronize_noirq();
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
@@ -711,14 +767,15 @@ int dpm_suspend_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
 /**
- *	device_suspend - Save state of one device.
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * __device_suspend - Execute suspend callbacks for given device.
+ * @dev: Device to suspend.
+ * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
+	device_pm_wait_for_children(dev);
 	down(&dev->sem);
 
 	if (dev->class) {
@@ -755,10 +812,51 @@ static int device_suspend(struct device 
 	}
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.comp);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async ");
+
+	mutex_lock(&dpm_list_mtx);
+	error = async_error;
+	mutex_unlock(&dpm_list_mtx);
+	if (error)
+		goto End;
+
+	error = __device_suspend(dev, dev->power.async_state);
+	if (error) {
+		pm_dev_err(dev, dev->power.async_state, " async", error);
+
+		mutex_lock(&dpm_list_mtx);
+		dev->power.status = DPM_SUSPENDING;
+		if (!async_error)
+			async_error = error;
+		mutex_unlock(&dpm_list_mtx);
+	}
+
+ End:
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
  *	dpm_suspend - Suspend every device.
  *	@state: PM transition of the system being carried out.
@@ -776,6 +874,7 @@ static int dpm_suspend(pm_message_t stat
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_suspend(dev, state);
@@ -783,16 +882,21 @@ static int dpm_suspend(pm_message_t stat
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
+		if (async_error) {
+			error = async_error;
+			break;
+		}
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+	dpm_synchronize();
 	return error;
 }
 
@@ -848,6 +952,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	async_error = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
