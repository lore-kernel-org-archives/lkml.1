Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZG2Nmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZG2Nmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZG2Nmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:42:36 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:32997 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbZG2Nme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:34 -0400
Message-Id: <20090729134230.972384347@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 08/12] introduce struct timekeeper
Content-Disposition: inline; filename=timekeeper-struct.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add struct timekeeper to keep the internal values timekeeping.c needs
in regard to the currently selected clock source. This moves the
timekeeping intervals, xtime_nsec and the ntp error value from
struct clocksource to struct timekeeper. The raw_time is removed from
the clocksource as well. It gets treated like xtime as a global variable.
Eventually xtime raw_time should be moved to struct timekeeper.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/time.c     |    1 
 include/linux/clocksource.h |   54 ----------
 kernel/time/clocksource.c   |    6 -
 kernel/time/timekeeping.c   |  223 ++++++++++++++++++++++++++++----------------
 4 files changed, 152 insertions(+), 132 deletions(-)

Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -280,7 +280,6 @@ void __init time_init(void)
 	now = get_clock();
 	tod_to_timeval(now - TOD_UNIX_EPOCH, &xtime);
 	clocksource_tod.cycle_last = now;
-	clocksource_tod.raw_time = xtime;
 	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &ts);
 	set_normalized_timespec(&wall_to_monotonic, -ts.tv_sec, -ts.tv_nsec);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -155,8 +155,6 @@ extern u64 timecounter_cyc2time(struct t
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @resume:		resume function for the clocksource, if necessary
- * @cycle_interval:	Used internally by timekeeping core, please ignore.
- * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
 struct clocksource {
 	/*
@@ -182,19 +180,12 @@ struct clocksource {
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
 
-	/* timekeeping specific data, ignore */
-	cycle_t cycle_interval;
-	u64	xtime_interval;
-	u32	raw_interval;
 	/*
 	 * Second part is written at each timer interrupt
 	 * Keep it in a different cache line to dirty no
 	 * more than one cache line.
 	 */
 	cycle_t cycle_last ____cacheline_aligned_in_smp;
-	u64 xtime_nsec;
-	s64 error;
-	struct timespec raw_time;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -203,8 +194,6 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
-
 /*
  * Clock source flags bits::
  */
@@ -270,50 +259,15 @@ static inline u32 clocksource_hz2mult(u3
 }
 
 /**
- * cyc2ns - converts clocksource cycles to nanoseconds
- * @cs:		Pointer to clocksource
- * @cycles:	Cycles
+ * clocksource_cyc2ns - converts clocksource cycles to nanoseconds
  *
- * Uses the clocksource and ntp ajdustment to convert cycle_ts to nanoseconds.
+ * Converts cycles to nanoseconds, using the given mult and shift.
  *
  * XXX - This could use some mult_lxl_ll() asm optimization
  */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
-{
-	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
-	return ret;
-}
-
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
+static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
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
+	return ((u64) cycles * mult) >> shift;
 }
 
 
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -177,7 +177,8 @@ static void clocksource_watchdog(unsigne
 		goto out;
 
 	wdnow = watchdog->read(watchdog);
-	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
+	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
+				     watchdog->mult, watchdog->shift);
 	watchdog_last = wdnow;
 
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
@@ -196,7 +197,8 @@ static void clocksource_watchdog(unsigne
 		}
 
 		/* Check the deviation from the watchdog clocksource. */
-		cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
+		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
+					     cs->mask, cs->mult, cs->shift);
 		cs->wd_last = csnow;
 		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -19,6 +19,56 @@
 #include <linux/time.h>
 #include <linux/tick.h>
 
+/* Structure holding internal timekeeping values. */
+struct timekeeper {
+	struct clocksource *clock;
+	cycle_t cycle_interval;
+	u64	xtime_interval;
+	u32	raw_interval;
+	u64	xtime_nsec;
+	s64	ntp_error;
+};
+
+struct timekeeper timekeeper;
+
+/**
+ * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ *
+ * @clock:		Pointer to clocksource.
+ *
+ * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
+ * pair and interval request.
+ *
+ * Unless you're the timekeeping code, you should not be using this!
+ */
+static void timekeeper_setup_internals(struct clocksource *clock)
+{
+	cycle_t interval;
+	u64 tmp;
+
+	timekeeper.clock = clock;
+	clock->cycle_last = clock->read(clock);
+
+	/* Do the ns -> cycle conversion first, using original mult */
+	tmp = NTP_INTERVAL_LENGTH;
+	tmp <<= clock->shift;
+	tmp += clock->mult_orig/2;
+	do_div(tmp, clock->mult_orig);
+	if (tmp == 0)
+		tmp = 1;
+
+	interval = (cycle_t) tmp;
+	timekeeper.cycle_interval = interval;
+
+	/* Go back from cycles -> shifted ns */
+	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.raw_interval =
+		((u64) interval * clock->mult_orig) >> clock->shift;
+
+	timekeeper.xtime_nsec = 0;
+
+	timekeeper.ntp_error = 0;
+}
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -46,6 +96,11 @@ struct timespec xtime __attribute__ ((al
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/*
+ * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
+ */
+struct timespec raw_time;
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -56,42 +111,42 @@ void update_xtime_cache(u64 nsec)
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-struct clocksource *clock;
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock);
 }
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * clocksource_forward_now - update clock to the current time
+ * timekeeping_forward_now - update clock to the current time
  *
  * Forward the current clock to update its state since the last call to
  * update_wall_time(). This is useful before significant clock changes,
  * as it avoids having to deal with this time offset explicitly.
  */
-static void clocksource_forward_now(void)
+static void timekeeping_forward_now(void)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	s64 nsec;
 
+	clock = timekeeper.clock;
 	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	nsec = cyc2ns(clock, cycle_delta);
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 
 	/* If arch requires, add in gettimeoffset() */
 	nsec += arch_gettimeoffset();
 
 	timespec_add_ns(&xtime, nsec);
 
-	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-	clock->raw_time.tv_nsec += nsec;
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult_orig, clock->shift);
+	timespec_add_ns(&raw_time, nsec);
 }
 
 /**
@@ -103,6 +158,7 @@ static void clocksource_forward_now(void
 void getnstimeofday(struct timespec *ts)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -114,13 +170,15 @@ void getnstimeofday(struct timespec *ts)
 		*ts = xtime;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
+		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
+					   clock->shift);
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -135,6 +193,7 @@ EXPORT_SYMBOL(getnstimeofday);
 ktime_t ktime_get(void)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	unsigned int seq;
 	s64 secs, nsecs;
 
@@ -146,13 +205,15 @@ ktime_t ktime_get(void)
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs += cyc2ns(clock, cycle_delta);
+		nsecs += clocksource_cyc2ns(cycle_delta, clock->mult,
+					    clock->shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -174,6 +235,7 @@ EXPORT_SYMBOL_GPL(ktime_get);
 void ktime_get_ts(struct timespec *ts)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	struct timespec tomono;
 	unsigned int seq;
 	s64 nsecs;
@@ -186,13 +248,15 @@ void ktime_get_ts(struct timespec *ts)
 		tomono = wall_to_monotonic;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
+		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
+					   clock->shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -233,7 +297,7 @@ int do_settimeofday(struct timespec *tv)
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	clocksource_forward_now();
+	timekeeping_forward_now();
 
 	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
@@ -243,10 +307,10 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	clock->error = 0;
+	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -269,38 +333,25 @@ static void change_clocksource(void)
 
 	new = clocksource_get_next();
 
-	if (!new || clock == new)
+	if (!new || timekeeper.clock == new)
 		return;
 
-	clocksource_forward_now();
+	timekeeping_forward_now();
 
 	if (new->enable && ! new->enable(new))
 		return;
 	/* save mult_orig on enable */
 	new->mult_orig = new->mult;
 
-	new->raw_time = clock->raw_time;
-	old = clock;
-	clock = new;
+	old = timekeeper.clock;
+	timekeeper_setup_internals(new);
 	if (old->disable)
 		old->disable(old);
 
-	clock->cycle_last = clock->read(clock);
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-
 	tick_clock_notify();
-
-	/*
-	 * We're holding xtime lock and waking up klogd would deadlock
-	 * us on enqueue.  So no printing!
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-	 */
 }
 #else /* GENERIC_TIME */
-static inline void clocksource_forward_now(void) { }
+static inline void timekeeping_forward_now(void) { }
 static inline void change_clocksource(void) { }
 
 /**
@@ -370,20 +421,23 @@ void getrawmonotonic(struct timespec *ts
 	unsigned long seq;
 	s64 nsecs;
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
+		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult_orig,
+					   clock->shift);
 
-		*ts = clock->raw_time;
+		*ts = raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -403,7 +457,7 @@ int timekeeping_valid_for_hres(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -429,6 +483,7 @@ unsigned long __attribute__((weak)) read
  */
 void __init timekeeping_init(void)
 {
+	struct clocksource *clock;
 	unsigned long flags;
 	unsigned long sec = read_persistent_clock();
 
@@ -441,11 +496,13 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	/* save mult_orig on enable */
 	clock->mult_orig = clock->mult;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clock->read(clock);
+
+	timekeeper_setup_internals(clock);
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
+	raw_time.tv_sec = 0;
+	raw_time.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
 	update_xtime_cache(0);
@@ -482,8 +539,8 @@ static int timekeeping_resume(struct sys
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = clock->read(clock);
-	clock->error = 0;
+	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -504,7 +561,7 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	clocksource_forward_now();
+	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -539,7 +596,7 @@ device_initcall(timekeeping_init_device)
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -555,7 +612,7 @@ static __always_inline int clocksource_b
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -564,8 +621,9 @@ static __always_inline int clocksource_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
+	tick_error = tick_length >>
+			(NTP_SCALE_SHIFT - timekeeper.clock->shift + 1);
+	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -590,18 +648,19 @@ static __always_inline int clocksource_b
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(s64 offset)
+static void timekeeping_adjust(s64 offset)
 {
-	s64 error, interval = clock->cycle_interval;
+	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
+	error = timekeeper.ntp_error >>
+		(NTP_SCALE_SHIFT - timekeeper.clock->shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
 		error >>= 2;
 		if (likely(error >= -interval)) {
@@ -609,15 +668,15 @@ static void clocksource_adjust(s64 offse
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else
 		return;
 
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - clock->shift);
+	timekeeper.clock->mult += adj;
+	timekeeper.xtime_interval += interval;
+	timekeeper.xtime_nsec -= offset;
+	timekeeper.ntp_error -= (interval - offset) <<
+			(NTP_SCALE_SHIFT - timekeeper.clock->shift);
 }
 
 /**
@@ -627,53 +686,57 @@ static void clocksource_adjust(s64 offse
  */
 void update_wall_time(void)
 {
+	struct clocksource *clock;
 	cycle_t offset;
+	s64 nsecs;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	clock = timekeeper.clock;
 #ifdef CONFIG_GENERIC_TIME
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
-	offset = clock->cycle_interval;
+	offset = timekeeper.cycle_interval;
 #endif
-	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
-	while (offset >= clock->cycle_interval) {
+	while (offset >= timekeeper.cycle_interval) {
 		/* accumulate one interval */
-		offset -= clock->cycle_interval;
-		clock->cycle_last += clock->cycle_interval;
+		offset -= timekeeper.cycle_interval;
+		clock->cycle_last += timekeeper.cycle_interval;
 
-		clock->xtime_nsec += clock->xtime_interval;
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+		timekeeper.xtime_nsec += timekeeper.xtime_interval;
+		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
+			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
 			second_overflow();
 		}
 
-		clock->raw_time.tv_nsec += clock->raw_interval;
-		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
-			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
-			clock->raw_time.tv_sec++;
+		raw_time.tv_nsec += timekeeper.raw_interval;
+		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
+			raw_time.tv_nsec -= NSEC_PER_SEC;
+			raw_time.tv_sec++;
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		timekeeper.ntp_error += tick_length;
+		timekeeper.ntp_error -= timekeeper.xtime_interval <<
+					(NTP_SCALE_SHIFT - clock->shift);
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(offset);
+	timekeeping_adjust(offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
 	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
 	 * xtime_nsec to be fairly small after the loop. Further, if we're
-	 * slightly speeding the clocksource up in clocksource_adjust(),
+	 * slightly speeding the clocksource up in timekeeping_adjust(),
 	 * its possible the required corrective factor to xtime_nsec could
 	 * cause it to underflow.
 	 *
@@ -685,24 +748,26 @@ void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)clock->xtime_nsec < 0)) {
-		s64 neg = -(s64)clock->xtime_nsec;
-		clock->xtime_nsec = 0;
-		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
+	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
+		s64 neg = -(s64)timekeeper.xtime_nsec;
+		timekeeper.xtime_nsec = 0;
+		timekeeper.ntp_error += neg << (NTP_SCALE_SHIFT - clock->shift);
 	}
 
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
+	xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >> clock->shift) + 1;
+	timekeeper.xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.ntp_error += timekeeper.xtime_nsec <<
+				(NTP_SCALE_SHIFT - clock->shift);
 
-	update_xtime_cache(cyc2ns(clock, offset));
+	nsecs = clocksource_cyc2ns(offset, clock->mult, clock->shift);
+	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock);
 }
 
 /**

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

