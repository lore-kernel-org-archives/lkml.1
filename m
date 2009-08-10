Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZHJUzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZHJUzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZHJUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:55:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZHJUzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:55:06 -0400
Date: Mon, 10 Aug 2009 16:52:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <2f63f892c862efd4f58f9d3e72cb5bc55f2d0025.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 07/12] add ftrace_event_call void * 'data' field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add an optional * void pointer to 'ftrace_event_call' that is
passed in for regfunc and unregfunc.

Signed-off-by: Jason Baron <jbaron@redhat.com>

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
index 80e5f6c..a0de384 100644
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
1.6.2.5

