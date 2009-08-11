Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbZHKSvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbZHKSvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZHKStU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:20 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZHKStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Boc1/1Qo+Jy3B0trEVOFRJivS8ZCs0zUwNI6fWsej+UI9fUrZ2kpTAnFRBQgO23Lrn
         Qxe7Eq248b3tdj4bHqKglCZhElPpGF/fAPX0S683d1+TlwcGwJBXp3TWmgGJgIM/iFrs
         PY7TWo8WS2cnridnXjipLuzrdr/8MNebBHvJo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/16] tracing: Add syscall tracepoints
Date: Tue, 11 Aug 2009 20:48:54 +0200
Message-Id: <1250016545-6601-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

add two tracepoints in syscall exit and entry path, conditioned on
TIF_SYSCALL_FTRACE. Supports the syscall trace event code.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |    7 +++++--
 include/trace/syscall.h  |   20 ++++++++++++++++++++
 kernel/tracepoint.c      |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..34dd6f1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -37,6 +37,9 @@
 
 #include <trace/syscall.h>
 
+DEFINE_TRACE(syscall_enter);
+DEFINE_TRACE(syscall_exit);
+
 #include "tls.h"
 
 enum x86_regset {
@@ -1498,7 +1501,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		trace_syscall_enter(regs, regs->orig_ax);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1524,7 +1527,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+		trace_syscall_exit(regs, regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index c55fcce..3951d77 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -1,8 +1,28 @@
 #ifndef _TRACE_SYSCALL_H
 #define _TRACE_SYSCALL_H
 
+#include <linux/tracepoint.h>
+
 #include <asm/ptrace.h>
 
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
+
 /*
  * A syscall entry in the ftrace syscalls array.
  *
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
1.6.2.3

