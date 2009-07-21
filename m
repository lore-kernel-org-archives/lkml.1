Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZGUWEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZGUWEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZGUWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:04:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59553 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZGUWEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:04:06 -0400
Subject: Re: [RFC][patch 3/5] remove clocksource inline functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20090721192059.454927873@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192059.454927873@de.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:03:55 -0700
Message-Id: <1248213835.3298.112.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-inline.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Remove clocksource_read, clocksource_enable and clocksource_disable
> inline functions. No functional change.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/clocksource.c |   18 ++++++++++++------
>  kernel/time/timekeeping.c |   13 ++++++-------
>  2 files changed, 18 insertions(+), 13 deletions(-)


There's a patch Magnus has that (should be) queued for 2.6.31 that makes
unbreaks the mult_orig manipulations enable/disable does. I suspect this
will cause this inline function removing to not be that much of a
benefit.

thanks
-john



> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -517,7 +517,7 @@ void clocksource_forward_now(void)
>  	cycle_t cycle_now, cycle_delta;
>  	s64 nsec;
> 
> -	cycle_now = clocksource_read(clock);
> +	cycle_now = clock->read(clock);
>  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
>  	clock->cycle_last = cycle_now;
> 
> @@ -567,16 +567,19 @@ void change_clocksource(void)
> 
>  	clocksource_forward_now();
> 
> -	if (clocksource_enable(new))
> +	if (new->enable && !new->enable(new))
>  		return;
> 
> +	/* save mult_orig after successful enable */
> +	new->mult_orig = new->mult;
> +
>  	new->raw_time = clock->raw_time;
>  	old = clock;
>  	clock = new;
> -	clocksource_disable(old);
> +	if (old->disable)
> +		old->disable(old);

	mult_orig needs to be saved to mult at this point.

> -	clock->cycle_last = 0;
> -	clock->cycle_last = clocksource_read(clock);
> +	clock->cycle_last = clock->read(clock);
>  	clock->error = 0;
>  	clock->xtime_nsec = 0;
>  	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
> @@ -655,7 +658,10 @@ void clocksource_unregister(struct clock
>  void __init clocksource_init(void)
>  {
>  	clock = clocksource_get_next();
> -	clocksource_enable(clock);
> +	if (clock->enable)
> +		clock->enable(clock);
> +	/* save mult_orig on enable */
> +	clock->mult_orig = clock->mult;
>  	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
>  	clock->cycle_last = clock->read(clock);
>  }
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
> @@ -78,7 +78,7 @@ void getnstimeofday(struct timespec *ts)
>  		*ts = xtime;
> 
>  		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> +		cycle_now = clock->read(clock);
> 
>  		/* calculate the delta since the last update_wall_time: */
>  		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> @@ -110,7 +110,7 @@ ktime_t ktime_get(void)
>  		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> 
>  		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> +		cycle_now = clock->read(clock);
> 
>  		/* calculate the delta since the last update_wall_time: */
>  		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> @@ -150,7 +150,7 @@ void ktime_get_ts(struct timespec *ts)
>  		tomono = wall_to_monotonic;
> 
>  		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> +		cycle_now = clock->read(clock);
> 
>  		/* calculate the delta since the last update_wall_time: */
>  		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> @@ -296,7 +296,7 @@ void getrawmonotonic(struct timespec *ts
>  		seq = read_seqbegin(&xtime_lock);
> 
>  		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> +		cycle_now = clock->read(clock);
> 
>  		/* calculate the delta since the last update_wall_time: */
>  		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> @@ -396,8 +396,7 @@ static int timekeeping_resume(struct sys
>  	}
>  	update_xtime_cache(0);
>  	/* re-base the last cycle value */
> -	clock->cycle_last = 0;
> -	clock->cycle_last = clocksource_read(clock);
> +	clock->cycle_last = clock->read(clock);
>  	clock->error = 0;
>  	timekeeping_suspended = 0;
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
> @@ -464,7 +463,7 @@ void update_wall_time(void)
>  		return;
> 
>  #ifdef CONFIG_GENERIC_TIME
> -	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
> +	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
>  #else
>  	offset = clock->cycle_interval;
>  #endif
> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 

