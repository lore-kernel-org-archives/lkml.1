Return-Path: <linux-kernel-owner+w=401wt.eu-S935198AbZLPSjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbZLPSjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935205AbZLPSjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:39:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:53479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935197AbZLPSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:42 -0500
Date: Wed, 16 Dec 2009 18:38:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.884743662@chello.nl>
References: <20091216170517.884743662@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix sched_exec() balancing
Message-ID: <tip-3802290628348674985d14914f9bfee7b9084548@git.kernel.org>
Git-Commit-ID: 3802290628348674985d14914f9bfee7b9084548
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3802290628348674985d14914f9bfee7b9084548
Gitweb:     http://git.kernel.org/tip/3802290628348674985d14914f9bfee7b9084548
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:56 +0100

sched: Fix sched_exec() balancing

Since we access ->cpus_allowed without holding rq->lock we need
a retry loop to validate the result, this comes for near free
when we merge sched_migrate_task() into sched_exec() since that
already does the needed check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.884743662@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   45 +++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 33d7965..63e55ac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2322,7 +2322,7 @@ void task_oncpu_function_call(struct task_struct *p,
  *
  *  - fork, @p is stable because it isn't on the tasklist yet
  *
- *  - exec, @p is unstable XXX
+ *  - exec, @p is unstable, retry loop
  *
  *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
  *             we should be good.
@@ -3132,21 +3132,36 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 }
 
 /*
- * If dest_cpu is allowed for this process, migrate the task to it.
- * This is accomplished by forcing the cpu_allowed mask to only
- * allow dest_cpu, which will force the cpu onto dest_cpu. Then
- * the cpu_allowed mask is restored.
+ * sched_exec - execve() is a valuable balancing opportunity, because at
+ * this point the task has the smallest effective memory and cache footprint.
  */
-static void sched_migrate_task(struct task_struct *p, int dest_cpu)
+void sched_exec(void)
 {
+	struct task_struct *p = current;
 	struct migration_req req;
+	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
 
+again:
+	this_cpu = get_cpu();
+	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == this_cpu) {
+		put_cpu();
+		return;
+	}
+
 	rq = task_rq_lock(p, &flags);
+	put_cpu();
+
+	/*
+	 * select_task_rq() can race against ->cpus_allowed
+	 */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu)))
-		goto out;
+	    || unlikely(!cpu_active(dest_cpu))) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
@@ -3161,24 +3176,10 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 
 		return;
 	}
-out:
 	task_rq_unlock(rq, &flags);
 }
 
 /*
- * sched_exec - execve() is a valuable balancing opportunity, because at
- * this point the task has the smallest effective memory and cache footprint.
- */
-void sched_exec(void)
-{
-	int new_cpu, this_cpu = get_cpu();
-	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
-	put_cpu();
-	if (new_cpu != this_cpu)
-		sched_migrate_task(current, new_cpu);
-}
-
-/*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
  */
