Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbYCSWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbYCSWfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYCSVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:06:58 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55979 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965530AbYCSVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:06:54 -0400
Date: Wed, 19 Mar 2008 03:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
Message-ID: <20080319021555.GA15825@elte.hu>
References: <1205831650.3215.569.camel@ymzhang> <20080318195807.GA26887@elte.hu> <1205892420.3215.594.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205892420.3215.594.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Could you send me a patch against 2.6.25-rc6? Or just send me the 
> kernel/sched*.c?

sure - the jist of it should be in the patch below.

	Ingo

------------------>
Ingo Molnar (8):
      sched: clean up fair wakeup balancing
      sched: clean up fair wakeup balancing, #2
      sched: clean up fair wakeup balancing, #3
      sched: net socket wakeups are sync
      sched: improved affine wakeups
      sched: wakeup-buddy tasks are cache-hot
      sched: retune wake granularity
      sched: tune multi-core idle balancing

 include/linux/sched.h    |    3 +
 include/linux/topology.h |    1 -
 kernel/sched.c           |   11 +++-
 kernel/sched_debug.c     |    1 +
 kernel/sched_fair.c      |  191 ++++++++++++++++++++++++++++------------------
 net/core/sock.c          |    4 +-
 6 files changed, 134 insertions(+), 77 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 11d8e9a..3625fca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -929,6 +929,9 @@ struct sched_entity {
 	u64			vruntime;
 	u64			prev_sum_exec_runtime;
 
+	u64			last_wakeup;
+	u64			avg_overlap;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2352f46..2d8dac8 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -138,7 +138,6 @@
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_IDLE		\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\
diff --git a/kernel/sched.c b/kernel/sched.c
index d1ad69b..3f7c5eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1396,6 +1396,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
 
+	/*
+	 * Buddy candidates are cache hot:
+	 */
+	if (&p->se == cfs_rq_of(&p->se)->next)
+		return 1;
+
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
@@ -1855,10 +1861,11 @@ out_activate:
 		schedstat_inc(p, se.nr_wakeups_remote);
 	update_rq_clock(rq);
 	activate_task(rq, p, 1);
-	check_preempt_curr(rq, p);
 	success = 1;
 
 out_running:
+	check_preempt_curr(rq, p);
+
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -1892,6 +1899,8 @@ static void __sched_fork(struct task_struct *p)
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
+	p->se.last_wakeup		= 0;
+	p->se.avg_overlap		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start		= 0;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4b5e24c..ef358ba 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -288,6 +288,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.exec_start);
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
+	PN(se.avg_overlap);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2cc590..b85cac4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -73,13 +73,13 @@ unsigned int sysctl_sched_batch_wakeup_granularity = 10000000UL;
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -556,6 +556,21 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 	account_entity_enqueue(cfs_rq, se);
 }
 
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
+
+static void update_avg_stats(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (!se->last_wakeup)
+		return;
+
+	update_avg(&se->avg_overlap, se->sum_exec_runtime - se->last_wakeup);
+	se->last_wakeup = 0;
+}
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -566,6 +581,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
+		update_avg_stats(cfs_rq, se);
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -980,96 +996,121 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SMP
-static int select_task_rq_fair(struct task_struct *p, int sync)
+
+static const struct sched_class fair_sched_class;
+
+static int
+wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
+	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
+	    int idx, unsigned long load, unsigned long this_load,
+	    unsigned int imbalance)
 {
-	int cpu, this_cpu;
-	struct rq *rq;
-	struct sched_domain *sd, *this_sd = NULL;
-	int new_cpu;
+	struct task_struct *curr = this_rq->curr;
+	unsigned long tl = this_load;
+	unsigned long tl_per_task;
+
+	if (!(this_sd->flags & SD_WAKE_AFFINE))
+		return 0;
+
+	/*
+	 * If the currently running task will sleep within
+	 * a reasonable amount of time then attract this newly
+	 * woken task:
+	 */
+	if (sync && curr->sched_class == &fair_sched_class) {
+		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
+				p->se.avg_overlap < sysctl_sched_migration_cost)
+			return 1;
+	}
 
-	cpu      = task_cpu(p);
-	rq       = task_rq(p);
-	this_cpu = smp_processor_id();
-	new_cpu  = cpu;
+	schedstat_inc(p, se.nr_wakeups_affine_attempts);
+	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (cpu == this_cpu)
-		goto out_set_cpu;
+	/*
+	 * If sync wakeup then subtract the (maximum possible)
+	 * effect of the currently running task from the load
+	 * of the current CPU:
+	 */
+	if (sync)
+		tl -= current->se.load.weight;
+
+	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
+			100*(tl + p->se.load.weight) <= imbalance*load) {
+		/*
+		 * This domain has SD_WAKE_AFFINE and
+		 * p is cache cold in this domain, and
+		 * there is no bad imbalance.
+		 */
+		schedstat_inc(this_sd, ttwu_move_affine);
+		schedstat_inc(p, se.nr_wakeups_affine);
 
+		return 1;
+	}
+	return 0;
+}
+
+static int select_task_rq_fair(struct task_struct *p, int sync)
+{
+	struct sched_domain *sd, *this_sd = NULL;
+	int prev_cpu, this_cpu, new_cpu;
+	unsigned long load, this_load;
+	struct rq *rq, *this_rq;
+	unsigned int imbalance;
+	int idx;
+
+	prev_cpu	= task_cpu(p);
+	rq		= task_rq(p);
+	this_cpu	= smp_processor_id();
+	this_rq		= cpu_rq(this_cpu);
+	new_cpu		= prev_cpu;
+
+	/*
+	 * 'this_sd' is the first domain that both
+	 * this_cpu and prev_cpu are present in:
+	 */
 	for_each_domain(this_cpu, sd) {
-		if (cpu_isset(cpu, sd->span)) {
+		if (cpu_isset(prev_cpu, sd->span)) {
 			this_sd = sd;
 			break;
 		}
 	}
 
 	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
-		goto out_set_cpu;
+		goto out;
 
 	/*
 	 * Check for affine wakeup and passive balancing possibilities.
 	 */
-	if (this_sd) {
-		int idx = this_sd->wake_idx;
-		unsigned int imbalance;
-		unsigned long load, this_load;
-
-		imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
-
-		load = source_load(cpu, idx);
-		this_load = target_load(this_cpu, idx);
-
-		new_cpu = this_cpu; /* Wake to this CPU if we can */
-
-		if (this_sd->flags & SD_WAKE_AFFINE) {
-			unsigned long tl = this_load;
-			unsigned long tl_per_task;
-
-			/*
-			 * Attract cache-cold tasks on sync wakeups:
-			 */
-			if (sync && !task_hot(p, rq->clock, this_sd))
-				goto out_set_cpu;
-
-			schedstat_inc(p, se.nr_wakeups_affine_attempts);
-			tl_per_task = cpu_avg_load_per_task(this_cpu);
-
-			/*
-			 * If sync wakeup then subtract the (maximum possible)
-			 * effect of the currently running task from the load
-			 * of the current CPU:
-			 */
-			if (sync)
-				tl -= current->se.load.weight;
-
-			if ((tl <= load &&
-				tl + target_load(cpu, idx) <= tl_per_task) ||
-			       100*(tl + p->se.load.weight) <= imbalance*load) {
-				/*
-				 * This domain has SD_WAKE_AFFINE and
-				 * p is cache cold in this domain, and
-				 * there is no bad imbalance.
-				 */
-				schedstat_inc(this_sd, ttwu_move_affine);
-				schedstat_inc(p, se.nr_wakeups_affine);
-				goto out_set_cpu;
-			}
-		}
+	if (!this_sd)
+		goto out;
 
-		/*
-		 * Start passive balancing when half the imbalance_pct
-		 * limit is reached.
-		 */
-		if (this_sd->flags & SD_WAKE_BALANCE) {
-			if (imbalance*this_load <= 100*load) {
-				schedstat_inc(this_sd, ttwu_move_balance);
-				schedstat_inc(p, se.nr_wakeups_passive);
-				goto out_set_cpu;
-			}
+	idx = this_sd->wake_idx;
+
+	imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
+
+	load = source_load(prev_cpu, idx);
+	this_load = target_load(this_cpu, idx);
+
+	if (wake_affine(rq, this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
+				     load, this_load, imbalance))
+		return this_cpu;
+
+	if (prev_cpu == this_cpu)
+		goto out;
+
+	/*
+	 * Start passive balancing when half the imbalance_pct
+	 * limit is reached.
+	 */
+	if (this_sd->flags & SD_WAKE_BALANCE) {
+		if (imbalance*this_load <= 100*load) {
+			schedstat_inc(this_sd, ttwu_move_balance);
+			schedstat_inc(p, se.nr_wakeups_passive);
+			return this_cpu;
 		}
 	}
 
-	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
-out_set_cpu:
+out:
 	return wake_idle(new_cpu, p);
 }
 #endif /* CONFIG_SMP */
@@ -1092,6 +1133,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 		return;
 	}
 
+	se->last_wakeup = se->sum_exec_runtime;
+	if (unlikely(se == pse))
+		return;
+
 	cfs_rq_of(pse)->next = pse;
 
 	/*
diff --git a/net/core/sock.c b/net/core/sock.c
index 09cb3a7..2654c14 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1621,7 +1621,7 @@ static void sock_def_readable(struct sock *sk, int len)
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible(sk->sk_sleep);
+		wake_up_interruptible_sync(sk->sk_sleep);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1635,7 +1635,7 @@ static void sock_def_write_space(struct sock *sk)
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible(sk->sk_sleep);
+			wake_up_interruptible_sync(sk->sk_sleep);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))
