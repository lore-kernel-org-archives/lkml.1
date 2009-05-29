Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZE2CC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZE2CC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 22:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZE2CCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 22:02:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZE2CCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 22:02:18 -0400
Message-ID: <4A1F41C5.7000803@cn.fujitsu.com>
Date: Fri, 29 May 2009 10:00:37 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 27 May 2009, Xiao Guangrong wrote:
>>>> +	TP_printk("timer=%p func=%pf expires=%lu cpu=%d", __entry->timer,
>>>> +		  __entry->function, __entry->expires, __entry->cpu)
>>>> +);
>>>   How do we connect the trace to the jiffies value when the timer
>>>   was started ?
>>>
>> ftrace already have time information in trace event's output, we can use it instead
> 
>   Hmm, I'm not sure whether we can see the jiffies value there, but ok. 
>  
>>>> @@ -547,6 +550,7 @@ void init_timer_key(struct timer_list *timer,
>>>>  {
>>>>  	debug_timer_init(timer);
>>>>  	__init_timer(timer, name, key);
>>>> +	trace_timer_init(timer);
>>>   Can we please avoid to have two debug calls in one 2 line function ?
>>>
>> debug_timer_init() must call before object's init, but tracepoint have to call
>> after object's init beacuse if we move the tracepoint to before object init, the
>> object has no data yet.
> 
>   Err.
> 
>>>> + TRACE_EVENT(timer_init,
>>>> +
>>>> + TP_PROTO(struct timer_list *timer),
>>>> +
>>>> + TP_ARGS(timer),
>>>> +
>>>> + TP_STRUCT__entry(
>>>> + __field( void *, timer )
>>>> + ),
>>>> +
>>>> + TP_fast_assign(
>>>> + __entry->timer = timer;
>>>> + ),
>>>> +
>>>> + TP_printk("timer=%p", __entry->timer)
>>>> +);
> 
>   Is timer different before and after the __init_timer call ?

Hello, Thomas

Yes, timer's pointer is same before and after __init_timer().
We don't need to put debug_timer_init() and trace_timer_init() into different
place.

But, for trace_timer_start() in __mod_timer(), we need to put it after
timer->* changed.
Nevertheless, it don't means we need separate trace_timer_start() and
debug_timer_activate(), because we can put move debug_timer_activate() below,
as:
-	debug_timer_activate(timer);
	...
 	timer->expires = expires;
 	internal_add_timer(base, timer);
+	debug_timer_activate(timer);
+	trace_timer_start(timer, smp_processor_id());

Then we can also combine debug_timer_activate() and trace_timer_start() into
one function.

So we'll do what you suggested.

Thanks
Zhaolei

