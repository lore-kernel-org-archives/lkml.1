Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbXAaDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbXAaDkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXAaDj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:39:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65346 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932585AbXAaDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:39:45 -0500
Message-Id: <20070131033806.127340327@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:20 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 10/23] clocksource: remove update_callback
Content-Disposition: inline; filename=clocksource_remove_update_callback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uses the block notifier to replace the functionality of update_callback().
update_callback() was a special case specifically for the tsc, but including
it in the clocksource structure duplicated it needlessly for other clocks.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c      |   33 +++++++++------------------------
 arch/x86_64/kernel/tsc.c    |   19 +++++--------------
 include/linux/clocksource.h |    2 --
 include/linux/timekeeping.h |    1 +
 kernel/time/timekeeping.c   |   32 ++++++++++++++++++++++++++++++--
 5 files changed, 45 insertions(+), 42 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -50,8 +50,7 @@ static int __init tsc_setup(char *str)
 __setup("notsc", tsc_setup);
 
 /*
- * code to mark and check if the TSC is unstable
- * due to cpufreq or due to unsynced TSCs
+ * Flag that denotes an unstable tsc and check function.
  */
 static int tsc_unstable;
 
@@ -60,12 +59,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -179,6 +172,7 @@ int recalibrate_cpu_khz(void)
 	if (cpu_has_tsc) {
 		cpu_khz = calculate_cpu_khz();
 		tsc_khz = cpu_khz;
+		mark_tsc_unstable();
 		cpu_data[0].loops_per_jiffy =
 			cpufreq_scale(cpu_data[0].loops_per_jiffy,
 					cpu_khz_old, cpu_khz);
@@ -295,7 +289,6 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
-static int tsc_update_callback(void);
 
 static cycle_t read_tsc(void)
 {
@@ -313,32 +306,24 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-static int tsc_update_callback(void)
+/*
+ * Code to mark if the TSC is unstable due to cpufreq or due to unsynced TSCs
+ */
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
 	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
+	if (unlikely(!tsc_unstable && clocksource_tsc.rating != 0)) {
 		clocksource_tsc.rating = 0;
 		clocksource_rating_change(&clocksource_tsc);
-		change = 1;
 	}
 
-	/* only update if tsc_khz has changed: */
-	if (current_tsc_khz != tsc_khz) {
-		current_tsc_khz = tsc_khz;
-		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
-							clocksource_tsc.shift);
-		change = 1;
-	}
-
-	return change;
+	tsc_unstable = 1;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -47,11 +47,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 #ifdef CONFIG_CPU_FREQ
 
@@ -182,8 +177,6 @@ __setup("notsc", notsc_setup);
 
 /* clock source code: */
 
-static int tsc_update_callback(void);
-
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
@@ -202,24 +195,22 @@ static struct clocksource clocksource_ts
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 	.vread			= vread_tsc,
 };
 
-static int tsc_update_callback(void)
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
 	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
+	if (unlikely(!tsc_unstable && clocksource_tsc.rating != 50)) {
 		clocksource_tsc.rating = 50;
 		clocksource_rating_change(&clocksource_tsc);
-		change = 1;
 	}
-	return change;
+
+	tsc_unstable = 1;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init init_tsc_clocksource(void)
 {
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -86,7 +86,6 @@ static inline void clocksource_freq_chan
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
- * @update_callback:	called when safe to alter clocksource values
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
@@ -100,7 +99,6 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
-	int (*update_callback)(void);
 	unsigned long flags;
 	cycle_t (*vread)(void);
 
Index: linux-2.6.19/include/linux/timekeeping.h
===================================================================
--- linux-2.6.19.orig/include/linux/timekeeping.h
+++ linux-2.6.19/include/linux/timekeeping.h
@@ -10,6 +10,7 @@ static inline int change_clocksource(voi
 }
 
 static inline void change_clocksource(void) { }
+static inline void timekeeping_init_notifier(void) { }
 
 #endif /* !CONFIG_GENERIC_TIME */
 
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.19.orig/kernel/time/timekeeping.c
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -39,6 +39,7 @@ static unsigned long timekeeping_suspend
  * Clock used for timekeeping
  */
 struct clocksource *clock = &clocksource_jiffies;
+atomic_t clock_recalc_interval = ATOMIC_INIT(0);
 
 #ifdef CONFIG_GENERIC_TIME
 /**
@@ -176,8 +177,9 @@ static int change_clocksource(void)
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 		       clock->name);
 		return 1;
-	} else if (clock->update_callback) {
-		return clock->update_callback();
+	} else if (unlikely(atomic_read(&clock_recalc_interval))) {
+		atomic_set(&clock_recalc_interval, 0);
+		return 1;
 	}
 	return 0;
 }
@@ -199,6 +201,29 @@ int timekeeping_is_continuous(void)
 
 	return ret;
 }
+
+static int
+clocksource_callback(struct notifier_block *nb, unsigned long op, void *c)
+{
+	if (c == clock && op == CLOCKSOURCE_NOTIFY_FREQ &&
+	    !atomic_read(&clock_recalc_interval))
+		atomic_inc(&clock_recalc_interval);
+
+	return 0;
+}
+
+static struct notifier_block clocksource_nb = {
+	.notifier_call = clocksource_callback,
+};
+
+void __init timekeeping_init_notifier(void)
+{
+	/*
+	 * Needs to be done early, incase a clock is unstable
+	 * early.
+	 */
+	clocksource_notifier_register(&clocksource_nb);
+}
 #endif /* CONFIG_GENERIC_TIME */
 
 /**
@@ -237,6 +262,9 @@ void __init timekeeping_init(void)
 		-xtime.tv_sec, -xtime.tv_nsec);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	timekeeping_init_notifier();
+
 }
 
 

-- 
