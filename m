Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZCFDUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZCFDUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZCFDTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:19:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCFDTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:19:44 -0500
Message-Id: <20090306031941.814968617@goodmis.org>
References: <20090306031857.686507907@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 22:18:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] tracing: move print of event format to separate file
Content-Disposition: inline; filename=0002-tracing-move-print-of-event-format-to-separate-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Move the macro that creates the event format file to a separate header.
This will allow the default ftrace events to use this same macro
to create the formats to read those events.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events_stage_2.h |   53 +---------------------------------
 kernel/trace/trace_format.h         |   55 +++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 52 deletions(-)
 create mode 100644 kernel/trace/trace_format.h

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index b1cebba..d24a97e 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -75,56 +75,5 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #include <trace/trace_event_types.h>
 
-/*
- * Setup the showing format of trace point.
- *
- * int
- * ftrace_format_##call(struct trace_seq *s)
- * {
- * 	struct ftrace_raw_##call field;
- * 	int ret;
- *
- * 	ret = trace_seq_printf(s, #type " " #item ";"
- * 			       " size:%d; offset:%d;\n",
- * 			       sizeof(field.type),
- * 			       offsetof(struct ftrace_raw_##call,
- * 					item));
- *
- * }
- */
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%lu;\tsize:%lu;\n",		\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item));			\
-	if (!ret)							\
-		return 0;
-
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
-	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%lu;\tsize:%lu;\n",		\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item));			\
-	if (!ret)							\
-		return 0;
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int									\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field;					\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
-									\
-	return ret;							\
-}
-
+#include "trace_format.h"
 #include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_format.h b/kernel/trace/trace_format.h
new file mode 100644
index 0000000..53a6b13
--- /dev/null
+++ b/kernel/trace/trace_format.h
@@ -0,0 +1,55 @@
+/*
+ * Setup the showing format of trace point.
+ *
+ * int
+ * ftrace_format_##call(struct trace_seq *s)
+ * {
+ *	struct ftrace_raw_##call field;
+ *	int ret;
+ *
+ *	ret = trace_seq_printf(s, #type " " #item ";"
+ *			       " size:%d; offset:%d;\n",
+ *			       sizeof(field.type),
+ *			       offsetof(struct ftrace_raw_##call,
+ *					item));
+ *
+ * }
+ */
+
+#undef TRACE_STRUCT
+#define TRACE_STRUCT(args...) args
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%lu;\tsize:%lu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
+	if (!ret)							\
+		return 0;
+
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
+	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
+			       "offset:%lu;\tsize:%lu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
+	if (!ret)							\
+		return 0;
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int									\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct ftrace_raw_##call field;					\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+									\
+	return ret;							\
+}
+
-- 
1.6.1.3

-- 
