Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZGTMJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZGTMJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZGTMJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:09:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGTMJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:09:08 -0400
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A641BFC.2050508@cn.fujitsu.com>
References: <4A604E46.5050903@cn.fujitsu.com>
	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>
	 <4A641BFC.2050508@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 14:09:31 +0200
Message-Id: <1248091771.15751.8578.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 15:25 +0800, Xiao Guangrong wrote:

> >> @@ -1162,9 +1182,8 @@ static void __run_hrtimer(struct hrtimer *timer)
> >>  	 * the timer base.
> >>  	 */
> >>  	spin_unlock(&cpu_base->lock);
> >> -	trace_hrtimer_entry(timer);
> >>  	restart = fn(timer);
> >> -	trace_hrtimer_exit(timer, restart);
> >> +	trace_hrtimer_callback_done(timer);
> >>  	spin_lock(&cpu_base->lock);
> >>  
> >>  	/*
> > 
> > Why bother introducing these tracepoints if you're going to remove them
> > in the same patch-set?
> > 
> 
> Actually I'm renaming them but not removing them.

Since the new set doesn't include anything comparable to _entry, I'd say
you're deleting one.

> I can drop the first patch and merge it into the latter patches,
> but that will lose the credit for Anton Blanchard

You could fix that with something like:

Suggested-by: Anton Blanchard

> > Also, the below:
> > 
> >> @@ -1275,6 +1294,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
> >>  				break;
> >>  			}
> >>  
> >> +			trace_hrtimer_expire(timer, basenow.tv64);
> >>  			__run_hrtimer(timer);
> >>  		}
> >>  		base++;
> >> @@ -1397,6 +1417,7 @@ void hrtimer_run_queues(void)
> >>  					hrtimer_get_expires_tv64(timer))
> >>  				break;
> >>  
> >> +			trace_hrtimer_expire(timer, base->softirq_time.tv64);
> >>  			__run_hrtimer(timer);
> >>  		}
> >>  		spin_unlock(&cpu_base->lock);
> > 
> > indicates you placed that tracepoint in the wrong place.
> > 
> > Furthermore, I don't get why you want it there and not on the old
> > _entry() site, because this adds all kinds of extra overhead and you
> > loose the exact callback timings.
> > 
> 
> Yes, it's true, but the loose is only about 1 microsecond as I tested it.
> Do you think it's acceptable or not?

The time is irrelevant, but look at the code, it includes a whole heap
of things, like debug code, locks, poking at hardware etc.

It simply isn't comparable to before.

> If we put trace_hrtimer_expire() on the old _entry() site, then we can't
> get the timestamps when hrtimer expires, which is used to calculate the
> latency of hrtimer.

Ah, but you don't get those anyway, I'd argue the whole expire thing is
broken. The only expiry you get is the hardware interrupt firing.
Anything after that is a free-for-all.

Look at that loop in hrtimer_interrupt(), with your tracepoint, they'd
all expire at the same time, regardless of how long previous callback's
took to complete.

Also, the whole loop can be re-tried, updating 'now' expiring a whole
new set of timers without expiry event.

The best you can get is a tracepoint when the hrtimer interrupt happens,
and the IRQ tracepoint already give you that.

So I really don't see the use-case for this _expiry tracepoint, its just
too ill-defined.

The _entry and _exit ones I can agree with, this stuff just doesn't make
any sense.
