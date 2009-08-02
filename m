Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZHBNNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZHBNNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZHBNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:13:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:33783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZHBNND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:13:03 -0400
Date: Sun, 2 Aug 2009 13:12:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1248696557.6987.1615.camel@twins>
References: <1248696557.6987.1615.camel@twins>
Subject: [tip:sched/core] sched: Fix cgroup smp fairness
Message-ID: <tip-a5004278f0525dcb9aa43703ef77bf371ea837cd@git.kernel.org>
Git-Commit-ID: a5004278f0525dcb9aa43703ef77bf371ea837cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:12:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5004278f0525dcb9aa43703ef77bf371ea837cd
Gitweb:     http://git.kernel.org/tip/a5004278f0525dcb9aa43703ef77bf371ea837cd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 27 Jul 2009 14:04:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:26:06 +0200

sched: Fix cgroup smp fairness

Commit ec4e0e2fe018992d980910db901637c814575914 ("fix
inconsistency when redistribute per-cpu tg->cfs_rq shares")
broke cgroup smp fairness.

In order to avoid starvation of newly placed tasks, we never
quite set the share of an empty cpu group-task to 0, but
instead we set it as if there's a single NICE-0 task present.

If however we actually set this in cfs_rq[cpu]->shares, that
means the total shares for that group will be slightly inflated
every time we balance, causing the observed unfairness.

Fix this by setting cfs_rq[cpu]->shares to 0 but actually
setting the effective weight of the related se to the inflated
number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1248696557.6987.1615.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ce1056e..26976cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1523,13 +1523,18 @@ static void
 update_group_shares_cpu(struct task_group *tg, int cpu,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
-	unsigned long shares;
 	unsigned long rq_weight;
+	unsigned long shares;
+	int boost = 0;
 
 	if (!tg->se[cpu])
 		return;
 
 	rq_weight = tg->cfs_rq[cpu]->rq_weight;
+	if (!rq_weight) {
+		boost = 1;
+		rq_weight = NICE_0_LOAD;
+	}
 
 	/*
 	 *           \Sum shares * rq_weight
@@ -1546,8 +1551,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->shares = shares;
-
+		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
@@ -1560,7 +1564,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0;
+	unsigned long weight, rq_weight = 0, eff_weight = 0;
 	unsigned long shares = 0;
 	struct sched_domain *sd = data;
 	int i;
@@ -1572,11 +1576,13 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		 * run here it will not get delayed by group starvation.
 		 */
 		weight = tg->cfs_rq[i]->load.weight;
+		tg->cfs_rq[i]->rq_weight = weight;
+		rq_weight += weight;
+
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		tg->cfs_rq[i]->rq_weight = weight;
-		rq_weight += weight;
+		eff_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
@@ -1586,8 +1592,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight);
+	for_each_cpu(i, sched_domain_span(sd)) {
+		unsigned long sd_rq_weight = rq_weight;
+
+		if (!tg->cfs_rq[i]->rq_weight)
+			sd_rq_weight = eff_weight;
+
+		update_group_shares_cpu(tg, i, shares, sd_rq_weight);
+	}
 
 	return 0;
 }
