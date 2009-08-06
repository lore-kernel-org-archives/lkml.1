Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZHFGHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZHFGHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZHFGHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:07:51 -0400
Received: from [222.73.24.84] ([222.73.24.84]:54634 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZHFGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:07:50 -0400
Message-ID: <4A7A72DF.6030009@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 14:06:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <f.weisbecker@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/filters: Add __field_ext() to TRACE_EVENT
References: <4A7A72BD.5030201@cn.fujitsu.com>
In-Reply-To: <4A7A72BD.5030201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __field_ext(), so a field can be assigned to a specific
filter_type, which matches a corresponding filter function.

For example, a later patch will allow this:
	__field_ext(const char *, str, FILTER_PTR_STR);

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |   11 +++++++++--
 include/trace/ftrace.h             |   28 ++++++++++++++++++++++------
 kernel/trace/trace_events.c        |    9 +++++++--
 kernel/trace/trace_events_filter.c |    6 ------
 kernel/trace/trace_export.c        |    7 ++++---
 5 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 26d3673..14c388e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -138,8 +138,15 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
+enum {
+	FILTER_STATIC_STRING = 1,
+	FILTER_DYN_STRING,
+	FILTER_OTHER,
+};
+
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size, int is_signed);
+			      char *name, int offset, int size,
+			      int is_signed, int filter_type);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
@@ -167,7 +174,7 @@ do {									\
 #define __common_field(type, item, is_signed)				\
 	ret = trace_define_field(event_call, #type, "common_" #item,	\
 				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item), is_signed);	\
+				 sizeof(field.ent.item), is_signed, -1);\
 	if (ret)							\
 		return ret;
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 380b603..8d8518f 100644
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
 
@@ -64,6 +67,9 @@
 #undef __field
 #define __field(type, item);
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type);
+
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
@@ -264,28 +273,32 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	
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
+#define __field(type, item)	__field_ext(type, item, -1)
+
 #undef __array
 #define __array(type, item, len)					\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, -1);		\
 	if (ret)							\
 		return ret;
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
 	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
-				offsetof(typeof(field), __data_loc_##item),    \
-				 sizeof(field.__data_loc_##item), 0);
+				 offsetof(typeof(field), __data_loc_##item),   \
+				 sizeof(field.__data_loc_##item), 0, -1);
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -322,6 +335,9 @@ ftrace_define_fields_##call(void)					\
 #undef __field
 #define __field(type, item)
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 71b2085..0cbad89 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -28,7 +28,8 @@ DEFINE_MUTEX(event_mutex);
 LIST_HEAD(ftrace_events);
 
 int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size, int is_signed)
+		       char *name, int offset, int size,
+		       int is_signed, int filter_type)
 {
 	struct ftrace_event_field *field;
 
@@ -44,7 +45,11 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 	if (!field->type)
 		goto err;
 
-	field->filter_type = filter_assign_type(type);
+	if (filter_type == -1)
+		field->filter_type = filter_assign_type(type);
+	else
+		field->filter_type = filter_type;
+
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4c8c5fd..5e7f031 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -475,12 +475,6 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 	return 0;
 }
 
-enum {
-	FILTER_STATIC_STRING = 1,
-	FILTER_DYN_STRING,
-	FILTER_OTHER,
-};
-
 int filter_assign_type(const char *type)
 {
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d06cf89..4a9f273 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -156,7 +156,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed_type(type));	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), -1);		\
 	if (ret)							\
 		return ret;
 
@@ -164,7 +165,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, -1);		\
 	if (ret)							\
 		return ret;
 
@@ -172,7 +173,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed);	\
+				 sizeof(field.item), is_signed, -1);	\
 	if (ret)							\
 		return ret;
 
-- 
1.6.3

