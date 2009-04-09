Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZDIEif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZDIEif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbZDIEhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:37:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351AbZDIEhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:37:41 -0400
Date: Thu, 9 Apr 2009 04:36:38 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tony.luck@intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
       md@google.com, tglx@linutronix.de, jbaron@redhat.com,
       laijs@cn.fujitsu.com, hpa@zytor.com, fche@redhat.com,
       jiayingz@google.com, linux-kernel@vger.kernel.org, mrubin@google.com,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mbligh@google.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@polymtl.ca,
       a.p.zijlstra@chello.nl, tony.luck@intel.com, fweisbec@gmail.com,
       rostedt@goodmis.org, md@google.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, hpa@zytor.com,
       fche@redhat.com, jiayingz@google.com, linux-kernel@vger.kernel.org,
       mrubin@google.com, kosaki.motohiro@jp.fujitsu.com, mbligh@google.com,
       mingo@elte.hu
In-Reply-To: <20090408184058.GB6017@nowhere>
References: <20090408184058.GB6017@nowhere>
Subject: [tip:tracing/urgent] tracing/syscalls: use a dedicated file header
Message-ID: <tip-47788c58e66c050982241d9a05eb690daceb05a9@git.kernel.org>
Git-Commit-ID: 47788c58e66c050982241d9a05eb690daceb05a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 04:36:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47788c58e66c050982241d9a05eb690daceb05a9
Gitweb:     http://git.kernel.org/tip/47788c58e66c050982241d9a05eb690daceb05a9
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 8 Apr 2009 20:40:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 05:43:32 +0200

tracing/syscalls: use a dedicated file header

Impact: fix build warnings and possibe compat misbehavior on IA64

Building a kernel on ia64 might trigger these ugly build warnings:

CC      arch/ia64/ia32/sys_ia32.o
In file included from arch/ia64/ia32/sys_ia32.c:55:
arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/ftrace.h:8,
                 from include/linux/syscalls.h:68,
                 from arch/ia64/ia32/sys_ia32.c:18:
arch/ia64/include/asm/elf.h:19:1: warning: this is the location of the previous definition
[...]

sys_ia32.c includes linux/syscalls.h which in turn includes linux/ftrace.h
to import the syscalls tracing prototypes.

But including ftrace.h can pull too much things for a low level file,
especially on ia64 where the ia32 private headers conflict with higher
level headers.

Now we isolate the syscall tracing headers in their own lightweight file.

Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Davidson <md@google.com>
LKML-Reference: <20090408184058.GB6017@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ftrace.c      |    2 ++
 arch/x86/kernel/ptrace.c      |    3 ++-
 include/linux/ftrace.h        |   29 -----------------------------
 include/linux/syscalls.h      |    2 +-
 include/trace/syscall.h       |   35 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c |    2 +-
 6 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 70a10ca..18dfa30 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,6 +18,8 @@
 #include <linux/init.h>
 #include <linux/list.h>
 
+#include <trace/syscall.h>
+
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index fe9345c..23b7c8f 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
-#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -35,6 +34,8 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
+#include <trace/syscall.h>
+
 #include "tls.h"
 
 enum x86_regset {
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ff112a8..8a0c2f2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -511,33 +511,4 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
-/*
- * A syscall entry in the ftrace syscalls array.
- *
- * @name: name of the syscall
- * @nb_args: number of parameters it takes
- * @types: list of types as strings
- * @args: list of args as strings (args[i] matches types[i])
- */
-struct syscall_metadata {
-	const char	*name;
-	int		nb_args;
-	const char	**types;
-	const char	**args;
-};
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern void arch_init_ftrace_syscalls(void);
-extern struct syscall_metadata *syscall_nr_to_meta(int nr);
-extern void start_ftrace_syscalls(void);
-extern void stop_ftrace_syscalls(void);
-extern void ftrace_syscall_enter(struct pt_regs *regs);
-extern void ftrace_syscall_exit(struct pt_regs *regs);
-#else
-static inline void start_ftrace_syscalls(void) { }
-static inline void stop_ftrace_syscalls(void) { }
-static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
-static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
-#endif
-
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6470f74..dabe4ad 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,7 +65,7 @@ struct old_linux_dirent;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
-#include <linux/ftrace.h>
+#include <trace/syscall.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
new file mode 100644
index 0000000..8cfe515
--- /dev/null
+++ b/include/trace/syscall.h
@@ -0,0 +1,35 @@
+#ifndef _TRACE_SYSCALL_H
+#define _TRACE_SYSCALL_H
+
+#include <asm/ptrace.h>
+
+/*
+ * A syscall entry in the ftrace syscalls array.
+ *
+ * @name: name of the syscall
+ * @nb_args: number of parameters it takes
+ * @types: list of types as strings
+ * @args: list of args as strings (args[i] matches types[i])
+ */
+struct syscall_metadata {
+	const char	*name;
+	int		nb_args;
+	const char	**types;
+	const char	**args;
+};
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+extern void arch_init_ftrace_syscalls(void);
+extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+extern void start_ftrace_syscalls(void);
+extern void stop_ftrace_syscalls(void);
+extern void ftrace_syscall_enter(struct pt_regs *regs);
+extern void ftrace_syscall_exit(struct pt_regs *regs);
+#else
+static inline void start_ftrace_syscalls(void)			{ }
+static inline void stop_ftrace_syscalls(void)			{ }
+static inline void ftrace_syscall_enter(struct pt_regs *regs)	{ }
+static inline void ftrace_syscall_exit(struct pt_regs *regs)	{ }
+#endif
+
+#endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a2a3af2..5e57964 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,5 @@
+#include <trace/syscall.h>
 #include <linux/kernel.h>
-#include <linux/ftrace.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
