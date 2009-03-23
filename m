Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZCWFMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZCWFMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZCWFMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:12:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53667 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZCWFMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:12:09 -0400
Message-ID: <49C71A15.5030300@jp.fujitsu.com>
Date: Mon, 23 Mar 2009 14:11:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] x86: Rename __task_delta_exec() to task_delta_exec_locked()
References: <49BF3F73.5090007@jp.fujitsu.com> <49C0CFC2.7080604@jp.fujitsu.com> <20090318113430.GD32233@elte.hu>
In-Reply-To: <20090318113430.GD32233@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Externing function with prefix "__" is unpleasant.
This patch renames the function and fix the caller.
This change is desirable for other fix that against posix clocks,
since the fix introduces another __task_delta_exec() which is static.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    2 +-
 kernel/perf_counter.c       |    6 +++---
 kernel/sched.c              |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index b6d2887..459bc1e 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -87,7 +87,7 @@ static inline unsigned int kstat_irqs(unsigned int irq)
  */
 extern void curr_rq_lock_irq_save(unsigned long *flags);
 extern void curr_rq_unlock_irq_restore(unsigned long *flags);
-extern unsigned long long __task_delta_exec(struct task_struct *tsk, int update);
+extern unsigned long long task_delta_exec_locked(struct task_struct *tsk, int update);
 extern unsigned long long task_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f054b8c..66ddb2f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -881,7 +881,7 @@ int perf_counter_task_disable(void)
 	cpu = smp_processor_id();
 
 	/* force the update of the task clock: */
-	__task_delta_exec(curr, 1);
+	task_delta_exec_locked(curr, 1);
 
 	perf_counter_task_sched_out(curr, cpu);
 
@@ -922,7 +922,7 @@ int perf_counter_task_enable(void)
 	cpu = smp_processor_id();
 
 	/* force the update of the task clock: */
-	__task_delta_exec(curr, 1);
+	task_delta_exec_locked(curr, 1);
 
 	perf_counter_task_sched_out(curr, cpu);
 
@@ -1635,7 +1635,7 @@ static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
 	struct task_struct *curr = counter->task;
 	u64 delta;
 
-	delta = __task_delta_exec(curr, update);
+	delta = task_delta_exec_locked(curr, update);
 
 	return curr->se.sum_exec_runtime + delta;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 3e827b8..5ee5a06 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4304,10 +4304,10 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return any ns on the sched_clock that have not yet been banked in
- * @p in case that task is currently running.
+ * Return any ns on the sched_clock that have not yet been accounted.
+ * @p must be a task currently running.
  */
-unsigned long long __task_delta_exec(struct task_struct *p, int update)
+unsigned long long task_delta_exec_locked(struct task_struct *p, int update)
 {
 	s64 delta_exec;
 	struct rq *rq;
-- 
1.6.2.1


