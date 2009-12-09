Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZLIJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZLIJ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZLIJ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:57:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:45763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZLIJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:39 -0500
Date: Wed, 9 Dec 2009 09:55:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       y-goto@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, y-goto@jp.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <1257934048.23203.76.camel@twins>
References: <1257934048.23203.76.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: cgroup: Implement different treatment for idle shares
Message-ID: <tip-cd8ad40de36c2fe75f3b731bd70198b385895246@git.kernel.org>
Git-Commit-ID: cd8ad40de36c2fe75f3b731bd70198b385895246
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd8ad40de36c2fe75f3b731bd70198b385895246
Gitweb:     http://git.kernel.org/tip/cd8ad40de36c2fe75f3b731bd70198b385895246
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Dec 2009 18:00:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:09 +0100

sched: cgroup: Implement different treatment for idle shares

When setting the weight for a per-cpu task-group, we have to put in a
phantom weight when there is no work on that cpu, otherwise we'll not
service that cpu when new work gets placed there until we again update
the per-cpu weights.

We used to add these phantom weights to the total, so that the idle
per-cpu shares don't get inflated, this however causes the non-idle
parts to get deflated, causing unexpected weight distibutions.

Reverse this, so that the non-idle shares are correct but the idle
shares are inflated.

Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Tested-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1257934048.23203.76.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0170735..71eb062 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1614,7 +1614,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, shares = 0;
+	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
 	unsigned long *usd_rq_weight;
 	struct sched_domain *sd = data;
 	unsigned long flags;
@@ -1630,6 +1630,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		weight = tg->cfs_rq[i]->load.weight;
 		usd_rq_weight[i] = weight;
 
+		rq_weight += weight;
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1638,10 +1639,13 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		rq_weight += weight;
+		sum_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
+	if (!rq_weight)
+		rq_weight = sum_weight;
+
 	if ((!shares && rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 
