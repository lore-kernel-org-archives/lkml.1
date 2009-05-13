Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbZEMPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbZEMPP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZEMPPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:15:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41676 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbZEMPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:15:15 -0400
Message-ID: <4A0AE3E3.5090304@ti.com>
Date: Wed, 13 May 2009 10:14:43 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com> <1242172727.3462.55.camel@localhost>
In-Reply-To: <1242172727.3462.55.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


john stultz wrote:
> Well, the mult adjustments should be quite small, especially compared to
> the NSEC_PER_SEC/HZ adjustment.
> 
> Hmm... Although, I guess we could get bitten if the max_deferment was
> like an hour, and the adjustment was enough that it scaled out to and we
> ended up being a second late or so. So you have a point.
> 
> But since the clockevent driver is not scaled, we probably can get away
> with using the orig_mult value instead of mult, and be ok.
> 
> Alternatively instead of NSEC_PER_SEC/HZ, we could always drop the
> larger of NSEC_PER_SEC/HZ or max_deferment/10? That way we should scale
> up without a problem. 

Yes, may be this would be a safer option. Thinking about this I was 
wondering if we should always use max_deferement/10, because I did not 
think that there would ever be a case where NSEC_PER_SEC/HZ would be 
greater. If NSEC_PER_SEC/HZ was greater than max_deferement/10 this 
would imply that the clocksource would wrap after only 10 jiffies, if I 
have the math right...

> I suspect it would be tough to hit this issue though.

Agree.

> Two patches should be fine.

Ok, I will re-post as two once we have the final version.

> Looks good overall. We may want to add the -10% (or -5%) to be totally
> safe, but that's likely just me being paranoid.

I am paranoid too! Do you care if we use 6.25% or 12.5% margin instead 
of 10% or 5%? This way we can avoid a 64-bit division by using a simple 
shift. See below. I have implemented a 6.25% margin for now. Let me know 
your thoughts.

One final question, I noticed in clocksource.h that the definition of 
function cyc2ns returns a type of s64, however, in the function itself a 
variable of type u64 is used and returned. Should this function be 
modified as follows?

  static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
  {
-       u64 ret = (u64)cycles;
+       s64 ret = (s64)cycles;
         ret = (ret * cs->mult) >> cs->shift;
         return ret;
  }

Cheers
Jon


Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  include/linux/time.h      |    1 +
  kernel/time/tick-sched.c  |   36 +++++++++++++++++++++++++-----------
  kernel/time/timekeeping.c |   28 ++++++++++++++++++++++++++++
  3 files changed, 54 insertions(+), 11 deletions(-)

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
index 687dff4..e764ac8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -271,6 +271,34 @@ int timekeeping_valid_for_hres(void)
  }

  /**
+ * timekeeping_max_deferment - Returns max time the clocksource can be 
deferred
+ *
+ * IMPORTANT: Must be called with xtime_lock held!
+ */
+s64 timekeeping_max_deferment(void)
+{
+	s64 max_nsecs, margin;
+
+	max_nsecs = cyc2ns(clock, clock->mask);
+
+	/*
+	 * To ensure that the clocksource does not wrap whilst we are idle,
+	 * let's limit the time the clocksource can be deferred by 6.25% of
+	 * the total time the clocksource can count. Please note a margin
+	 * of 6.25% is used because this can be computed with a shift,
+	 * versus say 5% which would require division.
+	 */
+	margin = max_nsecs >> 4;
+
+	max_nsecs = max_nsecs - margin;
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

