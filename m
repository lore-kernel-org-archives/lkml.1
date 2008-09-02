Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYIBBF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYIBBF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 21:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYIBBFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 21:05:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59520 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYIBBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 21:05:49 -0400
Date: Mon, 1 Sep 2008 18:05:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080902010544.GA6902@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <87ej44xl2i.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej44xl2i.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 11:38:29AM +0200, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> >  
> > -#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
> > +#if defined(CONFIG_NO_HZ)
> >  extern void rcu_irq_enter(void);
> >  extern void rcu_irq_exit(void);
> >  #else
> >  # define rcu_irq_enter() do { } while (0)
> >  # define rcu_irq_exit() do { } while (0)
> > -#endif /* CONFIG_PREEMPT_RCU */
> > +#endif /* #if defined(CONFIG_NO_HZ) */
> 
> It would be better if you hung rcu_irq_enter in the irq_enter() if 
> statement that checks if the task was idle or not. This way it would
> be zero overhead for interruptions of non busy CPUs, keeping 
> it out of many fast paths.
> 
> Haven't read everything, sorry.

So that I lose the #else above, and so that irq_enter() and irq_exit()
look something like the following (with additional adjustments to suit)?
Makes a lot of sense to me...

And it has the very nice side effect of allowing me to have a separate
rcu_irq_enter() and rcu_nmi_enter(), trivializing the RCU-dynticks
interface!!!  Very cool, thank you very much!!!

							Thanx, Paul

void irq_enter(void)
{
#ifdef CONFIG_NO_HZ
	int cpu = smp_processor_id();
	if (idle_cpu(cpu) && !in_interrupt())
		tick_nohz_stop_idle(cpu);
#endif
	__irq_enter();
#ifdef CONFIG_NO_HZ
	if (idle_cpu(cpu)) {
		rcu_irq_enter();
		tick_nohz_update_jiffies();
	}
#endif
}

void irq_exit(void)
{
	account_system_vtime(current);
	trace_hardirq_exit();
	sub_preempt_count(IRQ_EXIT_OFFSET);
	if (!in_interrupt() && local_softirq_pending())
		invoke_softirq();

#ifdef CONFIG_NO_HZ
	/* Make sure that timer wheel updates are propagated */
	if (idle_cpu(smp_processor_id())) {
		if (!in_interrupt() && !need_resched())
			tick_nohz_stop_sched_tick(0);
		rcu_irq_exit();
	}
#endif
	preempt_enable_no_resched();
}
