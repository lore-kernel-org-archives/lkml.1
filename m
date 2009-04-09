Return-Path: <linux-kernel-owner+w=401wt.eu-S935654AbZDIPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654AbZDIPpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935636AbZDIPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:45:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935576AbZDIPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:45:22 -0400
Date: Thu, 9 Apr 2009 17:45:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090409154508.GA20747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      tracing/syscalls: use a dedicated file header

Li Zefan (2):
      blktrace: pass the right pointer to kfree()
      tracing: consolidate documents

Tetsuo Handa (1):
      tracing: append a comma to INIT_FTRACE_GRAPH


 Documentation/{ => trace}/ftrace.txt           |    0
 Documentation/{vm => trace}/kmemtrace.txt      |    0
 Documentation/{tracers => trace}/mmiotrace.txt |    0
 Documentation/{ => trace}/tracepoints.txt      |    0
 arch/x86/kernel/ftrace.c                       |    2 +
 arch/x86/kernel/ptrace.c                       |    3 +-
 include/linux/ftrace.h                         |   31 +--------------------
 include/linux/syscalls.h                       |    2 +-
 include/trace/syscall.h                        |   35 ++++++++++++++++++++++++
 kernel/trace/blktrace.c                        |   10 +++---
 kernel/trace/trace_syscalls.c                  |    2 +-
 11 files changed, 47 insertions(+), 38 deletions(-)
 rename Documentation/{ => trace}/ftrace.txt (100%)
 rename Documentation/{vm => trace}/kmemtrace.txt (100%)
 rename Documentation/{tracers => trace}/mmiotrace.txt (100%)
 rename Documentation/{ => trace}/tracepoints.txt (100%)
 create mode 100644 include/trace/syscall.h

diff --git a/Documentation/ftrace.txt b/Documentation/trace/ftrace.txt
similarity index 100%
rename from Documentation/ftrace.txt
rename to Documentation/trace/ftrace.txt
diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/trace/kmemtrace.txt
similarity index 100%
rename from Documentation/vm/kmemtrace.txt
rename to Documentation/trace/kmemtrace.txt
diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
similarity index 100%
rename from Documentation/tracers/mmiotrace.txt
rename to Documentation/trace/mmiotrace.txt
diff --git a/Documentation/tracepoints.txt b/Documentation/trace/tracepoints.txt
similarity index 100%
rename from Documentation/tracepoints.txt
rename to Documentation/trace/tracepoints.txt
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
index da5405d..8a0c2f2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -357,7 +357,7 @@ struct ftrace_graph_ret {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
-#define INIT_FTRACE_GRAPH		.ret_stack = NULL
+#define INIT_FTRACE_GRAPH		.ret_stack = NULL,
 
 /*
  * Stack of return addresses for functions
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
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b32ff44..921ef5d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1377,12 +1377,12 @@ static int blk_trace_str2mask(const char *str)
 {
 	int i;
 	int mask = 0;
-	char *s, *token;
+	char *buf, *s, *token;
 
-	s = kstrdup(str, GFP_KERNEL);
-	if (s == NULL)
+	buf = kstrdup(str, GFP_KERNEL);
+	if (buf == NULL)
 		return -ENOMEM;
-	s = strstrip(s);
+	s = strstrip(buf);
 
 	while (1) {
 		token = strsep(&s, ",");
@@ -1403,7 +1403,7 @@ static int blk_trace_str2mask(const char *str)
 			break;
 		}
 	}
-	kfree(s);
+	kfree(buf);
 
 	return mask;
 }
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
