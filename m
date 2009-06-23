Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZFWSby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZFWSby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZFWSbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:31:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbZFWSbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:31:33 -0400
Date: Tue, 23 Jun 2009 14:29:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <be540cdf5e8ee54d7cf6933bc4dfb28b38794b28.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 4/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


add two tracepoints in syscall exit and entry path, conditioned on
TIF_SYSCALL_FTRACE. Supports the syscall trace event code.


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

---
 arch/x86/kernel/ptrace.c |    6 ++++--
 include/trace/syscall.h  |   18 ++++++++++++++++++
 kernel/tracepoint.c      |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b457f78..3a6449b 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -37,6 +37,8 @@
 #include <asm/hw_breakpoint.h>
 
 #include <trace/syscall.h>
+DEFINE_TRACE(syscall_enter);
+DEFINE_TRACE(syscall_exit);
 
 #include "tls.h"
 
@@ -1549,7 +1551,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		trace_syscall_enter(regs, regs->orig_ax);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1575,7 +1577,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+		trace_syscall_exit(regs, regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index c55fcce..4416c6f 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -2,6 +2,24 @@
 #define _TRACE_SYSCALL_H
 
 #include <asm/ptrace.h>
+#include <linux/tracepoint.h>
+
+extern void syscall_regfunc(void);
+extern void syscall_unregfunc(void);
+
+DECLARE_TRACE_WITH_CALLBACK(syscall_enter,
+	TP_PROTO(struct pt_regs *regs, long id),
+	TP_ARGS(regs, id),
+	syscall_regfunc,
+	syscall_unregfunc
+);
+
+DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
+	TP_PROTO(struct pt_regs *regs, long ret),
+	TP_ARGS(regs, ret),
+	syscall_regfunc,
+	syscall_unregfunc
+);
 
 /*
  * A syscall entry in the ftrace syscalls array.
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1ef5d3a..070a42b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -24,6 +24,7 @@
 #include <linux/tracepoint.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -577,3 +578,40 @@ static int init_tracepoints(void)
 __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
+
+static DEFINE_MUTEX(regfunc_mutex);
+static int sys_tracepoint_refcount;
+
+void syscall_regfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	sys_tracepoint_refcount++;
+	mutex_unlock(&regfunc_mutex);
+}
+
+void syscall_unregfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	sys_tracepoint_refcount--;
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	mutex_unlock(&regfunc_mutex);
+}
-- 
1.6.0.6

