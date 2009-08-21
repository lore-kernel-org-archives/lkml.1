Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZHUOnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZHUOnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZHUOnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:43:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:56607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbZHUOnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:43:40 -0400
Date: Fri, 21 Aug 2009 14:42:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, jes@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, jes@sgi.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250855934.7538.30.camel@twins>
References: <1250855934.7538.30.camel@twins>
Subject: [tip:sched/core] sched: Avoid division by zero
Message-ID: <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
Git-Commit-ID: a8af7246c114bfd939e539f9566b872c06f6225c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 14:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8af7246c114bfd939e539f9566b872c06f6225c
Gitweb:     http://git.kernel.org/tip/a8af7246c114bfd939e539f9566b872c06f6225c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 Aug 2009 13:58:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 14:15:10 +0200

sched: Avoid division by zero

Patch a5004278f0525dcb9aa43703ef77bf371ea837cd (sched: Fix
cgroup smp fairness) introduced the possibility of a
divide-by-zero because load-balancing is not synchronized
between sched_domains.

This can cause the state of cpus to change between the first
and second loop over the sched domain in tg_shares_up().

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1250855934.7538.30.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b529ef..8f8a98e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1522,7 +1522,8 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares);
  */
 static void
 update_group_shares_cpu(struct task_group *tg, int cpu,
-			unsigned long sd_shares, unsigned long sd_rq_weight)
+			unsigned long sd_shares, unsigned long sd_rq_weight,
+			unsigned long sd_eff_weight)
 {
 	unsigned long rq_weight;
 	unsigned long shares;
@@ -1535,13 +1536,15 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 	if (!rq_weight) {
 		boost = 1;
 		rq_weight = NICE_0_LOAD;
+		if (sd_rq_weight == sd_eff_weight)
+			sd_eff_weight += NICE_0_LOAD;
+		sd_rq_weight = sd_eff_weight;
 	}
 
 	/*
-	 *           \Sum shares * rq_weight
-	 * shares =  -----------------------
-	 *               \Sum rq_weight
-	 *
+	 *             \Sum_j shares_j * rq_weight_i
+	 * shares_i =  -----------------------------
+	 *                  \Sum_j rq_weight_j
 	 */
 	shares = (sd_shares * rq_weight) / sd_rq_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
@@ -1593,14 +1596,8 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	for_each_cpu(i, sched_domain_span(sd)) {
-		unsigned long sd_rq_weight = rq_weight;
-
-		if (!tg->cfs_rq[i]->rq_weight)
-			sd_rq_weight = eff_weight;
-
-		update_group_shares_cpu(tg, i, shares, sd_rq_weight);
-	}
+	for_each_cpu(i, sched_domain_span(sd))
+		update_group_shares_cpu(tg, i, shares, rq_weight, eff_weight);
 
 	return 0;
 }
