Return-Path: <linux-kernel-owner+w=401wt.eu-S935223AbZLPSjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223AbZLPSjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935171AbZLPSjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:39:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:53507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188AbZLPSjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:39:11 -0500
Date: Wed, 16 Dec 2009 18:38:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170518.039524041@chello.nl>
References: <20091216170518.039524041@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move kthread_bind() back to kthread.c
Message-ID: <tip-881232b70b195768a71cd74ff4b4e8ab9502997b@git.kernel.org>
Git-Commit-ID: 881232b70b195768a71cd74ff4b4e8ab9502997b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  881232b70b195768a71cd74ff4b4e8ab9502997b
Gitweb:     http://git.kernel.org/tip/881232b70b195768a71cd74ff4b4e8ab9502997b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:57 +0100

sched: Move kthread_bind() back to kthread.c

Since kthread_bind() lost its dependencies on sched.c, move it
back where it came from.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170518.039524041@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kthread.c |   23 +++++++++++++++++++++++
 kernel/sched.c   |   26 --------------------------
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index ab7ae57..fbb6222 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -150,6 +150,29 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
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
diff --git a/kernel/sched.c b/kernel/sched.c
index cc40bda..297dc44 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2004,32 +2004,6 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
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
