Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZELX67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZELX67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZELX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:58:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33245 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZELX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:58:48 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0A07D6.90408@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 16:58:47 -0700
Message-Id: <1242172727.3462.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 18:35 -0500, Jon Hunter wrote:
> john stultz wrote:
> > Yea. NSEC_PER_SEC/HZ would probably be safe. I was initially thinking
> > being more paranoid and just dividing it in half, but that's probably a
> > bit silly.
> 
> Thanks, I have added the code to subtract NSEC_PER_SEC/HZ. Should we 
> have any concerns about the adjustment of the mult value? This is the 
> only thing that could impact the value returned from 
> timekeeping_max_deferment(). I am not familiar with exactly how this is 
> working so just wanted to ask.

Well, the mult adjustments should be quite small, especially compared to
the NSEC_PER_SEC/HZ adjustment.

Hmm... Although, I guess we could get bitten if the max_deferment was
like an hour, and the adjustment was enough that it scaled out to and we
ended up being a second late or so. So you have a point.

But since the clockevent driver is not scaled, we probably can get away
with using the orig_mult value instead of mult, and be ok.

Alternatively instead of NSEC_PER_SEC/HZ, we could always drop the
larger of NSEC_PER_SEC/HZ or max_deferment/10? That way we should scale
up without a problem. 

I suspect it would be tough to hit this issue though.

> > As far the decision to defer if the next even is greater then one jiffy
> > away, that seems reasonable, but I'd not embed that into the
> > timekeeping_max_deferrment(). 
> > 
> > I'm suggesting we drop timekeeping_max_deferrment() down since that's
> > the absolute maximum and we're sure to break if we actually wait that
> > long (since the time between clocksource reads would certainly be longer
> > due to execution delay). 1HZ seems reasonable, since we should easily be
> > able to run the tick code twice in that time, as well as it should be
> > easily within the interrupt programming granularity.
> > 
> > Any additional decisions as to how far out we should be before we start
> > skipping ticks would be up to the tick resched code, and shouldn't be in
> > the timekeeping function.
> > 
> > Sound sane? If so add that in and I'll ack it.
> 
> Yes, agree. See below. By the way I have kept the below patch separate 
> from the original I posted here:
> 
> http://marc.info/?l=linux-kernel&m=124026224019895&w=2
> 
> I was not sure if you would prefer to keep these as two patch series or 
> make it one single patch. Let me know if you would like me to combine or 
> re-post as a two patch series.

Two patches should be fine.

> Please note that the environment I have been running some basic tests on 
> is a single core ARM device. I just wanted to let you know in case you 
> have any concerns with this.
> 
> > This looks *much* better to me. Thanks for reworking it!
> 
> Great! No problem. Thanks for your help and feedback.
> 
> Cheers
> Jon
> 
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>

Looks good overall. We may want to add the -10% (or -5%) to be totally
safe, but that's likely just me being paranoid.

Also one more safety issue below.

Otherwise,
Acked-by: John Stultz <johnstul@us.ibm.com>


thanks
-john


> ---
>   include/linux/time.h      |    1 +
>   kernel/time/tick-sched.c  |   36 +++++++++++++++++++++++++-----------
>   kernel/time/timekeeping.c |   19 +++++++++++++++++++
>   3 files changed, 45 insertions(+), 11 deletions(-)
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
> index 687dff4..7617fbe 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -271,6 +271,25 @@ int timekeeping_valid_for_hres(void)
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
> +
> +	/*
> +	 * Limit the time the clocksource can be
> +	 * deferred by one jiffie period to ensure
> +	 * that the clocksource will not wrap.
> +	 */
> +	max_nsecs = cyc2ns(clock, clock->mask) - (NSEC_PER_SEC/HZ);
> +

This seems really unlikely, but you might want to add something like:

	if (max_nsecs < 0)
		max_nsecs = 0;

To avoid negative underflows. I don't see how a system could be running
in highres mode if the clocksource isn't continuous for longer then a
tick, but probably a good idea none the less.


> +	return max_nsecs;
> +}
> +
> +/**
>    * read_persistent_clock -  Return time in seconds from the persistent 
> clock.
>    *
>    * Weak dummy function for arches that do not yet support it.

