Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZB0FgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZB0FgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZB0Fes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053442.333424258@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] tracing: add tracer dependent options to options directory
Content-Disposition: inline; filename=0002-tracing-add-tracer-dependent-options-to-options-dir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the tracer dependent options dynamically to the
options directory when the tracer is activated. These options are
removed when the tracer is deactivated.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  174 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 173 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 40e983e..485c6e7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2275,8 +2275,17 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
+struct trace_option_dentry;
+
+static struct trace_option_dentry *
+create_trace_option_files(struct tracer *tracer);
+
+static void
+destroy_trace_option_files(struct trace_option_dentry *topts);
+
 static int tracing_set_tracer(const char *buf)
 {
+	static struct trace_option_dentry *topts;
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
 	int ret = 0;
@@ -2297,7 +2306,12 @@ static int tracing_set_tracer(const char *buf)
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
 
+	destroy_trace_option_files(topts);
+
 	current_trace = t;
+
+	topts = create_trace_option_files(current_trace);
+
 	if (t->init) {
 		ret = tracer_init(t, tr);
 		if (ret)
@@ -3093,6 +3107,95 @@ static void tracing_init_debugfs_percpu(long cpu)
 #include "trace_selftest.c"
 #endif
 
+struct trace_option_dentry {
+	struct tracer_opt		*opt;
+	struct tracer_flags		*flags;
+	struct dentry			*entry;
+};
+
+static ssize_t
+trace_options_read(struct file *filp, char __user *ubuf, size_t cnt,
+			loff_t *ppos)
+{
+	struct trace_option_dentry *topt = filp->private_data;
+	char *buf;
+
+	if (topt->flags->val & topt->opt->bit)
+		buf = "1\n";
+	else
+		buf = "0\n";
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+}
+
+static ssize_t
+trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
+			 loff_t *ppos)
+{
+	struct trace_option_dentry *topt = filp->private_data;
+	unsigned long val;
+	char buf[64];
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = 0;
+	switch (val) {
+	case 0:
+		/* do nothing if already cleared */
+		if (!(topt->flags->val & topt->opt->bit))
+			break;
+
+		mutex_lock(&trace_types_lock);
+		if (current_trace->set_flag)
+			ret = current_trace->set_flag(topt->flags->val,
+						      topt->opt->bit, 0);
+		mutex_unlock(&trace_types_lock);
+		if (ret)
+			return ret;
+		topt->flags->val &= ~topt->opt->bit;
+		break;
+	case 1:
+		/* do nothing if already set */
+		if (topt->flags->val & topt->opt->bit)
+			break;
+
+		mutex_lock(&trace_types_lock);
+		if (current_trace->set_flag)
+			ret = current_trace->set_flag(topt->flags->val,
+						      topt->opt->bit, 1);
+		mutex_unlock(&trace_types_lock);
+		if (ret)
+			return ret;
+		topt->flags->val |= topt->opt->bit;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
+
+static const struct file_operations trace_options_fops = {
+	.open = tracing_open_generic,
+	.read = trace_options_read,
+	.write = trace_options_write,
+};
+
 static ssize_t
 trace_options_core_read(struct file *filp, char __user *ubuf, size_t cnt,
 			loff_t *ppos)
@@ -3146,7 +3249,6 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
-
 static const struct file_operations trace_options_core_fops = {
 	.open = tracing_open_generic,
 	.read = trace_options_core_read,
@@ -3174,6 +3276,76 @@ static struct dentry *trace_options_init_dentry(void)
 	return t_options;
 }
 
+static void
+create_trace_option_file(struct trace_option_dentry *topt,
+			 struct tracer_flags *flags,
+			 struct tracer_opt *opt)
+{
+	struct dentry *t_options;
+	struct dentry *entry;
+
+	t_options = trace_options_init_dentry();
+	if (!t_options)
+		return;
+
+	topt->flags = flags;
+	topt->opt = opt;
+
+	entry = debugfs_create_file(opt->name, 0644, t_options, topt,
+				    &trace_options_fops);
+
+	topt->entry = entry;
+
+}
+
+static struct trace_option_dentry *
+create_trace_option_files(struct tracer *tracer)
+{
+	struct trace_option_dentry *topts;
+	struct tracer_flags *flags;
+	struct tracer_opt *opts;
+	int cnt;
+
+	if (!tracer)
+		return NULL;
+
+	flags = tracer->flags;
+
+	if (!flags || !flags->opts)
+		return NULL;
+
+	opts = flags->opts;
+
+	for (cnt = 0; opts[cnt].name; cnt++)
+		;
+
+	topts = kzalloc(sizeof(*topts) * (cnt + 1), GFP_KERNEL);
+	if (!topts)
+		return NULL;
+
+	for (cnt = 0; opts[cnt].name; cnt++)
+		create_trace_option_file(&topts[cnt], flags,
+					 &opts[cnt]);
+
+	return topts;
+}
+
+static void
+destroy_trace_option_files(struct trace_option_dentry *topts)
+{
+	int cnt;
+
+	if (!topts)
+		return;
+
+	for (cnt = 0; topts[cnt].opt; cnt++) {
+		if (topts[cnt].entry)
+			debugfs_remove(topts[cnt].entry);
+	}
+
+	kfree(topts);
+}
+
 static struct dentry *
 create_trace_option_core_file(const char *option, long index)
 {
-- 
1.5.6.5

-- 
