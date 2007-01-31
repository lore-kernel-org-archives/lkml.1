Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbXAaDm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbXAaDm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbXAaDms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:42:48 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65447 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932622AbXAaDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:40:45 -0500
Message-Id: <20070131033806.468210824@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:21 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 11/23] clocksource: atomic signals
Content-Disposition: inline; filename=clocksource_add_atomic_singals.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modifies the way clocks are switched to in the timekeeping code. The original
code would constantly monitor the clocksource list checking for newly added
clocksources. I modified this by using atomic types to signal when a new clock
is added. This allows the operation to be used only when it's needed.

The fast path is also reduced to checking a single atomic value.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |    5 ++++
 include/linux/timekeeping.h |    4 ---
 kernel/time/clocksource.c   |    6 +++++
 kernel/time/timekeeping.c   |   49 ++++++++++++++++++++++++++++----------------
 4 files changed, 43 insertions(+), 21 deletions(-)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -25,6 +25,11 @@ typedef u64 cycle_t;
 extern struct clocksource clocksource_jiffies;
 
 /*
+ * Atomic signal that is specific to timekeeping.
+ */
+extern atomic_t clock_check;
+
+/*
  * Allows inlined calling for notifier routines.
  */
 extern struct atomic_notifier_head clocksource_list_notifier;
Index: linux-2.6.19/include/linux/timekeeping.h
===================================================================
--- linux-2.6.19.orig/include/linux/timekeeping.h
+++ linux-2.6.19/include/linux/timekeeping.h
@@ -4,10 +4,6 @@
 #include <linux/clocksource.h>
 
 #ifndef CONFIG_GENERIC_TIME
-static inline int change_clocksource(void)
-{
-	return 0;
-}
 
 static inline void change_clocksource(void) { }
 static inline void timekeeping_init_notifier(void) { }
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -50,6 +50,7 @@ static char override_name[32];
 static int finished_booting;
 
 ATOMIC_NOTIFIER_HEAD(clocksource_list_notifier);
+atomic_t clock_check = ATOMIC_INIT(0);
 
 /* clocksource_done_booting - Called near the end of bootup
  *
@@ -58,6 +59,8 @@ ATOMIC_NOTIFIER_HEAD(clocksource_list_no
 static int __init clocksource_done_booting(void)
 {
 	finished_booting = 1;
+	/* Check for a new clock now */
+	atomic_inc(&clock_check);
 	return 0;
 }
 
@@ -285,6 +288,9 @@ static ssize_t sysfs_override_clocksourc
 	/* try to select it: */
 	next_clocksource = select_clocksource();
 
+	/* Signal that there is a new clocksource */
+	atomic_inc(&clock_check);
+
 	spin_unlock_irq(&clocksource_lock);
 
 	return ret;
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.19.orig/kernel/time/timekeeping.c
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/timekeeping.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
@@ -39,7 +40,6 @@ static unsigned long timekeeping_suspend
  * Clock used for timekeeping
  */
 struct clocksource *clock = &clocksource_jiffies;
-atomic_t clock_recalc_interval = ATOMIC_INIT(0);
 
 #ifdef CONFIG_GENERIC_TIME
 /**
@@ -157,11 +157,12 @@ int do_settimeofday(struct timespec *tv)
 EXPORT_SYMBOL(do_settimeofday);
 
 /**
- * change_clocksource - Swaps clocksources if a new one is available
+ * timkeeping_change_clocksource - Swaps clocksources if a new one is available
  *
  * Accumulates current time interval and initializes new clocksource
+ * Needs to be called with the xtime_lock held.
  */
-static int change_clocksource(void)
+static void timekeeping_change_clocksource(void)
 {
 	struct clocksource *new;
 	cycle_t now;
@@ -176,12 +177,15 @@ static int change_clocksource(void)
 		clock->cycle_last = now;
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 		       clock->name);
-		return 1;
-	} else if (unlikely(atomic_read(&clock_recalc_interval))) {
-		atomic_set(&clock_recalc_interval, 0);
-		return 1;
+		tick_clock_notify();
+		clock->error = 0;
+		clock->xtime_nsec = 0;
+		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	} else {
+		clock->error = 0;
+		clock->xtime_nsec = 0;
+		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	}
-	return 0;
 }
 
 /**
@@ -205,9 +209,14 @@ int timekeeping_is_continuous(void)
 static int
 clocksource_callback(struct notifier_block *nb, unsigned long op, void *c)
 {
-	if (c == clock && op == CLOCKSOURCE_NOTIFY_FREQ &&
-	    !atomic_read(&clock_recalc_interval))
-		atomic_inc(&clock_recalc_interval);
+	if (likely(c != clock))
+		return 0;
+
+	switch (op) {
+		case CLOCKSOURCE_NOTIFY_FREQ:
+		case CLOCKSOURCE_NOTIFY_RATING:
+			atomic_inc(&clock_check);
+	}
 
 	return 0;
 }
@@ -334,6 +343,7 @@ static int __init timekeeping_init_devic
 	int error = sysdev_class_register(&timekeeping_sysclass);
 	if (!error)
 		error = sysdev_register(&device_timer);
+
 	return error;
 }
 
@@ -476,13 +486,18 @@ static inline void update_wall_time(void
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
-	/* check to see if there is a new clocksource to use */
-	if (change_clocksource()) {
-		clock->error = 0;
-		clock->xtime_nsec = 0;
-		tick_clock_notify();
-		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+#ifdef CONFIG_GENERIC_TIME
+	/*
+	 * check to see if there is a new clocksource to use
+	 */
+	if (unlikely(atomic_read(&clock_check))) {
+
+		timekeeping_change_clocksource();
+
+		atomic_set(&clock_check, 0);
 	}
+#endif /* CONFIG_GENERIC_TIME */
+
 	update_vsyscall(&xtime, clock);
 }
 

-- 
