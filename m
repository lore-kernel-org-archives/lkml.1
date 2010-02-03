Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0BCJQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:16:35 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47625 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab0BCJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y6L5UbQ6luiydbGDRsKMPRs9TcSrskbge4GDiPJPI9BEVsQU5Z9xFYSf2HcYJMUVNJ
         kQRxOJf93Ht8gVrAIyzB4tbiG4E+tfosDO+PKc/PicHOC+5TIaE4x+W3DFxJnc821NEM
         +/hFCD16IEnGBTVM4azFX4kaao5gPE3b3Svto=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/11] perf: Handle injection ioctl with trace events
Date: Wed,  3 Feb 2010 10:14:30 +0100
Message-Id: <1265188475-23509-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle injection ioctl request for tracepoints that support it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/ftrace_event.h       |    5 ++-
 include/linux/perf_event.h         |    4 +++
 kernel/perf_event.c                |   14 ++++++++--
 kernel/trace/trace_event_profile.c |   46 ++++++++++++++++++++++-------------
 4 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 026d39b..9b45db6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -189,8 +189,9 @@ do {									\
 
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
-extern int ftrace_profile_enable(int event_id);
-extern void ftrace_profile_disable(int event_id);
+extern int ftrace_profile_enable(struct perf_event *event);
+extern void ftrace_profile_disable(struct perf_event *event);
+extern void ftrace_perf_inject(struct perf_event *event);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d2e83f0..9e58ab9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -492,6 +492,10 @@ struct hw_perf_event {
 			struct arch_hw_breakpoint	info;
 		};
 #endif
+#ifdef CONFIG_EVENT_TRACING
+		/* tracepoint */
+		struct ftrace_event_call *tp_event;
+#endif
 	};
 	atomic64_t			prev_count;
 	u64				sample_period;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e4dfd12..280ae44 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4350,6 +4350,14 @@ static const struct pmu perf_ops_task_clock = {
 
 #ifdef CONFIG_EVENT_TRACING
 
+static const struct pmu perf_ops_tracepoints = {
+	.enable		= perf_swevent_enable,
+	.disable	= perf_swevent_disable,
+	.read		= perf_swevent_read,
+	.unthrottle	= perf_swevent_unthrottle,
+	.inject		= ftrace_perf_inject,
+};
+
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
@@ -4386,7 +4394,7 @@ static int perf_tp_event_match(struct perf_event *event,
 
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	ftrace_profile_disable(event->attr.config);
+	ftrace_profile_disable(event);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
@@ -4400,12 +4408,12 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (ftrace_profile_enable(event->attr.config))
+	if (ftrace_profile_enable(event))
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
 
-	return &perf_ops_generic;
+	return &perf_ops_tracepoints;
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index f0d6930..9ed684f 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -13,6 +13,8 @@
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
+static DEFINE_MUTEX(perf_trace_mutex);
+
 typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
 
 /* Count the events in use (per event id, not per instance) */
@@ -59,21 +61,27 @@ fail_buf:
 	return ret;
 }
 
-int ftrace_profile_enable(int event_id)
+int ftrace_profile_enable(struct perf_event *event)
 {
-	struct ftrace_event_call *event;
+	int event_id = event->attr.config;
+	struct ftrace_event_call *call;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->profile_enable &&
-		    try_module_get(event->mod)) {
-			ret = ftrace_profile_enable_event(event);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (call->id == event_id && call->profile_enable &&
+		    try_module_get(call->mod)) {
+			mutex_lock(&perf_trace_mutex);
+			ret = ftrace_profile_enable_event(call);
+			mutex_unlock(&perf_trace_mutex);
 			break;
 		}
 	}
 	mutex_unlock(&event_mutex);
 
+	if (!ret)
+		event->hw.tp_event = call;
+
 	return ret;
 }
 
@@ -104,19 +112,23 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 	}
 }
 
-void ftrace_profile_disable(int event_id)
+void ftrace_profile_disable(struct perf_event *event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *call = event->hw.tp_event;
 
-	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id) {
-			ftrace_profile_disable_event(event);
-			module_put(event->mod);
-			break;
-		}
-	}
-	mutex_unlock(&event_mutex);
+	mutex_lock(&perf_trace_mutex);
+	ftrace_profile_disable_event(call);
+	mutex_unlock(&perf_trace_mutex);
+
+	module_put(call->mod);
+}
+
+void ftrace_perf_inject(struct perf_event *event)
+{
+	struct ftrace_event_call *call = event->hw.tp_event;
+
+	if (call->inject)
+		call->inject();
 }
 
 __kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
-- 
1.6.2.3

