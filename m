Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0CEHAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:00:31 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60258 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0CEHA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:00:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NJadEqGPqVXUBpKjtzmeo82JokoVgjVFDW0wQ7L6gOsH6KlzZpcp9pkcRcL3v9On6i
         v1cAqTxVUEk7CLG+kXm4gpeQRo9WdZHv/7qdm7TK+01CusAAYcpJQe1dd7tcr2YPlROP
         RRc2NVFWb2u9K/4CMg09QdKaQKAo+BCGNV/5c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf: Walk through the relevant events only
Date: Fri,  5 Mar 2010 08:00:26 +0100
Message-Id: <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time a trace event triggers, we walk through the entire
list of events from the active contexts to find the perf events
that match the current one.

This is wasteful. To solve this, we maintain a per cpu list of
the active perf events for each running trace events and we
directly commit to these.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/ftrace_event.h    |   15 ++++++----
 include/linux/perf_event.h      |    9 +++++-
 include/trace/ftrace.h          |    4 +-
 kernel/perf_event.c             |   58 ++++++++++++++++++++++-----------------
 kernel/trace/trace_event_perf.c |   52 +++++++++++++++++++++++++++++++---
 kernel/trace/trace_kprobe.c     |    7 +++--
 kernel/trace/trace_syscalls.c   |    9 +++++-
 7 files changed, 109 insertions(+), 45 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 7ee157d..b39e8d5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -132,6 +132,7 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
+	struct list_head	__percpu *perf_list;
 	int			perf_refcount;
 	int			(*perf_event_enable)(struct ftrace_event_call *);
 	void			(*perf_event_disable)(struct ftrace_event_call *);
@@ -191,7 +192,7 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int perf_trace_enable(int event_id);
+extern int perf_trace_enable(int event_id, struct perf_event *perf_event);
 extern void perf_trace_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
@@ -201,15 +202,17 @@ perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
 			 unsigned long *irq_flags);
 
 static inline void
-perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
+perf_trace_buf_submit(struct ftrace_event_call *event, void *raw_data, int size,
+		      int rctx, u64 addr, u64 count, unsigned long irq_flags,
+		      struct pt_regs *regs)
 {
-	struct trace_entry *entry = raw_data;
-
-	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
+	perf_tp_event(event, addr, count, raw_data, size, regs);
 	perf_swevent_put_recursion_context(rctx);
 	local_irq_restore(irq_flags);
 }
+
+extern int perf_trace_sched_in(struct perf_event *event);
+extern void perf_trace_sched_out(struct perf_event *event);
 #endif
 
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e35ad6f..8a9e38f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -490,6 +490,8 @@ struct hw_perf_event {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		/* breakpoint */
 		struct arch_hw_breakpoint	info;
+		/* tracepoint */
+		struct ftrace_event_call	*trace_event;
 #endif
 	};
 	atomic64_t			prev_count;
@@ -578,6 +580,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct list_head		trace_list;
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
@@ -897,8 +900,8 @@ extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size, struct pt_regs *regs);
+extern void perf_tp_event(struct ftrace_event_call *fevent, u64 addr, u64 count,
+			  void *record, int entry_size, struct pt_regs *regs);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
@@ -917,6 +920,8 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern int perf_swevent_enable(struct perf_event *event);
+extern void perf_swevent_disable(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e92f037..dbd5e1f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -877,8 +877,8 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	__regs = &__get_cpu_var(perf_trace_regs);			\
 	perf_save_regs(__regs, 2);					\
 									\
-	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags, __regs);		\
+	perf_trace_buf_submit(event_call, entry, __entry_size, rctx,	\
+			      __addr, __count, irq_flags, __regs);	\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4fa24a5..87a7048 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4002,9 +4002,6 @@ static int perf_swevent_is_counting(struct perf_event *event)
 	return 1;
 }
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data);
-
 static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
@@ -4040,10 +4037,6 @@ static int perf_swevent_match(struct perf_event *event,
 	if (perf_exclude_event(event, regs))
 		return 0;
 
-	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
-	    !perf_tp_event_match(event, data))
-		return 0;
-
 	return 1;
 }
 
@@ -4140,7 +4133,7 @@ static void perf_swevent_read(struct perf_event *event)
 {
 }
 
-static int perf_swevent_enable(struct perf_event *event)
+int perf_swevent_enable(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -4151,7 +4144,7 @@ static int perf_swevent_enable(struct perf_event *event)
 	return 0;
 }
 
-static void perf_swevent_disable(struct perf_event *event)
+void perf_swevent_disable(struct perf_event *event)
 {
 }
 
@@ -4339,9 +4332,21 @@ static const struct pmu perf_ops_task_clock = {
 
 #ifdef CONFIG_EVENT_TRACING
 
-void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-		   int entry_size, struct pt_regs *regs)
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	void *record = data->raw->data;
+
+	if (likely(!event->filter) || filter_match_preds(event->filter, record))
+		return 1;
+	return 0;
+}
+
+void perf_tp_event(struct ftrace_event_call *fevent, u64 addr, u64 count,
+		   void *record, int entry_size, struct pt_regs *regs)
 {
+	struct list_head *list;
+	struct perf_event *event;
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
@@ -4352,27 +4357,30 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 		.raw = &raw,
 	};
 
-	/* Trace events already protected against recursion */
-	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-			 &data, regs);
-}
-EXPORT_SYMBOL_GPL(perf_tp_event);
+	list = per_cpu_ptr(fevent->perf_list, smp_processor_id());
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	void *record = data->raw->data;
+	list_for_each_entry(event, list, trace_list) {
+		if (perf_exclude_event(event, regs))
+			continue;
 
-	if (likely(!event->filter) || filter_match_preds(event->filter, record))
-		return 1;
-	return 0;
+		if (perf_tp_event_match(event, &data))
+			perf_swevent_add(event, count, 1, &data, regs);
+	}
 }
+EXPORT_SYMBOL_GPL(perf_tp_event);
 
 static void tp_perf_event_destroy(struct perf_event *event)
 {
 	perf_trace_disable(event->attr.config);
 }
 
+static const struct pmu perf_ops_tp = {
+	.enable		= perf_trace_sched_in,
+	.disable	= perf_trace_sched_out,
+	.read		= perf_swevent_read,
+	.unthrottle	= perf_swevent_unthrottle,
+};
+
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	/*
@@ -4384,12 +4392,12 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (perf_trace_enable(event->attr.config))
+	if (perf_trace_enable(event->attr.config, event))
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
 
-	return &perf_ops_generic;
+	return &perf_ops_tp;
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index f315b12..2bf254c 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -22,6 +22,7 @@ static int	total_ref_count;
 static int perf_trace_event_enable(struct ftrace_event_call *event)
 {
 	char *buf;
+	int cpu;
 	int ret = -ENOMEM;
 
 	if (event->perf_refcount++ > 0)
@@ -41,12 +42,26 @@ static int perf_trace_event_enable(struct ftrace_event_call *event)
 		rcu_assign_pointer(perf_trace_buf_nmi, buf);
 	}
 
+	event->perf_list = alloc_percpu(struct list_head);
+	if (!event->perf_list)
+		goto fail_buf_nmi;
+
+	for_each_online_cpu(cpu)
+		INIT_LIST_HEAD(per_cpu_ptr(event->perf_list, cpu));
+
+	/* Ensure the lists are visible before starting the events */
+	smp_mb();
+
 	ret = event->perf_event_enable(event);
-	if (!ret) {
-		total_ref_count++;
-		return 0;
-	}
+	if (ret)
+		goto fail_enable;
 
+	total_ref_count++;
+
+	return 0;
+
+fail_enable:
+	free_percpu(event->perf_list);
 fail_buf_nmi:
 	if (!total_ref_count) {
 		free_percpu(perf_trace_buf_nmi);
@@ -60,7 +75,7 @@ fail_buf:
 	return ret;
 }
 
-int perf_trace_enable(int event_id)
+int perf_trace_enable(int event_id, struct perf_event *perf_event)
 {
 	struct ftrace_event_call *event;
 	int ret = -EINVAL;
@@ -70,6 +85,8 @@ int perf_trace_enable(int event_id)
 		if (event->id == event_id && event->perf_event_enable &&
 		    try_module_get(event->mod)) {
 			ret = perf_trace_event_enable(event);
+			if (!ret)
+				perf_event->hw.trace_event = event;
 			break;
 		}
 	}
@@ -102,6 +119,7 @@ static void perf_trace_event_disable(struct ftrace_event_call *event)
 
 		free_percpu(buf);
 		free_percpu(nmi_buf);
+		free_percpu(event->perf_list);
 	}
 }
 
@@ -120,6 +138,30 @@ void perf_trace_disable(int event_id)
 	mutex_unlock(&event_mutex);
 }
 
+/*
+ * No need to protect the per cpu list of events.
+ * This is only changed locally without interrupts to
+ * race against.
+ */
+int perf_trace_sched_in(struct perf_event *event)
+{
+	struct ftrace_event_call *call = event->hw.trace_event;
+	struct list_head __percpu *head;
+
+	head = per_cpu_ptr(call->perf_list, smp_processor_id());
+
+	list_add_tail(&event->trace_list, head);
+	perf_swevent_enable(event);
+
+	return 0;
+}
+
+void perf_trace_sched_out(struct perf_event *event)
+{
+	list_del(&event->trace_list);
+	perf_swevent_disable(event);
+}
+
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 				       int *rctxp, unsigned long *irq_flags)
 {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 41ef5fa..1184f48 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1260,7 +1260,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+	perf_trace_buf_submit(call, entry, size, rctx, entry->ip, 1,
+			      irq_flags, regs);
 }
 
 /* Kretprobe profile handler */
@@ -1291,8 +1292,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs);
+	perf_trace_buf_submit(call, entry, size, rctx, entry->ret_ip, 1,
+			      irq_flags, regs);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 99cc45f..ed7d175 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -431,6 +431,7 @@ static int sys_perf_refcount_exit;
 static void perf_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
+	struct ftrace_event_call *event;
 	struct syscall_trace_enter *rec;
 	unsigned long flags;
 	int syscall_nr;
@@ -462,7 +463,8 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	event = sys_data->enter_event;
+	perf_trace_buf_submit(event, rec, size, rctx, 0, 1, flags, regs);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -503,6 +505,7 @@ void perf_sysenter_disable(struct ftrace_event_call *call)
 static void perf_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
+	struct ftrace_event_call *event;
 	struct syscall_trace_exit *rec;
 	unsigned long flags;
 	int syscall_nr;
@@ -537,7 +540,9 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	event = sys_data->exit_event;
+
+	perf_trace_buf_submit(event, rec, size, rctx, 0, 1, flags, regs);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)
-- 
1.6.2.3

