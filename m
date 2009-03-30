Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZC3FWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZC3FWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 01:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZC3FWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 01:22:31 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:13495 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZC3FWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 01:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QInxczwGpYPJ4ytgvQubawS10MzovYOAj8hkg4EuHhkswmHaY+YIH8pTVYI9SfWiGM
         RFbNVPjFeZXPoHHiy96dHewixOCNp+6gjDMrzOkis/MLBN6zTJ+6GXI4hFtdrWTjTYIQ
         mf93q5er3erLYjmtsefKtvgicIuXA5M9QDo3I=
Subject: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Content-Type: text/plain
Date: Mon, 30 Mar 2009 00:22:26 -0500
Message-Id: <1238390546.6368.65.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code allowing the event filter to be set only if there's
no active tracing going on.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.c               |   13 +++++++++++++
 kernel/trace/trace.h               |    2 ++
 kernel/trace/trace_events.c        |    7 +++++++
 kernel/trace/trace_events_filter.c |   12 ++++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3624b25..30530f7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,6 +235,19 @@ static struct tracer		*trace_types __read_mostly;
 /* current_trace points to the tracer that is currently active */
 static struct tracer		*current_trace __read_mostly;
 
+/**
+ * tracer_is_nop - return if nop tracer is current tracer
+ *
+ * This function is used by other tracers to know whether there is
+ * currently a tracer set.  Tracers may use this function to know if
+ * it should enable their features when starting up. See event tracer
+ * for an example (event_filter_write).
+ */
+int tracer_is_nop(void)
+{
+	return current_trace == &nop_trace;
+}
+
 /*
  * max_tracer_type_len is used to simplify the allocating of
  * buffers to read userspace tracer names. We keep track of
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cfb07ef..6834345 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -466,6 +466,7 @@ struct trace_iterator {
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
+int tracer_is_nop(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
@@ -859,6 +860,7 @@ extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
+extern int subsystem_events_enabled(struct event_subsystem *system);
 
 static inline void
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index be9299a..eb1d363 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	struct filter_pred *pred;
 	int err;
 
+	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
+		return -EBUSY;
+
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
 
@@ -564,6 +567,10 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	struct filter_pred *pred;
 	int err;
 
+	if (tracing_is_enabled() &&
+	    (!tracer_is_nop() || subsystem_events_enabled(system)))
+		return -EBUSY;
+
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 470ad94..a706e0b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -172,6 +172,18 @@ void filter_free_preds(struct ftrace_event_call *call)
 	}
 }
 
+int subsystem_events_enabled(struct event_subsystem *system)
+{
+	struct ftrace_event_call *call = __start_ftrace_events;
+
+	events_for_each(call) {
+		if (!strcmp(call->system, system->name) && call->enabled)
+			return 1;
+	}
+
+	return 0;
+}
+
 void filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call = __start_ftrace_events;
-- 
1.5.6.3



