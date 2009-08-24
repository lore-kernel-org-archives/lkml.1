Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZHXVn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZHXVn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZHXVny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZHXVnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:46 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v4 4/4] tracing: Create generic syscall TRACE_EVENTs
Date: Mon, 24 Aug 2009 14:43:14 -0700
Message-Id: <1251150194-1713-5-git-send-email-jistone@redhat.com>
In-Reply-To: <1251150194-1713-4-git-send-email-jistone@redhat.com>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com>
 <1251150194-1713-1-git-send-email-jistone@redhat.com>
 <1251150194-1713-2-git-send-email-jistone@redhat.com>
 <1251150194-1713-3-git-send-email-jistone@redhat.com>
 <1251150194-1713-4-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the syscall_enter/exit tracepoints into TRACE_EVENTs, so
you can have generic ftrace events that capture all system calls with
arguments and return values.  These generic events are also renamed to
sys_enter/exit, so they're more closely aligned to the specific
sys_enter_foo events.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/s390/kernel/ptrace.c       |    8 ++--
 arch/x86/kernel/ptrace.c        |   12 +++----
 include/trace/events/syscalls.h |   70 +++++++++++++++++++++++++++++++++++++++
 include/trace/syscall.h         |   17 ---------
 kernel/trace/trace_syscalls.c   |   17 +++++----
 5 files changed, 88 insertions(+), 36 deletions(-)
 create mode 100644 include/trace/events/syscalls.h

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index c05b44b..f3ddd7a 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -51,8 +51,8 @@
 #include "compat_ptrace.h"
 #endif
 
-DEFINE_TRACE_FN(syscall_enter, syscall_regfunc, syscall_unregfunc);
-DEFINE_TRACE_FN(syscall_exit, syscall_regfunc, syscall_unregfunc);
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
 
 enum s390_regset {
 	REGSET_GENERAL,
@@ -665,7 +665,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	}
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_syscall_enter(regs, regs->gprs[2]);
+		trace_sys_enter(regs, regs->gprs[2]);
 
 	if (unlikely(current->audit_context))
 		audit_syscall_entry(is_compat_task() ?
@@ -683,7 +683,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 				   regs->gprs[2]);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_syscall_exit(regs, regs->gprs[2]);
+		trace_sys_exit(regs, regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 31e9b97..8d7d5c9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -35,13 +35,11 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
-#include <trace/syscall.h>
-
-DEFINE_TRACE_FN(syscall_enter, syscall_regfunc, syscall_unregfunc);
-DEFINE_TRACE_FN(syscall_exit, syscall_regfunc, syscall_unregfunc);
-
 #include "tls.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 enum x86_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -1501,7 +1499,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_syscall_enter(regs, regs->orig_ax);
+		trace_sys_enter(regs, regs->orig_ax);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1527,7 +1525,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_syscall_exit(regs, regs->ax);
+		trace_sys_exit(regs, regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
new file mode 100644
index 0000000..397dff2
--- /dev/null
+++ b/include/trace/events/syscalls.h
@@ -0,0 +1,70 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM syscalls
+
+#if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENTS_SYSCALLS_H
+
+#include <linux/tracepoint.h>
+
+#include <asm/ptrace.h>
+#include <asm/syscall.h>
+
+
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
+
+extern void syscall_regfunc(void);
+extern void syscall_unregfunc(void);
+
+TRACE_EVENT_FN(sys_enter,
+
+	TP_PROTO(struct pt_regs *regs, long id),
+
+	TP_ARGS(regs, id),
+
+	TP_STRUCT__entry(
+		__field(	long,		id		)
+		__array(	unsigned long,	args,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->id	= id;
+		syscall_get_arguments(current, regs, 0, 6, __entry->args);
+	),
+
+	TP_printk("NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)",
+		  __entry->id,
+		  __entry->args[0], __entry->args[1], __entry->args[2],
+		  __entry->args[3], __entry->args[4], __entry->args[5]),
+
+	syscall_regfunc, syscall_unregfunc
+);
+
+TRACE_EVENT_FN(sys_exit,
+
+	TP_PROTO(struct pt_regs *regs, long ret),
+
+	TP_ARGS(regs, ret),
+
+	TP_STRUCT__entry(
+		__field(	long,	id	)
+		__field(	long,	ret	)
+	),
+
+	TP_fast_assign(
+		__entry->id	= syscall_get_nr(current, regs);
+		__entry->ret	= ret;
+	),
+
+	TP_printk("NR %ld = %ld",
+		  __entry->id, __entry->ret),
+
+	syscall_regfunc, syscall_unregfunc
+);
+
+#endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
+
+#endif /* _TRACE_EVENTS_SYSCALLS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 4e19430..5dc283b 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -8,23 +8,6 @@
 #include <asm/ptrace.h>
 
 
-#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
-
-extern void syscall_regfunc(void);
-extern void syscall_unregfunc(void);
-
-DECLARE_TRACE(syscall_enter,
-	TP_PROTO(struct pt_regs *regs, long id),
-	TP_ARGS(regs, id)
-);
-
-DECLARE_TRACE(syscall_exit,
-	TP_PROTO(struct pt_regs *regs, long ret),
-	TP_ARGS(regs, ret)
-);
-
-#endif
-
 /*
  * A syscall entry in the ftrace syscalls array.
  *
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 46c1b97..2698fe4 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,4 +1,5 @@
 #include <trace/syscall.h>
+#include <trace/events/syscalls.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
 #include <linux/perf_counter.h>
@@ -286,7 +287,7 @@ int reg_event_syscall_enter(void *ptr)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
-		ret = register_trace_syscall_enter(ftrace_syscall_enter);
+		ret = register_trace_sys_enter(ftrace_syscall_enter);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
@@ -311,7 +312,7 @@ void unreg_event_syscall_enter(void *ptr)
 	sys_refcount_enter--;
 	clear_bit(num, enabled_enter_syscalls);
 	if (!sys_refcount_enter)
-		unregister_trace_syscall_enter(ftrace_syscall_enter);
+		unregister_trace_sys_enter(ftrace_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -327,7 +328,7 @@ int reg_event_syscall_exit(void *ptr)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
-		ret = register_trace_syscall_exit(ftrace_syscall_exit);
+		ret = register_trace_sys_exit(ftrace_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
@@ -352,7 +353,7 @@ void unreg_event_syscall_exit(void *ptr)
 	sys_refcount_exit--;
 	clear_bit(num, enabled_exit_syscalls);
 	if (!sys_refcount_exit)
-		unregister_trace_syscall_exit(ftrace_syscall_exit);
+		unregister_trace_sys_exit(ftrace_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -418,7 +419,7 @@ int reg_prof_syscall_enter(char *name)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_prof_refcount_enter)
-		ret = register_trace_syscall_enter(prof_syscall_enter);
+		ret = register_trace_sys_enter(prof_syscall_enter);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
@@ -442,7 +443,7 @@ void unreg_prof_syscall_enter(char *name)
 	sys_prof_refcount_enter--;
 	clear_bit(num, enabled_prof_enter_syscalls);
 	if (!sys_prof_refcount_enter)
-		unregister_trace_syscall_enter(prof_syscall_enter);
+		unregister_trace_sys_enter(prof_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -479,7 +480,7 @@ int reg_prof_syscall_exit(char *name)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_prof_refcount_exit)
-		ret = register_trace_syscall_exit(prof_syscall_exit);
+		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
@@ -503,7 +504,7 @@ void unreg_prof_syscall_exit(char *name)
 	sys_prof_refcount_exit--;
 	clear_bit(num, enabled_prof_exit_syscalls);
 	if (!sys_prof_refcount_exit)
-		unregister_trace_syscall_exit(prof_syscall_exit);
+		unregister_trace_sys_exit(prof_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-- 
1.6.2.5

