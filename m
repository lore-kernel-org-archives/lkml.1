Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZKBS4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZKBS4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZKBS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:56:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:44014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbZKBS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:56:44 -0500
Date: Mon, 2 Nov 2009 18:55:38 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, eparis@redhat.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256813310.7574.3.camel@marge.simson.net>
References: <1256813310.7574.3.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix kthread_bind() by moving the body of kthread_bind() to sched.c
Message-ID: <tip-48f69b95afd3b8f3d0dab1b822f12ed4f5bdb247@git.kernel.org>
Git-Commit-ID: 48f69b95afd3b8f3d0dab1b822f12ed4f5bdb247
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48f69b95afd3b8f3d0dab1b822f12ed4f5bdb247
Gitweb:     http://git.kernel.org/tip/48f69b95afd3b8f3d0dab1b822f12ed4f5bdb247
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 29 Oct 2009 11:48:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 19:37:57 +0100

sched: Fix kthread_bind() by moving the body of kthread_bind() to sched.c

Eric Paris reported that commit
f685ceacab07d3f6c236f04803e2f2f0dbcc5afb causes boot time
PREEMPT_DEBUG complaints.

 [    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
 [    4.593043] caller is task_hot+0x86/0xd0

Since kthread_bind() messes with scheduler internals, move the
body to sched.c, and lock the runqueue.

Reported-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Tested-by: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1256813310.7574.3.camel@marge.simson.net>
[ v2: fix !SMP build and clean up ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kthread.c |   23 -----------------------
 kernel/sched.c   |   31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5fe7099..ab7ae57 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -150,29 +150,6 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 EXPORT_SYMBOL(kthread_create);
 
 /**
- * kthread_bind - bind a just-created kthread to a cpu.
- * @k: thread created by kthread_create().
- * @cpu: cpu (might not be online, must be possible) for @k to run on.
- *
- * Description: This function is equivalent to set_cpus_allowed(),
- * except that @cpu doesn't need to be online, and the thread must be
- * stopped (i.e., just returned from kthread_create()).
- */
-void kthread_bind(struct task_struct *k, unsigned int cpu)
-{
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-	set_task_cpu(k, cpu);
-	k->cpus_allowed = cpumask_of_cpu(cpu);
-	k->rt.nr_cpus_allowed = 1;
-	k->flags |= PF_THREAD_BOUND;
-}
-EXPORT_SYMBOL(kthread_bind);
-
-/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index bf21adb..a7df695 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1996,6 +1996,37 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio, running);
 }
 
+/**
+ * kthread_bind - bind a just-created kthread to a cpu.
+ * @k: thread created by kthread_create().
+ * @cpu: cpu (might not be online, must be possible) for @k to run on.
+ *
+ * Description: This function is equivalent to set_cpus_allowed(),
+ * except that @cpu doesn't need to be online, and the thread must be
+ * stopped (i.e., just returned from kthread_create()).
+ *
+ * Function lives here instead of kthread.c because it messes with
+ * scheduler internals which require locking.
+ */
+void kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spin_lock_irqsave(&rq->lock, flags);
+	set_task_cpu(p, cpu);
+	p->cpus_allowed = cpumask_of_cpu(cpu);
+	p->rt.nr_cpus_allowed = 1;
+	p->flags |= PF_THREAD_BOUND;
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 #ifdef CONFIG_SMP
 /*
  * Is this task likely cache-hot:
