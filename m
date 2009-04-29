Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZD2MKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZD2MKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZD2MKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:10:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791AbZD2MKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:10:19 -0400
Date: Wed, 29 Apr 2009 12:09:39 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240905893.6416.120.camel@tropicana>
References: <1240905893.6416.120.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: distinguish between signed and unsigned fields
Message-ID: <tip-a118e4d1402f1349fe3d953493e4168a300a752d@git.kernel.org>
Git-Commit-ID: a118e4d1402f1349fe3d953493e4168a300a752d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 12:09:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a118e4d1402f1349fe3d953493e4168a300a752d
Gitweb:     http://git.kernel.org/tip/a118e4d1402f1349fe3d953493e4168a300a752d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 28 Apr 2009 03:04:53 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:06:03 +0200

tracing/filters: distinguish between signed and unsigned fields

The new filter comparison ops need to be able to distinguish between
signed and unsigned field types, so add an is_signed flag/param to the
event field struct/trace_define_fields().  Also define a simple macro,
is_signed_type() to determine the signedness at compile time, used in the
trace macros.  If the is_signed_type() macro won't work with a specific
type, a new slightly modified version of TRACE_FIELD() called
TRACE_FIELD_SIGN(), allows the signedness to be set explicitly.

[ Impact: extend trace-filter code for new feature ]

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1240905893.6416.120.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h     |    7 ++++---
 include/trace/ftrace.h           |   16 ++++++++--------
 kernel/trace/trace.h             |    1 +
 kernel/trace/trace_event_types.h |    4 ++--
 kernel/trace/trace_events.c      |    3 ++-
 kernel/trace/trace_export.c      |   29 ++++++++++++++++++++++-------
 6 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 46a27f2..e61a740 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -122,8 +122,9 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 					struct ring_buffer_event *event);
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size);
+			      char *name, int offset, int size, int is_signed);
 
+#define is_signed_type(type)	(((type)(-1)) < 0)
 
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
index 1e68114..edb02bc 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -225,7 +225,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define __field(type, item)						\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
+				 sizeof(field.item), is_signed_type(type));	\
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
index 1fb7d6c..866d010 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -729,6 +729,7 @@ struct ftrace_event_field {
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
index 1cd1f37..bbbea74 100644
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
index 0cb1a14..d06cf89 100644
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
+				 sizeof(field.item), is_signed_type(type));	\
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
