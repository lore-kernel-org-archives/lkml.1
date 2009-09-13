Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZIMDrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZIMDrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZIMDrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:47:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZIMDqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:34 -0400
Message-Id: <20090913034637.089054131@goodmis.org>
References: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] tracing: use the new trace_entries.h to create format files
Content-Disposition: inline; filename=0004-tracing-use-the-new-trace_entries.h-to-create-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch changes the way the format files in

  debugfs/tracing/events/ftrace/*/format

are created. It uses the new trace_entries.h file to automate the
creation of the format files to ensure that they are always in sync
with the actual structures. This is the same methodology used to
create the format files for the TRACE_EVENT macro.

This also updates the filter creation that was built on the creation
of the format files.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |   12 ++-
 kernel/trace/trace_events.c |    1 +
 kernel/trace/trace_export.c |  241 +++++++++++++++++++++++--------------------
 3 files changed, 136 insertions(+), 118 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b0d287d..86bcff9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -7,6 +7,7 @@
 #include <linux/clocksource.h>
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
+#include <linux/tracepoint.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
@@ -746,11 +747,12 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call event_##call;
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
-#include "trace_event_types.h"
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
+	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#include "trace_entries.h"
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f46d14c..adbed12 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -21,6 +21,7 @@
 
 #include "trace_output.h"
 
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
 DEFINE_MUTEX(event_mutex);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index df1bf6e..4cb29d8 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -15,82 +15,163 @@
 
 #include "trace_output.h"
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	ftrace
 
-#undef TRACE_STRUCT
-#define TRACE_STRUCT(args...) args
+/* not needed for this file */
+#undef __field_struct
+#define __field_struct(type, item)
 
-extern void __bad_type_size(void);
+#undef __field
+#define __field(type, item)						\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
+	if (!ret)							\
+		return 0;
 
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	if (sizeof(type) != sizeof(field.item))				\
-		__bad_type_size();					\
+#undef __field_desc
+#define __field_desc(type, container, item)				\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), container.item),	\
+			       sizeof(field.container.item));		\
 	if (!ret)							\
 		return 0;
 
+#undef __array
+#define __array(type, item, len)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), item),	\
+			       sizeof(field.item));		\
+	if (!ret)							\
+		return 0;
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
-	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+#undef __array_desc
+#define __array_desc(type, container, item, len)			\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), container.item),	\
+			       sizeof(field.container.item));		\
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
-			       "offset:%u;\tsize:0;\n",			\
-			       (unsigned int)offsetof(typeof(field), item)); \
+#undef __dynamic_array
+#define __dynamic_array(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%zu;\tsize:0;\n",		\
+			       offsetof(typeof(field), item));		\
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
-	TRACE_FIELD(type, item, assign)
+#undef F_printk
+#define F_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
-#undef TP_RAW_FMT
-#define TP_RAW_FMT(args...) args
+#undef __entry
+#define __entry REC
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
 static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
+ftrace_format_##name(struct ftrace_event_call *unused,			\
+		     struct trace_seq *s)				\
 {									\
-	struct args field;						\
-	int ret;							\
+	struct struct_name field __attribute__((unused));		\
+	int ret = 0;							\
 									\
 	tstruct;							\
 									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
 									\
 	return ret;							\
 }
 
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)				\
-static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
+#include "trace_entries.h"
+
+
+#undef __field
+#define __field(type, item)						\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
+	if (ret)							\
+		return ret;
+
+#undef __field_desc
+#define __field_desc(type, container, item)	\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field),		\
+					  container.item),		\
+				 sizeof(field.container.item),		\
+				 is_signed_type(type), FILTER_OTHER);	\
+	if (ret)							\
+		return ret;
+
+#undef __array
+#define __array(type, item, len)					\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), 0, FILTER_OTHER);	\
+	if (ret)							\
+		return ret;
+
+#undef __array_desc
+#define __array_desc(type, container, item, len)			\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field),		\
+					  container.item),		\
+				 sizeof(field.container.item), 0,	\
+				 FILTER_OTHER);				\
+	if (ret)							\
+		return ret;
+
+#undef __dynamic_array
+#define __dynamic_array(type, item)
+
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
+int									\
+ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
-	struct args field;						\
+	struct struct_name field;					\
 	int ret;							\
 									\
-	tstruct;							\
+	ret = trace_define_common_fields(event_call);			\
+	if (ret)							\
+		return ret;						\
 									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+	tstruct;							\
 									\
 	return ret;							\
 }
 
-#include "trace_event_types.h"
+#include "trace_entries.h"
+
+
+#undef __field
+#define __field(type, item)
+
+#undef __field_desc
+#define __field_desc(type, container, item)
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __array_desc
+#define __array_desc(type, container, item, len)
+
+#undef __dynamic_array
+#define __dynamic_array(type, item)
+
 
 #undef TRACE_ZERO_CHAR
 #define TRACE_ZERO_CHAR(arg)
@@ -117,16 +198,15 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
 	cmd;
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int ftrace_define_fields_##call(struct ftrace_event_call *event_call);	\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
 static int ftrace_raw_init_event_##call(void);				\
 									\
 struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.id			= proto,				\
+	.id			= type,					\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.show_format		= ftrace_format_##call,			\
@@ -138,69 +218,4 @@ static int ftrace_raw_init_event_##call(void)				\
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
-#include "trace_event_types.h"
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	ret = trace_define_field(event_call, #type, #item,		\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
-	if (ret)							\
-		return ret;
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
-	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0, FILTER_OTHER);	\
-	if (ret)							\
-		return ret;
-
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
-	ret = trace_define_field(event_call, #type, #item,		\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed,		\
-				 FILTER_OTHER);				\
-	if (ret)							\
-		return ret;
-
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int									\
-ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
-{									\
-	struct args field;						\
-	int ret;							\
-									\
-	ret = trace_define_common_fields(event_call);			\
-	if (ret)							\
-		return ret;						\
-									\
-	tstruct;							\
-									\
-	return ret;							\
-}
-
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)
-
-#include "trace_event_types.h"
+#include "trace_entries.h"
-- 
1.6.3.3

-- 
