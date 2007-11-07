Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXKGMRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXKGMRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXKGMRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:17:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53748 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXKGMRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:17:09 -0500
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1194434956.6289.111.camel@twins>
References: <1194434956.6289.111.camel@twins>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 13:17:00 +0100
Message-Id: <1194437820.6289.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, missed a hunk

---
Subject: sched: avoid large irq-latencies in smp-balancing

SMP balancing is done with IRQs disabled and can iterate the full rq. When rqs
are large this can cause large irq-latencies. Limit the nr of iterations on
each run.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Peter Williams <pwil3058@bigpond.net.au>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   15 ++++++++++-----
 kernel/sysctl.c       |    8 ++++++++
 3 files changed, 19 insertions(+), 5 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -474,6 +474,12 @@ const_debug unsigned int sysctl_sched_fe
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
 /*
+ * Number of tasks to iterate in a single balance run.
+ * Limited because this is done with IRQs disabled.
+ */
+const_debug unsigned int sysctl_sched_nr_migrate = 32;
+
+/*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
  */
@@ -2237,7 +2243,7 @@ balance_tasks(struct rq *this_rq, int th
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct rq_iterator *iterator)
 {
-	int pulled = 0, pinned = 0, skip_for_load;
+	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
 
@@ -2251,10 +2257,10 @@ balance_tasks(struct rq *this_rq, int th
 	 */
 	p = iterator->start(iterator->arg);
 next:
-	if (!p)
+	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
 	/*
-	 * To help distribute high priority tasks accross CPUs we don't
+	 * To help distribute high priority tasks across CPUs we don't
 	 * skip a task if it will be the highest priority task (i.e. smallest
 	 * prio value) on its new queue regardless of its load weight
 	 */
@@ -2271,8 +2277,7 @@ next:
 	rem_load_move -= p->se.load.weight;
 
 	/*
-	 * We only want to steal up to the prescribed number of tasks
-	 * and the prescribed amount of weighted load.
+	 * We only want to steal up to the prescribed amount of weighted load.
 	 */
 	if (rem_load_move > 0) {
 		if (p->prio < *this_best_prio)
Index: linux-2.6-2/kernel/sysctl.c
===================================================================
--- linux-2.6-2.orig/kernel/sysctl.c
+++ linux-2.6-2/kernel/sysctl.c
@@ -298,6 +298,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_nr_migrate",
+		.data		= &sysctl_sched_nr_migrate,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -1466,6 +1466,7 @@ extern unsigned int sysctl_sched_batch_w
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_nr_migrate;
 #endif
 
 extern unsigned int sysctl_sched_compat_yield;


