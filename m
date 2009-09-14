Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZINKOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZINKOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZINKOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZINKOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:14:17 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] tracing - signal tracer
Date: Mon, 14 Sep 2009 12:14:10 +0200
Message-Id: <1252923251-6735-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
References: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements the tracer for the signals.  It is possible to narrow the trace 
using the "set_ftrace_pid" pid filter file.

Usage (running some of the pthread-tests pkg's binaries):

sh-4.0# echo signal > current_tracer
sh-4.0# /tests/signal-loss 
sh-4.0# /tests/ptrace_event_clone 
sh-4.0# /tests/ptrace-on-job-control-stopped
sh-4.0# /tests/clone-ptrace 
sh-4.0# cat trace
# tracer: signal
#
#    TIMESTAMP  CPU#             FROM-PID                 TO-PID           SIGNAL-NUM 
#        |       |                  | |                    | |                  | |   
    217.117000 [000]         modprobe-8741           khelper-8740         SIGCHLD-17  
    217.142000 [001]      signal-loss-8742       signal-loss-8743         SIGSTOP-19  
    217.143000 [001]      signal-loss-8742       signal-loss-8743          SIGINT-2   
    218.145000 [001]           <idle>-0          signal-loss-8742         SIGALRM-14  
    218.149000 [001]      signal-loss-8742       signal-loss-8743         SIGKILL-9   
    218.159000 [001]      signal-loss-8742                sh-283          SIGCHLD-17  
    221.108000 [001]         modprobe-8745           khelper-8744         SIGCHLD-17  
    221.145000 [001]              cat-8746                sh-283          SIGCHLD-17  
    254.790000 [000]         modprobe-8748           khelper-8747         SIGCHLD-17  
    254.820000 [001]  ptrace_event_cl-8750   ptrace_event_cl-8750         SIGSTOP-19  
    254.824000 [001]  ptrace_event_cl-8749   ptrace_event_cl-8750         SIGKILL-9   
    254.824000 [001]  ptrace_event_cl-8749   ptrace_event_cl-8751         SIGKILL-9   
    254.827000 [001]  ptrace_event_cl-8749                sh-283          SIGCHLD-17  
    256.399000 [000]         modprobe-8753           khelper-8752         SIGCHLD-17  
    256.448000 [000]              cat-8754                sh-283          SIGCHLD-17  
    333.634000 [000]         modprobe-8756           khelper-8755         SIGCHLD-17  
    333.663000 [000]  ptrace-on-job-c-8757   ptrace-on-job-c-8758         SIGSTOP-19  
    333.664000 [000]  ptrace-on-job-c-8757   ptrace-on-job-c-8758         SIGKILL-9   
    333.666000 [000]  ptrace-on-job-c-8757              init-1            SIGCHLD-17  
    333.666000 [000]  ptrace-on-job-c-8757                sh-283          SIGCHLD-17  
    335.323000 [000]         modprobe-8760           khelper-8759         SIGCHLD-17  
    448.054000 [001]     clone-ptrace-8808      clone-ptrace-8808         SIGSTOP-19
    448.057000 [001]     clone-ptrace-8807      clone-ptrace-8808         SIGKILL-9
    448.058000 [001]     clone-ptrace-8807      clone-ptrace-8809         SIGKILL-9
    448.063000 [001]     clone-ptrace-8807              init-1            SIGCHLD-17
    448.063000 [001]     clone-ptrace-8807                sh-283          SIGCHLD-17
    448.064000 [000]     clone-ptrace-8809      clone-ptrace-8809         SIGTRAP-5
    448.066000 [000]     clone-ptrace-8809              init-1            SIGCHLD-17
    449.321000 [001]         modprobe-8811           khelper-8810         SIGCHLD-17
sh-4.0# 

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/signaltrace.h |   22 +++++++
 include/linux/tracehook.h   |   14 +++++
 kernel/signal.c             |    3 +
 kernel/trace/Kconfig        |   11 ++++
 kernel/trace/Makefile       |    1 +
 kernel/trace/trace.h        |    9 +++
 kernel/trace/trace_signal.c |  132 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/signaltrace.h
 create mode 100644 kernel/trace/trace_signal.c

diff --git a/include/linux/signaltrace.h b/include/linux/signaltrace.h
new file mode 100644
index 0000000..5254478
--- /dev/null
+++ b/include/linux/signaltrace.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2009 Jiri Olsa <jolsa@redhat.com>
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_SIGNALTRACE_H
+#define _LINUX_SIGNALTRACE_H
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_SIGNAL_TRACER
+void trace_signal(struct task_struct *to, int sig);
+#else
+static inline void trace_signal(struct task_struct *to, int sig)
+{
+}
+#endif
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_SIGNALTRACE_H */
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 17ba82e..315b828 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
+#include <linux/signaltrace.h>
 struct linux_binprm;
 
 /**
@@ -462,6 +463,19 @@ static inline int tracehook_get_signal(struct task_struct *task,
 }
 
 /**
+ * tracehook_send_signal
+ * @to:			@current
+ * @sig:		number of signal being sent
+ */
+static inline int tracehook_send_signal(struct task_struct *to, int sig)
+{
+#ifdef CONFIG_SIGNAL_TRACER
+	trace_signal(to, sig);
+#endif
+	return 0;
+}
+
+/**
  * tracehook_notify_jctl - report about job control stop/continue
  * @notify:		nonzero if this is the last thread in the group to stop
  * @why:		%CLD_STOPPED or %CLD_CONTINUED
diff --git a/kernel/signal.c b/kernel/signal.c
index 64c5dee..8d3072b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -842,6 +842,9 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
+
+	tracehook_send_signal(t, sig);
+
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d05a661..be47a1a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -396,6 +396,17 @@ config HW_BRANCH_TRACER
 	  This tracer records all branches on the system in a circular
 	  buffer giving access to the last N branches for each cpu.
 
+config SIGNAL_TRACER
+	bool "Trace signals"
+	select TRACING
+	help
+	  This tracer records sent signals in a circular buffer.
+	  It is possible to narrow the trace using the "set_ftrace_pid"
+	  pid filter file.
+
+	  If unsure, say N.
+
+
 config KMEMTRACE
 	bool "Trace SLAB allocations"
 	select GENERIC_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index ce3b1cd..a76c214 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -55,5 +55,6 @@ obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
+obj-$(CONFIG_SIGNAL_TRACER) += trace_signal.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e747162..5c7873a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -44,6 +44,7 @@ enum trace_type {
 	TRACE_POWER,
 	TRACE_BLK,
 	TRACE_KSYM,
+	TRACE_SIGNAL,
 
 	__TRACE_LAST_TYPE,
 };
@@ -218,6 +219,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
 			  TRACE_KMEM_FREE);	\
 		IF_ASSIGN(var, ent, struct ksym_trace_entry, TRACE_KSYM);\
+		IF_ASSIGN(var, ent, struct signal_trace_entry, TRACE_SIGNAL);\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -254,6 +256,13 @@ struct ksym_trace_entry {
 	char			cmd[TASK_COMM_LEN];
 };
 
+/* Signal trace entry. */
+struct signal_trace_entry {
+	struct trace_entry	ent;
+	int			pid;
+	int			sig;
+};
+
 /**
  * struct tracer - a specific tracer and its callbacks to interact with debugfs
  * @name: the name chosen to select it on the available_tracers file
diff --git a/kernel/trace/trace_signal.c b/kernel/trace/trace_signal.c
new file mode 100644
index 0000000..4b386de
--- /dev/null
+++ b/kernel/trace/trace_signal.c
@@ -0,0 +1,132 @@
+/*
+ * signal tracer
+ *
+ * Copyright (C) 2009 Jiri Olsa <jolsa@redhat.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/signaltrace.h>
+
+#include "trace.h"
+
+static char* signal_str[SIGRTMIN + 1] =
+{
+	"UNKNOWN", "SIGHUP", "SIGINT", "SIGQUIT", "SIGILL", "SIGTRAP",
+	"SIGABRT", "SIGBUS", "SIGFPE", "SIGKILL", "SIGUSR1", "SIGSEGV",
+	"SIGUSR2", "SIGPIPE", "SIGALRM", "SIGTERM", "SIGSTKFLT", "SIGCHLD",
+	"SIGCONT", "SIGSTOP", "SIGTSTP", "SIGTTIN", "SIGTTOU", "SIGURG",
+	"SIGXCPU", "SIGXFSZ", "SIGVTALRM", "SIGPROF", "SIGWINCH", "SIGIO",
+	"SIGPWR", "SIGSYS"
+};
+
+static struct trace_array *ctx_trace;
+static int signal_trace_enabled = 0;
+
+void trace_signal(struct task_struct *to, int sig)
+{
+	struct ring_buffer_event *event;
+	struct signal_trace_entry *entry;
+	struct trace_array *tr = ctx_trace;
+
+	if (!ftrace_trace_task(current))
+		return;
+
+	if (!signal_trace_enabled)
+		return;
+
+	event = trace_buffer_lock_reserve(tr->buffer, TRACE_SIGNAL,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		return;
+
+	tracing_record_cmdline(current);
+	tracing_record_cmdline(to);
+
+	entry = ring_buffer_event_data(event);
+	entry->pid = to->pid;
+	entry->sig = sig;
+
+	trace_buffer_unlock_commit(tr->buffer, event, 0, 0);
+}
+
+static void start_signal_trace(void)
+{
+	signal_trace_enabled = 1;
+}
+
+static void stop_signal_trace(void)
+{
+	signal_trace_enabled = 0;
+}
+
+static int signal_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+	start_signal_trace();
+	return 0;
+}
+
+static void signal_trace_reset(struct trace_array *tr)
+{
+	stop_signal_trace();
+}
+
+static void trace_signal_print_header(struct seq_file *m)
+{
+	seq_printf(m, "# %12s %5s %16s-%-5s %16s-%-5s %14s-%-4s\n",
+		"TIMESTAMP", "CPU#", "FROM", "PID", "TO", "PID", "SIGNAL", "NUM");
+	seq_printf(m, "# %12s %5s %16s %-5s %16s %-5s %14s %-4s\n",
+		"    |    ", " |  ", "   |", "|  ", " |", "|  ", "     |", "|  ");
+}
+
+static enum print_line_t trace_signal_print_line(struct trace_iterator *iter)
+{
+	char to_comm[TASK_COMM_LEN], from_comm[TASK_COMM_LEN];
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *tr_entry = iter->ent;
+	struct signal_trace_entry *sig_entry = NULL;
+	int sig;
+	unsigned long long t = ns2usecs(iter->ts);
+	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
+	unsigned long secs = (unsigned long)t;
+
+	trace_assign_type(sig_entry, iter->ent);
+	if (!sig_entry)
+		return TRACE_TYPE_UNHANDLED;
+
+	sig = sig_entry->sig < 0 ? 0 : sig_entry->sig;
+	if (sig > SIGRTMIN)
+		sig = 0;
+
+	trace_find_cmdline(tr_entry->pid, from_comm);
+	trace_find_cmdline(sig_entry->pid, to_comm);
+
+        trace_seq_printf(s, "  %5lu.%06lu [%03d] %16s-%-5d %16s-%-5d %14s-%-4d\n",
+		secs, usec_rem, iter->cpu,
+		from_comm, tr_entry->pid,
+		to_comm, sig_entry->pid,
+		signal_str[sig], sig);
+
+	return TRACE_TYPE_HANDLED;
+}
+
+struct tracer signal_trace __read_mostly =
+{
+	.name		= "signal",
+	.init		= signal_trace_init,
+	.reset		= signal_trace_reset,
+	.wait_pipe	= poll_wait_pipe,
+	.print_header	= trace_signal_print_header,
+	.print_line	= trace_signal_print_line,
+};
+
+static __init int init_signal_trace(void)
+{
+	return register_tracer(&signal_trace);
+}
+
+device_initcall(init_signal_trace);
-- 
1.6.2.5

