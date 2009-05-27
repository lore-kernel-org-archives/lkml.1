Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbZE0J2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbZE0J2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbZE0J2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:28:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65250 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759196AbZE0J2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:28:07 -0400
Message-ID: <4A1D07C8.6010002@cn.fujitsu.com>
Date: Wed, 27 May 2009 17:28:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Anton Blanchard <anton@samba.org>, rostedt@goodmis.org, mingo@elte.hu,
       tzanussi@gmail.com, jbaron@redhat.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer	tracepoints
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526180600.GA5969@nowhere>
In-Reply-To: <20090526180600.GA5969@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Tue, May 26, 2009 at 02:26:43PM +1000, Anton Blanchard wrote:
>> Add tracepoints for timer and high res timer execution. We add entry and
>> exit tracepoints so we can calculate timer latency.
> 
> 
> Your work looks very similar to Xiao Guangrong's patches.
> 
> See:
> 
> ftrace: add tracepoint for timer
> ftrace: add tracepoint for itimer
> ftrace: add tracepoint for hrimer
> 
> I'm not sure which one should be picked between
> his patches and yours.
> 

Hi Frederic:

In fact, Anton Blanchard's is different from my patch.
My patch is used for trace timer lifecycle(init/start/expire/cancel), and his
patch is mostly used for trace the execution time of timer function.

Thanks,
Xiao Guangrong

> Frederic.
> 
>  
>> Example ftrace output:
>>
>> <idle>-0     [000]   264.040506: hrtimer_entry: func=.tick_sched_timer
>> <idle>-0     [000]   264.040508: hrtimer_exit: func=.tick_sched_timer restart=HRTIMER_RESTART
>> <idle>-0     [000]   264.040530: timer_entry: func=.e1000_watchdog
>> <idle>-0     [000]   264.040728: timer_exit: func=.e1000_watchdog
>>
>> Here we can see e1000_watchdog is taking 0.2ms - it might make sense to
>> move this into a workqueue or kernel thread.
>>
>> Signed-off-by: Anton Blanchard <anton@samba.org>
>> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>
>> v2: Changed %pF to %pf to remove always 0 function offset.
>>
>> Index: linux-2.6-master/kernel/hrtimer.c
>> ===================================================================
>> --- linux-2.6-master.orig/kernel/hrtimer.c	2009-05-26 12:55:35.000000000 +1000
>> +++ linux-2.6-master/kernel/hrtimer.c	2009-05-26 13:09:55.000000000 +1000
>> @@ -46,6 +46,8 @@
>>  
>>  #include <asm/uaccess.h>
>>  
>> +#include <trace/events/timer.h>
>> +
>>  /**
>>   * ktime_get - get the monotonic time in ktime_t format
>>   *
>> @@ -1161,7 +1163,9 @@
>>  	 * the timer base.
>>  	 */
>>  	spin_unlock(&cpu_base->lock);
>> +	trace_hrtimer_entry(timer);
>>  	restart = fn(timer);
>> +	trace_hrtimer_exit(timer, restart);
>>  	spin_lock(&cpu_base->lock);
>>  
>>  	/*
>> Index: linux-2.6-master/kernel/timer.c
>> ===================================================================
>> --- linux-2.6-master.orig/kernel/timer.c	2009-05-26 12:55:35.000000000 +1000
>> +++ linux-2.6-master/kernel/timer.c	2009-05-26 13:09:55.000000000 +1000
>> @@ -45,6 +45,9 @@
>>  #include <asm/timex.h>
>>  #include <asm/io.h>
>>  
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/timer.h>
>> +
>>  u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
>>  
>>  EXPORT_SYMBOL(jiffies_64);
>> @@ -947,7 +950,9 @@
>>  				 */
>>  				lock_map_acquire(&lockdep_map);
>>  
>> +				trace_timer_entry(timer);
>>  				fn(data);
>> +				trace_timer_exit(timer);
>>  
>>  				lock_map_release(&lockdep_map);
>>  
>> Index: linux-2.6-master/include/trace/events/timer.h
>> ===================================================================
>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>> +++ linux-2.6-master/include/trace/events/timer.h	2009-05-26 13:57:42.000000000 +1000
>> @@ -0,0 +1,116 @@
>> +#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_TIMER_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <linux/timer.h>
>> +#include <linux/hrtimer.h>
>> +
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM timer
>> +
>> +/**
>> + * timer_entry - called immediately before the timer
>> + * @timer: pointer to struct timer_list
>> + *
>> + * When used in combination with the timer_exit tracepoint we can
>> + * determine the timer latency.
>> + */
>> +TRACE_EVENT(timer_entry,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(void *, function)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->function = timer->function;
>> +	),
>> +
>> +	TP_printk("func=%pf", __entry->function)
>> +);
>> +
>> +/**
>> + * timer_exit - called immediately after the timer returns
>> + * @timer: pointer to struct timer_list
>> + *
>> + * When used in combination with the timer_entry tracepoint we can
>> + * determine the timer latency.
>> + */
>> +TRACE_EVENT(timer_exit,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(void *, function)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->function = timer->function;
>> +	),
>> +
>> +	TP_printk("func=%pf", __entry->function)
>> +);
>> +
>> +/**
>> + * hrtimer_entry - called immediately before the high res timer
>> + * @timer: pointer to struct hrtimer
>> + *
>> + * When used in combination with the hrtimer_exit tracepoint we can
>> + * determine the high res timer latency.
>> + */
>> +TRACE_EVENT(hrtimer_entry,
>> +
>> +	TP_PROTO(struct hrtimer *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(void *, function)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->function = timer->function;
>> +	),
>> +
>> +	TP_printk("func=%pf", __entry->function)
>> +);
>> +
>> +/**
>> + * hrtimer_exit - called immediately after the high res timer returns
>> + * @timer: pointer to struct hrtimer
>> + * @restart: high res timer return value
>> + *
>> + * High res timer will restart if @restart is set to HRTIMER_RESTART.
>> + * When used in combination with the hrtimer_entry tracepoint we can
>> + * determine the high res timer latency.
>> + */
>> +TRACE_EVENT(hrtimer_exit,
>> +
>> +	TP_PROTO(struct hrtimer *timer, int restart),
>> +
>> +	TP_ARGS(timer, restart),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(void *, function) +		__field(int, restart)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->function = timer->function;
>> +		__entry->restart = restart;
>> +	),
>> +
>> +	TP_printk("func=%pf restart=%s", __entry->function,
>> +		(__entry->restart == HRTIMER_RESTART) ?
>> +			"HRTIMER_RESTART" : "HRTIMER_NORESTART")
>> +);
>> +
>> +#endif /*  _TRACE_TIMER_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
