Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbZEIAvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbZEIAvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 20:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbZEIAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 20:51:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47455 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380AbZEIAvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 20:51:32 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep  
 formorethan 2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A04584E.4020307@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 17:51:21 -0700
Message-Id: <1241830281.7297.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:05 -0500, Jon Hunter wrote:
> john stultz wrote:
> > Yep. It would be easy to pull:
> > 	max_time_delta = timekeeping_max_deferment()
> > when you read jiffies.
> 
> Ok, will do.
> 
> > Urr. Lets move away from jiffies. Jiffies bad. Human time good.
> > 
> > Its easy to get the max value in ns right now, last_update is already a
> > ktime_t. 
> > 
> > I think checking if expires (little bit lower in the same function) is
> > larger then (last_update + max_time_delta) would be much much simpler.
> 
> No problem. I will do this too. I had a bit of a tough time figuring out 
> what was best here.
> 
> > Yeeks. No, lets not do this. Cluttering up the clocksource with jiffies
> > values is totally unnecessary.
> 
> Sorry about that. I have a tendency to try to reduce run-time 
> computation if I can do it once at the beginning. However, I also 
> dislike clutter so we can keep it the way you recommend.
> 
> > So while I really don't like your patch, I think you have the right
> > idea. Just keep things in nanoseconds, rather then converting them to
> > jiffies first. It will be much simpler patch and won't affect as much
> > code.
> > 
> > Look at the simple accessor patch I sent earlier:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html
> > 
> > You could require the xtime_lock be held while calling to doge grabbing
> > it twice and plug it right in.
> 
> Done. See below. Please note that the below patch is simply for handling 
> the wrapping of clocksources and does not include the original patch to 
> convert max_delta_ns to long long (to keep things simple for now).
> 
> I still have a couple concerns:
> 
> 1). The use of delta_jiffies
> 
> The below patch does not update delta_jiffies. In the current code 
> delta_jiffies in a couple places after "expires" is calculated. So if we 
> adjust expires to account for clocksource wrap, we should avoid using 
> delta_jiffies later on. The first place delta_jiffies is used after 
> expires is calculated is here:
> 
>                   if (delta_jiffies > 1)
>                           cpumask_set_cpu(cpu, nohz_cpu_mask);
> 
> The second place is here:
> 
>                   /*
>                    * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
>                    * there is no timer pending or at least extremly far
>                    * into the future (12 days for HZ=1000). In this case
>                    * we simply stop the tick timer:
>                    */
>                   if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
>                           ts->idle_expires.tv64 = KTIME_MAX;
>                           if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
>                                   hrtimer_cancel(&ts->sched_timer);
>                           goto out;
> 
> Currently I have modified these compares so that the comparisons are 
> done in nanoseconds and not jiffies to be safe. Let me know your thoughts.

Yep. Looks good to me.

> 
> 2). Clocksource max deferment
> 
> In your original patch you suggested that we should reduce the max time 
> returned by the function timekeeping_max_deferment by some amount. Would 
> it make sense to reduce this by a jiffie? In the current dynamic tick 
> code we will only defer the tick if the next event is greater than or 
> equal to 1 jiffie.

Yea. NSEC_PER_SEC/HZ would probably be safe. I was initially thinking
being more paranoid and just dividing it in half, but that's probably a
bit silly.

As far the decision to defer if the next even is greater then one jiffy
away, that seems reasonable, but I'd not embed that into the
timekeeping_max_deferrment(). 

I'm suggesting we drop timekeeping_max_deferrment() down since that's
the absolute maximum and we're sure to break if we actually wait that
long (since the time between clocksource reads would certainly be longer
due to execution delay). 1HZ seems reasonable, since we should easily be
able to run the tick code twice in that time, as well as it should be
easily within the interrupt programming granularity.

Any additional decisions as to how far out we should be before we start
skipping ticks would be up to the tick resched code, and shouldn't be in
the timekeeping function.

Sound sane? If so add that in and I'll ack it.

> 
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>

This looks *much* better to me. Thanks for reworking it!

Thomas, this all sound/look good to you?

thanks
-john

> ---
>   include/linux/time.h      |    1 +
>   kernel/time/tick-sched.c  |   36 +++++++++++++++++++++++++-----------
>   kernel/time/timekeeping.c |   14 ++++++++++++++
>   3 files changed, 40 insertions(+), 11 deletions(-)
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
> index d3f1ef4..5f9ba13 100644
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
> +		 * /
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
> index 687dff4..a2ce815 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -271,6 +271,20 @@ int timekeeping_valid_for_hres(void)
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
> +	max_nsecs = cyc2ns(clock, clock->mask);
> +
> +	return max_nsecs; /* XXX maybe reduce by some amount to be safe? */
> +}
> +
> +/**
>    * read_persistent_clock -  Return time in seconds from the persistent 
> clock.
>    *
>    * Weak dummy function for arches that do not yet support it.

