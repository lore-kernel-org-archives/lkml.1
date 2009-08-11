Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbZHKStl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbZHKStl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbZHKStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:39 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbZHKSth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sz+7w5dbCPpwlzCwJ2AI3X85mjs5FFQMnItL7s/5YMtzVd6ZKYF96lnXVjMAwQpnlo
         f2V81U/rElxkQBtaTpn1V04U18JbG5lp0SHVAwtvaq8s3tg+l9TSVwELClL6psvwOm44
         F42DO/iC96h+u0GonEeieNXd+gK8eX/Ol42jk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>
Subject: [PATCH 14/16] tracing: Add ftrace event call parameter to its field descriptor handler
Date: Tue, 11 Aug 2009 20:49:03 +0200
Message-Id: <1250016545-6601-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the struct ftrace_event_call as a parameter of its show_format()
callback. This way we can use it from the syscall trace events to
retrieve the syscall name from the ftrace event call parameter and
describe its fields using the syscalls metadata.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h |    3 ++-
 include/trace/ftrace.h       |    3 ++-
 kernel/trace/trace_events.c  |    2 +-
 kernel/trace/trace_export.c  |    6 ++++--
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8544f12..189806b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -116,7 +116,8 @@ struct ftrace_event_call {
 	void			(*unregfunc)(void *);
 	int			id;
 	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
+	int			(*show_format)(struct ftrace_event_call *call,
+					       struct trace_seq *s);
 	int			(*define_fields)(void);
 	struct list_head	fields;
 	int			filter_active;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 46d81b5..b250b06 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -151,7 +151,8 @@
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct ftrace_raw_##call field __attribute__((unused));		\
 	int ret = 0;							\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d289e2..b568ade 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -576,7 +576,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_printf(s, "format:\n");
 	trace_write_header(s);
 
-	r = call->show_format(s);
+	r = call->show_format(call, s);
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d06cf89..956d4bc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -60,7 +60,8 @@ extern void __bad_type_size(void);
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct args field;						\
 	int ret;							\
@@ -76,7 +77,8 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
 				    tpfmt)				\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct args field;						\
 	int ret;							\
-- 
1.6.2.3

