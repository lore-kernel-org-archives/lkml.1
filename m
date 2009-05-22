Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZEVTXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZEVTXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZEVTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:23:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51048 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225AbZEVTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:23:15 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep
 formorethan2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A16ED34.9060808@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>
	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com>
	 <1242242497.9777.2.camel@jstultz-laptop>  <4A0D99E0.3050306@ti.com>
	 <1242436726.29511.198.camel@jstultz-laptop>  <4A16ED34.9060808@ti.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 12:23:12 -0700
Message-Id: <1243020192.7480.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 13:21 -0500, Jon Hunter wrote:
> John Stultz wrote:
> > So cyc2ns is a very very hot path, so I don't think we want to muck with
> > that much.
> > 
> > Instead of catching the overflows, and then trying to handle them, we
> > really want to prevent overflows from happening. That is the main point
> > of the timekeeping_max_deferrment() interface after all ;)
> > 
> > So thinking about it a bit more, what we really want from
> > timekeeping_max_deferrment() is roughly:
> > 
> > 	/* find the max cycle value that would overflow the mult */
> > 	max_cycles = -1UUL/clocksource->mult;
> > 
> > 	/* pick the smaller of max_cycles or the mask value */
> > 	max_cycles = min(max_cycles, clocksource->mask);
> > 
> > 	/* convert max_cycles into ns */
> > 	max_time = cyc2ns(clocksource, max_cycles);
> > 
> > 	/* take off 5% of the max to make sure we don't show up late */
> > 	max_time = max_time - max_time/20;
> > 
> > 
> > We should be able to make this reasonably fast via:
> > 	max_cycles = 1<<(64 - ilog2(clocksource->mult) - 1);
> > 	max_cycles = min(max_cycles, clocksource->mask);
> > 	max_time = cyc2ns(clocksource, max_cycles);
> > 	max_time = max_time - max_time >> 4;
> > 
> > Does that seem reasonable?
> 
> Yes, good idea. Sorry for the delay in getting back to this. I have 
> implemented the above and incorporated into the patch below.
> 
> Please note that the only modification I made to the above was to add 1 
> to result of the log2. I found that the result of the log2 was rounded 
> down and so this was still making max_cycles too big. Therefore to be on 
> the safe side I add 1 to the result of log2 which will ensure max_cycles 
> is not too big.

Yep you're right. I was trying to handle that with the -1, but my
mistake was using 1<<64 not 1<<63. Thanks for catching that!


> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>

Acked-by: John Stultz <johnstul@us.ibm.com>

This looks great to me!

Thanks for putting up with my nit-picky review and revised suggestions!

Thomas, you ok to pick this up?
-john

> ---
>   include/linux/time.h      |    1 +
>   kernel/time/tick-sched.c  |   36 +++++++++++++++++++++++----------
>   kernel/time/timekeeping.c |   47 
> +++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 242f624..090be07 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -130,6 +130,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);
> 
>   extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>   extern int timekeeping_valid_for_hres(void);
> +extern s64 timekeeping_max_deferment(void);
>   extern void update_wall_time(void);
>   extern void update_xtime_cache(u64 nsec);
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d3f1ef4..f0155ae 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -217,6 +217,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>   	ktime_t last_update, expires, now;
>   	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
>   	int cpu;
> +	s64 time_delta, max_time_delta;
> 
>   	local_irq_save(flags);
> 
> @@ -264,6 +265,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>   		seq = read_seqbegin(&xtime_lock);
>   		last_update = last_jiffies_update;
>   		last_jiffies = jiffies;
> +		max_time_delta = timekeeping_max_deferment();
>   	} while (read_seqretry(&xtime_lock, seq));
> 
>   	/* Get the next timer wheel timer */
> @@ -283,11 +285,22 @@ void tick_nohz_stop_sched_tick(int inidle)
>   	if ((long)delta_jiffies >= 1) {
> 
>   		/*
> -		* calculate the expiry time for the next timer wheel
> -		* timer
> -		*/
> -		expires = ktime_add_ns(last_update, tick_period.tv64 *
> -				   delta_jiffies);
> +		 * Calculate the time delta for the next timer event.
> +		 * If the time delta exceeds the maximum time delta
> +		 * permitted by the current clocksource then adjust
> +		 * the time delta accordingly to ensure the
> +		 * clocksource does not wrap.
> +		 */
> +		time_delta = tick_period.tv64 * delta_jiffies;
> +
> +		if (time_delta > max_time_delta)
> +			time_delta = max_time_delta;
> +
> +		/*
> +		 * calculate the expiry time for the next timer wheel
> +		 * timer
> +		 */
> +		expires = ktime_add_ns(last_update, time_delta);
> 
>   		/*
>   		 * If this cpu is the one which updates jiffies, then
> @@ -300,7 +313,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>   		if (cpu == tick_do_timer_cpu)
>   			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> 
> -		if (delta_jiffies > 1)
> +		if (time_delta > tick_period.tv64)
>   			cpumask_set_cpu(cpu, nohz_cpu_mask);
> 
>   		/* Skip reprogram of event if its not changed */
> @@ -332,12 +345,13 @@ void tick_nohz_stop_sched_tick(int inidle)
>   		ts->idle_sleeps++;
> 
>   		/*
> -		 * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
> -		 * there is no timer pending or at least extremly far
> -		 * into the future (12 days for HZ=1000). In this case
> -		 * we simply stop the tick timer:
> +		 * time_delta >= (tick_period.tv64 * NEXT_TIMER_MAX_DELTA)
> +		 * signals that there is no timer pending or at least
> +		 * extremely far into the future (12 days for HZ=1000).
> +		 * In this case we simply stop the tick timer:
>   		 */
> -		if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
> +		if (unlikely(time_delta >=
> +				(tick_period.tv64 * NEXT_TIMER_MAX_DELTA))) {
>   			ts->idle_expires.tv64 = KTIME_MAX;
>   			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
>   				hrtimer_cancel(&ts->sched_timer);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 687dff4..608fc6f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -271,6 +271,53 @@ int timekeeping_valid_for_hres(void)
>   }
> 
>   /**
> + * timekeeping_max_deferment - Returns max time the clocksource can be 
> deferred
> + *
> + * IMPORTANT: Must be called with xtime_lock held!
> + */
> +s64 timekeeping_max_deferment(void)
> +{
> +	s64 max_nsecs;
> +	u64 max_cycles;
> +
> +	/*
> +	 * Calculate the maximum number of cycles that we can pass to the
> +	 * cyc2ns function without overflowing a 64-bit signed result. The
> +	 * maximum number of cycles is equal to ULLONG_MAX/clock->mult which
> +	 * is equivalent to the below.
> +	 * max_cycles < (2^63)/clock->mult
> +	 * max_cycles < 2^(log2((2^63)/clock->mult))
> +	 * max_cycles < 2^(log2(2^63) - log2(clock->mult))
> +	 * max_cycles < 2^(63 - log2(clock->mult))
> +	 * max_cycles < 1 << (63 - log2(clock->mult))
> +	 * Please note that we add 1 to the result of the log2 to account for
> +	 * any rounding errors, ensure the above inequality is satisfied and
> +	 * no overflow will occur.
> +	 */
> +	max_cycles = 1ULL << (63 - (ilog2(clock->mult) + 1));
> +
> +	/*
> +	 * The actual maximum number of cycles we can defer the clocksource is
> +	 * determined by the minimum of max_cycles and clock->mask.
> +	 */
> +	max_cycles = min(max_cycles, clock->mask);
> +	max_nsecs = cyc2ns(clock, max_cycles);
> +
> +	/*
> +	 * To ensure that the clocksource does not wrap whilst we are idle,
> +	 * limit the time the clocksource can be deferred by 6.25%. Please
> +	 * note a margin of 6.25% is used because this can be computed with
> +	 * a shift, versus say 5% which would require division.
> +	 */
> +	max_nsecs = max_nsecs - (max_nsecs >> 4);
> +
> +	if (max_nsecs < 0)
> +		max_nsecs = 0;
> +
> +	return max_nsecs;
> +}
> +
> +/**
>    * read_persistent_clock -  Return time in seconds from the persistent 
> clock.
>    *
>    * Weak dummy function for arches that do not yet support it.

