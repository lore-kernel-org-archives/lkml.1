Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYLPHkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYLPHkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYLPHhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:37:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbYLPHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:37:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=PztFP7ZQidzx85vramWebRhVg50HK+SK+pviShr260st7xjQecW6EnNq/Kylkfa7L
	hsF+vUTJUXXDpLrwb3kfw==
MIME-Version: 1.0
Date: Mon, 15 Dec 2008 23:37:50 -0800
Message-ID: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
Subject: [patch] sched: fix uneven per-cpu task_group share distribution
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing CFS scheduler on linux-2.6-tip tree
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip

We found that task which is pinned to a CPU could be starved relative to its
allocated fair share.

The per-cpu sched_enetity load share calculation in tg_shares_up /
update_group_shares_cpu distributes total task_group's share among all CPUs
for a given SD domain, this would dilute task_group's per-cpu share because
it distributes share to CPU that even has no load.  The trapped share is now
un-consumable and it leads to fair share starvation on the runnable CPU.
Peter was right that it is still required for the low level function to make
distinction between a boosted share that don't have any load and actual tg
share that should be distributed among CPUs in which the tg is running.

Patch to add that boost and we think the scheduler should only boost one
times of tg shares over all empty CPU that don't have any load for the
specific task_group in order to bound maximum temporary boost that a given
task_group can have.


Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/kernel/sched.c b/kernel/sched.c
index 1d673a9..7198a26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1465,24 +1465,34 @@ static void __set_se_shares(
  * Calculate and set the cpu's group shares.
  */
 static void
-update_group_shares_cpu(struct task_group *tg, int cpu,
+update_group_shares_cpu(struct task_group *tg, int cpu, int empty,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
-	unsigned long shares;
+	unsigned long shares, raw_shares;
 	unsigned long rq_weight;

 	if (!tg->se[cpu])
 		return;

 	rq_weight = tg->cfs_rq[cpu]->rq_weight;
-
-	/*
-	 *           \Sum shares * rq_weight
-	 * shares =  -----------------------
-	 *               \Sum rq_weight
-	 *
-	 */
-	shares = (sd_shares * rq_weight) / sd_rq_weight;
+	if (rq_weight) {
+		/*
+		 *           \Sum shares * rq_weight
+		 * shares =  -----------------------
+		 *               \Sum rq_weight
+		 *
+		 */
+		raw_shares = (sd_shares * rq_weight) / sd_rq_weight;
+		shares = raw_shares;
+	} else {
+		/*
+		 * If there are currently no tasks on the cpu pretend there
+		 * is one of average load so that when a new task gets to
+		 * run here it will not get delayed by group starvation.
+		 */
+		raw_shares = 0;
+		shares = sd_shares / empty;
+	}
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);

 	if (abs(shares - tg->se[cpu]->load.weight) >
@@ -1491,7 +1501,7 @@ update_group_shares_cpu(
 		unsigned long flags;

 		spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->shares = shares;
+		tg->cfs_rq[cpu]->shares = raw_shares;

 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1508,17 +1518,12 @@ static int tg_shares_up(
 	unsigned long weight, rq_weight = 0;
 	unsigned long shares = 0;
 	struct sched_domain *sd = data;
-	int i;
+	int i, empty = 0;

 	for_each_cpu(i, sched_domain_span(sd)) {
-		/*
-		 * If there are currently no tasks on the cpu pretend there
-		 * is one of average load so that when a new task gets to
-		 * run here it will not get delayed by group starvation.
-		 */
 		weight = tg->cfs_rq[i]->load.weight;
 		if (!weight)
-			weight = NICE_0_LOAD;
+			empty++;

 		tg->cfs_rq[i]->rq_weight = weight;
 		rq_weight += weight;
@@ -1532,7 +1537,7 @@ static int tg_shares_up(
 		shares = tg->shares;

 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight);
+		update_group_shares_cpu(tg, i, empty, shares, rq_weight);

 	return 0;
 }
