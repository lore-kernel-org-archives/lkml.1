Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYJQPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYJQPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYJQPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:35:52 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:33737 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbYJQPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:35:51 -0400
Date: Fri, 17 Oct 2008 21:05:13 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081017153513.GC23228@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <20081017083452.GA23228@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017083452.GA23228@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:04:52PM +0530, Gautham R Shenoy wrote:
> On Fri, Oct 10, 2008 at 09:09:30AM -0700, Paul E. McKenney wrote:
> > Hello!
> Hi Paul,
> 
> Looks interesting. Couple of minor nits. Comments interspersed. Search for "=>"
Search is too tedius, even for me. Trimming it down.

> > +};
> > +
> > +/* Values for signaled field in struc rcu_data. */
				   ^^^^^^^^^^^^^^^^^^
			   should be struct rcu_state.
> > +#define RCU_SAVE_DYNTICK	0	/* Need to scan dyntick state. */
> > +#define RCU_FORCE_QS		1	/* Need to force quiescent state. */
> > +#ifdef CONFIG_NO_HZ
> > +#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
> > +#else /* #ifdef CONFIG_NO_HZ */
> > +#define RCU_SIGNAL_INIT		RCU_FORCE_QS
> > +#endif /* #else #ifdef CONFIG_NO_HZ */
> > +
> > +}
> > +



> > +#ifdef CONFIG_SMP
> > +
> > +/*
> > + * If the specified CPU is offline, tell the caller that it is in
> > + * a quiescent state.  Otherwise, whack it with a reschedule IPI.
> > + * Grace periods can end up waiting on an offline CPU when that
> > + * CPU is in the process of coming online -- it will be added to the
> > + * rcu_node bitmasks before it actually makes it online.

        This can also happen when a CPU has just gone offline,
        but RCU hasn't yet marked it as offline. However, it's impact
        on delaying the grace period may not be high as in the
        CPU-online case.
> 
> > + * Because this
> > + * race is quite rare, we check for it after detecting that the grace
> > + * period has been delayed rather than checking each and every CPU
> > + * each and every time we start a new grace period.
> > + */
> > +static int rcu_implicit_offline_qs(struct rcu_data *rdp)
> > +{
> > +	/*
> > +	 * If the CPU is offline, it is in a quiescent state.  We can
> > +	 * trust its state not to change because interrupts are disabled.
> > +	 */
> > +	if (cpu_is_offline(rdp->cpu)) {
> > +		rdp->offline_fqs++;
> > +		return 1;
> > +	}
> > +
> > +	/* The CPU is online, so send it a reschedule IPI. */
> > +	if (rdp->cpu != smp_processor_id())

	This check is safe here since this callpath is invoked
	from a softirq, and thus the system cannot do a stop_machine()
	as yet. This implies that the cpu in question cannot go offline
	until we're done.

> > +		smp_send_reschedule(rdp->cpu);
> > +	else
> > +		set_need_resched();
> > +	rdp->resched_ipi++;
> > +	return 0;
> > +}
> > +
> > +#endif /* #ifdef CONFIG_SMP */
> > +/*

> > + * Record the specified "completed" value, which is later used to validate
> > + * dynticks counter manipulations.  Specify "rsp->complete - 1" to
					       ^^^^^^^^^^^^^^^^^^^
					       "rsp->completed - 1" ?


> > + * unconditionally invalidate any future dynticks manipulations (which is
> > + * useful at the beginning of a grace period).


> > +
> > +static void print_other_cpu_stall(struct rcu_state *rsp)
> > +{
> > +	int cpu;
> > +	long delta;
> > +	unsigned long flags;
> > +	struct rcu_node *rnp = rcu_get_root(rsp);
> > +	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
> > +	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
> > +
> > +	/* Only let one CPU complain about others per time interval. */
> > +
> > +	spin_lock_irqsave(&rnp->lock, flags);
> > +	delta = jiffies - rsp->jiffies_stall;
> > +	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum != rsp->completed) {
	----------------> [1]
	See comment in check_cpu_stall()

> > +		spin_unlock_irqrestore(&rnp->lock, flags);
> > +		return;
> > +	}
> > +	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
> > +	spin_unlock_irqrestore(&rnp->lock, flags);
> > +
> > +	/* OK, time to rat on our buddy... */
> > +
> > +	printk(KERN_ERR "RCU detected CPU stalls:");
> > +	for (; rnp_cur < rnp_end; rnp_cur++) {
> > +		if (rnp_cur->qsmask == 0)
> > +			continue;
> > +		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
> > +			if (rnp_cur->qsmask & (1UL << cpu))
> > +				printk(" %d", rnp_cur->grplo + cpu);
> > +	}
> > +	printk(" (detected by %d, t=%ld jiffies)\n",
> > +	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
> > +	force_quiescent_state(rsp, 0);  /* Kick them all. */
> > +}
> > +
> > +static void print_cpu_stall(struct rcu_state *rsp)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_node *rnp = rcu_get_root(rsp);
> > +
> > +	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu jiffies)\n",
> > +			smp_processor_id(), jiffies - rsp->gp_start);
> > +	dump_stack();
> > +	spin_lock_irqsave(&rnp->lock, flags);
> > +	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
> > +		rsp->jiffies_stall =
> > +			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
> > +	spin_unlock_irqrestore(&rnp->lock, flags);
> > +	set_need_resched();  /* kick ourselves to get things going. */
> > +}
> > +
> > +static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
> > +{
> > +	long delta;
> > +	struct rcu_node *rnp;
> > +
> > +	delta = jiffies - rsp->jiffies_stall;
> > +	rnp = rdp->mynode;
> > +	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
> > +
> > +		/* We haven't checked in, so go dump stack. */
> > +		print_cpu_stall(rsp);
> > +
> > +	} else if (rsp->gpnum != rsp->completed &&
> > +		   delta >= RCU_STALL_RAT_DELAY) {
> 
		If this condition is true, then,
		rsp->gpnum != rsp->completed. Hence, we will always enter
		the if() condition in print_other_cpu_stall() at
		[1] (See above), and return without ratting our buddy.

		That defeats the purpose of the stall check or I am
		missing the obvious, which is quite possible :-)
> > +
> > +		/* They had two time units to dump stack, so complain. */
> > +		print_other_cpu_stall(rsp);
> > +	}
> > +}
> > +
> > +#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> > +
> > +static void record_gp_stall_check_time(struct rcu_state *rsp)
> > +{
> > +}


> > +
> > +static void __cpuinit rcu_online_cpu(int cpu)
> > +{
> > +#ifdef CONFIG_NO_HZ
> > +	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
> > +
> > +	rdtp->dynticks_nesting = 1;
> > +	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
> > +	rdtp->dynticks_nmi = (rdtp->dynticks + 1) & ~0x1;
	rdtp->dynticks is odd. Hence rdtp->dynticks + 1 should be even.
	Why is the additional & ~0x1 ?


> 
> > +#endif /* #ifdef CONFIG_NO_HZ */
> > +	rcu_init_percpu_data(cpu, &rcu_state);
-- 
Thanks and Regards
gautham
