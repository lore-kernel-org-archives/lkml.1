Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbYAaMKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbYAaMKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYAaMKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:10:42 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:45308 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbYAaMKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:10:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP1IoUdMQWYq/2dsb2JhbACBWKl/
Date: Thu, 31 Jan 2008 07:10:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/23 -v8] handle accurate time keeping over long delays
Message-ID: <20080131121037.GB8493@Krystal>
References: <20080130210357.927754294@goodmis.org> <20080130210525.701268662@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080130210525.701268662@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:06:23 up 88 days, 17:11,  4 users,  load average: 3.21, 1.47,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: John Stultz <johnstul@us.ibm.com>
> 
> Handle accurate time even if there's a long delay between
> accumulated clock cycles.
> 

About this one.. we talked a lot about the importance of timekeeping at
the first Montreal Tracing Summit this week. Actually, someone
mentioned a very interesting point : in order to be able to synchronize
traces taken from the machine with traces taken on external hardware
(i.e. memory bus tracer on Freescale), taking the "real" counter value
rather that using the "cumulated cycles" approach (which creates a
virtual counted instead) would be better.

So I would recommend using an algorithm that would return a clock value
which is the same as the underlying hardware counter.

Mathieu

> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/powerpc/kernel/time.c    |    3 +-
>  arch/x86/kernel/vsyscall_64.c |    5 ++-
>  include/asm-x86/vgtod.h       |    2 -
>  include/linux/clocksource.h   |   58 ++++++++++++++++++++++++++++++++++++++++--
>  kernel/time/timekeeping.c     |   36 +++++++++++++-------------
>  5 files changed, 82 insertions(+), 22 deletions(-)
> 
> Index: linux-mcount.git/arch/x86/kernel/vsyscall_64.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/vsyscall_64.c	2008-01-30 14:47:08.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/vsyscall_64.c	2008-01-30 14:54:12.000000000 -0500
> @@ -86,6 +86,7 @@ void update_vsyscall(struct timespec *wa
>  	vsyscall_gtod_data.clock.mask = clock->mask;
>  	vsyscall_gtod_data.clock.mult = clock->mult;
>  	vsyscall_gtod_data.clock.shift = clock->shift;
> +	vsyscall_gtod_data.clock.cycle_accumulated = clock->cycle_accumulated;
>  	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
>  	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
>  	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
> @@ -121,7 +122,7 @@ static __always_inline long time_syscall
>  
>  static __always_inline void do_vgettimeofday(struct timeval * tv)
>  {
> -	cycle_t now, base, mask, cycle_delta;
> +	cycle_t now, base, accumulated, mask, cycle_delta;
>  	unsigned seq;
>  	unsigned long mult, shift, nsec;
>  	cycle_t (*vread)(void);
> @@ -135,6 +136,7 @@ static __always_inline void do_vgettimeo
>  		}
>  		now = vread();
>  		base = __vsyscall_gtod_data.clock.cycle_last;
> +		accumulated  = __vsyscall_gtod_data.clock.cycle_accumulated;
>  		mask = __vsyscall_gtod_data.clock.mask;
>  		mult = __vsyscall_gtod_data.clock.mult;
>  		shift = __vsyscall_gtod_data.clock.shift;
> @@ -145,6 +147,7 @@ static __always_inline void do_vgettimeo
>  
>  	/* calculate interval: */
>  	cycle_delta = (now - base) & mask;
> +	cycle_delta += accumulated;
>  	/* convert to nsecs: */
>  	nsec += (cycle_delta * mult) >> shift;
>  
> Index: linux-mcount.git/include/asm-x86/vgtod.h
> ===================================================================
> --- linux-mcount.git.orig/include/asm-x86/vgtod.h	2008-01-30 14:35:51.000000000 -0500
> +++ linux-mcount.git/include/asm-x86/vgtod.h	2008-01-30 14:54:12.000000000 -0500
> @@ -15,7 +15,7 @@ struct vsyscall_gtod_data {
>  	struct timezone sys_tz;
>  	struct { /* extract of a clocksource struct */
>  		cycle_t (*vread)(void);
> -		cycle_t	cycle_last;
> +		cycle_t	cycle_last, cycle_accumulated;
>  		cycle_t	mask;
>  		u32	mult;
>  		u32	shift;
> Index: linux-mcount.git/include/linux/clocksource.h
> ===================================================================
> --- linux-mcount.git.orig/include/linux/clocksource.h	2008-01-30 14:35:51.000000000 -0500
> +++ linux-mcount.git/include/linux/clocksource.h	2008-01-30 14:54:12.000000000 -0500
> @@ -50,8 +50,12 @@ struct clocksource;
>   * @flags:		flags describing special properties
>   * @vread:		vsyscall based read
>   * @resume:		resume function for the clocksource, if necessary
> + * @cycle_last:		Used internally by timekeeping core, please ignore.
> + * @cycle_accumulated:	Used internally by timekeeping core, please ignore.
>   * @cycle_interval:	Used internally by timekeeping core, please ignore.
>   * @xtime_interval:	Used internally by timekeeping core, please ignore.
> + * @xtime_nsec:		Used internally by timekeeping core, please ignore.
> + * @error:		Used internally by timekeeping core, please ignore.
>   */
>  struct clocksource {
>  	/*
> @@ -82,7 +86,10 @@ struct clocksource {
>  	 * Keep it in a different cache line to dirty no
>  	 * more than one cache line.
>  	 */
> -	cycle_t cycle_last ____cacheline_aligned_in_smp;
> +	struct {
> +		cycle_t cycle_last, cycle_accumulated;
> +	} ____cacheline_aligned_in_smp;
> +
>  	u64 xtime_nsec;
>  	s64 error;
>  
> @@ -168,11 +175,44 @@ static inline cycle_t clocksource_read(s
>  }
>  
>  /**
> + * clocksource_get_cycles: - Access the clocksource's accumulated cycle value
> + * @cs:		pointer to clocksource being read
> + * @now:	current cycle value
> + *
> + * Uses the clocksource to return the current cycle_t value.
> + * NOTE!!!: This is different from clocksource_read, because it
> + * returns the accumulated cycle value! Must hold xtime lock!
> + */
> +static inline cycle_t
> +clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> +{
> +	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> +	offset += cs->cycle_accumulated;
> +	return offset;
> +}
> +
> +/**
> + * clocksource_accumulate: - Accumulates clocksource cycles
> + * @cs:		pointer to clocksource being read
> + * @now:	current cycle value
> + *
> + * Used to avoids clocksource hardware overflow by periodically
> + * accumulating the current cycle delta. Must hold xtime write lock!
> + */
> +static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
> +{
> +	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> +	cs->cycle_last = now;
> +	cs->cycle_accumulated += offset;
> +}
> +
> +/**
>   * cyc2ns - converts clocksource cycles to nanoseconds
>   * @cs:		Pointer to clocksource
>   * @cycles:	Cycles
>   *
>   * Uses the clocksource and ntp ajdustment to convert cycle_ts to nanoseconds.
> + * Must hold xtime lock!
>   *
>   * XXX - This could use some mult_lxl_ll() asm optimization
>   */
> @@ -184,13 +224,27 @@ static inline s64 cyc2ns(struct clocksou
>  }
>  
>  /**
> + * ns2cyc - converts nanoseconds to clocksource cycles
> + * @cs:		Pointer to clocksource
> + * @nsecs:	Nanoseconds
> + */
> +static inline cycle_t ns2cyc(struct clocksource *cs, u64 nsecs)
> +{
> +	cycle_t ret = nsecs << cs->shift;
> +
> +	do_div(ret, cs->mult + 1);
> +
> +	return ret;
> +}
> +
> +/**
>   * clocksource_calculate_interval - Calculates a clocksource interval struct
>   *
>   * @c:		Pointer to clocksource.
>   * @length_nsec: Desired interval length in nanoseconds.
>   *
>   * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
> - * pair and interval request.
> + * pair and interval request. Must hold xtime_lock!
>   *
>   * Unless you're the timekeeping code, you should not be using this!
>   */
> Index: linux-mcount.git/kernel/time/timekeeping.c
> ===================================================================
> --- linux-mcount.git.orig/kernel/time/timekeeping.c	2008-01-30 14:35:51.000000000 -0500
> +++ linux-mcount.git/kernel/time/timekeeping.c	2008-01-30 14:54:12.000000000 -0500
> @@ -66,16 +66,10 @@ static struct clocksource *clock; /* poi
>   */
>  static inline s64 __get_nsec_offset(void)
>  {
> -	cycle_t cycle_now, cycle_delta;
> +	cycle_t cycle_delta;
>  	s64 ns_offset;
>  
> -	/* read clocksource: */
> -	cycle_now = clocksource_read(clock);
> -
> -	/* calculate the delta since the last update_wall_time: */
> -	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -
> -	/* convert to nanoseconds: */
> +	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
>  	ns_offset = cyc2ns(clock, cycle_delta);
>  
>  	return ns_offset;
> @@ -195,7 +189,7 @@ static void change_clocksource(void)
>  
>  	clock = new;
>  	clock->cycle_last = now;
> -
> +	clock->cycle_accumulated = 0;
>  	clock->error = 0;
>  	clock->xtime_nsec = 0;
>  	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
> @@ -205,9 +199,15 @@ static void change_clocksource(void)
>  	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
>  	       clock->name);
>  }
> +
> +void timekeeping_accumulate(void)
> +{
> +	clocksource_accumulate(clock, clocksource_read(clock));
> +}
>  #else
>  static inline void change_clocksource(void) { }
>  static inline s64 __get_nsec_offset(void) { return 0; }
> +void timekeeping_accumulate(void) { }
>  #endif
>  
>  /**
> @@ -302,6 +302,7 @@ static int timekeeping_resume(struct sys
>  	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
>  	/* re-base the last cycle value */
>  	clock->cycle_last = clocksource_read(clock);
> +	clock->cycle_accumulated = 0;
>  	clock->error = 0;
>  	timekeeping_suspended = 0;
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
> @@ -448,27 +449,28 @@ static void clocksource_adjust(s64 offse
>   */
>  void update_wall_time(void)
>  {
> -	cycle_t offset;
> +	cycle_t cycle_now;
>  
>  	/* Make sure we're fully resumed: */
>  	if (unlikely(timekeeping_suspended))
>  		return;
>  
>  #ifdef CONFIG_GENERIC_TIME
> -	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
> +	cycle_now = clocksource_read(clock);
>  #else
> -	offset = clock->cycle_interval;
> +	cycle_now = clock->cycle_last + clock->cycle_interval;
>  #endif
> +	clocksource_accumulate(clock, cycle_now);
> +
>  	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
>  
>  	/* normally this loop will run just once, however in the
>  	 * case of lost or late ticks, it will accumulate correctly.
>  	 */
> -	while (offset >= clock->cycle_interval) {
> +	while (clock->cycle_accumulated >= clock->cycle_interval) {
>  		/* accumulate one interval */
>  		clock->xtime_nsec += clock->xtime_interval;
> -		clock->cycle_last += clock->cycle_interval;
> -		offset -= clock->cycle_interval;
> +		clock->cycle_accumulated -= clock->cycle_interval;
>  
>  		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
>  			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
> @@ -482,13 +484,13 @@ void update_wall_time(void)
>  	}
>  
>  	/* correct the clock when NTP error is too big */
> -	clocksource_adjust(offset);
> +	clocksource_adjust(clock->cycle_accumulated);
>  
>  	/* store full nanoseconds into xtime */
>  	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
>  	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
>  
> -	update_xtime_cache(cyc2ns(clock, offset));
> +	update_xtime_cache(cyc2ns(clock, clock->cycle_accumulated));
>  
>  	/* check to see if there is a new clocksource to use */
>  	change_clocksource();
> Index: linux-mcount.git/arch/powerpc/kernel/time.c
> ===================================================================
> --- linux-mcount.git.orig/arch/powerpc/kernel/time.c	2008-01-30 14:35:51.000000000 -0500
> +++ linux-mcount.git/arch/powerpc/kernel/time.c	2008-01-30 14:54:12.000000000 -0500
> @@ -773,7 +773,8 @@ void update_vsyscall(struct timespec *wa
>  	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
>  	do_div(stamp_xsec, 1000000000);
>  	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
> -	update_gtod(clock->cycle_last, stamp_xsec, t2x);
> +	update_gtod(clock->cycle_last-clock->cycle_accumulated,
> +		    stamp_xsec, t2x);
>  }
>  
>  void update_vsyscall_tz(void)
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
