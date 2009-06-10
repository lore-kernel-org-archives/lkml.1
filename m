Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZFJSjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZFJSjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZFJSjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:39:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZFJSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:39:23 -0400
Date: Wed, 10 Jun 2009 14:39:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: [PATCH][GIT PULL] tracing: do not translate event helper macros in
 print format
In-Reply-To: <alpine.DEB.2.00.0906101353200.30552@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0906101436340.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu> <alpine.DEB.2.00.0906100812370.30552@gandalf.stny.rr.com>
 <20090610171648.GD31096@elte.hu> <alpine.DEB.2.00.0906101353200.30552@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This looks like it changed more than it really did, I only moved the one 
macro above another and added a few lines:

 +#undef __print_symbolic
 +#undef __get_dynamic_array
 +#undef __get_str
 +

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (1):
      tracing: do not translate event helper macros in print format

----
 include/trace/ftrace.h |  158 ++++++++++++++++++++++++-----------------------
 1 files changed, 81 insertions(+), 77 deletions(-)
---------------------------
commit 6ff9a64d2aaa6eae396adc95e9c91c0cbfa6dbe4
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Jun 10 14:28:34 2009 -0400

    tracing: do not translate event helper macros in print format
    
    By moving the macro that creates the print format code above the
    defining of the event macro helpers (__get_str, __print_symbolic,
    and __get_dynamic_array), we get a little cleaner print format.
    
    Instead of:
    
      (char *)((void *)REC + REC->__data_loc_name)
    
    we get:
    
       __get_str(name)
    
    Instead of:
    
       ({ static const struct trace_print_flags symbols[] = { { HI_SOFTIRQ, "HI" }, {
    
    we get:
    
       __print_symbolic(REC->vec, { HI_SOFTIRQ, "HI" }, {
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 40ede4d..1867553 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -81,6 +81,87 @@
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
+ * Setup the showing format of trace point.
+ *
+ * int
+ * ftrace_format_##call(struct trace_seq *s)
+ * {
+ *	struct ftrace_raw_##call field;
+ *	int ret;
+ *
+ *	ret = trace_seq_printf(s, #type " " #item ";"
+ *			       " offset:%u; size:%u;\n",
+ *			       offsetof(struct ftrace_raw_##call, item),
+ *			       sizeof(field.type));
+ *
+ * }
+ */
+
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef __field
+#define __field(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __array
+#define __array(type, item, len)						\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)				       \
+	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
+			       "offset:%u;\tsize:%u;\n",		       \
+			       (unsigned int)offsetof(typeof(field),	       \
+					__data_loc_##item),		       \
+			       (unsigned int)sizeof(field.__data_loc_##item)); \
+	if (!ret)							       \
+		return 0;
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)
+
+#undef __entry
+#define __entry REC
+
+#undef __print_symbolic
+#undef __get_dynamic_array
+#undef __get_str
+
+#undef TP_printk
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct ftrace_raw_##call field __attribute__((unused));		\
+	int ret = 0;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
+									\
+	return ret;							\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
  * Stage 3 of the trace events.
  *
  * Override the macros in <trace/trace_events.h> to include the following:
@@ -179,83 +260,6 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-/*
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
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
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
-#undef __entry
-#define __entry REC
-
-#undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
-
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
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
-
-#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-
 #undef __field
 #define __field(type, item)						\
 	ret = trace_define_field(event_call, #type, #item,		\


