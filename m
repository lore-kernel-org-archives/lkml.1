Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbXAaDvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbXAaDvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXAaDvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:51:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1827 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932695AbXAaDvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:51:37 -0500
Message-Id: <20070131033803.631812018@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:12 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 02/23] clocksource: drop clocksource-add-verification-watchdog-helper.patch
Content-Disposition: inline; filename=drop-clocksource-add-verification-watchdog-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/Kconfig           |    4 -
 arch/i386/kernel/tsc.c      |   49 +++++++++++++++++
 include/linux/clocksource.h |   15 -----
 kernel/time/clocksource.c   |  125 +-------------------------------------------
 kernel/timer.c              |   48 ++++++++--------
 5 files changed, 79 insertions(+), 162 deletions(-)

Index: linux-2.6.19/arch/i386/Kconfig
===================================================================
--- linux-2.6.19.orig/arch/i386/Kconfig
+++ linux-2.6.19/arch/i386/Kconfig
@@ -18,10 +18,6 @@ config GENERIC_TIME
 	bool
 	default y
 
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -344,6 +344,49 @@ static struct dmi_system_id __initdata b
 	 {}
 };
 
+#define TSC_FREQ_CHECK_INTERVAL (10*MSEC_PER_SEC) /* 10sec in MS */
+static struct timer_list verify_tsc_freq_timer;
+
+/* XXX - Probably should add locking */
+static void verify_tsc_freq(unsigned long unused)
+{
+	static u64 last_tsc;
+	static unsigned long last_jiffies;
+
+	u64 now_tsc, interval_tsc;
+	unsigned long now_jiffies, interval_jiffies;
+
+
+	if (check_tsc_unstable())
+		return;
+
+	rdtscll(now_tsc);
+	now_jiffies = jiffies;
+
+	if (!last_jiffies) {
+		goto out;
+	}
+
+	interval_jiffies = now_jiffies - last_jiffies;
+	interval_tsc = now_tsc - last_tsc;
+	interval_tsc *= HZ;
+	do_div(interval_tsc, cpu_khz*1000);
+
+	if (interval_tsc < (interval_jiffies * 3 / 4)) {
+		printk("TSC appears to be running slowly. "
+			"Marking it as unstable\n");
+		mark_tsc_unstable();
+		return;
+	}
+
+out:
+	last_tsc = now_tsc;
+	last_jiffies = now_jiffies;
+	/* set us up to go off on the next interval: */
+	mod_timer(&verify_tsc_freq_timer,
+		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
+}
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -401,6 +444,12 @@ static int __init init_tsc_clocksource(v
 			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 		}
 
+		init_timer(&verify_tsc_freq_timer);
+		verify_tsc_freq_timer.function = verify_tsc_freq;
+		verify_tsc_freq_timer.expires =
+			jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL);
+		add_timer(&verify_tsc_freq_timer);
+
 		return clocksource_register(&clocksource_tsc);
 	}
 
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -12,13 +12,11 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/list.h>
-#include <linux/timer.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
 /* clocksource cycle base type */
 typedef u64 cycle_t;
-struct clocksource;
 
 /**
  * struct clocksource - hardware abstraction for a free running counter
@@ -66,22 +64,13 @@ struct clocksource {
 	cycle_t cycle_last, cycle_interval;
 	u64 xtime_nsec, xtime_interval;
 	s64 error;
-
-#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
-	/* Watchdog related data, used by the framework */
-	struct list_head wd_list;
-	cycle_t wd_last;
-#endif
 };
 
 /*
  * Clock source flags bits::
  */
-#define CLOCK_SOURCE_IS_CONTINUOUS		0x01
-#define CLOCK_SOURCE_MUST_VERIFY		0x02
-
-#define CLOCK_SOURCE_WATCHDOG			0x10
-#define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_IS_CONTINUOUS	0x01
+#define CLOCK_SOURCE_MUST_VERIFY	0x02
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -62,114 +62,8 @@ static int __init clocksource_done_booti
 	finished_booting = 1;
 	return 0;
 }
-late_initcall(clocksource_done_booting);
-
-#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
-static LIST_HEAD(watchdog_list);
-static struct clocksource *watchdog;
-static struct timer_list watchdog_timer;
-static DEFINE_SPINLOCK(watchdog_lock);
-static cycle_t watchdog_last;
-/*
- * Interval: 0.5sec Treshold: 0.0625s
- */
-#define WATCHDOG_INTERVAL (HZ >> 1)
-#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
-
-static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
-{
-	if (delta > -WATCHDOG_TRESHOLD && delta < WATCHDOG_TRESHOLD)
-		return;
-
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
-	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
-	clocksource_change_rating(cs, 0);
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-	list_del(&cs->wd_list);
-}
-
-static void clocksource_watchdog(unsigned long data)
-{
-	struct clocksource *cs, *tmp;
-	cycle_t csnow, wdnow;
-	int64_t wd_nsec, cs_nsec;
-
-	spin_lock(&watchdog_lock);
-
-	wdnow = watchdog->read();
-	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
-	watchdog_last = wdnow;
-
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
-		csnow = cs->read();
-		/* Initialized ? */
-		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
-			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
-			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS))
-				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-			cs->flags |= CLOCK_SOURCE_WATCHDOG;
-			cs->wd_last = csnow;
-		} else {
-			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
-			cs->wd_last = csnow;
-			/* Check the delta. Might remove from the list ! */
-			clocksource_ratewd(cs, cs_nsec - wd_nsec);
-		}
-	}
-
-	if (!list_empty(&watchdog_list)) {
-		__mod_timer(&watchdog_timer,
-			    watchdog_timer.expires + WATCHDOG_INTERVAL);
-	}
-	spin_unlock(&watchdog_lock);
-}
-static void clocksource_check_watchdog(struct clocksource *cs)
-{
-	struct clocksource *cse;
-	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		int started = !list_empty(&watchdog_list);
-
-		list_add(&cs->wd_list, &watchdog_list);
-		if (!started && watchdog) {
-			watchdog_last = watchdog->read();
-			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer(&watchdog_timer);
-		}
-	} else if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
-			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-
-		if (!watchdog || cs->rating > watchdog->rating) {
-			if (watchdog)
-				del_timer(&watchdog_timer);
-			watchdog = cs;
-			init_timer(&watchdog_timer);
-			watchdog_timer.function = clocksource_watchdog;
-
-			/* Reset watchdog cycles */
-			list_for_each_entry(cse, &watchdog_list, wd_list)
-				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
-			/* Start if list is not empty */
-			if (!list_empty(&watchdog_list)) {
-				watchdog_last = watchdog->read();
-				watchdog_timer.expires =
-					jiffies + WATCHDOG_INTERVAL;
-				add_timer(&watchdog_timer);
-			}
-		}
-	}
-	spin_unlock_irqrestore(&watchdog_lock, flags);
-}
-#else
-static void clocksource_check_watchdog(struct clocksource *cs)
-{
-	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
-		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-}
-#endif
+late_initcall(clocksource_done_booting);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
@@ -199,21 +93,13 @@ struct clocksource *clocksource_get_next
  */
 static struct clocksource *select_clocksource(void)
 {
-	struct clocksource *next;
-
 	if (list_empty(&clocksource_list))
 		return NULL;
 
 	if (clocksource_override)
-		next = clocksource_override;
-	else
-		next = list_entry(clocksource_list.next, struct clocksource,
-				  list);
+		return clocksource_override;
 
-	if (next == curr_clocksource)
-		return NULL;
-
-	return next;
+	return list_entry(clocksource_list.next, struct clocksource, list);
 }
 
 /*
@@ -251,15 +137,13 @@ static int clocksource_enqueue(struct cl
 int clocksource_register(struct clocksource *c)
 {
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
 		next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -274,7 +158,6 @@ void clocksource_change_rating(struct cl
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
-	cs->rating = rating;
 	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
Index: linux-2.6.19/kernel/timer.c
===================================================================
--- linux-2.6.19.orig/kernel/timer.c
+++ linux-2.6.19/kernel/timer.c
@@ -876,35 +876,31 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static void change_clocksource(void)
+static int change_clocksource(void)
 {
 	struct clocksource *new;
 	cycle_t now;
 	u64 nsec;
-
 	new = clocksource_get_next();
-
-	if (clock == new)
-		return;
-
-	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
-	timespec_add_ns(&xtime, nsec);
-
-	clock = new;
-	clock->cycle_last = now;
-
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-
-	tick_clock_notify();
-
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
+	if (clock != new) {
+		now = clocksource_read(new);
+		nsec =  __get_nsec_offset();
+		timespec_add_ns(&xtime, nsec);
+
+		clock = new;
+		clock->cycle_last = now;
+		tick_clock_notify();
+		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+		       clock->name);
+		return 1;
+	}
+	return 0;
 }
 #else
-static inline void change_clocksource(void) { }
+static inline int change_clocksource(void)
+{
+	return 0;
+}
 #endif
 
 /**
@@ -918,7 +914,7 @@ int timekeeping_is_continuous(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = clock->flags & CLOCK_SOURCE_IS_CONTINUOUS;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -1172,7 +1168,11 @@ static void update_wall_time(void)
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
 	/* check to see if there is a new clocksource to use */
-	change_clocksource();
+	if (change_clocksource()) {
+		clock->error = 0;
+		clock->xtime_nsec = 0;
+		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	}
 	update_vsyscall(&xtime, clock);
 }
 

-- 
