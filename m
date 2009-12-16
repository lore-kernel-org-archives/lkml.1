Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbZLPRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbZLPRGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbZLPRGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762273AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170517.732561278@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:35 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/12] sched: Use TASK_WAKING for fork wakups
Content-Disposition: inline; filename=foo11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For later convenience use TASK_WAKING for fresh tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2544,14 +2544,6 @@ static void __sched_fork(struct task_str
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
-
-	/*
-	 * We mark the process as running here, but have not actually
-	 * inserted it onto the runqueue yet. This guarantees that
-	 * nobody will actually run it, and a signal or other external
-	 * event cannot wake it up and insert it on the runqueue either.
-	 */
-	p->state = TASK_RUNNING;
 }
 
 /*
@@ -2562,6 +2554,12 @@ void sched_fork(struct task_struct *p, i
 	int cpu = get_cpu();
 
 	__sched_fork(p);
+	/*
+	 * We mark the process as waking here. This guarantees that
+	 * nobody will actually run it, and a signal or other external
+	 * event cannot wake it up and insert it on the runqueue either.
+	 */
+	p->state = TASK_WAKING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2630,7 +2628,8 @@ void wake_up_new_task(struct task_struct
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	BUG_ON(p->state != TASK_RUNNING);
+	BUG_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
@@ -6992,6 +6991,7 @@ void __cpuinit init_idle(struct task_str
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
+	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));

-- 

