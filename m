Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZCMEaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZCMEaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZCME3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:29:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:54414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbZCME3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:29:45 -0400
Date: Fri, 13 Mar 2009 04:27:45 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
References: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/x86: basic implementation of syscall tracing for x86
Message-ID: <tip-1b3fa2ce64363c289b3b14723cca7290bf91cfce@git.kernel.org>
Git-Commit-ID: 1b3fa2ce64363c289b3b14723cca7290bf91cfce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:27:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b3fa2ce64363c289b3b14723cca7290bf91cfce
Gitweb:     http://git.kernel.org/tip/1b3fa2ce64363c289b3b14723cca7290bf91cfce
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 7 Mar 2009 05:53:00 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 06:25:44 +0100

tracing/x86: basic implementation of syscall tracing for x86

Provide the x86 trace callbacks to trace syscalls.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |    9 ++++++---
 arch/x86/kernel/ptrace.c           |    7 +++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdcee12..b0a638b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -35,6 +35,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select HAVE_FTRACE_SYSCALLS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index df9d5f7..8820a73 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -94,6 +94,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -115,15 +116,17 @@ struct thread_info {
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
@@ -132,7 +135,7 @@ struct thread_info {
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
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
 
