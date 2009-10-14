Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbZJNCxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbZJNCxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZJNCxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:53:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45792 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbZJNCxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:53:15 -0400
Date: Tue, 13 Oct 2009 19:52:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
Message-ID: <20091014025235.GB6840@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091009224954.GA26516@linux.vnet.ibm.com> <4AD42FF5.2080109@cn.fujitsu.com> <20091013170022.GA6782@linux.vnet.ibm.com> <4AD51D3E.60103@cn.fujitsu.com> <20091014010956.GG6782@linux.vnet.ibm.com> <4AD531E5.6070103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD531E5.6070103@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:05:25AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Wed, Oct 14, 2009 at 08:37:18AM +0800, Lai Jiangshan wrote:
> >> Paul E. McKenney wrote:
> >>>> It's an old issue.
> >>>> It's not only about RCUTINY, it's also about other rcu implementations:
> >>>>
> >>>> rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.
> >>>>
> >>>> irq_exit() calls tick_nohz_stop_sched_tick() which calls rcu_enter_nohz(),
> >>>> where is the corresponding rcu_exit_nohz()?
> >>>> (or tick_nohz_restart_sched_tick())?
> >>> The tick_nohz_restart_sched_tick() function is called from the various
> >>> per-architecture cpu_idle() functions (or default_idle() or whatever
> >>> name that the architecture uses).  For example, in:
> >>>
> >>> 	arch/x86/kernel/process_64.c
> >>>
> >>> the cpu_idle() function invokes tick_nohz_restart_sched_tick() just
> >>> before invoking schedule() to exit the idle loop.
> >>>
> >>> And, as you say, tick_nohz_restart_sched_tick() invokes rcu_exit_nohz().
> >> These tick_nohz_restart_sched_tick() which are called from the various
> >> per-architecture cpu_idle() functions are not the opposite of
> >> the tick_nohz_stop_sched_tick() in *irq_exit()*. So I figure that 
> >> rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.
> > 
> > OK, let's start with rcu_enter_nohz(), which tells RCU that the running
> > CPU is going into dyntick-idle mode, and thus should be ignored by RCU.
> > Let's do the idle loop first:
> > 
> > o	Upon entry to the idle() loop (using cpu_idle() in
> > 	arch/x86/kernel/process_64.c for this exercise),
> > 	we invoke tick_nohz_stop_sched_tick(1), which says we
> > 	are in an idle loop.  (This is in contrast to the call
> > 	from irq_exit(), where we are not in the idle loop.)
> > 
> > o	tick_nohz_stop_sched_tick() invokes rcu_enter_nohz(),
> > 	does a bunch of timer checking, and returns.  If anything
> > 	indicated that entering dyntick-idle mode would be bad,
> > 	we raise TIMER_SOFTIRQ to kick us out of this mode.
> > 
> > 	Either way, we return to the idle loop.
> > 
> > o	The idle loops until need_resched().  Upon exit from the
> > 	idle loop, we call tick_nohz_restart_sched_tick(), which
> > 	invokes rcu_exit_nohz(), which tells RCU to start paying
> > 	attention to this CPU once more.
> > 
> > OK, now for interrupts.
> > 
> > o	The hardware interrupt handlers invoke irq_enter(), which in
> > 	turn invokes rcu_irq_enter().  This has no real effect (other
> > 	than incrementing a counter) if the interrupt did not come
> > 	from dyntick-idle mode.
> > 
> > 	Either way, RCU is now paying attention to RCU read-side
> > 	critical sections on this CPU.
> > 
> > o	Upon return from interrupt, the hardware interrupt handlers
> > 	invoke irq_exit(), which in turn invokes rcu_irq_exit().
> > 	This has no real effect (other than decrementing a counter)
> > 	if the interrupt is not returning to dyntick-idle mode.
> > 
> > 	However, if the interrupt -is- returning to dyntick-idle
> > 	mode, then RCU will stop paying attention to RCU read-side
> > 	critical sections on this CPU.
> 
> 
> You haven't explain the tick_nohz_stop_sched_tick() in *irq_exit()*.
> (tick_nohz_stop_sched_tick() calls rcu_enter_nohz())
> 
> void irq_exit(void)
> {
> 	....
> 	rcu_irq_exit(); /* This is OK, the opposite is in irq_enter() */
> 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
> 		tick_nohz_stop_sched_tick(0); /* where is the opposite ??? */
> 	....
> }
> 
> This means if the interrupt -is- returning to dyntick-idle mode,
> rcu_enter_nohz() is called again.
> 
> Take this flow as example:
> 
> cpu_idle():
> while(1) {
> 
>   tick_nohz_stop_sched_tick()
>      rcu_enter_nohz()                 *****

=== now RCU is in no_hz mode.

> ------->interrupt happen
>         irq_enter()

		rcu_irq_enter()

=== now RCU is no longer in no_hz mode.

>         irq_exit()

		rcu_irq_exit()

=== now RCU is in no_hz mode again.

>            tick_nohz_stop_sched_tick()

=== but tick_nohz_stop_sched_tick() is passed "0" as the argument.  
=== I might be missing something, but doesn't this prevent
=== rcu_enter_nohz() from being called at this point?

>               rcu_enter_nohz()       *****
> <-------interrupt returns
>   tick_nohz_restart_sched_tick()
>      rcu_exit_nohz()                  *****

=== now RCU is no longer in no_hz mode.

> } /* while(1) */
> 
> 
> You can see that rcu_enter_nohz() is called twice and
> rcu_exit_nohz() is only called once in this flow.
> 
> It's because tick_nohz_stop_sched_tick()/tick_nohz_restart_sched_tick()
> are not called in pairs, so rcu_enter_nohz() and rcu_exit_nohz()
> are not called in pairs either.

I believe that the checks in tick_nohz_stop_sched_tick() prevent this
scenario from happening, but could easily be mistaken.  I am not seeing
the WARN_ON_RATELIMIT() in rcu_exit_nohz(), however.

							Thanx, Paul

> Lai
> 
> > 
> > So I do believe that rcu_enter_nohz() and rcu_exit_nohz() are in fact
> > invoked in pairs.  One strange thing about this is that the idle loop
> > first invokes rcu_enter_nohz(), then invokes rcu_exit_nohz(), while
> > an interrupt handler first invokes rcu_irq_enter() and then invokes
> > rcu_irq_exit().  So the idle loop enters dyntick-idle mode and then
> > leaves it, while an interrupt handler might leave dyntick-idle mode and
> > then re-enter it.
> > 
> > Or am I still missing something here?
> > 
> > 							Thanx, Paul
> > 
> > 
> 
