Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYHKLEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYHKLEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYHKLED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:04:03 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:57106 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYHKLEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:04:01 -0400
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <20080811104526.GA15186@elte.hu>
References: <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	 <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	 <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	 <20080808121428.646a8b3c.akpm@linux-foundation.org>
	 <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	 <1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
	 <20080811104526.GA15186@elte.hu>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 13:04:00 +0200
Message-Id: <1218452640.10800.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 12:45 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2008-08-08 at 21:21 +0200, Peter Zijlstra wrote:
> > 
> > > The initial printk_tick() based implementation didn't suffer this
> > > problem, should we revert to that scheme?
> > 
> > Just in case people care..
> > 
> > ---
> > Subject: printk: robustify printk
> > 
> > Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd 
> > wakeup by polling from the timer tick.
> 
> i missed most of the discussion, but this seems like the simplest (and 
> hence ultimately the best) approach to me.
> 
> Coupling printk with RCU, albeit elegant, does not seem like the right 
> choice to me in this specific case: printk as an essential debug 
> mechanism should be as decoupled as possible.
> 
> Also, once we accept the possibility of async klogd completion, we might 
> as well do it all the time.
> 
> i have only one sidenote:
> 
> > --- linux-2.6.orig/kernel/time/tick-sched.c
> > +++ linux-2.6/kernel/time/tick-sched.c
> > @@ -255,7 +255,7 @@ void tick_nohz_stop_sched_tick(int inidl
> >       next_jiffies = get_next_timer_interrupt(last_jiffies);
> >       delta_jiffies = next_jiffies - last_jiffies;
> >
> > -     if (rcu_needs_cpu(cpu))
> > +     if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
> >               delta_jiffies = 1;
> 
> this change made a previous design quirks even more visible: these are 
> items that are not purely event driven but need some polling component. 
> RCU is one, and now printk is another.
> 
> We could clean this up further by integrating the rcu_needs_cpu() and 
> printk_needs_cpu() into a softirq mechanism. We already check for 
> pending softirqs in tick-sched.c, so the above complication would go 
> away completely.

RCU depends on the polling to advance the state machine, if you want an
event driven state machine, you'd have to drive it from
rcu_read_unlock() adding overhead there - and I'm pretty sure you don't
want to do that.

So while its a tad ugly to poll for these states, I'm not too worried in
these two cases - of course every additional poll needs good
justification.

> ( But that's for a separate cleanup patch i think. )
> 
> No strong feelings though. Peter, which one do you prefer?

I personally prefer this printk_tick() driven one over the RCU driven
one because it doesn't trade deadlocks.


