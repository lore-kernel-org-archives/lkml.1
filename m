Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYGPIeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYGPIeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYGPIdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:33:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:44749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYGPIdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:33:50 -0400
Subject: Re: [patch 07/17] LTTng instrumentation - timer
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080715222747.520809773@polymtl.ca>
References: <20080715222604.331269462@polymtl.ca>
	 <20080715222747.520809773@polymtl.ca>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 10:34:11 +0200
Message-Id: <1216197251.5232.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> plain text document attachment (lttng-instrumentation-timer.patch)
> Instrument timer activity (timer set, expired, current time updates) to keep
> information about the "real time" flow within the kernel. It can be used by a
> trace analysis tool to synchronize information coming from various sources, e.g.
> to merge traces with system logs.
> 
> Those tracepoints are used by LTTng.
> 
> About the performance impact of tracepoints (which is comparable to markers),
> even without immediate values optimizations, tests done by Hideo Aoki on ia64
> show no regression. His test case was using hackbench on a kernel where
> scheduler instrumentation (about 5 events in code scheduler code) was added.
> See the "Tracepoints" patch header for performance result detail.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/trace/timer.h |   24 ++++++++++++++++++++++++
>  kernel/itimer.c       |    5 +++++
>  kernel/timer.c        |    8 +++++++-
>  3 files changed, 36 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/itimer.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/itimer.c	2008-07-15 14:49:14.000000000 -0400
> +++ linux-2.6-lttng/kernel/itimer.c	2008-07-15 15:14:28.000000000 -0400
> @@ -12,6 +12,7 @@
>  #include <linux/time.h>
>  #include <linux/posix-timers.h>
>  #include <linux/hrtimer.h>
> +#include <trace/timer.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -132,6 +133,8 @@ enum hrtimer_restart it_real_fn(struct h
>  	struct signal_struct *sig =
>  		container_of(timer, struct signal_struct, real_timer);
>  
> +	trace_timer_itimer_expired(sig);
> +
>  	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
>  
>  	return HRTIMER_NORESTART;
> @@ -157,6 +160,8 @@ int do_setitimer(int which, struct itime
>  	    !timeval_valid(&value->it_interval))
>  		return -EINVAL;
>  
> +	trace_timer_itimer_set(which, value);
> +
>  	switch (which) {
>  	case ITIMER_REAL:
>  again:
> Index: linux-2.6-lttng/kernel/timer.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/timer.c	2008-07-15 14:51:50.000000000 -0400
> +++ linux-2.6-lttng/kernel/timer.c	2008-07-15 15:14:28.000000000 -0400
> @@ -37,12 +37,14 @@
>  #include <linux/delay.h>
>  #include <linux/tick.h>
>  #include <linux/kallsyms.h>
> +#include <trace/timer.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
>  #include <asm/div64.h>
>  #include <asm/timex.h>
>  #include <asm/io.h>
> +#include <asm/irq_regs.h>
>  
>  u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
>  
> @@ -288,6 +290,7 @@ static void internal_add_timer(struct tv
>  		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
>  		vec = base->tv5.vec + i;
>  	}
> +	trace_timer_set(timer);
>  	/*
>  	 * Timers are FIFO:
>  	 */
> @@ -1066,6 +1069,7 @@ void do_timer(unsigned long ticks)
>  {
>  	jiffies_64 += ticks;
>  	update_times(ticks);
> +	trace_timer_update_time(&xtime, &wall_to_monotonic);
>  }

This is a very dangerous trace point - we're holding xtime lock here.

Ah, I see you make that comment below too, are you sure you want to do
this? 

Thomas, any input?

>  #ifdef __ARCH_WANT_SYS_ALARM
> @@ -1147,7 +1151,9 @@ asmlinkage long sys_getegid(void)
>  
>  static void process_timeout(unsigned long __data)
>  {
> -	wake_up_process((struct task_struct *)__data);
> +	struct task_struct *task = (struct task_struct *)__data;
> +	trace_timer_timeout(task);
> +	wake_up_process(task);
>  }
>  
>  /**
> Index: linux-2.6-lttng/include/trace/timer.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/trace/timer.h	2008-07-15 15:14:28.000000000 -0400
> @@ -0,0 +1,24 @@
> +#ifndef _TRACE_TIMER_H
> +#define _TRACE_TIMER_H
> +
> +#include <linux/tracepoint.h>
> +
> +DEFINE_TRACE(timer_itimer_expired,
> +	TPPROTO(struct signal_struct *sig),
> +	TPARGS(sig));
> +DEFINE_TRACE(timer_itimer_set,
> +	TPPROTO(int which, struct itimerval *value),
> +	TPARGS(which, value));
> +DEFINE_TRACE(timer_set,
> +	TPPROTO(struct timer_list *timer),
> +	TPARGS(timer));
> +/*
> + * xtime_lock is taken when kernel_timer_update_time tracepoint is reached.
> + */
> +DEFINE_TRACE(timer_update_time,
> +	TPPROTO(struct timespec *_xtime, struct timespec *_wall_to_monotonic),
> +	TPARGS(_xtime, _wall_to_monotonic));
> +DEFINE_TRACE(timer_timeout,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +#endif
> 

