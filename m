Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXKGL3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXKGL3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 06:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXKGL3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 06:29:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38808 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXKGL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:29:36 -0500
Subject: [PATCH] sched: avoid large irq-latencies in smp-balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 12:29:16 +0100
Message-Id: <1194434956.6289.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: avoid large irq-latencies in smp-balancing

SMP balancing is done with IRQs disabled and can iterate the full rq. When rqs
are large this can cause large irq-latencies. Limit the nr of iterations on
each run.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Peter Williams <pwil3058@bigpond.net.au>
---
 kernel/sched.c  |   10 ++++++++--
 kernel/sysctl.c |    8 ++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

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
 
@@ -2251,7 +2257,7 @@ balance_tasks(struct rq *this_rq, int th
 	 */
 	p = iterator->start(iterator->arg);
 next:
-	if (!p)
+	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
 	/*
 	 * To help distribute high priority tasks accross CPUs we don't
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


