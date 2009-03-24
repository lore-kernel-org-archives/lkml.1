Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZCXSWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZCXSWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbZCXSW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:22:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56327 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbZCXSW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:22:26 -0400
Date: Tue, 24 Mar 2009 19:21:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 6/9] LTTng instrumentation - timer
Message-ID: <20090324182122.GG31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.754766083@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.754766083@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Instrument timer activity (timer set, expired, current time 
> updates) to keep information about the "real time" flow within the 
> kernel. It can be used by a trace analysis tool to synchronize 
> information coming from various sources, e.g. to merge traces with 
> system logs.
> 
> Those tracepoints are used by LTTng.
> 
> About the performance impact of tracepoints (which is comparable 
> to markers), even without immediate values optimizations, tests 
> done by Hideo Aoki on ia64 show no regression. His test case was 
> using hackbench on a kernel where scheduler instrumentation (about 
> 5 events in code scheduler code) was added. See the "Tracepoints" 
> patch header for performance result detail.
> 
> Note : do_setitimer instrumentation could potentially be done with 
> a more generic system call instrumentation.
>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/trace/timer.h |   24 ++++++++++++++++++++++++
>  kernel/itimer.c       |    8 ++++++++
>  kernel/timer.c        |   12 +++++++++++-
>  3 files changed, 43 insertions(+), 1 deletion(-)

For complete timer instrumentation, hrtimers should be instrumented 
as well.

>  	return HRTIMER_NORESTART;
> @@ -148,6 +154,8 @@ int do_setitimer(int which, struct itime
>  	    !timeval_valid(&value->it_interval))
>  		return -EINVAL;
>  
> +	trace_timer_itimer_set(which, value);

for consistency, i'd name the timer start tracepoints the following 
way:

  trace_timer_init()
  trace_itimer_init()
  trace_hrtimer_init()

  trace_timer_start()
  trace_itimer_start()
  trace_hrtimer_start()

  trace_timer_expire()
  trace_itimer_expire()
  trace_hrtimer_expire()

  trace_timer_cancel()
  trace_itimer_cancel()
  trace_hrtimer_cancel()

the init methods are missing from your patch entirely - and the rest 
is partially incomplete as well.

Instrumentation of the del_timer() variants is missing. For a 
complete lifetime analysis of timers this cannot be left out.

> +DEFINE_TRACE(timer_set);
> +DEFINE_TRACE(timer_timeout);

these two should be 'timer_start' and 'timer_expire'.

> +DEFINE_TRACE(timer_update_time);

This is a misnomer. This is in timer.c but is not a 'timer' 
tracepoint - this is a time of day tracepoint - and this should be 
reflected in its naming - so it should be: trace_gtod_update_xtime() 
or so.

> @@ -357,6 +363,7 @@ static void internal_add_timer(struct tv
>  		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
>  		vec = base->tv5.vec + i;
>  	}
> +	trace_timer_set(timer);
>  	/*
>  	 * Timers are FIFO:
>  	 */

this should be trace_timer_start().

> @@ -1121,6 +1128,7 @@ void do_timer(unsigned long ticks)
>  {
>  	jiffies_64 += ticks;
>  	update_times(ticks);
> +	trace_timer_update_time(&xtime, &wall_to_monotonic);
>  }

gtod_update_xtime().

The GTOD instrumentation should move into a separate patch, and 
should probably be extended with NTP correction events as well.

>  #ifdef __ARCH_WANT_SYS_ALARM
> @@ -1202,7 +1210,9 @@ SYSCALL_DEFINE0(getegid)
>  
>  static void process_timeout(unsigned long __data)
>  {
> -	wake_up_process((struct task_struct *)__data);
> +	struct task_struct *task = (struct task_struct *)__data;
> +	trace_timer_timeout(task);
> +	wake_up_process(task);

[ nit: misssing new line after local variable declaration. ]

this should be trace_timer_expire().

> Index: linux-2.6-lttng/include/trace/timer.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/trace/timer.h	2009-03-24 09:31:51.000000000 -0400
> @@ -0,0 +1,24 @@
> +#ifndef _TRACE_TIMER_H
> +#define _TRACE_TIMER_H
> +
> +#include <linux/tracepoint.h>
> +
> +DECLARE_TRACE(timer_itimer_expired,
> +	TPPROTO(struct signal_struct *sig),
> +		TPARGS(sig));
> +DECLARE_TRACE(timer_itimer_set,
> +	TPPROTO(int which, struct itimerval *value),
> +		TPARGS(which, value));
> +DECLARE_TRACE(timer_set,
> +	TPPROTO(struct timer_list *timer),
> +		TPARGS(timer));
> +/*
> + * xtime_lock is taken when kernel_timer_update_time tracepoint is reached.
> + */
> +DECLARE_TRACE(timer_update_time,
> +	TPPROTO(struct timespec *_xtime, struct timespec *_wall_to_monotonic),
> +		TPARGS(_xtime, _wall_to_monotonic));
> +DECLARE_TRACE(timer_timeout,
> +	TPPROTO(struct task_struct *p),
> +		TPARGS(p));
> +#endif

For completeness and consistency, trace_itimer_start() should be 
split into two cases:

	if (value)
		trace_itimer_start(which, value);
	else
		trace_itimer_cancel(which);

That extra branch does not matter much and the resulting 
instrumentaton is more consistent across all the timer types.

So this patch needs more work, but it's a good first step.

It would also be fantastic if you did them via the TRACE_EVENT() 
mechanism in the tracing tree. It would still be just as useful to 
LTTNG - but it would also be useful to ftrace that way.

Thanks,

	Ingo
