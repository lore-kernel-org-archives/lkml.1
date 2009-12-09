Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZLIJ5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZLIJ5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZLIJ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:57:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:45770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZLIJ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:44 -0500
Date: Wed, 9 Dec 2009 09:55:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1259754383.4003.610.camel@laptop>
References: <1259754383.4003.610.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix task priority bug
Message-ID: <tip-57785df5ac53c70da9fb53696130f3c551bfe1f9@git.kernel.org>
Git-Commit-ID: 57785df5ac53c70da9fb53696130f3c551bfe1f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57785df5ac53c70da9fb53696130f3c551bfe1f9
Gitweb:     http://git.kernel.org/tip/57785df5ac53c70da9fb53696130f3c551bfe1f9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Dec 2009 09:59:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:10 +0100

sched: Fix task priority bug

83f9ac removed a call to effective_prio() in wake_up_new_task(), which
leads to tasks running at MAX_PRIO.

This is caused by the idle thread being set to MAX_PRIO before forking
off init. O(1) used that to make sure idle was always preempted, CFS
uses check_preempt_curr_idle() for that so we can savely remove this bit
of legacy code.

Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1259754383.4003.610.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 71eb062..3878f50 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3158,10 +3158,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	deactivate_task(src_rq, p, 0);
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
-	/*
-	 * Note that idle threads have a prio of MAX_PRIO, for this test
-	 * to be always true for them.
-	 */
 	check_preempt_curr(this_rq, p, 0);
 }
 
@@ -6992,7 +6988,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
 
-	idle->prio = idle->normal_prio = MAX_PRIO;
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
@@ -7696,7 +7691,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
-		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
