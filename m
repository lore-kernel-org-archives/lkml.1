Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZDMFwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZDMFwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 01:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZDMFwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 01:52:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33036 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZDMFwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 01:52:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] ftrace, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090413125653.6E01.A69D9226@jp.fujitsu.com>
References: <49E2B656.1020308@cn.fujitsu.com> <20090413125653.6E01.A69D9226@jp.fujitsu.com>
Message-Id: <20090413145105.6E07.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 14:52:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2] ftrace, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro

TRACE_EVENT is a more generic way to define tracepoints.
Doing so adds these new capabilities to this tracepoint:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

Then, this patch convert DEFINE_TRACE to TRACE_EVENT in workqueue related tracepoint.


Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/trace/trace_event_types.h     |    1 
 include/trace/trace_events.h          |    1 
 include/trace/workqueue.h             |   19 ------
 include/trace/workqueue_event_types.h |  101 ++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 17 deletions(-)
 create mode 100644 include/trace/workqueue_event_types.h

Index: b/include/trace/trace_event_types.h
===================================================================
--- a/include/trace/trace_event_types.h	2009-04-13 12:11:00.000000000 +0900
+++ b/include/trace/trace_event_types.h	2009-04-13 12:18:56.000000000 +0900
@@ -5,3 +5,4 @@
 #include <trace/lockdep_event_types.h>
 #include <trace/skb_event_types.h>
 #include <trace/kmem_event_types.h>
+#include <trace/workqueue_event_types.h>
Index: b/include/trace/trace_events.h
===================================================================
--- a/include/trace/trace_events.h	2009-04-13 12:11:00.000000000 +0900
+++ b/include/trace/trace_events.h	2009-04-13 12:18:56.000000000 +0900
@@ -5,3 +5,4 @@
 #include <trace/lockdep.h>
 #include <trace/skb.h>
 #include <trace/kmem.h>
+#include <trace/workqueue.h>
Index: b/include/trace/workqueue.h
===================================================================
--- a/include/trace/workqueue.h	2009-04-13 12:08:59.000000000 +0900
+++ b/include/trace/workqueue.h	2009-04-13 12:18:56.000000000 +0900
@@ -1,25 +1,10 @@
 #ifndef __TRACE_WORKQUEUE_H
 #define __TRACE_WORKQUEUE_H
 
-#include <linux/tracepoint.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/tracepoint.h>
 
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
+#include <trace/workqueue_event_types.h>
 
 #endif /* __TRACE_WORKQUEUE_H */
Index: b/include/trace/workqueue_event_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/trace/workqueue_event_types.h	2009-04-13 12:25:16.000000000 +0900
@@ -0,0 +1,101 @@
+
+/* use <trace/workqueue.h> instead */
+#ifndef TRACE_EVENT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
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
+		__array(char,			thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,			thread_pid)
+		__field(struct work_struct *,	work)
+		__field(work_func_t,		func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
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
+		__array(char,			thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,			thread_pid)
+		__field(struct work_struct *,	work)
+		__field(work_func_t,		func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
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
+#undef TRACE_SYSTEM


