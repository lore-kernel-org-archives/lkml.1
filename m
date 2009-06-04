Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZFDFiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZFDFiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZFDFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:38:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZFDFiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:38:07 -0400
Message-ID: <4A275DDC.6020507@cn.fujitsu.com>
Date: Thu, 04 Jun 2009 13:38:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com> <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain> <4A25E575.5000601@cn.fujitsu.com> <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:

> No, this is _wrong_. You need to look at the full source. I added some
> extra comments
> 
> 	new_base = __get_cpu_var(tvec_bases);
> 
> 	if (base != new_base) {
> 
> + 	   	 /* current timer base is on a different CPU */
> 
> 		/*
> 		 * We are trying to schedule the timer on the local CPU.
> 		 * However we can't change timer's base while it is running,
> 		 * otherwise del_timer_sync() can't detect that the timer's
> 		 * handler yet has not finished. This also guarantees that
> 		 * the timer is serialized wrt itself.
> 		 */
> 		if (likely(base->running_timer != timer)) {
> 			/* See the comment in lock_timer_base() */
> 			timer_set_base(timer, NULL);
> 			spin_unlock(&base->lock);
> 			base = new_base;
> 			spin_lock(&base->lock);
> 			timer_set_base(timer, base);
> -		}
> +		} else
> +		  /*
> +		   * we know that that
> +		   * the callback is running on a different CPU and we need
> +		   * to keep base unchanged, so smp_processor_id() is
> +		   * telling you the wrong information.
> +		   */
> +	}
> 
>> We can not add the timer to the current CPUs by using add_timer_on(), selects
> 
>   We can add the timer to the current CPU by using add_timer_on() as well.
> 
>> the timer base in this function as below code:
>> 	struct tvec_base *base = per_cpu(tvec_bases, cpu);
>> In this case, We can know the timer is added to 'cpu'.
>>
>> So, I add trace_timer_start() in __mod_timer() and add_timer_on()in my patch.
> 
>   Still in the __mod_timer() case the tracing info can be wrong and
>   tracing wrong information is worse than tracing no information.
> 
>   Your patch could result in a trace which confuses the hell out of
>   people looking at it:
> 
>   ....... 0..... activate_timer on cpu 0
>   
>   some time later
> 
>   ....... 2..... expire timer on cpu 2
> 
>   And the guy who needs to analyse that trace would rip his hairs out
>   to find out how the timer moved from cpu 0 to cpu 2
>  
>> In hrtimer, all timer is added to the current CPU which can be getted by using
>> smp_processor_id() in probe function, so it not has 'cpu' argument in my patch.
> 
>   Wrong again. Read the code in switch_hrtimer_base(). It does the
>   same thing as the timer base selection logic in __mod_timer()
>  

Hi tglx: 

Thanks for you correct my mistake again.  :-) 

It's hard to detect which cpu the timer add, we can remove the 'cpu' parameter
in trace_timer_start() as your suggestion, like this:

TRACE_EVENT(timer_start,

	TP_PROTO(struct timer_list *timer),

	TP_ARGS(timer),

	TP_STRUCT__entry(
		__field( void *,	timer		)
		__field( void *,	function	)
		__field( unsigned long,	expires		)
	),
	......
}

>> In addition, we do better not put trace_timer_start() and debug_timer_activate
>> in one function, have two reasons:
>> 1: for trace_timer_start()'s logic, the timer start event is completed in 
>>    internal_add_timer(), in other words: the timer is not start before
>>    internal_add_timer().
> 
>  Oh well. So where is the difference of tracing it before or after the
>  list add happened ? That's complete irrelevant.
>  

Yes, maybe it's not important.

>> 2: as Zhaolei says in the last mail, the timer's data may changed after
>>    debug_timer_activate().
> 
>  Really ? What is going to change ? Nothing in the normal case, in the
>  case the timer is active then it is removed first. Also it depends on
>  how you do this:
> 
> void debug_and_trace_timer_activate(....)
> {
> 	debug_timer_activate(...);
> 	trace_timer_activate(...);
> }
> 
> in the timer code:
> 
> -      debug_timer_activate(...);
> +      debug_and_trace_timer_activate(...);
> 
> So this does not change the order of functions at all, but it avoids
> sprinkling the real code with tons of extra crap.
> 

See below code:

static inline int
__mod_timer(......)
{
	......
	......
	
	debug_timer_activate(timer);

	new_base = __get_cpu_var(tvec_bases);
	......
	......
	
	timer->expires = expires;	*
	internal_add_timer(base, timer);
	trace_timer_start(...)
	......
}
( this example is in Zhaolei's reply)

timer->expires can be changed at *, if we put trace_timer_start() and
debug_timer_activate() together, we can't get the right value of timer->expires.

In addition, do you agree my humble opinion about not put __init_timer() and
debug_timer_init() together? (can be found at:
http://marc.info/?l=linux-kernel&m=124399744614127&w=2)
If you agree with it, we do better to detach other event.

Thanks,
Xiao Guangrong

> Thanks,
> 
> 	tglx
> 
> 
