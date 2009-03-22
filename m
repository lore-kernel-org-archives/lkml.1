Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZCVTm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZCVTm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbZCVTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:42:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbZCVTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:42:09 -0400
Date: Sun, 22 Mar 2009 19:40:28 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237710677.7703.49.camel@charm-linux>
References: <1237710677.7703.49.camel@charm-linux>
Subject: [tip:tracing/filters] tracing: add per-subsystem filtering
Message-ID: <tip-cfb180f3e71b2a280a254c8646a9ab1beab63f84@git.kernel.org>
Git-Commit-ID: cfb180f3e71b2a280a254c8646a9ab1beab63f84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:40:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfb180f3e71b2a280a254c8646a9ab1beab63f84
Gitweb:     http://git.kernel.org/tip/cfb180f3e71b2a280a254c8646a9ab1beab63f84
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sun, 22 Mar 2009 03:31:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:38:47 +0100

tracing: add per-subsystem filtering

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
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237710677.7703.49.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h               |   15 ++++++
 kernel/trace/trace_events.c        |   86 +++++++++++++++++++++++++++++++++---
 kernel/trace/trace_events_filter.c |   80 +++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d9eb39e..f267723 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -804,6 +804,18 @@ struct ftrace_event_call {
 #endif
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
@@ -832,6 +844,9 @@ extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_free_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern void filter_free_subsystem_preds(struct event_subsystem *system);
+extern int filter_add_subsystem_pred(struct event_subsystem *system,
+				     struct filter_pred *pred);
 
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 97470c4..97d4daa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -524,6 +524,71 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
@@ -575,6 +640,12 @@ static const struct file_operations ftrace_event_filter_fops = {
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
@@ -595,18 +666,13 @@ static struct dentry *event_trace_events_dir(void)
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
@@ -633,6 +699,14 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
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
index 8e8c5fa..1ab20ce 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -181,6 +181,27 @@ void filter_free_preds(struct ftrace_event_call *call)
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
@@ -250,6 +271,65 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
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
+		if (i == MAX_FILTER_PRED - 1)
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
