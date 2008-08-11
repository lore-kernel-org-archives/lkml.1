Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbYHKKp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbYHKKp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYHKKpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:45:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55764 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYHKKpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:45:50 -0400
Date: Mon, 11 Aug 2008 12:45:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811104526.GA15186@elte.hu>
References: <1218202249.8625.106.camel@twins> <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org> <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-08-08 at 21:21 +0200, Peter Zijlstra wrote:
> 
> > The initial printk_tick() based implementation didn't suffer this
> > problem, should we revert to that scheme?
> 
> Just in case people care..
> 
> ---
> Subject: printk: robustify printk
> 
> Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd 
> wakeup by polling from the timer tick.

i missed most of the discussion, but this seems like the simplest (and 
hence ultimately the best) approach to me.

Coupling printk with RCU, albeit elegant, does not seem like the right 
choice to me in this specific case: printk as an essential debug 
mechanism should be as decoupled as possible.

Also, once we accept the possibility of async klogd completion, we might 
as well do it all the time.

i have only one sidenote:

> --- linux-2.6.orig/kernel/time/tick-sched.c
> +++ linux-2.6/kernel/time/tick-sched.c
> @@ -255,7 +255,7 @@ void tick_nohz_stop_sched_tick(int inidl
>       next_jiffies = get_next_timer_interrupt(last_jiffies);
>       delta_jiffies = next_jiffies - last_jiffies;
>
> -     if (rcu_needs_cpu(cpu))
> +     if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
>               delta_jiffies = 1;

this change made a previous design quirks even more visible: these are 
items that are not purely event driven but need some polling component. 
RCU is one, and now printk is another.

We could clean this up further by integrating the rcu_needs_cpu() and 
printk_needs_cpu() into a softirq mechanism. We already check for 
pending softirqs in tick-sched.c, so the above complication would go 
away completely.

( But that's for a separate cleanup patch i think. )

No strong feelings though. Peter, which one do you prefer?

	Ingo
