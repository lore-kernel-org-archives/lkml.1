Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0CEHAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:00:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62905 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0CEHA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:00:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tRTvxMT2LbH7BlEBh5koLSQVRhMpIO01H/ZIJxSo2GlOf+L2zmt8ygSPsg6yELzdty
         xvTp8ogh4iDbamy7AsPhHg/tA3vHJQfYNuwSMVk3bAl4/9uMYycsFHFhgqDRpIFRizjf
         mn01ak+r2FaFUmbKWkvtep7rwdAVDirHCXyak=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/2] perf: Drop the obsolete profile naming for trace events
Date: Fri,  5 Mar 2010 08:00:25 +0100
Message-Id: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the obsolete "profile" naming used by perf for trace events.
Perf can now do more than simple events counting, so generalize
the API naming.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h                       |   16 ++--
 include/linux/syscalls.h                           |   24 +++---
 include/trace/ftrace.h                             |   38 +++++-----
 include/trace/syscall.h                            |    8 +-
 kernel/perf_event.c                                |    4 +-
 kernel/trace/Makefile                              |    2 +-
 .../{trace_event_profile.c => trace_event_perf.c}  |   44 ++++++------
 kernel/trace/trace_events.c                        |    2 +-
 kernel/trace/trace_kprobe.c                        |   28 ++++----
 kernel/trace/trace_syscalls.c                      |   72 ++++++++++----------
 10 files changed, 119 insertions(+), 119 deletions(-)
 rename kernel/trace/{trace_event_profile.c => trace_event_perf.c} (73%)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 48b367e..7ee157d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -132,12 +132,12 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	int			profile_count;
-	int			(*profile_enable)(struct ftrace_event_call *);
-	void			(*profile_disable)(struct ftrace_event_call *);
+	int			perf_refcount;
+	int			(*perf_event_enable)(struct ftrace_event_call *);
+	void			(*perf_event_disable)(struct ftrace_event_call *);
 };
 
-#define FTRACE_MAX_PROFILE_SIZE	2048
+#define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
@@ -191,17 +191,17 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int ftrace_profile_enable(int event_id);
-extern void ftrace_profile_disable(int event_id);
+extern int perf_trace_enable(int event_id);
+extern void perf_trace_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *
-ftrace_perf_buf_prepare(int size, unsigned short type, int *rctxp,
+perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
 			 unsigned long *irq_flags);
 
 static inline void
-ftrace_perf_buf_submit(void *raw_data, int size, int rctx, u64 addr,
+perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
 		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
 {
 	struct trace_entry *entry = raw_data;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index feee739..eb46f5b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -101,18 +101,18 @@ struct perf_event_attr;
 
 #ifdef CONFIG_PERF_EVENTS
 
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
-	.profile_enable = prof_sysenter_enable,				       \
-	.profile_disable = prof_sysenter_disable,
+#define TRACE_SYS_ENTER_PERF_INIT(sname)				       \
+	.perf_event_enable = perf_sysenter_enable,			       \
+	.perf_event_disable = perf_sysenter_disable,
 
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
-	.profile_enable = prof_sysexit_enable,				       \
-	.profile_disable = prof_sysexit_disable,
+#define TRACE_SYS_EXIT_PERF_INIT(sname)					       \
+	.perf_event_enable = perf_sysexit_enable,			       \
+	.perf_event_disable = perf_sysexit_disable,
 #else
-#define TRACE_SYS_ENTER_PROFILE(sname)
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)
-#define TRACE_SYS_EXIT_PROFILE(sname)
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)
+#define TRACE_SYS_ENTER_PERF(sname)
+#define TRACE_SYS_ENTER_PERF_INIT(sname)
+#define TRACE_SYS_EXIT_PERF(sname)
+#define TRACE_SYS_EXIT_PERF_INIT(sname)
 #endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -149,7 +149,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
+		TRACE_SYS_ENTER_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
@@ -171,7 +171,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
+		TRACE_SYS_EXIT_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a4fa51c..e92f037 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -524,16 +524,16 @@ static inline int ftrace_get_offsets_##call(				\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
 									\
-static void ftrace_profile_##name(proto);				\
+static void perf_trace_##name(proto);					\
 									\
-static int ftrace_profile_enable_##name(struct ftrace_event_call *unused)\
+static int perf_trace_enable_##name(struct ftrace_event_call *unused)	\
 {									\
-	return register_trace_##name(ftrace_profile_##name);		\
+	return register_trace_##name(perf_trace_##name);		\
 }									\
 									\
-static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
+static void perf_trace_disable_##name(struct ftrace_event_call *unused)\
 {									\
-	unregister_trace_##name(ftrace_profile_##name);			\
+	unregister_trace_##name(perf_trace_##name);			\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -629,12 +629,12 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 
 #ifdef CONFIG_PERF_EVENTS
 
-#define _TRACE_PROFILE_INIT(call)					\
-	.profile_enable = ftrace_profile_enable_##call,			\
-	.profile_disable = ftrace_profile_disable_##call,
+#define _TRACE_PERF_INIT(call)						\
+	.perf_event_enable = perf_trace_enable_##call,			\
+	.perf_event_disable = perf_trace_disable_##call,
 
 #else
-#define _TRACE_PROFILE_INIT(call)
+#define _TRACE_PERF_INIT(call)
 #endif /* CONFIG_PERF_EVENTS */
 
 #undef __entry
@@ -739,7 +739,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##template,		\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PROFILE_INIT(call)					\
+	_TRACE_PERF_INIT(call)					\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -756,18 +756,18 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PROFILE_INIT(call)					\
+	_TRACE_PERF_INIT(call)					\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
- * Define the insertion callback to profile events
+ * Define the insertion callback to perf events
  *
  * The job is very similar to ftrace_raw_event_<call> except that we don't
  * insert in the ring buffer but in a perf counter.
  *
- * static void ftrace_profile_<call>(proto)
+ * static void ftrace_perf_<call>(proto)
  * {
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ftrace_event_call *event_call = &event_<call>;
@@ -846,7 +846,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static void								\
-ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
+perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 			    proto)					\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
@@ -863,10 +863,10 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	if (WARN_ONCE(__entry_size > FTRACE_MAX_PROFILE_SIZE,		\
+	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
 		      "profile buffer not large enough"))		\
 		return;							\
-	entry = (struct ftrace_raw_##call *)ftrace_perf_buf_prepare(	\
+	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 		__entry_size, event_call->id, &rctx, &irq_flags);	\
 	if (!entry)							\
 		return;							\
@@ -877,17 +877,17 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 	__regs = &__get_cpu_var(perf_trace_regs);			\
 	perf_save_regs(__regs, 2);					\
 									\
-	ftrace_perf_buf_submit(entry, __entry_size, rctx, __addr,	\
+	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 			       __count, irq_flags, __regs);		\
 }
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
-static void ftrace_profile_##call(proto)			\
+static void perf_trace_##call(proto)				\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
 								\
-	ftrace_profile_templ_##template(event_call, args);	\
+	perf_trace_templ_##template(event_call, args);		\
 }
 
 #undef DEFINE_EVENT_PRINT
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 3d463dc..ad193fa 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -51,10 +51,10 @@ enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
-int prof_sysenter_enable(struct ftrace_event_call *call);
-void prof_sysenter_disable(struct ftrace_event_call *call);
-int prof_sysexit_enable(struct ftrace_event_call *call);
-void prof_sysexit_disable(struct ftrace_event_call *call);
+int perf_sysenter_enable(struct ftrace_event_call *call);
+void perf_sysenter_disable(struct ftrace_event_call *call);
+int perf_sysexit_enable(struct ftrace_event_call *call);
+void perf_sysexit_disable(struct ftrace_event_call *call);
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 763a482..4fa24a5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4370,7 +4370,7 @@ static int perf_tp_event_match(struct perf_event *event,
 
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	ftrace_profile_disable(event->attr.config);
+	perf_trace_disable(event->attr.config);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
@@ -4384,7 +4384,7 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (ftrace_profile_enable(event->attr.config))
+	if (perf_trace_enable(event->attr.config))
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d00c6fe..78edc64 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 ifeq ($(CONFIG_PERF_EVENTS),y)
-obj-$(CONFIG_EVENT_TRACING) += trace_event_profile.o
+obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_perf.c
similarity index 73%
rename from kernel/trace/trace_event_profile.c
rename to kernel/trace/trace_event_perf.c
index e66d21e..f315b12 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_perf.c
@@ -1,5 +1,5 @@
 /*
- * trace event based perf counter profiling
+ * trace event based perf event profiling/tracing
  *
  * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra <pzijlstr@redhat.com>
  * Copyright (C) 2009-2010 Frederic Weisbecker <fweisbec@gmail.com>
@@ -14,20 +14,20 @@ DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
-typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
+typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
 
 /* Count the events in use (per event id, not per instance) */
-static int	total_profile_count;
+static int	total_ref_count;
 
-static int ftrace_profile_enable_event(struct ftrace_event_call *event)
+static int perf_trace_event_enable(struct ftrace_event_call *event)
 {
 	char *buf;
 	int ret = -ENOMEM;
 
-	if (event->profile_count++ > 0)
+	if (event->perf_refcount++ > 0)
 		return 0;
 
-	if (!total_profile_count) {
+	if (!total_ref_count) {
 		buf = (char *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf;
@@ -41,35 +41,35 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 		rcu_assign_pointer(perf_trace_buf_nmi, buf);
 	}
 
-	ret = event->profile_enable(event);
+	ret = event->perf_event_enable(event);
 	if (!ret) {
-		total_profile_count++;
+		total_ref_count++;
 		return 0;
 	}
 
 fail_buf_nmi:
-	if (!total_profile_count) {
+	if (!total_ref_count) {
 		free_percpu(perf_trace_buf_nmi);
 		free_percpu(perf_trace_buf);
 		perf_trace_buf_nmi = NULL;
 		perf_trace_buf = NULL;
 	}
 fail_buf:
-	event->profile_count--;
+	event->perf_refcount--;
 
 	return ret;
 }
 
-int ftrace_profile_enable(int event_id)
+int perf_trace_enable(int event_id)
 {
 	struct ftrace_event_call *event;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->profile_enable &&
+		if (event->id == event_id && event->perf_event_enable &&
 		    try_module_get(event->mod)) {
-			ret = ftrace_profile_enable_event(event);
+			ret = perf_trace_event_enable(event);
 			break;
 		}
 	}
@@ -78,16 +78,16 @@ int ftrace_profile_enable(int event_id)
 	return ret;
 }
 
-static void ftrace_profile_disable_event(struct ftrace_event_call *event)
+static void perf_trace_event_disable(struct ftrace_event_call *event)
 {
 	char *buf, *nmi_buf;
 
-	if (--event->profile_count > 0)
+	if (--event->perf_refcount > 0)
 		return;
 
-	event->profile_disable(event);
+	event->perf_event_disable(event);
 
-	if (!--total_profile_count) {
+	if (!--total_ref_count) {
 		buf = perf_trace_buf;
 		rcu_assign_pointer(perf_trace_buf, NULL);
 
@@ -105,14 +105,14 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 	}
 }
 
-void ftrace_profile_disable(int event_id)
+void perf_trace_disable(int event_id)
 {
 	struct ftrace_event_call *event;
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id) {
-			ftrace_profile_disable_event(event);
+			perf_trace_event_disable(event);
 			module_put(event->mod);
 			break;
 		}
@@ -120,8 +120,8 @@ void ftrace_profile_disable(int event_id)
 	mutex_unlock(&event_mutex);
 }
 
-__kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
-					int *rctxp, unsigned long *irq_flags)
+__kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
+				       int *rctxp, unsigned long *irq_flags)
 {
 	struct trace_entry *entry;
 	char *trace_buf, *raw_data;
@@ -162,4 +162,4 @@ err_recursion:
 	local_irq_restore(*irq_flags);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ftrace_perf_buf_prepare);
+EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..27296c7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -931,7 +931,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
-	if (call->id && call->profile_enable)
+	if (call->id && call->perf_event_enable)
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 73e0526..41ef5fa 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1234,7 +1234,7 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes void kprobe_profile_func(struct kprobe *kp,
+static __kprobes void kprobe_perf_func(struct kprobe *kp,
 					 struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
@@ -1247,11 +1247,11 @@ static __kprobes void kprobe_profile_func(struct kprobe *kp,
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1260,11 +1260,11 @@ static __kprobes void kprobe_profile_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
 }
 
 /* Kretprobe profile handler */
-static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 					    struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1277,11 +1277,11 @@ static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1291,11 +1291,11 @@ static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1,
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
 			       irq_flags, regs);
 }
 
-static int probe_profile_enable(struct ftrace_event_call *call)
+static int probe_perf_enable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
@@ -1307,7 +1307,7 @@ static int probe_profile_enable(struct ftrace_event_call *call)
 		return enable_kprobe(&tp->rp.kp);
 }
 
-static void probe_profile_disable(struct ftrace_event_call *call)
+static void probe_perf_disable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
@@ -1332,7 +1332,7 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 		kprobe_trace_func(kp, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kprobe_profile_func(kp, regs);
+		kprobe_perf_func(kp, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1346,7 +1346,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 		kretprobe_trace_func(ri, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kretprobe_profile_func(ri, regs);
+		kretprobe_perf_func(ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1377,8 +1377,8 @@ static int register_probe_event(struct trace_probe *tp)
 	call->unregfunc = probe_event_disable;
 
 #ifdef CONFIG_PERF_EVENTS
-	call->profile_enable = probe_profile_enable;
-	call->profile_disable = probe_profile_disable;
+	call->perf_event_enable = probe_perf_enable;
+	call->perf_event_disable = probe_perf_disable;
 #endif
 	call->data = tp;
 	ret = trace_add_event_call(call);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d0f34ab..99cc45f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -423,12 +423,12 @@ core_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
-static int sys_prof_refcount_enter;
-static int sys_prof_refcount_exit;
+static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
+static int sys_perf_refcount_enter;
+static int sys_perf_refcount_exit;
 
-static void prof_syscall_enter(struct pt_regs *regs, long id)
+static void perf_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
@@ -438,7 +438,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
+	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -450,11 +450,11 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
-		      "profile buffer not large enough"))
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		      "perf buffer not large enough"))
 		return;
 
-	rec = (struct syscall_trace_enter *)ftrace_perf_buf_prepare(size,
+	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
 				sys_data->enter_event->id, &rctx, &flags);
 	if (!rec)
 		return;
@@ -462,10 +462,10 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
-int prof_sysenter_enable(struct ftrace_event_call *call)
+int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -473,34 +473,34 @@ int prof_sysenter_enable(struct ftrace_event_call *call)
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_prof_refcount_enter)
-		ret = register_trace_sys_enter(prof_syscall_enter);
+	if (!sys_perf_refcount_enter)
+		ret = register_trace_sys_enter(perf_syscall_enter);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_prof_enter_syscalls);
-		sys_prof_refcount_enter++;
+		set_bit(num, enabled_perf_enter_syscalls);
+		sys_perf_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-void prof_sysenter_disable(struct ftrace_event_call *call)
+void perf_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	sys_prof_refcount_enter--;
-	clear_bit(num, enabled_prof_enter_syscalls);
-	if (!sys_prof_refcount_enter)
-		unregister_trace_sys_enter(prof_syscall_enter);
+	sys_perf_refcount_enter--;
+	clear_bit(num, enabled_perf_enter_syscalls);
+	if (!sys_perf_refcount_enter)
+		unregister_trace_sys_enter(perf_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static void prof_syscall_exit(struct pt_regs *regs, long ret)
+static void perf_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
@@ -510,7 +510,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
+	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -525,11 +525,11 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	 * Impossible, but be paranoid with the future
 	 * How to put this check outside runtime?
 	 */
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
-		"exit event has grown above profile buffer size"))
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		"exit event has grown above perf buffer size"))
 		return;
 
-	rec = (struct syscall_trace_exit *)ftrace_perf_buf_prepare(size,
+	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
 				sys_data->exit_event->id, &rctx, &flags);
 	if (!rec)
 		return;
@@ -537,10 +537,10 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
-int prof_sysexit_enable(struct ftrace_event_call *call)
+int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -548,30 +548,30 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_prof_refcount_exit)
-		ret = register_trace_sys_exit(prof_syscall_exit);
+	if (!sys_perf_refcount_exit)
+		ret = register_trace_sys_exit(perf_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_prof_exit_syscalls);
-		sys_prof_refcount_exit++;
+		set_bit(num, enabled_perf_exit_syscalls);
+		sys_perf_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-void prof_sysexit_disable(struct ftrace_event_call *call)
+void perf_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	sys_prof_refcount_exit--;
-	clear_bit(num, enabled_prof_exit_syscalls);
-	if (!sys_prof_refcount_exit)
-		unregister_trace_sys_exit(prof_syscall_exit);
+	sys_perf_refcount_exit--;
+	clear_bit(num, enabled_perf_exit_syscalls);
+	if (!sys_perf_refcount_exit)
+		unregister_trace_sys_exit(perf_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-- 
1.6.2.3

