Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbYFSMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbYFSMgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbYFSMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:33534 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbYFSMfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:32 -0400
Message-Id: <20080619123314.113080419@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/10] sched: debug: add some rt debug output
Content-Disposition: inline; filename=sched-rt-bw-debug.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also display rt_rq information in /proc/sched_debug

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_debug.c |   40 +++++++++++++++++++++++++++++++++++++---
 kernel/sched_rt.c    |   14 ++++++++++++++
 2 files changed, 51 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -119,9 +119,7 @@ void print_cfs_rq(struct seq_file *m, in
 	struct sched_entity *last;
 	unsigned long flags;
 
-#if !defined(CONFIG_CGROUP_SCHED) || !defined(CONFIG_USER_SCHED)
-	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
-#else
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
 	char path[128] = "";
 	struct cgroup *cgroup = NULL;
 	struct task_group *tg = cfs_rq->tg;
@@ -133,6 +131,8 @@ void print_cfs_rq(struct seq_file *m, in
 		cgroup_path(cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
+#else
+	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
 
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
@@ -169,6 +169,39 @@ void print_cfs_rq(struct seq_file *m, in
 			cfs_rq->nr_spread_over);
 }
 
+void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
+{
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
+	char path[128] = "";
+	struct cgroup *cgroup = NULL;
+	struct task_group *tg = rt_rq->tg;
+
+	if (tg)
+		cgroup = tg->css.cgroup;
+
+	if (cgroup)
+		cgroup_path(cgroup, path, sizeof(path));
+
+	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
+#else
+	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
+#endif
+
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rt_rq->x))
+
+	P(rt_nr_running);
+	P(rt_throttled);
+	PN(rt_time);
+	PN(rt_runtime);
+
+#undef PN
+#undef P
+}
+
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = &per_cpu(runqueues, cpu);
@@ -208,6 +241,7 @@ static void print_cpu(struct seq_file *m
 #undef PN
 
 	print_cfs_stats(m, cpu);
+	print_rt_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1447,3 +1447,17 @@ static const struct sched_class rt_sched
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
+
+static void print_rt_stats(struct seq_file *m, int cpu)
+{
+	struct rt_rq *rt_rq;
+
+	rcu_read_lock();
+	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
+		print_rt_rq(m, cpu, rt_rq);
+	rcu_read_unlock();
+}
+#endif

-- 

