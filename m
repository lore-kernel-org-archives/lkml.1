Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYLSWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYLSWdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYLSWdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:33:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYLSWdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:33:01 -0500
Date: Fri, 19 Dec 2008 23:31:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       a.p.zijlstra@chello.nl, dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz, rusty@rustcorp.com.au
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081219223130.GA13172@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com> <20081219135508.9c6217ba.akpm@linux-foundation.org> <20081219141928.3c2939ef.akpm@linux-foundation.org> <20081219222709.GN2351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219222709.GN2351@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > [   74.013893]  <EOI> <0>Code: 8b 47 08 4a 8b 0c 00 48 85 c9 0f 84 c3 00 00 00 49 8b 47 10 4a 8b 04 00 48 8b 80 a8 00 00 00 48 85 c0 74 13 48 0f af 45 c8 31 d2 <48> f7 75 c0 49 89 c6 48 89 c6 eb 16 48 63 55 d0 48 8b 45 c8 45 
> > [   74.013893] RIP  [<ffffffff802375d8>] tg_shares_up+0x113/0x1f1
> > [   74.013893]  RSP <ffff88025e057d88>
> > [   74.020022] ---[ end trace 2fc4046e394f2312 ]---
> > [   74.020188] Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > config: http://userweb.kernel.org/~akpm/config-akpm2.txt
> > 
> > I'll try hacking some div-by-zero avoidance into update_group_shares_cpu().
> 
> hm, weird - Yinghai noticed this crash in -tip and we have that patch 
> zapped from all -*-next branches already.

I guess you applied Ken's patch from email and had it in -mm? We have a 
new version of that patch from Ken now based on Yinghai's bugreport - only 
lightly tested for now.

	Ingo

----------->
>From d71f5a7c8bf9cd7c74159a53e522e363f2eddaf5 Mon Sep 17 00:00:00 2001
From: Ken Chen <kenchen@google.com>
Date: Fri, 19 Dec 2008 10:11:50 -0800
Subject: [PATCH] sched: fix uneven per-cpu task_group share distribution

Impact: fix group scheduling behavior

While testing CFS scheduler on linux-2.6-tip tree:

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ae5ca3f..7d07c97 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1475,24 +1475,34 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares);
  * Calculate and set the cpu's group shares.
  */
 static void
-update_group_shares_cpu(struct task_group *tg, int cpu,
+update_group_shares_cpu(struct task_group *tg, int cpu, unsigned long boost,
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
+	if (rq_weight && sd_rq_weight) {
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
+		shares = boost;
+	}
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
 
 	if (abs(shares - tg->se[cpu]->load.weight) >
@@ -1501,7 +1511,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->shares = shares;
+		tg->cfs_rq[cpu]->shares = raw_shares;
 
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1517,18 +1527,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
 {
 	unsigned long weight, rq_weight = 0;
 	unsigned long shares = 0;
+	unsigned long boost;
 	struct sched_domain *sd = data;
-	int i;
+	int i, no_load_count = 0;
 
 	for_each_cpu(i, sched_domain_span(sd)) {
-		/*
-		 * If there are currently no tasks on the cpu pretend there
-		 * is one of average load so that when a new task gets to
-		 * run here it will not get delayed by group starvation.
-		 */
 		weight = tg->cfs_rq[i]->load.weight;
 		if (!weight)
-			weight = NICE_0_LOAD;
+			no_load_count++;
 
 		tg->cfs_rq[i]->rq_weight = weight;
 		rq_weight += weight;
@@ -1541,8 +1547,13 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
+	if (no_load_count)
+		boost = shares / no_load_count;
+	else
+		boost = shares / cpumask_weight(sched_domain_span(sd));
+
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight);
+		update_group_shares_cpu(tg, i, boost, shares, rq_weight);
 
 	return 0;
 }
