Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbZHNNuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbZHNNuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbZHNNtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:49:40 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56987 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbZHNNsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:11 -0400
Message-Id: <20090814134810.711836357@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 13/15] update clocksource with stop_machine
Content-Disposition: inline; filename=timekeeper-stop-machine.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

update_wall_time calls change_clocksource HZ times per second to check
if a new clock source is available. In close to 100% of all calls there
is no new clock. Replace the tick based check by an update done with
stop_machine.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |    2 
 kernel/time/clocksource.c   |  112 +++++++++++++++++---------------------------
 kernel/time/timekeeping.c   |   41 ++++++++++------
 3 files changed, 72 insertions(+), 83 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -291,4 +291,6 @@ static inline void update_vsyscall_tz(vo
 }
 #endif
 
+extern void timekeeping_notify(struct clocksource *clock);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -109,35 +109,17 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource.
- * next_clocksource:
- *	pending next selected clocksource.
  * clocksource_list:
  *	linked list with the registered clocksources
- * clocksource_lock:
- *	protects manipulations to curr_clocksource and next_clocksource
- *	and the clocksource_list
+ * clocksource_mutex:
+ *	protects manipulations to curr_clocksource and the clocksource_list
  * override_name:
  *	Name of the user-specified clocksource.
  */
 static struct clocksource *curr_clocksource;
-static struct clocksource *next_clocksource;
 static LIST_HEAD(clocksource_list);
-static DEFINE_SPINLOCK(clocksource_lock);
+static DEFINE_MUTEX(clocksource_mutex);
 static char override_name[32];
-static int finished_booting;
-
-/* clocksource_done_booting - Called near the end of core bootup
- *
- * Hack to avoid lots of clocksource churn at boot time.
- * We use fs_initcall because we want this to start before
- * device_initcall but after subsys_initcall.
- */
-static int __init clocksource_done_booting(void)
-{
-	finished_booting = 1;
-	return 0;
-}
-fs_initcall(clocksource_done_booting);
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static LIST_HEAD(watchdog_list);
@@ -356,18 +338,16 @@ static inline void clocksource_resume_wa
 void clocksource_resume(void)
 {
 	struct clocksource *cs;
-	unsigned long flags;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 
-	list_for_each_entry(cs, &clocksource_list, list) {
+	list_for_each_entry(cs, &clocksource_list, list)
 		if (cs->resume)
 			cs->resume();
-	}
 
 	clocksource_resume_watchdog();
 
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 }
 
 /**
@@ -383,28 +363,13 @@ void clocksource_touch_watchdog(void)
 }
 
 #ifdef CONFIG_GENERIC_TIME
-/**
- * clocksource_get_next - Returns the selected clocksource
- *
- */
-struct clocksource *clocksource_get_next(void)
-{
-	unsigned long flags;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
-	if (next_clocksource && finished_booting) {
-		curr_clocksource = next_clocksource;
-		next_clocksource = NULL;
-	}
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-
-	return curr_clocksource;
-}
+static int finished_booting;
 
 /**
  * clocksource_select - Select the best clocksource available
  *
- * Private function. Must hold clocksource_lock when called.
+ * Private function. Must hold clocksource_mutex when called.
  *
  * Select the clocksource with the best rating, or the clocksource,
  * which is selected by userspace override.
@@ -413,7 +378,7 @@ static void clocksource_select(void)
 {
 	struct clocksource *best, *cs;
 
-	if (list_empty(&clocksource_list))
+	if (!finished_booting || list_empty(&clocksource_list))
 		return;
 	/* First clocksource on the list has the best rating. */
 	best = list_first_entry(&clocksource_list, struct clocksource, list);
@@ -438,13 +403,31 @@ static void clocksource_select(void)
 			best = cs;
 		break;
 	}
-	if (curr_clocksource != best)
-		next_clocksource = best;
+	if (curr_clocksource != best) {
+		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+		curr_clocksource = best;
+		timekeeping_notify(curr_clocksource);
+	}
 }
 
+/*
+ * clocksource_done_booting - Called near the end of core bootup
+ *
+ * Hack to avoid lots of clocksource churn at boot time.
+ * We use fs_initcall because we want this to start before
+ * device_initcall but after subsys_initcall.
+ */
+static int __init clocksource_done_booting(void)
+{
+	finished_booting = 1;
+	clocksource_select();
+	return 0;
+}
+fs_initcall(clocksource_done_booting);
+
 #else /* CONFIG_GENERIC_TIME */
 
-static void clocksource_select(void) { }
+static inline void clocksource_select(void) { }
 
 #endif
 
@@ -471,13 +454,11 @@ static void clocksource_enqueue(struct c
  */
 int clocksource_register(struct clocksource *cs)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_select();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
 	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -487,14 +468,12 @@ EXPORT_SYMBOL(clocksource_register);
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 	list_del(&cs->list);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
 	clocksource_select();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
 
@@ -503,13 +482,11 @@ EXPORT_SYMBOL(clocksource_change_rating)
  */
 void clocksource_unregister(struct clocksource *cs)
 {
-	unsigned long flags;
-
+	mutex_lock(&clocksource_mutex);
 	clocksource_dequeue_watchdog(cs);
-	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
 	clocksource_select();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
@@ -527,9 +504,9 @@ sysfs_show_current_clocksources(struct s
 {
 	ssize_t count = 0;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	return count;
 }
@@ -555,14 +532,14 @@ static ssize_t sysfs_override_clocksourc
 	if (buf[count-1] == '\n')
 		count--;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 
 	if (count > 0)
 		memcpy(override_name, buf, count);
 	override_name[count] = 0;
 	clocksource_select();
 
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	return count;
 }
@@ -582,7 +559,7 @@ sysfs_show_available_clocksources(struct
 	struct clocksource *src;
 	ssize_t count = 0;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 	list_for_each_entry(src, &clocksource_list, list) {
 		/*
 		 * Don't show non-HRES clocksource if the tick code is
@@ -594,7 +571,7 @@ sysfs_show_available_clocksources(struct
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	count += snprintf(buf + count,
 			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
@@ -649,11 +626,10 @@ device_initcall(init_clocksource_sysfs);
  */
 static int __init boot_override_clocksource(char* str)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 	if (str)
 		strlcpy(override_name, str, sizeof(override_name));
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 	return 1;
 }
 
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/tick.h>
+#include <linux/stop_machine.h>
 
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
@@ -179,6 +180,7 @@ void timekeeping_leap_insert(int leapsec
 }
 
 #ifdef CONFIG_GENERIC_TIME
+
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -351,31 +353,40 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static void change_clocksource(void)
+static int change_clocksource(void *data)
 {
 	struct clocksource *new, *old;
 
-	new = clocksource_get_next();
-
-	if (!new || timekeeper.clock == new)
-		return;
+	new = (struct clocksource *) data;
 
 	timekeeping_forward_now();
+	if (!new->enable || new->enable(new) == 0) {
+		old = timekeeper.clock;
+		timekeeper_setup_internals(new);
+		if (old->disable)
+			old->disable(old);
+	}
+	return 0;
+}
 
-	if (new->enable && ! new->enable(new))
+/**
+ * timekeeping_notify - Install a new clock source
+ * @clock:		pointer to the clock source
+ *
+ * This function is called from clocksource.c after a new, better clock
+ * source has been registered. The caller holds the clocksource_mutex.
+ */
+void timekeeping_notify(struct clocksource *clock)
+{
+	if (timekeeper.clock == clock)
 		return;
-
-	old = timekeeper.clock;
-	timekeeper_setup_internals(new);
-
-	if (old->disable)
-		old->disable(old);
-
+	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
 }
+
 #else /* GENERIC_TIME */
+
 static inline void timekeeping_forward_now(void) { }
-static inline void change_clocksource(void) { }
 
 /**
  * ktime_get - get the monotonic time in ktime_t format
@@ -416,6 +427,7 @@ void ktime_get_ts(struct timespec *ts)
 				ts->tv_nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
+
 #endif /* !GENERIC_TIME */
 
 /**
@@ -772,7 +784,6 @@ void update_wall_time(void)
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
-	change_clocksource();
 	update_vsyscall(&xtime, timekeeper.clock);
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

