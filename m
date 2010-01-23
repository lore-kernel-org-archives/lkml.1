Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905Ab0AWHKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0AWHKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 02:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703Ab0AWHKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 02:10:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35784 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0AWHKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 02:10:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: David Miller <davem@davemloft.net>, heiko.carstens@de.ibm.com,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2] ftrace: unify arch_syscall_addr() implementations
Date: Sat, 23 Jan 2010 02:10:43 -0500
Message-Id: <1264230643-29434-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most implementations of arch_syscall_addr() are the same, so create a
default weak version in common code.  New arch ports don't have to waste
time copying & pasting this simple function.  The Blackfin version is
going to be exactly the same for example.

The s390/sparc versions need to be different, so document why.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- document s390/sparc funkiness

 Documentation/trace/ftrace-design.txt |    6 +++++-
 arch/s390/kernel/ftrace.c             |    7 ++++++-
 arch/sh/kernel/ftrace.c               |    9 ---------
 arch/sparc/kernel/ftrace.c            |    7 ++++++-
 arch/x86/kernel/ftrace.c              |   10 ----------
 include/linux/ftrace.h                |    6 ++++++
 kernel/trace/trace_syscalls.c         |    6 ++++++
 7 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 6a5a579..1a67b8c 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -240,8 +240,12 @@ You need very few things to get the syscalls tracing in an arch.
 
 - Have a NR_syscalls variable in <asm/unistd.h> that provides the number
   of syscalls supported by the arch.
+- Implement <asm/syscall.h>.
 - Implement arch_syscall_addr() that resolves a syscall address from a
-  syscall number.
+  syscall number.  For the simple arches where your syscall table is an
+  array of longs named "sys_call_table", there is a default implementation
+  in kernel/trace/trace_syscalls.c.  If your arch needs something weird,
+  then you'll have to define the function yourself.
 - Support the TIF_SYSCALL_TRACEPOINT thread flags
 - Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
   in the ptrace syscalls tracing path.
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 5a82bc6..d5fa352 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -203,7 +203,12 @@ out:
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned int sys_call_table[];
+/*
+ * The syscall table always contains 32 bit pointers since we know that the
+ * address of the function to be called is (way) below 4GB.  So the "int"
+ * type here is what we want [need] for both 32 bit and 64 bit systems.
+ */
+extern const unsigned int sys_call_table[];
 
 unsigned long __init arch_syscall_addr(int nr)
 {
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
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 29973da..deeeaa6 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -94,7 +94,12 @@ int __init ftrace_dyn_arch_init(void *data)
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned int sys_call_table[];
+/*
+ * The syscall table always contains 32 bit pointers since we know that the
+ * address of the function to be called is (way) below 4GB.  So the "int"
+ * type here is what we want [need] for both 32 bit and 64 bit systems.
+ */
+extern const unsigned int sys_call_table[];
 
 unsigned long __init arch_syscall_addr(int nr)
 {
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
index 75289f3..671c670 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -394,6 +394,12 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return 0;
 }
 
+unsigned long __init __weak arch_syscall_addr(int nr)
+{
+	extern const unsigned long sys_call_table[];
+	return sys_call_table[nr];
+}
+
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
-- 
1.6.6.1

