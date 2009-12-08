Return-Path: <linux-kernel-owner+w=401wt.eu-S966834AbZLHWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966834AbZLHWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966690AbZLHWyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:54:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966589AbZLHWyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:54:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Async suspend-resume patch w/ rwsems (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 23:55:00 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <200912082240.42773.rjw@sisk.pl> <200912082303.12758.rjw@sisk.pl>
In-Reply-To: <200912082303.12758.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082355.00711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Rafael J. Wysocki wrote:
> On Tuesday 08 December 2009, Rafael J. Wysocki wrote:
> > On Tuesday 08 December 2009, Linus Torvalds wrote:
> > > 
> > > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > > > 
> > > > Anyway, if we use an rwsem, it won't be checkable from interrupt context just
> > > > as well.
> > > 
> > > You can't do a lock() from an interrupt, but the unlocks should be 
> > > irq-safe. 
> > > 
> > > > Suppose we use rwsem and during suspend each child uses a down_read() on a
> > > > parent and then the parent uses down_write() on itself.  What if, whatever the
> > > > reason, the parent is a bit early and does the down_write() before one of the
> > > > children has a chance to do the down_read()?  Aren't we toast?
> > > 
> > > We're toast, but we're toast for a totally unrealted reason: it means that 
> > > you tried to resume a child before a parent, which would be a major bug to 
> > > begin with.
> > > 
> > > Look, I even wrote out the comments, so let me repeat the code one more 
> > > time.
> > > 
> > >  - suspend time calling:
> > >         // This won't block, because we suspend nodes before parents
> > >         down_read(node->parent->lock);
> > >         // Do the part that may block asynchronously
> > >         async_schedule(do_usb_node_suspend, node);
> > > 
> > >  - resume time calling:
> > >         // This won't block, because we resume parents before children,
> > >         // and the children will take the read lock. 
> > >         down_write(leaf->lock);
> > >         // Do the blocking part asynchronously
> > >         async_schedule(usb_node_resume, leaf);
> > > 
> > > See? So when we take the parent lock for suspend, we are guaranteed to do 
> > > so _before_ the parent node itself suspends. And conversely, when we take 
> > > the parent lock (asynchronously) for resume, we're guaranteed to do that 
> > > _after_ the parent node has done its own down_write.
> > > 
> > > And that all depends on just one trivial thing; that the suspend and 
> > > resume is called in the right order (children first vs parent first 
> > > respectively). And that is such a _major_ correctness issue that if that 
> > > isn't correct, your suspend isn't going to work _anyway_.
> > 
> > Understood (I think).
> > 
> > Let's try it, then.  Below is the resume patch based on my previous one in this
> > thread (I have only verified that it builds).
> 
> Ah, I need to check if dev->parent is not NULL before trying to lock it, but
> apart from this it doesn't break things at least.

For completness, below is the full async suspend/resume patch with rwlocks,
that has been (very slightly) tested and doesn't seem to break things.

[Note to Alan: lockdep doesn't seem to complain about the not annotated nested
locks.]

Thanks,
Rafael


---
 drivers/base/power/main.c    |  195 +++++++++++++++++++++++++++++++++++++++----
 include/linux/device.h       |    6 +
 include/linux/pm.h           |    3 
 include/linux/resume-trace.h |    7 +
 4 files changed, 194 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
+#include <linux/rwsem.h>
 
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
+	struct rw_semaphore	rwsem;
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
+	init_rwsem(&dev->power.rwsem);
 	pm_runtime_init(dev);
 }
 
@@ -334,25 +337,53 @@ static void pm_dev_err(struct device *de
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
+	if (dev->parent)
+		down_read(&dev->parent->power.rwsem);
 
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
- End:
+
+	if (dev->parent)
+		up_read(&dev->parent->power.rwsem);
+	up_write(&dev->power.rwsem);
+
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async EARLY", error);
+	put_device(dev);
+}
+
+static int device_resume_noirq(struct device *dev)
+{
+	down_write(&dev->power.rwsem);
+
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	return __device_resume_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_resume_noirq - Execute "early resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -366,32 +397,36 @@ void dpm_resume_noirq(pm_message_t state
 
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
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
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
 
+	if (dev->parent)
+		down_read(&dev->parent->power.rwsem);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -426,11 +461,38 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	if (dev->parent)
+		up_read(&dev->parent->power.rwsem);
+	up_write(&dev->power.rwsem);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev)
+{
+	down_write(&dev->power.rwsem);
+
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	return __device_resume(dev, pm_transition);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -444,6 +506,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +517,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -469,6 +532,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
@@ -533,6 +597,8 @@ static void dpm_complete(pm_message_t st
 	mutex_unlock(&dpm_list_mtx);
 }
 
+static atomic_t async_error;
+
 /**
  * dpm_resume_end - Execute "resume" callbacks and complete system transition.
  * @state: PM transition of the system being carried out.
@@ -580,20 +646,59 @@ static pm_message_t resume_event(pm_mess
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
+	down_write(&dev->power.rwsem);
 
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
+
+	up_write(&dev->power.rwsem);
+	if (dev->parent)
+		up_read(&dev->parent->power.rwsem);
+
 	return error;
 }
 
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = atomic_read(&async_error);
+
+	if (error) {
+		if (dev->parent)
+			up_read(&dev->parent->power.rwsem);
+		dev->power.status = DPM_OFF;
+		return;
+	}
+
+	error = __device_suspend_noirq(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async LATE", error);
+		dev->power.status = DPM_OFF;
+		atomic_set(&async_error, error);
+	}
+	put_device(dev);
+}
+
+static int device_suspend_noirq(struct device *dev)
+{
+	if (dev->parent)
+		down_read(&dev->parent->power.rwsem);
+
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+
+	return __device_suspend_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_suspend_noirq - Execute "late suspend" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -608,15 +713,21 @@ int dpm_suspend_noirq(pm_message_t state
 
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
-		error = device_suspend_noirq(dev, state);
+		dev->power.status = DPM_OFF_IRQ;
+		error = device_suspend_noirq(dev);
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
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	if (error)
 		dpm_resume_noirq(resume_event(state));
 	return error;
@@ -628,10 +739,11 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
+	down_write(&dev->power.rwsem);
 	down(&dev->sem);
 
 	if (dev->class) {
@@ -668,10 +780,50 @@ static int device_suspend(struct device 
 	}
  End:
 	up(&dev->sem);
+	up_write(&dev->power.rwsem);
+	if (dev->parent)
+		up_read(&dev->parent->power.rwsem);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = atomic_read(&async_error);
+
+	if (error) {
+		if (dev->parent)
+			up_read(&dev->parent->power.rwsem);
+		dev->power.status = DPM_SUSPENDING;
+		goto End;
+	}
+
+	error = __device_suspend(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+		dev->power.status = DPM_SUSPENDING;
+		atomic_set(&async_error, error);
+	}
+
+ End:
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev, pm_message_t state)
+{
+	if (dev->parent)
+		down_read(&dev->parent->power.rwsem);
+
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	return __device_suspend(dev, pm_transition);
+}
+
 /**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -683,10 +835,12 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_suspend(dev, state);
@@ -694,16 +848,22 @@ static int dpm_suspend(pm_message_t stat
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
+	async_synchronize_full();
+	if (!error)
+		error = atomic_read(&async_error);
 	return error;
 }
 
@@ -762,6 +922,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	atomic_set(&async_error, 0);
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
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
 
