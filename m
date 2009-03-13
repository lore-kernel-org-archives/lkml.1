Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZCMQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZCMQKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbZCMQKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:10:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:41483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZCMQKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:10:17 -0400
Date: Fri, 13 Mar 2009 16:09:35 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: core infrastructure for syscalls tracing, enhancements
Message-ID: <tip-bed1ffca022cc876fb83161d26670e9b5d3cf36b@git.kernel.org>
Git-Commit-ID: bed1ffca022cc876fb83161d26670e9b5d3cf36b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 16:09:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bed1ffca022cc876fb83161d26670e9b5d3cf36b
Gitweb:     http://git.kernel.org/tip/bed1ffca022cc876fb83161d26670e9b5d3cf36b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 13 Mar 2009 15:42:11 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 16:57:42 +0100

tracing/syscalls: core infrastructure for syscalls tracing, enhancements

Impact: new feature

This adds the generic support for syscalls tracing. This is
currently exploited through a devoted tracer but other tracing
engines can use it. (They just have to play with
{start,stop}_ftrace_syscalls() and use the display callbacks
unless they want to override them.)

The syscalls prototypes definitions are abused here to steal
some metadata informations:

- syscall name, param types, param names, number of params

The syscall addr is not directly saved during this definition
because we don't know if its prototype is available in the
namespace. But we don't really need it. The arch has just to
build a function able to resolve the syscall number to its
metadata struct.

The current tracer prints the syscall names, parameters names
and values (and their types optionally). Currently the value is
a raw hex but higher level values diplaying is on my TODO list.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/asm-generic/vmlinux.lds.h |   11 +++-
 include/linux/ftrace.h            |   14 +++-
 include/linux/syscalls.h          |   60 +++++++++++++++-
 kernel/trace/trace.h              |   17 ++++
 kernel/trace/trace_syscalls.c     |  146 +++++++++++++++++++++++++++++++++++--
 5 files changed, 234 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 0e0f39b..d3bc3c8 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -77,6 +77,14 @@
 #define TRACE_PRINTKS()
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
+			 *(__syscalls_metadata)				\
+			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
+#else
+#define TRACE_SYSCALLS()
+#endif
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -99,7 +107,8 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
-	FTRACE_EVENTS()
+	FTRACE_EVENTS()							\
+	TRACE_SYSCALLS()
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index c146c10..6dc1c65 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -506,13 +506,21 @@ static inline void trace_hw_branch_oops(void) {}
 /*
  * A syscall entry in the ftrace syscalls array.
  *
- * @syscall_nr: syscall number
+ * @name: name of the syscall
+ * @nb_args: number of parameters it takes
+ * @types: list of types as strings
+ * @args: list of args as strings (args[i] matches types[i])
  */
-struct syscall_trace_entry {
-	int		syscall_nr;
+struct syscall_metadata {
+	const char	*name;
+	int		nb_args;
+	const char	**types;
+	const char	**args;
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
+extern void arch_init_ftrace_syscalls(void);
+extern struct syscall_metadata *syscall_nr_to_meta(int nr);
 extern void start_ftrace_syscalls(void);
 extern void stop_ftrace_syscalls(void);
 extern void ftrace_syscall_enter(struct pt_regs *regs);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f9f900c..0cff9bb 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,7 @@ struct old_linux_dirent;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
+#include <linux/ftrace.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
@@ -95,7 +96,46 @@ struct old_linux_dirent;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define __SC_STR_ADECL1(t, a)		#a
+#define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
+#define __SC_STR_ADECL3(t, a, ...)	#a, __SC_STR_ADECL2(__VA_ARGS__)
+#define __SC_STR_ADECL4(t, a, ...)	#a, __SC_STR_ADECL3(__VA_ARGS__)
+#define __SC_STR_ADECL5(t, a, ...)	#a, __SC_STR_ADECL4(__VA_ARGS__)
+#define __SC_STR_ADECL6(t, a, ...)	#a, __SC_STR_ADECL5(__VA_ARGS__)
+
+#define __SC_STR_TDECL1(t, a)		#t
+#define __SC_STR_TDECL2(t, a, ...)	#t, __SC_STR_TDECL1(__VA_ARGS__)
+#define __SC_STR_TDECL3(t, a, ...)	#t, __SC_STR_TDECL2(__VA_ARGS__)
+#define __SC_STR_TDECL4(t, a, ...)	#t, __SC_STR_TDECL3(__VA_ARGS__)
+#define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
+#define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
+
+#define SYSCALL_METADATA(sname, nb)				\
+	static const struct syscall_metadata __used		\
+	  __attribute__((__aligned__(4)))			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	  __syscall_meta_##sname = {				\
+		.name 		= "sys"#sname,			\
+		.nb_args 	= nb,				\
+		.types		= types_##sname,		\
+		.args		= args_##sname,			\
+	}
+
+#define SYSCALL_DEFINE0(sname)					\
+	static const struct syscall_metadata __used		\
+	  __attribute__((__aligned__(4)))			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	  __syscall_meta_##sname = {				\
+		.name 		= "sys_"#sname,			\
+		.nb_args 	= 0,				\
+	};							\
+	asmlinkage long sys_##sname(void)
+
+#else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
+#endif
+
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
@@ -117,10 +157,26 @@ struct old_linux_dirent;
 #endif
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define SYSCALL_DEFINEx(x, sname, ...)				\
+	static const char *types_##sname[] = {			\
+		__SC_STR_TDECL##x(__VA_ARGS__)			\
+	};							\
+	static const char *args_##sname[] = {			\
+		__SC_STR_ADECL##x(__VA_ARGS__)			\
+	};							\
+	SYSCALL_METADATA(sname, x);				\
+	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+#else
+#define SYSCALL_DEFINEx(x, sname, ...)				\
+	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+#endif
+
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
-#define SYSCALL_DEFINEx(x, name, ...)					\
+
+#define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
 	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
 	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
@@ -134,7 +190,7 @@ struct old_linux_dirent;
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
-#define SYSCALL_DEFINEx(x, name, ...)					\
+#define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3d49daa..d80ca0d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -194,6 +194,19 @@ struct kmemtrace_free_entry {
 	const void *ptr;
 };
 
+struct syscall_trace_enter {
+	struct trace_entry	ent;
+	int			nr;
+	unsigned long		args[];
+};
+
+struct syscall_trace_exit {
+	struct trace_entry	ent;
+	int			nr;
+	unsigned long		ret;
+};
+
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -306,6 +319,10 @@ extern void __ftrace_bad_type(void);
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
 			  TRACE_KMEM_FREE);	\
+		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
+			  TRACE_SYSCALL_ENTER);				\
+		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
+			  TRACE_SYSCALL_EXIT);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 66cf974..c72e599 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,6 +1,5 @@
-#include <linux/ftrace.h>
 #include <linux/kernel.h>
-
+#include <linux/ftrace.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
@@ -8,6 +7,90 @@
 
 static atomic_t refcount;
 
+/* Our two options */
+enum {
+	TRACE_SYSCALLS_OPT_TYPES = 0x1,
+};
+
+static struct tracer_opt syscalls_opts[] = {
+	{ TRACER_OPT(syscall_arg_type, TRACE_SYSCALLS_OPT_TYPES) },
+	{ }
+};
+
+static struct tracer_flags syscalls_flags = {
+	.val = 0, /* By default: no args types */
+	.opts = syscalls_opts
+};
+
+enum print_line_t
+print_syscall_enter(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *ent = iter->ent;
+	struct syscall_trace_enter *trace;
+	struct syscall_metadata *entry;
+	int i, ret, syscall;
+
+	trace_assign_type(trace, ent);
+
+	syscall = trace->nr;
+
+	entry = syscall_nr_to_meta(syscall);
+	if (!entry)
+		goto end;
+
+	ret = trace_seq_printf(s, "%s(", entry->name);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	for (i = 0; i < entry->nb_args; i++) {
+		/* parameter types */
+		if (syscalls_flags.val & TRACE_SYSCALLS_OPT_TYPES) {
+			ret = trace_seq_printf(s, "%s ", entry->types[i]);
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+		/* parameter values */
+		ret = trace_seq_printf(s, "%s: %lx%s ", entry->args[i],
+				       trace->args[i],
+				       i == entry->nb_args - 1 ? ")" : ",");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+end:
+	trace_seq_printf(s, "\n");
+	return TRACE_TYPE_HANDLED;
+}
+
+enum print_line_t
+print_syscall_exit(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *ent = iter->ent;
+	struct syscall_trace_exit *trace;
+	int syscall;
+	struct syscall_metadata *entry;
+	int ret;
+
+	trace_assign_type(trace, ent);
+
+	syscall = trace->nr;
+
+	entry = syscall_nr_to_meta(syscall);
+	if (!entry) {
+		trace_seq_printf(s, "\n");
+		return TRACE_TYPE_HANDLED;
+	}
+
+	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
+				trace->ret);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
 void start_ftrace_syscalls(void)
 {
 	unsigned long flags;
@@ -16,6 +99,7 @@ void start_ftrace_syscalls(void)
 	if (atomic_inc_return(&refcount) != 1)
 		goto out;
 
+	arch_init_ftrace_syscalls();
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, t) {
@@ -48,20 +132,63 @@ out:
 
 void ftrace_syscall_enter(struct pt_regs *regs)
 {
+	struct syscall_trace_enter *entry;
+	struct syscall_metadata *sys_data;
+	struct ring_buffer_event *event;
+	int size;
 	int syscall_nr;
+	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 
-	trace_printk("syscall %d enter\n", syscall_nr);
+	cpu = raw_smp_processor_id();
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
+
+	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size,
+							0, 0);
+	if (!event)
+		return;
+
+	entry = ring_buffer_event_data(event);
+	entry->nr = syscall_nr;
+	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
+
+	trace_current_buffer_unlock_commit(event, 0, 0);
+	trace_wake_up();
 }
 
 void ftrace_syscall_exit(struct pt_regs *regs)
 {
+	struct syscall_trace_exit *entry;
+	struct syscall_metadata *sys_data;
+	struct ring_buffer_event *event;
 	int syscall_nr;
+	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 
-	trace_printk("syscall %d exit\n", syscall_nr);
+	cpu = raw_smp_processor_id();
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_EXIT,
+				sizeof(*entry), 0, 0);
+	if (!event)
+		return;
+
+	entry = ring_buffer_event_data(event);
+	entry->nr = syscall_nr;
+	entry->ret = syscall_get_return_value(current, regs);
+
+	trace_current_buffer_unlock_commit(event, 0, 0);
+	trace_wake_up();
 }
 
 static int init_syscall_tracer(struct trace_array *tr)
@@ -77,17 +204,20 @@ static void reset_syscall_tracer(struct trace_array *tr)
 }
 
 static struct trace_event syscall_enter_event = {
-	.type		= TRACE_SYSCALL_ENTER,
+	.type	 	= TRACE_SYSCALL_ENTER,
+	.trace		= print_syscall_enter,
 };
 
 static struct trace_event syscall_exit_event = {
-	.type		= TRACE_SYSCALL_EXIT,
+	.type	 	= TRACE_SYSCALL_EXIT,
+	.trace		= print_syscall_exit,
 };
 
 static struct tracer syscall_tracer __read_mostly = {
-	.name		= "syscall",
+	.name	     	= "syscall",
 	.init		= init_syscall_tracer,
-	.reset		= reset_syscall_tracer
+	.reset		= reset_syscall_tracer,
+	.flags		= &syscalls_flags,
 };
 
 __init int register_ftrace_syscalls(void)
