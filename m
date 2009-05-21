Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZEUAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZEUAB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZEUABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:01:21 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39413 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbZEUABU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BpsMwE1X1b1fdVZR0dOrXqbm/IWmmVGKumYEya/Lcf3/mJlzqrvKXp131QVEU/hodk
         RD6gwwODGOY0fHYF+CYQFfV3WJzEtBKR/bzOfCCYIwfQYY6wrz/KF5Ezmw0cC1U6bKfg
         60eX+DgNWByAE4wcLLBXTMHiuNdDrHeSrLK6o=
MIME-Version: 1.0
In-Reply-To: <20090520101334.GA23442@kryten>
References: <20090520101334.GA23442@kryten>
Date: Thu, 21 May 2009 02:01:20 +0200
Message-ID: <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com>
Subject: Re: [PATCH] tracing/events: Add timer and high res timer tracepoints
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/20 Anton Blanchard <anton@samba.org>:
>
> Add tracepoints for timer and high res timer execution. We add entry and
> exit tracepoints so we can calculate timer latency.
>
> Example ftrace output:
>
> <idle>-0     [000]   264.040506: hrtimer_entry: func=.tick_sched_timer+0x0/0xf0
> <idle>-0     [000]   264.040508: hrtimer_exit: func=.tick_sched_timer+0x0/0xf0 restart=HRTIMER_RESTART
> <idle>-0     [000]   264.040530: timer_entry: func=.e1000_watchdog+0x0/0x8fc
> <idle>-0     [000]   264.040728: timer_exit: func=.e1000_watchdog+0x0/0x8fc
>
> Here we can see e1000_watchdog is taking 0.2ms - it might make sense to
> move this into a workqueue or kernel thread.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> Index: linux-2.6-tracing/kernel/hrtimer.c
> ===================================================================
> --- linux-2.6-tracing.orig/kernel/hrtimer.c     2009-05-20 17:11:50.000000000 +1000
> +++ linux-2.6-tracing/kernel/hrtimer.c  2009-05-20 17:11:52.000000000 +1000
> @@ -46,6 +46,8 @@
>
>  #include <asm/uaccess.h>
>
> +#include <trace/events/timer.h>
> +
>  /**
>  * ktime_get - get the monotonic time in ktime_t format
>  *
> @@ -1161,7 +1163,9 @@
>         * the timer base.
>         */
>        spin_unlock(&cpu_base->lock);
> +       trace_hrtimer_entry(timer);
>        restart = fn(timer);
> +       trace_hrtimer_exit(timer, restart);
>        spin_lock(&cpu_base->lock);
>
>        /*
> Index: linux-2.6-tracing/kernel/timer.c
> ===================================================================
> --- linux-2.6-tracing.orig/kernel/timer.c       2009-05-20 17:11:50.000000000 +1000
> +++ linux-2.6-tracing/kernel/timer.c    2009-05-20 17:11:52.000000000 +1000
> @@ -44,6 +44,9 @@
>  #include <asm/timex.h>
>  #include <asm/io.h>
>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/timer.h>
> +
>  u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
>
>  EXPORT_SYMBOL(jiffies_64);
> @@ -946,7 +949,9 @@
>                                 */
>                                lock_map_acquire(&lockdep_map);
>
> +                               trace_timer_entry(timer);
>                                fn(data);
> +                               trace_timer_exit(timer);
>
>                                lock_map_release(&lockdep_map);
>
> Index: linux-2.6-tracing/include/trace/events/timer.h
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-tracing/include/trace/events/timer.h      2009-05-20 17:15:41.000000000 +1000
> @@ -0,0 +1,116 @@
> +#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_TIMER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/timer.h>
> +#include <linux/hrtimer.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM timer
> +
> +/**
> + * timer_entry - called immediately before the timer
> + * @timer: pointer to struct timer_list
> + *
> + * When used in combination with the timer_exit tracepoint we can
> + * determine the timer latency.
> + */
> +TRACE_EVENT(timer_entry,
> +
> +       TP_PROTO(struct timer_list *timer),
> +
> +       TP_ARGS(timer),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, function)



void * won't make the filtering easier.
It would require the raw address whereas it would be nice to filter
by function name.

But saving the address instead of the resolved name is faster.

I guess we should add a filter feature to resolve a function name to
its address.



> +       ),
> +
> +       TP_fast_assign(
> +               __entry->function = timer->function;
> +       ),
> +
> +       TP_printk("func=%pF", __entry->function)


Please use %pf which only prints the function name and ignore the
offsets and so... These overload
the trace in such case.

Thanks,
Frederic.



> +);
> +
> +/**
> + * timer_exit - called immediately after the timer returns
> + * @timer: pointer to struct timer_list
> + *
> + * When used in combination with the timer_entry tracepoint we can
> + * determine the timer latency.
> + */
> +TRACE_EVENT(timer_exit,
> +
> +       TP_PROTO(struct timer_list *timer),
> +
> +       TP_ARGS(timer),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, function)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->function = timer->function;
> +       ),
> +
> +       TP_printk("func=%pF", __entry->function)
> +);
> +
> +/**
> + * hrtimer_entry - called immediately before the high res timer
> + * @timer: pointer to struct hrtimer
> + *
> + * When used in combination with the hrtimer_exit tracepoint we can
> + * determine the high res timer latency.
> + */
> +TRACE_EVENT(hrtimer_entry,
> +
> +       TP_PROTO(struct hrtimer *timer),
> +
> +       TP_ARGS(timer),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, function)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->function = timer->function;
> +       ),
> +
> +       TP_printk("func=%pF", __entry->function)
> +);
> +
> +/**
> + * hrtimer_exit - called immediately after the high res timer returns
> + * @timer: pointer to struct hrtimer
> + * @restart: high res timer return value
> + *
> + * High res timer will restart if @restart is set to HRTIMER_RESTART.
> + * When used in combination with the hrtimer_entry tracepoint we can
> + * determine the high res timer latency.
> + */
> +TRACE_EVENT(hrtimer_exit,
> +
> +       TP_PROTO(struct hrtimer *timer, int restart),
> +
> +       TP_ARGS(timer, restart),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, function)
> +               __field(int, restart)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->function = timer->function;
> +               __entry->restart = restart;
> +       ),
> +
> +       TP_printk("func=%pF restart=%s", __entry->function,
> +               (__entry->restart == HRTIMER_RESTART) ?
> +                       "HRTIMER_RESTART" : "HRTIMER_NORESTART")
> +);
> +
> +#endif /*  _TRACE_TIMER_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
