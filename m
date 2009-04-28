Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbZD1IGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbZD1IGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZD1IE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:04:59 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:57215 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbZD1IE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FXi0bIIaJNPxjCalJw2SaO78Iy3RvNiyB0+BRXtWUErCj7h1pCXrR99ZmSXLnb10LN
         OEF0O+DhVGfIa4NPeYsT1YjBO+Cg373U3IYZ0oDlCIOcRmwew07pmHaHbmpMV8MIcsX4
         stfb6vfKHWHUzNsPB7ovjLZRjQKLI+RqsUUTk=
Subject: [PATCH 2/3] tracing/filters: distinguish between signed and
 unsigned fields
From: Tom Zanussi <tzanussi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 03:04:53 -0500
Message-Id: <1240905893.6416.120.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new filter comparison ops need to be able to distinguish between
signed and unsigned field types, so add an is_signed flag/param to the
event field struct/trace_define_fields().  Also define a simple macro,
is_signed() to determine the signedness at compile time, used in the
trace macros.  If the is_signed() macro won't work with a specific
type, a new slightly modified version of TRACE_FIELD() called
TRACE_FIELD_SIGN(), allows the signedness to be set explicitly.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 include/linux/ftrace_event.h     |    7 ++++---
 include/trace/ftrace.h           |   16 ++++++++--------
 kernel/trace/trace.h             |    1 +
 kernel/trace/trace_event_types.h |    4 ++--
 kernel/trace/trace_events.c      |    3 ++-
 kernel/trace/trace_export.c      |   29 ++++++++++++++++++++++-------
 6 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 46a27f2..51bff2e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -122,8 +122,9 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 					struct ring_buffer_event *event);
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size);
+			      char *name, int offset, int size, int is_signed);
 
+#define is_signed(t)	(((t)-1) < 0)
 
 /*
  * The double __builtin_constant_p is because gcc will give us an error
@@ -144,10 +145,10 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-#define __common_field(type, item)					\
+#define __common_field(type, item, is_signed)				\
 	ret = trace_define_field(event_call, #type, "common_" #item,	\
 				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item));		\
+				 sizeof(field.ent.item), is_signed);	\
 	if (ret)							\
 		return ret;
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1e68114..6709126 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -225,7 +225,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define __field(type, item)						\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
+				 sizeof(field.item), is_signed(type));	\
 	if (ret)							\
 		return ret;
 
@@ -234,7 +234,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
+				 sizeof(field.item), 0);		\
 	if (ret)							\
 		return ret;
 
@@ -242,7 +242,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define __string(item, src)						       \
 	ret = trace_define_field(event_call, "__str_loc", #item,	       \
 				offsetof(typeof(field), __str_loc_##item),     \
-				sizeof(field.__str_loc_##item));
+				 sizeof(field.__str_loc_##item), 0);
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
@@ -253,11 +253,11 @@ ftrace_define_fields_##call(void)					\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	int ret;							\
 									\
-	__common_field(int, type);					\
-	__common_field(unsigned char, flags);				\
-	__common_field(unsigned char, preempt_count);			\
-	__common_field(int, pid);					\
-	__common_field(int, tgid);					\
+	__common_field(int, type, 1);					\
+	__common_field(unsigned char, flags, 0);			\
+	__common_field(unsigned char, preempt_count, 0);		\
+	__common_field(int, pid, 1);					\
+	__common_field(int, tgid, 1);					\
 									\
 	tstruct;							\
 									\
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 11ef8ec..97b83b0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -731,6 +731,7 @@ struct ftrace_event_field {
 	char			*type;
 	int			offset;
 	int			size;
+	int			is_signed;
 };
 
 struct event_filter {
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index cfcecc4..5e32e37 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -141,8 +141,8 @@ TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
 
 TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
 	TRACE_STRUCT(
-		TRACE_FIELD(ktime_t, state_data.stamp, stamp)
-		TRACE_FIELD(ktime_t, state_data.end, end)
+		TRACE_FIELD_SIGN(ktime_t, state_data.stamp, stamp, 1)
+		TRACE_FIELD_SIGN(ktime_t, state_data.end, end, 1)
 		TRACE_FIELD(int, state_data.type, type)
 		TRACE_FIELD(int, state_data.state, state)
 	),
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2de652d..f816782 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -26,7 +26,7 @@ static DEFINE_MUTEX(event_mutex);
 LIST_HEAD(ftrace_events);
 
 int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size)
+		       char *name, int offset, int size, int is_signed)
 {
 	struct ftrace_event_field *field;
 
@@ -44,6 +44,7 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 
 	field->offset = offset;
 	field->size = size;
+	field->is_signed = is_signed;
 	list_add(&field->link, &call->fields);
 
 	return 0;
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 0cb1a14..fc7c16f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -50,6 +50,9 @@ extern void __bad_type_size(void);
 	if (!ret)							\
 		return 0;
 
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
+	TRACE_FIELD(type, item, assign)
 
 #undef TP_RAW_FMT
 #define TP_RAW_FMT(args...) args
@@ -98,6 +101,10 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
 
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
+	TRACE_FIELD(type, item, assign)
+
 #undef TP_CMD
 #define TP_CMD(cmd...)	cmd
 
@@ -149,7 +156,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
+				 sizeof(field.item), is_signed(type));	\
 	if (ret)							\
 		return ret;
 
@@ -157,7 +164,15 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
+				 sizeof(field.item), 0);		\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), is_signed);	\
 	if (ret)							\
 		return ret;
 
@@ -173,11 +188,11 @@ ftrace_define_fields_##call(void)					\
 	struct args field;						\
 	int ret;							\
 									\
-	__common_field(unsigned char, type);				\
-	__common_field(unsigned char, flags);				\
-	__common_field(unsigned char, preempt_count);			\
-	__common_field(int, pid);					\
-	__common_field(int, tgid);					\
+	__common_field(unsigned char, type, 0);				\
+	__common_field(unsigned char, flags, 0);			\
+	__common_field(unsigned char, preempt_count, 0);		\
+	__common_field(int, pid, 1);					\
+	__common_field(int, tgid, 1);					\
 									\
 	tstruct;							\
 									\
-- 
1.5.6.3



