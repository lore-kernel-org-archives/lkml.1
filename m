Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZKQXld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZKQXld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZKQXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:41:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbZKQXlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:41:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/3] tracepoint: Move signal sending tracepoint to
	events/signal.h
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Nov 2009 18:41:41 -0500
Message-ID: <20091117234141.30589.18497.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move signal sending event to events/signal.h. This patch also renames
sched_signal_send event to signal_generate.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 include/trace/events/sched.h  |   25 -------------------------
 include/trace/events/signal.h |   38 ++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |    5 +++--
 3 files changed, 41 insertions(+), 27 deletions(-)
 create mode 100644 include/trace/events/signal.h

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b50b985..b221bb3 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -320,31 +320,6 @@ TRACE_EVENT(sched_process_fork,
 );
 
 /*
- * Tracepoint for sending a signal:
- */
-TRACE_EVENT(sched_signal_send,
-
-	TP_PROTO(int sig, struct task_struct *p),
-
-	TP_ARGS(sig, p),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig			)
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid	= p->pid;
-		__entry->sig	= sig;
-	),
-
-	TP_printk("sig=%d comm=%s pid=%d",
-		  __entry->sig, __entry->comm, __entry->pid)
-);
-
-/*
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
new file mode 100644
index 0000000..c7817f3
--- /dev/null
+++ b/include/trace/events/signal.h
@@ -0,0 +1,38 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM signal
+
+#if !defined(_TRACE_SIGNAL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SIGNAL_H
+
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+/*
+ * Tracepoint for generating a signal:
+ */
+TRACE_EVENT(signal_generate,
+
+	TP_PROTO(int sig, struct task_struct *p),
+
+	TP_ARGS(sig, p),
+
+	TP_STRUCT__entry(
+		__field(	int,	sig			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid	= p->pid;
+		__entry->sig	= sig;
+	),
+
+	TP_printk("sig=%d comm=%s pid=%d",
+		  __entry->sig, __entry->comm, __entry->pid)
+);
+
+#endif /* _TRACE_SIGNAL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/signal.c b/kernel/signal.c
index fe08008..82ab077 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -28,7 +28,8 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
-#include <trace/events/sched.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/signal.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -856,7 +857,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigqueue *q;
 	int override_rlimit;
 
-	trace_sched_signal_send(sig, t);
+	trace_signal_generate(sig, t);
 
 	assert_spin_locked(&t->sighand->siglock);
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
