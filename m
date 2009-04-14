Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZDNR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZDNR14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZDNR0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZDNR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:44 -0400
Message-Id: <20090414172641.255384407@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 4/8] tracing/events: move declarations from trace directory to core include
Content-Disposition: inline; filename=0004-tracing-events-move-declarations-from-trace-directo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In preparation to allowing trace events to happen in modules, we need
to move some of the local declarations in the kernel/trace directory
into include/linux.

This patch simply moves the declarations and performs no context changes.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |  146 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |  120 +----------------------------------
 kernel/trace/trace_output.h  |   14 ----
 3 files changed, 147 insertions(+), 133 deletions(-)
 create mode 100644 include/linux/ftrace_event.h

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
new file mode 100644
index 0000000..496b76d
--- /dev/null
+++ b/include/linux/ftrace_event.h
@@ -0,0 +1,146 @@
+#ifndef _LINUX_FTRACE_EVENT_H
+#define _LINUX_FTRACE_EVENT_H
+
+#include <linux/trace_seq.h>
+#include <linux/ring_buffer.h>
+
+
+struct trace_array;
+struct tracer;
+
+/*
+ * The trace entry - the most basic unit of tracing. This is what
+ * is printed in the end as a single line in the trace output, such as:
+ *
+ *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
+ */
+struct trace_entry {
+	unsigned char		type;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+	int			tgid;
+};
+
+/*
+ * Trace iterator - used by printout routines who present trace
+ * results to users and which routines might sleep, etc:
+ */
+struct trace_iterator {
+	struct trace_array	*tr;
+	struct tracer		*trace;
+	void			*private;
+	int			cpu_file;
+	struct mutex		mutex;
+	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+
+	/* The below is zeroed out in pipe_read */
+	struct trace_seq	seq;
+	struct trace_entry	*ent;
+	int			cpu;
+	u64			ts;
+
+	unsigned long		iter_flags;
+	loff_t			pos;
+	long			idx;
+
+	cpumask_var_t		started;
+};
+
+
+typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
+					      int flags);
+struct trace_event {
+	struct hlist_node	node;
+	int			type;
+	trace_print_func	trace;
+	trace_print_func	raw;
+	trace_print_func	hex;
+	trace_print_func	binary;
+};
+
+extern int register_ftrace_event(struct trace_event *event);
+extern int unregister_ftrace_event(struct trace_event *event);
+
+/* Return values for print_line callback */
+enum print_line_t {
+	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
+	TRACE_TYPE_HANDLED	= 1,
+	TRACE_TYPE_UNHANDLED	= 2,	/* Relay to other output functions */
+	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
+};
+
+
+struct ring_buffer_event *
+trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
+				  unsigned long flags, int pc);
+void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
+void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
+void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
+
+void tracing_record_cmdline(struct task_struct *tsk);
+
+struct ftrace_event_call {
+	char			*name;
+	char			*system;
+	struct dentry		*dir;
+	int			enabled;
+	int			(*regfunc)(void);
+	void			(*unregfunc)(void);
+	int			id;
+	int			(*raw_init)(void);
+	int			(*show_format)(struct trace_seq *s);
+	int			(*define_fields)(void);
+	struct list_head	fields;
+	int			n_preds;
+	struct filter_pred	**preds;
+
+#ifdef CONFIG_EVENT_PROFILE
+	atomic_t	profile_count;
+	int		(*profile_enable)(struct ftrace_event_call *);
+	void		(*profile_disable)(struct ftrace_event_call *);
+#endif
+};
+
+#define MAX_FILTER_PRED		8
+#define MAX_FILTER_STR_VAL	128
+
+extern int init_preds(struct ftrace_event_call *call);
+extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_current_check_discard(struct ftrace_event_call *call,
+					void *rec,
+					struct ring_buffer_event *event);
+
+extern int trace_define_field(struct ftrace_event_call *call, char *type,
+			      char *name, int offset, int size);
+
+
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement optimizing out.
+ */
+#define event_trace_printk(ip, fmt, args...)				\
+do {									\
+	__trace_printk_check_format(fmt, ##args);			\
+	tracing_record_cmdline(current);				\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
+	} else								\
+		__trace_printk(ip, fmt, ##args);			\
+} while (0)
+
+#define __common_field(type, item)					\
+	ret = trace_define_field(event_call, #type, "common_" #item,	\
+				 offsetof(typeof(field.ent), item),	\
+				 sizeof(field.ent.item));		\
+	if (ret)							\
+		return ret;
+
+#endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1882846..6bcdf4a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -13,6 +13,7 @@
 #include <trace/power.h>
 
 #include <linux/trace_seq.h>
+#include <linux/ftrace_event.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -44,20 +45,6 @@ enum trace_type {
 };
 
 /*
- * The trace entry - the most basic unit of tracing. This is what
- * is printed in the end as a single line in the trace output, such as:
- *
- *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
- */
-struct trace_entry {
-	unsigned char		type;
-	unsigned char		flags;
-	unsigned char		preempt_count;
-	int			pid;
-	int			tgid;
-};
-
-/*
  * Function trace entry - function address and parent function addres:
  */
 struct ftrace_entry {
@@ -265,8 +252,6 @@ struct trace_array_cpu {
 	char			comm[TASK_COMM_LEN];
 };
 
-struct trace_iterator;
-
 /*
  * The trace array - an array of per-CPU trace arrays. This is the
  * highest level data structure that individual tracers deal with.
@@ -341,15 +326,6 @@ extern void __ftrace_bad_type(void);
 		__ftrace_bad_type();					\
 	} while (0)
 
-/* Return values for print_line callback */
-enum print_line_t {
-	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
-	TRACE_TYPE_HANDLED	= 1,
-	TRACE_TYPE_UNHANDLED	= 2,	/* Relay to other output functions */
-	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
-};
-
-
 /*
  * An option specific to a tracer. This is a boolean value.
  * The bit is the bit index that sets its value on the
@@ -428,31 +404,6 @@ struct tracer {
 
 #define TRACE_PIPE_ALL_CPU	-1
 
-/*
- * Trace iterator - used by printout routines who present trace
- * results to users and which routines might sleep, etc:
- */
-struct trace_iterator {
-	struct trace_array	*tr;
-	struct tracer		*trace;
-	void			*private;
-	int			cpu_file;
-	struct mutex		mutex;
-	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
-
-	/* The below is zeroed out in pipe_read */
-	struct trace_seq	seq;
-	struct trace_entry	*ent;
-	int			cpu;
-	u64			ts;
-
-	unsigned long		iter_flags;
-	loff_t			pos;
-	long			idx;
-
-	cpumask_var_t		started;
-};
-
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
@@ -479,15 +430,6 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc);
 
-struct ring_buffer_event *
-trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
-				  unsigned long flags, int pc);
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc);
-void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
-
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 
@@ -510,7 +452,6 @@ void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
 				unsigned long flags, int pc);
-void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_sched_wakeup_trace(struct trace_array *tr,
 				struct task_struct *wakee,
@@ -790,28 +731,6 @@ struct ftrace_event_field {
 	int			size;
 };
 
-struct ftrace_event_call {
-	char			*name;
-	char			*system;
-	struct dentry		*dir;
-	int			enabled;
-	int			(*regfunc)(void);
-	void			(*unregfunc)(void);
-	int			id;
-	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
-	int			(*define_fields)(void);
-	struct list_head	fields;
-	int			n_preds;
-	struct filter_pred	**preds;
-
-#ifdef CONFIG_EVENT_PROFILE
-	atomic_t	profile_count;
-	int		(*profile_enable)(struct ftrace_event_call *);
-	void		(*profile_disable)(struct ftrace_event_call *);
-#endif
-};
-
 struct event_subsystem {
 	struct list_head	list;
 	const char		*name;
@@ -825,9 +744,6 @@ struct event_subsystem {
 	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
 	     event++)
 
-#define MAX_FILTER_PRED		8
-#define MAX_FILTER_STR_VAL	128
-
 struct filter_pred;
 
 typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
@@ -845,9 +761,6 @@ struct filter_pred {
 	int clear;
 };
 
-int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size);
-extern int init_preds(struct ftrace_event_call *call);
 extern void filter_free_pred(struct filter_pred *pred);
 extern void filter_print_preds(struct filter_pred **preds, int n_preds,
 			       struct trace_seq *s);
@@ -855,13 +768,9 @@ extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_disable_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
-extern int filter_current_check_discard(struct ftrace_event_call *call,
-					void *rec,
-					struct ring_buffer_event *event);
 
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
@@ -876,14 +785,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-#define __common_field(type, item)					\
-	ret = trace_define_field(event_call, #type, "common_" #item,	\
-				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item));		\
-	if (ret)							\
-		return ret;
-
-void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
@@ -895,25 +796,6 @@ extern struct ftrace_event_call __stop_ftrace_events[];
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
-/*
- * The double __builtin_constant_p is because gcc will give us an error
- * if we try to allocate the static variable to fmt if it is not a
- * constant. Even with the outer if statement optimizing out.
- */
-#define event_trace_printk(ip, fmt, args...)				\
-do {									\
-	__trace_printk_check_format(fmt, ##args);			\
-	tracing_record_cmdline(current);				\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
-									\
-		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
-	} else								\
-		__trace_printk(ip, fmt, ##args);			\
-} while (0)
-
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 	extern struct ftrace_event_call event_##call;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 5c7cbfb..6e220a8 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -4,18 +4,6 @@
 #include <linux/trace_seq.h>
 #include "trace.h"
 
-typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
-					      int flags);
-
-struct trace_event {
-	struct hlist_node	node;
-	int			type;
-	trace_print_func	trace;
-	trace_print_func	raw;
-	trace_print_func	hex;
-	trace_print_func	binary;
-};
-
 extern enum print_line_t
 trace_print_bprintk_msg_only(struct trace_iterator *iter);
 extern enum print_line_t
@@ -33,8 +21,6 @@ extern int trace_print_context(struct trace_iterator *iter);
 extern int trace_print_lat_context(struct trace_iterator *iter);
 
 extern struct trace_event *ftrace_find_event(int type);
-extern int register_ftrace_event(struct trace_event *event);
-extern int unregister_ftrace_event(struct trace_event *event);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
 					 int flags);
-- 
1.6.2.1

-- 
