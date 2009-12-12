Return-Path: <linux-kernel-owner+w=401wt.eu-S935420AbZLMCGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420AbZLMCGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934709AbZLMCGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:06:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40493 "HELO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935368AbZLMCF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:05:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 12 Dec 2009 18:48:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912120048.46180.rjw@sisk.pl> <alpine.LFD.2.00.0912111552330.3526@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912111552330.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912121848.33062.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Linus Torvalds wrote:
> 
> On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > Below is a patch I've just tested, but there's a lockdep problem in it I don't
> > know how to solve.  Namely, lockdep is apparently unhappy with us not releasing
> > the lock taken in device_suspend() and it complains we take it twice in a row
> > (which we do, but for another device).  I need to use down_read_non_owner()
> > to make it shut up and then I also need to use up_read_non_owner() in
> > __device_suspend(),
> 
> Ok, that I admit is actually a problem.
> 
> Ok, ok, I'll accept that completion() version, even though I think it's 
> inferior.

Great! :-)

I slightly changed it in the meantime to avoid calling wait_for_completion()
when both the parent and the child are "synchronous", which prevents the code
from choking on some situations when the ordering of dpm_list is wrong (this
happens as a result of bugs, but not necessarily fatal, for example if one of
the drivers' suspend and resume callbacks are NULL and the bus type doesn't
access the hardware directly, so we shouldn't make things worse than they
already are IMO).

I'd like to put it into my tree in this form, if you don't mind.

[Note for Alan: dpm_wait() is not exported for now, we'll export it when there
are any users.]

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Asynchronous suspend and resume of devices

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
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
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
@@ -381,17 +410,19 @@ void dpm_resume_noirq(pm_message_t state
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
@@ -426,11 +457,36 @@ static int device_resume(struct device *
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
@@ -444,6 +500,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +511,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -469,6 +526,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
@@ -623,17 +681,24 @@ int dpm_suspend_noirq(pm_message_t state
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
@@ -666,12 +731,44 @@ static int device_suspend(struct device 
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
@@ -683,13 +780,15 @@ static int dpm_suspend(pm_message_t stat
 
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
@@ -697,13 +796,17 @@ static int dpm_suspend(pm_message_t stat
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
