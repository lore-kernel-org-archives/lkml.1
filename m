Return-Path: <linux-kernel-owner+w=401wt.eu-S933053Ab0AFXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0AFXSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482Ab0AFXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:17:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab0AFXPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=28yl3zFSaEEA:10 a=omOdbC7AAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BIH4o_m_BeAvUYt43rEA:9 a=2oGbPECPMLd73OZoJEEA:7 a=Sy-CziVv4sagRp2yLCMvHhfTiyYA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231532.782397273@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 07/11] tracing: Remove show_format and related macros from TRACE_EVENT
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-show_format-and-related-macros-from-T.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The previous patches added the use of print_fmt string and changes
the trace_define_field() function to also create the fields and
format output for the event format files.

   text	   data	    bss	    dec	    hex	filename
5857201	1355780	9336808	16549789	 fc879d	vmlinux
5884589	1351684	9337896	16574169	 fce6d9	vmlinux-orig

The above shows the size of the vmlinux after this patch set
compared to the vmlinux-orig which is before the patch set.

This saves us 27k on text, 1k on bss and adds just 4k of data.

The total savings of 24k in size.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D4D.40604@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h  |    2 -
 include/linux/syscalls.h      |    2 -
 include/trace/ftrace.h        |  133 ++---------------------------------------
 include/trace/syscall.h       |    4 -
 kernel/trace/trace_events.c   |   12 ----
 kernel/trace/trace_export.c   |   73 ----------------------
 kernel/trace/trace_kprobe.c   |   78 ------------------------
 kernel/trace/trace_syscalls.c |   66 --------------------
 8 files changed, 6 insertions(+), 364 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index bd23d8e..84a5629 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -123,8 +123,6 @@ struct ftrace_event_call {
 	int			id;
 	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
-	int			(*show_format)(struct ftrace_event_call *,
-					       struct trace_seq *);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ed353d2..7b21969 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -144,7 +144,6 @@ struct perf_event_attr;
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
-		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
@@ -166,7 +165,6 @@ struct perf_event_attr;
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
-		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3351d85..df65b99 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -131,130 +131,6 @@
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
@@ -622,7 +498,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
- *	.show_format		= ftrace_format_<call>,
  * }
  *
  */
@@ -657,6 +532,12 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
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
@@ -750,7 +631,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##template,			\
-	.show_format		= ftrace_format_##template,		\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
 }
@@ -770,7 +650,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##call,			\
-	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
 }
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
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 250ec86..c2a3077 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -520,14 +520,6 @@ out:
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
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
@@ -965,10 +957,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 				  filter);
 	}
 
-	/* A trace may not want to export its format */
-	if (!call->show_format)
-		return 0;
-
 	trace_create_file("format", 0444, call->dir, call,
 			  format);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 95d14b6..e091f64 100644
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
@@ -235,7 +163,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.raw_init		= ftrace_raw_init_event,		\
 	.print_fmt		= print,				\
-	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##call,		\
 };									\
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 147491d..c990299 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1174,82 +1174,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __probe_event_show_format(struct trace_seq *s,
-				     struct trace_probe *tp, const char *fmt,
-				     const char *arg)
-{
-	int i;
-
-	/* Show format */
-	if (!trace_seq_printf(s, "\nprint fmt: \"%s", fmt))
-		return 0;
-
-	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_printf(s, " %s=%%lx", tp->args[i].name))
-			return 0;
-
-	if (!trace_seq_printf(s, "\", %s", arg))
-		return 0;
-
-	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_printf(s, ", REC->%s", tp->args[i].name))
-			return 0;
-
-	return trace_seq_puts(s, "\n");
-}
-
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
-
-static int kprobe_event_show_format(struct ftrace_event_call *call,
-				    struct trace_seq *s)
-{
-	struct kprobe_trace_entry field __attribute__((unused));
-	int ret, i;
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	SHOW_FIELD(unsigned long, ip, FIELD_STRING_IP);
-	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
-
-	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++)
-		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
-	trace_seq_puts(s, "\n");
-
-	return __probe_event_show_format(s, tp, "(%lx)",
-					 "REC->" FIELD_STRING_IP);
-}
-
-static int kretprobe_event_show_format(struct ftrace_event_call *call,
-				       struct trace_seq *s)
-{
-	struct kretprobe_trace_entry field __attribute__((unused));
-	int ret, i;
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	SHOW_FIELD(unsigned long, func, FIELD_STRING_FUNC);
-	SHOW_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP);
-	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
-
-	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++)
-		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
-	trace_seq_puts(s, "\n");
-
-	return __probe_event_show_format(s, tp, "(%lx <- %lx)",
-					 "REC->" FIELD_STRING_FUNC
-					 ", REC->" FIELD_STRING_RETIP);
-}
-
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 {
 	int i;
@@ -1504,12 +1428,10 @@ static int register_probe_event(struct trace_probe *tp)
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
 	if (set_print_fmt(tp) < 0)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a78e863..49cea70 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -143,54 +143,6 @@ extern char *__bad_type_size(void);
 		#type, #name, offsetof(typeof(trace), name),		\
 		sizeof(trace.name), is_signed_type(type)
 
-int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
-{
-	int i;
-	int ret;
-	struct syscall_metadata *entry = call->data;
-	struct syscall_trace_enter trace;
-	int offset = offsetof(struct syscall_trace_enter, args);
-
-	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n",
-			       SYSCALL_FIELD(int, nr));
-	if (!ret)
-		return 0;
-
-	for (i = 0; i < entry->nb_args; i++) {
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
-	}
-
-	trace_seq_puts(s, "\nprint fmt: \"");
-	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
-				        sizeof(unsigned long),
-					i == entry->nb_args - 1 ? "" : ", ");
-		if (!ret)
-			return 0;
-	}
-	trace_seq_putc(s, '"');
-
-	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, ", ((unsigned long)(REC->%s))",
-				       entry->args[i]);
-		if (!ret)
-			return 0;
-	}
-
-	return trace_seq_putc(s, '\n');
-}
-
 static
 int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
 {
@@ -252,24 +204,6 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
-{
-	int ret;
-	struct syscall_trace_exit trace;
-
-	ret = trace_seq_printf(s,
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n"
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
-			       "\tsigned:%u;\n",
-			       SYSCALL_FIELD(int, nr),
-			       SYSCALL_FIELD(long, ret));
-	if (!ret)
-		return 0;
-
-	return trace_seq_printf(s, "\nprint fmt: \"0x%%lx\", REC->ret\n");
-}
-
 int syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
-- 
1.6.5


