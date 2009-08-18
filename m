Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZHRRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZHRRp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbZHRRp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:45:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44175 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbZHRRp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:45:27 -0400
From: Jon Hunter <jon-hunter@ti.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Jon Hunter <jon-hunter@ti.com>
Subject: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during idle
Date: Tue, 18 Aug 2009 12:45:10 -0500
Message-Id: <1250617512-23567-2-git-send-email-jon-hunter@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Hunter <jon-hunter@ti.com>

The dynamic tick allows the kernel to sleep for periods longer
than a single tick. This patch prevents that the kernel from
sleeping for a period longer than the maximum time that the
current clocksource can count. This ensures that the kernel will
not lose track of time. This patch adds a function called
"clocksource_max_deferment()" that calculates the maximum time the
kernel can sleep for a given clocksource and function called
"timekeeping_max_deferment()" that returns maximum time the kernel
can sleep for the current clocksource.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
 include/linux/clocksource.h |    2 +
 include/linux/time.h        |    1 +
 kernel/time/clocksource.c   |   47 +++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c    |   57 ++++++++++++++++++++++++++++++++----------
 kernel/time/timekeeping.c   |   11 ++++++++
 5 files changed, 104 insertions(+), 14 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 9ea40ff..09ed7f1 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -151,6 +151,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
+ * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @resume:		resume function for the clocksource, if necessary
@@ -168,6 +169,7 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
+	s64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
 	void (*resume)(void);
diff --git a/include/linux/time.h b/include/linux/time.h
index f505988..e68a480 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -146,6 +146,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
+extern s64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
 extern void timekeeping_leap_insert(int leapsecond);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02dc22d..7fffe54 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -369,6 +369,50 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
+/**
+ * clocksource_max_deferment - Returns max time the clocksource can be deferred
+ * @cs:         Pointer to clocksource
+ *
+ */
+static s64 clocksource_max_deferment(struct clocksource *cs)
+{
+	s64 max_nsecs;
+	u64 max_cycles;
+
+	/*
+	 * Calculate the maximum number of cycles that we can pass to the
+	 * cyc2ns function without overflowing a 64-bit signed result. The
+	 * maximum number of cycles is equal to ULLONG_MAX/cs->mult which
+	 * is equivalent to the below.
+	 * max_cycles < (2^63)/cs->mult
+	 * max_cycles < 2^(log2((2^63)/cs->mult))
+	 * max_cycles < 2^(log2(2^63) - log2(cs->mult))
+	 * max_cycles < 2^(63 - log2(cs->mult))
+	 * max_cycles < 1 << (63 - log2(cs->mult))
+	 * Please note that we add 1 to the result of the log2 to account for
+	 * any rounding errors, ensure the above inequality is satisfied and
+	 * no overflow will occur.
+	 */
+	max_cycles = 1ULL << (63 - (ilog2(cs->mult) + 1));
+
+	/*
+	 * The actual maximum number of cycles we can defer the clocksource is
+	 * determined by the minimum of max_cycles and cs->mask.
+	 */
+	max_cycles = min(max_cycles, cs->mask);
+	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult, cs->shift);
+
+	/*
+	 * To ensure that the clocksource does not wrap whilst we are idle,
+	 * limit the time the clocksource can be deferred by 12.5%. Please
+	 * note a margin of 12.5% is used because this can be computed with
+	 * a shift, versus say 10% which would require division.
+	 */
+	max_nsecs = max_nsecs - (max_nsecs >> 5);
+
+	return max_nsecs;
+}
+
 #ifdef CONFIG_GENERIC_TIME
 
 static int finished_booting;
@@ -461,6 +505,9 @@ static void clocksource_enqueue(struct clocksource *cs)
  */
 int clocksource_register(struct clocksource *cs)
 {
+	/* calculate max idle time permitted for this clocksource */
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_select();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..7a98e90 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -217,6 +217,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	int cpu;
+	s64 time_delta, max_time_delta;
 
 	local_irq_save(flags);
 
@@ -270,6 +271,18 @@ void tick_nohz_stop_sched_tick(int inidle)
 		seq = read_seqbegin(&xtime_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
+
+		/*
+		 * On SMP we really should only care for the CPU which
+		 * has the do_timer duty assigned. All other CPUs can
+		 * sleep as long as they want.
+		 */
+		if (cpu == tick_do_timer_cpu ||
+				tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+			max_time_delta = timekeeping_max_deferment();
+		else
+			max_time_delta = KTIME_MAX;
+
 	} while (read_seqretry(&xtime_lock, seq));
 
 	/* Get the next timer wheel timer */
@@ -289,11 +302,30 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if ((long)delta_jiffies >= 1) {
 
 		/*
-		* calculate the expiry time for the next timer wheel
-		* timer
-		*/
-		expires = ktime_add_ns(last_update, tick_period.tv64 *
-				   delta_jiffies);
+		 * calculate the expiry time for the next timer wheel
+		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
+		 * that there is no timer pending or at least extremely
+		 * far into the future (12 days for HZ=1000). In this
+		 * case we set the expiry to the end of time.
+		 */
+		if (likely(delta_jiffies < NEXT_TIMER_MAX_DELTA)) {
+
+			/*
+			 * Calculate the time delta for the next timer event.
+			 * If the time delta exceeds the maximum time delta
+			 * permitted by the current clocksource then adjust
+			 * the time delta accordingly to ensure the
+			 * clocksource does not wrap.
+			 */
+			time_delta = tick_period.tv64 * delta_jiffies;
+
+			if (time_delta > max_time_delta)
+				time_delta = max_time_delta;
+
+			expires = ktime_add_ns(last_update, time_delta);
+		} else {
+			expires.tv64 = KTIME_MAX;
+		}
 
 		/*
 		 * If this cpu is the one which updates jiffies, then
@@ -337,22 +369,19 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 		ts->idle_sleeps++;
 
+		/* Mark expires */
+		ts->idle_expires = expires;
+
 		/*
-		 * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
-		 * there is no timer pending or at least extremly far
-		 * into the future (12 days for HZ=1000). In this case
-		 * we simply stop the tick timer:
+		 * If the expiration time == KTIME_MAX, then
+		 * in this case we simply stop the tick timer.
 		 */
-		if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
-			ts->idle_expires.tv64 = KTIME_MAX;
+		 if (unlikely(expires.tv64 == KTIME_MAX)) {
 			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
 				hrtimer_cancel(&ts->sched_timer);
 			goto out;
 		}
 
-		/* Mark expiries */
-		ts->idle_expires = expires;
-
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS_PINNED);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 15e06de..2e57251 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -487,6 +487,17 @@ int timekeeping_valid_for_hres(void)
 }
 
 /**
+ * timekeeping_max_deferment - Returns max time the clocksource can be deferred
+ *
+ * IMPORTANT: Caller must observe xtime_lock via read_seqbegin/read_seqretry
+ * to ensure that the clocksource does not change!
+ */
+s64 timekeeping_max_deferment(void)
+{
+	return timekeeper.clock->max_idle_ns;
+}
+
+/**
  * read_persistent_clock -  Return time from the persistent clock.
  *
  * Weak dummy function for arches that do not yet support it.
-- 
1.6.0.4

