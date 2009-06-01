Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZFAJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZFAJK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZFAJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:10:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbZFAJKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:10:19 -0400
Message-ID: <4A239A92.60708@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 17:08:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: Re: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com> <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
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

Hello, Thomas

Thanks for your review.

Please see my explain below.

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

Sorry for my poor English.
I don't means that internal_add_timer() will change timer->*.
My meaning is:
	timer->expires = expires; *
	internal_add_timer(base, timer);

*: timer->expires is changed here, so trace_timer_start() need to called below
   this line. If we call debug_timer_activate() and trace_timer_start() together,
   we need to move debug_timer_activate() to place below this line too.

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

Indeed.
We can remove smp_processor_id() from trace_timer_start()'s argument.

Xiao Guangrong, author of this patch is in vacation these days, and will come
back recently.
Maybe we want to hear his opinion about this fix.

Thanks
Zhaolei

