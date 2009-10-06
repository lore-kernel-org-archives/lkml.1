Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZJFNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZJFNHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZJFNHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:07:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:43889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZJFNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:07:51 -0400
Date: Tue, 6 Oct 2009 13:06:39 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254809398-8078-2-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/events: Add 'signed' field to format files
Message-ID: <tip-26a50744b21fff65bd754874072857bee8967f4d@git.kernel.org>
Git-Commit-ID: 26a50744b21fff65bd754874072857bee8967f4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 13:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26a50744b21fff65bd754874072857bee8967f4d
Gitweb:     http://git.kernel.org/tip/26a50744b21fff65bd754874072857bee8967f4d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:09:50 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 15:04:45 +0200

tracing/events: Add 'signed' field to format files

The sign info used for filters in the kernel is also useful to
applications that process the trace stream.  Add it to the format
files and make it available to userspace.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: hch@infradead.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254809398-8078-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/ftrace.h              |   15 +++++++++------
 kernel/trace/ring_buffer.c          |   15 +++++++++------
 kernel/trace/trace_events.c         |   24 ++++++++++++------------
 kernel/trace/trace_export.c         |   25 ++++++++++++++-----------
 kernel/trace/trace_syscalls.c       |   20 +++++++++++++-------
 tools/perf/util/trace-event-parse.c |   24 ++++++++++++++++++++++++
 tools/perf/util/trace-event.h       |    1 +
 7 files changed, 82 insertions(+), 42 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..c9bbcab 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -120,9 +120,10 @@
 #undef __field
 #define __field(type, item)					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
 			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+			       (unsigned int)sizeof(field.item),	\
+			       (unsigned int)is_signed_type(type));	\
 	if (!ret)							\
 		return 0;
 
@@ -132,19 +133,21 @@
 #undef __array
 #define __array(type, item, len)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
 			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+			       (unsigned int)sizeof(field.item),	\
+			       (unsigned int)is_signed_type(type));	\
 	if (!ret)							\
 		return 0;
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
 	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
-			       "offset:%u;\tsize:%u;\n",		       \
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	       \
 			       (unsigned int)offsetof(typeof(field),	       \
 					__data_loc_##item),		       \
-			       (unsigned int)sizeof(field.__data_loc_##item)); \
+			       (unsigned int)sizeof(field.__data_loc_##item), \
+			       (unsigned int)is_signed_type(type));	\
 	if (!ret)							       \
 		return 0;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4ff019..e43c928 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -397,18 +397,21 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 	int ret;
 
 	ret = trace_seq_printf(s, "\tfield: u64 timestamp;\t"
-			       "offset:0;\tsize:%u;\n",
-			       (unsigned int)sizeof(field.time_stamp));
+			       "offset:0;\tsize:%u;\tsigned:%u;\n",
+			       (unsigned int)sizeof(field.time_stamp),
+			       (unsigned int)is_signed_type(u64));
 
 	ret = trace_seq_printf(s, "\tfield: local_t commit;\t"
-			       "offset:%u;\tsize:%u;\n",
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			       (unsigned int)offsetof(typeof(field), commit),
-			       (unsigned int)sizeof(field.commit));
+			       (unsigned int)sizeof(field.commit),
+			       (unsigned int)is_signed_type(long));
 
 	ret = trace_seq_printf(s, "\tfield: char data;\t"
-			       "offset:%u;\tsize:%u;\n",
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			       (unsigned int)offsetof(typeof(field), data),
-			       (unsigned int)BUF_PAGE_SIZE);
+			       (unsigned int)BUF_PAGE_SIZE,
+			       (unsigned int)is_signed_type(char));
 
 	return ret;
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d128f65..cf3cabf 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -507,7 +507,7 @@ extern char *__bad_type_size(void);
 #define FIELD(type, name)						\
 	sizeof(type) != sizeof(field.name) ? __bad_type_size() :	\
 	#type, "common_" #name, offsetof(typeof(field), name),		\
-		sizeof(field.name)
+		sizeof(field.name), is_signed_type(type)
 
 static int trace_write_header(struct trace_seq *s)
 {
@@ -515,17 +515,17 @@ static int trace_write_header(struct trace_seq *s)
 
 	/* struct trace_entry */
 	return trace_seq_printf(s,
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
-				FIELD(int, lock_depth));
+			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
+			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
+			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
+			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
+			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
+			"\n",
+			FIELD(unsigned short, type),
+			FIELD(unsigned char, flags),
+			FIELD(unsigned char, preempt_count),
+			FIELD(int, pid),
+			FIELD(int, lock_depth));
 }
 
 static ssize_t
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9753fcc..31da218 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -66,44 +66,47 @@ static void __used ____ftrace_check_##name(void)		\
 #undef __field
 #define __field(type, item)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:%zu;\n",		\
+			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
 			       offsetof(typeof(field), item),		\
-			       sizeof(field.item));			\
+			       sizeof(field.item), is_signed_type(type)); \
 	if (!ret)							\
 		return 0;
 
 #undef __field_desc
 #define __field_desc(type, container, item)				\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:%zu;\n",		\
+			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
 			       offsetof(typeof(field), container.item),	\
-			       sizeof(field.container.item));		\
+			       sizeof(field.container.item),		\
+			       is_signed_type(type));			\
 	if (!ret)							\
 		return 0;
 
 #undef __array
 #define __array(type, item, len)					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
-			       "offset:%zu;\tsize:%zu;\n",		\
-			       offsetof(typeof(field), item),	\
-			       sizeof(field.item));		\
+			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item), is_signed_type(type)); \
 	if (!ret)							\
 		return 0;
 
 #undef __array_desc
 #define __array_desc(type, container, item, len)			\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
-			       "offset:%zu;\tsize:%zu;\n",		\
+			       "offset:%zu;\tsize:%zu;\tsigned:%u;\n",	\
 			       offsetof(typeof(field), container.item),	\
-			       sizeof(field.container.item));		\
+			       sizeof(field.container.item),		\
+			       is_signed_type(type));			\
 	if (!ret)							\
 		return 0;
 
 #undef __dynamic_array
 #define __dynamic_array(type, item)					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%zu;\tsize:0;\n",		\
-			       offsetof(typeof(field), item));		\
+			       "offset:%zu;\tsize:0;\tsigned:%u;\n",	\
+			       offsetof(typeof(field), item),		\
+			       is_signed_type(type));			\
 	if (!ret)							\
 		return 0;
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 527e17e..d99abc4 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -103,7 +103,8 @@ extern char *__bad_type_size(void);
 #define SYSCALL_FIELD(type, name)					\
 	sizeof(type) != sizeof(trace.name) ?				\
 		__bad_type_size() :					\
-		#type, #name, offsetof(typeof(trace), name), sizeof(trace.name)
+		#type, #name, offsetof(typeof(trace), name),		\
+		sizeof(trace.name), is_signed_type(type)
 
 int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
@@ -120,7 +121,8 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 	if (!entry)
 		return 0;
 
-	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
+			       "\tsigned:%u;\n",
 			       SYSCALL_FIELD(int, nr));
 	if (!ret)
 		return 0;
@@ -130,8 +132,10 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 				        entry->args[i]);
 		if (!ret)
 			return 0;
-		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;\n", offset,
-				       sizeof(unsigned long));
+		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;"
+				       "\tsigned:%u;\n", offset,
+				       sizeof(unsigned long),
+				       is_signed_type(unsigned long));
 		if (!ret)
 			return 0;
 		offset += sizeof(unsigned long);
@@ -163,8 +167,10 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 	struct syscall_trace_exit trace;
 
 	ret = trace_seq_printf(s,
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
+			       "\tsigned:%u;\n"
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
+			       "\tsigned:%u;\n",
 			       SYSCALL_FIELD(int, nr),
 			       SYSCALL_FIELD(long, ret));
 	if (!ret)
@@ -212,7 +218,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
-	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
+	ret = trace_define_field(call, SYSCALL_FIELD(long, ret),
 				 FILTER_OTHER);
 
 	return ret;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 55b41b9..be8412d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -897,6 +897,21 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 		if (read_expected(EVENT_OP, (char *)";") < 0)
 			goto fail_expect;
 
+		if (read_expected(EVENT_ITEM, (char *)"signed") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_OP, (char *)":") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+		if (strtoul(token, NULL, 0))
+			field->flags |= FIELD_IS_SIGNED;
+		free_token(token);
+
+		if (read_expected(EVENT_OP, (char *)";") < 0)
+			goto fail_expect;
+
 		if (read_expect_type(EVENT_NEWLINE, &token) < 0)
 			goto fail;
 		free_token(token);
@@ -2845,6 +2860,15 @@ static void parse_header_field(char *type,
 	free_token(token);
 	if (read_expected(EVENT_OP, (char *)";") < 0)
 		return;
+	if (read_expected(EVENT_ITEM, (char *)"signed") < 0)
+		return;
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		return;
+	free_token(token);
+	if (read_expected(EVENT_OP, (char *)";") < 0)
+		return;
 	if (read_expect_type(EVENT_NEWLINE, &token) < 0)
 		return;
 	free_token(token);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 162c3e6..00b440d 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -26,6 +26,7 @@ enum {
 enum format_flags {
 	FIELD_IS_ARRAY		= 1,
 	FIELD_IS_POINTER	= 2,
+	FIELD_IS_SIGNED		= 4,
 };
 
 struct format_field {
