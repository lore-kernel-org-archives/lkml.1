Return-Path: <linux-kernel-owner+w=401wt.eu-S966466AbZLHVkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966466AbZLHVkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966389AbZLHVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:40:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966099AbZLHVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:40:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 22:40:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <200912082044.52098.rjw@sisk.pl> <alpine.LFD.2.00.0912081256310.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912081256310.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082240.42773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Linus Torvalds wrote:
> 
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > Anyway, if we use an rwsem, it won't be checkable from interrupt context just
> > as well.
> 
> You can't do a lock() from an interrupt, but the unlocks should be 
> irq-safe. 
> 
> > Suppose we use rwsem and during suspend each child uses a down_read() on a
> > parent and then the parent uses down_write() on itself.  What if, whatever the
> > reason, the parent is a bit early and does the down_write() before one of the
> > children has a chance to do the down_read()?  Aren't we toast?
> 
> We're toast, but we're toast for a totally unrealted reason: it means that 
> you tried to resume a child before a parent, which would be a major bug to 
> begin with.
> 
> Look, I even wrote out the comments, so let me repeat the code one more 
> time.
> 
>  - suspend time calling:
>         // This won't block, because we suspend nodes before parents
>         down_read(node->parent->lock);
>         // Do the part that may block asynchronously
>         async_schedule(do_usb_node_suspend, node);
> 
>  - resume time calling:
>         // This won't block, because we resume parents before children,
>         // and the children will take the read lock. 
>         down_write(leaf->lock);
>         // Do the blocking part asynchronously
>         async_schedule(usb_node_resume, leaf);
> 
> See? So when we take the parent lock for suspend, we are guaranteed to do 
> so _before_ the parent node itself suspends. And conversely, when we take 
> the parent lock (asynchronously) for resume, we're guaranteed to do that 
> _after_ the parent node has done its own down_write.
> 
> And that all depends on just one trivial thing; that the suspend and 
> resume is called in the right order (children first vs parent first 
> respectively). And that is such a _major_ correctness issue that if that 
> isn't correct, your suspend isn't going to work _anyway_.

Understood (I think).

Let's try it, then.  Below is the resume patch based on my previous one in this
thread (I have only verified that it builds).  Is that along the lines you want?

Rafael


---
 drivers/base/power/main.c    |   78 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/device.h       |    6 +++
 include/linux/pm.h           |    3 +
 include/linux/resume-trace.h |    7 +++
 4 files changed, 85 insertions(+), 9 deletions(-)

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
 
@@ -334,25 +337,51 @@ static void pm_dev_err(struct device *de
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
+	down_read(&dev->parent->power.rwsem);
 
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
- End:
+
+	up_read(&dev->parent->power.rwsem);
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
@@ -366,32 +395,35 @@ void dpm_resume_noirq(pm_message_t state
 
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
 
+	down_read(&dev->parent->power.rwsem);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -426,11 +458,37 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	up_read(&dev->parent->power.rwsem);
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
@@ -444,6 +502,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +513,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -469,6 +528,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
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
 
