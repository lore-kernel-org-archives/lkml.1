Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZHSNcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZHSNcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZHSNcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:32:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZHSNcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:32:11 -0400
Date: Wed, 19 Aug 2009 13:31:34 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <4A8BAF90.6060801@cn.fujitsu.com>
References: <4A8BAF90.6060801@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: Add ftrace_event_call param to define_fields()
Message-ID: <tip-14be96c9716cb8c46dca94bd890defd7856e0734@git.kernel.org>
Git-Commit-ID: 14be96c9716cb8c46dca94bd890defd7856e0734
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 13:31:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14be96c9716cb8c46dca94bd890defd7856e0734
Gitweb:     http://git.kernel.org/tip/14be96c9716cb8c46dca94bd890defd7856e0734
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 19 Aug 2009 15:53:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 15:02:23 +0200

tracing/events: Add ftrace_event_call param to define_fields()

This parameter is needed by syscall events to add define_fields()
handler.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A8BAF90.6060801@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h |    2 +-
 include/trace/ftrace.h       |    3 +--
 kernel/trace/trace_events.c  |    2 +-
 kernel/trace/trace_export.c  |    5 ++---
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 189806b..35b3a4a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -118,7 +118,7 @@ struct ftrace_event_call {
 	int			(*raw_init)(void);
 	int			(*show_format)(struct ftrace_event_call *call,
 					       struct trace_seq *s);
-	int			(*define_fields)(void);
+	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b250b06..4e81c9b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -294,10 +294,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	int ret;							\
 									\
 	__common_field(int, type, 1);					\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b568ade..af8fb8e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -941,7 +941,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 					  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields();
+		ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 956d4bc..cf2c752 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -119,7 +119,7 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int ftrace_define_fields_##call(void);					\
+int ftrace_define_fields_##call(struct ftrace_event_call *event_call);	\
 static int ftrace_raw_init_event_##call(void);				\
 									\
 struct ftrace_event_call __used						\
@@ -184,9 +184,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	struct args field;						\
 	int ret;							\
 									\
