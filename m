Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYJQRau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYJQRau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYJQR3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:29:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbYJQR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:29:48 -0400
Message-Id: <20081017172829.568667401@chello.nl>
References: <20081017172701.047939625@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 19:27:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] sched: optimize group load balancer
Content-Disposition: inline; filename=sched-opt-group-balance.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that tg_shares_up() unconditionally takes rq-locks for all cpus
in the sched_domain. This hurts.

We need the rq-locks whenever we change the weight of the per-cpu group sched
entities. To allevate this a little, only change the weight when the new
weight is at least shares_thresh away from the old value.

This avoids the rq-lock for the top level entries, since those will never
be re-weighted, and fuzzes the lower level entries a little to gain performance
in semi-stable situations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Friesen <cfriesen@nortel.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   45 +++++++++++++++++++++++++--------------------
 kernel/sysctl.c       |   10 ++++++++++
 3 files changed, 36 insertions(+), 20 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1660,6 +1660,7 @@ extern unsigned int sysctl_sched_feature
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_shares_ratelimit;
+extern unsigned int sysctl_sched_shares_thresh;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -818,6 +818,13 @@ const_debug unsigned int sysctl_sched_nr
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
@@ -1453,8 +1460,8 @@ static void __set_se_shares(struct sched
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
@@ -1485,19 +1492,23 @@ __update_group_shares_cpu(struct task_gr
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
@@ -1526,14 +1537,8 @@ static int tg_shares_up(struct task_grou
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
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -277,6 +277,16 @@ static struct ctl_table kern_table[] = {
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

-- 

