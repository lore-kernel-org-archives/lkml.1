Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZHZFA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZHZFA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZHZFAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbZHZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:50 -0400
Message-Id: <20090826050051.498927303@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/8] tracing/filters: Add __field_ext() to TRACE_EVENT
Content-Disposition: inline; filename=0004-tracing-filters-Add-__field_ext-to-TRACE_EVENT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Add __field_ext(), so a field can be assigned to a specific
filter_type, which matches a corresponding filter function.

For example, a later patch will allow this:
	__field_ext(const char *, str, FILTER_PTR_STR);

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A7B9272.6050709@cn.fujitsu.com>

[
  Fixed a -1 to FILTER_OTHER
  Forward ported to latest kernel.
]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    9 ++++++++-
 include/trace/ftrace.h             |   31 ++++++++++++++++++++++++-------
 kernel/trace/trace_events.c        |   11 ++++++++---
 kernel/trace/trace_events_filter.c |    6 ------
 kernel/trace/trace_export.c        |    8 +++++---
 kernel/trace/trace_syscalls.c      |    6 ++++--
 6 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index df5b085..0440bea 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -140,9 +140,16 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
+enum {
+	FILTER_OTHER = 0,
+	FILTER_STATIC_STRING,
+	FILTER_DYN_STRING,
+};
+
 extern int trace_define_field(struct ftrace_event_call *call,
 			      const char *type, const char *name,
-			      int offset, int size, int is_signed);
+			      int offset, int size, int is_signed,
+			      int filter_type);
 extern int trace_define_common_fields(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1274002..1b1f742 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -21,6 +21,9 @@
 #undef __field
 #define __field(type, item)		type	item;
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)	type	item;
+
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
@@ -62,7 +65,10 @@
  */
 
 #undef __field
-#define __field(type, item);
+#define __field(type, item)
+
+#undef __field_ext
+#define __field_ext(type, item, filter_type)
 
 #undef __array
 #define __array(type, item, len)
@@ -110,6 +116,9 @@
 	if (!ret)							\
 		return 0;
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)	__field(type, item)
+
 #undef __array
 #define __array(type, item, len)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
@@ -265,28 +274,33 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef __field
-#define __field(type, item)						\
+#undef __field_ext
+#define __field_ext(type, item, filter_type)				\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed_type(type));	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
+#undef __field
+#define __field(type, item)	__field_ext(type, item, FILTER_OTHER)
+
 #undef __array
 #define __array(type, item, len)					\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
 	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
-				offsetof(typeof(field), __data_loc_##item),    \
-				 sizeof(field.__data_loc_##item), 0);
+				 offsetof(typeof(field), __data_loc_##item),   \
+				 sizeof(field.__data_loc_##item), 0,	       \
+				 FILTER_OTHER);
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -320,6 +334,9 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __field
 #define __field(type, item)
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5740e90..d33bcde 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -28,7 +28,8 @@ DEFINE_MUTEX(event_mutex);
 LIST_HEAD(ftrace_events);
 
 int trace_define_field(struct ftrace_event_call *call, const char *type,
-		       const char *name, int offset, int size, int is_signed)
+		       const char *name, int offset, int size, int is_signed,
+		       int filter_type)
 {
 	struct ftrace_event_field *field;
 
@@ -44,7 +45,11 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	if (!field->type)
 		goto err;
 
-	field->filter_type = filter_assign_type(type);
+	if (filter_type == FILTER_OTHER)
+		field->filter_type = filter_assign_type(type);
+	else
+		field->filter_type = filter_type;
+
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
@@ -68,7 +73,7 @@ EXPORT_SYMBOL_GPL(trace_define_field);
 	ret = trace_define_field(call, #type, "common_" #item,		\
 				 offsetof(typeof(ent), item),		\
 				 sizeof(ent.item),			\
-				 is_signed_type(type));			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 22e6d82..8a8e576 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -475,12 +475,6 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 	return 0;
 }
 
-enum {
-	FILTER_OTHER = 0,
-	FILTER_STATIC_STRING,
-	FILTER_DYN_STRING,
-};
-
 int filter_assign_type(const char *type)
 {
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7087530..029a91f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -158,7 +158,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed_type(type));	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -166,7 +167,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -174,7 +175,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed);	\
+				 sizeof(field.item), is_signed,		\
+				 FILTER_OTHER);				\
 	if (ret)							\
 		return ret;
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 46c1b97..97a2454 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -194,7 +194,8 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	for (i = 0; i < meta->nb_args; i++) {
 		ret = trace_define_field(call, meta->types[i],
 					 meta->args[i], offset,
-					 sizeof(unsigned long), 0);
+					 sizeof(unsigned long), 0,
+					 FILTER_OTHER);
 		offset += sizeof(unsigned long);
 	}
 
@@ -210,7 +211,8 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
-	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0);
+	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
+				 FILTER_OTHER);
 
 	return ret;
 }
-- 
1.6.3.3

-- 
