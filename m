Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYJUOYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYJUOYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYJUOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:24:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYJUOYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:24:12 -0400
Date: Tue, 21 Oct 2008 16:23:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes/updates
Message-ID: <20081021142359.GA22949@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest scheduler fixes/updates git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Miller (1):
      sched: kill unused scheduler decl.

Ingo Molnar (1):
      sched: disable the hrtick for now

Miao Xie (1):
      sched: fix the wrong mask_len

Mike Galbraith (1):
      sched: minor fast-path overhead reduction

Peter Zijlstra (5):
      sched: only update rq->clock while holding rq->lock
      sched: fix the wrong mask_len, cleanup
      sched: optimize group load balancer
      sched: fair scheduler should not resched rt tasks
      sched: revert back to per-rq vruntime


 include/linux/sched.h   |    2 +-
 kernel/sched.c          |   51 +++++++++++++++++++-------------------
 kernel/sched_fair.c     |   62 ++++++++++++++++++++++++++++++----------------
 kernel/sched_features.h |    2 +-
 kernel/sched_stats.h    |    2 +-
 kernel/sysctl.c         |   10 +++++++
 6 files changed, 79 insertions(+), 50 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c226c7b..4f59c8e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -287,7 +287,6 @@ extern void trap_init(void);
 extern void account_process_tick(struct task_struct *task, int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
-extern void hrtick_resched(void);
 
 extern void sched_show_task(struct task_struct *p);
 
@@ -1622,6 +1621,7 @@ extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_shares_ratelimit;
+extern unsigned int sysctl_sched_shares_thresh;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
diff --git a/kernel/sched.c b/kernel/sched.c
index 6f23059..11ca390 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -818,6 +818,13 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
 unsigned int sysctl_sched_shares_ratelimit = 250000;
 
 /*
+ * Inject some fuzzyness into changing the per-cpu group shares
+ * this avoids remote rq-locks at the expense of fairness.
+ * default: 4
+ */
+unsigned int sysctl_sched_shares_thresh = 4;
+
+/*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
@@ -1453,8 +1460,8 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares);
  * Calculate and set the cpu's group shares.
  */
 static void
-__update_group_shares_cpu(struct task_group *tg, int cpu,
-			  unsigned long sd_shares, unsigned long sd_rq_weight)
+update_group_shares_cpu(struct task_group *tg, int cpu,
+			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
 	int boost = 0;
 	unsigned long shares;
@@ -1485,19 +1492,23 @@ __update_group_shares_cpu(struct task_group *tg, int cpu,
 	 *
 	 */
 	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
+	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
 
-	/*
-	 * record the actual number of shares, not the boosted amount.
-	 */
-	tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
-	tg->cfs_rq[cpu]->rq_weight = rq_weight;
+	if (abs(shares - tg->se[cpu]->load.weight) >
+			sysctl_sched_shares_thresh) {
+		struct rq *rq = cpu_rq(cpu);
+		unsigned long flags;
 
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	else if (shares > MAX_SHARES)
-		shares = MAX_SHARES;
+		spin_lock_irqsave(&rq->lock, flags);
+		/*
+		 * record the actual number of shares, not the boosted amount.
+		 */
+		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
+		tg->cfs_rq[cpu]->rq_weight = rq_weight;
 
-	__set_se_shares(tg->se[cpu], shares);
+		__set_se_shares(tg->se[cpu], shares);
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
 }
 
 /*
@@ -1526,14 +1537,8 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!rq_weight)
 		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
 
-	for_each_cpu_mask(i, sd->span) {
-		struct rq *rq = cpu_rq(i);
-		unsigned long flags;
-
-		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, i, shares, rq_weight);
-		spin_unlock_irqrestore(&rq->lock, flags);
-	}
+	for_each_cpu_mask(i, sd->span)
+		update_group_shares_cpu(tg, i, shares, rq_weight);
 
 	return 0;
 }
@@ -4441,12 +4446,8 @@ need_resched_nonpreemptible:
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
-	/*
-	 * Do the rq-clock update outside the rq lock:
-	 */
-	local_irq_disable();
+	spin_lock_irq(&rq->lock);
 	update_rq_clock(rq);
-	spin_lock(&rq->lock);
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 18fd171..a0aa38b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -73,6 +73,8 @@ unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+static const struct sched_class fair_sched_class;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -334,7 +336,7 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= w / rw
+ * delta *= P[w / rw]
  */
 static inline unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
@@ -348,15 +350,13 @@ calc_delta_weight(unsigned long delta, struct sched_entity *se)
 }
 
 /*
- * delta *= rw / w
+ * delta /= w
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
 
 	return delta;
 }
@@ -386,26 +386,26 @@ static u64 __sched_period(unsigned long nr_running)
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
  *
- * s = p*w/rw
+ * s = p*P[w/rw]
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	unsigned long nr_running = cfs_rq->nr_running;
+
+	if (unlikely(!se->on_rq))
+		nr_running++;
+
+	return calc_delta_weight(__sched_period(nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w
  */
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
-
-	if (!se->on_rq)
-		nr_running++;
-
-	return __sched_period(nr_running);
+	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
 /*
@@ -627,7 +627,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice_add(cfs_rq, se);
+		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
@@ -747,7 +747,7 @@ pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	struct rq *rq = rq_of(cfs_rq);
 	u64 pair_slice = rq->clock - cfs_rq->pair_start;
 
-	if (!cfs_rq->next || pair_slice > sched_slice(cfs_rq, cfs_rq->next)) {
+	if (!cfs_rq->next || pair_slice > sysctl_sched_min_granularity) {
 		cfs_rq->pair_start = rq->clock;
 		return se;
 	}
@@ -848,11 +848,31 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		hrtick_start(rq, delta);
 	}
 }
+
+/*
+ * called from enqueue/dequeue and updates the hrtick when the
+ * current task is from our class and nr_running is low enough
+ * to matter.
+ */
+static void hrtick_update(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+
+	if (curr->sched_class != &fair_sched_class)
+		return;
+
+	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
+		hrtick_start_fair(rq, curr);
+}
 #else /* !CONFIG_SCHED_HRTICK */
 static inline void
 hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
 }
+
+static inline void hrtick_update(struct rq *rq)
+{
+}
 #endif
 
 /*
@@ -873,7 +893,7 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 		wakeup = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -895,7 +915,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 		sleep = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -1001,8 +1021,6 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 
 #ifdef CONFIG_SMP
 
-static const struct sched_class fair_sched_class;
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 7c9e8f4..fda0162 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -5,7 +5,7 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
-SCHED_FEAT(HRTICK, 1)
+SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8385d43..6757925 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -9,7 +9,7 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = NR_CPUS/32 * 9;
+	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
 	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
 
 	if (mask_str == NULL)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 617d41e..3d804f4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -276,6 +276,16 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_shares_thresh",
+		.data		= &sysctl_sched_shares_thresh,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
