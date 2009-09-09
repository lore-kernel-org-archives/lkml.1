Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZIIIw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZIIIw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZIIIw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:52:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:58661 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751580AbZIIIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:52:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qNbcqsWrqgS1Bf9JGCeiFu+Tf1Y0y3rMv8ap3kl
	MQ/slQUFRaZcr2
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090909061308.GA28109@elte.hu>
References: <20090906205952.GA6516@elte.hu>
	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>
	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 10:52:24 +0200
Message-Id: <1252486344.28645.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 08:13 +0200, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Sep 08 2009, Peter Zijlstra wrote:
> > > On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
> > > > And here's a newer version.
> > > 
> > > I tinkered a bit with your proglet and finally found the 
> > > problem.
> > > 
> > > You used a single pipe per child, this means the loop in 
> > > run_child() would consume what it just wrote out until it got 
> > > force preempted by the parent which would also get woken.
> > > 
> > > This results in the child spinning a while (its full quota) and 
> > > only reporting the last timestamp to the parent.
> > 
> > Oh doh, that's not well thought out. Well it was a quick hack :-) 
> > Thanks for the fixup, now it's at least usable to some degree.
> 
> What kind of latencies does it report on your box?
> 
> Our vanilla scheduler default latency targets are:
> 
>   single-core: 20 msecs
>     dual-core: 40 msecs
>     quad-core: 60 msecs
>     opto-core: 80 msecs
> 
> You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via 
> /proc/sys/kernel/sched_latency_ns:
> 
>    echo 10000000 > /proc/sys/kernel/sched_latency_ns

He would also need to lower min_granularity, otherwise, it'd be larger
than the whole latency target.

I'm testing right now, and one thing that is definitely a problem is the
amount of sleeper fairness we're giving.  A full latency is just too
much short term fairness in my testing.  While sleepers are catching up,
hogs languish.  That's the biggest issue going on.

I've also been doing some timings of make -j4 (looking at idle time),
and find that child_runs_first is mildly detrimental to fork/exec load,
as are buddies.

I'm running with the below at the moment.  (the kthread/workqueue thing
is just because I don't see any reason for it to exist, so consider it
to be a waste of perfectly good math;)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 6ec4643..a44210e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,8 +16,6 @@
 #include <linux/mutex.h>
 #include <trace/events/sched.h>
 
-#define KTHREAD_NICE_LEVEL (-5)
-
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 
@@ -150,7 +148,6 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 		 * The kernel thread should not inherit these properties.
 		 */
 		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
 		set_cpus_allowed_ptr(create.result, cpu_all_mask);
 	}
 	return create.result;
@@ -226,7 +223,6 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_possible_map);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index c512a02..e68c341 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7124,33 +7124,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
  */
 cpumask_var_t nohz_cpu_mask;
 
-/*
- * Increase the granularity value when there are more CPUs,
- * because with more CPUs the 'effective latency' as visible
- * to users decreases. But the relationship is not linear,
- * so pick a second-best guess by going with the log2 of the
- * number of CPUs.
- *
- * This idea comes from the SD scheduler of Con Kolivas:
- */
-static inline void sched_init_granularity(void)
-{
-	unsigned int factor = 1 + ilog2(num_online_cpus());
-	const unsigned long limit = 200000000;
-
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
-
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
-
-	sysctl_sched_wakeup_granularity *= factor;
-
-	sysctl_sched_shares_ratelimit *= factor;
-}
-
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -9356,7 +9329,6 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed_ptr(current, non_isolated_cpus) < 0)
 		BUG();
-	sched_init_granularity();
 	free_cpumask_var(non_isolated_cpus);
 
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
@@ -9365,7 +9337,6 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
-	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e386e5d..ff7fec9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -51,7 +51,7 @@ static unsigned int sched_nr_latency = 5;
  * After fork, child runs first. (default) If set to 0 then
  * parent will (try to) run first.
  */
-const_debug unsigned int sysctl_sched_child_runs_first = 1;
+const_debug unsigned int sysctl_sched_child_runs_first = 0;
 
 /*
  * sys_sched_yield() compat mode
@@ -713,7 +713,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			unsigned long thresh = sysctl_sched_latency;
+			unsigned long thresh = sysctl_sched_min_granularity;
 
 			/*
 			 * Convert the sleeper threshold into virtual time.
@@ -1502,7 +1502,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	set_next_buddy(pse);
+	if (sched_feat(NEXT_BUDDY))
+		set_next_buddy(pse);
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 4569bfa..85d30d1 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -13,5 +13,6 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
-SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(LAST_BUDDY, 0)
+SCHED_FEAT(NEXT_BUDDY, 0)
 SCHED_FEAT(OWNER_SPIN, 1)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3c44b56..addfe2d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -317,8 +317,6 @@ static int worker_thread(void *__cwq)
 	if (cwq->wq->freezeable)
 		set_freezable();
 
-	set_user_nice(current, -5);
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&


