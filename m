Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbZD3A16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbZD3A16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbZD3A12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZD3A10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ApsfclmizgLUDrFLLyhCj2ZIvOnLAIqMpi04OTp7mbr4ePfX9i4upRhnVNlrnomCRP
         J9lq3SR+KNGXsUV37mSappwCY+abY0TZy3GFIEa8qIJvWyDoZMuDBalCvh7XA/B0XCeV
         QJe7IoXwHRkgVgP1hiMfNEohciOVSKxf/FU1c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/19] ftrace, workqueuetrace: make workqueue tracepoints use TRACE_EVENT macro
Date: Thu, 30 Apr 2009 02:27:02 +0200
Message-Id: <1241051240-4280-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

v3: zhaolei@cn.fujitsu.com: Change TRACE_EVENT definition to new format
    introduced by Steven Rostedt: consolidate trace and trace_event headers
v2: kosaki@jp.fujitsu.com: print the function names instead of addr, and zap
    the work addr
v1: zhaolei@cn.fujitsu.com: Make workqueue tracepoints use TRACE_EVENT macro

TRACE_EVENT is a more generic way to define tracepoints.
Doing so adds these new capabilities to the tracepoints:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

Then, this patch converts DEFINE_TRACE to TRACE_EVENT in workqueue related
tracepoints.

[ Impact: expand workqueue tracer to events tracing ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |  100 ++++++++++++++++++++++++++++++++++++++
 include/trace/workqueue.h        |   25 ---------
 kernel/trace/trace_workqueue.c   |    2 +-
 kernel/workqueue.c               |   11 +---
 4 files changed, 103 insertions(+), 35 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
new file mode 100644
index 0000000..035f1bf
--- /dev/null
+++ b/include/trace/events/workqueue.h
@@ -0,0 +1,100 @@
+#if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WORKQUEUE_H
+
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM workqueue
+
+TRACE_EVENT(workqueue_insertion,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+TRACE_EVENT(workqueue_execution,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+/* Trace the creation of one workqueue thread on a cpu */
+TRACE_EVENT(workqueue_creation,
+
+	TP_PROTO(struct task_struct *wq_thread, int cpu),
+
+	TP_ARGS(wq_thread, cpu),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+		__field(int,	cpu)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
+		__entry->thread_pid, __entry->cpu)
+);
+
+TRACE_EVENT(workqueue_destruction,
+
+	TP_PROTO(struct task_struct *wq_thread),
+
+	TP_ARGS(wq_thread),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+	),
+
+	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
+);
+
+#endif /* _TRACE_WORKQUEUE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
deleted file mode 100644
index 7626523..0000000
--- a/include/trace/workqueue.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __TRACE_WORKQUEUE_H
-#define __TRACE_WORKQUEUE_H
-
-#include <linux/tracepoint.h>
-#include <linux/workqueue.h>
-#include <linux/sched.h>
-
-DECLARE_TRACE(workqueue_insertion,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-DECLARE_TRACE(workqueue_execution,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-/* Trace the creation of one workqueue thread on a cpu */
-DECLARE_TRACE(workqueue_creation,
-	   TP_PROTO(struct task_struct *wq_thread, int cpu),
-	   TP_ARGS(wq_thread, cpu));
-
-DECLARE_TRACE(workqueue_destruction,
-	   TP_PROTO(struct task_struct *wq_thread),
-	   TP_ARGS(wq_thread));
-
-#endif /* __TRACE_WORKQUEUE_H */
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 984b917..cfe56d3 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -6,7 +6,7 @@
  */
 
 
-#include <trace/workqueue.h>
+#include <trace/events/workqueue.h>
 #include <linux/list.h>
 #include <linux/percpu.h>
 #include "trace_stat.h"
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f71fb2a..0668795 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,7 +33,8 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#include <trace/workqueue.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/workqueue.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -124,8 +125,6 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-DEFINE_TRACE(workqueue_insertion);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
@@ -262,8 +261,6 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-DEFINE_TRACE(workqueue_execution);
-
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -753,8 +750,6 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	return cwq;
 }
 
-DEFINE_TRACE(workqueue_creation);
-
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
@@ -860,8 +855,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-DEFINE_TRACE(workqueue_destruction);
-
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
-- 
1.6.2.3

