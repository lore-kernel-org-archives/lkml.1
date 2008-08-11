Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHKNWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHKNWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHKNWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:22:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49874 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYHKNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:22:36 -0400
Date: Mon, 11 Aug 2008 06:22:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811132241.GM8125@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org> <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811104526.GA15186@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:45:26PM +0200, Ingo Molnar wrote:
> 
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

I am missing something here.  Are you suggesting that RCU call out
when a given CPU has nothing to do, rather than the current behavior
where rcu_needs_cpu() is invoked when a CPU is being considered for
dynticks idle mode?  My concern with this approach would be races that
are currently avoided by the fact that calls to rcu_needs_cpu() are
performed with hardirqs disabled.

							Thanx, Paul

> ( But that's for a separate cleanup patch i think. )
> 
> No strong feelings though. Peter, which one do you prefer?
> 
> 	Ingo
