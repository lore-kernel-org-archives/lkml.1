Return-Path: <linux-kernel-owner+w=401wt.eu-S933621AbZLOUbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbZLOUbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbZLOUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:31:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbZLOUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:31:43 -0500
Date: Tue, 15 Dec 2009 21:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091215203126.GA4720@elte.hu>
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

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Joe Perches (1):
      ftrace.h: Use common pr_info fmt string

Li Zefan (13):
      tracing: Extract duplicate ftrace_raw_init_event_foo()
      tracing: Pull up calls to trace_define_common_fields()
      tracing: Move a printk out of ftrace_raw_reg_event_foo()
      ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
      ftrace: Call trace_parser_clear() properly
      function-graph: Allow writing the same val to set_graph_function
      tracing: Use seq file for trace_options
      tracing: Use seq file for trace_clock
      tracing: Remove useless trace option
      tracing: Simplify trace_option_write()
      tracing: Change event->profile_count to be int type
      tracing/power: Remove two exports
      ksym_tracer: Fix bad cast

Steven Rostedt (5):
      ring-buffer: Use sync sched protection on ring buffer resizing
      ring-buffer: Move resize integrity check under reader lock
      tracing: Add trace_dump_stack()
      tracing: Add stack trace to irqsoff tracer
      tracing: Fix return of trace_dump_stack()

Thomas Gleixner (1):
      tracing: Fix wrong usage of strstrip in trace_ksyms


 include/linux/ftrace_event.h       |    4 +-
 include/linux/kernel.h             |    3 +
 include/linux/syscalls.h           |    6 +-
 include/trace/ftrace.h             |   56 +----------
 kernel/trace/ftrace.c              |   30 ++++--
 kernel/trace/power-traces.c        |    2 -
 kernel/trace/ring_buffer.c         |   29 ++----
 kernel/trace/trace.c               |  182 +++++++++++++++---------------------
 kernel/trace/trace.h               |   23 ++---
 kernel/trace/trace_event_profile.c |    6 +-
 kernel/trace/trace_events.c        |   41 +++++++--
 kernel/trace/trace_export.c        |    4 -
 kernel/trace/trace_irqsoff.c       |    2 +
 kernel/trace/trace_kprobe.c        |    9 --
 kernel/trace/trace_ksym.c          |   56 +++++------
 kernel/trace/trace_syscalls.c      |   18 +---
 16 files changed, 196 insertions(+), 275 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 38f8d65..2233c98 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -131,7 +131,7 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	atomic_t		profile_count;
+	int			profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
 	void			(*profile_disable)(struct ftrace_event_call *);
 };
@@ -158,7 +158,7 @@ enum {
 	FILTER_PTR_STRING,
 };
 
-extern int trace_define_common_fields(struct ftrace_event_call *call);
+extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fa4c59..f1dc752 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -492,6 +492,8 @@ extern int
 __trace_printk(unsigned long ip, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 
+extern void trace_dump_stack(void);
+
 /*
  * The double __builtin_constant_p is because gcc will give us an error
  * if we try to allocate the static variable to fmt if it is not a
@@ -525,6 +527,7 @@ trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
+static inline void trace_dump_stack(void) { }
 static inline int
 trace_printk(const char *fmt, ...)
 {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 939a615..65793e9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -102,12 +102,10 @@ struct perf_event_attr;
 #ifdef CONFIG_EVENT_PROFILE
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
-	.profile_count = ATOMIC_INIT(-1),				       \
 	.profile_enable = prof_sysenter_enable,				       \
 	.profile_disable = prof_sysenter_disable,
 
 #define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
-	.profile_count = ATOMIC_INIT(-1),				       \
 	.profile_enable = prof_sysexit_enable,				       \
 	.profile_disable = prof_sysexit_disable,
 #else
@@ -145,7 +143,7 @@ struct perf_event_attr;
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
+		.raw_init		= trace_event_raw_init,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
@@ -167,7 +165,7 @@ struct perf_event_attr;
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
+		.raw_init		= trace_event_raw_init,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1b3de9..7352315 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -436,10 +436,6 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	struct ftrace_raw_##call field;					\
 	int ret;							\
 									\
-	ret = trace_define_common_fields(event_call);			\
-	if (ret)							\
-		return ret;						\
-									\
 	tstruct;							\
 									\
 	return ret;							\
@@ -559,13 +555,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
  * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to  <call>");
- *	return ret;
+ *	return register_trace_<call>(ftrace_event_<call>);
  * }
  *
  * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
@@ -623,23 +613,12 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
- * static int ftrace_raw_init_event_<call>(struct ftrace_event_call *unused)
- * {
- *	int id;
- *
- *	id = register_ftrace_event(&ftrace_event_type_<call>);
- *	if (!id)
- *		return -ENODEV;
- *	event_<call>.id = id;
- *	return 0;
- * }
- *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.system			= "<system>",
- *	.raw_init		= ftrace_raw_init_event_<call>,
+ *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
  *	.show_format		= ftrace_format_<call>,
@@ -647,13 +626,9 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  */
 
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
 #ifdef CONFIG_EVENT_PROFILE
 
 #define _TRACE_PROFILE_INIT(call)					\
-	.profile_count = ATOMIC_INIT(-1),				\
 	.profile_enable = ftrace_profile_enable_##call,			\
 	.profile_disable = ftrace_profile_disable_##call,
 
@@ -728,13 +703,7 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 {									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_raw_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
+	return register_trace_##call(ftrace_raw_event_##call);		\
 }									\
 									\
 static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
@@ -744,19 +713,7 @@ static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
 									\
 static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
-};									\
-									\
-static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(&ftrace_event_type_##call);		\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	return 0;							\
-}
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -776,7 +733,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##template,		\
@@ -793,7 +750,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
@@ -953,7 +910,6 @@ end:									\
 	perf_swevent_put_recursion_context(rctx);			\
 end_recursion:								\
 	local_irq_restore(irq_flags);					\
-									\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e51a1bc..7968762 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1724,7 +1724,7 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 	return ftrace_match(str, regex, len, type);
 }
 
-static void ftrace_match_records(char *buff, int len, int enable)
+static int ftrace_match_records(char *buff, int len, int enable)
 {
 	unsigned int search_len;
 	struct ftrace_page *pg;
@@ -1733,6 +1733,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	char *search;
 	int type;
 	int not;
+	int found = 0;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	type = filter_parse_regex(buff, len, &search, &not);
@@ -1750,6 +1751,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 				rec->flags &= ~flag;
 			else
 				rec->flags |= flag;
+			found = 1;
 		}
 		/*
 		 * Only enable filtering if we have a function that
@@ -1759,6 +1761,8 @@ static void ftrace_match_records(char *buff, int len, int enable)
 			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
+
+	return found;
 }
 
 static int
@@ -1780,7 +1784,7 @@ ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
 		return 1;
 }
 
-static void ftrace_match_module_records(char *buff, char *mod, int enable)
+static int ftrace_match_module_records(char *buff, char *mod, int enable)
 {
 	unsigned search_len = 0;
 	struct ftrace_page *pg;
@@ -1789,6 +1793,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	char *search = buff;
 	unsigned long flag;
 	int not = 0;
+	int found = 0;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
@@ -1819,12 +1824,15 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 				rec->flags &= ~flag;
 			else
 				rec->flags |= flag;
+			found = 1;
 		}
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
 			ftrace_filtered = 1;
 
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
+
+	return found;
 }
 
 /*
@@ -1853,8 +1861,9 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 	if (!strlen(mod))
 		return -EINVAL;
 
-	ftrace_match_module_records(func, mod, enable);
-	return 0;
+	if (ftrace_match_module_records(func, mod, enable))
+		return 0;
+	return -EINVAL;
 }
 
 static struct ftrace_func_command ftrace_mod_cmd = {
@@ -2151,8 +2160,9 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 	func = strsep(&next, ":");
 
 	if (!next) {
-		ftrace_match_records(func, len, enable);
-		return 0;
+		if (ftrace_match_records(func, len, enable))
+			return 0;
+		return ret;
 	}
 
 	/* command found */
@@ -2198,10 +2208,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	    !trace_parser_cont(parser)) {
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
+		trace_parser_clear(parser);
 		if (ret)
 			goto out_unlock;
-
-		trace_parser_clear(parser);
 	}
 
 	ret = read;
@@ -2543,10 +2552,9 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 					exists = true;
 					break;
 				}
-			if (!exists) {
+			if (!exists)
 				array[(*idx)++] = rec->ip;
-				found = 1;
-			}
+			found = 1;
 		}
 	} while_for_each_ftrace_rec();
 
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index e06c6e3..9f4f565 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -14,7 +14,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a1ca495..eccb4cf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1193,9 +1193,6 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	struct list_head *p;
 	unsigned i;
 
-	atomic_inc(&cpu_buffer->record_disabled);
-	synchronize_sched();
-
 	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
@@ -1211,12 +1208,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		return;
 
 	rb_reset_cpu(cpu_buffer);
-	spin_unlock_irq(&cpu_buffer->reader_lock);
-
 	rb_check_pages(cpu_buffer);
 
-	atomic_dec(&cpu_buffer->record_disabled);
-
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 static void
@@ -1227,9 +1221,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
-	atomic_inc(&cpu_buffer->record_disabled);
-	synchronize_sched();
-
 	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
@@ -1242,11 +1233,9 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add_tail(&bpage->list, cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
-	spin_unlock_irq(&cpu_buffer->reader_lock);
-
 	rb_check_pages(cpu_buffer);
 
-	atomic_dec(&cpu_buffer->record_disabled);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 /**
@@ -1254,11 +1243,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
  * @buffer: the buffer to resize.
  * @size: the new size.
  *
- * The tracer is responsible for making sure that the buffer is
- * not being used while changing the size.
- * Note: We may be able to change the above requirement by using
- *  RCU synchronizations.
- *
  * Minimum size is 2 * BUF_PAGE_SIZE.
  *
  * Returns -1 on failure.
@@ -1290,6 +1274,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	if (size == buffer_size)
 		return size;
 
+	atomic_inc(&buffer->record_disabled);
+
+	/* Make sure all writers are done with this buffer. */
+	synchronize_sched();
+
 	mutex_lock(&buffer->mutex);
 	get_online_cpus();
 
@@ -1352,6 +1341,8 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 
+	atomic_dec(&buffer->record_disabled);
+
 	return size;
 
  free_pages:
@@ -1361,6 +1352,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	}
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
+	atomic_dec(&buffer->record_disabled);
 	return -ENOMEM;
 
 	/*
@@ -1370,6 +1362,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
  out_fail:
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
+	atomic_dec(&buffer->record_disabled);
 	return -1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88bd9ae..ee61915 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -313,7 +313,6 @@ static const char *trace_options[] = {
 	"bin",
 	"block",
 	"stacktrace",
-	"sched-tree",
 	"trace_printk",
 	"ftrace_preempt",
 	"branch",
@@ -1151,6 +1150,22 @@ void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
 }
 
+/**
+ * trace_dump_stack - record a stack back trace in the trace buffer
+ */
+void trace_dump_stack(void)
+{
+	unsigned long flags;
+
+	if (tracing_disabled || tracing_selftest_running)
+		return;
+
+	local_save_flags(flags);
+
+	/* skipping 3 traces, seems to get us at the caller of this function */
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+}
+
 void
 ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
@@ -2316,67 +2331,49 @@ static const struct file_operations tracing_cpumask_fops = {
 	.write		= tracing_cpumask_write,
 };
 
-static ssize_t
-tracing_trace_options_read(struct file *filp, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
+static int tracing_trace_options_show(struct seq_file *m, void *v)
 {
 	struct tracer_opt *trace_opts;
 	u32 tracer_flags;
-	int len = 0;
-	char *buf;
-	int r = 0;
 	int i;
 
-
-	/* calculate max size */
-	for (i = 0; trace_options[i]; i++) {
-		len += strlen(trace_options[i]);
-		len += 3; /* "no" and newline */
-	}
-
 	mutex_lock(&trace_types_lock);
 	tracer_flags = current_trace->flags->val;
 	trace_opts = current_trace->flags->opts;
 
-	/*
-	 * Increase the size with names of options specific
-	 * of the current tracer.
-	 */
-	for (i = 0; trace_opts[i].name; i++) {
-		len += strlen(trace_opts[i].name);
-		len += 3; /* "no" and newline */
-	}
-
-	/* +1 for \0 */
-	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (!buf) {
-		mutex_unlock(&trace_types_lock);
-		return -ENOMEM;
-	}
-
 	for (i = 0; trace_options[i]; i++) {
 		if (trace_flags & (1 << i))
-			r += sprintf(buf + r, "%s\n", trace_options[i]);
+			seq_printf(m, "%s\n", trace_options[i]);
 		else
-			r += sprintf(buf + r, "no%s\n", trace_options[i]);
+			seq_printf(m, "no%s\n", trace_options[i]);
 	}
 
 	for (i = 0; trace_opts[i].name; i++) {
 		if (tracer_flags & trace_opts[i].bit)
-			r += sprintf(buf + r, "%s\n",
-				trace_opts[i].name);
+			seq_printf(m, "%s\n", trace_opts[i].name);
 		else
-			r += sprintf(buf + r, "no%s\n",
-				trace_opts[i].name);
+			seq_printf(m, "no%s\n", trace_opts[i].name);
 	}
 	mutex_unlock(&trace_types_lock);
 
-	WARN_ON(r >= len + 1);
+	return 0;
+}
 
-	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+static int __set_tracer_option(struct tracer *trace,
+			       struct tracer_flags *tracer_flags,
+			       struct tracer_opt *opts, int neg)
+{
+	int ret;
 
-	kfree(buf);
-	return r;
+	ret = trace->set_flag(tracer_flags->val, opts->bit, !neg);
+	if (ret)
+		return ret;
+
+	if (neg)
+		tracer_flags->val &= ~opts->bit;
+	else
+		tracer_flags->val |= opts->bit;
+	return 0;
 }
 
 /* Try to assign a tracer specific option */
@@ -2384,33 +2381,17 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 {
 	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
-	int ret = 0, i = 0;
-	int len;
+	int i;
 
 	for (i = 0; tracer_flags->opts[i].name; i++) {
 		opts = &tracer_flags->opts[i];
-		len = strlen(opts->name);
 
-		if (strncmp(cmp, opts->name, len) == 0) {
-			ret = trace->set_flag(tracer_flags->val,
-				opts->bit, !neg);
-			break;
-		}
+		if (strcmp(cmp, opts->name) == 0)
+			return __set_tracer_option(trace, trace->flags,
+						   opts, neg);
 	}
-	/* Not found */
-	if (!tracer_flags->opts[i].name)
-		return -EINVAL;
-
-	/* Refused to handle */
-	if (ret)
-		return ret;
-
-	if (neg)
-		tracer_flags->val &= ~opts->bit;
-	else
-		tracer_flags->val |= opts->bit;
 
-	return 0;
+	return -EINVAL;
 }
 
 static void set_tracer_flags(unsigned int mask, int enabled)
@@ -2430,7 +2411,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int ret;
 	int i;
@@ -2442,16 +2423,15 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
-	if (strncmp(buf, "no", 2) == 0) {
+	if (strncmp(cmp, "no", 2) == 0) {
 		neg = 1;
 		cmp += 2;
 	}
 
 	for (i = 0; trace_options[i]; i++) {
-		int len = strlen(trace_options[i]);
-
-		if (strncmp(cmp, trace_options[i], len) == 0) {
+		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
 			break;
 		}
@@ -2471,9 +2451,18 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_trace_options_open(struct inode *inode, struct file *file)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+	return single_open(file, tracing_trace_options_show, NULL);
+}
+
 static const struct file_operations tracing_iter_fops = {
-	.open		= tracing_open_generic,
-	.read		= tracing_trace_options_read,
+	.open		= tracing_trace_options_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= tracing_trace_options_write,
 };
 
@@ -3392,21 +3381,18 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
-				  size_t cnt, loff_t *ppos)
+static int tracing_clock_show(struct seq_file *m, void *v)
 {
-	char buf[64];
-	int bufiter = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
-		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
+		seq_printf(m,
 			"%s%s%s%s", i ? " " : "",
 			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
 			i == trace_clock_id ? "]" : "");
-	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
+	seq_putc(m, '\n');
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
+	return 0;
 }
 
 static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
@@ -3448,6 +3434,13 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_clock_open(struct inode *inode, struct file *file)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+	return single_open(file, tracing_clock_show, NULL);
+}
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -3486,8 +3479,10 @@ static const struct file_operations tracing_mark_fops = {
 };
 
 static const struct file_operations trace_clock_fops = {
-	.open		= tracing_open_generic,
-	.read		= tracing_clock_read,
+	.open		= tracing_clock_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= tracing_clock_write,
 };
 
@@ -3948,39 +3943,16 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	ret = 0;
-	switch (val) {
-	case 0:
-		/* do nothing if already cleared */
-		if (!(topt->flags->val & topt->opt->bit))
-			break;
-
-		mutex_lock(&trace_types_lock);
-		if (current_trace->set_flag)
-			ret = current_trace->set_flag(topt->flags->val,
-						      topt->opt->bit, 0);
-		mutex_unlock(&trace_types_lock);
-		if (ret)
-			return ret;
-		topt->flags->val &= ~topt->opt->bit;
-		break;
-	case 1:
-		/* do nothing if already set */
-		if (topt->flags->val & topt->opt->bit)
-			break;
+	if (val != 0 && val != 1)
+		return -EINVAL;
 
+	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
-		if (current_trace->set_flag)
-			ret = current_trace->set_flag(topt->flags->val,
-						      topt->opt->bit, 1);
+		ret = __set_tracer_option(current_trace, topt->flags,
+					  topt->opt, val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
 			return ret;
-		topt->flags->val |= topt->opt->bit;
-		break;
-
-	default:
-		return -EINVAL;
 	}
 
 	*ppos += cnt;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7fa33ca..1b18cb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,18 +597,17 @@ enum trace_iterator_flags {
 	TRACE_ITER_BIN			= 0x40,
 	TRACE_ITER_BLOCK		= 0x80,
 	TRACE_ITER_STACKTRACE		= 0x100,
-	TRACE_ITER_SCHED_TREE		= 0x200,
-	TRACE_ITER_PRINTK		= 0x400,
-	TRACE_ITER_PREEMPTONLY		= 0x800,
-	TRACE_ITER_BRANCH		= 0x1000,
-	TRACE_ITER_ANNOTATE		= 0x2000,
-	TRACE_ITER_USERSTACKTRACE       = 0x4000,
-	TRACE_ITER_SYM_USEROBJ          = 0x8000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
-	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
-	TRACE_ITER_LATENCY_FMT		= 0x40000,
-	TRACE_ITER_SLEEP_TIME		= 0x80000,
-	TRACE_ITER_GRAPH_TIME		= 0x100000,
+	TRACE_ITER_PRINTK		= 0x200,
+	TRACE_ITER_PREEMPTONLY		= 0x400,
+	TRACE_ITER_BRANCH		= 0x800,
+	TRACE_ITER_ANNOTATE		= 0x1000,
+	TRACE_ITER_USERSTACKTRACE       = 0x2000,
+	TRACE_ITER_SYM_USEROBJ          = 0x4000,
+	TRACE_ITER_PRINTK_MSGONLY	= 0x8000,
+	TRACE_ITER_CONTEXT_INFO		= 0x10000, /* Print pid/cpu/time */
+	TRACE_ITER_LATENCY_FMT		= 0x20000,
+	TRACE_ITER_SLEEP_TIME		= 0x40000,
+	TRACE_ITER_GRAPH_TIME		= 0x80000,
 };
 
 /*
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index d9c60f8..9e25573 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -25,7 +25,7 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	char *buf;
 	int ret = -ENOMEM;
 
-	if (atomic_inc_return(&event->profile_count))
+	if (event->profile_count++ > 0)
 		return 0;
 
 	if (!total_profile_count) {
@@ -56,7 +56,7 @@ fail_buf_nmi:
 		perf_trace_buf = NULL;
 	}
 fail_buf:
-	atomic_dec(&event->profile_count);
+	event->profile_count--;
 
 	return ret;
 }
@@ -83,7 +83,7 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 {
 	char *buf, *nmi_buf;
 
-	if (!atomic_add_negative(-1, &event->profile_count))
+	if (--event->profile_count > 0)
 		return;
 
 	event->profile_disable(event);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d18315..189b09b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(trace_define_field);
 	if (ret)							\
 		return ret;
 
-int trace_define_common_fields(struct ftrace_event_call *call)
+static int trace_define_common_fields(struct ftrace_event_call *call)
 {
 	int ret;
 	struct trace_entry ent;
@@ -91,7 +91,6 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(trace_define_common_fields);
 
 void trace_destroy_fields(struct ftrace_event_call *call)
 {
@@ -105,9 +104,25 @@ void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
-static void ftrace_event_enable_disable(struct ftrace_event_call *call,
+int trace_event_raw_init(struct ftrace_event_call *call)
+{
+	int id;
+
+	id = register_ftrace_event(call->event);
+	if (!id)
+		return -ENODEV;
+	call->id = id;
+	INIT_LIST_HEAD(&call->fields);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_event_raw_init);
+
+static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
+	int ret = 0;
+
 	switch (enable) {
 	case 0:
 		if (call->enabled) {
@@ -118,12 +133,20 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		break;
 	case 1:
 		if (!call->enabled) {
-			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc(call);
+			ret = call->regfunc(call);
+			if (ret) {
+				tracing_stop_cmdline_record();
+				pr_info("event trace: Could not enable event "
+					"%s\n", call->name);
+				break;
+			}
+			call->enabled = 1;
 		}
 		break;
 	}
+
+	return ret;
 }
 
 static void ftrace_clear_events(void)
@@ -402,7 +425,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	case 0:
 	case 1:
 		mutex_lock(&event_mutex);
-		ftrace_event_enable_disable(call, val);
+		ret = ftrace_event_enable_disable(call, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -412,7 +435,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	*ppos += cnt;
 
-	return cnt;
+	return ret ? ret : cnt;
 }
 
 static ssize_t
@@ -913,7 +936,9 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 		  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields(call);
+		ret = trace_define_common_fields(call);
+		if (!ret)
+			ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index dff8c84..458e5bf 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -184,10 +184,6 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 	struct struct_name field;					\
 	int ret;							\
 									\
-	ret = trace_define_common_fields(event_call);			\
-	if (ret)							\
-		return ret;						\
-									\
 	tstruct;							\
 									\
 	return ret;							\
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 3aa7eaa..2974bc7 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -151,6 +151,8 @@ check_critical_timing(struct trace_array *tr,
 		goto out_unlock;
 
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	/* Skip 5 functions to get to the irq/preempt enable function */
+	__trace_stack(tr, flags, 5, pc);
 
 	if (data->critical_sequence != max_sequence)
 		goto out_unlock;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b52d397..7ecab06 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1132,10 +1132,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct kprobe_trace_entry field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
-	ret = trace_define_common_fields(event_call);
-	if (ret)
-		return ret;
-
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
 	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
@@ -1150,10 +1146,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct kretprobe_trace_entry field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
-	ret = trace_define_common_fields(event_call);
-	if (ret)
-		return ret;
-
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
 	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
@@ -1453,7 +1445,6 @@ static int register_probe_event(struct trace_probe *tp)
 	call->unregfunc = probe_event_disable;
 
 #ifdef CONFIG_EVENT_PROFILE
-	atomic_set(&call->profile_count, -1);
 	call->profile_enable = probe_profile_enable;
 	call->profile_disable = probe_profile_disable;
 #endif
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index acb87d4..faf37fa 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -236,7 +236,8 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
+		ret = trace_seq_printf(s, "%pS:",
+				(void *)(unsigned long)entry->attr.bp_addr);
 		if (entry->attr.bp_type == HW_BREAKPOINT_R)
 			ret = trace_seq_puts(s, "r--\n");
 		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
@@ -278,21 +279,20 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
-	char *input_string, *ksymname = NULL;
+	char *buf, *input_string, *ksymname = NULL;
 	unsigned long ksym_addr = 0;
 	int ret, op, changed = 0;
 
-	input_string = kzalloc(count + 1, GFP_KERNEL);
-	if (!input_string)
+	buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
-	if (copy_from_user(input_string, buffer, count)) {
-		kfree(input_string);
-		return -EFAULT;
-	}
-	input_string[count] = '\0';
+	ret = -EFAULT;
+	if (copy_from_user(buf, buffer, count))
+		goto out;
 
-	strstrip(input_string);
+	buf[count] = '\0';
+	input_string = strstrip(buf);
 
 	/*
 	 * Clear all breakpoints if:
@@ -300,18 +300,16 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!input_string[0] || !strcmp(input_string, "0") ||
-	    !strcmp(input_string, "*:---")) {
+	if (!buf[0] || !strcmp(buf, "0") ||
+	    !strcmp(buf, "*:---")) {
 		__ksym_trace_reset();
-		kfree(input_string);
-		return count;
+		ret = 0;
+		goto out;
 	}
 
 	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
-	if (ret < 0) {
-		kfree(input_string);
-		return ret;
-	}
+	if (ret < 0)
+		goto out;
 
 	mutex_lock(&ksym_tracer_mutex);
 
@@ -322,7 +320,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 			if (entry->attr.bp_type != op)
 				changed = 1;
 			else
-				goto out;
+				goto out_unlock;
 			break;
 		}
 	}
@@ -337,28 +335,24 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 			if (IS_ERR(entry->ksym_hbp))
 				ret = PTR_ERR(entry->ksym_hbp);
 			else
-				goto out;
+				goto out_unlock;
 		}
 		/* Error or "symbol:---" case: drop it */
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry);
-		goto out;
+		goto out_unlock;
 	} else {
 		/* Check for malformed request: (4) */
-		if (op == 0)
-			goto out;
-		ret = process_new_ksym_entry(ksymname, op, ksym_addr);
+		if (op)
+			ret = process_new_ksym_entry(ksymname, op, ksym_addr);
 	}
-out:
+out_unlock:
 	mutex_unlock(&ksym_tracer_mutex);
-
-	kfree(input_string);
-
-	if (!ret)
-		ret = count;
-	return ret;
+out:
+	kfree(buf);
+	return !ret ? count : ret;
 }
 
 static const struct file_operations ksym_tracing_fops = {
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 57501d9..75289f3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -217,10 +217,6 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	int i;
 	int offset = offsetof(typeof(trace), args);
 
-	ret = trace_define_common_fields(call);
-	if (ret)
-		return ret;
-
 	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
 	if (ret)
 		return ret;
@@ -241,10 +237,6 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	struct syscall_trace_exit trace;
 	int ret;
 
-	ret = trace_define_common_fields(call);
-	if (ret)
-		return ret;
-
 	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
 	if (ret)
 		return ret;
@@ -333,10 +325,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter);
-	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
-	} else {
+	if (!ret) {
 		set_bit(num, enabled_enter_syscalls);
 		sys_refcount_enter++;
 	}
@@ -370,10 +359,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit);
-	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall exit trace point");
-	} else {
+	if (!ret) {
 		set_bit(num, enabled_exit_syscalls);
 		sys_refcount_exit++;
 	}
