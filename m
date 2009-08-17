Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZHQAXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZHQAXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZHQAXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:23:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZHQAW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/7] PM: Asynchronous resume of I/O devices
Date: Mon, 17 Aug 2009 02:18:45 +0200
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
Message-Id: <200908170218.45513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The patch below introduces a mechanism allowing some devices to be
resumed asynchronously, using completions with the following rules:
(1) There is a completion, dev->power.comp, for each device object.
(2) All of these completions are reset before suspend as well as
    each resume stage (dpm_resume_noirq(), dpm_resume()).
(3) If dev->power.async_suspend is set for dev or for one of devices
    it depends on, the PM core waits for the "master" device's
    completion before attempting to run the resume callbacks,
    appropriate for this particular stage of resume, for dev.
(4) dev->power.comp is completed for each device after running its
    resume callbacks.

With this mechanism in place, the drivers wanting their resume
callbacks to be executed asynchronously can set
dev->power.async_suspend for them, with the help of
device_enable_async_suspend().  In addition to that, the PM
dependencies between devices have to be represented by
'struct pm_link' objects introduced by the previous patch.

---
 drivers/base/power/common.c |    5 +
 drivers/base/power/main.c   |  124 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/device.h      |    6 ++
 include/linux/pm.h          |    4 +
 4 files changed, 129 insertions(+), 10 deletions(-)

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
@@ -414,9 +415,12 @@ struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
+	unsigned int		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
+	struct completion	comp;
+	pm_message_t		async_state;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
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
@@ -50,6 +52,11 @@ static DEFINE_MUTEX(dpm_list_mtx);
  */
 static bool transition_started;
 
+void device_pm_sleep_init(struct device *dev)
+{
+	init_completion(&dev->power.comp);
+}
+
 /**
  * device_pm_lock - Lock the list of active devices used by the PM core.
  */
@@ -144,6 +151,50 @@ void device_pm_move_last(struct device *
 	list_move_tail(&dev->power.entry, &dpm_list);
 }
 
+static void dpm_synchronize_noirq(void)
+{
+	struct device *dev;
+
+	async_synchronize_full();
+
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		INIT_COMPLETION(dev->power.comp);
+}
+
+static void dpm_synchronize(void)
+{
+	struct device *dev;
+
+	async_synchronize_full();
+
+	mutex_lock(&dpm_list_mtx);
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		INIT_COMPLETION(dev->power.comp);
+	mutex_unlock(&dpm_list_mtx);
+}
+
+static void device_pm_wait(struct device *sub, struct device *dev)
+{
+	if (sub->power.async_suspend || (dev && dev->power.async_suspend)) {
+		dev_dbg(sub, "PM: Waiting for %s %s\n", dev_driver_string(dev),
+			dev_name(dev));
+		wait_for_completion(&dev->power.comp);
+	}
+}
+
+static int device_pm_wait_fn(struct device *dev, void *data)
+{
+	struct device *sub = (struct device *)data;
+
+	device_pm_wait(sub, dev);
+	return 0;
+}
+
+static void device_pm_wait_for_masters(struct device *slave)
+{
+	device_for_each_master(slave, slave, device_pm_wait_fn);
+}
+
 /**
  * pm_op - Execute the PM operation appropiate for given PM event.
  * @dev: Device to handle.
@@ -310,32 +361,57 @@ static void pm_dev_err(struct device *de
 /*------------------------- Resume routines -------------------------*/
 
 /**
- * device_resume_noirq - Execute an "early resume" callback for given device.
+ * __device_resume_noirq - Execute an "early resume" callback for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  *
  * The driver of @dev will not receive interrupts while this fuction is being
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
+	device_pm_wait_for_masters(dev);
 
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
- End:
+
+	complete_all(&dev->power.comp);
+
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async EARLY ");
+	error = __device_resume_noirq(dev, dev->power.async_state);
+	if (error)
+		pm_dev_err(dev, dev->power.async_state, " async EARLY", error);
+	put_device(dev);
+}
+
+static int device_resume_noirq(struct device *dev, pm_message_t state)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	return __device_resume_noirq(dev, state);
+}
+
 /**
  * dpm_resume_noirq - Execute "early resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -357,23 +433,25 @@ void dpm_resume_noirq(pm_message_t state
 			if (error)
 				pm_dev_err(dev, state, " early", error);
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
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	device_pm_wait_for_masters(dev);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -408,11 +486,36 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.comp);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async ");
+	error = __device_resume(dev, dev->power.async_state);
+	if (error)
+		pm_dev_err(dev, dev->power.async_state, " async", error);
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev, pm_message_t state)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	return __device_resume(dev, state);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -452,6 +555,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	dpm_synchronize();
 }
 
 /**
@@ -775,8 +879,10 @@ static int dpm_prepare(pm_message_t stat
 			break;
 		}
 		dev->power.status = DPM_SUSPENDING;
-		if (!list_empty(&dev->power.entry))
+		if (!list_empty(&dev->power.entry)) {
 			list_move_tail(&dev->power.entry, &list);
+			INIT_COMPLETION(dev->power.comp);
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
 	INIT_LIST_HEAD(&dev->power.master_links);
 	INIT_LIST_HEAD(&dev->power.slave_links);
+	dev->power.status = DPM_ON;
+	device_pm_sleep_init(dev);
 	pm_runtime_init(dev);
 }
 
@@ -82,6 +83,8 @@ int pm_link_add(struct device *slave, st
 	return 0;
 
  err_link:
+	master->power.async_suspend = false;
+	slave->power.async_suspend = false;
 	error = -ENOMEM;
 	put_device(slave);
 
