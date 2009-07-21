Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZGUTVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZGUTVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZGUTVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:03 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46766 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbZGUTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:20:59 -0400
Message-Id: <20090721192057.177653956@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 21 Jul 2009 21:17:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 1/5] move clock source related code to clocksource.c
Content-Disposition: inline; filename=clocksource-move.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Move clock source related code from timekeeping.c to clocksource.c
where they belong. The selected clocks source "clock" is now defined
in clocksource.c and clocksource_init is added to set up the initial
clock.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |   44 ++-------
 kernel/time/clocksource.c   |  199 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c   |  161 -----------------------------------
 3 files changed, 211 insertions(+), 193 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/cache.h>
 #include <linux/timer.h>
+#include <linux/init.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -329,46 +330,23 @@ static inline s64 cyc2ns(struct clocksou
 	return ret;
 }
 
-/**
- * clocksource_calculate_interval - Calculates a clocksource interval struct
- *
- * @c:		Pointer to clocksource.
- * @length_nsec: Desired interval length in nanoseconds.
- *
- * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
- * pair and interval request.
- *
- * Unless you're the timekeeping code, you should not be using this!
- */
-static inline void clocksource_calculate_interval(struct clocksource *c,
-					  	  unsigned long length_nsec)
-{
-	u64 tmp;
-
-	/* Do the ns -> cycle conversion first, using original mult */
-	tmp = length_nsec;
-	tmp <<= c->shift;
-	tmp += c->mult_orig/2;
-	do_div(tmp, c->mult_orig);
-
-	c->cycle_interval = (cycle_t)tmp;
-	if (c->cycle_interval == 0)
-		c->cycle_interval = 1;
-
-	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
-	c->xtime_interval = (u64)c->cycle_interval * c->mult;
-	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) >> c->shift;
-}
-
-
 /* used to install a new clocksource */
+extern void __init clocksource_init(void);
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
-extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_adjust(s64 offset);
 extern void clocksource_resume(void);
 
+#ifdef CONFIG_GENERIC_TIME
+extern void clocksource_forward_now(void);
+extern void change_clocksource(void);
+#else
+static inline void clocksource_forward_now(void) { }
+static inline void change_clocksource(void) { }
+#endif
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -110,6 +110,9 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
 
+/* Currently selected clock source. */
+struct clocksource *clock;
+
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource. Initialized to clocksource_jiffies.
@@ -392,6 +395,191 @@ static int clocksource_enqueue(struct cl
 }
 
 /**
+ * clocksource_calculate_interval - Calculates a clocksource interval struct
+ *
+ * @c:		Pointer to clocksource.
+ * @length_nsec: Desired interval length in nanoseconds.
+ *
+ * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
+ * pair and interval request.
+ *
+ * Unless you're the timekeeping code, you should not be using this!
+ */
+static void clocksource_calculate_interval(struct clocksource *c,
+					   unsigned long length_nsec)
+{
+	u64 tmp;
+
+	/* Do the ns -> cycle conversion first, using original mult */
+	tmp = length_nsec;
+	tmp <<= c->shift;
+	tmp += c->mult_orig/2;
+	do_div(tmp, c->mult_orig);
+
+	c->cycle_interval = (cycle_t)tmp;
+	if (c->cycle_interval == 0)
+		c->cycle_interval = 1;
+
+	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
+	c->xtime_interval = (u64)c->cycle_interval * c->mult;
+	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) >> c->shift;
+}
+
+/*
+ * If the error is already larger, we look ahead even further
+ * to compensate for late or lost adjustments.
+ */
+static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+						 s64 *offset)
+{
+	s64 tick_error, i;
+	u32 look_ahead, adj;
+	s32 error2, mult;
+
+	/*
+	 * Use the current error value to determine how much to look ahead.
+	 * The larger the error the slower we adjust for it to avoid problems
+	 * with losing too many ticks, otherwise we would overadjust and
+	 * produce an even larger error.  The smaller the adjustment the
+	 * faster we try to adjust for it, as lost ticks can do less harm
+	 * here.  This is tuned so that an error of about 1 msec is adjusted
+	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
+	 */
+	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = abs(error2);
+	for (look_ahead = 0; error2 > 0; look_ahead++)
+		error2 >>= 2;
+
+	/*
+	 * Now calculate the error in (1 << look_ahead) ticks, but first
+	 * remove the single look ahead already included in the error.
+	 */
+	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
+	tick_error -= clock->xtime_interval >> 1;
+	error = ((error - tick_error) >> look_ahead) + tick_error;
+
+	/* Finally calculate the adjustment shift value.  */
+	i = *interval;
+	mult = 1;
+	if (error < 0) {
+		error = -error;
+		*interval = -*interval;
+		*offset = -*offset;
+		mult = -1;
+	}
+	for (adj = 0; error > i; adj++)
+		error >>= 1;
+
+	*interval <<= adj;
+	*offset <<= adj;
+	return mult << adj;
+}
+
+/*
+ * Adjust the multiplier to reduce the error value,
+ * this is optimized for the most common adjustments of -1,0,1,
+ * for other values we can do a bit more work.
+ */
+void clocksource_adjust(s64 offset)
+{
+	s64 error, interval = clock->cycle_interval;
+	int adj;
+
+	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
+	if (error > interval) {
+		error >>= 2;
+		if (likely(error <= interval))
+			adj = 1;
+		else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else if (error < -interval) {
+		error >>= 2;
+		if (likely(error >= -interval)) {
+			adj = -1;
+			interval = -interval;
+			offset = -offset;
+		} else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else
+		return;
+
+	clock->mult += adj;
+	clock->xtime_interval += interval;
+	clock->xtime_nsec -= offset;
+	clock->error -= (interval - offset) <<
+			(NTP_SCALE_SHIFT - clock->shift);
+}
+
+#ifdef CONFIG_GENERIC_TIME
+/**
+ * clocksource_forward_now - update clock to the current time
+ *
+ * Forward the current clock to update its state since the last call to
+ * update_wall_time(). This is useful before significant clock changes,
+ * as it avoids having to deal with this time offset explicitly.
+ */
+void clocksource_forward_now(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	s64 nsec;
+
+	cycle_now = clocksource_read(clock);
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	clock->cycle_last = cycle_now;
+
+	nsec = cyc2ns(clock, cycle_delta);
+
+	/* If arch requires, add in gettimeoffset() */
+	nsec += arch_gettimeoffset();
+
+	timespec_add_ns(&xtime, nsec);
+
+	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
+	clock->raw_time.tv_nsec += nsec;
+}
+
+/**
+ * change_clocksource - Swaps clocksources if a new one is available
+ *
+ * Accumulates current time interval and initializes new clocksource
+ */
+void change_clocksource(void)
+{
+	struct clocksource *new, *old;
+
+	new = clocksource_get_next();
+
+	if (clock == new)
+		return;
+
+	clocksource_forward_now();
+
+	if (clocksource_enable(new))
+		return;
+
+	new->raw_time = clock->raw_time;
+	old = clock;
+	clock = new;
+	clocksource_disable(old);
+
+	clock->cycle_last = 0;
+	clock->cycle_last = clocksource_read(clock);
+	clock->error = 0;
+	clock->xtime_nsec = 0;
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+
+	tick_clock_notify();
+
+	/*
+	 * We're holding xtime lock and waking up klogd would deadlock
+	 * us on enqueue.  So no printing!
+	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+	       clock->name);
+	 */
+}
+#endif
+
+/**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
@@ -444,6 +632,17 @@ void clocksource_unregister(struct clock
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
+/**
+ * clocksource_init - set up initial clock source
+ */
+void __init clocksource_init(void)
+{
+	clock = clocksource_get_next();
+	clocksource_enable(clock);
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	clock->cycle_last = clock->read(clock);
+}
+
 #ifdef CONFIG_SYSFS
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -56,38 +56,9 @@ void update_xtime_cache(u64 nsec)
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-struct clocksource *clock;
-
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * clocksource_forward_now - update clock to the current time
- *
- * Forward the current clock to update its state since the last call to
- * update_wall_time(). This is useful before significant clock changes,
- * as it avoids having to deal with this time offset explicitly.
- */
-static void clocksource_forward_now(void)
-{
-	cycle_t cycle_now, cycle_delta;
-	s64 nsec;
-
-	cycle_now = clocksource_read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
-
-	nsec = cyc2ns(clock, cycle_delta);
-
-	/* If arch requires, add in gettimeoffset() */
-	nsec += arch_gettimeoffset();
-
-	timespec_add_ns(&xtime, nsec);
-
-	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-	clock->raw_time.tv_nsec += nsec;
-}
-
-/**
  * getnstimeofday - Returns the time of day in a timespec
  * @ts:		pointer to the timespec to be set
  *
@@ -251,48 +222,7 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
-/**
- * change_clocksource - Swaps clocksources if a new one is available
- *
- * Accumulates current time interval and initializes new clocksource
- */
-static void change_clocksource(void)
-{
-	struct clocksource *new, *old;
-
-	new = clocksource_get_next();
-
-	if (clock == new)
-		return;
-
-	clocksource_forward_now();
-
-	if (clocksource_enable(new))
-		return;
-
-	new->raw_time = clock->raw_time;
-	old = clock;
-	clock = new;
-	clocksource_disable(old);
-
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-
-	tick_clock_notify();
-
-	/*
-	 * We're holding xtime lock and waking up klogd would deadlock
-	 * us on enqueue.  So no printing!
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-	 */
-}
 #else /* GENERIC_TIME */
-static inline void clocksource_forward_now(void) { }
-static inline void change_clocksource(void) { }
 
 /**
  * ktime_get - get the monotonic time in ktime_t format
@@ -426,11 +356,7 @@ void __init timekeeping_init(void)
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	ntp_init();
-
-	clock = clocksource_get_next();
-	clocksource_enable(clock);
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
+	clocksource_init();
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
@@ -524,91 +450,6 @@ static int __init timekeeping_init_devic
 
 device_initcall(timekeeping_init_device);
 
-/*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
- */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
-						 s64 *offset)
-{
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
-
-	/*
-	 * Use the current error value to determine how much to look ahead.
-	 * The larger the error the slower we adjust for it to avoid problems
-	 * with losing too many ticks, otherwise we would overadjust and
-	 * produce an even larger error.  The smaller the adjustment the
-	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adjusted
-	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-	 */
-	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
-	error2 = abs(error2);
-	for (look_ahead = 0; error2 > 0; look_ahead++)
-		error2 >>= 2;
-
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
-
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
-	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
-
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void clocksource_adjust(s64 offset)
-{
-	s64 error, interval = clock->cycle_interval;
-	int adj;
-
-	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
-	if (error > interval) {
-		error >>= 2;
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else if (error < -interval) {
-		error >>= 2;
-		if (likely(error >= -interval)) {
-			adj = -1;
-			interval = -interval;
-			offset = -offset;
-		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else
-		return;
-
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - clock->shift);
-}
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

