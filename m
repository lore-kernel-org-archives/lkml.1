Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbZHKSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbZHKSvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbZHKSvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:51:09 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbZHKStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kps/328e/yVV9Kv6j1iYPBesPv1UsZ5rmdfsaJGtG0BWgoHAMrTbqkI8DYJvblwdfT
         h5RtmNzghueAwOGfIxyD4LJLK9kMFSQri6hR9Nq4iKRaR+/5GKPWbSW0rCqAc7i1VoK1
         Rcr9AsxS7HtUztgKjn4ukLQX8uHut0sonOQwk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/16] tracing: Add ftrace_event_call void * 'data' field
Date: Tue, 11 Aug 2009 20:48:57 +0200
Message-Id: <1250016545-6601-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

add an optional void * pointer to 'ftrace_event_call' that is
passed in for regfunc and unregfunc.

This prepares for syscall tracepoints creation by passing the name of
the syscall we want to trace and then retrieve its number through our
arch syscall table.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h |    5 +++--
 include/trace/ftrace.h       |    4 ++--
 kernel/trace/trace_events.c  |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index ac8c6f8..8544f12 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -112,8 +112,8 @@ struct ftrace_event_call {
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
-	int			(*regfunc)(void);
-	void			(*unregfunc)(void);
+	int			(*regfunc)(void *);
+	void			(*unregfunc)(void *);
 	int			id;
 	int			(*raw_init)(void);
 	int			(*show_format)(struct trace_seq *s);
@@ -122,6 +122,7 @@ struct ftrace_event_call {
 	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
+	void			*data;
 
 	atomic_t		profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 25d3b02..46d81b5 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -568,7 +568,7 @@ static void ftrace_raw_event_##call(proto)				\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 }									\
 									\
-static int ftrace_raw_reg_event_##call(void)				\
+static int ftrace_raw_reg_event_##call(void *ptr)			\
 {									\
 	int ret;							\
 									\
@@ -579,7 +579,7 @@ static int ftrace_raw_reg_event_##call(void)				\
 	return ret;							\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(void)				\
+static void ftrace_raw_unreg_event_##call(void *ptr)			\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f95f847..1d289e2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -86,14 +86,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->enabled) {
 			call->enabled = 0;
 			tracing_stop_cmdline_record();
-			call->unregfunc();
+			call->unregfunc(call->data);
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc();
+			call->regfunc(call->data);
 		}
 		break;
 	}
-- 
1.6.2.3

