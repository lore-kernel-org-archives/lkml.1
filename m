Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZHYTMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZHYTMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbZHYTMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:12:36 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:47082 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZHYTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:12:35 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: Avoid division by zero
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org, jes@sgi.com,
       jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
References: <1250855934.7538.30.camel@twins>
	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 21:11:26 +0200
Message-Id: <1251227486.7538.1174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yinghai, Balbir, Arjan,

Could you try the below to see if that fully does away with the /0 in
the group scheduler thing?

---
 kernel/sched.c |   53 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0e76b17..45cebe0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1515,30 +1515,33 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+struct update_shares_data {
+	spinlock_t lock;
+	unsigned long sum_weight;
+	unsigned long shares;
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
+static void update_group_shares_cpu(struct task_group *tg,
+				    struct update_shares_data *usd, int cpu)
 {
-	unsigned long rq_weight;
-	unsigned long shares;
+	unsigned long shares, rq_weight;
 	int boost = 0;
 
 	if (!tg->se[cpu])
 		return;
 
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
@@ -1546,7 +1549,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 	 * shares_i =  -----------------------------
 	 *                  \Sum_j rq_weight_j
 	 */
-	shares = (sd_shares * rq_weight) / sd_rq_weight;
+	shares = (usd->shares * rq_weight) / usd->sum_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
 
 	if (abs(shares - tg->se[cpu]->load.weight) >
@@ -1555,6 +1558,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
+		tg->cfs_rq[cpu]->rq_weight = boost ? 0 : rq_weight;
 		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1568,36 +1572,44 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, eff_weight = 0;
-	unsigned long shares = 0;
+	struct update_shares_data *usd = &get_cpu_var(update_shares_data);
+	unsigned long weight, sum_weight = 0, shares = 0;
 	struct sched_domain *sd = data;
+	unsigned long flags;
 	int i;
 
+	spin_lock_irqsave(&usd->lock, flags);
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
+		sum_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
-	if ((!shares && rq_weight) || shares > tg->shares)
+	if ((!shares && sum_weight) || shares > tg->shares)
 		shares = tg->shares;
 
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
+	usd->sum_weight = sum_weight;
+	usd->shares = shares;
+
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight, eff_weight);
+		update_group_shares_cpu(tg, usd, i);
+
+	spin_unlock_irqrestore(&usd->lock, flags);
+	put_cpu_var(update_shares_data);
 
 	return 0;
 }
@@ -9449,6 +9461,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
+		spin_lock_init(&per_cpu(update_shares_data, i).lock);
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 #ifdef CONFIG_CGROUP_SCHED


