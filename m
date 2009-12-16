Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbZLPRJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbZLPRJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762322AbZLPRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762279AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170517.884743662@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/12] sched: Fix sched_exec() balancing
Content-Disposition: inline; filename=foo6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we access ->cpus_allowed without holding rq->lock we need a
retry loop to validate the result, this comes for near free when we
merge sched_migrate_task() into sched_exec() since that already does
the needed check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2322,7 +2322,7 @@ void task_oncpu_function_call(struct tas
  *
  *  - fork, @p is stable because it isn't on the tasklist yet
  *
- *  - exec, @p is unstable XXX
+ *  - exec, @p is unstable, retry loop
  *
  *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
  *             we should be good.
@@ -3132,21 +3132,36 @@ static void double_rq_unlock(struct rq *
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
@@ -3161,24 +3176,10 @@ static void sched_migrate_task(struct ta
 
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

-- 

