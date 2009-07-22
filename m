Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZGVJiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZGVJiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZGVJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:38:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60040 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZGVJiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:38:50 -0400
Message-ID: <4A66DDB6.4000700@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 17:36:54 +0800
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
References: <4A604E46.5050903@cn.fujitsu.com>	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>	 <4A641BFC.2050508@cn.fujitsu.com> <1248091771.15751.8578.camel@twins>
In-Reply-To: <1248091771.15751.8578.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:

> Ah, but you don't get those anyway, I'd argue the whole expire thing is
> broken. The only expiry you get is the hardware interrupt firing.
> Anything after that is a free-for-all.
> 
> Look at that loop in hrtimer_interrupt(), with your tracepoint, they'd
> all expire at the same time, regardless of how long previous callback's
> took to complete.
> 
> Also, the whole loop can be re-tried, updating 'now' expiring a whole
> new set of timers without expiry event.
> 

Yes, the expire time that got by _expire() is incorrect and thanks for
your point out.

> The best you can get is a tracepoint when the hrtimer interrupt happens,
> and the IRQ tracepoint already give you that.
> 

I'm trying to fix it address your comment, but meet some problems,
the time of ftrace output can't solve everything, because:

1: the time unit of ftrace output is microsecond, but hrtimer's unit
   is nanosecond, it's not exact for us

2: the time of ftrace ouput is the time after system boot, but we need
   xtime and wall_to_monotonic to calculate latency of hrtimer,
   for example:
   insmod-3821  [001]  3192.239335: hrtimer_start: timer=d08a1480  expires=1245162841000000000 ns
   <idle>-0     [001]  3201.506127: hrtimer_expire: timer=d08a1480
   
  we expect the timer expire at 1245162841000000000 ns, this is base on
  xtime, but we don't know the interval running that we are expect hrtimer
  to run if we don't know the xtime at hrtimer_start or hrtimer_expire.

But it's hard for hrtime's TRACE_EVENT to get xtime and wall_to_monotonic
since it's a fast patch, if we have to do this, the code maybe like below:

TRACE_EVENT(hrtimer_expire,

	......

	TP_STRUCT__entry(
		__field( void *,	timer	)
		__field( s64,		now	)
		__field( s64, 		offset	)
	),

	TP_fast_assign(
		__entry->timer	= timer;
		__entry->now	= ktime_get().tv64;
		__entry->wtom 	= timespec_to_ktime(wall_to_monotonic).tv64;
	),

	TP_printk("timer=%p now=%llu ns wtom=%llu", __entry->timer,
		 (unsigned long long)__entry->now, (unsigned long long)__entry->wtom)
);

We need cooperate with trace_hrtimer_init() to get hrtimer's clockid.

That make trace_hrtimer_expire() slow.

Though the original patch get expire time not exactly, but It harm system's 
performance very little.

Thanks, 
Xiao

> So I really don't see the use-case for this _expiry tracepoint, its just
> too ill-defined.
> 
> The _entry and _exit ones I can agree with, this stuff just doesn't make
> any sense.
> 
> 
