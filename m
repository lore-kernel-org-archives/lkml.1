Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZFCCwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZFCCwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZFCCwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:52:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbZFCCwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:52:00 -0400
Message-ID: <4A25E575.5000601@cn.fujitsu.com>
Date: Wed, 03 Jun 2009 10:52:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com> <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Fri, 29 May 2009, Zhaolei wrote:
>> But, for trace_timer_start() in __mod_timer(), we need to put it after
>> timer->* changed.
> 
> Why ?
> 
>>> +	TP_fast_assign(
>>> +		__entry->timer		= timer;
>>> +		__entry->function	= timer->function;
>>> +		__entry->expires	= timer->expires;
>>> +		__entry->cpu		= cpu;
> 
> Again, neither timer nor function nor expires will change when the
> timer is added, right ?
> 
> The only unknown at this point is cpu. See below.
> 
>> Nevertheless, it don't means we need separate trace_timer_start() and
>> debug_timer_activate(), because we can put move debug_timer_activate() below,
>> as:
>> -	debug_timer_activate(timer);
>> 	...
>>  	timer->expires = expires;
>>  	internal_add_timer(base, timer);
>> +	debug_timer_activate(timer);
> 
> No, you can not call it with the base->lock held.
> 
>> +	trace_timer_start(timer, smp_processor_id());
> 
> Also using smp_processor_id() here is wrong. We do not necessarily add
> the timer to the current CPUs timer wheel. See the code which selects
> the timer base. So this information is rather useless, because the
> tracer knows anyway  on which CPU we are running.
> 
> Unfortunately we do not have an easy way to figure out to which CPU
> the base belongs (except if it's the base of the current CPU). There
> is not much we can do about that. But OTOH, this is not a problem
> because we see when the timer expires on which CPU it was enqueued. So
> scrapping the cpu entry in the trace completely is not a big loss.
> 
> The same applies to hrtimers as well.
> 

Hi tglx:

I also have different view here.  :-) 

As you say, "We do not necessarily add the timer to the current CPUs timer
wheel", but the timer is added to current CPU in __mod_timer(), selects the
timer base as below code:
	new_base = __get_cpu_var(tvec_bases);
In this case, we can use smp_processor_id() to get the CPU which timer is
added.

We can not add the timer to the current CPUs by using add_timer_on(), selects
the timer base in this function as below code:
	struct tvec_base *base = per_cpu(tvec_bases, cpu);
In this case, We can know the timer is added to 'cpu'.

So, I add trace_timer_start() in __mod_timer() and add_timer_on()in my patch.

In hrtimer, all timer is added to the current CPU which can be getted by using
smp_processor_id() in probe function, so it not has 'cpu' argument in my patch.

In addition, we do better not put trace_timer_start() and debug_timer_activate
in one function, have two reasons:
1: for trace_timer_start()'s logic, the timer start event is completed in 
   internal_add_timer(), in other words: the timer is not start before
   internal_add_timer().
	
2: as Zhaolei says in the last mail, the timer's data may changed after
   debug_timer_activate().

Thanks,
Xiao Guangrong

> 
> 	tglx
> 
> 
