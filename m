Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbZLKXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbZLKXsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761624AbZLKXsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:48:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761613AbZLKXsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:48:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 12 Dec 2009 00:48:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912112311.08548.rjw@sisk.pl> <alpine.LFD.2.00.0912111415160.3922@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912111415160.3922@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912120048.46180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Linus Torvalds wrote:
> 
> On Fri, 11 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > But fine, say we use the approach based on rwsems and consider suspend and
> > the inner lock.  We acquire it using down_write(), because we want to wait for
> > multiple other dirvers.  Now, in fact we could do literally
> > 
> > down_write(dev->power.rwsem);
> > up_write(dev->power.rwsem);
> > 
> > because the lock doesn't really protect anything from anyone.  What it does is
> > to prevent _us_ from doing something too early.  To me, personally, it's not a
> > usual use of locks.
> 
> I agree that it's fairly unusual, but on the other hand, it's unusual only 
> because you contrieved it to be.

Whatever.  The very fact that you can freely move the up_write() (as long as
it's after the down_write()) is fairly unusual.

> But think about it this way: if you could abort a failed suspend, and 
> start resuming devices immediately, without doing that 
> "async_synchronize_full()" in between - simply because you know that the 
> node locking itself will just "do the right thing".

I'd rather not. :-)

> To me, that's a sign of a _good_ design. Using a rwsem is simply just more 
> robust and natural for the problem in question. Exactly because it's a 
> real lock.
...
> Solve the problem at hand _first_. Solve it as simply as you can. And hope 
> that you never ever will need anything more complex.

Below is a patch I've just tested, but there's a lockdep problem in it I don't
know how to solve.  Namely, lockdep is apparently unhappy with us not releasing
the lock taken in device_suspend() and it complains we take it twice in a row
(which we do, but for another device).  I need to use down_read_non_owner()
to make it shut up and then I also need to use up_read_non_owner() in
__device_suspend(), although there's the comment in include/linux/rwsem.h
saying exatly this about that:

/*
 * Take/release a lock when not the owner will release it.
 *
 * [ This API should be avoided as much as possible - the
 *   proper abstraction for this case is completions. ]
 */

(I'd like to know your opinion about that).  Yet, that's not all, because next
it complains during resume that __device_resume() releases a lock it didn't
acquire, which it clearly does, but that is intentional.  Unfortunately,
there's no up_write_non_owner() ...

So, what am I supposed to do about that?

Rafael


---
 drivers/base/power/main.c    |  107 +++++++++++++++++++++++++++++++++++++++----
 include/linux/device.h       |    6 ++
 include/linux/pm.h           |    3 +
 include/linux/resume-trace.h |    7 ++
 4 files changed, 114 insertions(+), 9 deletions(-)

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
 
@@ -381,17 +384,22 @@ void dpm_resume_noirq(pm_message_t state
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
+	struct device *parent = dev->parent;
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	/* Wait for the parent's resume to complete, if necessary. */
+	if (parent)
+		down_read_nested(&parent->power.rwsem, SINGLE_DEPTH_NESTING);
+
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -426,11 +434,41 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	if (parent)
+		up_read(&parent->power.rwsem);
+
+	/* Allow the children to resume now. */
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
+	/* Prevent the children from resuming before us. */
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
@@ -444,6 +482,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +493,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -469,6 +508,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
@@ -584,13 +624,11 @@ static int device_suspend_noirq(struct d
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
 	return error;
 }
 
@@ -623,17 +661,24 @@ int dpm_suspend_noirq(pm_message_t state
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
+static int async_error;
+
 /**
  * device_suspend - Execute "suspend" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
+	/* Wait for the suspends of the children to complete, if necessary. */
+	down_write_nested(&dev->power.rwsem, SINGLE_DEPTH_NESTING);
 	down(&dev->sem);
 
+	if (async_error)
+		goto End;
+
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
@@ -666,12 +711,50 @@ static int device_suspend(struct device 
 			suspend_report_result(dev->bus->suspend, error);
 		}
 	}
+
+	if (!error)
+		dev->power.status = DPM_OFF;
+
  End:
 	up(&dev->sem);
+	up_write(&dev->power.rwsem);
+
+	/* Allow the parent to suspend now. */
+	if (dev->parent)
+		up_read_non_owner(&dev->parent->power.rwsem);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+		async_error = error;
+	}
+
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev, pm_message_t state)
+{
+	/* Prevent the parent from suspending before us. */
+	if (dev->parent)
+		down_read_non_owner(&dev->parent->power.rwsem);
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
@@ -683,6 +766,7 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
@@ -697,13 +781,17 @@ static int dpm_suspend(pm_message_t stat
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
 
@@ -762,6 +850,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	async_error = 0;
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
