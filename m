Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0BAEYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:24:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56777 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0BAEYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:24:09 -0500
Date: Sun, 31 Jan 2010 20:24:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] v2 accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100201042404.GD6721@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100128153249.GA7087@linux.vnet.ibm.com> <20100131192343.GB5224@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131192343.GB5224@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 08:23:45PM +0100, Frederic Weisbecker wrote:
> On Thu, Jan 28, 2010 at 07:32:49AM -0800, Paul E. McKenney wrote:
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
> > However, if any CPU other than the current one is not in dyntick-idle
> > mode, fall back to simply checking (with fix to bug noted by Lai
> > Jiangshan).  Also, take advantage of last grace-period forcing, the
> > opportunity to do so noted by Steve Rostedt.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/cpumask.h |   14 +++++++++
> >  init/Kconfig            |   16 +++++++++++
> >  kernel/rcutree.c        |    5 +--
> >  kernel/rcutree_plugin.h |   69 +++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 101 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index d77b547..dbcee76 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -143,6 +143,8 @@ static inline unsigned int cpumask_any_but(const struct cpumask *mask,
> >  
> >  #define for_each_cpu(cpu, mask)			\
> >  	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
> > +#define for_each_cpu_not(cpu, mask)		\
> > +	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
> >  #define for_each_cpu_and(cpu, mask, and)	\
> >  	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
> >  #else
> > @@ -203,6 +205,18 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
> >  		(cpu) < nr_cpu_ids;)
> >  
> >  /**
> > + * for_each_cpu_not - iterate over every cpu in a complemented mask
> > + * @cpu: the (optionally unsigned) integer iterator
> > + * @mask: the cpumask pointer
> > + *
> > + * After the loop, cpu is >= nr_cpu_ids.
> > + */
> > +#define for_each_cpu_not(cpu, mask)				\
> > +	for ((cpu) = -1;					\
> > +		(cpu) = cpumask_next_zero((cpu), (mask)),	\
> > +		(cpu) < nr_cpu_ids;)
> > +
> > +/**
> >   * for_each_cpu_and - iterate over every cpu in both masks
> >   * @cpu: the (optionally unsigned) integer iterator
> >   * @mask: the first cpumask pointer
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
> > index e77cdf3..c1d97ec 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -906,3 +906,72 @@ static void __init __rcu_init_preempt(void)
> >  }
> >  
> >  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> > +
> > +#if defined(CONFIG_TREE_PREEMPT_RCU) || !defined(CONFIG_RCU_FAST_NO_HZ)
> 
> RCU_FAST_NO_HZ depends on TREE_RCU, so you can't have both.

So you would like to see:

	#if !defined(CONFIG_RCU_FAST_NO_HZ)

OK, makes sense, fixed.

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
> > +	for_each_cpu_not(thatcpu, nohz_cpu_mask)
> > +		if (thatcpu != cpu)
> > +			return rcu_needs_cpu_quick_check(cpu);
> > +
> > +	/* Try to push remaining RCU-sched and RCU-bh callbacks through. */
> > +	for (i = 0; i < RCU_NEEDS_CPU_FLUSHES && c; i++) {
> 
> I wonder why you take such limitation of 5. Actually you know you
> are in a quiescent state, so is there any danger in eating
> every new iterations of rcu callbacks until the last completion?
> If there are still other callbacks to process after that, they
> will be processed in the next jiffy anyway, right? So is it
> worth it having this limitation?
> 
> The only bad thing that can happen is that the recursive rcu
> callback becomes very badly recursive, that it never stops, but
> in this case, the rcu cpu stall detection will warn very soon
> (unless the current cpu is already considered as beeing in
> true idle-dyntick mode and then won't need to signals its quiscent
> state?). But the bad recursion is just going to be deferred with the
> "5" limitions actually...

There is nothing illegal about the following:

	static void my_rcu_callback(struct rcu_head *rcu)
	{
		struct foo *fp = container_of(rcu, struct foo, rcu_head);

		if (fp->refcnt != 0) {
			call_rcu(rcu);
			return;
		}
		kfree(fp);
	}

And allowing RCU_NEEDS_CPU_FLUSHES of infinity would work correctly in
some sense, but would be a massive power inefficiency.

The choice of "5" allows a callback that posts one other callback,
which happens often enough to be worth the extra iterations.  It is
necessary to budget two passes through the loop per level of RCU
callback, one for the current CPU to start the grace period and another
for it to end it.

Seem reasonable?

							Thanx, Paul
