Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968391Ab0B0OGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:06:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968340Ab0B0OGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:06:13 -0500
Date: Sat, 27 Feb 2010 15:05:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] tracing/core changes for v2.6.34
Message-ID: <20100227140553.GA12107@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      tracing: Drop the tr check from the graph tracing path

Heiko Carstens (3):
      tracing/kprobes: Make Kconfig dependencies generic
      s390: Add pt_regs register and stack access API
      tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API

Jeff Mahoney (1):
      tracing: Fix ftrace_event_call alignment for use with gcc 4.5

Lai Jiangshan (8):
      tracing: Have __dynamic_array() define a field
      tracing: Add print_fmt field
      tracing/syscalls: Init print_fmt for syscall events
      tracing/kprobes: Init print_fmt for kprobe events
      tracing: Use defined fields and print_fmt to print formats
      tracing: Remove show_format and related macros from TRACE_EVENT
      tracing: Consolidate protection of reader access to the ring buffer
      tracing: Simplify test for function_graph tracing start point

Li Zefan (2):
      ftrace: Allow to remove a single function from function graph filter
      tracing: Remove CONFIG_TRACE_POWER from kernel config

Mike Frysinger (1):
      tracing: Unify arch_syscall_addr() implementations

Steven Rostedt (6):
      tracing: Have syscall tracing call its own init function
      tracing: Add stack dump to trace_printk if stacktrace option is set
      tracing: Add correct/incorrect to sort keys for branch annotation output
      tracing: Add notrace to TRACE_EVENT implementation functions
      ftrace: Remove memory barriers from NMI code when not needed
      ftrace: Add function names to dangling } in function graph tracer

Wenji Huang (4):
      tracing: Fix typo in prof_sysexit_enable()
      tracing: Fix typo of info text in trace_kprobe.c
      tracing: Remove unnecessary variable in print_graph_return
      tracing: Simplify memory recycle of trace_define_field

Wolfram Sang (2):
      tracing: optimize recordmcount.pl for offsets-handling
      tracing: Use appropriate perl constructs in recordmcount.pl


 Documentation/trace/ftrace-design.txt |    5 +-
 arch/Kconfig                          |    8 ++
 arch/s390/Kconfig                     |    1 +
 arch/s390/include/asm/ptrace.h        |   13 ++-
 arch/s390/include/asm/syscall.h       |    7 +
 arch/s390/kernel/ftrace.c             |   10 --
 arch/s390/kernel/ptrace.c             |   58 ++++++++++
 arch/sh/include/asm/syscall.h         |    2 +
 arch/sh/kernel/ftrace.c               |    9 --
 arch/sparc/include/asm/syscall.h      |    7 +
 arch/sparc/kernel/ftrace.c            |   11 --
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/syscall.h        |    2 +
 arch/x86/kernel/ftrace.c              |   36 +++++--
 include/linux/ftrace.h                |    6 +
 include/linux/ftrace_event.h          |    3 +-
 include/linux/syscalls.h              |   12 +-
 include/trace/ftrace.h                |  195 +++++++++------------------------
 include/trace/syscall.h               |    4 -
 kernel/trace/Kconfig                  |   11 +--
 kernel/trace/ftrace.c                 |   51 +++++----
 kernel/trace/trace.c                  |  144 +++++++++++++++++-------
 kernel/trace/trace.h                  |    6 +-
 kernel/trace/trace_branch.c           |   19 +++-
 kernel/trace/trace_events.c           |   81 +++++++-------
 kernel/trace/trace_export.c           |   87 ++-------------
 kernel/trace/trace_functions_graph.c  |   78 +++++++++----
 kernel/trace/trace_kprobe.c           |  108 ++++++++-----------
 kernel/trace/trace_syscalls.c         |  113 ++++++++++---------
 scripts/recordmcount.pl               |   39 +++----
 30 files changed, 580 insertions(+), 547 deletions(-)

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
diff --git a/arch/Kconfig b/arch/Kconfig
index 9d055b4..50877ef 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -121,6 +121,14 @@ config HAVE_DMA_ATTRS
 config USE_GENERIC_SMP_HELPERS
 	bool
 
+config HAVE_REGS_AND_STACK_ACCESS_API
+	bool
+	help
+	  This symbol should be selected by an architecure if it supports
+	  the API needed to access registers and stack entries from pt_regs,
+	  declared in asm/ptrace.h
+	  For example the kprobes-based event tracer needs this API.
+
 config HAVE_CLK
 	bool
 	help
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c802352..2590ce2 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -87,6 +87,7 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 95dcf18..dd2d913 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -492,13 +492,24 @@ struct user_regs_struct
 struct task_struct;
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
+extern void show_regs(struct pt_regs * regs);
 
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
 #define regs_return_value(regs)((regs)->gprs[2])
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs * regs);
+
+int regs_query_register_offset(const char *name);
+const char *regs_query_register_name(unsigned int offset);
+unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset);
+unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n);
+
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+{
+	return regs->gprs[15] & PSW_ADDR_INSN;
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
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
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 7cf4642..33fdc5a 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -992,3 +992,61 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 #endif
 	return &user_s390_view;
 }
+
+static const char *gpr_names[NUM_GPRS] = {
+	"r0", "r1",  "r2",  "r3",  "r4",  "r5",  "r6",  "r7",
+	"r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
+};
+
+unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset)
+{
+	if (offset >= NUM_GPRS)
+		return 0;
+	return regs->gprs[offset];
+}
+
+int regs_query_register_offset(const char *name)
+{
+	unsigned long offset;
+
+	if (!name || *name != 'r')
+		return -EINVAL;
+	if (strict_strtoul(name + 1, 10, &offset))
+		return -EINVAL;
+	if (offset >= NUM_GPRS)
+		return -EINVAL;
+	return offset;
+}
+
+const char *regs_query_register_name(unsigned int offset)
+{
+	if (offset >= NUM_GPRS)
+		return NULL;
+	return gpr_names[offset];
+}
+
+static int regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
+{
+	unsigned long ksp = kernel_stack_pointer(regs);
+
+	return (addr & ~(THREAD_SIZE - 1)) == (ksp & ~(THREAD_SIZE - 1));
+}
+
+/**
+ * regs_get_kernel_stack_nth() - get Nth entry of the stack
+ * @regs:pt_regs which contains kernel stack pointer.
+ * @n:stack entry number.
+ *
+ * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
+ * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
+ * this returns 0.
+ */
+unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n)
+{
+	unsigned long addr;
+
+	addr = kernel_stack_pointer(regs) + n * sizeof(long);
+	if (!regs_within_kernel_stack(regs, addr))
+		return 0;
+	return *(unsigned long *)addr;
+}
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..0896008 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -45,6 +45,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
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
index 3096892..cd37469 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -30,14 +30,32 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+/*
+ * modifying_code is set to notify NMIs that they need to use
+ * memory barriers when entering or exiting. But we don't want
+ * to burden NMIs with unnecessary memory barriers when code
+ * modification is not being done (which is most of the time).
+ *
+ * A mutex is already held when ftrace_arch_code_modify_prepare
+ * and post_process are called. No locks need to be taken here.
+ *
+ * Stop machine will make sure currently running NMIs are done
+ * and new NMIs will see the updated variable before we need
+ * to worry about NMIs doing memory barriers.
+ */
+static int modifying_code __read_mostly;
+static DEFINE_PER_CPU(int, save_modifying_code);
+
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
+	modifying_code = 1;
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
+	modifying_code = 0;
 	set_kernel_text_ro();
 	return 0;
 }
@@ -149,6 +167,11 @@ static void ftrace_mod_code(void)
 
 void ftrace_nmi_enter(void)
 {
+	__get_cpu_var(save_modifying_code) = modifying_code;
+
+	if (!__get_cpu_var(save_modifying_code))
+		return;
+
 	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
 		smp_rmb();
 		ftrace_mod_code();
@@ -160,6 +183,9 @@ void ftrace_nmi_enter(void)
 
 void ftrace_nmi_exit(void)
 {
+	if (!__get_cpu_var(save_modifying_code))
+		return;
+
 	/* Finish all executions before clearing nmi_running */
 	smp_mb();
 	atomic_dec(&nmi_running);
@@ -484,13 +510,3 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
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
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2233c98..84a5629 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -121,9 +121,8 @@ struct ftrace_event_call {
 	int			(*regfunc)(struct ftrace_event_call *);
 	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
+	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
-	int			(*show_format)(struct ftrace_event_call *,
-					       struct trace_seq *);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 207466a..91bd7d7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -132,7 +132,8 @@ struct perf_event_attr;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
-	static struct ftrace_event_call event_enter_##sname;		\
+	static struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct trace_event enter_syscall_print_##sname = {	\
 		.trace                  = print_syscall_enter,		\
 	};								\
@@ -143,8 +144,7 @@ struct perf_event_attr;
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
-		.show_format		= syscall_enter_format,		\
+		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
@@ -154,7 +154,8 @@ struct perf_event_attr;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
-	static struct ftrace_event_call event_exit_##sname;		\
+	static struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct trace_event exit_syscall_print_##sname = {	\
 		.trace                  = print_syscall_exit,		\
 	};								\
@@ -165,8 +166,7 @@ struct perf_event_attr;
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
-		.show_format		= syscall_exit_format,		\
+		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c6fe03e..f23a0ca 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -65,7 +65,8 @@
 	};
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
-	static struct ftrace_event_call event_##name
+	static struct ftrace_event_call			\
+	__attribute__((__aligned__(4))) event_##name
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -131,130 +132,6 @@
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
- * Setup the showing format of trace point.
- *
- * int
- * ftrace_format_##call(struct trace_seq *s)
- * {
- *	struct ftrace_raw_##call field;
- *	int ret;
- *
- *	ret = trace_seq_printf(s, #type " " #item ";"
- *			       " offset:%u; size:%u;\n",
- *			       offsetof(struct ftrace_raw_##call, item),
- *			       sizeof(field.type));
- *
- * }
- */
-
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef __field
-#define __field(type, item)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item),	\
-			       (unsigned int)is_signed_type(type));	\
-	if (!ret)							\
-		return 0;
-
-#undef __field_ext
-#define __field_ext(type, item, filter_type)	__field(type, item)
-
-#undef __array
-#define __array(type, item, len)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item),	\
-			       (unsigned int)is_signed_type(type));	\
-	if (!ret)							\
-		return 0;
-
-#undef __dynamic_array
-#define __dynamic_array(type, item, len)				       \
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	       \
-			       (unsigned int)offsetof(typeof(field),	       \
-					__data_loc_##item),		       \
-			       (unsigned int)sizeof(field.__data_loc_##item), \
-			       (unsigned int)is_signed_type(type));	\
-	if (!ret)							       \
-		return 0;
-
-#undef __string
-#define __string(item, src) __dynamic_array(char, item, -1)
-
-#undef __entry
-#define __entry REC
-
-#undef __print_symbolic
-#undef __get_dynamic_array
-#undef __get_str
-
-#undef TP_printk
-#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
-
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...)
-
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
-static int								\
-ftrace_format_setup_##call(struct ftrace_event_call *unused,		\
-			   struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field __attribute__((unused));		\
-	int ret = 0;							\
-									\
-	tstruct;							\
-									\
-	return ret;							\
-}									\
-									\
-static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		     struct trace_seq *s)				\
-{									\
-	int ret = 0;							\
-									\
-	ret = ftrace_format_setup_##call(unused, s);			\
-	if (!ret)							\
-		return ret;						\
-									\
-	ret = trace_seq_printf(s, "\nprint fmt: " print);		\
-									\
-	return ret;							\
-}
-
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)
-
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)		\
-static int								\
-ftrace_format_##name(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
-{									\
-	int ret = 0;							\
-									\
-	ret = ftrace_format_setup_##template(unused, s);		\
-	if (!ret)							\
-		return ret;						\
-									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
-									\
-	return ret;							\
-}
-
-#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-
-/*
  * Stage 3 of the trace events.
  *
  * Override the macros in <trace/trace_events.h> to include the following:
@@ -323,7 +200,7 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_id_##call(int event_id, const char *name,		\
 			    struct trace_iterator *iter, int flags)	\
 {									\
@@ -356,7 +233,7 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 {									\
 	return ftrace_raw_output_id_##template(event_##name.id,		\
@@ -365,7 +242,7 @@ ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
 	struct trace_seq *s = &iter->seq;				\
@@ -431,7 +308,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
-static int								\
+static int notrace							\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
@@ -479,7 +356,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static inline int ftrace_get_offsets_##call(				\
+static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
@@ -526,12 +403,14 @@ static inline int ftrace_get_offsets_##call(				\
 									\
 static void ftrace_profile_##name(proto);				\
 									\
-static int ftrace_profile_enable_##name(struct ftrace_event_call *unused)\
+static notrace int							\
+ftrace_profile_enable_##name(struct ftrace_event_call *unused)		\
 {									\
 	return register_trace_##name(ftrace_profile_##name);		\
 }									\
 									\
-static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
+static notrace void							\
+ftrace_profile_disable_##name(struct ftrace_event_call *unused)		\
 {									\
 	unregister_trace_##name(ftrace_profile_##name);			\
 }
@@ -622,7 +501,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
- *	.show_format		= ftrace_format_<call>,
  * }
  *
  */
@@ -657,10 +535,17 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), src);
 
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TP_perf_assign
+#define TP_perf_assign(args...)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
-static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
+static notrace void							\
+ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 				       proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
@@ -697,17 +582,19 @@ static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static void ftrace_raw_event_##call(proto)				\
+static notrace void ftrace_raw_event_##call(proto)			\
 {									\
 	ftrace_raw_event_id_##template(&event_##call, args);		\
 }									\
 									\
-static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
+static notrace int							\
+ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)		\
 {									\
 	return register_trace_##call(ftrace_raw_event_##call);		\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
+static notrace void							\
+ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)		\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -722,8 +609,20 @@ static struct trace_event ftrace_event_type_##call = {			\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#undef __entry
+#define __entry REC
+
+#undef __print_flags
+#undef __print_symbolic
+#undef __get_dynamic_array
+#undef __get_str
+
+#undef TP_printk
+#define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
+
 #undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+static const char print_fmt_##call[] = print;
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -737,7 +636,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##template,		\
+	.print_fmt		= print_fmt_##template,			\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
 }
@@ -745,6 +644,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 									\
+static const char print_fmt_##call[] = print;				\
+									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
@@ -754,7 +655,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##call,			\
+	.print_fmt		= print_fmt_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
 }
@@ -837,6 +738,16 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #ifdef CONFIG_EVENT_PROFILE
 
+#undef __entry
+#define __entry entry
+
+#undef __get_dynamic_array
+#define __get_dynamic_array(field)	\
+		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
+
+#undef __get_str
+#define __get_str(field) (char *)__get_dynamic_array(field)
+
 #undef __perf_addr
 #define __perf_addr(a) __addr = (a)
 
@@ -845,7 +756,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static void								\
+static notrace void							\
 ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			    proto)					\
 {									\
@@ -915,7 +826,7 @@ end_recursion:								\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
-static void ftrace_profile_##call(proto)			\
+static notrace void ftrace_profile_##call(proto)		\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
 								\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 961fda3..8cd4102 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -34,10 +34,6 @@ struct syscall_metadata {
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
-extern int syscall_enter_format(struct ftrace_event_call *call,
-				struct trace_seq *s);
-extern int syscall_exit_format(struct ftrace_event_call *call,
-				struct trace_seq *s);
 extern int syscall_enter_define_fields(struct ftrace_event_call *call);
 extern int syscall_exit_define_fields(struct ftrace_event_call *call);
 extern int reg_event_syscall_enter(struct ftrace_event_call *call);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 60e2ce0..13e13d4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -328,15 +328,6 @@ config BRANCH_TRACER
 
 	  Say N if unsure.
 
-config POWER_TRACER
-	bool "Trace power consumption behavior"
-	depends on X86
-	select GENERIC_TRACER
-	help
-	  This tracer helps developers to analyze and optimize the kernel's
-	  power management decisions, specifically the C-state and P-state
-	  behavior.
-
 config KSYM_TRACER
 	bool "Trace read and write access on kernel memory locations"
 	depends on HAVE_HW_BREAKPOINT
@@ -449,7 +440,7 @@ config BLK_DEV_IO_TRACE
 
 config KPROBE_EVENT
 	depends on KPROBES
-	depends on X86
+	depends on HAVE_REGS_AND_STACK_ACCESS_API
 	bool "Enable kprobes-based dynamic events"
 	select TRACING
 	default y
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e6640f..d996353 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2426,6 +2426,7 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 int ftrace_graph_count;
+int ftrace_graph_filter_enabled;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
@@ -2448,7 +2449,7 @@ static void *g_start(struct seq_file *m, loff_t *pos)
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
-	if (!ftrace_graph_count && !*pos)
+	if (!ftrace_graph_filter_enabled && !*pos)
 		return (void *)1;
 
 	return __g_next(m, pos);
@@ -2494,6 +2495,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
+		ftrace_graph_filter_enabled = 0;
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
@@ -2519,7 +2521,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 	int search_len;
-	int found = 0;
+	int fail = 1;
 	int type, not;
 	char *search;
 	bool exists;
@@ -2530,37 +2532,51 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 
 	/* decode regex */
 	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
-	if (not)
-		return -EINVAL;
+	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
+		return -EBUSY;
 
 	search_len = strlen(search);
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
-			break;
-
 		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
 			continue;
 
 		if (ftrace_match_record(rec, search, search_len, type)) {
-			/* ensure it is not already in the array */
+			/* if it is in the array */
 			exists = false;
-			for (i = 0; i < *idx; i++)
+			for (i = 0; i < *idx; i++) {
 				if (array[i] == rec->ip) {
 					exists = true;
 					break;
 				}
-			if (!exists)
-				array[(*idx)++] = rec->ip;
-			found = 1;
+			}
+
+			if (!not) {
+				fail = 0;
+				if (!exists) {
+					array[(*idx)++] = rec->ip;
+					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
+						goto out;
+				}
+			} else {
+				if (exists) {
+					array[i] = array[--(*idx)];
+					array[*idx] = 0;
+					fail = 0;
+				}
+			}
 		}
 	} while_for_each_ftrace_rec();
-
+out:
 	mutex_unlock(&ftrace_lock);
 
-	return found ? 0 : -EINVAL;
+	if (fail)
+		return -EINVAL;
+
+	ftrace_graph_filter_enabled = 1;
+	return 0;
 }
 
 static ssize_t
@@ -2570,16 +2586,11 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	struct trace_parser parser;
 	ssize_t read, ret;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&graph_lock);
 
-	if (ftrace_graph_count >= FTRACE_GRAPH_MAX_FUNCS) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
 		ret = -ENOMEM;
 		goto out_unlock;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eac6875..032c57c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -32,6 +32,7 @@
 #include <linux/splice.h>
 #include <linux/kdebug.h>
 #include <linux/string.h>
+#include <linux/rwsem.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -102,9 +103,6 @@ static inline void ftrace_enable_cpu(void)
 
 static cpumask_var_t __read_mostly	tracing_buffer_mask;
 
-/* Define which cpu buffers are currently read in trace_pipe */
-static cpumask_var_t			tracing_reader_cpumask;
-
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu(cpu, tracing_buffer_mask)
 
@@ -243,12 +241,91 @@ static struct tracer		*current_trace __read_mostly;
 
 /*
  * trace_types_lock is used to protect the trace_types list.
- * This lock is also used to keep user access serialized.
- * Accesses from userspace will grab this lock while userspace
- * activities happen inside the kernel.
  */
 static DEFINE_MUTEX(trace_types_lock);
 
+/*
+ * serialize the access of the ring buffer
+ *
+ * ring buffer serializes readers, but it is low level protection.
+ * The validity of the events (which returns by ring_buffer_peek() ..etc)
+ * are not protected by ring buffer.
+ *
+ * The content of events may become garbage if we allow other process consumes
+ * these events concurrently:
+ *   A) the page of the consumed events may become a normal page
+ *      (not reader page) in ring buffer, and this page will be rewrited
+ *      by events producer.
+ *   B) The page of the consumed events may become a page for splice_read,
+ *      and this page will be returned to system.
+ *
+ * These primitives allow multi process access to different cpu ring buffer
+ * concurrently.
+ *
+ * These primitives don't distinguish read-only and read-consume access.
+ * Multi read-only access are also serialized.
+ */
+
+#ifdef CONFIG_SMP
+static DECLARE_RWSEM(all_cpu_access_lock);
+static DEFINE_PER_CPU(struct mutex, cpu_access_lock);
+
+static inline void trace_access_lock(int cpu)
+{
+	if (cpu == TRACE_PIPE_ALL_CPU) {
+		/* gain it for accessing the whole ring buffer. */
+		down_write(&all_cpu_access_lock);
+	} else {
+		/* gain it for accessing a cpu ring buffer. */
+
+		/* Firstly block other trace_access_lock(TRACE_PIPE_ALL_CPU). */
+		down_read(&all_cpu_access_lock);
+
+		/* Secondly block other access to this @cpu ring buffer. */
+		mutex_lock(&per_cpu(cpu_access_lock, cpu));
+	}
+}
+
+static inline void trace_access_unlock(int cpu)
+{
+	if (cpu == TRACE_PIPE_ALL_CPU) {
+		up_write(&all_cpu_access_lock);
+	} else {
+		mutex_unlock(&per_cpu(cpu_access_lock, cpu));
+		up_read(&all_cpu_access_lock);
+	}
+}
+
+static inline void trace_access_lock_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		mutex_init(&per_cpu(cpu_access_lock, cpu));
+}
+
+#else
+
+static DEFINE_MUTEX(access_lock);
+
+static inline void trace_access_lock(int cpu)
+{
+	(void)cpu;
+	mutex_lock(&access_lock);
+}
+
+static inline void trace_access_unlock(int cpu)
+{
+	(void)cpu;
+	mutex_unlock(&access_lock);
+}
+
+static inline void trace_access_lock_init(void)
+{
+}
+
+#endif
+
 /* trace_wait is a waitqueue for tasks blocked on trace_poll */
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
@@ -1320,8 +1397,10 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
+		ftrace_trace_stack(buffer, flags, 6, pc);
+	}
 
 out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
@@ -1394,8 +1473,10 @@ int trace_array_vprintk(struct trace_array *tr,
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = '\0';
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
+		ftrace_trace_stack(buffer, irq_flags, 6, pc);
+	}
 
  out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
@@ -1585,12 +1666,6 @@ static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 }
 
 /*
- * No necessary locking here. The worst thing which can
- * happen is loosing events consumed at the same time
- * by a trace_pipe reader.
- * Other than that, we don't risk to crash the ring buffer
- * because it serializes the readers.
- *
  * The current tracer is copied to avoid a global locking
  * all around.
  */
@@ -1645,12 +1720,16 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	}
 
 	trace_event_read_lock();
+	trace_access_lock(cpu_file);
 	return p;
 }
 
 static void s_stop(struct seq_file *m, void *p)
 {
+	struct trace_iterator *iter = m->private;
+
 	atomic_dec(&trace_record_cmdline_disabled);
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
 
@@ -2841,22 +2920,6 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	mutex_lock(&trace_types_lock);
 
-	/* We only allow one reader per cpu */
-	if (cpu_file == TRACE_PIPE_ALL_CPU) {
-		if (!cpumask_empty(tracing_reader_cpumask)) {
-			ret = -EBUSY;
-			goto out;
-		}
-		cpumask_setall(tracing_reader_cpumask);
-	} else {
-		if (!cpumask_test_cpu(cpu_file, tracing_reader_cpumask))
-			cpumask_set_cpu(cpu_file, tracing_reader_cpumask);
-		else {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-
 	/* create a buffer to store the information to pass to userspace */
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter) {
@@ -2912,12 +2975,6 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	if (iter->cpu_file == TRACE_PIPE_ALL_CPU)
-		cpumask_clear(tracing_reader_cpumask);
-	else
-		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
-
-
 	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
 
@@ -3079,6 +3136,7 @@ waitagain:
 	iter->pos = -1;
 
 	trace_event_read_lock();
+	trace_access_lock(iter->cpu_file);
 	while (find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
@@ -3095,6 +3153,7 @@ waitagain:
 		if (iter->seq.len >= cnt)
 			break;
 	}
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 
 	/* Now copy what we have to the user */
@@ -3220,6 +3279,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	}
 
 	trace_event_read_lock();
+	trace_access_lock(iter->cpu_file);
 
 	/* Fill as many pages as possible. */
 	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
@@ -3243,6 +3303,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		trace_seq_init(&iter->seq);
 	}
 
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 	mutex_unlock(&iter->mutex);
 
@@ -3544,10 +3605,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
 	info->read = 0;
 
+	trace_access_lock(info->cpu);
 	ret = ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
 				    count,
 				    info->cpu, 0);
+	trace_access_unlock(info->cpu);
 	if (ret < 0)
 		return 0;
 
@@ -3675,6 +3738,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		len &= PAGE_MASK;
 	}
 
+	trace_access_lock(info->cpu);
 	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 
 	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
@@ -3722,6 +3786,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 	}
 
+	trace_access_unlock(info->cpu);
 	spd.nr_pages = i;
 
 	/* did we read anything? */
@@ -4158,6 +4223,8 @@ static __init int tracer_init_debugfs(void)
 	struct dentry *d_tracer;
 	int cpu;
 
+	trace_access_lock_init();
+
 	d_tracer = tracing_init_dentry();
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
@@ -4392,9 +4459,6 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
-	if (!zalloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
-		goto out_free_tracing_cpumask;
-
 	/* To save memory, keep the ring buffer size to its minimum */
 	if (ring_buffer_expanded)
 		ring_buf_size = trace_buf_size;
@@ -4452,8 +4516,6 @@ __init static int tracer_alloc_buffers(void)
 	return 0;
 
 out_free_cpumask:
-	free_cpumask_var(tracing_reader_cpumask);
-out_free_tracing_cpumask:
 	free_cpumask_var(tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4df6a77..fd05bca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -497,6 +497,7 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
 #define FTRACE_GRAPH_MAX_FUNCS		32
+extern int ftrace_graph_filter_enabled;
 extern int ftrace_graph_count;
 extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
 
@@ -504,7 +505,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 {
 	int i;
 
-	if (!ftrace_graph_count || test_tsk_trace_graph(current))
+	if (!ftrace_graph_filter_enabled)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
@@ -791,7 +792,8 @@ extern const char *__stop___trace_bprintk_fmt[];
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
-	extern struct ftrace_event_call event_##call;
+	extern struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4a194f0..b9bc4d4 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -307,8 +307,23 @@ static int annotated_branch_stat_cmp(void *p1, void *p2)
 		return -1;
 	if (percent_a > percent_b)
 		return 1;
-	else
-		return 0;
+
+	if (a->incorrect < b->incorrect)
+		return -1;
+	if (a->incorrect > b->incorrect)
+		return 1;
+
+	/*
+	 * Since the above shows worse (incorrect) cases
+	 * first, we continue that by showing best (correct)
+	 * cases last.
+	 */
+	if (a->correct > b->correct)
+		return -1;
+	if (a->correct < b->correct)
+		return 1;
+
+	return 0;
 }
 
 static struct tracer_stat annotated_branch_stats = {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..3f972ad 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	return 0;
 
 err:
-	if (field) {
+	if (field)
 		kfree(field->name);
-		kfree(field->type);
-	}
 	kfree(field);
 
 	return -ENOMEM;
@@ -520,41 +518,16 @@ out:
 	return ret;
 }
 
-extern char *__bad_type_size(void);
-
-#undef FIELD
-#define FIELD(type, name)						\
-	sizeof(type) != sizeof(field.name) ? __bad_type_size() :	\
-	#type, "common_" #name, offsetof(typeof(field), name),		\
-		sizeof(field.name), is_signed_type(type)
-
-static int trace_write_header(struct trace_seq *s)
-{
-	struct trace_entry field;
-
-	/* struct trace_entry */
-	return trace_seq_printf(s,
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\n",
-			FIELD(unsigned short, type),
-			FIELD(unsigned char, flags),
-			FIELD(unsigned char, preempt_count),
-			FIELD(int, pid),
-			FIELD(int, lock_depth));
-}
-
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_field *field;
 	struct trace_seq *s;
+	int common_field_count = 5;
 	char *buf;
-	int r;
+	int r = 0;
 
 	if (*ppos)
 		return 0;
@@ -565,14 +538,48 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	/* If any of the first writes fail, so will the show_format. */
-
 	trace_seq_printf(s, "name: %s\n", call->name);
 	trace_seq_printf(s, "ID: %d\n", call->id);
 	trace_seq_printf(s, "format:\n");
-	trace_write_header(s);
 
-	r = call->show_format(call, s);
+	list_for_each_entry_reverse(field, &call->fields, link) {
+		/*
+		 * Smartly shows the array type(except dynamic array).
+		 * Normal:
+		 *	field:TYPE VAR
+		 * If TYPE := TYPE[LEN], it is shown:
+		 *	field:TYPE VAR[LEN]
+		 */
+		const char *array_descriptor = strchr(field->type, '[');
+
+		if (!strncmp(field->type, "__data_loc", 10))
+			array_descriptor = NULL;
+
+		if (!array_descriptor) {
+			r = trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
+					"\tsize:%u;\tsigned:%d;\n",
+					field->type, field->name, field->offset,
+					field->size, !!field->is_signed);
+		} else {
+			r = trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
+					"\tsize:%u;\tsigned:%d;\n",
+					(int)(array_descriptor - field->type),
+					field->type, field->name,
+					array_descriptor, field->offset,
+					field->size, !!field->is_signed);
+		}
+
+		if (--common_field_count == 0)
+			r = trace_seq_printf(s, "\n");
+
+		if (!r)
+			break;
+	}
+
+	if (r)
+		r = trace_seq_printf(s, "\nprint fmt: %s\n",
+				call->print_fmt);
+
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
@@ -948,10 +955,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 				  filter);
 	}
 
-	/* A trace may not want to export its format */
-	if (!call->show_format)
-		return 0;
-
 	trace_create_file("format", 0444, call->dir, call,
 			  format);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d4fa5dc..e091f64 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -62,78 +62,6 @@ static void __always_unused ____ftrace_check_##name(void)	\
 
 #include "trace_entries.h"
 
-
-#undef __field
-#define __field(type, item)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item), is_signed_type(type)); \
-	if (!ret)							\
-		return 0;
-
-#undef __field_desc
-#define __field_desc(type, container, item)				\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
-			       offsetof(typeof(field), container.item),	\
-			       sizeof(field.container.item),		\
-			       is_signed_type(type));			\
-	if (!ret)							\
-		return 0;
-
-#undef __array
-#define __array(type, item, len)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
-			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item), is_signed_type(type)); \
-	if (!ret)							\
-		return 0;
-
-#undef __array_desc
-#define __array_desc(type, container, item, len)			\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
-			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
-			       offsetof(typeof(field), container.item),	\
-			       sizeof(field.container.item),		\
-			       is_signed_type(type));			\
-	if (!ret)							\
-		return 0;
-
-#undef __dynamic_array
-#define __dynamic_array(type, item)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:0;\tsigned:%u;\n",	\
-			       offsetof(typeof(field), item),		\
-			       is_signed_type(type));			\
-	if (!ret)							\
-		return 0;
-
-#undef F_printk
-#define F_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
-
-#undef __entry
-#define __entry REC
-
-#undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
-static int								\
-ftrace_format_##name(struct ftrace_event_call *unused,			\
-		     struct trace_seq *s)				\
-{									\
-	struct struct_name field __attribute__((unused));		\
-	int ret = 0;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
-									\
-	return ret;							\
-}
-
-#include "trace_entries.h"
-
 #undef __field
 #define __field(type, item)						\
 	ret = trace_define_field(event_call, #type, #item,		\
@@ -175,7 +103,12 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 		return ret;
 
 #undef __dynamic_array
-#define __dynamic_array(type, item)
+#define __dynamic_array(type, item)					\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 0, is_signed_type(type), FILTER_OTHER);\
+	if (ret)							\
+		return ret;
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
@@ -198,6 +131,9 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 	return 0;
 }
 
+#undef __entry
+#define __entry REC
+
 #undef __field
 #define __field(type, item)
 
@@ -213,6 +149,9 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 #undef __dynamic_array
 #define __dynamic_array(type, item)
 
+#undef F_printk
+#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
 									\
@@ -223,7 +162,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.id			= type,					\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.raw_init		= ftrace_raw_init_event,		\
-	.show_format		= ftrace_format_##call,			\
+	.print_fmt		= print,				\
 	.define_fields		= ftrace_define_fields_##call,		\
 };									\
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b1342c5..e998a82 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -18,6 +18,7 @@ struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
 	int		ignore;
+	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
 };
 
 struct fgraph_data {
@@ -212,13 +213,11 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	int cpu;
 	int pc;
 
-	if (unlikely(!tr))
-		return 0;
-
 	if (!ftrace_trace_task(current))
 		return 0;
 
-	if (!ftrace_graph_addr(trace->func))
+	/* trace it when it is-nested-in or is a function enabled. */
+	if (!(trace->depth || ftrace_graph_addr(trace->func)))
 		return 0;
 
 	local_irq_save(flags);
@@ -231,9 +230,6 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	} else {
 		ret = 0;
 	}
-	/* Only do the atomic if it is not already set */
-	if (!test_tsk_trace_graph(current))
-		set_tsk_trace_graph(current);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
@@ -281,17 +277,24 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 		pc = preempt_count();
 		__trace_graph_return(tr, trace, flags, pc);
 	}
-	if (!trace->depth)
-		clear_tsk_trace_graph(current);
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
+void set_graph_array(struct trace_array *tr)
+{
+	graph_array = tr;
+
+	/* Make graph_array visible before we start tracing */
+
+	smp_mb();
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int ret;
 
-	graph_array = tr;
+	set_graph_array(tr);
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry);
 	if (ret)
@@ -301,11 +304,6 @@ static int graph_trace_init(struct trace_array *tr)
 	return 0;
 }
 
-void set_graph_array(struct trace_array *tr)
-{
-	graph_array = tr;
-}
-
 static void graph_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_cmdline_record();
@@ -673,15 +671,21 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	duration = graph_ret->rettime - graph_ret->calltime;
 
 	if (data) {
+		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
 
 		/*
 		 * Comments display at + 1 to depth. Since
 		 * this is a leaf function, keep the comments
 		 * equal to this depth.
 		 */
-		*depth = call->depth - 1;
+		cpu_data->depth = call->depth - 1;
+
+		/* No need to keep this function around for this depth */
+		if (call->depth < FTRACE_RETFUNC_DEPTH)
+			cpu_data->enter_funcs[call->depth] = 0;
 	}
 
 	/* Overhead */
@@ -721,10 +725,15 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	int i;
 
 	if (data) {
+		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
-		*depth = call->depth;
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
+		cpu_data->depth = call->depth;
+
+		/* Save this function pointer to see if the exit matches */
+		if (call->depth < FTRACE_RETFUNC_DEPTH)
+			cpu_data->enter_funcs[call->depth] = call->func;
 	}
 
 	/* No overhead */
@@ -854,19 +863,28 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	struct fgraph_data *data = iter->private;
 	pid_t pid = ent->pid;
 	int cpu = iter->cpu;
+	int func_match = 1;
 	int ret;
 	int i;
 
 	if (data) {
+		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
 
 		/*
 		 * Comments display at + 1 to depth. This is the
 		 * return from a function, we now want the comments
 		 * to display at the same level of the bracket.
 		 */
-		*depth = trace->depth - 1;
+		cpu_data->depth = trace->depth - 1;
+
+		if (trace->depth < FTRACE_RETFUNC_DEPTH) {
+			if (cpu_data->enter_funcs[trace->depth] != trace->func)
+				func_match = 0;
+			cpu_data->enter_funcs[trace->depth] = 0;
+		}
 	}
 
 	if (print_graph_prologue(iter, s, 0, 0))
@@ -891,9 +909,21 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "}\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	/*
+	 * If the return function does not have a matching entry,
+	 * then the entry was lost. Instead of just printing
+	 * the '}' and letting the user guess what function this
+	 * belongs to, write out the function name.
+	 */
+	if (func_match) {
+		ret = trace_seq_printf(s, "}\n");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	} else {
+		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Overrun */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 50b1b82..465b36b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -651,12 +651,12 @@ static int create_trace_probe(int argc, char **argv)
 			event = strchr(group, '/') + 1;
 			event[-1] = '\0';
 			if (strlen(group) == 0) {
-				pr_info("Group name is not specifiled\n");
+				pr_info("Group name is not specified\n");
 				return -EINVAL;
 			}
 		}
 		if (strlen(event) == 0) {
-			pr_info("Event name is not specifiled\n");
+			pr_info("Event name is not specified\n");
 			return -EINVAL;
 		}
 	}
@@ -1174,80 +1174,60 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __probe_event_show_format(struct trace_seq *s,
-				     struct trace_probe *tp, const char *fmt,
-				     const char *arg)
+static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 {
 	int i;
+	int pos = 0;
 
-	/* Show format */
-	if (!trace_seq_printf(s, "\nprint fmt: \"%s", fmt))
-		return 0;
+	const char *fmt, *arg;
 
-	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_printf(s, " %s=%%lx", tp->args[i].name))
-			return 0;
+	if (!probe_is_return(tp)) {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	} else {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	}
 
-	if (!trace_seq_printf(s, "\", %s", arg))
-		return 0;
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
 
-	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_printf(s, ", REC->%s", tp->args[i].name))
-			return 0;
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
 
-	return trace_seq_puts(s, "\n");
-}
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%%lx",
+				tp->args[i].name);
+	}
 
-#undef SHOW_FIELD
-#define SHOW_FIELD(type, item, name)					\
-	do {								\
-		ret = trace_seq_printf(s, "\tfield:" #type " %s;\t"	\
-				"offset:%u;\tsize:%u;\tsigned:%d;\n", name,\
-				(unsigned int)offsetof(typeof(field), item),\
-				(unsigned int)sizeof(type),		\
-				is_signed_type(type));			\
-		if (!ret)						\
-			return 0;					\
-	} while (0)
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
 
-static int kprobe_event_show_format(struct ftrace_event_call *call,
-				    struct trace_seq *s)
-{
-	struct kprobe_trace_entry field __attribute__((unused));
-	int ret, i;
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	SHOW_FIELD(unsigned long, ip, FIELD_STRING_IP);
-	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+				tp->args[i].name);
+	}
 
-	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++)
-		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
-	trace_seq_puts(s, "\n");
+#undef LEN_OR_ZERO
 
-	return __probe_event_show_format(s, tp, "(%lx)",
-					 "REC->" FIELD_STRING_IP);
+	/* return the length of print_fmt */
+	return pos;
 }
 
-static int kretprobe_event_show_format(struct ftrace_event_call *call,
-				       struct trace_seq *s)
+static int set_print_fmt(struct trace_probe *tp)
 {
-	struct kretprobe_trace_entry field __attribute__((unused));
-	int ret, i;
-	struct trace_probe *tp = (struct trace_probe *)call->data;
+	int len;
+	char *print_fmt;
 
-	SHOW_FIELD(unsigned long, func, FIELD_STRING_FUNC);
-	SHOW_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP);
-	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_print_fmt(tp, NULL, 0);
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
 
-	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++)
-		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
-	trace_seq_puts(s, "\n");
+	/* Second: actually write the @print_fmt */
+	__set_print_fmt(tp, print_fmt, len + 1);
+	tp->call.print_fmt = print_fmt;
 
-	return __probe_event_show_format(s, tp, "(%lx <- %lx)",
-					 "REC->" FIELD_STRING_FUNC
-					 ", REC->" FIELD_STRING_RETIP);
+	return 0;
 }
 
 #ifdef CONFIG_EVENT_PROFILE
@@ -1448,18 +1428,20 @@ static int register_probe_event(struct trace_probe *tp)
 	if (probe_is_return(tp)) {
 		tp->event.trace = print_kretprobe_event;
 		call->raw_init = probe_event_raw_init;
-		call->show_format = kretprobe_event_show_format;
 		call->define_fields = kretprobe_event_define_fields;
 	} else {
 		tp->event.trace = print_kprobe_event;
 		call->raw_init = probe_event_raw_init;
-		call->show_format = kprobe_event_show_format;
 		call->define_fields = kprobe_event_define_fields;
 	}
+	if (set_print_fmt(tp) < 0)
+		return -ENOMEM;
 	call->event = &tp->event;
 	call->id = register_ftrace_event(&tp->event);
-	if (!call->id)
+	if (!call->id) {
+		kfree(call->print_fmt);
 		return -ENODEV;
+	}
 	call->enabled = 0;
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
@@ -1472,6 +1454,7 @@ static int register_probe_event(struct trace_probe *tp)
 	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
+		kfree(call->print_fmt);
 		unregister_ftrace_event(&tp->event);
 	}
 	return ret;
@@ -1481,6 +1464,7 @@ static void unregister_probe_event(struct trace_probe *tp)
 {
 	/* tp->event is unregistered in trace_remove_event_call() */
 	trace_remove_event_call(&tp->call);
+	kfree(tp->call.print_fmt);
 }
 
 /* Make a debugfs interface for controling probe points */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 75289f3..a1834dd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -143,70 +143,65 @@ extern char *__bad_type_size(void);
 		#type, #name, offsetof(typeof(trace), name),		\
 		sizeof(trace.name), is_signed_type(type)
 
-int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
+static
+int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
 {
 	int i;
-	int ret;
-	struct syscall_metadata *entry = call->data;
-	struct syscall_trace_enter trace;
-	int offset = offsetof(struct syscall_trace_enter, args);
+	int pos = 0;
 
-	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n",
-			       SYSCALL_FIELD(int, nr));
-	if (!ret)
-		return 0;
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
 
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
 	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "\tfield:%s %s;", entry->types[i],
-				        entry->args[i]);
-		if (!ret)
-			return 0;
-		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;"
-				       "\tsigned:%u;\n", offset,
-				       sizeof(unsigned long),
-				       is_signed_type(unsigned long));
-		if (!ret)
-			return 0;
-		offset += sizeof(unsigned long);
+		pos += snprintf(buf + pos, LEN_OR_ZERO, "%s: 0x%%0%zulx%s",
+				entry->args[i], sizeof(unsigned long),
+				i == entry->nb_args - 1 ? "" : ", ");
 	}
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
 
-	trace_seq_puts(s, "\nprint fmt: \"");
 	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
-				        sizeof(unsigned long),
-					i == entry->nb_args - 1 ? "" : ", ");
-		if (!ret)
-			return 0;
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				", ((unsigned long)(REC->%s))", entry->args[i]);
 	}
-	trace_seq_putc(s, '"');
 
-	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, ", ((unsigned long)(REC->%s))",
-				       entry->args[i]);
-		if (!ret)
-			return 0;
-	}
+#undef LEN_OR_ZERO
 
-	return trace_seq_putc(s, '\n');
+	/* return the length of print_fmt */
+	return pos;
 }
 
-int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
+static int set_syscall_print_fmt(struct ftrace_event_call *call)
 {
-	int ret;
-	struct syscall_trace_exit trace;
+	char *print_fmt;
+	int len;
+	struct syscall_metadata *entry = call->data;
 
-	ret = trace_seq_printf(s,
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n"
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n",
-			       SYSCALL_FIELD(int, nr),
-			       SYSCALL_FIELD(long, ret));
-	if (!ret)
+	if (entry->enter_event != call) {
+		call->print_fmt = "\"0x%lx\", REC->ret";
 		return 0;
+	}
 
-	return trace_seq_printf(s, "\nprint fmt: \"0x%%lx\", REC->ret\n");
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_enter_print_fmt(entry, NULL, 0);
+
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_enter_print_fmt(entry, print_fmt, len + 1);
+	call->print_fmt = print_fmt;
+
+	return 0;
+}
+
+static void free_syscall_print_fmt(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	if (entry->enter_event == call)
+		kfree(call->print_fmt);
 }
 
 int syscall_enter_define_fields(struct ftrace_event_call *call)
@@ -386,12 +381,22 @@ int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 
-	id = register_ftrace_event(call->event);
-	if (!id)
-		return -ENODEV;
-	call->id = id;
-	INIT_LIST_HEAD(&call->fields);
-	return 0;
+	if (set_syscall_print_fmt(call) < 0)
+		return -ENOMEM;
+
+	id = trace_event_raw_init(call);
+
+	if (id < 0) {
+		free_syscall_print_fmt(call);
+		return id;
+	}
+
+	return id;
+}
+
+unsigned long __init arch_syscall_addr(int nr)
+{
+	return (unsigned long)sys_call_table[nr];
 }
 
 int __init init_ftrace_syscalls(void)
@@ -603,7 +608,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+				"syscall exit trace point");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ea6f6e3..f3c9c0a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -136,13 +136,14 @@ my %text_sections = (
      ".text.unlikely" => 1,
 );
 
-$objdump = "objdump" if ((length $objdump) == 0);
-$objcopy = "objcopy" if ((length $objcopy) == 0);
-$cc = "gcc" if ((length $cc) == 0);
-$ld = "ld" if ((length $ld) == 0);
-$nm = "nm" if ((length $nm) == 0);
-$rm = "rm" if ((length $rm) == 0);
-$mv = "mv" if ((length $mv) == 0);
+# Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
+$objdump = 'objdump' if (!$objdump);
+$objcopy = 'objcopy' if (!$objcopy);
+$cc = 'gcc' if (!$cc);
+$ld = 'ld' if (!$ld);
+$nm = 'nm' if (!$nm);
+$rm = 'rm' if (!$rm);
+$mv = 'mv' if (!$mv);
 
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
@@ -432,14 +433,14 @@ sub update_funcs
 
     # Loop through all the mcount caller offsets and print a reference
     # to the caller based from the ref_func.
-    for (my $i=0; $i <= $#offsets; $i++) {
-	if (!$opened) {
-	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
-	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
-	    print FILE "\t.align $alignment\n" if (defined($alignment));
-	}
-	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
+    if (!$opened) {
+	open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
+	$opened = 1;
+	print FILE "\t.section $mcount_section,\"a\",$section_type\n";
+	print FILE "\t.align $alignment\n" if (defined($alignment));
+    }
+    foreach my $cur_offset (@offsets) {
+	printf FILE "\t%s %s + %d\n", $type, $ref_func, $cur_offset - $offset;
     }
 }
 
@@ -476,11 +477,7 @@ while (<IN>) {
 	$read_headers = 0;
 
 	# Only record text sections that we know are safe
-	if (defined($text_sections{$1})) {
-	    $read_function = 1;
-	} else {
-	    $read_function = 0;
-	}
+	$read_function = defined($text_sections{$1});
 	# print out any recorded offsets
 	update_funcs();
 
@@ -514,7 +511,7 @@ while (<IN>) {
     }
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
-	$offsets[$#offsets + 1] = hex $1;
+	push(@offsets, hex $1);
     }
 }
 
