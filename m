Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbZE0HiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbZE0HiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763589AbZE0Hfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:35:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762502AbZE0Hfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:35:34 -0400
Message-ID: <4A1CED66.7030805@cn.fujitsu.com>
Date: Wed, 27 May 2009 15:36:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Fri, 22 May 2009, Xiao Guangrong wrote:
> 
>> This patch is modify from Mathieu's patch base on ingo's suggestion, the original patch
>> can be found here: 
>> 	http://marc.info/?l=linux-kernel&m=123791201816247&w=2
> 
>   I have a hard time to connect this patch to the original one.
>  

There are some timer hook in Mathieu's patch, I just modify the tracepoint name and
add the tracepoint in other suitable place.

>> +TRACE_EVENT(timer_start,
>> +
>> +	TP_PROTO(struct timer_list *timer, int cpu),
>> +
>> +	TP_ARGS(timer, cpu),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,	function	)
>> +		__field( unsigned long,	expires		)
>> +		__field( int,		cpu		)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->timer		= timer;
>> +		__entry->function	= timer->function;
>> +		__entry->expires	= timer->expires;
>> +		__entry->cpu		= cpu;
>> +	),
>> +
>> +	TP_printk("timer=%p func=%pf expires=%lu cpu=%d", __entry->timer,
>> +		  __entry->function, __entry->expires, __entry->cpu)
>> +);
> 
>   How do we connect the trace to the jiffies value when the timer
>   was started ?
> 

ftrace already have time information in trace event's output, we can use it instead

>> +
>> +TRACE_EVENT(timer_expire,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,        function	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->timer		= timer;
>> +		__entry->function       = timer->function;
>> +	),
>> +
>> +	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
>> +);
> 
>   Ditto.
> 

Yes, you are right, I'll remove __entry->function in v2 patch

>> +TRACE_EVENT(timer_cancel,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,        function        )
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->timer		= timer;
>> +		__entry->function	= timer->function;
>> +	),
>> +
>> +	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
>> +);
> 
>   Same here.
> 
>> @@ -547,6 +550,7 @@ void init_timer_key(struct timer_list *timer,
>>  {
>>  	debug_timer_init(timer);
>>  	__init_timer(timer, name, key);
>> +	trace_timer_init(timer);
> 
>   Can we please avoid to have two debug calls in one 2 line function ?
> 

debug_timer_init() must call before object's init, but tracepoint have to call
after object's init beacuse if we move the tracepoint to before object init, the
object has no data yet.

>>  }
>>  EXPORT_SYMBOL(init_timer_key);
>>  
>> @@ -565,6 +569,7 @@ static inline void detach_timer(struct timer_list *timer,
>>  	struct list_head *entry = &timer->entry;
>>  
>>  	debug_timer_deactivate(timer);
>> +	trace_timer_cancel(timer);
> 
>   Ditto. Please create one debug entity which covers both.
>

IMHO, we can't create one entity for init event, so we do better detach other event.

for example:  

in init event:
void init_timer_key(...)
{
	debug_timer_init(timer); 
	__init_timer(timer, name, key);
	trace_timer_init(timer); 
}
 
but in detach event ():
void detach_timer(...)
{
	......
	trace_timer_deactivate()
}

void trace_timer_deactivate()
{
	debug_timer_deactivate(timer);
	trace_timer_cancel(timer);
}
 
it's  disunity for us.

Thanks,
Xiao Guangrong
 
>   ....
> 
> Thanks,
> 
> 	tglx
> 
> 
