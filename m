Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZH0LKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZH0LKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZH0LKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:10:17 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:34374 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZH0LKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:10:13 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH] sched: Avoid division by zero - really
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jes@sgi.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <4A94FD58.8060207@kernel.org>
References: <1250855934.7538.30.camel@twins>
	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
	 <1251227486.7538.1174.camel@twins>  <4A94FD58.8060207@kernel.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 13:08:56 +0200
Message-Id: <1251371336.18584.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When re-computing the shares for each task group's cpu representation we
need the ratio of weight on each cpu vs the total weight of the sched
domain.

Since load-balancing is loosely (read not) synchronized, the weight of
individual cpus can change between doing the sum and calculating the
ratio.

The previous patch dealt with only one of the race scenarios, this patch
side steps them all by saving a snapshot of all the individual cpu
weights, thereby always working on a consistent set.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   50 +++++++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0e76b17..4591054 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1515,30 +1515,29 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+struct update_shares_data {
+	unsigned long rq_weight[NR_CPUS];
+};
+
+static DEFINE_PER_CPU(struct update_shares_data, update_shares_data);
+
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /*
  * Calculate and set the cpu's group shares.
  */
-static void
-update_group_shares_cpu(struct task_group *tg, int cpu,
-			unsigned long sd_shares, unsigned long sd_rq_weight,
-			unsigned long sd_eff_weight)
+static void update_group_shares_cpu(struct task_group *tg, int cpu,
+				    unsigned long sd_shares,
+				    unsigned long sd_rq_weight,
+				    struct update_shares_data *usd)
 {
-	unsigned long rq_weight;
-	unsigned long shares;
+	unsigned long shares, rq_weight;
 	int boost = 0;
 
-	if (!tg->se[cpu])
-		return;
-
-	rq_weight = tg->cfs_rq[cpu]->rq_weight;
+	rq_weight = usd->rq_weight[cpu];
 	if (!rq_weight) {
 		boost = 1;
 		rq_weight = NICE_0_LOAD;
-		if (sd_rq_weight == sd_eff_weight)
-			sd_eff_weight += NICE_0_LOAD;
-		sd_rq_weight = sd_eff_weight;
 	}
 
 	/*
@@ -1555,6 +1554,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
+		tg->cfs_rq[cpu]->rq_weight = boost ? 0 : rq_weight;
 		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1568,25 +1568,31 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, eff_weight = 0;
-	unsigned long shares = 0;
+	unsigned long weight, rq_weight = 0, shares = 0;
+	struct update_shares_data *usd;
 	struct sched_domain *sd = data;
+	unsigned long flags;
 	int i;
 
+	if (!tg->se[0])
+		return 0;
+
+	local_irq_save(flags);
+	usd = &__get_cpu_var(update_shares_data);
+
 	for_each_cpu(i, sched_domain_span(sd)) {
+		weight = tg->cfs_rq[i]->load.weight;
+		usd->rq_weight[i] = weight;
+
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
 		 * run here it will not get delayed by group starvation.
 		 */
-		weight = tg->cfs_rq[i]->load.weight;
-		tg->cfs_rq[i]->rq_weight = weight;
-		rq_weight += weight;
-
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		eff_weight += weight;
+		rq_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
@@ -1597,7 +1603,9 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		shares = tg->shares;
 
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight, eff_weight);
+		update_group_shares_cpu(tg, i, shares, rq_weight, usd);
+
+	local_irq_restore(flags);
 
 	return 0;
 }


