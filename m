Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbZANL7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbZANL7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZANL7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:59:35 -0500
Received: from viefep12-int.chello.at ([62.179.121.32]:37831 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbZANL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:59:35 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 1/2] sched: introduce avg_wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114114026.969559732@chello.nl>
References: <20090114113917.199690328@chello.nl>
	 <20090114114026.969559732@chello.nl>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 12:59:31 +0100
Message-Id: <1231934371.7141.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps if I post the patch that builds...

---
Subject: sched: introduce avg_wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Dec 09 11:08:21 CET 2008

Introduce a new avg_wakeup statistic.

avg_wakeup is a measure of how frequently a task wakes up other tasks, it
represents the average time between wakeups, with a limit of avg_runtime
for when it doesn't wake up anybody.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 include/linux/sched.h |    3 +++
 kernel/sched.c        |   36 ++++++++++++++++++++++++++++++------
 kernel/sched_debug.c  |    1 +
 3 files changed, 34 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1725,6 +1725,9 @@ static void update_avg(u64 *avg, u64 sam
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	if (wakeup)
+		p->se.start_runtime = p->se.sum_exec_runtime;
+
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
@@ -1732,10 +1735,15 @@ static void enqueue_task(struct rq *rq, 
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep && p->se.last_wakeup) {
-		update_avg(&p->se.avg_overlap,
-			   p->se.sum_exec_runtime - p->se.last_wakeup);
-		p->se.last_wakeup = 0;
+	if (sleep) {
+		if (p->se.last_wakeup) {
+			update_avg(&p->se.avg_overlap,
+				p->se.sum_exec_runtime - p->se.last_wakeup);
+			p->se.last_wakeup = 0;
+		} else {
+			update_avg(&p->se.avg_wakeup,
+				sysctl_sched_wakeup_granularity);
+		}
 	}
 
 	sched_info_dequeued(p);
@@ -2403,6 +2411,22 @@ out_activate:
 	activate_task(rq, p, 1);
 	success = 1;
 
+	/*
+	 * Only attribute actual wakeups done by this task.
+	 */
+	if (!in_interrupt()) {
+		struct sched_entity *se = &current->se;
+		u64 sample = se->sum_exec_runtime;
+
+		if (se->last_wakeup)
+			sample -= se->last_wakeup;
+		else
+			sample -= se->start_runtime;
+		update_avg(&se->avg_wakeup, sample);
+
+		current->se.last_wakeup = current->se.sum_exec_runtime;
+	}
+
 out_running:
 	trace_sched_wakeup(rq, p, success);
 	check_preempt_curr(rq, p, sync);
@@ -2413,8 +2437,6 @@ out_running:
 		p->sched_class->task_wake_up(rq, p);
 #endif
 out:
-	current->se.last_wakeup = current->se.sum_exec_runtime;
-
 	task_rq_unlock(rq, &flags);
 
 	return success;
@@ -2445,6 +2467,8 @@ static void __sched_fork(struct task_str
 	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
+	p->se.start_runtime		= 0;
+	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start		= 0;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1035,6 +1035,9 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	u64			start_runtime;
+	u64			avg_wakeup;
+
 	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -397,6 +397,7 @@ void proc_sched_show_task(struct task_st
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
+	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 


