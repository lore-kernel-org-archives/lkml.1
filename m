Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbZCQGZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbZCQGZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZCQGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:24:57 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762852AbZCQGYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TzBwDfPuC2H+lpOE+pcYzjVgKi7d2sVrXiEIoKmQs+J/yqcit7qq16ZAIJWslIPCnV
         JH8YyGDjS/iPvItQoOfJA3wiPJWC8D57lzrfRgcGofRD4DOMvHvRLFS7Nej0350GZt1G
         z8N5DQWmvjFyCpzpMP5Q90167d+kGn0oFMNIQ=
Subject: [RFC][PATCH 4/4] tracing: add per-subsystem filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:23:58 -0500
Message-Id: <1237271038.8033.152.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds per-subsystem filtering to the event tracing subsystem.

It adds a 'filter' debugfs file to each subsystem directory.  This file
can be written to to set filters; reading from it will display the
current set of filters set for that subsystem.

Basically what it does is propagate the filter down to each event
contained in the subsystem.  If a particular event doesn't have a field
with the name specified in the filter, it simply doesn't get set for
that event.  You can verify whether or not the filter was set for a
particular event by looking at the filter file for that event.

As with per-event filters, compound expressions are supported, echoing
'0' to the subsystem's filter file clears all filters in the subsystem,
etc.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.h               |   15 ++++++
 kernel/trace/trace_events.c        |   91 +++++++++++++++++++++++++++++++----
 kernel/trace/trace_events_filter.c |   80 +++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3081df5..d918e73 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -799,6 +799,18 @@ struct ftrace_event_call {
 	struct filter_pred	**preds;
 };
 
+struct event_subsystem {
+	struct list_head	list;
+	const char		*name;
+	struct dentry		*entry;
+	struct filter_pred	**preds;
+};
+
+#define events_for_each(event)						\
+	for (event = __start_ftrace_events;				\
+	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
+	     event++)
+
 #define MAX_FILTER_PRED 8
 
 struct filter_pred;
@@ -827,6 +839,9 @@ extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_free_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern void filter_free_subsystem_preds(struct event_subsystem *system);
+extern int filter_add_subsystem_pred(struct event_subsystem *system,
+				     struct filter_pred *pred);
 
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 61ab3e8..05e4219 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -19,11 +19,6 @@
 
 static DEFINE_MUTEX(event_mutex);
 
-#define events_for_each(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
-
 int trace_define_field(struct ftrace_event_call *call, char *type,
 		       char *name, int offset, int size)
 {
@@ -505,6 +500,71 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static ssize_t
+subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
+		      loff_t *ppos)
+{
+	struct event_subsystem *system = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	r = filter_print_preds(system->preds, s->buffer);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
+
+	kfree(s);
+
+	return r;
+}
+
+static ssize_t
+subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		       loff_t *ppos)
+{
+	struct event_subsystem *system = filp->private_data;
+	char buf[64], *pbuf = buf;
+	struct filter_pred *pred;
+	int err;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return -ENOMEM;
+
+	err = filter_parse(&pbuf, pred);
+	if (err < 0) {
+		filter_free_pred(pred);
+		return err;
+	}
+
+	if (pred->clear) {
+		filter_free_subsystem_preds(system);
+		return cnt;
+	}
+
+	if (filter_add_subsystem_pred(system, pred)) {
+		filter_free_pred(pred);
+		return -EINVAL;
+	}
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -551,6 +611,12 @@ static const struct file_operations ftrace_event_filter_fops = {
 	.write = event_filter_write,
 };
 
+static const struct file_operations ftrace_subsystem_filter_fops = {
+	.open = tracing_open_generic,
+	.read = subsystem_filter_read,
+	.write = subsystem_filter_write,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -571,18 +637,13 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
 
-struct event_subsystem {
-	struct list_head	list;
-	const char		*name;
-	struct dentry		*entry;
-};
-
 static LIST_HEAD(event_subsystems);
 
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
 	struct event_subsystem *system;
+	struct dentry *entry;
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -609,6 +670,14 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	system->name = name;
 	list_add(&system->list, &event_subsystems);
 
+	system->preds = NULL;
+
+	entry = debugfs_create_file("filter", 0444, system->entry, system,
+				    &ftrace_subsystem_filter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/filter' entry\n", name);
+
 	return system->entry;
 }
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 199037f..e730834 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -175,6 +175,27 @@ void filter_free_preds(struct ftrace_event_call *call)
 	}
 }
 
+void filter_free_subsystem_preds(struct event_subsystem *system)
+{
+	struct ftrace_event_call *call = __start_ftrace_events;
+	int i;
+
+	if (system->preds) {
+		for (i = 0; i < MAX_FILTER_PRED; i++)
+			filter_free_pred(system->preds[i]);
+		kfree(system->preds);
+		system->preds = NULL;
+	}
+
+	events_for_each(call) {
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (!strcmp(call->system, system->name))
+			filter_free_preds(call);
+	}
+}
+
 static int __filter_add_pred(struct ftrace_event_call *call,
 			     struct filter_pred *pred)
 {
@@ -244,6 +265,65 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 	return __filter_add_pred(call, pred);
 }
 
+static struct filter_pred *copy_pred(struct filter_pred *pred)
+{
+	struct filter_pred *new_pred = kmalloc(sizeof(*pred), GFP_KERNEL);
+	if (!new_pred)
+		return NULL;
+
+	memcpy(new_pred, pred, sizeof(*pred));
+	if (pred->str_val) {
+		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
+		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
+		if (!new_pred->str_val) {
+			kfree(new_pred);
+			return NULL;
+		}
+	}
+
+	return new_pred;
+}
+
+int filter_add_subsystem_pred(struct event_subsystem *system,
+			      struct filter_pred *pred)
+{
+	struct ftrace_event_call *call = __start_ftrace_events;
+	struct filter_pred *event_pred;
+	int i;
+
+	if (system->preds && !pred->compound)
+		filter_free_subsystem_preds(system);
+
+	if (!system->preds) {
+		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
+					GFP_KERNEL);
+		if (!system->preds)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (!system->preds[i]) {
+			system->preds[i] = pred;
+			break;
+		}
+		if (i == MAX_FILTER_PRED -1)
+			return -EINVAL;
+	}
+
+	events_for_each(call) {
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (!strcmp(call->system, system->name)) {
+			event_pred = copy_pred(pred);
+			if (event_pred)
+				filter_add_pred(call, event_pred);
+		}
+	}
+
+	return 0;
+}
+
 int filter_parse(char **pbuf, struct filter_pred *pred)
 {
 	char *tmp, *tok, *val_str = NULL;
-- 
1.5.6.3

 


