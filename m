Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZCGExv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZCGExv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 23:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZCGExO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 23:53:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:36423 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZCGExK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 23:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WCWktzlB521s5MCa/vX7YPBbuUITYZFTs5cTjVgcMrD9ioxDOmmgrsxRJGpRDdg0oI
         Qu2VQH5/JPEUNNbwSjZQ01fKkBWgdNuvBV+D1+JcXTf4MCcENaeeQPIXKm9tOD95Vwjg
         4bBaCxVuGKEeFXJXMQ2aFS+vOaUhra3GpIHRo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 2/2] tracing/x86: basic implementation of syscall tracing for x86-64
Date: Sat,  7 Mar 2009 05:53:00 +0100
Message-Id: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the ptrace hooks and arch specific syscall numbers to ftrace arch indepedant
syscall numbers.
For now it only supports 4 syscalls to provide an example.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/ftrace.h      |    7 +++++++
 arch/x86/include/asm/thread_info.h |    9 ++++++---
 arch/x86/kernel/ftrace.c           |   15 +++++++++++++++
 arch/x86/kernel/ptrace.c           |    7 +++++++
 5 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2a0ddfe..b5aec1b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -35,6 +35,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select HAVE_FTRACE_SYSCALLS if X86_64
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..b2e6855 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,6 +28,13 @@
 
 #endif
 
+/* FIXME: I don't want to stay hardcoded */
+#ifdef CONFIG_X86_64
+#define FTRACE_SYSCALL_MAX	296
+#else
+#define FTRACE_SYSCALL_MAX	333
+#endif
+
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f6ba6f8..83d2b73 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,15 +118,17 @@ struct thread_info {
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |	\
 	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP)
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
+	 _TIF_SYSCALL_FTRACE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -134,7 +137,7 @@ struct thread_info {
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index a85da17..5bba98b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -453,3 +453,18 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_X86_64
+/*
+ * Array that make the arch specific syscall numbers
+ * matching the ftrace syscall numbers.
+ */
+short arch_syscall_trace_nr[FTRACE_SYSCALL_MAX] = {
+	[__NR_open]	= SYSCALL_TRACE_OPEN,
+	[__NR_close]	= SYSCALL_TRACE_CLOSE,
+	[__NR_read]	= SYSCALL_TRACE_READ,
+	[__NR_write]	= SYSCALL_TRACE_WRITE
+};
+#endif
+#endif
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 3d9672e..99749d6 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1416,6 +1417,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+		ftrace_syscall_enter(regs);
+
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
 			audit_syscall_entry(AUDIT_ARCH_I386,
@@ -1439,6 +1443,9 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+		ftrace_syscall_exit(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
 
-- 
1.6.1

