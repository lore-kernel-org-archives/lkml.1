Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYKES5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYKES5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYKES46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:56:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYKES45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:56:57 -0500
Date: Wed, 5 Nov 2008 19:56:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler fixes
Message-ID: <20081105185644.GA24199@elte.hu>
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

these are a group of scheduler performance fixes from Peter, Mike and 
myself.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: re-tune balancing

Peter Zijlstra (4):
      sched: cleanup fair task selection
      sched: fix fair preempt check
      sched: backward looking buddy
      sched: fix buddies for group scheduling


 arch/x86/include/asm/topology.h |    7 ++--
 include/linux/topology.h        |    4 +-
 kernel/sched.c                  |    6 ++-
 kernel/sched_fair.c             |   76 +++++++++++++++++++++++++--------------
 kernel/sched_features.h         |    1 +
 5 files changed, 60 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 90ac771..4850e4b 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -154,7 +154,7 @@ extern unsigned long node_remap_size[];
 
 #endif
 
-/* sched_domains SD_NODE_INIT for NUMAQ machines */
+/* sched_domains SD_NODE_INIT for NUMA machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
 	.min_interval		= 8,			\
 	.max_interval		= 32,			\
@@ -169,8 +169,9 @@ extern unsigned long node_remap_size[];
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2158fc0..34a7ee0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -146,10 +146,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
 				| BALANCE_FOR_PKG_POWER,\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..82cc839 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -397,7 +397,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next;
+	struct sched_entity *curr, *next, *last;
 
 	unsigned long nr_spread_over;
 
@@ -1805,7 +1805,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && (&p->se == cfs_rq_of(&p->se)->next))
+	if (sched_feat(CACHE_HOT_BUDDY) &&
+			(&p->se == cfs_rq_of(&p->se)->next ||
+			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
 	if (p->sched_class != &fair_sched_class)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ce514af..51aa3e1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -341,23 +341,20 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		cfs_rq->rb_leftmost = next_node;
 	}
 
-	if (cfs_rq->next == se)
-		cfs_rq->next = NULL;
-
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
-{
-	return cfs_rq->rb_leftmost;
-}
-
 static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
+	struct rb_node *left = cfs_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_entity, run_node);
 }
 
-static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
@@ -741,6 +738,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 #endif
 	}
 
+	if (cfs_rq->last == se)
+		cfs_rq->last = NULL;
+
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
+
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
@@ -794,24 +797,15 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static int
 wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
-static struct sched_entity *
-pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	if (!cfs_rq->next || wakeup_preempt_entity(cfs_rq->next, se) == 1)
-		return se;
-
-	return cfs_rq->next;
-}
-
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = NULL;
+	struct sched_entity *se = __pick_next_entity(cfs_rq);
 
-	if (first_fair(cfs_rq)) {
-		se = __pick_next_entity(cfs_rq);
-		se = pick_next(cfs_rq, se);
-		set_next_entity(cfs_rq, se);
-	}
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
+		return cfs_rq->next;
+
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
+		return cfs_rq->last;
 
 	return se;
 }
@@ -1325,26 +1319,53 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 	return 0;
 }
 
+static void set_last_buddy(struct sched_entity *se)
+{
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->last = se;
+}
+
+static void set_next_buddy(struct sched_entity *se)
+{
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->next = se;
+}
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 {
 	struct task_struct *curr = rq->curr;
-	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 
 	if (unlikely(rt_prio(p->prio))) {
+		struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+
 		update_rq_clock(rq);
 		update_curr(cfs_rq);
 		resched_task(curr);
 		return;
 	}
 
+	if (unlikely(p->sched_class != &fair_sched_class))
+		return;
+
 	if (unlikely(se == pse))
 		return;
 
-	cfs_rq_of(pse)->next = pse;
+	/*
+	 * Only set the backward buddy when the current task is still on the
+	 * rq. This can happen when a wakeup gets interleaved with schedule on
+	 * the ->pre_schedule() or idle_balance() point, either of which can
+	 * drop the rq lock.
+	 *
+	 * Also, during early boot the idle thread is in the fair class, for
+	 * obvious reasons its a bad idea to schedule back to the idle thread.
+	 */
+	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
+		set_last_buddy(se);
+	set_next_buddy(pse);
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1396,6 +1417,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
+		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index fda0162..da5d93b 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -12,3 +12,4 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
+SCHED_FEAT(LAST_BUDDY, 1)
