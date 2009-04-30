Return-Path: <linux-kernel-owner+w=401wt.eu-S1765897AbZD3RWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765897AbZD3RWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764608AbZD3RHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:51 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764419AbZD3RHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:43 2009
Message-Id: <20090430165743.368536563@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 34/88] posixtimers, sched: Fix posix clock monotonicity
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0055-posixtimers-sched-Fix-posix-clock-monotonicity.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

upstream commit: c5f8d99585d7b5b7e857fabf8aefd0174903a98c

Impact: Regression fix (against clock_gettime() backwarding bug)

This patch re-introduces a couple of functions, task_sched_runtime
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
LKML-Reference: <49D1CC93.4080401@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/posix-cpu-timers.c |    7 ++--
 kernel/sched.c            |   65 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 61 insertions(+), 11 deletions(-)

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -294,7 +294,7 @@ static int cpu_clock_sample(const clocki
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -310,18 +310,19 @@ static int cpu_clock_sample_group(const 
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
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4064,9 +4064,25 @@ DEFINE_PER_CPU(struct kernel_stat, kstat
 EXPORT_PER_CPU_SYMBOL(kstat);
 
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
@@ -4074,16 +4090,49 @@ unsigned long long task_delta_exec(struc
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
+
+	rq = task_rq_lock(p, &flags);
+	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	return ns;
+}
 
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


