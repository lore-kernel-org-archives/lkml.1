Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZCMOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZCMOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZCMOmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:42:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:24080 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZCMOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jgAkfE8O9CHtZdhg5uGLX5MFw1Wx7rKuJ/FxVnqAgu/wAZBRbTufgUW9t1Ts7nRCGa
         Wqj700ZUr+Er/TwJvYVAWiLNSVxWKSt3b1BeFuPGudBCLQy0P0RYo0dXZ7ODt0b+CpT3
         x92OQBp61MWi5IH0b/kBWlslVz1bTJoYrAWSw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: [PATCH 2/2 v2] tracing/syscalls: support for syscalls tracing on x86-64
Date: Fri, 13 Mar 2009 15:42:12 +0100
Message-Id: <1236955332-10133-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bits for syscalls tracing remain arch dependent, including:

- tasks trapping on syscalls entry/exit by using TIF_FLAFS
- call ftrace_syscall_{enter,exit}()
- implement syscall_nr_to_meta() which provides the syscalls metadata
  giving the syscall number

The latter callback is fast on x86-64, a table is built once the syscall
tracing is first launched. This table contains the address of each syscalls
metadata having the syscall number as an index on the table.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/ftrace.h      |    7 ++++
 arch/x86/include/asm/thread_info.h |    9 +++--
 arch/x86/kernel/ftrace.c           |   63 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace.c           |    7 ++++
 5 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15ec8a2..4c6e422 100644
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
index db24c22..d0954f7 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,6 +28,13 @@
 
 #endif
 
+/* FIXME: I don't want to stay hardcoded */
+#ifdef CONFIG_X86_64
+#define FTRACE_SYSCALL_MAX     296
+#else
+#define FTRACE_SYSCALL_MAX     333
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
index a85da17..1d0d7f4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -453,3 +453,66 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+extern unsigned long __start_syscalls_metadata[];
+extern unsigned long __stop_syscalls_metadata[];
+extern unsigned long *sys_call_table;
+
+static struct syscall_metadata **syscalls_metadata;
+
+static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
+{
+	struct syscall_metadata *start;
+	struct syscall_metadata *stop;
+	char str[KSYM_SYMBOL_LEN];
+
+
+	start = (struct syscall_metadata *)__start_syscalls_metadata;
+	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
+
+	for ( ; start < stop; start++) {
+		if (start->name && !strcmp(start->name, str))
+			return start;
+	}
+	return NULL;
+}
+
+struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_MAX || nr < 0)
+		return NULL;
+
+	return syscalls_metadata[nr];
+}
+
+void arch_init_ftrace_syscalls(void)
+{
+	int i;
+	struct syscall_metadata *meta;
+	unsigned long **psys_syscall_table = &sys_call_table;
+	static atomic_t refs;
+
+	if (atomic_inc_return(&refs) != 1)
+		goto end;
+
+	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+					FTRACE_SYSCALL_MAX, GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return;
+	}
+
+	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+		meta = find_syscall_meta(psys_syscall_table[i]);
+		syscalls_metadata[i] = meta;
+	}
+	return;
+
+	/* Paranoid: avoid overflow */
+end:
+	atomic_dec(&refs);
+}
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

