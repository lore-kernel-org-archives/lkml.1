Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZGTHZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZGTHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGTHZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:25:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZGTHZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:25:55 -0400
Message-ID: <4A641BFC.2050508@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 15:25:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
References: <4A604E46.5050903@cn.fujitsu.com>	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>
In-Reply-To: <1247827801.15751.4.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for your review.

Peter Zijlstra wrote:

>> +static inline void debug_and_trace_hrtimer_deactivate(struct hrtimer *timer)
>> +{
>> +	debug_hrtimer_deactivate(timer);
>> +	trace_hrtimer_cancel(timer);
>> +}
> 
> I would argue that tracing is a form of debugging and you shouldn't need
> to mangle these names like that, simply leave them debug_*().
> 

I think this makes sense. I'll fix it unless Thomas has objections.

> 
>> @@ -1162,9 +1182,8 @@ static void __run_hrtimer(struct hrtimer *timer)
>>  	 * the timer base.
>>  	 */
>>  	spin_unlock(&cpu_base->lock);
>> -	trace_hrtimer_entry(timer);
>>  	restart = fn(timer);
>> -	trace_hrtimer_exit(timer, restart);
>> +	trace_hrtimer_callback_done(timer);
>>  	spin_lock(&cpu_base->lock);
>>  
>>  	/*
> 
> Why bother introducing these tracepoints if you're going to remove them
> in the same patch-set?
> 

Actually I'm renaming them but not removing them.

I can drop the first patch and merge it into the latter patches,
but that will lose the credit for Anton Blanchard

> Also, the below:
> 
>> @@ -1275,6 +1294,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>>  				break;
>>  			}
>>  
>> +			trace_hrtimer_expire(timer, basenow.tv64);
>>  			__run_hrtimer(timer);
>>  		}
>>  		base++;
>> @@ -1397,6 +1417,7 @@ void hrtimer_run_queues(void)
>>  					hrtimer_get_expires_tv64(timer))
>>  				break;
>>  
>> +			trace_hrtimer_expire(timer, base->softirq_time.tv64);
>>  			__run_hrtimer(timer);
>>  		}
>>  		spin_unlock(&cpu_base->lock);
> 
> indicates you placed that tracepoint in the wrong place.
> 
> Furthermore, I don't get why you want it there and not on the old
> _entry() site, because this adds all kinds of extra overhead and you
> loose the exact callback timings.
> 

Yes, it's true, but the loose is only about 1 microsecond as I tested it.
Do you think it's acceptable or not?

If we put trace_hrtimer_expire() on the old _entry() site, then we can't
get the timestamps when hrtimer expires, which is used to calculate the
latency of hrtimer.

You can see the mail which I send to Thomas last week, can be found here:
	http://marc.info/?l=linux-kernel&m=124762164322497&w=2)


Thanks,
Xiao

> 
> 
> 
