Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYLZGBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYLZGBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYLZGBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:01:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34153 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYLZGBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:01:13 -0500
Message-ID: <49547320.9010302@jp.fujitsu.com>
Date: Fri, 26 Dec 2008 15:01:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID) goes
 backward
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix-cpu-timers, clock_gettime(CLOCK_THREAD_CPUTIME_ID) and
clock_gettime(CLOCK_PROCESS_CPUTIME_ID) occasionally go backward.

>From user land (@HZ=250), it looks like:
	prev call       current call    diff
        (0.191195713) > (0.191200456) : 4743
        (0.191200456) > (0.191205198) : 4742
        (0.191205198) > (0.187213693) : -3991505
        (0.187213693) > (0.191218688) : 4004995
        (0.191218688) > (0.191223436) : 4748

The reasons are:

 - Timer tick (and task_tick) can interrups between getting
   sum_exec_runtime and task_delta_exec(p).  Since task's runtime
   is updated in the tick, it makes the value of cpu->sched about
   a tick less than what it should be.
   So, interrupts should be disabled while sampling runtime and
   delta.

 - Queueing task also updates runtime of task running on the rq
   which a task is going to be enqueued/dequeued.
   So, runqueue should be locked while sampling runtime and delta.

For thread timer (CLOCK_THREAD_CPUTIME_ID), it is easy to solve
by making a function do all in a block locked by task_rq_lock().

 # clock_gettime(CLOCK_THREAD_CPUTIME_ID)
   before:
	cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
   after:
	cpu->sched = task_total_exec(p);

For process timer (CLOCK_PROCESS_CPUTIME_ID), proposed fix here
is moving thread_group_cputime() from kernel/posix-cpu-timers.c
to kernel/sched.c, and let it use rq-related operations.

 # clock_gettime(CLOCK_PROCESS_CPUTIME_ID)
   before:
	thread_group_cputime(p,&cputime); /* returns total */
	cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
   after:
	thread_group_cputime(p,&cputime); /* total + local delta */
	cpu->sched = cputime.sum_exec_runtime;

Note: According to the current code, process timer returns
"((total runtime of thread group) + (delta of current thread))."
The former total is total of "banked runtime" in signal structure,
therefore technically speaking the latter delta should be sum of
delta of all running thread in the group.  However requesting delta
for all cpu is quite heavy and nonsense, so I took a realistic
approach - keep it as is, as return banked total plus local delta.
In othe words, be careful that accuracy of process timer is not
so good, it can stale about tick*(max(num_cpu, num_thread)-1).

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    2 +-
 kernel/posix-cpu-timers.c   |   38 +----------------------------
 kernel/sched.c              |   54 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 4a145ca..e142222 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -66,7 +66,7 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
-extern unsigned long long task_delta_exec(struct task_struct *);
+extern unsigned long long task_total_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, cputime_t);
 extern void account_user_time_scaled(struct task_struct *, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 4e5288a..c53cea4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -45,40 +45,6 @@ int thread_group_cputime_alloc(struct task_struct *tsk)
 	return 0;
 }
 
-/**
- * thread_group_cputime - Sum the thread group time fields across all CPUs.
- *
- * @tsk:	The task we use to identify the thread group.
- * @times:	task_cputime structure in which we return the summed fields.
- *
- * Walk the list of CPUs to sum the per-CPU time fields in the thread group
- * time structure.
- */
-void thread_group_cputime(
-	struct task_struct *tsk,
-	struct task_cputime *times)
-{
-	struct signal_struct *sig;
-	int i;
-	struct task_cputime *tot;
-
-	sig = tsk->signal;
-	if (unlikely(!sig) || !sig->cputime.totals) {
-		times->utime = tsk->utime;
-		times->stime = tsk->stime;
-		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
-		return;
-	}
-	times->stime = times->utime = cputime_zero;
-	times->sum_exec_runtime = 0;
-	for_each_possible_cpu(i) {
-		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
-		times->utime = cputime_add(times->utime, tot->utime);
-		times->stime = cputime_add(times->stime, tot->stime);
-		times->sum_exec_runtime += tot->sum_exec_runtime;
-	}
-}
-
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
@@ -294,7 +260,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = task_total_exec(p);
 		break;
 	}
 	return 0;
@@ -321,7 +287,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..13bd162 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4064,10 +4064,10 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return any ns on the sched_clock that have not yet been banked in
+ * Return total of runtime which already banked and which not yet
  * @p in case that task is currently running.
  */
-unsigned long long task_delta_exec(struct task_struct *p)
+unsigned long long task_total_exec(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
@@ -4083,12 +4083,62 @@ unsigned long long task_delta_exec(struct task_struct *p)
 		if ((s64)delta_exec > 0)
 			ns = delta_exec;
 	}
+	ns += p->se.sum_exec_runtime;
 
 	task_rq_unlock(rq, &flags);
 
 	return ns;
 }
 
+/**
+ * thread_group_cputime - Sum the thread group time fields across all CPUs.
+ *
+ * @p:		The task we use to identify the thread group.
+ * @times:	task_cputime structure in which we return the summed fields.
+ *
+ * Walk the list of CPUs to sum the per-CPU time fields in the thread group
+ * time structure.
+ */
+void thread_group_cputime(struct task_struct *p, struct task_cputime *times)
+{
+	unsigned long flags;
+	struct rq *rq;
+	u64 delta_exec = 0;
+	struct task_cputime *tot;
+	struct signal_struct *sig;
+	int i;
+
+	sig = p->signal;
+	if (unlikely(!sig) || !sig->cputime.totals) {
+		times->utime = p->utime;
+		times->stime = p->stime;
+		times->sum_exec_runtime = task_total_exec(p);
+		return;
+	}
+
+	times->stime = times->utime = cputime_zero;
+	times->sum_exec_runtime = 0;
+
+	rq = task_rq_lock(p, &flags);
+
+	if (task_current(rq, p)) {
+		update_rq_clock(rq);
+		delta_exec = rq->clock - p->se.exec_start;
+		if ((s64)delta_exec < 0)
+			delta_exec = 0;
+	}
+
+	for_each_possible_cpu(i) {
+		tot = per_cpu_ptr(p->signal->cputime.totals, i);
+		times->utime = cputime_add(times->utime, tot->utime);
+		times->stime = cputime_add(times->stime, tot->stime);
+		times->sum_exec_runtime += tot->sum_exec_runtime;
+	}
+	times->sum_exec_runtime += delta_exec;
+
+	task_rq_unlock(rq, &flags);
+}
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
-- 
1.6.1.rc4


