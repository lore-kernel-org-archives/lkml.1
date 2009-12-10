Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbZLJVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbZLJVNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbZLJVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:13:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761679AbZLJVNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:13:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Thu, 10 Dec 2009 22:14:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912101010090.2825-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912101010090.2825-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102214.40310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Alan Stern wrote:
> On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:
> 
> > > How about CONFIG_PROVE_LOCKING?  If lockdep really does start 
> > > complaining then switching to completions would be a simple way to 
> > > appease it.
> > 
> > Ah, that one is not set.  I guess I'll try it later, although I've already
> > decided to use completions anyway.
> 
> You should see how badly lockdep complains about the rwsems.  If it 
> really doesn't like them then using completions makes sense.

It does complain about them, but when the nested _down operations are marked
as nested, it stops complaining (that's in the version where there's no async
in the _noirq phases).

> > Index: linux-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -56,6 +58,7 @@ static bool transition_started;
> >  void device_pm_init(struct device *dev)
> >  {
> >  	dev->power.status = DPM_ON;
> > +	init_completion(&dev->power.completion);
> >  	pm_runtime_init(dev);
> >  }
> 
> You need a matching complete_all() in device_pm_remove(), in case 
> someone else is waiting for the device when it gets unregistered.

Right, added.

> > +/**
> > + * dpm_synchronize - Wait for PM callbacks of all devices to complete.
> > + */
> > +static void dpm_synchronize(void)
> > +{
> > +	struct device *dev;
> > +
> > +	async_synchronize_full();
> > +
> > +	mutex_lock(&dpm_list_mtx);
> > +	list_for_each_entry(dev, &dpm_list, power.entry)
> > +		INIT_COMPLETION(dev->power.completion);
> > +	mutex_unlock(&dpm_list_mtx);
> > +}
> 
> I agree with Linus, initializing the completions here is weird.  You
> should initialize them just before using them.

I removed that completely and now the INIT_COMPLETION() is always done in the
preceding phase.

> > @@ -683,6 +786,7 @@ static int dpm_suspend(pm_message_t stat
> >  
> >  	INIT_LIST_HEAD(&list);
> >  	mutex_lock(&dpm_list_mtx);
> > +	pm_transition = state;
> >  	while (!list_empty(&dpm_list)) {
> >  		struct device *dev = to_device(dpm_list.prev);
> >  
> > @@ -697,13 +801,18 @@ static int dpm_suspend(pm_message_t stat
> >  			put_device(dev);
> >  			break;
> >  		}
> > -		dev->power.status = DPM_OFF;
> >  		if (!list_empty(&dev->power.entry))
> >  			list_move(&dev->power.entry, &list);
> >  		put_device(dev);
> > +		error = atomic_read(&async_error);
> > +		if (error)
> > +			break;
> >  	}
> >  	list_splice(&list, dpm_list.prev);
> 
> Here's something you might want to do in a later patch.  These awkward 
> list-pointer manipulations can be simplified as follows:

Well, I'm not sure if that's more straightforward.

Anyway, as you said, that's something for a different patch. :-)

Below is an updated version of the $subject one.  I don't use the atomic_t for
async_error any more and (apart from this fixed issue) I don't see any problems
in the suspend error path now.

Rafael


---
 drivers/base/power/main.c    |  113 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h       |    6 ++
 include/linux/pm.h           |   12 ++++
 include/linux/resume-trace.h |    7 ++
 4 files changed, 131 insertions(+), 7 deletions(-)

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
@@ -508,6 +511,13 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
+extern int __dpm_wait(struct device *dev, void *ign);
+
+static inline void dpm_wait(struct device *dev)
+{
+	__dpm_wait(dev, NULL);
+}
+
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -520,6 +530,8 @@ static inline int dpm_suspend_start(pm_m
 
 #define suspend_report_result(fn, ret)		do {} while (0)
 
+static inline void dpm_wait(struct device *dev) {}
+
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
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
@@ -162,6 +166,24 @@ void device_pm_move_last(struct device *
 }
 
 /**
+ * __dpm_wait - Wait for a PM operation to complete.
+ * @dev: Device to wait for.
+ * @ign: This value is not used by the function.
+ */
+int __dpm_wait(struct device *dev, void *ign)
+{
+	if (dev)
+		wait_for_completion(&dev->power.completion);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__dpm_wait);
+
+static void dpm_wait_for_children(struct device *dev)
+{
+       device_for_each_child(dev, NULL, __dpm_wait);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -366,7 +388,7 @@ void dpm_resume_noirq(pm_message_t state
 
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
-	list_for_each_entry(dev, &dpm_list, power.entry)
+	list_for_each_entry(dev, &dpm_list, power.entry) {
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
@@ -375,23 +397,27 @@ void dpm_resume_noirq(pm_message_t state
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+		/* Needed by the subsequent dpm_resume(). */
+		INIT_COMPLETION(dev->power.completion);
+	}
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
 
+	dpm_wait(dev->parent);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -426,11 +452,34 @@ static int device_resume(struct device *
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
+	return __device_resume(dev, pm_transition);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -444,6 +493,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -454,7 +504,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -469,6 +519,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 }
 
 /**
@@ -623,15 +674,18 @@ int dpm_suspend_noirq(pm_message_t state
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
 
+	dpm_wait_for_children(dev);
 	down(&dev->sem);
 
 	if (dev->class) {
@@ -666,12 +720,48 @@ static int device_suspend(struct device 
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
+	if (async_error) {
+		complete_all(&dev->power.completion);
+		goto End;
+	}
+
+	error = __device_suspend(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+		async_error = error;
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
@@ -683,6 +773,7 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
@@ -697,13 +788,17 @@ static int dpm_suspend(pm_message_t stat
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
 
@@ -762,6 +857,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	async_error = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -793,8 +889,11 @@ static int dpm_prepare(pm_message_t stat
 			break;
 		}
 		dev->power.status = DPM_SUSPENDING;
-		if (!list_empty(&dev->power.entry))
+		if (!list_empty(&dev->power.entry)) {
 			list_move_tail(&dev->power.entry, &list);
+			/* Needed by the subsequent dpm_suspend(). */
+			INIT_COMPLETION(dev->power.completion);
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
