Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZG3Hj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZG3Hj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZG3Hj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:39:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZG3HjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:39:25 -0400
Message-ID: <4A714E44.2060301@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 15:39:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip V3] tracing: use defined fields to print formats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that ftrace_format_##call() and ftrace_define_fields_##call()
are duplicate more or less.

trace_define_field() defines fields and links them into
strcut ftrace_event_call. We reuse them to print formats
and remove ftrace_format_##call(). It make all things simpler.

TRACE_EVENT_FORMAT_NOFILTER is dropped. Because we should
"trace_define_field()" fields for all struct ftrace_event_call,
even it's no filter.

The advantages of this fix:

1) A big function ftrace_format_##call() is defined
for every event type. It waste a lot of memory.
this patch saves these memory.

2) Reduce coupling: ftrace_format_##call() and
ftrace_define_fields_##call() are almost the same.
We need to maintain them together, it's not good design.

What have been changed for the foramt file after this fix applied:

1) tracing/events/block/block_rq_abort/format:
	field:__data_loc char[] cmd;	offset:36;	size:4;
==>
	field:__data_loc char cmd[];	offset:36;	size:4;

"[]" is added for __dynamic_array() in tip-tree several days ago,
it's not in stable kernel yet. It will not break userland tools.
This change makes __dynamic_array() and __array() are the same style.

2) tracing/events/ftrace/branch/format:
	field special:char func[TRACE_FUNC_SIZE+1];	offset:16;	size:31;
	field special:char file[TRACE_FUNC_SIZE+1];	offset:47;	size:21;
==>
	field:char func[TRACE_FUNC_SIZE+1];	offset:16;	size:31;
	field:char file[TRACE_FUNC_SIZE+1];	offset:47;	size:21;

This format is exactly the same as __array(). So " special" is not needed.
TRACE_FIELD_SPECIAL() is renamed to TRACE_FIELD_ARRAY().
Userland parser for parsing __array() will parse this correctly.

3) tracing/events/ftrace/bprint/format:
	field:char buf;	offset:20;	size:0;
==>
	field:u32 buf[];	offset:20;	size:0;
   tracing/events/ftrace/print/format:
	field:char buf;	offset:16;	size:0;
==>
	field:char buf[];	offset:16;	size:0;

Make its format more correct.

changed from v1:
   carefully compare the old and the new format, and fix the difference.

changed from v2:
   make __array() generates TYPE ITEM[LEN] again.
   changelog itself contains full details.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h     |    2
 include/trace/ftrace.h           |   79 +++------------------------
 kernel/trace/trace.h             |    2
 kernel/trace/trace_event_types.h |   12 +---
 kernel/trace/trace_events.c      |   69 +++++++++++------------
 kernel/trace/trace_export.c      |  114 +++++----------------------------------
 6 files changed, 66 insertions(+), 212 deletions(-)
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..738b33d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -111,8 +111,8 @@ struct ftrace_event_call {
 	int			(*regfunc)(void);
 	void			(*unregfunc)(void);
 	int			id;
+	const char		*print_fmt;
 	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
 	int			(*define_fields)(void);
 	struct list_head	fields;
 	int			filter_active;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3cbb96e..163cd78 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -82,56 +82,11 @@
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
- * Setup the showing format of trace point.
+ * Setup the print format of trace point.
  *
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
+ * static const char *print_fmt_<call> = <TP_printk>;
  */
 
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef __field
-#define __field(type, item)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __array
-#define __array(type, item, len)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __dynamic_array
-#define __dynamic_array(type, item, len)				       \
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
-			       "offset:%u;\tsize:%u;\n",		       \
-			       (unsigned int)offsetof(typeof(field),	       \
-					__data_loc_##item),		       \
-			       (unsigned int)sizeof(field.__data_loc_##item)); \
-	if (!ret)							       \
-		return 0;
-
-#undef __string
-#define __string(item, src) __dynamic_array(char, item, -1)
-
 #undef __entry
 #define __entry REC
 
@@ -140,25 +95,11 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
-
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
+#define TP_printk(fmt, args...) #fmt ", "  __stringify(args)
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field __attribute__((unused));		\
-	int ret = 0;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
-									\
-	return ret;							\
-}
+static const char *print_fmt_##call = print;
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -296,7 +237,7 @@ ftrace_define_fields_##call(void)					\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	int ret;							\
 									\
-	__common_field(int, type, 1);					\
+	__common_field(unsigned short, type, 1);			\
 	__common_field(unsigned char, flags, 0);			\
 	__common_field(unsigned char, preempt_count, 0);		\
 	__common_field(int, pid, 1);					\
@@ -429,6 +370,7 @@ static inline int ftrace_get_offsets_##call(				\
  *	if (!id)
  *		return -ENODEV;
  *	event_<call>.id = id;
+	event_<call>.print_fmt = print_fmt_<call>;
  *	return 0;
  * }
  *
@@ -440,14 +382,10 @@ static inline int ftrace_get_offsets_##call(				\
  *	.raw_init		= ftrace_raw_init_event_<call>,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
- *	.show_format		= ftrace_format_<call>,
  * }
  *
  */
 
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
 #ifdef CONFIG_EVENT_PROFILE
 #define _TRACE_PROFILE(call, proto, args)				\
 static void ftrace_profile_##call(proto)				\
@@ -502,6 +440,9 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), src);
 
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 _TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
@@ -567,6 +508,7 @@ static int ftrace_raw_init_event_##call(void)				\
 	if (!id)							\
 		return -ENODEV;						\
 	event_##call.id = id;						\
+	event_##call.print_fmt = print_fmt_##call;			\
 	INIT_LIST_HEAD(&event_##call.fields);				\
 	init_preds(&event_##call);					\
 	return 0;							\
@@ -581,7 +523,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##call,		\
 	_TRACE_PROFILE_INIT(call)					\
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 06886a0..1551c45 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -867,8 +867,6 @@ extern const char *__stop___trace_bprintk_fmt[];
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 	extern struct ftrace_event_call event_##call;
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
 #include "trace_event_types.h"
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 6db005e..82534b5 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -60,7 +60,7 @@ TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
 	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
 );
 
-TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
+TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, arg1, arg1)
 		TRACE_FIELD(unsigned long, arg2, arg2)
@@ -109,7 +109,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(char *, fmt, fmt)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_DYNAMIC_ARRAY(u32, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
@@ -117,7 +117,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_DYNAMIC_ARRAY(char, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
@@ -125,10 +125,8 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
-		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
-				    TRACE_FUNC_SIZE+1, func)
-		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
-				    TRACE_FUNC_SIZE+1, file)
+		TRACE_FIELD_ARRAY(char, func, TRACE_FUNC_SIZE+1, func)
+		TRACE_FIELD_ARRAY(char, file, TRACE_FUNC_SIZE+1, file)
 		TRACE_FIELD(char, correct, correct)
 	),
 	TP_RAW_FMT("%u:%s:%s (%u)")
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cf936..d799961 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -47,7 +47,7 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
-	list_add(&field->link, &call->fields);
+	list_add_tail(&field->link, &call->fields);
 
 	return 0;
 
@@ -524,41 +524,16 @@ out:
 	return ret;
 }
 
-extern char *__bad_type_size(void);
-
-#undef FIELD
-#define FIELD(type, name)						\
-	sizeof(type) != sizeof(field.name) ? __bad_type_size() :	\
-	#type, "common_" #name, offsetof(typeof(field), name),		\
-		sizeof(field.name)
-
-static int trace_write_header(struct trace_seq *s)
-{
-	struct trace_entry field;
-
-	/* struct trace_entry */
-	return trace_seq_printf(s,
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\n",
-				FIELD(unsigned short, type),
-				FIELD(unsigned char, flags),
-				FIELD(unsigned char, preempt_count),
-				FIELD(int, pid),
-				FIELD(int, tgid));
-}
-
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_field *field;
 	struct trace_seq *s;
+	int common_field_count = 5;
 	char *buf;
-	int r;
+	int r = 0;
 
 	if (*ppos)
 		return 0;
@@ -569,14 +544,40 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	/* If any of the first writes fail, so will the show_format. */
+	/* If any of the first writes fail, so will the formats. */
 
 	trace_seq_printf(s, "name: %s\n", call->name);
 	trace_seq_printf(s, "ID: %d\n", call->id);
 	trace_seq_printf(s, "format:\n");
-	trace_write_header(s);
 
-	r = call->show_format(s);
+	list_for_each_entry(field, &call->fields, link) {
+		const char *array_descriptor = strchr(field->type, '[');
+		if (!array_descriptor) {
+			r = trace_seq_printf(s, "\tfield:%s %s;"
+					"\toffset:%u;\tsize:%u;\n",
+					field->type, field->name,
+					field->offset, field->size);
+		} else {
+			r = trace_seq_printf(s, "\tfield:%.*s %s%s;"
+					"\toffset:%u;\tsize:%u;\n",
+					array_descriptor - field->type,
+					field->type, field->name,
+					array_descriptor,
+					field->offset, field->size);
+		}
+
+		if (--common_field_count == 0)
+			r = trace_seq_printf(s, "\n");
+
+		if (!r)
+			break;
+	}
+
+	if (r) {
+		r = trace_seq_printf(s, "\nprint fmt: %s\n",
+				call->print_fmt);
+	}
+
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
@@ -986,10 +987,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 					  filter);
 	}
 
-	/* A trace may not want to export its format */
-	if (!call->show_format)
-		return 0;
-
 	entry = trace_create_file("format", 0444, call->dir, call,
 				  format);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d06cf89..30ff2dd 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -19,77 +19,6 @@
 #undef TRACE_STRUCT
 #define TRACE_STRUCT(args...) args
 
-extern void __bad_type_size(void);
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	if (sizeof(type) != sizeof(field.item))				\
-		__bad_type_size();					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
-	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
-			       "offset:%u;\tsize:0;\n",			\
-			       (unsigned int)offsetof(typeof(field), item)); \
-	if (!ret)							\
-		return 0;
-
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
-	TRACE_FIELD(type, item, assign)
-
-#undef TP_RAW_FMT
-#define TP_RAW_FMT(args...) args
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct args field;						\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
-									\
-	return ret;							\
-}
-
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)				\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct args field;						\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
-									\
-	return ret;							\
-}
-
-#include "trace_event_types.h"
-
 #undef TRACE_ZERO_CHAR
 #define TRACE_ZERO_CHAR(arg)
 
@@ -111,10 +40,13 @@ ftrace_format_##call(struct trace_seq *s)				\
 #undef TRACE_ENTRY
 #define TRACE_ENTRY	entry
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
+#undef TRACE_FIELD_ARRAY
+#define TRACE_FIELD_ARRAY(type_item, item, len, cmd)	\
 	cmd;
 
+#undef TP_RAW_FMT
+#define TP_RAW_FMT(args...) args
+
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 int ftrace_define_fields_##call(void);					\
@@ -124,10 +56,10 @@ struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.id			= proto,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.id			= proto,				\
+	.print_fmt		= "\"" tpfmt "\"",			\
 	.raw_init		= ftrace_raw_init_event_##call,		\
-	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##call,		\
 };									\
 static int ftrace_raw_init_event_##call(void)				\
@@ -137,19 +69,6 @@ static int ftrace_raw_init_event_##call(void)				\
 	return 0;							\
 }									\
 
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)				\
-									\
-struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.id			= proto,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.show_format		= ftrace_format_##call,			\
-};
-
 #include "trace_event_types.h"
 
 #undef TRACE_FIELD
@@ -160,8 +79,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
+#undef TRACE_FIELD_ARRAY
+#define TRACE_FIELD_ARRAY(type, item, len, cmd)				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item), 0);		\
@@ -176,8 +95,13 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)
+#undef TRACE_FIELD_DYNAMIC_ARRAY
+#define TRACE_FIELD_DYNAMIC_ARRAY(type, item)				\
+	ret = trace_define_field(event_call, #type "[]", #item,		\
+				 offsetof(typeof(field), item),		\
+				 0, is_signed_type(type));		\
+	if (ret)							\
+		return ret;
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
@@ -188,7 +112,7 @@ ftrace_define_fields_##call(void)					\
 	struct args field;						\
 	int ret;							\
 									\
-	__common_field(unsigned char, type, 0);				\
+	__common_field(unsigned short, type, 0);			\
 	__common_field(unsigned char, flags, 0);			\
 	__common_field(unsigned char, preempt_count, 0);		\
 	__common_field(int, pid, 1);					\
@@ -199,8 +123,4 @@ ftrace_define_fields_##call(void)					\
 	return ret;							\
 }
 
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)
-
 #include "trace_event_types.h"



