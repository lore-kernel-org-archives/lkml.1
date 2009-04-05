Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZDEOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZDEOzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZDEOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:55:21 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:47052 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752604AbZDEOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:55:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=elastic.org;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
	b=dxDyGQqXOaB7PQRbqvH57L9L8YicF8/5Y737+xmgj1AYPAUQdIROFJ0TPREBrVJsiUk38NMS9wKv1bTfkG5wa5g8yGMRXGRsl/5+idn3iDJCZ9LPZs0O0gY2X8+0BBJJ;
From: "Frank Ch. Eigler" <fche@elastic.org>
To: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Cc: systemtap@sources.redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       mingo@elte.hu, "Frank Ch. Eigler" <fche@elastic.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH 2/2] utrace-based ftrace "process" engine, v3
Date: Sun,  5 Apr 2009 10:17:54 -0400
Message-Id: <1238941074-27424-3-git-send-email-fche@elastic.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238941074-27424-2-git-send-email-fche@elastic.org>
References: <1238941074-27424-1-git-send-email-fche@elastic.org>
 <1238941074-27424-2-git-send-email-fche@elastic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the v3 utrace-ftrace interface.  based on Roland McGrath's
utrace API, which provides programmatic hooks to the in-tree tracehook
layer.  This patch interfaces those events to ftrace, as configured by
a small number of debugfs controls, and includes system-call
pretty-printing using code from the ftrace syscall prototype by
Frederic Weisbecker.  Here's the
/debugfs/tracing/process_trace_README:

    process event tracer mini-HOWTO

    1. Select process hierarchy to monitor.  Other processes will be
       completely unaffected.  Leave at 0 for system-wide tracing.
    %  echo NNN > process_follow_pid

    2. Determine which process event traces are potentially desired.
       syscall and signal tracing slow down monitored processes.
    %  echo 0 > process_trace_{syscalls,signals,lifecycle}

    3. Add any final uid- or taskcomm-based filtering.  Non-matching
       processes will skip trace messages, but will still be slowed.
    %  echo NNN > process_trace_uid_filter # -1: unrestricted
    %  echo ls > process_trace_taskcomm_filter # empty: unrestricted

    4. Start tracing.
    %  echo process > current_tracer

    5. Examine trace.
    %  cat trace

    6. Stop tracing.
    %  echo nop > current_tracer

Signed-off-by: Frank Ch. Eigler <fche@redhat.com>
---
 include/linux/processtrace.h |   51 ++++
 kernel/trace/Kconfig         |    8 +
 kernel/trace/Makefile        |    1 +
 kernel/trace/trace.h         |    9 +
 kernel/trace/trace_process.c |  642 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 711 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/processtrace.h
 create mode 100644 kernel/trace/trace_process.c

diff --git a/include/linux/processtrace.h b/include/linux/processtrace.h
new file mode 100644
index 0000000..74d031e
--- /dev/null
+++ b/include/linux/processtrace.h
@@ -0,0 +1,51 @@
+#ifndef PROCESSTRACE_H
+#define PROCESSTRACE_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct process_trace_entry {
+	unsigned char opcode;	/* one of _UTRACE_EVENT_* */
+	union {
+		struct {
+			pid_t child;
+			unsigned long flags;
+		} trace_clone;
+		struct {
+			int type;
+                        int notify;
+		} trace_jctl;
+		struct {
+			long code;
+		} trace_exit;
+		struct {
+                        /* Selected fields from linux_binprm */
+                        int argc;
+                        /* We need to copy the file name, because by
+                           the time we format the trace record for
+                           display, the task may be gone. */
+#define PROCESS_TRACE_FILENAME_LENGTH 64
+                        char filename[PROCESS_TRACE_FILENAME_LENGTH];
+		} trace_exec;
+		struct {
+			int si_signo;
+			int si_errno;
+			int si_code;
+		} trace_signal;
+		struct {
+			long callno;
+			unsigned long args[6];
+		} trace_syscall_entry;
+		struct {
+			long rc;
+			long error;
+		} trace_syscall_exit;
+	};
+};
+
+/* in kernel/trace/trace_process.c */
+
+extern void enable_process_trace(void);
+extern void disable_process_trace(void);
+
+#endif /* PROCESSTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b0a46f8..226cb60 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -186,6 +186,14 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
+config PROCESS_TRACER
+	bool "Trace process events via utrace"
+	select TRACING
+	select UTRACE
+	help
+	  This tracer records process events that may be hooked by utrace:
+	  thread lifecycle, system calls, signals, and job control.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	select TRACING
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c3feea0..880080a 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -44,5 +44,6 @@ obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
+obj-$(CONFIG_PROCESS_TRACER) += trace_process.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f561628..c27d2ba 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -8,6 +8,7 @@
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
+#include <linux/processtrace.h>
 #include <trace/boot.h>
 #include <trace/kmemtrace.h>
 #include <trace/power.h>
@@ -37,6 +38,7 @@ enum trace_type {
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
 	TRACE_BLK,
+	TRACE_PROCESS,
 
 	__TRACE_LAST_TYPE,
 };
@@ -214,6 +216,12 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
+struct trace_process {
+	struct trace_entry		ent;
+	struct process_trace_entry	event;
+};
+
+
 
 /*
  * trace_flag_type is an enumeration that holds different
@@ -332,6 +340,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_SYSCALL_ENTER);				\
 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
 			  TRACE_SYSCALL_EXIT);				\
+		IF_ASSIGN(var, ent, struct trace_process, TRACE_PROCESS); \
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_process.c b/kernel/trace/trace_process.c
new file mode 100644
index 0000000..b98ab28
--- /dev/null
+++ b/kernel/trace/trace_process.c
@@ -0,0 +1,642 @@
+/*
+ * utrace-based process event tracing
+ * Copyright (C) 2009 Red Hat Inc.
+ * By Frank Ch. Eigler <fche@redhat.com>
+ *
+ * Based on mmio ftrace engine by Pekka Paalanen
+ * and utrace-syscall-tracing prototype by Ananth Mavinakayanahalli
+ * and ftrace-syscall prototype by Frederic Weisbecker <fweisbec@gmail.com>
+ */
+
+/* #define DEBUG 1 */
+
+#include <linux/kernel.h>
+#include <linux/utrace.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <asm/syscall.h>
+#include <linux/binfmts.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+/* A process must match these filters in order to be traced. */
+static char trace_taskcomm_filter[TASK_COMM_LEN]; /* \0: unrestricted */
+static u32 trace_taskuid_filter = -1; /* -1: unrestricted */
+static u32 trace_lifecycle_p = 1;
+static u32 trace_syscalls_p = 1;
+static u32 trace_signals_p = 1;
+
+/* A process must be a direct child of given pid in order to be
+   followed. */
+static u32 process_follow_pid; /* 0: unrestricted/systemwide */
+
+/* XXX: lock the above? */
+
+
+/* trace data collection */
+
+static struct trace_array *process_trace_array;
+
+static void process_reset_data(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	tracing_reset_online_cpus(tr);
+}
+
+static int process_trace_init(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	process_trace_array = tr;
+	process_reset_data(tr);
+	enable_process_trace();
+	return 0;
+}
+
+static void process_trace_reset(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	disable_process_trace();
+	process_reset_data(tr);
+	process_trace_array = NULL;
+}
+
+static void process_trace_start(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	process_reset_data(tr);
+}
+
+static void __trace_processtrace(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct process_trace_entry *ent)
+{
+	struct ring_buffer_event *event;
+	struct trace_process *entry;
+
+	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
+	entry->ent.type			= TRACE_PROCESS;
+	entry->event			= *ent;
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+	trace_wake_up();
+}
+
+void process_trace(struct process_trace_entry *ent)
+{
+	struct trace_array *tr = process_trace_array;
+	struct trace_array_cpu *data;
+
+	preempt_disable();
+	data = tr->data[smp_processor_id()];
+	__trace_processtrace(tr, data, ent);
+	preempt_enable();
+}
+
+
+/* trace data rendering */
+
+static void process_pipe_open(struct trace_iterator *iter)
+{
+	pr_debug("in %s\n", __func__);
+}
+
+static void process_close(struct trace_iterator *iter)
+{
+	iter->private = NULL;
+}
+
+static ssize_t process_read(struct trace_iterator *iter, struct file *filp,
+				char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	ssize_t ret;
+	struct trace_seq *s = &iter->seq;
+	ret = trace_seq_to_user(s, ubuf, cnt);
+	return (ret == -EBUSY) ? 0 : ret;
+}
+
+static enum print_line_t process_print(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_process *field;
+        struct process_trace_entry *pte;
+	struct trace_seq *s	= &iter->seq;
+	int ret = 1;
+	struct syscall_metadata *syscall;
+        int i;
+
+	trace_assign_type(field, entry);
+        pte = &field->event;
+
+	if (!trace_print_context(iter))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	switch (pte->opcode) {
+	case _UTRACE_EVENT_CLONE:
+		ret = trace_seq_printf(s, "fork %d flags 0x%lx\n",
+				       pte->trace_clone.child,
+				       pte->trace_clone.flags);
+		break;
+	case _UTRACE_EVENT_EXEC:
+		ret = trace_seq_printf(s, "exec '%s' (args %d)\n",
+                                       pte->trace_exec.filename,
+                                       pte->trace_exec.argc);
+		break;
+	case _UTRACE_EVENT_EXIT:
+		ret = trace_seq_printf(s, "exit %ld\n",
+				       pte->trace_exit.code);
+		break;
+	case _UTRACE_EVENT_JCTL:
+		ret = trace_seq_printf(s, "jctl %d %d\n",
+				       pte->trace_jctl.type,
+                                       pte->trace_jctl.notify);
+		break;
+	case _UTRACE_EVENT_SIGNAL:
+		ret = trace_seq_printf(s, "signal %d errno %d code 0x%x\n",
+				       pte->trace_signal.si_signo,
+				       pte->trace_signal.si_errno,
+				       pte->trace_signal.si_code);
+		break;
+	case _UTRACE_EVENT_SYSCALL_ENTRY:
+                syscall = syscall_nr_to_meta (pte->trace_syscall_entry.callno);
+                if (!syscall) {
+                        /* Metadata is incomplete.  Simply hex dump. */
+                        ret = trace_seq_printf(s, "syscall %ld [0x%lx 0x%lx"
+                                               " 0x%lx 0x%lx 0x%lx 0x%lx]\n",
+                                               pte->trace_syscall_entry.callno,
+                                               pte->trace_syscall_entry.args[0],
+                                               pte->trace_syscall_entry.args[1],
+                                               pte->trace_syscall_entry.args[2],
+                                               pte->trace_syscall_entry.args[3],
+                                               pte->trace_syscall_entry.args[4],
+                                               pte->trace_syscall_entry.args[5]);
+                        break;
+                }
+                ret = trace_seq_printf(s, "%s(", syscall->name);
+                if (!ret)
+                        break;
+                for (i = 0; i < syscall->nb_args; i++) {
+                        ret = trace_seq_printf(s, "%s: 0x%lx%s", syscall->args[i],
+                                               pte->trace_syscall_entry.args[i],
+                                               i == syscall->nb_args - 1 ? ")\n" : ", ");
+                        if (!ret)
+                                break;
+                }
+		break;
+	case _UTRACE_EVENT_SYSCALL_EXIT:
+                /* utrace doesn't preserve the syscall number. */
+                ret = trace_seq_printf(s, "syscall rc %ld error %ld\n",
+                                       pte->trace_syscall_exit.rc,
+                                       pte->trace_syscall_exit.error);
+                break;
+	default:
+		ret = trace_seq_printf(s, "process event code %d?\n",
+				       pte->opcode);
+		break;
+	}
+        if (!ret)
+        	return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+
+static enum print_line_t process_print_line(struct trace_iterator *iter)
+{
+	switch (iter->ent->type) {
+	case TRACE_PROCESS:
+		return process_print(iter);
+	default:
+		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
+	}
+}
+
+static struct tracer process_tracer = {
+	.name		= "process",
+	.init		= process_trace_init,
+	.reset		= process_trace_reset,
+	.start		= process_trace_start,
+	.pipe_open	= process_pipe_open,
+	.close		= process_close,
+	.read		= process_read,
+	.print_line	= process_print_line,
+};
+
+
+
+/* utrace backend */
+
+/* Should tracing apply to given task?	Compare against filter
+   values. */
+static int trace_test(struct task_struct *tsk)
+{
+	if (trace_taskcomm_filter[0]
+	    && strncmp(trace_taskcomm_filter, tsk->comm, TASK_COMM_LEN))
+		return 0;
+
+	if (trace_taskuid_filter != (u32)-1
+	    && trace_taskuid_filter != task_uid(tsk))
+		return 0;
+
+	return 1;
+}
+
+
+static const struct utrace_engine_ops process_trace_ops;
+
+static void process_trace_tryattach(struct task_struct *tsk)
+{
+	struct utrace_engine *engine;
+
+	pr_debug("in %s\n", __func__);
+        tracing_record_cmdline (tsk);
+	engine = utrace_attach_task(tsk,
+				    UTRACE_ATTACH_CREATE |
+				    UTRACE_ATTACH_EXCLUSIVE,
+				    &process_trace_ops, NULL);
+	if (IS_ERR(engine) || (engine == NULL)) {
+		pr_warning("utrace_attach_task %d (rc %p)\n",
+			   tsk->pid, engine);
+	} else {
+		int rc;
+
+		/* We always hook cost-free events. */
+		unsigned long events =
+			UTRACE_EVENT(CLONE) |
+			UTRACE_EVENT(EXEC) |
+			UTRACE_EVENT(JCTL) |
+			UTRACE_EVENT(EXIT);
+
+		/* Penalizing events are individually controlled, so that
+		   utrace doesn't even take the monitored threads off their
+		   fast paths, nor bother call our callbacks. */
+		if (trace_syscalls_p)
+			events |= UTRACE_EVENT_SYSCALL;
+		if (trace_signals_p)
+			events |= UTRACE_EVENT_SIGNAL_ALL;
+
+		rc = utrace_set_events(tsk, engine, events);
+		if (rc == -EINPROGRESS)
+			rc = utrace_barrier(tsk, engine);
+		if (rc)
+			pr_warning("utrace_set_events/barrier rc %d\n", rc);
+
+		utrace_engine_put(engine);
+		pr_debug("attached in %s to %s(%d)\n", __func__,
+			 tsk->comm, tsk->pid);
+	}
+}
+
+
+u32 process_trace_report_clone(enum utrace_resume_action action,
+			       struct utrace_engine *engine,
+			       struct task_struct *parent,
+			       unsigned long clone_flags,
+			       struct task_struct *child)
+{
+	if (trace_lifecycle_p && trace_test(parent)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_CLONE;
+		ent.trace_clone.child = child->pid;
+		ent.trace_clone.flags = clone_flags;
+		process_trace(&ent);
+	}
+
+	process_trace_tryattach(child);
+
+	return UTRACE_RESUME;
+}
+
+
+u32 process_trace_report_jctl(enum utrace_resume_action action,
+                              struct utrace_engine *engine,
+                              struct task_struct *task,
+                              int type, int notify)
+{
+        struct process_trace_entry ent;
+        ent.opcode = _UTRACE_EVENT_JCTL;
+        ent.trace_jctl.type = type;
+        ent.trace_jctl.notify = notify;
+        process_trace(&ent);
+
+	return UTRACE_RESUME;
+}
+
+
+u32 process_trace_report_syscall_entry(u32 action,
+				       struct utrace_engine *engine,
+				       struct task_struct *task,
+				       struct pt_regs *regs)
+{
+	if (trace_syscalls_p && trace_test(task)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_SYSCALL_ENTRY;
+		ent.trace_syscall_entry.callno = syscall_get_nr(task, regs);
+		syscall_get_arguments(task, regs, 0, 6,
+				      ent.trace_syscall_entry.args);
+		process_trace(&ent);
+	}
+
+	return UTRACE_RESUME;
+}
+
+
+u32 process_trace_report_syscall_exit(enum utrace_resume_action action,
+				   struct utrace_engine *engine,
+				   struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	if (trace_syscalls_p && trace_test(task)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_SYSCALL_EXIT;
+		ent.trace_syscall_exit.rc =
+			syscall_get_return_value(task, regs);
+		ent.trace_syscall_exit.error = syscall_get_error(task, regs);
+		process_trace(&ent);
+	}
+
+	return UTRACE_RESUME;
+}
+
+
+u32 process_trace_report_exec(enum utrace_resume_action action,
+			      struct utrace_engine *engine,
+			      struct task_struct *task,
+			      const struct linux_binfmt *fmt,
+			      const struct linux_binprm *bprm,
+			      struct pt_regs *regs)
+{
+	if (trace_lifecycle_p && trace_test(task)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_EXEC;
+                ent.trace_exec.argc = bprm->argc;
+                strlcpy (ent.trace_exec.filename, bprm->filename, 
+                         sizeof(ent.trace_exec.filename));
+		process_trace(&ent);
+	}
+
+        tracing_record_cmdline (task);
+
+	/* We're already attached; no need for a new tryattach. */
+
+	return UTRACE_RESUME;
+}
+
+
+u32 process_trace_report_signal(u32 action,
+				struct utrace_engine *engine,
+				struct task_struct *task,
+				struct pt_regs *regs,
+				siginfo_t *info,
+				const struct k_sigaction *orig_ka,
+				struct k_sigaction *return_ka)
+{
+	if (trace_signals_p && trace_test(task)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_SIGNAL;
+		ent.trace_signal.si_signo = info->si_signo;
+		ent.trace_signal.si_errno = info->si_errno;
+		ent.trace_signal.si_code = info->si_code;
+		process_trace(&ent);
+	}
+
+	/* We're already attached, so no need for a new tryattach. */
+
+	return UTRACE_RESUME | utrace_signal_action(action);
+}
+
+
+u32 process_trace_report_exit(enum utrace_resume_action action,
+			      struct utrace_engine *engine,
+			      struct task_struct *task,
+			      long orig_code, long *code)
+{
+	if (trace_lifecycle_p && trace_test(task)) {
+		struct process_trace_entry ent;
+		ent.opcode = _UTRACE_EVENT_EXIT;
+		ent.trace_exit.code = orig_code;
+		process_trace(&ent);
+	}
+
+	/* There is no need to explicitly attach or detach here. */
+
+	return UTRACE_RESUME;
+}
+
+
+void enable_process_trace()
+{
+	struct task_struct *grp, *tsk;
+
+	pr_debug("in %s\n", __func__);
+	rcu_read_lock();
+	do_each_thread(grp, tsk) {
+		/* Skip over kernel threads. */
+		if (tsk->flags & PF_KTHREAD)
+			continue;
+
+		if (process_follow_pid) {
+			if (tsk->tgid == process_follow_pid ||
+			    tsk->parent->tgid == process_follow_pid)
+				process_trace_tryattach(tsk);
+		} else {
+			process_trace_tryattach(tsk);
+		}
+	} while_each_thread(grp, tsk);
+	rcu_read_unlock();
+}
+
+void disable_process_trace()
+{
+	struct utrace_engine *engine;
+	struct task_struct *grp, *tsk;
+	int rc;
+
+	pr_debug("in %s\n", __func__);
+	rcu_read_lock();
+	do_each_thread(grp, tsk) {
+		/* Find matching engine, if any.  Returns -ENOENT for
+		   unattached threads. */
+		engine = utrace_attach_task(tsk, UTRACE_ATTACH_MATCH_OPS,
+					    &process_trace_ops, 0);
+		if (IS_ERR(engine)) {
+			if (PTR_ERR(engine) != -ENOENT)
+				pr_warning("utrace_attach_task %d (rc %ld)\n",
+					   tsk->pid, -PTR_ERR(engine));
+		} else if (engine == NULL) {
+			pr_warning("utrace_attach_task %d (null engine)\n",
+				   tsk->pid);
+		} else {
+			/* Found one of our own engines.  Detach.  */
+			rc = utrace_control(tsk, engine, UTRACE_DETACH);
+			switch (rc) {
+			case 0:		    /* success */
+				break;
+			case -ESRCH:	    /* REAP callback already begun */
+			case -EALREADY:	    /* DEATH callback already begun */
+				break;
+			default:
+				rc = -rc;
+				pr_warning("utrace_detach %d (rc %d)\n",
+					   tsk->pid, rc);
+				break;
+			}
+			utrace_engine_put(engine);
+			pr_debug("detached in %s from %s(%d)\n", __func__,
+				 tsk->comm, tsk->pid);
+		}
+	} while_each_thread(grp, tsk);
+	rcu_read_unlock();
+}
+
+
+static const struct utrace_engine_ops process_trace_ops = {
+	.report_clone = process_trace_report_clone,
+	.report_exec = process_trace_report_exec,
+	.report_exit = process_trace_report_exit,
+	.report_jctl = process_trace_report_jctl,
+	.report_signal = process_trace_report_signal,
+	.report_syscall_entry = process_trace_report_syscall_entry,
+	.report_syscall_exit = process_trace_report_syscall_exit,
+};
+
+
+
+/* control interfaces */
+
+
+static ssize_t
+trace_taskcomm_filter_read(struct file *filp, char __user *ubuf,
+			   size_t cnt, loff_t *ppos)
+{
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       trace_taskcomm_filter, TASK_COMM_LEN);
+}
+
+
+static ssize_t
+trace_taskcomm_filter_write(struct file *filp, const char __user *ubuf,
+			    size_t cnt, loff_t *fpos)
+{
+	char *end;
+
+	if (cnt > TASK_COMM_LEN)
+		cnt = TASK_COMM_LEN;
+
+	if (copy_from_user(trace_taskcomm_filter, ubuf, cnt))
+		return -EFAULT;
+
+	/* Cut from the first nil or newline. */
+	trace_taskcomm_filter[cnt] = '\0';
+	end = strchr(trace_taskcomm_filter, '\n');
+	if (end)
+		*end = '\0';
+
+	*fpos += cnt;
+	return cnt;
+}
+
+
+static const struct file_operations trace_taskcomm_filter_fops = {
+	.open		= tracing_open_generic,
+	.read		= trace_taskcomm_filter_read,
+	.write		= trace_taskcomm_filter_write,
+};
+
+
+
+static char README_text[] =
+	"process event tracer mini-HOWTO\n"
+	"\n"
+	"1. Select process hierarchy to monitor.  Other processes will be\n"
+	"   completely unaffected.  Leave at 0 for system-wide tracing.\n"
+	"#  echo NNN > process_follow_pid\n"
+	"\n"
+	"2. Determine which process event traces are potentially desired.\n"
+	"   syscall and signal tracing slow down monitored processes.\n"
+	"#  echo 0 > process_trace_{syscalls,signals,lifecycle}\n"
+	"\n"
+	"3. Add any final uid- or taskcomm-based filtering.  Non-matching\n"
+	"   processes will skip trace messages, but will still be slowed.\n"
+	"#  echo NNN > process_trace_uid_filter # -1: unrestricted \n"
+	"#  echo ls > process_trace_taskcomm_filter # empty: unrestricted\n"
+	"\n"
+	"4. Start tracing.\n"
+	"#  echo process > current_tracer\n"
+	"\n"
+	"5. Examine trace.\n"
+	"#  cat trace\n"
+	"\n"
+	"6. Stop tracing.\n"
+	"#  echo nop > current_tracer\n"
+	;
+
+static struct debugfs_blob_wrapper README_blob = {
+	.data = README_text,
+	.size = sizeof(README_text),
+};
+
+
+static __init int init_process_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+        arch_init_ftrace_syscalls ();
+
+	entry = debugfs_create_blob("process_trace_README", 0444, d_tracer,
+				    &README_blob);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_README' entry\n");
+
+	/* Control for scoping process following. */
+	entry = debugfs_create_u32("process_follow_pid", 0644, d_tracer,
+				   &process_follow_pid);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_follow_pid' entry\n");
+
+	/* Process-level filters */
+	entry = debugfs_create_file("process_trace_taskcomm_filter", 0644,
+				    d_tracer, NULL,
+				    &trace_taskcomm_filter_fops);
+	/* XXX: it'd be nice to have a read/write debugfs_create_blob. */
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_taskcomm_filter' entry\n");
+
+	entry = debugfs_create_u32("process_trace_uid_filter", 0644, d_tracer,
+				   &trace_taskuid_filter);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_uid_filter' entry\n");
+
+	/* Event-level filters. */
+	entry = debugfs_create_u32("process_trace_lifecycle", 0644, d_tracer,
+				   &trace_lifecycle_p);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_lifecycle' entry\n");
+
+	entry = debugfs_create_u32("process_trace_syscalls", 0644, d_tracer,
+				   &trace_syscalls_p);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_syscalls' entry\n");
+
+	entry = debugfs_create_u32("process_trace_signals", 0644, d_tracer,
+				   &trace_signals_p);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'process_trace_signals' entry\n");
+
+	return register_tracer(&process_tracer);
+}
+
+device_initcall(init_process_trace);
-- 
1.6.0.6

