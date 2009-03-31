Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZCaH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZCaH4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZCaH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:56:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55037 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZCaH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:56:11 -0400
Message-ID: <49D1CC93.4080401@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 16:56:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org
Subject: [RESEND 2][PATCH -tip] posixtimers: Fix posix clock monotonicity
 v3
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Regression fix (against clock_gettime() backwarding bug)

This patch re-introduces a couple of function, task_sched_runtime
and thread_group_sched_runtime, which was once removed at the
time of 2.6.28-rc1.

These functions protect the sampling of thread/process clock with
rq lock.  This rq lock is required not to update rq->clock during
the sampling.
i.e.
  The clock_gettime() may return
   ((accounted runtime before update) + (delta after update))
  that is less than what it should be.

v2 -> v3:
	- Rename static helper function __task_delta_exec()
	  to do_task_delta_exec() since -tip tree already has
	  a __task_delta_exec() of different version.

v1 -> v2:
	- Revises comments of function and patch description.
	- Add note about accuracy of thread group's runtime.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org	[2.6.28.x][2.6.29.x]
---
 kernel/posix-cpu-timers.c |    7 +++--
 kernel/sched.c            |   65 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8e5d9a6..6f7b869 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -224,7 +224,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -305,18 +305,19 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
+		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
+		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = thread_group_sched_runtime(p);
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index 706517c..d3d0848 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4589,9 +4589,25 @@ unsigned long long __task_delta_exec(struct task_struct *p, int update)
 }
 
 /*
- * Return any ns on the sched_clock that have not yet been banked in
+ * Return any ns on the sched_clock that have not yet been accounted in
  * @p in case that task is currently running.
+ *
+ * Called with task_rq_lock() held on @rq.
  */
+static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
+{
+	u64 ns = 0;
+
+	if (task_current(rq, p)) {
+		update_rq_clock(rq);
+		ns = rq->clock - p->se.exec_start;
+		if ((s64)ns < 0)
+			ns = 0;
+	}
+
+	return ns;
+}
+
 unsigned long long task_delta_exec(struct task_struct *p)
 {
 	unsigned long flags;
@@ -4599,16 +4615,49 @@ unsigned long long task_delta_exec(struct task_struct *p)
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
+	ns = do_task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
 
-	if (task_current(rq, p)) {
-		u64 delta_exec;
+	return ns;
+}
 
-		update_rq_clock(rq);
-		delta_exec = rq->clock - p->se.exec_start;
-		if ((s64)delta_exec > 0)
-			ns = delta_exec;
-	}
+/*
+ * Return accounted runtime for the task.
+ * In case the task is currently running, return the runtime plus current's
+ * pending runtime that have not been accounted yet.
+ */
+unsigned long long task_sched_runtime(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq *rq;
+	u64 ns = 0;
 
+	rq = task_rq_lock(p, &flags);
+	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	return ns;
+}
+
+/*
+ * Return sum_exec_runtime for the thread group.
+ * In case the task is currently running, return the sum plus current's
+ * pending runtime that have not been accounted yet.
+ *
+ * Note that the thread group might have other running tasks as well,
+ * so the return value not includes other pending runtime that other
+ * running tasks might have.
+ */
+unsigned long long thread_group_sched_runtime(struct task_struct *p)
+{
+	struct task_cputime totals;
+	unsigned long flags;
+	struct rq *rq;
+	u64 ns;
+
+	rq = task_rq_lock(p, &flags);
+	thread_group_cputime(p, &totals);
+	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
 
 	return ns;
-- 
1.6.2.1

