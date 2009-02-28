Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZB1JOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZB1JOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZB1JJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZB1JJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:41 -0500
Message-Id: <20090228090938.397793965@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/10] tracing: add raw fast tracing interface for trace events
Content-Disposition: inline; filename=0008-tracing-add-raw-fast-tracing-interface-for-trace-ev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the interface to enable the C style trace points.
In the directory /debugfs/tracing/events/subsystem/event
We now have three files:

 enable : values 0 or 1 to enable or disable the trace event.

 available_types: values 'raw' and 'printf' which indicate the tracing
       types available for the trace point. If a developer does not
       use the TRACE_EVENT_FORMAT macro and just uses the TRACE_FORMAT
       macro, then only 'printf' will be available. This file is
       read only.

 type: values 'raw' or 'printf'. This indicates which type of tracing
       is active for that trace point. 'printf' is the default and
       if 'raw' is not available, this file is read only.

 # echo raw > /debug/tracing/events/sched/sched_wakeup/type
 # echo 1 > /debug/tracing/events/sched/sched_wakeup/enable

 Will enable the C style tracing for the sched_wakeup trace point.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h        |    7 ++
 kernel/trace/trace_events.c |  199 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 181 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index aa1ab0c..f6fa0b9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -726,6 +726,12 @@ static inline void trace_branch_disable(void)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
+/* trace event type bit fields, not numeric */
+enum {
+	TRACE_EVENT_TYPE_PRINTF		= 1,
+	TRACE_EVENT_TYPE_RAW		= 2,
+};
+
 struct ftrace_event_call {
 	char		*name;
 	char		*system;
@@ -736,6 +742,7 @@ struct ftrace_event_call {
 	int		id;
 	struct dentry	*raw_dir;
 	int		raw_enabled;
+	int		type;
 	int		(*raw_init)(void);
 	int		(*raw_reg)(void);
 	void		(*raw_unreg)(void);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 77a5c02..1d07f80 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -44,6 +44,36 @@ static void ftrace_clear_events(void)
 	}
 }
 
+static void ftrace_event_enable_disable(struct ftrace_event_call *call,
+					int enable)
+{
+
+	switch (enable) {
+	case 0:
+		if (call->enabled) {
+			call->enabled = 0;
+			call->unregfunc();
+		}
+		if (call->raw_enabled) {
+			call->raw_enabled = 0;
+			call->raw_unreg();
+		}
+		break;
+	case 1:
+		if (!call->enabled &&
+		    (call->type & TRACE_EVENT_TYPE_PRINTF)) {
+			call->enabled = 1;
+			call->regfunc();
+		}
+		if (!call->raw_enabled &&
+		    (call->type & TRACE_EVENT_TYPE_RAW)) {
+			call->raw_enabled = 1;
+			call->raw_reg();
+		}
+		break;
+	}
+}
+
 static int ftrace_set_clr_event(char *buf, int set)
 {
 	struct ftrace_event_call *call = __start_ftrace_events;
@@ -90,19 +120,8 @@ static int ftrace_set_clr_event(char *buf, int set)
 		if (event && strcmp(event, call->name) != 0)
 			continue;
 
-		if (set) {
-			/* Already set? */
-			if (call->enabled)
-				return 0;
-			call->enabled = 1;
-			call->regfunc();
-		} else {
-			/* Already cleared? */
-			if (!call->enabled)
-				return 0;
-			call->enabled = 0;
-			call->unregfunc();
-		}
+		ftrace_event_enable_disable(call, set);
+
 		ret = 0;
 	}
 	return ret;
@@ -273,7 +292,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	struct ftrace_event_call *call = filp->private_data;
 	char *buf;
 
-	if (call->enabled)
+	if (call->enabled || call->raw_enabled)
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -304,18 +323,8 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	switch (val) {
 	case 0:
-		if (!call->enabled)
-			break;
-
-		call->enabled = 0;
-		call->unregfunc();
-		break;
 	case 1:
-		if (call->enabled)
-			break;
-
-		call->enabled = 1;
-		call->regfunc();
+		ftrace_event_enable_disable(call, val);
 		break;
 
 	default:
@@ -327,6 +336,107 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static ssize_t
+event_type_read(struct file *filp, char __user *ubuf, size_t cnt,
+		loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	char buf[16];
+	int r = 0;
+
+	if (call->type & TRACE_EVENT_TYPE_PRINTF)
+		r += sprintf(buf, "printf\n");
+
+	if (call->type & TRACE_EVENT_TYPE_RAW)
+		r += sprintf(buf+r, "raw\n");
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+event_type_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		 loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	char buf[64];
+
+	/*
+	 * If there's only one type, we can't change it.
+	 * And currently we always have printf type, and we
+	 * may or may not have raw type.
+	 *
+	 * This is a redundant check, the file should be read
+	 * only if this is the case anyway.
+	 */
+
+	if (!call->raw_init)
+		return -EPERM;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	if (!strncmp(buf, "printf", 6) &&
+	    (!buf[6] || isspace(buf[6]))) {
+
+		call->type = TRACE_EVENT_TYPE_PRINTF;
+
+		/*
+		 * If raw enabled, the disable it and enable
+		 * printf type.
+		 */
+		if (call->raw_enabled) {
+			call->raw_enabled = 0;
+			call->raw_unreg();
+
+			call->enabled = 1;
+			call->regfunc();
+		}
+
+	} else if (!strncmp(buf, "raw", 3) &&
+	    (!buf[3] || isspace(buf[3]))) {
+
+		call->type = TRACE_EVENT_TYPE_RAW;
+
+		/*
+		 * If printf enabled, the disable it and enable
+		 * raw type.
+		 */
+		if (call->enabled) {
+			call->enabled = 0;
+			call->unregfunc();
+
+			call->raw_enabled = 1;
+			call->raw_reg();
+		}
+	} else
+		return -EINVAL;
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
+static ssize_t
+event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
+			   loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	char buf[16];
+	int r = 0;
+
+	r += sprintf(buf, "printf\n");
+
+	if (call->raw_init)
+		r += sprintf(buf+r, "raw\n");
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -362,6 +472,17 @@ static const struct file_operations ftrace_enable_fops = {
 	.write = event_enable_write,
 };
 
+static const struct file_operations ftrace_type_fops = {
+	.open = tracing_open_generic,
+	.read = event_type_read,
+	.write = event_type_write,
+};
+
+static const struct file_operations ftrace_available_types_fops = {
+	.open = tracing_open_generic,
+	.read = event_available_types_read,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -427,6 +548,7 @@ static int
 event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 {
 	struct dentry *entry;
+	int ret;
 
 	/*
 	 * If the trace point header did not define TRACE_SYSTEM
@@ -435,6 +557,18 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	if (strcmp(call->system, "TRACE_SYSTEM") != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
+	if (call->raw_init) {
+		ret = call->raw_init();
+		if (ret < 0) {
+			pr_warning("Could not initialize trace point"
+				   " events/%s\n", call->name);
+			return ret;
+		}
+	}
+
+	/* default the output to printf */
+	call->type = TRACE_EVENT_TYPE_PRINTF;
+
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
 		pr_warning("Could not create debugfs "
@@ -448,6 +582,21 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		pr_warning("Could not create debugfs "
 			   "'%s/enable' entry\n", call->name);
 
+	/* Only let type be writable, if we can change it */
+	entry = debugfs_create_file("type",
+				    call->raw_init ? 0644 : 0444,
+				    call->dir, call,
+				    &ftrace_type_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/type' entry\n", call->name);
+
+	entry = debugfs_create_file("available_types", 0444, call->dir, call,
+				    &ftrace_available_types_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/type' available_types\n", call->name);
+
 	return 0;
 }
 
-- 
1.5.6.5

-- 
