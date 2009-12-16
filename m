Return-Path: <linux-kernel-owner+w=401wt.eu-S1762340AbZLPRJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762340AbZLPRJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbZLPRGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:53824 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170518.039524041@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/12] sched: Move kthread_bind() back to kthread.c
Content-Disposition: inline; filename=foo5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kthread_bind() lost its dependencies on sched.c, move it back
where it came from.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/kthread.c |   23 +++++++++++++++++++++++
 kernel/sched.c   |   26 --------------------------
 2 files changed, 23 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c
+++ linux-2.6/kernel/kthread.c
@@ -150,6 +150,29 @@ struct task_struct *kthread_create(int (
 EXPORT_SYMBOL(kthread_create);
 
 /**
+ * kthread_bind - bind a just-created kthread to a cpu.
+ * @p: thread created by kthread_create().
+ * @cpu: cpu (might not be online, must be possible) for @k to run on.
+ *
+ * Description: This function is equivalent to set_cpus_allowed(),
+ * except that @cpu doesn't need to be online, and the thread must be
+ * stopped (i.e., just returned from kthread_create()).
+ */
+void kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+		WARN_ON(1);
+		return;
+	}
+
+	p->cpus_allowed = cpumask_of_cpu(cpu);
+	p->rt.nr_cpus_allowed = 1;
+	p->flags |= PF_THREAD_BOUND;
+}
+EXPORT_SYMBOL(kthread_bind);
+
+/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2002,32 +2002,6 @@ static inline void check_class_changed(s
 		p->sched_class->prio_changed(rq, p, oldprio, running);
 }
 
-/**
- * kthread_bind - bind a just-created kthread to a cpu.
- * @p: thread created by kthread_create().
- * @cpu: cpu (might not be online, must be possible) for @k to run on.
- *
- * Description: This function is equivalent to set_cpus_allowed(),
- * except that @cpu doesn't need to be online, and the thread must be
- * stopped (i.e., just returned from kthread_create()).
- *
- * Function lives here instead of kthread.c because it messes with
- * scheduler internals which require locking.
- */
-void kthread_bind(struct task_struct *p, unsigned int cpu)
-{
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	p->cpus_allowed = cpumask_of_cpu(cpu);
-	p->rt.nr_cpus_allowed = 1;
-	p->flags |= PF_THREAD_BOUND;
-}
-EXPORT_SYMBOL(kthread_bind);
-
 #ifdef CONFIG_SMP
 /*
  * Is this task likely cache-hot:

-- 

