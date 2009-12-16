Return-Path: <linux-kernel-owner+w=401wt.eu-S935191AbZLPSij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbZLPSij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935163AbZLPSi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:38:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935146AbZLPSiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:11 -0500
Date: Wed, 16 Dec 2009 18:37:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.732561278@chello.nl>
References: <20091216170517.732561278@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use TASK_WAKING for fork wakups
Message-ID: <tip-06b83b5fbea273672822b6ee93e16781046553ec@git.kernel.org>
Git-Commit-ID: 06b83b5fbea273672822b6ee93e16781046553ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06b83b5fbea273672822b6ee93e16781046553ec
Gitweb:     http://git.kernel.org/tip/06b83b5fbea273672822b6ee93e16781046553ec
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:55 +0100

sched: Use TASK_WAKING for fork wakups

For later convenience use TASK_WAKING for fresh tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.732561278@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1d8ca25..1672823 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2540,14 +2540,6 @@ static void __sched_fork(struct task_struct *p)
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
@@ -2558,6 +2550,12 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
@@ -2626,7 +2624,8 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	BUG_ON(p->state != TASK_RUNNING);
+	BUG_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
@@ -6984,6 +6983,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
+	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
