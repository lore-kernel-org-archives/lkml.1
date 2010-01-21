Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453Ab0AUEY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0AUEY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366Ab0AUEYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:24:40 -0500
Received: from kroah.org ([198.145.64.141]:60212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab0AUEXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:36 2010
Message-Id: <20100121041836.286147376@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [29/30] sched: Fix task priority bug
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 57785df5ac53c70da9fb53696130f3c551bfe1f9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3177,10 +3177,6 @@ static void pull_task(struct rq *src_rq,
 	deactivate_task(src_rq, p, 0);
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
-	/*
-	 * Note that idle threads have a prio of MAX_PRIO, for this test
-	 * to be always true for them.
-	 */
 	check_preempt_curr(this_rq, p, 0);
 }
 
@@ -6982,7 +6978,6 @@ void __cpuinit init_idle(struct task_str
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
 
-	idle->prio = idle->normal_prio = MAX_PRIO;
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
@@ -7686,7 +7681,6 @@ migration_call(struct notifier_block *nf
 		spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
-		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);


