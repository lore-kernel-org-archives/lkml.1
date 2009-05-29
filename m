Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZE2J4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZE2J4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZE2Jz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:55:57 -0400
Received: from www.tglx.de ([62.245.132.106]:44586 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZE2Jz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:55:56 -0400
Date: Fri, 29 May 2009 11:55:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A1F41C5.7000803@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Zhaolei wrote:
> But, for trace_timer_start() in __mod_timer(), we need to put it after
> timer->* changed.

Why ?

>> +	TP_fast_assign(
>> +		__entry->timer		= timer;
>> +		__entry->function	= timer->function;
>> +		__entry->expires	= timer->expires;
>> +		__entry->cpu		= cpu;

Again, neither timer nor function nor expires will change when the
timer is added, right ?

The only unknown at this point is cpu. See below.

> Nevertheless, it don't means we need separate trace_timer_start() and
> debug_timer_activate(), because we can put move debug_timer_activate() below,
> as:
> -	debug_timer_activate(timer);
> 	...
>  	timer->expires = expires;
>  	internal_add_timer(base, timer);
> +	debug_timer_activate(timer);

No, you can not call it with the base->lock held.

> +	trace_timer_start(timer, smp_processor_id());

Also using smp_processor_id() here is wrong. We do not necessarily add
the timer to the current CPUs timer wheel. See the code which selects
the timer base. So this information is rather useless, because the
tracer knows anyway  on which CPU we are running.

Unfortunately we do not have an easy way to figure out to which CPU
the base belongs (except if it's the base of the current CPU). There
is not much we can do about that. But OTOH, this is not a problem
because we see when the timer expires on which CPU it was enqueued. So
scrapping the cpu entry in the trace completely is not a big loss.

The same applies to hrtimers as well.

Thanks,

	tglx
