Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZE0Oth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZE0Oth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZE0Ot2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:49:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39842 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbZE0Ot1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:49:27 -0400
Message-ID: <4A1D52E3.3040204@ti.com>
Date: Wed, 27 May 2009 09:49:07 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during idle
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The dynamic tick allows the kernel to sleep for periods longer than a 
single tick. This patch prevents that the kernel from sleeping for a 
period longer than the maximum time that the current clocksource can 
count. This ensures that the kernel will not lose track of time. This 
patch adds a new function called "timekeeping_max_deferment()" that 
calculates the maximum time the kernel can sleep for a given clocksource.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  include/linux/time.h      |    1 +
  kernel/time/tick-sched.c  |   36 +++++++++++++++++++++++----------
  kernel/time/timekeeping.c |   47 
+++++++++++++++++++++++++++++++++++++++++++++
  3 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 242f624..090be07 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -130,6 +130,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);

  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
  extern int timekeeping_valid_for_hres(void);
+extern s64 timekeeping_max_deferment(void);
  extern void update_wall_time(void);
  extern void update_xtime_cache(u64 nsec);

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..f0155ae 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -217,6 +217,7 @@ void tick_nohz_stop_sched_tick(int inidle)
  	ktime_t last_update, expires, now;
  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
  	int cpu;
+	s64 time_delta, max_time_delta;

  	local_irq_save(flags);

@@ -264,6 +265,7 @@ void tick_nohz_stop_sched_tick(int inidle)
  		seq = read_seqbegin(&xtime_lock);
  		last_update = last_jiffies_update;
  		last_jiffies = jiffies;
+		max_time_delta = timekeeping_max_deferment();
  	} while (read_seqretry(&xtime_lock, seq));

  	/* Get the next timer wheel timer */
@@ -283,11 +285,22 @@ void tick_nohz_stop_sched_tick(int inidle)
  	if ((long)delta_jiffies >= 1) {

  		/*
-		* calculate the expiry time for the next timer wheel
-		* timer
-		*/
-		expires = ktime_add_ns(last_update, tick_period.tv64 *
-				   delta_jiffies);
+		 * Calculate the time delta for the next timer event.
+		 * If the time delta exceeds the maximum time delta
+		 * permitted by the current clocksource then adjust
+		 * the time delta accordingly to ensure the
+		 * clocksource does not wrap.
+		 */
+		time_delta = tick_period.tv64 * delta_jiffies;
+
+		if (time_delta > max_time_delta)
+			time_delta = max_time_delta;
+
+		/*
+		 * calculate the expiry time for the next timer wheel
+		 * timer
+		 */
+		expires = ktime_add_ns(last_update, time_delta);

  		/*
  		 * If this cpu is the one which updates jiffies, then
@@ -300,7 +313,7 @@ void tick_nohz_stop_sched_tick(int inidle)
  		if (cpu == tick_do_timer_cpu)
  			tick_do_timer_cpu = TICK_DO_TIMER_NONE;

-		if (delta_jiffies > 1)
+		if (time_delta > tick_period.tv64)
  			cpumask_set_cpu(cpu, nohz_cpu_mask);

  		/* Skip reprogram of event if its not changed */
@@ -332,12 +345,13 @@ void tick_nohz_stop_sched_tick(int inidle)
  		ts->idle_sleeps++;

  		/*
-		 * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
-		 * there is no timer pending or at least extremly far
-		 * into the future (12 days for HZ=1000). In this case
-		 * we simply stop the tick timer:
+		 * time_delta >= (tick_period.tv64 * NEXT_TIMER_MAX_DELTA)
+		 * signals that there is no timer pending or at least
+		 * extremely far into the future (12 days for HZ=1000).
+		 * In this case we simply stop the tick timer:
  		 */
-		if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
+		if (unlikely(time_delta >=
+				(tick_period.tv64 * NEXT_TIMER_MAX_DELTA))) {
  			ts->idle_expires.tv64 = KTIME_MAX;
  			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
  				hrtimer_cancel(&ts->sched_timer);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 687dff4..608fc6f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -271,6 +271,53 @@ int timekeeping_valid_for_hres(void)
  }

  /**
+ * timekeeping_max_deferment - Returns max time the clocksource can be 
deferred
+ *
+ * IMPORTANT: Must be called with xtime_lock held!
+ */
+s64 timekeeping_max_deferment(void)
+{
+	s64 max_nsecs;
+	u64 max_cycles;
+
+	/*
+	 * Calculate the maximum number of cycles that we can pass to the
+	 * cyc2ns function without overflowing a 64-bit signed result. The
+	 * maximum number of cycles is equal to ULLONG_MAX/clock->mult which
+	 * is equivalent to the below.
+	 * max_cycles < (2^63)/clock->mult
+	 * max_cycles < 2^(log2((2^63)/clock->mult))
+	 * max_cycles < 2^(log2(2^63) - log2(clock->mult))
+	 * max_cycles < 2^(63 - log2(clock->mult))
+	 * max_cycles < 1 << (63 - log2(clock->mult))
+	 * Please note that we add 1 to the result of the log2 to account for
+	 * any rounding errors, ensure the above inequality is satisfied and
+	 * no overflow will occur.
+	 */
+	max_cycles = 1ULL << (63 - (ilog2(clock->mult) + 1));
+
+	/*
+	 * The actual maximum number of cycles we can defer the clocksource is
+	 * determined by the minimum of max_cycles and clock->mask.
+	 */
+	max_cycles = min(max_cycles, clock->mask);
+	max_nsecs = cyc2ns(clock, max_cycles);
+
+	/*
+	 * To ensure that the clocksource does not wrap whilst we are idle,
+	 * limit the time the clocksource can be deferred by 6.25%. Please
+	 * note a margin of 6.25% is used because this can be computed with
+	 * a shift, versus say 5% which would require division.
+	 */
+	max_nsecs = max_nsecs - (max_nsecs >> 4);
+
+	if (max_nsecs < 0)
+		max_nsecs = 0;
+
+	return max_nsecs;
+}
+
+/**
   * read_persistent_clock -  Return time in seconds from the persistent 
clock.
   *
   * Weak dummy function for arches that do not yet support it.
-- 
1.6.1
