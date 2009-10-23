Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZJWOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZJWOng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZJWOng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:43:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZJWOnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:43:35 -0400
Date: Fri, 23 Oct 2009 16:43:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091023144328.GA10521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Mike Galbraith (1):
      sched: Use LAST_BUDDY only to minimize negative wakeup preemption effects

Peter Zijlstra (2):
      sched: Disable SD_PREFER_LOCAL for MC/CPU domains
      sched: Do less agressive buddy clearing


 arch/x86/include/asm/topology.h |    1 +
 include/linux/topology.h        |    4 +-
 kernel/sched.c                  |    2 +-
 kernel/sched_fair.c             |   46 ++++++++++++++++++--------------------
 4 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 25a9284..d823c24 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,6 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fc0bf3e..57e6357 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -162,7 +162,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/kernel/sched.c b/kernel/sched.c
index 789001d..cae6700 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2008,7 +2008,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) &&
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..dfcf0c9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -863,10 +863,15 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
-		return cfs_rq->next;
+		se = cfs_rq->next;
 
+	/*
+	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 */
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
-		return cfs_rq->last;
+		se = cfs_rq->last;
+
+	clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1582,17 +1587,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
-	/*
-	 * Only set the backward buddy when the current task is still on the
-	 * rq. This can happen when a wakeup gets interleaved with schedule on
-	 * the ->pre_schedule() or idle_balance() point, either of which can
-	 * drop the rq lock.
-	 *
-	 * Also, during early boot the idle thread is in the fair class, for
-	 * obvious reasons its a bad idea to schedule back to the idle thread.
-	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
-		set_last_buddy(se);
 	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
@@ -1639,8 +1633,22 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 
 	BUG_ON(!pse);
 
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
+		/*
+		 * Only set the backward buddy when the current task is still
+		 * on the rq. This can happen when a wakeup gets interleaved
+		 * with schedule on the ->pre_schedule() or idle_balance()
+		 * point, either of which can * drop the rq lock.
+		 *
+		 * Also, during early boot the idle thread is in the fair class,
+		 * for obvious reasons its a bad idea to schedule back to it.
+		 */
+		if (unlikely(!se->on_rq || curr == rq->idle))
+			return;
+		if (sched_feat(LAST_BUDDY))
+			set_last_buddy(se);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
@@ -1654,16 +1662,6 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
-		/*
-		 * If se was a buddy, clear it so that it will have to earn
-		 * the favour again.
-		 *
-		 * If se was not a buddy, clear the buddies because neither
-		 * was elegible to run, let them earn it again.
-		 *
-		 * IOW. unconditionally clear buddies.
-		 */
-		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
