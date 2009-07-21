Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZGUTVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZGUTVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZGUTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:11 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:61546 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZGUTVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:21:06 -0400
Message-Id: <20090721192101.545285889@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 21 Jul 2009 21:17:50 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 5/5] update clocksource with stop_machine
Content-Disposition: inline; filename=clocksource-stop_machine.diff
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
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |    2 -
 kernel/time/clocksource.c   |   82 ++++++++++++++++----------------------------
 kernel/time/timekeeping.c   |    2 -
 3 files changed, 31 insertions(+), 55 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -340,10 +340,8 @@ extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME
 extern void clocksource_forward_now(void);
-extern void change_clocksource(void);
 #else
 static inline void clocksource_forward_now(void) { }
-static inline void change_clocksource(void) { }
 #endif
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/stop_machine.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -107,46 +108,26 @@ u64 timecounter_cyc2time(struct timecoun
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
-/* XXX - Would like a better way for initializing curr_clocksource */
+/* XXX - Would like a better way for initializing clock */
 extern struct clocksource clocksource_jiffies;
 
 /* Currently selected clock source. */
 struct clocksource *clock;
 
 /*[Clocksource internal variables]---------
- * curr_clocksource:
- *	currently selected clocksource. Initialized to clocksource_jiffies.
- * next_clocksource:
- *	pending next selected clocksource.
  * clocksource_list:
  *	linked list with the registered clocksources
  * clocksource_lock:
- *	protects manipulations to curr_clocksource and next_clocksource
- *	and the clocksource_list
+ *	protects manipulations to the clocksource_list
  * override_name:
  *	Name of the user-specified clocksource.
  */
-static struct clocksource *curr_clocksource = &clocksource_jiffies;
-static struct clocksource *next_clocksource;
 static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 static int finished_booting;
 
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
-
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
@@ -323,24 +304,6 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
-/**
- * clocksource_get_next - Returns the selected clocksource
- *
- */
-struct clocksource *clocksource_get_next(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	if (next_clocksource && finished_booting) {
-		curr_clocksource = next_clocksource;
-		next_clocksource = NULL;
-	}
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-
-	return curr_clocksource;
-}
-
 /*
  * Enqueue the clocksource sorted by rating
  */
@@ -552,23 +515,22 @@ static struct clocksource *select_clocks
 }
 
 /**
- * change_clocksource - Swaps clocksources if a new one is available
+ * clocksource_swap - Swaps clocksources if a new one is available
  *
  * Accumulates current time interval and initializes new clocksource
  */
-void change_clocksource(void)
+static int clocksource_swap(void *dummy)
 {
 	struct clocksource *new, *old;
 
-	new = clocksource_get_next();
-
-	if (clock == new)
-		return;
+	new = select_clocksource();
+	if (!new || clock == new)
+		return 0;
 
 	clocksource_forward_now();
 
 	if (new->enable && !new->enable(new))
-		return;
+		return 0;
 
 	/* save mult_orig after successful enable */
 	new->mult_orig = new->mult;
@@ -592,6 +554,7 @@ void change_clocksource(void)
 	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 	       clock->name);
 	 */
+	return 0;
 }
 
 /**
@@ -602,11 +565,13 @@ static void clocksource_update(void)
 	struct clocksource *new;
 	unsigned long flags;
 
+	if (!finished_booting)
+		return;
 	spin_lock_irqsave(&clocksource_lock, flags);
 	new = select_clocksource();
-	if (new)
-		next_clocksource = new;
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+	if (new && new != clock)
+		stop_machine(clocksource_swap, NULL, NULL);
 }
 #else /* CONFIG_GENERIC_TIME */
 static inline void clocksource_update(void) { }
@@ -657,7 +622,7 @@ void clocksource_unregister(struct clock
  */
 void __init clocksource_init(void)
 {
-	clock = clocksource_get_next();
+	clock = &clocksource_jiffies;
 	if (clock->enable)
 		clock->enable(clock);
 	/* save mult_orig on enable */
@@ -666,6 +631,21 @@ void __init clocksource_init(void)
 	clock->cycle_last = clock->read(clock);
 }
 
+/**
+ * clocksource_done_booting - Called near the end of core bootup
+ *
+ * Hack to avoid lots of clocksource churn at boot time.
+ * We use fs_initcall because we want this to start before
+ * device_initcall but after subsys_initcall.
+ */
+static int __init clocksource_done_booting(void)
+{
+	finished_booting = 1;
+	clocksource_update();
+	return 0;
+}
+fs_initcall(clocksource_done_booting);
+
 #ifdef CONFIG_SYSFS
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
@@ -681,7 +661,7 @@ sysfs_show_current_clocksources(struct s
 	ssize_t count = 0;
 
 	spin_lock_irq(&clocksource_lock);
-	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
+	count = snprintf(buf, PAGE_SIZE, "%s\n", clock->name);
 	spin_unlock_irq(&clocksource_lock);
 
 	return count;
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -491,8 +491,6 @@ void update_wall_time(void)
 
 	update_xtime_cache(cyc2ns(clock, offset));
 
-	/* check to see if there is a new clocksource to use */
-	change_clocksource();
 	update_vsyscall(&xtime, clock);
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

