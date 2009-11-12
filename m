Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZKLKHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZKLKHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZKLKHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:07:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:33091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751321AbZKLKHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:07:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Vpp4ETRkVQll67rs/vgwYO/zAhGTJDnuq1nIXZT
	kfNMeP5pZhsymt
Subject: [patch] sched: fix/add missing update_rq_clock() calls
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Nov 2009 11:07:44 +0100
Message-Id: <1258020464.6491.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: fix/add missing update_rq_clock() calls.

kthread_bind(), migrate_task() and sched_fork were missing updates, and
try_to_wake_up() was updating after having already used the stale clock.

Aside from preventing potential latency hits, there' a side benefit in that
early boot printk time stamps become monotonic.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux-2.6.32.git/kernel/sched.c
===================================================================
--- linux-2.6.32.git.orig/kernel/sched.c
+++ linux-2.6.32.git/kernel/sched.c
@@ -2019,6 +2019,7 @@ void kthread_bind(struct task_struct *p,
 	}
 
 	spin_lock_irqsave(&rq->lock, flags);
+	update_rq_clock(rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
@@ -2117,6 +2118,7 @@ migrate_task(struct task_struct *p, int
 	 * it is sufficient to simply update the task's cpu field.
 	 */
 	if (!p->se.on_rq && !task_running(rq, p)) {
+		update_rq_clock(rq);
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -2378,14 +2380,15 @@ static int try_to_wake_up(struct task_st
 	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
+		local_irq_save(flags);
+		rq = cpu_rq(cpu);
+		update_rq_clock(rq);
 		set_task_cpu(p, cpu);
-
+		local_irq_restore(flags);
+	}
 	rq = task_rq_lock(p, &flags);
 
-	if (rq != orig_rq)
-		update_rq_clock(rq);
-
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -2558,6 +2561,7 @@ static void __sched_fork(struct task_str
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
+	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2594,7 +2598,10 @@ void sched_fork(struct task_struct *p, i
 #ifdef CONFIG_SMP
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
+	local_irq_save(flags);
+	update_rq_clock(cpu_rq(cpu));
 	set_task_cpu(p, cpu);
+	local_irq_restore(flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))


