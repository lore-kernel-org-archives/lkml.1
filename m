Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbZDDAcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbZDDAcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936788AbZDDA2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936690AbZDDA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:12 -0400
Message-Id: <20090404002809.140014737@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/10] function-graph: add proper initialization for init task
Content-Disposition: inline; filename=0006-function-graph-add-proper-initialization-for-init-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
 
 
-- 
1.6.2.1

-- 
