Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYAPXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYAPXeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYAPXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:33:57 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:51809 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYAPXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:33:56 -0500
Date: Wed, 16 Jan 2008 18:33:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: john stultz <johnstul@us.ibm.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <1200523867.6127.5.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>  <20080109233044.777564395@goodmis.org>
  <20080115214636.GD17439@Krystal>  <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
  <20080115220824.GB22242@Krystal>  <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
  <20080116031730.GA2164@Krystal>  <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
  <20080116145604.GB31329@Krystal>  <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks John for doing this!

(comments imbedded)

On Wed, 16 Jan 2008, john stultz wrote:

>
> On Wed, 2008-01-16 at 14:36 -0800, john stultz wrote:
>
> Completely un-tested, but it builds, so I figured I'd send it out for
> review.

heh, ok, I'll take it and run it.

>
> I'm not super sure the update or the read doesn't need something
> additional to force a memory access, but as I didn't see anything
> special in Mathieu's implementation, I'm going to guess this is ok.
>
> Mathieu, Let me know if this isn't what you're suggesting.
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
>
> Index: monotonic-cleanup/include/linux/clocksource.h
> ===================================================================
> --- monotonic-cleanup.orig/include/linux/clocksource.h	2008-01-16 12:22:04.000000000 -0800
> +++ monotonic-cleanup/include/linux/clocksource.h	2008-01-16 14:41:31.000000000 -0800
> @@ -87,9 +87,17 @@
>  	 * more than one cache line.
>  	 */
>  	struct {
> -		cycle_t cycle_last, cycle_accumulated, cycle_raw;
> -	} ____cacheline_aligned_in_smp;
> +		cycle_t cycle_last, cycle_accumulated;
>
> +		/* base structure provides lock-free read
> +		 * access to a virtualized 64bit counter
> +		 * Uses RCU-like update.
> +		 */
> +		struct {
> +			cycle_t cycle_base_last, cycle_base;
> +		} base[2];
> +		int base_num;
> +	} ____cacheline_aligned_in_smp;
>  	u64 xtime_nsec;
>  	s64 error;
>
> @@ -175,19 +183,21 @@
>  }
>
>  /**
> - * clocksource_get_cycles: - Access the clocksource's accumulated cycle value
> + * clocksource_get_basecycles: - get the clocksource's accumulated cycle value
>   * @cs:		pointer to clocksource being read
>   * @now:	current cycle value
>   *
>   * Uses the clocksource to return the current cycle_t value.
>   * NOTE!!!: This is different from clocksource_read, because it
> - * returns the accumulated cycle value! Must hold xtime lock!
> + * returns a 64bit wide accumulated value.
>   */
>  static inline cycle_t
> -clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> +clocksource_get_basecycles(struct clocksource *cs, cycle_t now)
>  {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> -	offset += cs->cycle_accumulated;
> +	int num = cs->base_num;
> +	cycle_t offset = (now - cs->base[num].cycle_base_last);
> +	offset &= cs->mask;
> +	offset += cs->base[num].cycle_base;
>  	return offset;
>  }
>
> @@ -197,14 +207,25 @@
>   * @now:	current cycle value
>   *
>   * Used to avoids clocksource hardware overflow by periodically
> - * accumulating the current cycle delta. Must hold xtime write lock!
> + * accumulating the current cycle delta. Uses RCU-like update, but
> + * ***still requires the xtime_lock is held for writing!***
>   */
>  static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
>  {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> +	/* First update the monotonic base portion.
> +	 * The dual array update method allows for lock-free reading.
> +	 */
> +	int num = !cs->base_num;
> +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> +	offset &= cs->mask;
> +	cs->base[num].cycle_base = cs->base[!num].cycle_base + offset;
> +	cs->base[num].cycle_base_last = now;

I would think that we would need some sort of barrier here. Otherwise,
base_num could be updated before all the cycle_base. I'd expect a smp_wmb
is needed.

> +	cs->base_num = num;
> +
> +	/* Now update the cycle_accumulated portion */
> +	offset = (now - cs->cycle_last) & cs->mask;
>  	cs->cycle_last = now;
>  	cs->cycle_accumulated += offset;
> -	cs->cycle_raw += offset;
>  }
>
>  /**
> Index: monotonic-cleanup/kernel/time/timekeeping.c
> ===================================================================
> --- monotonic-cleanup.orig/kernel/time/timekeeping.c	2008-01-16 12:21:46.000000000 -0800
> +++ monotonic-cleanup/kernel/time/timekeeping.c	2008-01-16 14:15:31.000000000 -0800
> @@ -71,10 +71,12 @@
>   */
>  static inline s64 __get_nsec_offset(void)
>  {
> -	cycle_t cycle_delta;
> +	cycle_t now, cycle_delta;
>  	s64 ns_offset;
>
> -	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
> +	now = clocksource_read(clock);
> +	cycle_delta = (now - clock->cycle_last) & clock->mask;
> +	cycle_delta += clock->cycle_accumulated;

Is the above just to decouple the two methods?

>  	ns_offset = cyc2ns(clock, cycle_delta);
>
>  	return ns_offset;
> @@ -105,35 +107,7 @@
>
>  cycle_t notrace get_monotonic_cycles(void)
>  {
> -	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> -
> -	do {
> -		/*
> -		 * cycle_raw and cycle_last can change on
> -		 * another CPU and we need the delta calculation
> -		 * of cycle_now and cycle_last happen atomic, as well
> -		 * as the adding to cycle_raw. We don't need to grab
> -		 * any locks, we just keep trying until get all the
> -		 * calculations together in one state.
> -		 *
> -		 * In fact, we __cant__ grab any locks. This
> -		 * function is called from the latency_tracer which can
> -		 * be called anywhere. To grab any locks (including
> -		 * seq_locks) we risk putting ourselves into a deadlock.
> -		 */
> -		cycle_raw = clock->cycle_raw;
> -		cycle_last = clock->cycle_last;
> -
> -		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> -
> -	} while (cycle_raw != clock->cycle_raw ||
> -		 cycle_last != clock->cycle_last);
> -
> -	return cycle_raw + cycle_delta;
> +	return clocksource_get_basecycles(clock, clocksource_read(clock));

Nice ;-)

>  }
>
>  unsigned long notrace cycles_to_usecs(cycle_t cycles)

-- Steve

