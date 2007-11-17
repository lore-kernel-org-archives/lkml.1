Return-Path: <linux-kernel-owner+w=401wt.eu-S935379AbXKQGa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379AbXKQGa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762548AbXKQGYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:49 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38180 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437AbXKQGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:41 -0500
Message-Id: <20071117062405.634159013@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 16/17] Fix schedstat handling
Content-Disposition: inline; filename=rt-balance-wakup-fix-schedstat.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins RT balancing broke sched domains.
This is a fix to allow it to still work.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |   17 ++++++++++++++---
 kernel/sched_fair.c     |   19 ++++++++++++++-----
 kernel/sched_idletask.c |    3 ++-
 kernel/sched_rt.c       |    3 ++-
 5 files changed, 34 insertions(+), 11 deletions(-)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-17 00:15:57.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-17 00:15:57.000000000 -0500
@@ -1453,6 +1453,7 @@ static int try_to_wake_up(struct task_st
 	unsigned long flags;
 	long old_state;
 	struct rq *rq;
+	struct sched_domain *this_sd = NULL;
 #ifdef CONFIG_SMP
 	int new_cpu;
 #endif
@@ -1476,10 +1477,20 @@ static int try_to_wake_up(struct task_st
 	schedstat_inc(rq, ttwu_count);
 	if (cpu == this_cpu)
 		schedstat_inc(rq, ttwu_local);
-	else
-		schedstat_inc(rq->sd, ttwu_wake_remote);
+	else {
+#ifdef CONFIG_SCHEDSTATS
+		struct sched_domain *sd;
+		for_each_domain(this_cpu, sd) {
+			if (cpu_isset(cpu, sd->span)) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				this_sd = sd;
+				break;
+			}
+		}
+#endif /* CONFIG_SCHEDSTATES */
+	}
 
-	new_cpu = p->sched_class->select_task_rq(p, sync);
+	new_cpu = p->sched_class->select_task_rq(p, this_sd, sync);
 
 	if (new_cpu != cpu) {
 		set_task_cpu(p, new_cpu);
Index: linux-compile.git/include/linux/sched.h
===================================================================
--- linux-compile.git.orig/include/linux/sched.h	2007-11-17 00:15:57.000000000 -0500
+++ linux-compile.git/include/linux/sched.h	2007-11-17 00:15:57.000000000 -0500
@@ -823,7 +823,8 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
-	int  (*select_task_rq)(struct task_struct *p, int sync);
+	int  (*select_task_rq)(struct task_struct *p,
+			       struct sched_domain *sd, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
Index: linux-compile.git/kernel/sched_fair.c
===================================================================
--- linux-compile.git.orig/kernel/sched_fair.c	2007-11-17 00:15:57.000000000 -0500
+++ linux-compile.git/kernel/sched_fair.c	2007-11-17 00:43:44.000000000 -0500
@@ -611,11 +611,12 @@ static inline int wake_idle(int cpu, str
 #endif
 
 #ifdef CONFIG_SMP
-static int select_task_rq_fair(struct task_struct *p, int sync)
+static int select_task_rq_fair(struct task_struct *p,
+			       struct sched_domain *this_sd, int sync)
 {
 	int cpu, this_cpu;
 	struct rq *rq;
-	struct sched_domain *sd, *this_sd = NULL;
+	struct sched_domain *sd;
 	int new_cpu;
 
 	cpu      = task_cpu(p);
@@ -623,15 +624,23 @@ static int select_task_rq_fair(struct ta
 	this_cpu = smp_processor_id();
 	new_cpu  = cpu;
 
+	if (cpu == this_cpu || unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
+		goto out_set_cpu;
+
+#ifndef CONFIG_SCHEDSTATS
+	/*
+	 * If SCHEDSTATS is configured, then this_sd would
+	 * have already been determined.
+	 */
 	for_each_domain(this_cpu, sd) {
 		if (cpu_isset(cpu, sd->span)) {
 			this_sd = sd;
 			break;
 		}
 	}
-
-	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
-		goto out_set_cpu;
+#else
+	(void)sd; /* unused */
+#endif /* CONFIG_SCHEDSTATS */
 
 	/*
 	 * Check for affine wakeup and passive balancing possibilities.
Index: linux-compile.git/kernel/sched_idletask.c
===================================================================
--- linux-compile.git.orig/kernel/sched_idletask.c	2007-11-17 00:15:57.000000000 -0500
+++ linux-compile.git/kernel/sched_idletask.c	2007-11-17 00:15:57.000000000 -0500
@@ -6,7 +6,8 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sync)
+static int select_task_rq_idle(struct task_struct *p,
+			       struct sched_domain *sd, int sync)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-17 00:15:57.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-17 00:44:31.000000000 -0500
@@ -46,7 +46,8 @@ static void update_rt_migration(struct r
 
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sync)
+static int select_task_rq_rt(struct task_struct *p,
+			     struct sched_domain *sd, int sync)
 {
 	struct rq *rq = task_rq(p);
 

-- 
