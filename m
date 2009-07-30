Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZG3Vj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZG3Vj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZG3Vj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:39:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56977 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG3Vj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:39:56 -0400
Subject: Re: [RFC][patch 11/12] timekeeper read clock helper functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090729134231.768960500@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
	 <20090729134231.768960500@de.ibm.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 14:39:54 -0700
Message-Id: <1248989994.3374.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> plain text document attachment (timekeeper-helper.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
> them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/timekeeping.c |   91 +++++++++++++++++++---------------------------
>  1 file changed, 38 insertions(+), 53 deletions(-)
> 
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
> @@ -84,6 +84,40 @@ static void timekeeper_setup_internals(s
>  	timekeeper.shift = clock->shift;
>  }
> 
> +/* Timekeeper helper functions. */
> +static inline s64 timekeeper_read_clock_ntp(void)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +	struct clocksource *clock;
> +
> +	/* read clocksource: */
> +	clock = timekeeper.clock;
> +	cycle_now = clock->read(clock);
> +

I know it seems nice to have it here, but I think these helpers would be
more reusable in other contexts if they took the cycle_now value as an
argument. Also I'd drop the ntp bit, just to avoid confusing it with
some ntp specific function. So:

 timekeeping_get_ns(cycle_t now);
 timekeeping_get_ns_raw(cycle_t now);

That way in some situations we don't have to make two accesses to the
hardware if we want to get both values at the same point.

Seem reasonable?

thanks
-john



> +	/* calculate the delta since the last update_wall_time: */
> +	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +	/* return delta convert to nanoseconds using ntp adjusted mult. */
> +	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> +				  timekeeper.shift);
> +}
> +
> +static inline s64 timekeeper_read_clock_raw(void)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +	struct clocksource *clock;
> +
> +	/* read clocksource: */
> +	clock = timekeeper.clock;
> +	cycle_now = clock->read(clock);
> +
> +	/* calculate the delta since the last update_wall_time: */
> +	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +	/* return delta convert to nanoseconds using ntp adjusted mult. */
> +	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
> +}
> +
>  /*
>   * This read-write spinlock protects us from races in SMP while
>   * playing with xtime.
> @@ -172,8 +206,6 @@ static void timekeeping_forward_now(void
>   */
>  void getnstimeofday(struct timespec *ts)
>  {
> -	cycle_t cycle_now, cycle_delta;
> -	struct clocksource *clock;
>  	unsigned long seq;
>  	s64 nsecs;
> 
> @@ -183,17 +215,7 @@ void getnstimeofday(struct timespec *ts)
>  		seq = read_seqbegin(&xtime_lock);
> 
>  		*ts = xtime;
> -
> -		/* read clocksource: */
> -		clock = timekeeper.clock;
> -		cycle_now = clock->read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -
> -		/* convert to nanoseconds: */
> -		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> -					   timekeeper.shift);
> +		nsecs = timekeeper_read_clock_ntp();
> 
>  		/* If arch requires, add in gettimeoffset() */
>  		nsecs += arch_gettimeoffset();
> @@ -207,8 +229,6 @@ EXPORT_SYMBOL(getnstimeofday);
> 
>  ktime_t ktime_get(void)
>  {
> -	cycle_t cycle_now, cycle_delta;
> -	struct clocksource *clock;
>  	unsigned int seq;
>  	s64 secs, nsecs;
> 
> @@ -218,17 +238,7 @@ ktime_t ktime_get(void)
>  		seq = read_seqbegin(&xtime_lock);
>  		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
>  		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> -
> -		/* read clocksource: */
> -		clock = timekeeper.clock;
> -		cycle_now = clock->read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -
> -		/* convert to nanoseconds: */
> -		nsecs += clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> -					    timekeeper.shift);
> +		nsecs += timekeeper_read_clock_ntp();
> 
>  	} while (read_seqretry(&xtime_lock, seq));
>  	/*
> @@ -249,8 +259,6 @@ EXPORT_SYMBOL_GPL(ktime_get);
>   */
>  void ktime_get_ts(struct timespec *ts)
>  {
> -	cycle_t cycle_now, cycle_delta;
> -	struct clocksource *clock;
>  	struct timespec tomono;
>  	unsigned int seq;
>  	s64 nsecs;
> @@ -261,17 +269,7 @@ void ktime_get_ts(struct timespec *ts)
>  		seq = read_seqbegin(&xtime_lock);
>  		*ts = xtime;
>  		tomono = wall_to_monotonic;
> -
> -		/* read clocksource: */
> -		clock = timekeeper.clock;
> -		cycle_now = clock->read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -
> -		/* convert to nanoseconds: */
> -		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> -					   timekeeper.shift);
> +		nsecs = timekeeper_read_clock_ntp();
> 
>  	} while (read_seqretry(&xtime_lock, seq));
> 
> @@ -433,23 +431,10 @@ void getrawmonotonic(struct timespec *ts
>  {
>  	unsigned long seq;
>  	s64 nsecs;
> -	cycle_t cycle_now, cycle_delta;
> -	struct clocksource *clock;
> 
>  	do {
>  		seq = read_seqbegin(&xtime_lock);
> -
> -		/* read clocksource: */
> -		clock = timekeeper.clock;
> -		cycle_now = clock->read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -
> -		/* convert to nanoseconds: */
> -		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
> -					   clock->shift);
> -
> +		nsecs = timekeeper_read_clock_raw();
>  		*ts = raw_time;
> 
>  	} while (read_seqretry(&xtime_lock, seq));
> 

