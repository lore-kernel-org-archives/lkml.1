Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580Ab0AZJjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0AZJjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778Ab0AZJjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:39:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33319 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab0AZJjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:39:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: David Miller <davem@davemloft.net>, heiko.carstens@de.ibm.com,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v3] ftrace: unify arch_syscall_addr() implementations
Date: Tue, 26 Jan 2010 04:40:03 -0500
Message-Id: <1264498803-17278-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1264230643-29434-1-git-send-email-vapier@gentoo.org>
References: <1264230643-29434-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most implementations of arch_syscall_addr() are the same, so create a
default version in common code and move the one piece that differs (the
syscall table) to asm/syscall.h.  New arch ports don't have to waste
time copying & pasting this simple function.

The s390/sparc versions need to be different, so document why.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
v3
	- move sys_call_table[] decl to asm/syscall.h
	- unify everyone's arch_syscall_addr() again
	- mention right tracehook requirements

 Documentation/trace/ftrace-design.txt |    5 ++---
 arch/s390/include/asm/syscall.h       |    7 +++++++
 arch/s390/kernel/ftrace.c             |   10 ----------
 arch/sh/include/asm/syscall.h         |    2 ++
 arch/sh/kernel/ftrace.c               |    9 ---------
 arch/sparc/include/asm/syscall.h      |    7 +++++++
 arch/sparc/kernel/ftrace.c            |   11 -----------
 arch/x86/include/asm/syscall.h        |    2 ++
 arch/x86/kernel/ftrace.c              |   10 ----------
 include/linux/ftrace.h                |    6 ++++++
 kernel/trace/trace_syscalls.c         |    5 +++++
 11 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 6a5a579..f1f81af 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -238,11 +238,10 @@ HAVE_SYSCALL_TRACEPOINTS
 
 You need very few things to get the syscalls tracing in an arch.
 
+- Support HAVE_ARCH_TRACEHOOK (see arch/Kconfig).
 - Have a NR_syscalls variable in <asm/unistd.h> that provides the number
   of syscalls supported by the arch.
-- Implement arch_syscall_addr() that resolves a syscall address from a
-  syscall number.
-- Support the TIF_SYSCALL_TRACEPOINT thread flags
+- Support the TIF_SYSCALL_TRACEPOINT thread flags.
 - Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
   in the ptrace syscalls tracing path.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index e0a73d3..8429686 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -15,6 +15,13 @@
 #include <linux/sched.h>
 #include <asm/ptrace.h>
 
+/*
+ * The syscall table always contains 32 bit pointers since we know that the
+ * address of the function to be called is (way) below 4GB.  So the "int"
+ * type here is what we want [need] for both 32 bit and 64 bit systems.
+ */
+extern const unsigned int sys_call_table[];
+
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 5a82bc6..9e69449 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -200,13 +200,3 @@ out:
 	return parent;
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-
-extern unsigned int sys_call_table[];
-
-unsigned long __init arch_syscall_addr(int nr)
-{
-	return (unsigned long)sys_call_table[nr];
-}
-#endif
diff --git a/arch/sh/include/asm/syscall.h b/arch/sh/include/asm/syscall.h
index 6a38142..aa7777b 100644
--- a/arch/sh/include/asm/syscall.h
+++ b/arch/sh/include/asm/syscall.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_SYSCALL_H
 #define __ASM_SH_SYSCALL_H
 
+extern const unsigned long sys_call_table[];
+
 #ifdef CONFIG_SUPERH32
 # include "syscall_32.h"
 #else
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index a48cded..30e1319 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -399,12 +399,3 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern unsigned long *sys_call_table;
-
-unsigned long __init arch_syscall_addr(int nr)
-{
-	return (unsigned long)sys_call_table[nr];
-}
-#endif /* CONFIG_FTRACE_SYSCALLS */
diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/syscall.h
index 7486c60..025a02a 100644
--- a/arch/sparc/include/asm/syscall.h
+++ b/arch/sparc/include/asm/syscall.h
@@ -5,6 +5,13 @@
 #include <linux/sched.h>
 #include <asm/ptrace.h>
 
+/*
+ * The syscall table always contains 32 bit pointers since we know that the
+ * address of the function to be called is (way) below 4GB.  So the "int"
+ * type here is what we want [need] for both 32 bit and 64 bit systems.
+ */
+extern const unsigned int sys_call_table[];
+
 /* The system call number is given by the user in %g1 */
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 29973da..9103a56 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -91,14 +91,3 @@ int __init ftrace_dyn_arch_init(void *data)
 	return 0;
 }
 #endif
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-
-extern unsigned int sys_call_table[];
-
-unsigned long __init arch_syscall_addr(int nr)
-{
-	return (unsigned long)sys_call_table[nr];
-}
-
-#endif
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 8d33bc5..c4a348f 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,6 +16,8 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
+extern const unsigned long sys_call_table[];
+
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
  * This importantly ignores the high bits on 64-bit, so comparisons
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3096892..0d93a94 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -484,13 +484,3 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-
-extern unsigned long *sys_call_table;
-
-unsigned long __init arch_syscall_addr(int nr)
-{
-	return (unsigned long)(&sys_call_table)[nr];
-}
-#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..1cbb36f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -511,4 +511,10 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+unsigned long arch_syscall_addr(int nr);
+
+#endif /* CONFIG_FTRACE_SYSCALLS */
+
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 75289f3..a72732e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -394,6 +394,11 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return 0;
 }
 
+unsigned long __init arch_syscall_addr(int nr)
+{
+	return (unsigned long)sys_call_table[nr];
+}
+
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
-- 
1.6.6.1

