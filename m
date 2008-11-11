Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYKKS0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYKKS0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYKKSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:25:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYKKSZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:25:57 -0500
Date: Tue, 11 Nov 2008 19:25:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081111182545.GA17037@elte.hu>
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

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Oleg Nesterov (1):
      fix for account_group_exec_runtime(), make sure ->signal can't be freed under rq->lock

Peter Zijlstra (2):
      sched: clean up debug info
      sched: release buddies on yield


 include/linux/sched.h |    1 +
 kernel/exit.c         |    5 +++++
 kernel/sched.c        |   10 +++++++++-
 kernel/sched_debug.c  |   41 +++++++++++++++++++++--------------------
 kernel/sched_fair.c   |   17 ++++++++++++-----
 5 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 295b7c7..644ffbd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -247,6 +247,7 @@ extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(void);
+extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
diff --git a/kernel/exit.c b/kernel/exit.c
index 80137a5..ae2b92b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -141,6 +141,11 @@ static void __exit_signal(struct task_struct *tsk)
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
+		/*
+		 * Make sure ->signal can't go away under rq->lock,
+		 * see account_group_exec_runtime().
+		 */
+		task_rq_unlock_wait(tsk);
 		__cleanup_signal(sig);
 	}
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 57c933f..50a21f9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -399,7 +399,7 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr, *next, *last;
 
-	unsigned long nr_spread_over;
+	unsigned int nr_spread_over;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
@@ -969,6 +969,14 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	}
 }
 
+void task_rq_unlock_wait(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+
+	smp_mb(); /* spin-unlock-wait is not a full memory barrier */
+	spin_unlock_wait(&rq->lock);
+}
+
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5ae1776..48ecc51 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -144,7 +144,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	last = __pick_last_entity(cfs_rq);
 	if (last)
 		max_vruntime = last->vruntime;
-	min_vruntime = rq->cfs.min_vruntime;
+	min_vruntime = cfs_rq->min_vruntime;
 	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
@@ -161,26 +161,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-#ifdef CONFIG_SCHEDSTATS
-#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
-
-	P(yld_exp_empty);
-	P(yld_act_empty);
-	P(yld_both_empty);
-	P(yld_count);
 
-	P(sched_switch);
-	P(sched_count);
-	P(sched_goidle);
-
-	P(ttwu_count);
-	P(ttwu_local);
-
-	P(bkl_count);
-
-#undef P
-#endif
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
+	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
@@ -260,6 +242,25 @@ static void print_cpu(struct seq_file *m, int cpu)
 #undef P
 #undef PN
 
+#ifdef CONFIG_SCHEDSTATS
+#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+
+	P(yld_exp_empty);
+	P(yld_act_empty);
+	P(yld_both_empty);
+	P(yld_count);
+
+	P(sched_switch);
+	P(sched_count);
+	P(sched_goidle);
+
+	P(ttwu_count);
+	P(ttwu_local);
+
+	P(bkl_count);
+
+#undef P
+#endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 51aa3e1..98345e4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -716,6 +716,15 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
+static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (cfs_rq->last == se)
+		cfs_rq->last = NULL;
+
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
+}
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -738,11 +747,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 #endif
 	}
 
-	if (cfs_rq->last == se)
-		cfs_rq->last = NULL;
-
-	if (cfs_rq->next == se)
-		cfs_rq->next = NULL;
+	clear_buddies(cfs_rq, se);
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
@@ -977,6 +982,8 @@ static void yield_task_fair(struct rq *rq)
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
+	clear_buddies(cfs_rq, se);
+
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
 		update_rq_clock(rq);
 		/*
