Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZLMWnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZLMWnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZLMWnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42410 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbZLMWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/5] PM: Asynchronous suspend and resume of devices
Date: Sun, 13 Dec 2009 23:39:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132339.33019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Theoretically, the total time of system sleep transitions (suspend
to RAM, hibernation) can be reduced by running suspend and resume
callbacks of device drivers in parallel with each other.  However,
there are dependencies between devices such that we're not allowed
to suspend the parent of a device before suspending the device
itself.  Analogously, we're not allowed to resume a device before
resuming its parent.

Thus, to make it possible to execute device drivers' suspend and
resume callbacks in parallel with each other, introduce (at the PM
core level) a synchronization mechanism preventing the dependencies
between devices from being violated.

First, device drivers that want their suspend and resume callbacks
to be run asynchronously need to set the power.async_suspend flags
of their devices using device_enable_async_suspend().

Second, for each device with the power.async_suspend flag set the PM
core will start async threads to execute its suspend and resume
callbacks.

The async threads started for different devices are synchronized with
each other and with the main suspend (or resume) thread with the help
of completions, in the following way:
(1) There is a completion, power.completion, for each device object.
(2) Each device's completion is reset before starting the async
    suspend (or resume) thread for the device or, in the case of
    devices whose power.async_suspend flags are not set, before
    executing the device's suspend and resume callbacks.
(3) During suspend, right before running the bus type, device type
    and device class suspend callbacks for the device, the PM core
    waits for the completions of all the device's children to be
    completed.
(4) During resume, right before running the bus type, device type and
    device class resume callbacks for the device, the PM core waits
    for the completion of the device's parent to be completed.
(5) The PM core completes power.completion for each device right
    after the bus type, device type and device class suspend (or
    resume) callbacks executed for the device have returned.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c    |  115 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h       |    6 ++
 include/linux/pm.h           |    3 +
 include/linux/resume-trace.h |    7 ++
 4 files changed, 125 insertions(+), 6 deletions(-)

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
@@ -412,9 +413,11 @@ struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
+	unsigned		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
+	struct completion	completion;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -25,6 +25,7 @@
 #include <linux/resume-trace.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/async.h>
 
 #include "../base.h"
 #include "power.h"
@@ -42,6 +43,7 @@
 LIST_HEAD(dpm_list);
 
 static DEFINE_MUTEX(dpm_list_mtx);
+static pm_message_t pm_transition;
 
 /*
  * Set once the preparation of devices for a PM transition has started, reset
@@ -56,6 +58,7 @@ static bool transition_started;
 void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
+	init_completion(&dev->power.completion);
 	pm_runtime_init(dev);
 }
 
@@ -111,6 +114,7 @@ void device_pm_remove(struct device *dev
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	complete_all(&dev->power.completion);
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
@@ -162,6 +166,31 @@ void device_pm_move_last(struct device *
 }
 
 /**
+ * dpm_wait - Wait for a PM operation to complete.
+ * @dev: Device to wait for.
+ * @async: If unset, wait only if the device's power.async_suspend flag is set.
+ */
+static void dpm_wait(struct device *dev, bool async)
+{
+	if (!dev)
+		return;
+
+	if (async || dev->power.async_suspend)
+		wait_for_completion(&dev->power.completion);
+}
+
+static int dpm_wait_fn(struct device *dev, void *async_ptr)
+{
+	dpm_wait(dev, *((bool *)async_ptr));
+	return 0;
+}
+
+static void dpm_wait_for_children(struct device *dev, bool async)
+{
+       device_for_each_child(dev, &async, dpm_wait_fn);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -408,17 +437,19 @@ void dpm_resume_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
- * device_resume - Execute "resume" callbacks for given device.
+ * __device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
+ * @async: If true, the device is being resumed asynchronously.
  */
-static int device_resume(struct device *dev, pm_message_t state)
+static int __device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	dpm_wait(dev->parent, async);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -453,11 +484,36 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.completion);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume(dev, pm_transition, true);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev)
+{
+	INIT_COMPLETION(dev->power.completion);
+
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	return __device_resume(dev, pm_transition, false);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -471,6 +527,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -481,7 +538,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -496,6 +553,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
@@ -647,17 +705,24 @@ int dpm_suspend_noirq(pm_message_t state
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
+static int async_error;
+
 /**
  * device_suspend - Execute "suspend" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
+ * @async: If true, the device is being suspended asynchronously.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
 
+	dpm_wait_for_children(dev, async);
 	down(&dev->sem);
 
+	if (async_error)
+		goto End;
+
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
@@ -690,12 +755,44 @@ static int device_suspend(struct device 
 			suspend_report_result(dev->bus->suspend, error);
 		}
 	}
+
+	if (!error)
+		dev->power.status = DPM_OFF;
+
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.completion);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend(dev, pm_transition, true);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+		async_error = error;
+	}
+
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev)
+{
+	INIT_COMPLETION(dev->power.completion);
+
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	return __device_suspend(dev, pm_transition, false);
+}
+
 /**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -707,13 +804,15 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+	async_error = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend(dev, state);
+		error = device_suspend(dev);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -721,13 +820,17 @@ static int dpm_suspend(pm_message_t stat
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_OFF;
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &list);
 		put_device(dev);
+		if (async_error)
+			break;
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
+	if (!error)
+		error = async_error;
 	return error;
 }
 
Index: linux-2.6/include/linux/resume-trace.h
===================================================================
--- linux-2.6.orig/include/linux/resume-trace.h
+++ linux-2.6/include/linux/resume-trace.h
@@ -6,6 +6,11 @@
 
 extern int pm_trace_enabled;
 
+static inline int pm_trace_is_enabled(void)
+{
+       return pm_trace_enabled;
+}
+
 struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(const void *tracedata, unsigned int user);
@@ -17,6 +22,8 @@ extern void generate_resume_trace(const 
 
 #else
 
+static inline int pm_trace_is_enabled(void) { return 0; }
+
 #define TRACE_DEVICE(dev) do { } while (0)
 #define TRACE_RESUME(dev) do { } while (0)
 
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

