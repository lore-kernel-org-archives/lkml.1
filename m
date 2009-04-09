Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZDIAPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZDIAPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZDIAPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:15:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZDIAPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:15:06 -0400
Date: Wed, 8 Apr 2009 20:15:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: "Luck, Tony" <tony.luck@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: [GIT PULL][PATCH] tracing/syscalls: use a dedicated file header
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.0904082013200.16430@gandalf.stny.rr.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com> <20090408184058.GB6017@nowhere>
 <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Frederic Weisbecker (1):
      tracing/syscalls: use a dedicated file header

----
 arch/x86/kernel/ftrace.c      |    2 ++
 arch/x86/kernel/ptrace.c      |    2 ++
 include/linux/ftrace.h        |   29 -----------------------------
 include/linux/syscalls.h      |    2 +-
 include/trace/syscall.h       |   35 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c |    2 +-
 6 files changed, 41 insertions(+), 31 deletions(-)
---------------------------
commit e733d7da21b91da7cf593ca16523b60ae38f32fb
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Apr 8 20:26:11 2009 +0200

    tracing/syscalls: use a dedicated file header
    
    Impact: fix a build error on IA64
    
    Building a kernel on ia64 might trigger the following crash:
    
    CC      arch/ia64/ia32/sys_ia32.o
    In file included from arch/ia64/ia32/sys_ia32.c:55:
    arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
    In file included from include/linux/elf.h:7,
                     from include/linux/module.h:14,
                     from include/linux/ftrace.h:8,
                     from include/linux/syscalls.h:68,
                     from arch/ia64/ia32/sys_ia32.c:18:
    /home/aegl/generic-smp/arch/ia64/include/asm/elf.h:19:1: warning: this
    is the location of the previous definition
    In file included from arch/ia64/ia32/sys_ia32.c:55:
    arch/ia64/ia32/ia32priv.h:295:1: warning: "ELF_CLASS" redefined
    In file included from include/linux/elf.h:7,
                     from include/linux/module.h:14,
                     from include/linux/ftrace.h:8,
                     from include/linux/syscalls.h:68,
                     from arch/ia64/ia32/sys_ia32.c:18:
    
    sys_ia32.c includes linux/syscalls.h which in turn includes linux/ftrace.h
    to import the syscalls tracing prototypes.
    But including ftrace.h can pull too much things for a low level file,
    especially on ia64 where the ia32 private headers conflict with higher level
    headers.
    
    Now we isolate the syscall tracing headers in their own lightweight file.
    
    [ moved placement of #include <trace/syscall.h - Steven Rostedt ]
    
    Reported-Tested-and-Acked-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <20090408184058.GB6017@nowhere>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
index fe9345c..46609cc 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -23,6 +23,8 @@
 #include <linux/signal.h>
 #include <linux/ftrace.h>
 
+#include <trace/syscall.h>
+
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6aea54d..a5fa36d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -510,33 +510,4 @@ static inline void trace_hw_branch_oops(void) {}
 
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
index 0000000..27d1d31
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
+static inline void start_ftrace_syscalls(void) { }
+static inline void stop_ftrace_syscalls(void) { }
+static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
+static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
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


