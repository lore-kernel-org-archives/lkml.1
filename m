Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZKLLeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZKLLeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZKLLeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:34:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:51954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZKLLeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:34:07 -0500
Date: Thu, 12 Nov 2009 11:33:42 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <1258020464.6491.2.camel@marge.simson.net>,
	<new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix/add missing update_rq_clock() calls
Message-ID: <tip-055a00865dcfc8e61f3cbefbb879c9577bd36ae5@git.kernel.org>
Git-Commit-ID: 055a00865dcfc8e61f3cbefbb879c9577bd36ae5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  055a00865dcfc8e61f3cbefbb879c9577bd36ae5
Gitweb:     http://git.kernel.org/tip/055a00865dcfc8e61f3cbefbb879c9577bd36ae5
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 12 Nov 2009 11:07:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Nov 2009 12:28:29 +0100

sched: Fix/add missing update_rq_clock() calls

kthread_bind(), migrate_task() and sched_fork were missing
updates, and try_to_wake_up() was updating after having already
used the stale clock.

Aside from preventing potential latency hits, there' a side
benefit in that early boot printk time stamps become monotonic.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1258020464.6491.2.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..701eca4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2017,6 +2017,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 	}
 
 	spin_lock_irqsave(&rq->lock, flags);
+	update_rq_clock(rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
@@ -2115,6 +2116,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 	 * it is sufficient to simply update the task's cpu field.
 	 */
 	if (!p->se.on_rq && !task_running(rq, p)) {
+		update_rq_clock(rq);
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -2376,14 +2378,15 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
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
 
@@ -2545,6 +2548,7 @@ static void __sched_fork(struct task_struct *p)
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
+	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2581,7 +2585,10 @@ void sched_fork(struct task_struct *p, int clone_flags)
 #ifdef CONFIG_SMP
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
+	local_irq_save(flags);
+	update_rq_clock(cpu_rq(cpu));
 	set_task_cpu(p, cpu);
+	local_irq_restore(flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
