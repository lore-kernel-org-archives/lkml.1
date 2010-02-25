Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193Ab0BYVoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:44:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158Ab0BYVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:58 -0500
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on
 runtime balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:28 +0100
Message-ID: <1267129708.22519.563.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:

>  /*
> + * Reset the balancing machinery, restarting from a safe runtime assignment
> + * on all the cpus/rt_rqs in the system.  There is room for improvements here,
> + * as this iterates through all the rt_rqs in the system; the main problem
> + * is that after the balancing has been running for some time we are not
> + * sure that the fragmentation of the free bandwidth it produced allows new
> + * groups to run where they need to run.  The caller has to make sure that
> + * only one instance of this function is running at any time.
>   */
> +static void __rt_reset_runtime(void)
>  {
> +       struct rq *rq;
> +       struct rt_rq *rt_rq;
> +       struct rt_bandwidth *rt_b;
> +       unsigned long flags;
> +       int i;
> +
> +       for_each_possible_cpu(i) {
> +               rq = cpu_rq(i);
> +
> +               rq->rt_balancing_disabled = 1;
> +               /*
> +                * Make sure that all the new calls to do_balance_runtime()
> +                * see the disable flag and do not migrate anything.  We will
> +                * implicitly wait for the old ones to terminate entering all
> +                * the rt_b->rt_runtime_lock, one by one.  Note that maybe
> +                * iterating over the task_groups first would be a good idea...
> +                */
> +               smp_wmb();
> +
> +               for_each_leaf_rt_rq(rt_rq, rq) {
> +                       rt_b = sched_rt_bandwidth(rt_rq);
> +
> +                       raw_spin_lock_irqsave(&rt_b->rt_runtime_lock, flags);
> +                       raw_spin_lock(&rt_rq->rt_runtime_lock);
> +                       rt_rq->rt_runtime = rt_b->rt_runtime;
> +                       rt_rq->rt_period = rt_b->rt_period;
> +                       rt_rq->rt_time = 0;
> +                       raw_spin_unlock(&rt_rq->rt_runtime_lock);
> +                       raw_spin_unlock_irqrestore(&rt_b->rt_runtime_lock, flags);
> +               }
> +       }
> +}


> +/*
> + * Handle runtime rebalancing: try to push our bandwidth to
> + * runqueues that need it.
> + */
> +static void do_balance_runtime(struct rt_rq *rt_rq)
> +{
> +       struct rq *rq = cpu_rq(smp_processor_id());
> +       struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
> +       struct root_domain *rd = rq->rd;
> +       int i, weight, ret;
> +       u64 rt_period, prev_runtime;
> +       s64 diff;
> +
>         weight = cpumask_weight(rd->span);
>  
>         raw_spin_lock(&rt_b->rt_runtime_lock);
> +       /*
> +        * The raw_spin_lock() acts as an acquire barrier, ensuring
> +        * that rt_balancing_disabled is accessed after taking the lock;
> +        * since rt_reset_runtime() takes rt_runtime_lock after
> +        * setting the disable flag we are sure that no bandwidth
> +        * is migrated while the reset is in progress.
> +        */

Note that LOCK != {RMB,MB}, what you can do is order the WMB with the
UNLOCK+LOCK (== MB).

I'm thinking the WMB above is superfluous, either we are already in
do_balance() and __rt_reset_runtime() will wait for us, or
__rt_reset_runtime() will have done a LOCK+UNLOCK between setting
->rt_balancing_disabled here and we'll have done a LOCK before the read.

So we always have at least store+UNLOCK+LOCK+load, which can never be
reordered.

IOW, look at it as if the store leaks into the rt_b->rt_runtime_lock
section, in that case that lock properly serializes the store and these
loads.

> +       if (rq->rt_balancing_disabled)
> +               goto out;

( maybe call that label unlock )

> +
> +       prev_runtime = rt_rq->rt_runtime;
>         rt_period = ktime_to_ns(rt_b->rt_period);
> +
>         for_each_cpu(i, rd->span) {
>                 struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
> +               struct rq *iter_rq = rq_of_rt_rq(iter);
>  
>                 if (iter == rt_rq)
>                         continue;

Idem to the above ordering.

> +               if (iter_rq->rt_balancing_disabled)
> +                       continue;
> +
>                 raw_spin_lock(&iter->rt_runtime_lock);
>                 /*
>                  * Either all rqs have inf runtime and there's nothing to steal 



