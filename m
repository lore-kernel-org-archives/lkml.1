Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768Ab0A0FSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0A0FSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 00:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229Ab0A0FSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 00:18:01 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39441 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0A0FR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 00:17:59 -0500
Date: Tue, 26 Jan 2010 21:17:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127051754.GB6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <4B5D8E72.3050807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5D8E72.3050807@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 08:28:34PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > [Experimental RFC, not for inclusion.]
> > 
> > I recently received a complaint that RCU was refusing to let a system
> > go into low-power state immediately, instead waiting a few ticks after
> > the system had gone idle before letting go of the last CPU.  Of course,
> > the reason for this was that there were a couple of RCU callbacks on
> > the last CPU.
> > 
> > Currently, rcu_needs_cpu() simply checks whether the current CPU has
> > an outstanding RCU callback, which means that the last CPU to go into
> > dyntick-idle mode might wait a few ticks for the relevant grace periods
> > to complete.  However, if all the other CPUs are in dyntick-idle mode,
> > and if this CPU is in a quiescent state (which it is for RCU-bh and
> > RCU-sched any time that we are considering going into dyntick-idle mode),
> > then the grace period is instantly complete.
> > 
> > This patch therefore repeatedly invokes the RCU grace-period machinery
> > in order to force any needed grace periods to complete quickly.  It does
> > so a limited number of times in order to prevent starvation by an RCU
> > callback function that might pass itself to call_rcu().
> > 
> > Thoughts?
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index d95ca7c..42bf914 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -396,6 +396,22 @@ config RCU_FANOUT_EXACT
> >  
> >  	  Say N if unsure.
> >  
> > +config RCU_FAST_NO_HZ
> > +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> > +	depends on TREE_RCU && NO_HZ && SMP
> > +	default n
> > +	help
> > +	  This option causes RCU to attempt to accelerate grace periods
> > +	  in order to allow the final CPU to enter dynticks-idle state
> > +	  more quickly.  On the other hand, this option increases the
> > +	  overhead of the dynticks-idle checking, particularly on systems
> > +	  with large numbers of CPUs.
> > +
> > +	  Say Y if energy efficiency is critically important, particularly
> > +	  	if you have relatively few CPUs.
> > +
> > +	  Say N if you are unsure.
> > +
> >  config TREE_RCU_TRACE
> >  	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
> >  	select DEBUG_FS
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 099a255..29d88c0 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1550,10 +1550,9 @@ static int rcu_pending(int cpu)
> >  /*
> >   * Check to see if any future RCU-related work will need to be done
> >   * by the current CPU, even if none need be done immediately, returning
> > - * 1 if so.  This function is part of the RCU implementation; it is -not-
> > - * an exported member of the RCU API.
> > + * 1 if so.
> >   */
> > -int rcu_needs_cpu(int cpu)
> > +static int rcu_needs_cpu_quick_check(int cpu)
> >  {
> >  	/* RCU callbacks either ready or pending? */
> >  	return per_cpu(rcu_sched_data, cpu).nxtlist ||
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index e77cdf3..d6170a9 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -906,3 +906,72 @@ static void __init __rcu_init_preempt(void)
> >  }
> >  
> >  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> > +
> > +#if defined(CONFIG_TREE_PREEMPT_RCU) || !defined(CONFIG_RCU_FAST_NO_HZ)
> > +
> > +/*
> > + * Check to see if any future RCU-related work will need to be done
> > + * by the current CPU, even if none need be done immediately, returning
> > + * 1 if so.  This function is part of the RCU implementation; it is -not-
> > + * an exported member of the RCU API.
> > + *
> > + * Because we have preemptible RCU, just check whether this CPU needs
> > + * any flavor of RCU.  Do not chew up lots of CPU cycles with preemption
> > + * disabled in a most-likely vain attempt to cause RCU not to need this CPU.
> > + */
> > +int rcu_needs_cpu(int cpu)
> > +{
> > +	return rcu_needs_cpu_quick_check(cpu);
> > +}
> > +
> > +#else
> > +
> > +#define RCU_NEEDS_CPU_FLUSHES 5
> > +
> > +/*
> > + * Check to see if any future RCU-related work will need to be done
> > + * by the current CPU, even if none need be done immediately, returning
> > + * 1 if so.  This function is part of the RCU implementation; it is -not-
> > + * an exported member of the RCU API.
> > + *
> > + * Because we are not supporting preemptible RCU, attempt to accelerate
> > + * any current grace periods so that RCU no longer needs this CPU, but
> > + * only if all other CPUs are already in dynticks-idle mode.  This will
> > + * allow the CPU cores to be powered down immediately, as opposed to after
> > + * waiting many milliseconds for grace periods to elapse.
> > + */
> > +int rcu_needs_cpu(int cpu)
> > +{
> > +	int c = 1;
> > +	int i;
> > +	int thatcpu;
> > +
> > +	/* Don't bother unless we are the last non-dyntick-idle CPU. */
> > +	for_each_cpu(thatcpu, nohz_cpu_mask)
> > +		if (thatcpu != cpu)
> > +			return rcu_needs_cpu_quick_check(cpu);
> 
> The comment and the code are not the same, I think.

Indeed, for this code to be correct, I would need to sequence through
the non-dyntick-idle CPUs, not the dyntick-idle ones.

Good catch!

I will likely come back with something similar to Steve Rostedt's
suggestion.  Probably better to sequence through all the CPUs rather
than to allocate a cpumask and invert it.  Or a 'for_each_cpu_not()'
or some such.  ;-)

There does appear to be a cpumask_next_zero() that I should be able to
use.

						Thanx, Paul

> -----------
> I found this thing, Although I think it is a ugly thing.
> Is it help?
> 
> See select_nohz_load_balancer().
> 
> /*
>  * This routine will try to nominate the ilb (idle load balancing)
>  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
>  * load balancing on behalf of all those cpus. If all the cpus in the system
>  * go into this tickless mode, then there will be no ilb owner (as there is
>  * no need for one) and all the cpus will sleep till the next wakeup event
>  * arrives...
>  *
>  * For the ilb owner, tick is not stopped. And this tick will be used
>  * for idle load balancing. ilb owner will still be part of
>  * nohz.cpu_mask..
>  *
>  * While stopping the tick, this cpu will become the ilb owner if there
>  * is no other owner. And will be the owner till that cpu becomes busy
>  * or if all cpus in the system stop their ticks at which point
>  * there is no need for ilb owner.
>  *
>  * When the ilb owner becomes busy, it nominates another owner, during the
>  * next busy scheduler_tick()
>  */
