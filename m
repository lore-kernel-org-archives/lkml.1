Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbZFLV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbZFLV0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbZFLV0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:26:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123AbZFLV0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:26:11 -0400
Date: Fri, 12 Jun 2009 17:25:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <1ede6fc830c7d3419353e42a725566b08651adac.1244837725.git.jbaron@redhat.com>
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com>
Subject: [PATCH 7/7] add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Layer Frederic's syscall tracer on tracepoints. We create trace events via
hooking into the SYCALL_DEFINE macros. This allows us to individually toggle
syscall entry and exit points on/off.



Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/linux/syscalls.h      |   63 +++++++++++++++
 include/trace/syscall.h       |   19 ++---
 kernel/trace/trace_syscalls.c |  172 +++++++++++++++++++----------------------
 3 files changed, 153 insertions(+), 101 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 79faae9..17dc567 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -64,6 +64,7 @@ struct perf_counter_hw_event;
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
+#include <linux/unistd.h>
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
@@ -121,6 +122,68 @@ struct perf_counter_hw_event;
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
+	};							\
+	static struct ftrace_event_call event_enter_##sname;	\
+	static int init_enter_##sname(void)			\
+	{							\
+		int num;					\
+		num = syscall_name_to_nr("sys"#sname);		\
+		if (num < 0)					\
+			return -ENOSYS;				\
+		register_ftrace_event(&event_syscall_enter);	\
+		INIT_LIST_HEAD(&event_enter_##sname.fields);	\
+		init_preds(&event_enter_##sname);		\
+		return 0;					\
+	}							\
+	static int reg_enter_##sname(void)			\
+	{							\
+		return reg_event_syscall_enter("sys"#sname);	\
+	}							\
+	static void unreg_enter_##sname(void)			\
+	{							\
+		unreg_event_syscall_enter("sys"#sname);		\
+	}							\
+	static struct ftrace_event_call __used			\
+	  __attribute__((__aligned__(4)))			\
+	  __attribute__((section("_ftrace_events")))		\
+	  event_enter_##sname = {				\
+		.name                   = "sys_enter"#sname,	\
+		.system                 = "syscalls",		\
+		.event                  = &event_syscall_enter,	\
+		.raw_init		= init_enter_##sname,	\
+		.regfunc		= reg_enter_##sname,	\
+		.unregfunc		= unreg_enter_##sname,	\
+	};							\
+	static struct ftrace_event_call event_exit_##sname;	\
+	static int init_exit_##sname(void)			\
+	{							\
+		int num;					\
+		num = syscall_name_to_nr("sys"#sname);		\
+		if (num < 0)					\
+			return -ENOSYS;				\
+		register_ftrace_event(&event_syscall_exit);	\
+		INIT_LIST_HEAD(&event_exit_##sname.fields);	\
+		init_preds(&event_exit_##sname);		\
+		return 0;					\
+	}							\
+	static int reg_exit_##sname(void)			\
+	{							\
+		return reg_event_syscall_exit("sys"#sname);	\
+	}							\
+	static void unreg_exit_##sname(void)			\
+	{							\
+		unreg_event_syscall_exit("sys"#sname);		\
+	}							\
+	static struct ftrace_event_call __used			\
+	  __attribute__((__aligned__(4)))			\
+	  __attribute__((section("_ftrace_events")))		\
+	  event_exit_##sname = {				\
+		.name                   = "sys_exit"#sname,	\
+		.system                 = "syscalls",		\
+		.event                  = &event_syscall_exit,	\
+		.raw_init		= init_exit_##sname,	\
+		.regfunc		= reg_exit_##sname,	\
+		.unregfunc		= unreg_exit_##sname,	\
 	}
 
 #define SYSCALL_DEFINE0(sname)					\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index d5d8310..461f7dd 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -3,6 +3,8 @@
 
 #include <asm/ptrace.h>
 #include <linux/tracepoint.h>
+#include <linux/unistd.h>
+#include <linux/ftrace_event.h>
 
 extern void syscall_regfunc(void);
 extern void syscall_unregfunc(void);
@@ -37,17 +39,14 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern void arch_init_ftrace_syscalls(void);
 extern struct syscall_metadata *syscall_nr_to_meta(int nr);
-extern void start_ftrace_syscalls(void);
-extern void stop_ftrace_syscalls(void);
-extern void ftrace_syscall_enter(struct pt_regs *regs);
-extern void ftrace_syscall_exit(struct pt_regs *regs);
-#else
-static inline void start_ftrace_syscalls(void)			{ }
-static inline void stop_ftrace_syscalls(void)			{ }
-static inline void ftrace_syscall_enter(struct pt_regs *regs)	{ }
-static inline void ftrace_syscall_exit(struct pt_regs *regs)	{ }
+extern int syscall_name_to_nr(char *name);
+extern struct trace_event event_syscall_enter;
+extern struct trace_event event_syscall_exit;
+extern int reg_event_syscall_enter(char *name);
+extern void unreg_event_syscall_enter(char *name);
+extern int reg_event_syscall_exit(char *name);
+extern void unreg_event_syscall_exit(char *name);
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e57964..a7a3962 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,15 +1,16 @@
 #include <trace/syscall.h>
 #include <linux/kernel.h>
+#include <linux/ftrace.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
 #include "trace.h"
 
-/* Keep a counter of the syscall tracing users */
-static int refcount;
-
-/* Prevent from races on thread flags toggling */
 static DEFINE_MUTEX(syscall_trace_lock);
+int sys_refcount_enter;
+int sys_refcount_exit;
+static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX + 1);
+static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX + 1);
 
 /* Option to display the parameters types */
 enum {
@@ -95,54 +96,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-void start_ftrace_syscalls(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&syscall_trace_lock);
-
-	/* Don't enable the flag on the tasks twice */
-	if (++refcount != 1)
-		goto unlock;
-
-	arch_init_ftrace_syscalls();
-	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, t) {
-		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
-
-unlock:
-	mutex_unlock(&syscall_trace_lock);
-}
-
-void stop_ftrace_syscalls(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&syscall_trace_lock);
-
-	/* There are perhaps still some users */
-	if (--refcount)
-		goto unlock;
-
-	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, t) {
-		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
-
-unlock:
-	mutex_unlock(&syscall_trace_lock);
-}
-
-void ftrace_syscall_enter(struct pt_regs *regs)
+void ftrace_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
@@ -151,6 +105,8 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_enter_syscalls))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -171,7 +127,7 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 	trace_wake_up();
 }
 
-void ftrace_syscall_exit(struct pt_regs *regs)
+void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
@@ -179,6 +135,8 @@ void ftrace_syscall_exit(struct pt_regs *regs)
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_exit_syscalls))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -197,54 +155,86 @@ void ftrace_syscall_exit(struct pt_regs *regs)
 	trace_wake_up();
 }
 
-static int init_syscall_tracer(struct trace_array *tr)
+int reg_event_syscall_enter(char *name)
 {
-	start_ftrace_syscalls();
+	int ret = 0;
+	int num;
 
-	return 0;
+	num = syscall_name_to_nr(name);
+	if (num < 0)
+		return -ENOSYS;
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_refcount_enter)
+		ret = register_trace_syscall_enter(ftrace_syscall_enter);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_enter_syscalls);
+		sys_refcount_enter++;
+	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
 }
 
-static void reset_syscall_tracer(struct trace_array *tr)
+void unreg_event_syscall_enter(char *name)
 {
-	stop_ftrace_syscalls();
-	tracing_reset_online_cpus(tr);
-}
-
-static struct trace_event syscall_enter_event = {
-	.type	 	= TRACE_SYSCALL_ENTER,
-	.trace		= print_syscall_enter,
-};
-
-static struct trace_event syscall_exit_event = {
-	.type	 	= TRACE_SYSCALL_EXIT,
-	.trace		= print_syscall_exit,
-};
+	int num;
 
-static struct tracer syscall_tracer __read_mostly = {
-	.name	     	= "syscall",
-	.init		= init_syscall_tracer,
-	.reset		= reset_syscall_tracer,
-	.flags		= &syscalls_flags,
-};
+	num = syscall_name_to_nr(name);
+	if (num < 0)
+		return;
+	mutex_lock(&syscall_trace_lock);
+	sys_refcount_enter--;
+	clear_bit(num, enabled_enter_syscalls);
+	if (!sys_refcount_enter)
+		unregister_trace_syscall_enter(ftrace_syscall_enter);
+	mutex_unlock(&syscall_trace_lock);
+}
 
-__init int register_ftrace_syscalls(void)
+int reg_event_syscall_exit(char *name)
 {
-	int ret;
+	int ret = 0;
+	int num;
 
-	ret = register_ftrace_event(&syscall_enter_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_enter_event.type);
-		WARN_ON_ONCE(1);
+	num = syscall_name_to_nr(name);
+	if (num < 0)
+		return -ENOSYS;
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_refcount_exit)
+		ret = register_trace_syscall_exit(ftrace_syscall_exit);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall exit trace point");
+	} else {
+		set_bit(num, enabled_exit_syscalls);
+		sys_refcount_exit++;
 	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
 
-	ret = register_ftrace_event(&syscall_exit_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_exit_event.type);
-		WARN_ON_ONCE(1);
-	}
+void unreg_event_syscall_exit(char *name)
+{
+	int num;
 
-	return register_tracer(&syscall_tracer);
+	num = syscall_name_to_nr(name);
+	if (num < 0)
+		return;
+	mutex_lock(&syscall_trace_lock);
+	sys_refcount_exit--;
+	clear_bit(num, enabled_exit_syscalls);
+	if (!sys_refcount_exit)
+		unregister_trace_syscall_exit(ftrace_syscall_exit);
+	mutex_unlock(&syscall_trace_lock);
 }
-device_initcall(register_ftrace_syscalls);
+
+struct trace_event event_syscall_enter = {
+	.trace			= print_syscall_enter,
+	.type			= TRACE_SYSCALL_ENTER
+};
+
+struct trace_event event_syscall_exit = {
+	.trace			= print_syscall_exit,
+	.type			= TRACE_SYSCALL_EXIT
+};
-- 
1.6.0.6

