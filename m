Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZAJTeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZAJTeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZAJTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:34:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58757 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZAJTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:34:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=mAGFNaswAhw/AGSV1JMnIsnjHEKo6ICCHFHZYZGJOUpIF+BxgnQqydVoy9+xddz3Ex
         tiMcebqqqWswKBaGpROHbw7wY6cY81Iq0qtMSR22QeqLyL+YmjVm32hdtUJmOfqzSWeH
         BkzGiRviz4K0tiGuYpjPkJJBaPygYpvCxTnUs=
Message-ID: <4968f843.0d135e0a.4a26.3652@mx.google.com>
Date: Sat, 10 Jan 2009 11:34:27 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com
Subject: [PATCH 2/2] tracing: Add a new workqueue tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workqueue tracer provides some statistical informations
about each cpu workqueue thread such as the number of the
works inserted and executed since their creation. It can help
to evaluate the amount of work each of them have to perform.
For example it can help a developer to decide whether he should
choose a per cpu workqueue instead of a singlethreaded one.

It only traces statistical informations for now but it will probably later
provide event tracing too.

Such a tracer could help too, and be improved, to help rt priority sorted
workqueue development.

To have a snapshot of the workqueues state at any time, just do

cat /debugfs/tracing/trace_stat/workqueues

Ie:

# CPU  INSERTED  EXECUTED   NAME
# |      |         |          |

  1    125        125       reiserfs/1
  1      0          0       scsi_tgtd/1
  1      0          0       aio/1
  1      0          0       ata/1
  1    114        114       kblockd/1
  1      0          0       kintegrityd/1
  1   2144       2147       events/1

  0      0          0       kpsmoused
  0    105        105       reiserfs/0
  0      0          0       scsi_tgtd/0
  0      0          0       aio/0
  0      0          0       ata_aux
  0      0          0       ata/0
  0      0          0       cqueue
  0      0          0       kacpi_notify
  0      0          0       kacpid
  0    149        149       kblockd/0
  0      0          0       kintegrityd/0
  0   1000       1000       khelper
  0   2258       2270       events/0

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Kconfig  |   11 +++++++++++
 kernel/trace/Makefile |    1 +
 kernel/workqueue.c    |   16 +++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1c0b750..9ba1c68 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -284,6 +284,17 @@ config KMEMTRACE
 
 	  If unsure, say N.
 
+config WORKQUEUE_TRACER
+	bool "Trace workqueues"
+	select TRACING
+	help
+	  The workqueue tracer provides some statistical informations
+          about each cpu workqueue thread such as the number of the
+          works inserted and executed since their creation. It can help
+          to evaluate the amount of work each of them have to perform.
+          For example it can help a developer to decide whether he should
+          choose a per cpu workqueue instead of a singlethreaded one.
+ 
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 05c9182..f76d48f 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -36,5 +36,6 @@ obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
+obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..71145f8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <trace/workqueue.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -138,11 +139,15 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	wake_up(&cwq->more_work);
 }
 
+DEFINE_TRACE(workqueue_insertion);
+
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
 	unsigned long flags;
 
+	trace_workqueue_insertion(cwq->thread, work);
+
 	spin_lock_irqsave(&cwq->lock, flags);
 	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -259,6 +264,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+DEFINE_TRACE(workqueue_execution);
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -284,7 +291,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		 */
 		struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
-
+		trace_workqueue_execution(cwq->thread, work);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -765,6 +772,8 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	return cwq;
 }
 
+DEFINE_TRACE(workqueue_creation);
+
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
@@ -787,6 +796,8 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
+	trace_workqueue_creation(cwq->thread, cpu);
+
 	return 0;
 }
 
@@ -868,6 +879,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
+DEFINE_TRACE(workqueue_destruction);
+
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
@@ -891,6 +904,7 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
+	trace_workqueue_destruction(cwq->thread);
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
-- 
1.6.0.4


