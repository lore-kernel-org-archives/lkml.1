Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbXHXSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbXHXSbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761477AbXHXSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:31:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33822 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbXHXSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:31:11 -0400
Subject: Re: [PATCH RT 3/3] fix get_monotonic_cycles for latency tracer
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1187978236.2941.19.camel@localhost.localdomain>
References: <1187978236.2941.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 11:30:44 -0700
Message-Id: <1187980244.6163.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 13:57 -0400, Steven Rostedt wrote:
> The latency tracer on SMP was given crazy results. It was found that the
> get_monotonic_cycles that it uses was not returning a monotonic counter.
> The cause of this was that clock->cycles_raw and clock->cycles_last can
> be updated on another CPU and make the cycles_now variable out-of-date.
> So the delta that was calculated from cycles_now - cycles_last was
> incorrect.
> 
> This patch adds a loop to make sure that the cycles_raw and cycles_last
> are consistent through out the calculation (otherwise it performs the
> loop again).
> 
> With this patch the latency_tracer can produce normal results again.

Ah! good catch. I totally missed that get_monotonic_cycles was being
called outside of the xtime lock.


> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-2.6-rt/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6-rt.orig/kernel/time/timekeeping.c	2007-08-24 11:41:04.000000000 -0400
> +++ linux-2.6-rt/kernel/time/timekeeping.c	2007-08-24 11:47:01.000000000 -0400
> @@ -75,15 +75,30 @@ s64 __get_nsec_offset(void)
> 
>  cycle_t notrace get_monotonic_cycles(void)
>  {
> -	cycle_t cycle_now, cycle_delta;
> +	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> 
> -	/* read clocksource: */
> -	cycle_now = clocksource_read(clock);
> +	do {
> +		/*
> +		 * cycle_raw and cycle_last can change on
> +		 * another CPU and we need the delta calculation
> +		 * of cycle_now and cycle_last happen atomic, as well
> +		 * as the adding to cycle_raw. We don't need to grab
> +		 * any locks, we just keep trying until get all the
> +		 * calculations together in one state.
> +		 */
> +		cycle_raw = clock->cycle_raw;
> +		cycle_last = clock->cycle_last;
> +
> +		/* read clocksource: */
> +		cycle_now = clocksource_read(clock);
> +
> +		/* calculate the delta since the last update_wall_time: */
> +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> 
> -	/* calculate the delta since the last update_wall_time: */
> -	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +	} while (cycle_raw != clock->cycle_raw ||
> +		 cycle_last != clock->cycle_last);

So if I'm understanding this right, not taking a lock isn't an
optimization (as the seq read lock code is almost the same), but a
requirement (as this might be called while xtime_lock is held),
correct? 

Might want to clarify that a bit in the comment.


> -	return clock->cycle_raw + cycle_delta;
> +	return cycle_raw + cycle_delta;
>  }
> 
>  unsigned long notrace cycles_to_usecs(cycle_t cycles)

Otherwise:
Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john


