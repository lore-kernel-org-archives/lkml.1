Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZFDT3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZFDT3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZFDT3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:29:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44399 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZFDT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:29:43 -0400
Message-ID: <4A282089.5020103@ti.com>
Date: Thu, 4 Jun 2009 14:29:13 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain> <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain> <4A1EF244.5040108@ti.com> <alpine.LFD.2.00.0905282231500.3397@localhost.localdomain> <4A1EFDBD.8040007@ti.com> <4A208538.3040406@ti.com>
In-Reply-To: <4A208538.3040406@ti.com>
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jon Hunter wrote:
> Jon Hunter wrote:
>> +		 * Calculate the time delta for the next timer event.
>> +		 * If the time delta exceeds the maximum time delta
>> +		 * permitted by the current clocksource then adjust
>> +		 * the time delta accordingly to ensure the
>> +		 * clocksource does not wrap.
>> +		 */
>> +		time_delta = tick_period.tv64 * delta_jiffies;
> 
> Thinking about this more, although it is very unlikely, for 64-bit 
> machines there is a chance that the above multiply could overflow if 
> delta_jiffies is very large.
> 
> tick_period.tv64 should always be less than NSEC_PER_SEC and so you 
> would need delta_jiffies to be greater than 2^32 to cause overflow. On a 
> 32-bit machine an unsigned long will not be greater than 2^32 as it is 
> only 32-bits but this would be possible on a 64-bit machines.
> 
> So to be safe we should make sure that delta_jiffies is not greater than 
>   NEXT_TIMER_MAX_DELTA (2^30 - 1) before doing the multiply. If you 
> think that this is a valid concern, then I can re-work and re-post. 
> Sorry for not catching this before.

With regard to the above, to ensure that there are no overflows with the 
above calculation, I re-worked this patch a little. The below should be 
equivalent to the current code, just re-organised a little. Let me know 
if this would be acceptable or not.

Cheers
Jon

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
  kernel/time/tick-sched.c    |   57 
++++++++++++++++++++++++++++++++----------
  kernel/time/timekeeping.c   |   11 ++++++++
  5 files changed, 104 insertions(+), 14 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..465af22 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -151,6 +151,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
   * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
   * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
   * @shift:		cycle to nanosecond divisor (power of two)
+ * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
   * @flags:		flags describing special properties
   * @vread:		vsyscall based read
   * @resume:		resume function for the clocksource, if necessary
@@ -171,6 +172,7 @@ struct clocksource {
  	u32 mult;
  	u32 mult_orig;
  	u32 shift;
+	s64 max_idle_ns;
  	unsigned long flags;
  	cycle_t (*vread)(void);
  	void (*resume)(void);
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

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ecfd7b5..18d2b9f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -321,6 +321,50 @@ void clocksource_touch_watchdog(void)
  }

  /**
+ * clocksource_max_deferment - Returns max time the clocksource can be 
deferred
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
+	max_nsecs = cyc2ns(cs, max_cycles);
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
+/**
   * clocksource_get_next - Returns the selected clocksource
   *
   */
@@ -405,6 +449,9 @@ int clocksource_register(struct clocksource *c)
  	/* save mult_orig on registration */
  	c->mult_orig = c->mult;

+	/* calculate max idle time permitted for this clocksource */
+	c->max_idle_ns = clocksource_max_deferment(c);
+
  	spin_lock_irqsave(&clocksource_lock, flags);
  	ret = clocksource_enqueue(c);
  	if (!ret)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..9988e5e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -217,6 +217,7 @@ void tick_nohz_stop_sched_tick(int inidle)
  	ktime_t last_update, expires, now;
  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
  	int cpu;
+	s64 time_delta, max_time_delta;

  	local_irq_save(flags);

@@ -264,6 +265,18 @@ void tick_nohz_stop_sched_tick(int inidle)
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
@@ -283,11 +296,30 @@ void tick_nohz_stop_sched_tick(int inidle)
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
@@ -331,22 +363,19 @@ void tick_nohz_stop_sched_tick(int inidle)

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
+		if (unlikely(expires.tv64 == KTIME_MAX)) {
  			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
  				hrtimer_cancel(&ts->sched_timer);
  			goto out;
  		}

-		/* Mark expiries */
-		ts->idle_expires = expires;
-
  		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
  			hrtimer_start(&ts->sched_timer, expires,
  				      HRTIMER_MODE_ABS);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 687dff4..659cae3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -271,6 +271,17 @@ int timekeeping_valid_for_hres(void)
  }

  /**
+ * timekeeping_max_deferment - Returns max time the clocksource can be 
deferred
+ *
+ * IMPORTANT: Caller must observe xtime_lock via 
read_seqbegin/read_seqretry
+ * to ensure that the clocksource does not change!
+ */
+s64 timekeeping_max_deferment(void)
+{
+	return clock->max_idle_ns;
+}
+
+/**
   * read_persistent_clock -  Return time in seconds from the persistent 
clock.
   *
   * Weak dummy function for arches that do not yet support it.
-- 
1.6.1

