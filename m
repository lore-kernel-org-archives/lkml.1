Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0CCQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:48:21 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43897 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112Ab0CCQsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:48:18 -0500
Date: Wed, 3 Mar 2010 18:00:56 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on runtime
 balancing
Message-ID: <20100303170055.GQ2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
 <1267129708.22519.563.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129708.22519.563.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:28PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> 
> >  /*
> > + * Reset the balancing machinery, restarting from a safe runtime assignment
> > + * on all the cpus/rt_rqs in the system.  There is room for improvements here,
> > + * as this iterates through all the rt_rqs in the system; the main problem
> > + * is that after the balancing has been running for some time we are not
> > + * sure that the fragmentation of the free bandwidth it produced allows new
> > + * groups to run where they need to run.  The caller has to make sure that
> > + * only one instance of this function is running at any time.
> >   */
> > +static void __rt_reset_runtime(void)
> >  {
> > +       struct rq *rq;
> > +       struct rt_rq *rt_rq;
> > +       struct rt_bandwidth *rt_b;
> > +       unsigned long flags;
> > +       int i;
> > +
> > +       for_each_possible_cpu(i) {
> > +               rq = cpu_rq(i);
> > +
> > +               rq->rt_balancing_disabled = 1;
> > +               /*
> > +                * Make sure that all the new calls to do_balance_runtime()
> > +                * see the disable flag and do not migrate anything.  We will
> > +                * implicitly wait for the old ones to terminate entering all
> > +                * the rt_b->rt_runtime_lock, one by one.  Note that maybe
> > +                * iterating over the task_groups first would be a good idea...
> > +                */
> > +               smp_wmb();
> > +
> > +               for_each_leaf_rt_rq(rt_rq, rq) {
> > +                       rt_b = sched_rt_bandwidth(rt_rq);
> > +
> > +                       raw_spin_lock_irqsave(&rt_b->rt_runtime_lock, flags);
> > +                       raw_spin_lock(&rt_rq->rt_runtime_lock);
> > +                       rt_rq->rt_runtime = rt_b->rt_runtime;
> > +                       rt_rq->rt_period = rt_b->rt_period;
> > +                       rt_rq->rt_time = 0;
> > +                       raw_spin_unlock(&rt_rq->rt_runtime_lock);
> > +                       raw_spin_unlock_irqrestore(&rt_b->rt_runtime_lock, flags);
> > +               }
> > +       }
> > +}
> 
> 
> > +/*
> > + * Handle runtime rebalancing: try to push our bandwidth to
> > + * runqueues that need it.
> > + */
> > +static void do_balance_runtime(struct rt_rq *rt_rq)
> > +{
> > +       struct rq *rq = cpu_rq(smp_processor_id());
> > +       struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
> > +       struct root_domain *rd = rq->rd;
> > +       int i, weight, ret;
> > +       u64 rt_period, prev_runtime;
> > +       s64 diff;
> > +
> >         weight = cpumask_weight(rd->span);
> >  
> >         raw_spin_lock(&rt_b->rt_runtime_lock);
> > +       /*
> > +        * The raw_spin_lock() acts as an acquire barrier, ensuring
> > +        * that rt_balancing_disabled is accessed after taking the lock;
> > +        * since rt_reset_runtime() takes rt_runtime_lock after
> > +        * setting the disable flag we are sure that no bandwidth
> > +        * is migrated while the reset is in progress.
> > +        */
> 
> Note that LOCK != {RMB,MB}, what you can do is order the WMB with the
> UNLOCK+LOCK (== MB).
> 
> I'm thinking the WMB above is superfluous, either we are already in
> do_balance() and __rt_reset_runtime() will wait for us, or
> __rt_reset_runtime() will have done a LOCK+UNLOCK between setting
> ->rt_balancing_disabled here and we'll have done a LOCK before the read.
> 
> So we always have at least store+UNLOCK+LOCK+load, which can never be
> reordered.
> 
> IOW, look at it as if the store leaks into the rt_b->rt_runtime_lock
> section, in that case that lock properly serializes the store and these
> loads.
> 

The barrier can be removed.  Unfortunately the comments were not clear at
all; what I wanted to do was ensuring that *all* the bw balance operations
be stopped before the first loop in the reset path.  So I did not need
a full memory barrier in do_balance_runtime(), but the acquire barrier
implied by the spin_lock() (paired with the wmb() in the reset path),
was enough to prevent any new balancing op from moving bandwidth.

As you noticed, after the first reset loop a full mb() will be implied
by the lock+unlock sequence, so removing the wmb() would relax the
synchronisation constraints, theoretically allowing some balancing
operations to be started while the first reset loop is being executed.
Since no balancing operation will affect rt_b's already traversed by the
reset loop everything should be safe, so I'll remove the wmb().

The wmb() in __rt_restart_balancing() was needed for the same reason,
when reenabling balancing, so it too can be removed.


> > +       if (rq->rt_balancing_disabled)
> > +               goto out;
> 
> ( maybe call that label unlock )
> 

Will do,

Thank you!


> > +
> > +       prev_runtime = rt_rq->rt_runtime;
> >         rt_period = ktime_to_ns(rt_b->rt_period);
> > +
> >         for_each_cpu(i, rd->span) {
> >                 struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
> > +               struct rq *iter_rq = rq_of_rt_rq(iter);
> >  
> >                 if (iter == rt_rq)
> >                         continue;
> 
> Idem to the above ordering.
> 
> > +               if (iter_rq->rt_balancing_disabled)
> > +                       continue;
> > +
> >                 raw_spin_lock(&iter->rt_runtime_lock);
> >                 /*
> >                  * Either all rqs have inf runtime and there's nothing to steal 
> 
> 
