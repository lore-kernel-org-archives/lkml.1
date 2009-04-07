Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZDGNN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZDGNN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbZDGNNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:13:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:59378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbZDGNNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:13:33 -0400
Date: Tue, 7 Apr 2009 13:12:59 GMT
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0903252053080.5675@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903252053080.5675@gandalf.stny.rr.com>
Subject: [tip:tracing/urgent] function-graph: add proper initialization for init task
Message-ID: <tip-5ac9f62267dc92c7735c642a5942d9e6c1190308@git.kernel.org>
Git-Commit-ID: 5ac9f62267dc92c7735c642a5942d9e6c1190308
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ac9f62267dc92c7735c642a5942d9e6c1190308
Gitweb:     http://git.kernel.org/tip/5ac9f62267dc92c7735c642a5942d9e6c1190308
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 25 Mar 2009 20:55:00 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:00:39 +0200

function-graph: add proper initialization for init task

Impact: fix to crash going to kexec

The init task did not properly initialize the function graph pointers.
Altough these pointers are NULL, they can not be assumed to be NULL
for the init task, and must still be properly initialize.

This usually is not an issue since a problem only arises when a task
exits, and the init tasks do not usually exit. But when doing tests
with kexec, the init tasks do exit, and the bug appears.

This patch properly initializes the init tasks function graph data
structures.

Reported-and-Tested-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <alpine.DEB.2.00.0903252053080.5675@gandalf.stny.rr.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace.h    |    8 ++++++--
 include/linux/init_task.h |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 015a3d2..da5405d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -356,6 +356,9 @@ struct ftrace_graph_ret {
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
+/* for init task */
+#define INIT_FTRACE_GRAPH		.ret_stack = NULL
+
 /*
  * Stack of return addresses for functions
  * of a thread.
@@ -430,10 +433,11 @@ static inline void unpause_graph_tracing(void)
 {
 	atomic_dec(&current->tracing_graph_pause);
 }
-#else
+#else /* !CONFIG_FUNCTION_GRAPH_TRACER */
 
 #define __notrace_funcgraph
 #define __irq_entry
+#define INIT_FTRACE_GRAPH
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
@@ -445,7 +449,7 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
 
 static inline void pause_graph_tracing(void) { }
 static inline void unpause_graph_tracing(void) { }
-#endif
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #ifdef CONFIG_TRACING
 #include <linux/sched.h>
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e752d97..cada054 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -5,6 +5,7 @@
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
 #include <linux/lockdep.h>
+#include <linux/ftrace.h>
 #include <linux/ipc.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
@@ -184,6 +185,7 @@ extern struct cred init_cred;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_FTRACE_GRAPH						\
 }
 
 
