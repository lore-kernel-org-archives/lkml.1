Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZDMAy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZDMAy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 20:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZDMAys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 20:54:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMAyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 20:54:47 -0400
Message-ID: <49E28D4B.5040802@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 08:54:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints use
 TRACE_EVENT macro
References: <49E28D00.2020803@cn.fujitsu.com>
In-Reply-To: <49E28D00.2020803@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT is a more generic way to define tracepoints.
Doing so adds these new capabilities to this tracepoint:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/trace_event_types.h     |    1 +
 include/trace/trace_events.h          |    1 +
 include/trace/workqueue.h             |   19 +------
 include/trace/workqueue_event_types.h |  101 +++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 17 deletions(-)
 create mode 100644 include/trace/workqueue_event_types.h

diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index 552a50e..2babba4 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -5,3 +5,4 @@
 #include <trace/lockdep_event_types.h>
 #include <trace/skb_event_types.h>
 #include <trace/kmem_event_types.h>
+#include <trace/workqueue_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 13d6b85..2e0f58c 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -5,3 +5,4 @@
 #include <trace/lockdep.h>
 #include <trace/skb.h>
 #include <trace/kmem.h>
+#include <trace/workqueue.h>
diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
index 7626523..ecb58f4 100644
--- a/include/trace/workqueue.h
+++ b/include/trace/workqueue.h
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
diff --git a/include/trace/workqueue_event_types.h b/include/trace/workqueue_event_types.h
new file mode 100644
index 0000000..ff65d47
--- /dev/null
+++ b/include/trace/workqueue_event_types.h
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
+		__array(	char,			thread_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,			thread_pid			)
+		__field(	struct work_struct *,	work				)
+		__field(	work_func_t,		func				)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
+		__entry->thread_pid, __entry->work, __entry->func)
+);
+
+TRACE_EVENT(workqueue_execution,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(	char,			thread_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,			thread_pid			)
+		__field(	struct work_struct *,	work				)
+		__field(	work_func_t,		func				)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
+		__entry->thread_pid, __entry->work, __entry->func)
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
+		__array(	char,	thread_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	thread_pid			)
+		__field(	int,	cpu				)
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
+		__array(	char,	thread_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	thread_pid			)
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
-- 
1.5.5.3


