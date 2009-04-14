Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZDNR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZDNR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZDNR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZDNR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:45 -0400
Message-Id: <20090414172641.694731417@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 6/8] tracing/events: convert event call sites to use a link list
Content-Disposition: inline; filename=0006-tracing-events-convert-event-call-sites-to-use-a-li.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: makes it possible to define events in modules

The events are created by reading down the section that they are linked
in by the macros. But this is not scalable to modules. This patch converts
the manipulations to use a global link list, and on boot up it adds
the items in the section to the list.

This change will allow modules to add their tracing events to the list as
well.

Note, this change alone does not permit modules to use the TRACE_EVENT macros,
but the change is needed for them to eventually do so.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace.h               |   13 +--------
 kernel/trace/trace_event_profile.c |    4 +-
 kernel/trace/trace_events.c        |   51 ++++++++++++++++++++++--------------
 kernel/trace/trace_events_filter.c |    8 +++---
 5 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 496b76d..1781085 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -83,6 +83,7 @@ void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
 void tracing_record_cmdline(struct task_struct *tsk);
 
 struct ftrace_event_call {
+	struct list_head	list;
 	char			*name;
 	char			*system;
 	struct dentry		*dir;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6bcdf4a..8817c18 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -739,11 +739,6 @@ struct event_subsystem {
 	struct filter_pred	**preds;
 };
 
-#define events_for_each(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
-
 struct filter_pred;
 
 typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
@@ -785,13 +780,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
-
-#define for_each_event(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
+extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 199de9c..7bf2ad6 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -11,7 +11,7 @@ int ftrace_profile_enable(int event_id)
 {
 	struct ftrace_event_call *event;
 
-	for_each_event(event) {
+	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id)
 			return event->profile_enable(event);
 	}
@@ -23,7 +23,7 @@ void ftrace_profile_disable(int event_id)
 {
 	struct ftrace_event_call *event;
 
-	for_each_event(event) {
+	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id)
 			return event->profile_disable(event);
 	}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ead68ac..5c66aaf 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -19,6 +19,8 @@
 
 static DEFINE_MUTEX(event_mutex);
 
+LIST_HEAD(ftrace_events);
+
 int trace_define_field(struct ftrace_event_call *call, char *type,
 		       char *name, int offset, int size)
 {
@@ -54,16 +56,14 @@ err:
 
 static void ftrace_clear_events(void)
 {
-	struct ftrace_event_call *call = (void *)__start_ftrace_events;
-
+	struct ftrace_event_call *call;
 
-	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
+	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (call->enabled) {
 			call->enabled = 0;
 			call->unregfunc();
 		}
-		call++;
 	}
 }
 
@@ -89,7 +89,7 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 
 static int ftrace_set_clr_event(char *buf, int set)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct ftrace_event_call *call;
 	char *event = NULL, *sub = NULL, *match;
 	int ret = -EINVAL;
 
@@ -118,7 +118,7 @@ static int ftrace_set_clr_event(char *buf, int set)
 	}
 
 	mutex_lock(&event_mutex);
-	for_each_event(call) {
+	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->name || !call->regfunc)
 			continue;
@@ -224,15 +224,17 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
-	struct ftrace_event_call *next = call;
+	struct list_head *list = m->private;
+	struct ftrace_event_call *call;
 
 	(*pos)++;
 
 	for (;;) {
-		if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+		if (list == &ftrace_events)
 			return NULL;
 
+		call = list_entry(list, struct ftrace_event_call, list);
+
 		/*
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
@@ -240,11 +242,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		if (call->regfunc)
 			break;
 
-		call++;
-		next = call;
+		list = list->next;
 	}
 
-	m->private = ++next;
+	m->private = list->next;
 
 	return call;
 }
@@ -257,22 +258,23 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 static void *
 s_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
-	struct ftrace_event_call *next;
+	struct list_head *list = m->private;
+	struct ftrace_event_call *call;
 
 	(*pos)++;
 
  retry:
-	if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+	if (list == &ftrace_events)
 		return NULL;
 
+	call = list_entry(list, struct ftrace_event_call, list);
+
 	if (!call->enabled) {
-		call++;
+		list = list->next;
 		goto retry;
 	}
 
-	next = call;
-	m->private = ++next;
+	m->private = list->next;
 
 	return call;
 }
@@ -312,7 +314,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
 	if (!ret) {
 		struct seq_file *m = file->private_data;
 
-		m->private = __start_ftrace_events;
+		m->private = ftrace_events.next;
 	}
 	return ret;
 }
@@ -797,9 +799,17 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	return 0;
 }
 
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
+#define for_each_event(event)						\
+	for (event = __start_ftrace_events;				\
+	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
+	     event++)
+
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct ftrace_event_call *call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
@@ -830,6 +840,7 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
+		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events);
 	}
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index de42dad..d30b06b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -223,7 +223,7 @@ oom:
 
 void filter_free_subsystem_preds(struct event_subsystem *system)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct ftrace_event_call *call;
 	int i;
 
 	if (system->n_preds) {
@@ -234,7 +234,7 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
 		system->n_preds = 0;
 	}
 
-	events_for_each(call) {
+	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
 
@@ -320,7 +320,7 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 int filter_add_subsystem_pred(struct event_subsystem *system,
 			      struct filter_pred *pred)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct ftrace_event_call *call;
 
 	if (system->n_preds && !pred->compound)
 		filter_free_subsystem_preds(system);
@@ -337,7 +337,7 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 
 	system->preds[system->n_preds] = pred;
 
-	events_for_each(call) {
+	list_for_each_entry(call, &ftrace_events, list) {
 		int err;
 
 		if (!call->define_fields)
-- 
1.6.2.1

-- 
