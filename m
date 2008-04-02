Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYDBQCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYDBQCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbYDBQBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:01:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37292 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbYDBQBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:01:51 -0400
Subject: Re: [PATCH 1/2] Introduce clocksource_forward_now
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804021322490.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
	 <1205878420.28128.117.camel@localhost>
	 <Pine.LNX.4.64.0804021322490.26791@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 09:01:48 -0700
Message-Id: <1207152108.6211.12.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 13:39 +0200, Roman Zippel wrote:
> Hi,
> 
> On Tue, 18 Mar 2008, john stultz wrote:
> 
> > My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> > nanosecond based time value, that increments starting at bootup and has
> > no frequency adjustments made to it what so ever.
> 
> There is a problem with the time offset since the last update_wall_time() 
> call, which isn't taken into account when switching clocks (possibly 
> during suspend/resume too), so that the clock might jump back during a 
> clock switch.

Yep, thanks for catching that!


> To avoid making the whole more complex it's better to do small cleanup 
> first, so this patch introduces clocksource_forward_now() which takes care 
> of this offset since the last update_wall_time() call and adds it to the 
> clock, so there is no need anymore to deal with it explicitly.
> This is also gets rid of the timekeeping_suspend_nsecs hack, instead of 
> waiting until resume, the value is accumulated during suspend. In the end 
> there is only a single user of __get_nsec_offset() left, so I integrated 
> it back to getnstimeofday().
> 
> bye, Roman
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Looks ok to me.

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  kernel/time/timekeeping.c |   67 ++++++++++++++++++++--------------------------
>  1 file changed, 30 insertions(+), 37 deletions(-)
> 
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
> @@ -58,27 +58,23 @@ struct clocksource *clock;
> 
>  #ifdef CONFIG_GENERIC_TIME
>  /**
> - * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
> + * clocksource_forward_now - update clock to the current time
>   *
> - * private function, must hold xtime_lock lock when being
> - * called. Returns the number of nanoseconds since the
> - * last call to update_wall_time() (adjusted by NTP scaling)
> + * Forward the current clock to update its state since the last call to
> + * update_wall_time(). This is useful before significant clock changes,
> + * as it avoids having to deal with this time offset explicitly.
>   */
> -static inline s64 __get_nsec_offset(void)
> +static void clocksource_forward_now(void)
>  {
>  	cycle_t cycle_now, cycle_delta;
> -	s64 ns_offset;
> +	s64 nsec;
> 
> -	/* read clocksource: */
>  	cycle_now = clocksource_read(clock);
> -
> -	/* calculate the delta since the last update_wall_time: */
>  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +	clock->cycle_last = cycle_now;
> 
> -	/* convert to nanoseconds: */
> -	ns_offset = cyc2ns(clock, cycle_delta);
> -
> -	return ns_offset;
> +	nsec = cyc2ns(clock, cycle_delta);
> +	timespec_add_ns(&xtime, nsec);
>  }
> 
>  /**
> @@ -89,6 +85,7 @@ static inline s64 __get_nsec_offset(void
>   */
>  void getnstimeofday(struct timespec *ts)
>  {
> +	cycle_t cycle_now, cycle_delta;
>  	unsigned long seq;
>  	s64 nsecs;
> 
> @@ -96,7 +93,15 @@ void getnstimeofday(struct timespec *ts)
>  		seq = read_seqbegin(&xtime_lock);
> 
>  		*ts = xtime;
> -		nsecs = __get_nsec_offset();
> +
> +		/* read clocksource: */
> +		cycle_now = clocksource_read(clock);
> +
> +		/* calculate the delta since the last update_wall_time: */
> +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +		/* convert to nanoseconds: */
> +		nsecs = cyc2ns(clock, cycle_delta);
> 
>  	} while (read_seqretry(&xtime_lock, seq));
> 
> @@ -130,21 +135,19 @@ EXPORT_SYMBOL(do_gettimeofday);
>  int do_settimeofday(struct timespec *tv)
>  {
>  	unsigned long flags;
> -	time_t wtm_sec, sec = tv->tv_sec;
> -	long wtm_nsec, nsec = tv->tv_nsec;
> 
>  	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
>  		return -EINVAL;
> 
>  	write_seqlock_irqsave(&xtime_lock, flags);
> 
> -	nsec -= __get_nsec_offset();
> +	clocksource_forward_now();
> 
> -	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
> -	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
> +	wall_to_monotonic.tv_sec += xtime.tv_sec - tv->tv_sec;
> +	timespec_add_ns(&wall_to_monotonic, xtime.tv_nsec - tv->tv_nsec);
> +
> +	xtime = *tv;
> 
> -	set_normalized_timespec(&xtime, sec, nsec);
> -	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
>  	update_xtime_cache(0);
> 
>  	clock->error = 0;
> @@ -170,21 +173,16 @@ EXPORT_SYMBOL(do_settimeofday);
>  static void change_clocksource(void)
>  {
>  	struct clocksource *new;
> -	cycle_t now;
> -	u64 nsec;
> 
>  	new = clocksource_get_next();
> 
>  	if (clock == new)
>  		return;
> 
> -	now = clocksource_read(new);
> -	nsec =  __get_nsec_offset();
> -	timespec_add_ns(&xtime, nsec);
> +	clocksource_forward_now();
> 
>  	clock = new;
> -	clock->cycle_last = now;
> -
> +	clock->cycle_last = clocksource_read(new);
>  	clock->error = 0;
>  	clock->xtime_nsec = 0;
>  	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
> @@ -199,8 +197,8 @@ static void change_clocksource(void)
>  	 */
>  }
>  #else
> +static inline void clocksource_forward_now(void) { }
>  static inline void change_clocksource(void) { }
> -static inline s64 __get_nsec_offset(void) { return 0; }
>  #endif
> 
>  /**
> @@ -264,8 +262,6 @@ void __init timekeeping_init(void)
>  static int timekeeping_suspended;
>  /* time in seconds when suspend began */
>  static unsigned long timekeeping_suspend_time;
> -/* xtime offset when we went into suspend */
> -static s64 timekeeping_suspend_nsecs;
> 
>  /**
>   * timekeeping_resume - Resumes the generic timekeeping subsystem.
> @@ -291,8 +287,6 @@ static int timekeeping_resume(struct sys
>  		wall_to_monotonic.tv_sec -= sleep_length;
>  		total_sleep_time += sleep_length;
>  	}
> -	/* Make sure that we have the correct xtime reference */
> -	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
>  	update_xtime_cache(0);
>  	/* re-base the last cycle value */
>  	clock->cycle_last = clocksource_read(clock);
> @@ -317,8 +311,7 @@ static int timekeeping_suspend(struct sy
>  	timekeeping_suspend_time = read_persistent_clock();
> 
>  	write_seqlock_irqsave(&xtime_lock, flags);
> -	/* Get the current xtime offset */
> -	timekeeping_suspend_nsecs = __get_nsec_offset();
> +	clocksource_forward_now();
>  	timekeeping_suspended = 1;
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
> 
> @@ -459,10 +452,10 @@ void update_wall_time(void)
>  	 */
>  	while (offset >= clock->cycle_interval) {
>  		/* accumulate one interval */
> -		clock->xtime_nsec += clock->xtime_interval;
> -		clock->cycle_last += clock->cycle_interval;
>  		offset -= clock->cycle_interval;
> +		clock->cycle_last += clock->cycle_interval;
> 
> +		clock->xtime_nsec += clock->xtime_interval;
>  		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
>  			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
>  			xtime.tv_sec++;

