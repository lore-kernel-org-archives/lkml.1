Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbZBYC71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbZBYC71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZBYC6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:58:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZBYC56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:57:58 -0500
Message-Id: <20090225025754.033529552@goodmis.org>
References: <20090225025608.956691460@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Feb 2009 21:56:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] tracing: add schedule events to event trace
Content-Disposition: inline; filename=0003-tracing-add-schedule-events-to-event-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch changes the trace/sched.h to use the DECLARE_TRACE_FMT
such that they are automatically registered with the event tracer.

And it also adds the tracing sched headers to kernel/trace/events.c

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/sched.h             |   49 +------------------------
 include/trace/sched_event_types.h |   72 +++++++++++++++++++++++++++++++++++++
 kernel/trace/Makefile             |    1 +
 kernel/trace/events.c             |   13 +++++++
 4 files changed, 87 insertions(+), 48 deletions(-)
 create mode 100644 include/trace/sched_event_types.h
 create mode 100644 kernel/trace/events.c

diff --git a/include/trace/sched.h b/include/trace/sched.h
index 0d81098..4e372a1 100644
--- a/include/trace/sched.h
+++ b/include/trace/sched.h
@@ -4,53 +4,6 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-DECLARE_TRACE(sched_kthread_stop,
-	TPPROTO(struct task_struct *t),
-		TPARGS(t));
-
-DECLARE_TRACE(sched_kthread_stop_ret,
-	TPPROTO(int ret),
-		TPARGS(ret));
-
-DECLARE_TRACE(sched_wait_task,
-	TPPROTO(struct rq *rq, struct task_struct *p),
-		TPARGS(rq, p));
-
-DECLARE_TRACE(sched_wakeup,
-	TPPROTO(struct rq *rq, struct task_struct *p, int success),
-		TPARGS(rq, p, success));
-
-DECLARE_TRACE(sched_wakeup_new,
-	TPPROTO(struct rq *rq, struct task_struct *p, int success),
-		TPARGS(rq, p, success));
-
-DECLARE_TRACE(sched_switch,
-	TPPROTO(struct rq *rq, struct task_struct *prev,
-		struct task_struct *next),
-		TPARGS(rq, prev, next));
-
-DECLARE_TRACE(sched_migrate_task,
-	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
-		TPARGS(p, orig_cpu, dest_cpu));
-
-DECLARE_TRACE(sched_process_free,
-	TPPROTO(struct task_struct *p),
-		TPARGS(p));
-
-DECLARE_TRACE(sched_process_exit,
-	TPPROTO(struct task_struct *p),
-		TPARGS(p));
-
-DECLARE_TRACE(sched_process_wait,
-	TPPROTO(struct pid *pid),
-		TPARGS(pid));
-
-DECLARE_TRACE(sched_process_fork,
-	TPPROTO(struct task_struct *parent, struct task_struct *child),
-		TPARGS(parent, child));
-
-DECLARE_TRACE(sched_signal_send,
-	TPPROTO(int sig, struct task_struct *p),
-		TPARGS(sig, p));
+#include <trace/sched_event_types.h>
 
 #endif
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
new file mode 100644
index 0000000..a4f6629
--- /dev/null
+++ b/include/trace/sched_event_types.h
@@ -0,0 +1,72 @@
+
+/* use <trace/sched.h> instead */
+#ifndef DEFINE_TRACE_FMT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+DEFINE_TRACE_FMT(sched_kthread_stop,
+	TPPROTO(struct task_struct *t),
+	TPARGS(t),
+	TPFMT("task %s:%d", t->comm, t->pid));
+
+DEFINE_TRACE_FMT(sched_kthread_stop_ret,
+	TPPROTO(int ret),
+	TPARGS(ret),
+	TPFMT("ret=%d", ret));
+
+DEFINE_TRACE_FMT(sched_wait_task,
+	TPPROTO(struct rq *rq, struct task_struct *p),
+	TPARGS(rq, p),
+	TPFMT("task %s:%d", p->comm, p->pid));
+
+DEFINE_TRACE_FMT(sched_wakeup,
+	TPPROTO(struct rq *rq, struct task_struct *p, int success),
+	TPARGS(rq, p, success),
+	TPFMT("task %s:%d %s",
+	      p->comm, p->pid, success?"succeeded":"failed"));
+
+DEFINE_TRACE_FMT(sched_wakeup_new,
+	TPPROTO(struct rq *rq, struct task_struct *p, int success),
+	TPARGS(rq, p, success),
+	TPFMT("task %s:%d",
+	      p->comm, p->pid, success?"succeeded":"failed"));
+
+DEFINE_TRACE_FMT(sched_switch,
+	TPPROTO(struct rq *rq, struct task_struct *prev,
+		struct task_struct *next),
+	TPARGS(rq, prev, next),
+	TPFMT("task %s:%d ==> %s:%d",
+	      prev->comm, prev->pid, next->comm, next->pid));
+
+DEFINE_TRACE_FMT(sched_migrate_task,
+	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+	TPARGS(p, orig_cpu, dest_cpu),
+	TPFMT("task %s:%d from: %d  to: %d",
+	      p->comm, p->pid, orig_cpu, dest_cpu));
+
+DEFINE_TRACE_FMT(sched_process_free,
+	TPPROTO(struct task_struct *p),
+	TPARGS(p),
+	TPFMT("task %s:%d", p->comm, p->pid));
+
+DEFINE_TRACE_FMT(sched_process_exit,
+	TPPROTO(struct task_struct *p),
+	TPARGS(p),
+	TPFMT("task %s:%d", p->comm, p->pid));
+
+DEFINE_TRACE_FMT(sched_process_wait,
+	TPPROTO(struct pid *pid),
+	TPARGS(pid),
+	TPFMT("pid %d", pid));
+
+DEFINE_TRACE_FMT(sched_process_fork,
+	TPPROTO(struct task_struct *parent, struct task_struct *child),
+	TPARGS(parent, child),
+	TPFMT("parent %s:%d  child %s:%d",
+	      parent->comm, parent->pid, child->comm, child->pid));
+
+DEFINE_TRACE_FMT(sched_signal_send,
+	TPPROTO(int sig, struct task_struct *p),
+	TPARGS(sig, p),
+	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid));
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c736356..664b6c0 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -39,5 +39,6 @@ obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_EVENT_TRACER) += trace_events.o
+obj-$(CONFIG_EVENT_TRACER) += events.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
new file mode 100644
index 0000000..38c89ee
--- /dev/null
+++ b/kernel/trace/events.c
@@ -0,0 +1,13 @@
+/*
+ * This is the place to register all trace points as events.
+ * Include the trace/<type>.h at the top.
+ * Include the trace/<type>_event_types.h at the bottom.
+ */
+
+/* trace/<type>.h here */
+#include <trace/sched.h>
+
+#include "trace_events.h"
+
+/* trace/<type>_event_types.h here */
+#include <trace/sched_event_types.h>
-- 
1.5.6.5

-- 
