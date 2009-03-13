Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZCME3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZCME3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZCME3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:29:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZCME3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:29:24 -0400
Date: Fri, 13 Mar 2009 04:27:36 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1236401580-5758-2-git-send-email-fweisbec@gmail.com>
References: <1236401580-5758-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/ftrace: syscall tracing infrastructure, basics
Message-ID: <tip-ee08c6eccb7d1295516f7cf420fddf7b14e9146f@git.kernel.org>
Git-Commit-ID: ee08c6eccb7d1295516f7cf420fddf7b14e9146f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee08c6eccb7d1295516f7cf420fddf7b14e9146f
Gitweb:     http://git.kernel.org/tip/ee08c6eccb7d1295516f7cf420fddf7b14e9146f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 7 Mar 2009 05:52:59 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 06:25:43 +0100

tracing/ftrace: syscall tracing infrastructure, basics

Provide basic callbacks to do syscall tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1236401580-5758-2-git-send-email-fweisbec@gmail.com>
[ simplified it to a trace_printk() for now. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace.h        |   21 ++++++++
 kernel/trace/Kconfig          |   10 ++++
 kernel/trace/Makefile         |    1 +
 kernel/trace/trace.h          |    2 +
 kernel/trace/trace_syscalls.c |  113 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e1583f2..c146c10 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -503,4 +503,25 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
+/*
+ * A syscall entry in the ftrace syscalls array.
+ *
+ * @syscall_nr: syscall number
+ */
+struct syscall_trace_entry {
+	int		syscall_nr;
+};
+
+#ifdef CONFIG_FTRACE_SYSCALLS
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
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8e4a2a6..95a0ad1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -34,6 +34,9 @@ config HAVE_FTRACE_MCOUNT_RECORD
 config HAVE_HW_BRANCH_TRACER
 	bool
 
+config HAVE_FTRACE_SYSCALLS
+	bool
+
 config TRACER_MAX_TRACE
 	bool
 
@@ -175,6 +178,13 @@ config EVENT_TRACER
 	  allowing the user to pick and choose which trace point they
 	  want to trace.
 
+config FTRACE_SYSCALLS
+	bool "Trace syscalls"
+	depends on HAVE_FTRACE_SYSCALLS
+	select TRACING
+	help
+	  Basic tracer to catch the syscall entry and exit events.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	select TRACING
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c7a2943..c3feea0 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -43,5 +43,6 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACER) += trace_export.o
+obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c5e1d88..3d49daa 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -30,6 +30,8 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_HW_BRANCHES,
+	TRACE_SYSCALL_ENTER,
+	TRACE_SYSCALL_EXIT,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
new file mode 100644
index 0000000..66cf974
--- /dev/null
+++ b/kernel/trace/trace_syscalls.c
@@ -0,0 +1,113 @@
+#include <linux/ftrace.h>
+#include <linux/kernel.h>
+
+#include <asm/syscall.h>
+
+#include "trace_output.h"
+#include "trace.h"
+
+static atomic_t refcount;
+
+void start_ftrace_syscalls(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	if (atomic_inc_return(&refcount) != 1)
+		goto out;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+
+	do_each_thread(g, t) {
+		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+	} while_each_thread(g, t);
+
+	read_unlock_irqrestore(&tasklist_lock, flags);
+out:
+	atomic_dec(&refcount);
+}
+
+void stop_ftrace_syscalls(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	if (atomic_dec_return(&refcount))
+		goto out;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+
+	do_each_thread(g, t) {
+		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+	} while_each_thread(g, t);
+
+	read_unlock_irqrestore(&tasklist_lock, flags);
+out:
+	atomic_inc(&refcount);
+}
+
+void ftrace_syscall_enter(struct pt_regs *regs)
+{
+	int syscall_nr;
+
+	syscall_nr = syscall_get_nr(current, regs);
+
+	trace_printk("syscall %d enter\n", syscall_nr);
+}
+
+void ftrace_syscall_exit(struct pt_regs *regs)
+{
+	int syscall_nr;
+
+	syscall_nr = syscall_get_nr(current, regs);
+
+	trace_printk("syscall %d exit\n", syscall_nr);
+}
+
+static int init_syscall_tracer(struct trace_array *tr)
+{
+	start_ftrace_syscalls();
+
+	return 0;
+}
+
+static void reset_syscall_tracer(struct trace_array *tr)
+{
+	stop_ftrace_syscalls();
+}
+
+static struct trace_event syscall_enter_event = {
+	.type		= TRACE_SYSCALL_ENTER,
+};
+
+static struct trace_event syscall_exit_event = {
+	.type		= TRACE_SYSCALL_EXIT,
+};
+
+static struct tracer syscall_tracer __read_mostly = {
+	.name		= "syscall",
+	.init		= init_syscall_tracer,
+	.reset		= reset_syscall_tracer
+};
+
+__init int register_ftrace_syscalls(void)
+{
+	int ret;
+
+	ret = register_ftrace_event(&syscall_enter_event);
+	if (!ret) {
+		printk(KERN_WARNING "event %d failed to register\n",
+		       syscall_enter_event.type);
+		WARN_ON_ONCE(1);
+	}
+
+	ret = register_ftrace_event(&syscall_exit_event);
+	if (!ret) {
+		printk(KERN_WARNING "event %d failed to register\n",
+		       syscall_exit_event.type);
+		WARN_ON_ONCE(1);
+	}
+
+	return register_tracer(&syscall_tracer);
+}
+device_initcall(register_ftrace_syscalls);
