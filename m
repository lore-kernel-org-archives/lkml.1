Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbZEGSBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbZEGSBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZEGSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:01:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50990 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZEGSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:01:15 -0400
Date: Thu, 7 May 2009 11:01:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507180112.GE6693@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <20090507173608.GC6693@linux.vnet.ibm.com> <1241717904.6311.1558.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241717904.6311.1558.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 07:38:24PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-05-07 at 10:36 -0700, Paul E. McKenney wrote:
> > On Thu, May 07, 2009 at 07:18:38PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-05-07 at 19:13 +0200, Peter Zijlstra wrote:
> > > > On Thu, 2009-05-07 at 19:09 +0200, Peter Zijlstra wrote:
> > > > > On Thu, 2009-05-07 at 10:13 -0400, Christoph Lameter wrote:
> > > > > > I think we need to reduce the general tick frequency to be as low as
> > > > > > possible. With high resolution timers the tick frequency is just the
> > > > > > frequency with which the timer interrupt disturbs a running application.
> > > > > > 
> > > > > > Are there any benefits remaining from frequent timer interrupts? I would
> > > > > > think that 60 HZ would be sufficient.
> > > > > > 
> > > > > > It would be good if the kernel would be truly tickless. Scheduler events
> > > > > > would be driven by the scheduling intervals and not the invokations of the
> > > > > > scheduler softirq.
> > > > > 
> > > > > The only thing that's driven by the softirq is load-balancing, there's
> > > > > way more to the scheduler-tick than kicking that thing awake every so
> > > > > often.
> > > > > 
> > > > > The problem is that running the scheduler of off hrtimers is too
> > > > > expensive. We have the code, we tried it, people complained.
> > > > 
> > > > Therefore, decreasing the HZ value to say 50, we'd get a minimum
> > > > involuntary preemption granularity of 20ms, something on the high end of
> > > > barely usable.
> > > 
> > > Another user is RCU, the grace period is tick driven, growing these
> > > ticks by a factor 50 or so might require some tinkering with forced
> > > grace periods when we notice our batch queues getting too long.
> > 
> > One approach would be to enter nohz mode when running a CPU-bound
> > application on a CPU that had nothing else (other than the idle task)
> > on its runqueue and for which rcu_needs_cpu() returns zero.  In this
> > mode, RCU would need to be informed on each system call, perhaps with an
> > rcu_kernel_enter() and rcu_kernel_exit() that work like rcu_irq_enter()
> > and rcu_irq_exit() -- and that perhaps replace rcu_irq_enter() and
> > rcu_irq_exit().
> > 
> > Then RCU would ignore any CPU that was executing a CPU-bound application,
> > allowing the HZ to be dialed down as low as you like, or perhaps really
> > entering something like nohz mode.
> 
> Which would make syscall more expensive, not something you'd want to
> do :-)

In general, I agree.  However, in the case where you have a single
CPU-bound task running in user mode, you don't care that much about
syscall performance.  So, yes, this would mean having yet another config
variable that users running big CPU-bound scientific applications would
need to worry about, which is not perfect either.

For whatever it is worth, the added overhead on entry would be something
like the following:

void rcu_irq_enter(void)
{
	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);

	if (rdtp->dynticks_nesting++)
		return;
	rdtp->dynticks++;
	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
}

On exit, a bit more:

void rcu_irq_exit(void)
{
	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);

	if (--rdtp->dynticks_nesting)
		return;
	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
	rdtp->dynticks++;
	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);

	/* If the interrupt queued a callback, get out of dyntick mode. */
	if (__get_cpu_var(rcu_data).nxtlist ||
	    __get_cpu_var(rcu_bh_data).nxtlist)
		set_need_resched();
}

But I could move the callback check into call_rcu(), which would get the
overhead of rcu_irq_exit() down to about that of rcu_irq_enter().

							Thanx, Paul
