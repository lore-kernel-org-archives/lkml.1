Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZKTV3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZKTV3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZKTV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZKTV3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:29:06 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 1/3] tracepoint: Move signal sending tracepoint to
	events/signal.h
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 20 Nov 2009 16:31:15 -0500
Message-ID: <20091120213115.14708.55068.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move signal sending event to events/signal.h. This patch also renames
sched_signal_send event to signal_generate.

Changes in v3:
 - Add docbook style comments

Changes in v2:
 - Add siginfo argument
 - Add siginfo storing macro

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 Documentation/DocBook/tracepoint.tmpl |    5 +++
 include/trace/events/sched.h          |   25 -------------
 include/trace/events/signal.h         |   66 +++++++++++++++++++++++++++++++++
 kernel/signal.c                       |    5 ++-
 4 files changed, 74 insertions(+), 27 deletions(-)
 create mode 100644 include/trace/events/signal.h

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index b0756d0..8bca1d5 100644
--- a/Documentation/DocBook/tracepoint.tmpl
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -86,4 +86,9 @@
 !Iinclude/trace/events/irq.h
   </chapter>
 
+  <chapter id="signal">
+   <title>SIGNAL</title>
+!Iinclude/trace/events/signal.h
+  </chapter>
+
 </book>
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
index 0000000..af2e6b1
--- /dev/null
+++ b/include/trace/events/signal.h
@@ -0,0 +1,66 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM signal
+
+#if !defined(_TRACE_SIGNAL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SIGNAL_H
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+#define TP_STORE_SIGINFO(__entry, info)				\
+	do {							\
+		if (info == SEND_SIG_NOINFO) {			\
+			__entry->errno	= 0;			\
+			__entry->code	= SI_USER;		\
+		} else if (info == SEND_SIG_PRIV) {		\
+			__entry->errno	= 0;			\
+			__entry->code	= SI_KERNEL;		\
+		} else {					\
+			__entry->errno	= info->si_errno;	\
+			__entry->code	= info->si_code;	\
+		}						\
+	} while (0)
+
+/**
+ * signal_generate - called when a signal is generated
+ * @sig: signal number
+ * @info: pointer to struct siginfo
+ * @task: pointer to struct task_struct
+ *
+ * Current process sends a 'sig' signal to 'task' process with
+ * 'info' siginfo. If 'info' is SEND_SIG_NOINFO or SEND_SIG_PRIV,
+ * 'info' is not a pointer and you can't access its field. Instead,
+ * SEND_SIG_NOINFO means that si_code is SI_USER, and SEND_SIG_PRIV
+ * means that si_code is SI_KERNEL.
+ */
+TRACE_EVENT(signal_generate,
+
+	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task),
+
+	TP_ARGS(sig, info, p),
+
+	TP_STRUCT__entry(
+		__field(	int,	sig			)
+		__field(	int,	errno			)
+		__field(	int,	code			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		TP_STORE_SIGINFO(__entry, info);
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->pid	= task->pid;
+	),
+
+	TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
+		  __entry->sig, __entry->errno, __entry->code,
+		  __entry->comm, __entry->pid)
+);
+
+#endif /* _TRACE_SIGNAL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/signal.c b/kernel/signal.c
index fe08008..54ac4c5 100644
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
+	trace_signal_generate(sig, info, t);
 
 	assert_spin_locked(&t->sighand->siglock);
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
