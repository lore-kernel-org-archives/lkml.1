Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbZDPUBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbZDPUBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbZDPUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:00:54 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61405 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZDPUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RgdgWIf0cmMeJXMuqQwqzaVFe2doSjkYnpPVV8ICFZ5LEztVa8rc9UZBsllMdGEf8P
         xLEd7AhFIE+ajrzIuEhvWINJO7pJjmUWbpOvAMa7116H9Z0avVC7EXtKn9o0E5sf/ssq
         OpHn60HnD9oIZcF5ZJRv4dPjZKgsozMJTjXxI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2 v2] tracing/events: provide string with undefined size support
Date: Thu, 16 Apr 2009 22:00:46 +0200
Message-Id: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: less memory usage for tracing

This patch provides the support for dynamic size strings on
event tracing.

The key concept is to use a structure with an ending char array field of
undefined size and use such ability to allocate the minimal size on the ring
buffer to make the entry fit inside as opposite to a fixed length strings with
upper bound.

This patch provides one new macro:

-__ending_string(name, src)

This one declares the string to the structure inside TP_STRUCT__entry.
You need to provide the name of the string field and the source that will be
copied inside.
Two constraints: only one __ending_string() per TRACE_EVENT can be added and
it must be the last field to be declared. Hence the __ending prefix.

This macro will declare the necessary field and will also add the dynamic
size of the string needed for the ring buffer entry allocation.

It also support filtering because these strings behave essentially
like usual fixed length string.

Changes in v2:

Address the suggestion of Steven Rostedt: drop the opening_string() macro
and redefine __ending_string() to get the size of the string to be copied
instead of overwritting the whole ring buffer allocation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/ftrace.h |   42 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 6fb06bd..7d29cf5 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -27,6 +27,9 @@
 #undef __field
 #define __field(type, item)		type	item;
 
+#undef __ending_string
+#define __ending_string(item, src)	char	item[];
+
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
@@ -150,6 +153,14 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	if (!ret)							\
 		return 0;
 
+#undef __ending_string
+#define __ending_string(item, src)					      \
+	ret = trace_seq_printf(s, "\tfield: char " #item "[];\t"	      \
+			       "offset:%u;\n",				      \
+			       (unsigned int)offsetof(typeof(field), item));  \
+	if (!ret)							      \
+		return 0;
+
 #undef __entry
 #define __entry REC
 
@@ -193,6 +204,18 @@ ftrace_format_##call(struct trace_seq *s)				\
 	if (ret)							\
 		return ret;
 
+/*
+ * We choose a size of MAX_FILTER_STR_VAL, then we behave like
+ * a usual string with the maximum size to keep being filterable.
+ */
+#undef __ending_string
+#define __ending_string(item, src)					\
+	ret = trace_define_field(event_call, "char []", #item,		\
+				 offsetof(typeof(field), item),		\
+				 MAX_FILTER_STR_VAL);			\
+	if (ret)							\
+		return ret;
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 int									\
@@ -413,6 +436,15 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef __entry
 #define __entry entry
 
+#undef __field
+#define __field(type, item)
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __ending_string
+#define __ending_string(item, src)	__str_size = strlen(src) + 1
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 _TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
@@ -425,14 +457,18 @@ static void ftrace_raw_event_##call(proto)				\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	unsigned long irq_flags;					\
+	int __str_size = 0;						\
 	int pc;								\
 									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
 									\
-	event = trace_current_buffer_lock_reserve(event_##call.id,	\
-				  sizeof(struct ftrace_raw_##call),	\
-				  irq_flags, pc);			\
+	tstruct;							\
+									\
+	event = trace_current_buffer_lock_reserve(			\
+			event_##call.id,				\
+			sizeof(struct ftrace_raw_##call) + __str_size,	\
+			irq_flags, pc);					\
 	if (!event)							\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
-- 
1.6.1

