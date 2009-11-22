Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZKVMNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZKVMNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZKVMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:13:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:42815 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752382AbZKVMNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:13:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qiihkzS8qamAq9+xtv0FSK7FNmcAiFd1IvjXsnl
	pfmECghJaa2E3R
Subject: [patch] sched: finish fixing kthread_bind()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:13:40 +0100
Message-Id: <1258892020.14325.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: finish fixing kthread_bind()

kthread_bind() diddles task state without the task's runqueue locked,
which is against the rules.  Lock the task's runqueue, and update both
runqueue clocks in the event that the task is being bound to a remote cpu.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2007,7 +2007,7 @@ static inline void check_class_changed(s
  */
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq, *dest_rq = cpu_rq(cpu);
 	unsigned long flags;
 
 	/* Must have done schedule() in kthread() before we set_task_cpu */
@@ -2016,13 +2016,15 @@ void kthread_bind(struct task_struct *p,
 		return;
 	}
 
-	spin_lock_irqsave(&rq->lock, flags);
+	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
+	if (rq != dest_rq)
+		update_rq_clock(dest_rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
-	spin_unlock_irqrestore(&rq->lock, flags);
+	task_rq_unlock(rq, &flags);
 }
 EXPORT_SYMBOL(kthread_bind);
 


