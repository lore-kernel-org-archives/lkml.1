Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbYLXIvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbYLXIvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 03:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLXIuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 03:50:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45388 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLXIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 03:50:53 -0500
Message-ID: <4951F7E6.2080805@jp.fujitsu.com>
Date: Wed, 24 Dec 2008 17:50:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_THREAD_CPUTIME_ID)
 goes backward
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1]:
 Timer tick (and task_tick) can interrups between getting sum_exec_runtime
 and task_delta_exec(p).  Since task's runtime is updated in the tick,
 it makes the value of cpu->sched about a tick less than what it should be.
 So, interrupts should be disabled while sampling runtime.

[2]:
 enqueue_task also updates runtime of task running on the rq which
 a task is going to be enqueued.
 So, runqueue should be locked while sampling runtime.

>From user land (@HZ=250), it looks like:
	prev call       current call    diff
        (0.191195713) > (0.191200456) : 4743
        (0.191200456) > (0.191205198) : 4742
        (0.191205198) > (0.187213693) : -3991505
        (0.187213693) > (0.191218688) : 4004995
        (0.191218688) > (0.191223436) : 4748

clock_gettime(CLOCK_PROCESS_CPUTIME_ID) also has same problem,
but it is complicated because it need to handle thread group.
There should be another patch to fix it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    1 +
 kernel/posix-cpu-timers.c   |    2 +-
 kernel/sched.c              |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 4a145ca..225f27a 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -66,6 +66,7 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
+extern unsigned long long task_total_exec(struct task_struct *);
 extern unsigned long long task_delta_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, cputime_t);
 extern void account_user_time_scaled(struct task_struct *, cputime_t);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 4e5288a..8e828b4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -294,7 +294,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = task_total_exec(p);
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..5c7365a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4064,6 +4064,33 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
+ * Return total of runtime which already banked and which not yet
+ * @p in case that task is currently running.
+ */
+unsigned long long task_total_exec(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq *rq;
+	u64 ns = 0;
+
+	rq = task_rq_lock(p, &flags);
+
+	if (task_current(rq, p)) {
+		u64 delta_exec;
+
+		update_rq_clock(rq);
+		delta_exec = rq->clock - p->se.exec_start;
+		if ((s64)delta_exec > 0)
+			ns = delta_exec;
+	}
+	ns += p->se.sum_exec_runtime;
+
+	task_rq_unlock(rq, &flags);
+
+	return ns;
+}
+
+/*
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
  */
-- 
1.6.1.rc4

