Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZKYJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZKYJiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbZKYJiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:38:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbZKYJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:38:10 -0500
Subject: Re: [RFC][PATCH 0/7] perf trace: general-purpose scripting
 support, v2
From: Peter Zijlstra <peterz@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, anton@samba.org, hch@infradead.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1259137695.4027.45.camel@laptop>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
	 <1259137695.4027.45.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 10:38:11 +0100
Message-ID: <1259141891.4027.199.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 09:28 +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-25 at 01:15 -0600, Tom Zanussi wrote:
> > sched::sched_wakeup      0 01238.657997033     6183 firefox              comm=firefox, pid=6199, prio=120, success=1, target_cpu=1
> > sched::sched_switch      1 01238.657991740     7140 firefox              prev_comm=firefox, prev_pid=7140, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6199, next_prio=120
> > 
> > min_wakeup_latency: -5293 
> 
> Looks like we missed a clock update on the cross cpu wakeup, Mike was
> busy plugging those holes -- I've been starting at a patch that might
> cure this (amongst other things).

Hmm, current -tip should have that cured as per:

---
commit 055a00865dcfc8e61f3cbefbb879c9577bd36ae5
Author: Mike Galbraith <efault@gmx.de>
Date:   Thu Nov 12 11:07:44 2009 +0100

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


