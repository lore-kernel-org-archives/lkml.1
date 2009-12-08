Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZLHMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZLHMeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZLHMen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:34:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZLHMel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:34:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 13:23:50 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org>
MIME-Version: 1.0
Message-Id: <200912081323.50606.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Alan Stern wrote:
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> 
> > However, the parent can be on a different bus type than the children, so it
> > looks like we can only start the asynchronous path at the core level.
> 
> Agreed.
> 
> > > Unless you want to do _all_ of the async logic in generic code and 
> > > re-introduce the "dev->async_suspend" flag.
> > 
> > Quite frankly, I would like to.
> > 
> > > I would be ok with that now that the infrastructure seems so simple.
> > 
> > Well, perhaps I should dig out my original async suspend/resume patches
> > that didn't contain all of the non-essential stuff and post them here for
> > discussion, after all ...
> 
> That seems like a very good idea.  IIRC they were quite similar to what 
> we have been discussing.

There you go.

Below is the resume part.  I have reworked the original patch a bit so that
it's even simpler.  I'll post the suspend part in a reply to this message.

The idea is basically that if a device has the power.async_suspend flag set,
we schedule the execution of it's resume callback asynchronously, but we
wait for the device's parent to finish resume before the device's suspend is
actually executed.

The wait queue plus the op_complete flag combo plays the role of the locking
in the Linus' picture, and it's essentially equivalent, since the devices being
waited for during resume will have to wait during suspend, so for example if
A has to wait for B during suspend, then B will have to wait for A during
resume (thus they both need to know in advance who's going to wait for them
and whom they need to wait for).

Of course, the code in this patch has the problem that if there are two
"asynchronous" devices in dpm_list separated by a series of "synchronous"
devices, then they usually won't be resumed in parallel (which is what we
ultimately want).  That can be optimised in a couple of ways, but such
optimisations add quite some details to the code, so let's just omit them for
now.

BTW, thanks to the discussion with Linus I've realized that the off-tree
dependences may be (relatively easily) taken into account by making the
interested drivers directly execute dpm_wait() for the extra devices they
need to wait for, so the entire PM links thing is simply unnecessary.  So it
looks like the only thing this patch is missing are the optimisations mentioned
above.

[This version of the patch has only been slightly tested.]

---
 drivers/base/power/main.c    |  129 +++++++++++++++++++++++++++++++++++++++----
 include/linux/device.h       |    6 ++
 include/linux/pm.h           |    4 +
 include/linux/resume-trace.h |    7 ++
 4 files changed, 134 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -412,15 +412,17 @@ struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
+	unsigned		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
+	wait_queue_head_t	wait_queue;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
+	unsigned int            op_complete:1;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
 	unsigned long		timer_expires;
 	struct work_struct	work;
-	wait_queue_head_t	wait_queue;
 	spinlock_t		lock;
 	atomic_t		usage_count;
 	atomic_t		child_count;
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
+	init_waitqueue_head(&dev->power.wait_queue);
 	pm_runtime_init(dev);
 }
 
@@ -162,6 +165,56 @@ void device_pm_move_last(struct device *
 }
 
 /**
+ * dpm_reset - Clear op_complete for given device.
+ * @dev: Device to handle.
+ */
+static void dpm_reset(struct device *dev)
+{
+       dev->power.op_complete = false;
+}
+
+/**
+ * dpm_finish - Set op_complete for a device and wake up threads waiting for it.
+ */
+static void dpm_finish(struct device *dev)
+{
+	dev->power.op_complete = true;
+	wake_up_all(&dev->power.wait_queue);
+}
+
+/**
+ * dpm_wait - Wait for a PM operation to complete.
+ * @dev: Device to wait for.
+ * @async: If true, ignore the device's async_suspend flag.
+ *
+ * Wait for a PM operation carried out for @dev to complete, unless @dev has to
+ * be handled synchronously and @async is false.
+ */
+static void dpm_wait(struct device *dev, bool async)
+{
+       if (!dev)
+               return;
+
+       if (!(async || dev->power.async_suspend))
+               return;
+
+       if (!dev->power.op_complete)
+               wait_event(dev->power.wait_queue, !!dev->power.op_complete);
+}
+
+/**
+ * dpm_synchronize - Wait for PM callbacks of all devices to complete.
+ */
+static void dpm_synchronize(void)
+{
+	struct device *dev;
+
+	async_synchronize_full();
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		dpm_reset(dev);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -334,25 +387,48 @@ static void pm_dev_err(struct device *de
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
+	dpm_finish(dev);
+
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	dpm_wait(dev->parent, true);
+	error = __device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async EARLY", error);
+	put_device(dev);
+}
+
+static int device_resume_noirq(struct device *dev)
+{
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	dpm_wait(dev->parent, false);
+	return __device_resume_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_resume_noirq - Execute "early resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -366,26 +442,28 @@ void dpm_resume_noirq(pm_message_t state
 
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
 				pm_dev_err(dev, state, " early", error);
 		}
+	dpm_synchronize();
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
 
@@ -426,11 +504,36 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	dpm_finish(dev);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	dpm_wait(dev->parent, true);
+	error = __device_resume(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev)
+{
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	dpm_wait(dev->parent, false);
+	return __device_resume(dev, pm_transition);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -444,6 +547,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +558,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -468,6 +572,7 @@ static void dpm_resume(pm_message_t stat
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
+	dpm_synchronize();
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -793,8 +898,10 @@ static int dpm_prepare(pm_message_t stat
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
 
