Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbZKFBPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbZKFBPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZKFBPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:15:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbZKFBPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:15:17 -0500
Message-ID: <4AF3789F.8070904@cn.fujitsu.com>
Date: Fri, 06 Nov 2009 09:15:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] softirq,tracing: enable to trace softirq raise latency
References: <4AF284CF.3010407@cn.fujitsu.com> <20091105144349.GA8317@Krystal>
In-Reply-To: <20091105144349.GA8317@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> Add a tracepoint for tracing when softirq action is raised.
>>
>> It and the existed tracepoints complete softirq's tracepoints:
>> softirq_raise, softirq_entry and softirq_exit.
>>
>> And when this tracepoint is used in combination with
>> the softirq_entry tracepoint we can determine
>> the softirq raise latency.
>>
> 
> Hi Lai,
> 
> It generally looks good, we have a similar instrumentation point in the
> LTTng tree, and it's really useful. It's a good idea to instrument
> __raise_softirq_irqoff rather than just raise_softirq_irqoff: it
> includes the HI/TASKLET and HRTIMER softirqs.
> 
> There is just a small comment which should probably also be changed,
> please see below, besides that, you have my
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 75f3f00..b368d5d 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -18,6 +18,7 @@
>>  #include <asm/atomic.h>
>>  #include <asm/ptrace.h>
>>  #include <asm/system.h>
>> +#include <trace/events/irq.h>
>>  
>>  /*
>>   * These correspond to the IORESOURCE_IRQ_* defines in
>> @@ -372,7 +373,13 @@ asmlinkage void do_softirq(void);
>>  asmlinkage void __do_softirq(void);
>>  extern void open_softirq(int nr, void (*action)(struct softirq_action *));
>>  extern void softirq_init(void);
>> -#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
>> +
>> +static inline void __raise_softirq_irqoff(unsigned int nr)
>> +{
>> +	trace_softirq_raise(nr);
>> +	or_softirq_pending(1UL << nr);
>> +}
>> +
>>  extern void raise_softirq_irqoff(unsigned int nr);
>>  extern void raise_softirq(unsigned int nr);
>>  extern void wakeup_softirqd(void);
>> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
>> index dcfcd44..799af09 100644
>> --- a/include/trace/events/irq.h
>> +++ b/include/trace/events/irq.h
>> @@ -5,7 +5,9 @@
>>  #define _TRACE_IRQ_H
>>  
>>  #include <linux/tracepoint.h>
>> -#include <linux/interrupt.h>
>> +
>> +struct irqaction;
>> +struct softirq_action;
>>  
>>  #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
>>  #define show_softirq_name(val)				\
>> @@ -83,6 +85,32 @@ TRACE_EVENT(irq_handler_exit,
>>  );
>>  
>>  /**
>> + * softirq_raise - called immediately when a softirq is raised
>> + * @nr: softirq vector number
>> + *
>> + * Tracepoint for tracing when softirq action is raised.
>> + * Also, when used in combination with the softirq_entry tracepoint
>> + * we can determine the softirq raise latency.
>> + */
>> +TRACE_EVENT(softirq_raise,
>> +
>> +	TP_PROTO(unsigned int nr),
>> +
>> +	TP_ARGS(nr),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	unsigned int,	vec		)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->vec	= nr;
>> +	),
>> +
>> +	TP_printk("vec=%d [action=%s]", __entry->vec,
>> +		  show_softirq_name(__entry->vec))
>> +);
>> +
>> +/**
>>   * softirq_entry - called immediately before the softirq handler
>>   * @h: pointer to struct softirq_action
>>   * @vec: pointer to first struct softirq_action in softirq_vec array
> 
> Please change this comment to "@vec: softirq vector number" while you
> are at it. The same probably needs to be done for softirq_exit. @vec are
> not pointers: these are offsets.
> 

Thank you for you like it and your comment.

@vec are pointers here. it's softirq_vec. Don't need to change
these comments.

Lai
