Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbYBNQTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbYBNQTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYBNQTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:19:39 -0500
Received: from viefep28-int.chello.at ([62.179.121.48]:3978 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYBNQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:19:38 -0500
X-Greylist: delayed 946 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 11:19:37 EST
Message-Id: <20080214160234.681387000@chello.nl>
References: <20080214155724.772744000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 14 Feb 2008 16:57:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>
Subject: [RFC][PATCH 2/2] sched: fair-group: per root-domain load balancing
Content-Disposition: inline; filename=sched-fair-dyn-balance-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the lb_monitor will walk all the domains/cpus from a single
cpu's timer interrupt. This will cause massive cache-trashing and cache-line
bouncing on larger machines.

Split the lb_monitor into root_domain (disjoint sched-domains).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Gregory Haskins <gregory.haskins.ml@gmail.com>
---
 kernel/sched.c      |  106 ++++++++++++++++++++++++++++------------------------
 kernel/sched_fair.c |    2 
 2 files changed, 59 insertions(+), 49 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -357,8 +357,6 @@ struct lb_monitor {
 	spinlock_t lock;
 };
 
-static struct lb_monitor lb_monitor;
-
 /*
  * How frequently should we rebalance_shares() across cpus?
  *
@@ -417,6 +415,9 @@ static void lb_monitor_wake(struct lb_mo
 	if (hrtimer_active(&lb_monitor->timer))
 		return;
 
+	/*
+	 * XXX: rd->load_balance && weight(rd->span) > 1
+	 */
 	if (nr_cpu_ids == 1)
 		return;
 
@@ -444,6 +445,11 @@ static void lb_monitor_init(struct lb_mo
 
 	spin_lock_init(&lb_monitor->lock);
 }
+
+static int lb_monitor_destroy(struct lb_monitor *lb_monitor)
+{
+	return hrtimer_cancel(&lb_monitor->timer);
+}
 #endif
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares);
@@ -607,6 +613,8 @@ struct root_domain {
 	 */
 	cpumask_t rto_mask;
 	atomic_t rto_count;
+
+	struct lb_monitor lb_monitor;
 };
 
 /*
@@ -6328,6 +6336,7 @@ static void rq_attach_root(struct rq *rq
 {
 	unsigned long flags;
 	const struct sched_class *class;
+	int active = 0;
 
 	spin_lock_irqsave(&rq->lock, flags);
 
@@ -6342,8 +6351,14 @@ static void rq_attach_root(struct rq *rq
 		cpu_clear(rq->cpu, old_rd->span);
 		cpu_clear(rq->cpu, old_rd->online);
 
-		if (atomic_dec_and_test(&old_rd->refcount))
+		if (atomic_dec_and_test(&old_rd->refcount)) {
+			/*
+			 * sync with active timers.
+			 */
+			active = lb_monitor_destroy(&old_rd->lb_monitor);
+
 			kfree(old_rd);
+		}
 	}
 
 	atomic_inc(&rd->refcount);
@@ -6358,6 +6373,9 @@ static void rq_attach_root(struct rq *rq
 			class->join_domain(rq);
 	}
 
+	if (active)
+		lb_monitor_wake(&rd->lb_monitor);
+
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -6367,6 +6385,8 @@ static void init_rootdomain(struct root_
 
 	cpus_clear(rd->span);
 	cpus_clear(rd->online);
+
+	lb_monitor_init(&rd->lb_monitor);
 }
 
 static void init_defrootdomain(void)
@@ -7398,10 +7418,6 @@ void __init sched_init(void)
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	lb_monitor_init(&lb_monitor);
-#endif
 #endif
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
@@ -7631,11 +7647,11 @@ void set_curr_task(int cpu, struct task_
  * distribute shares of all task groups among their schedulable entities,
  * to reflect load distribution across cpus.
  */
-static int rebalance_shares(struct sched_domain *sd, int this_cpu)
+static int rebalance_shares(struct root_domain *rd, int this_cpu)
 {
 	struct cfs_rq *cfs_rq;
 	struct rq *rq = cpu_rq(this_cpu);
-	cpumask_t sdspan = sd->span;
+	cpumask_t sdspan = rd->span;
 	int state = shares_idle;
 
 	/* Walk thr' all the task groups that we have */
@@ -7685,50 +7701,12 @@ static int rebalance_shares(struct sched
 	return state;
 }
 
-static int load_balance_shares(struct lb_monitor *lb_monitor)
+static void set_lb_monitor_timeout(struct lb_monitor *lb_monitor, int state)
 {
-	int i, cpu, state = shares_idle;
 	u64 max_timeout = (u64)sysctl_sched_max_bal_int_shares * NSEC_PER_MSEC;
 	u64 min_timeout = (u64)sysctl_sched_min_bal_int_shares * NSEC_PER_MSEC;
 	u64 timeout;
 
-	/* Prevent cpus going down or coming up */
-	/* get_online_cpus(); */
-	/* lockout changes to doms_cur[] array */
-	/* lock_doms_cur(); */
-	/*
-	 * Enter a rcu read-side critical section to safely walk rq->sd
-	 * chain on various cpus and to walk task group list
-	 * (rq->leaf_cfs_rq_list) in rebalance_shares().
-	 */
-	rcu_read_lock();
-
-	for (i = 0; i < ndoms_cur; i++) {
-		cpumask_t cpumap = doms_cur[i];
-		struct sched_domain *sd = NULL, *sd_prev = NULL;
-
-		cpu = first_cpu(cpumap);
-
-		/* Find the highest domain at which to balance shares */
-		for_each_domain(cpu, sd) {
-			if (!(sd->flags & SD_LOAD_BALANCE))
-				continue;
-			sd_prev = sd;
-		}
-
-		sd = sd_prev;
-		/* sd == NULL? No load balance reqd in this domain */
-		if (!sd)
-			continue;
-
-		state = max(state, rebalance_shares(sd, cpu));
-	}
-
-	rcu_read_unlock();
-
-	/* unlock_doms_cur(); */
-	/* put_online_cpus(); */
-
 	timeout = ktime_to_ns(lb_monitor->timeout);
 	switch (state) {
 	case shares_balanced:
@@ -7741,6 +7719,38 @@ static int load_balance_shares(struct lb
 		break;
 	}
 	lb_monitor->timeout = ns_to_ktime(timeout);
+}
+
+static int load_balance_shares(struct lb_monitor *lb_monitor)
+{
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
+	struct root_domain *rd;
+	struct sched_domain *sd, *sd_prev = NULL;
+	int state = shares_idle;
+
+	spin_lock(&rq->lock);
+	/*
+	 * root_domain will stay valid until timer exits - synchronized by
+	 * hrtimer_cancel().
+	 */
+	rd = rq->rd;
+	spin_unlock(&rq->lock);
+
+	/*
+	 * complicated way to find rd->load_balance
+	 */
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+		sd_prev = sd;
+	}
+	if (sd_prev)
+		state = max(state, rebalance_shares(rd, cpu));
+	rcu_read_unlock();
+
+	set_lb_monitor_timeout(lb_monitor, state);
 
 	return state;
 }
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -553,7 +553,7 @@ account_entity_enqueue(struct cfs_rq *cf
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-	lb_monitor_wake(&lb_monitor);
+	lb_monitor_wake(&rq_of(cfs_rq)->rd->lb_monitor);
 #endif
 }
 

--

