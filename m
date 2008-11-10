Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYKJJp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYKJJp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYKJJpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:45:49 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:38205 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYKJJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:45:48 -0500
X-SourceIP: 213.46.9.244
Subject: [PATCH] sched: cleanup debug info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20081110092350.GA3679@in.ibm.com>
References: <20081110092350.GA3679@in.ibm.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 10:46:32 +0100
Message-Id: <1226310392.2697.4054.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: cleanup debug info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Oct 30 23:57:11 CET 2008

While looking over the sched_debug code I noticed that we printed the rq
schedstats for every cfs_rq, ammend this.

Also change nr_spead_over into an int, and fix a little buglet in
min_vruntime printing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |    2 +-
 kernel/sched_debug.c |   41 +++++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -399,7 +399,7 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr, *next, *last;
 
-	unsigned long nr_spread_over;
+	unsigned int nr_spread_over;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -139,7 +139,7 @@ void print_cfs_rq(struct seq_file *m, in
 	last = __pick_last_entity(cfs_rq);
 	if (last)
 		max_vruntime = last->vruntime;
-	min_vruntime = rq->cfs.min_vruntime;
+	min_vruntime = cfs_rq->min_vruntime;
 	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
@@ -156,26 +156,8 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-#ifdef CONFIG_SCHEDSTATS
-#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
-
-	P(yld_exp_empty);
-	P(yld_act_empty);
-	P(yld_both_empty);
-	P(yld_count);
 
-	P(sched_switch);
-	P(sched_count);
-	P(sched_goidle);
-
-	P(ttwu_count);
-	P(ttwu_local);
-
-	P(bkl_count);
-
-#undef P
-#endif
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
+	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
@@ -250,6 +232,25 @@ static void print_cpu(struct seq_file *m
 #undef P
 #undef PN
 
+#ifdef CONFIG_SCHEDSTATS
+#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+
+	P(yld_exp_empty);
+	P(yld_act_empty);
+	P(yld_both_empty);
+	P(yld_count);
+
+	P(sched_switch);
+	P(sched_count);
+	P(sched_goidle);
+
+	P(ttwu_count);
+	P(ttwu_local);
+
+	P(bkl_count);
+
+#undef P
+#endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 



