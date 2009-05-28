Return-Path: <linux-kernel-owner+w=401wt.eu-S1763916AbZE1UWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763916AbZE1UWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbZE1UV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:21:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56055 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbZE1UV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:21:56 -0400
Message-ID: <4A1EF244.5040108@ti.com>
Date: Thu, 28 May 2009 15:21:24 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain> <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas Gleixner wrote:
> On Wed, 27 May 2009, john stultz wrote:
>>>   Why do you want to recalculate the whole stuff over and over ?
>>>
>>>   That computation can be done when the clock source is initialized or
>>>   any fundamental change of the clock parameters happens.
>>>
>>>   Stick that value into the clocksource struct and just read it out.
>> Sigh. 
>>
>> I was hoping to avoid hanging another bit of junk off of the clocksource
>> struct. 
> 
> Sure, but buying that 8 bytes with Einsteinian insanity is nuts.

Ok, I have re-worked the patch to avoid computing the value over and 
over and just use the original mult value to calculate the max 
deferment. This patch calculates the value on registering the 
clocksource and stores the value in the clocksource struct.

>> But I guess we could compute that value on registration and keep it
>> around. Changes to mult could effect things, but should be well within
>> the 6% safety net we give ourselves.
> 
> That was my thought as well, but even if we have to go to 12% it's way
> better than doing repeated nonsense on the way to idle.

For now I have modified the patch to go to 12.5% margin to be on the 
safe side.

Let me know your thoughts on the below.

Cheers
Jon

The dynamic tick allows the kernel to sleep for periods longer than a 
single tick. This patch prevents that the kernel from sleeping for a 
period longer than the maximum time that the current clocksource can 
count. This ensures that the kernel will not lose track of time. This 
patch adds a function called "clocksource_max_deferment()" that 
calculates the maximum time the kernel can sleep for a given clocksource 
and function called "timekeeping_max_deferment()" that returns maximum 
time the kernel can sleep for the current clocksource.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  include/linux/clocksource.h |   46 
+++++++++++++++++++++++++++++++++++++++++++
  include/linux/time.h        |    1 +
  kernel/time/clocksource.c   |    3 ++
  kernel/time/tick-sched.c    |   36 +++++++++++++++++++++++----------
  kernel/time/timekeeping.c   |   11 ++++++++++
  5 files changed, 86 insertions(+), 11 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..b0d676e 100644
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
@@ -322,6 +324,50 @@ static inline s64 cyc2ns(struct clocksource *cs, 
cycle_t cycles)
  }

  /**
+ * clocksource_max_deferment - Returns max time the clocksource can be 
deferred
+ * @cs:		Pointer to clocksource
+ *
+ */
+static inline s64 clocksource_max_deferment(struct clocksource *cs)
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
   * clocksource_calculate_interval - Calculates a clocksource interval 
struct
   *
   * @c:		Pointer to clocksource.
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
index ecfd7b5..0d98dc2 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -405,6 +405,9 @@ int clocksource_register(struct clocksource *c)
  	/* save mult_orig on registration */
  	c->mult_orig = c->mult;

+	/* calculate max idle time permitted for this clocksource */
+	c->max_idle_ns = clocksource_max_deferment(c);
+
  	spin_lock_irqsave(&clocksource_lock, flags);
  	ret = clocksource_enqueue(c);
  	if (!ret)
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


