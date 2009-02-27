Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZB0Ffm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZB0Ffm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZB0Fer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053442.090760812@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] tracing: add options directory and core option files
Content-Disposition: inline; filename=0001-tracing-add-options-directory-and-core-option-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch creates an options directory in the debugfs, that contains
the available tracing options. These files contain 1 or 0, where 1
is the option is enabled and 0 it is disabled.

Simply echoing in 1 will enable the option and 0 will disable it.
This patch only contains the core options, not the tracer options.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bdaf60d..40e983e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3093,6 +3093,121 @@ static void tracing_init_debugfs_percpu(long cpu)
 #include "trace_selftest.c"
 #endif
 
+static ssize_t
+trace_options_core_read(struct file *filp, char __user *ubuf, size_t cnt,
+			loff_t *ppos)
+{
+	long index = (long)filp->private_data;
+	char *buf;
+
+	if (trace_flags & (1 << index))
+		buf = "1\n";
+	else
+		buf = "0\n";
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+}
+
+static ssize_t
+trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
+			 loff_t *ppos)
+{
+	long index = (long)filp->private_data;
+	char buf[64];
+	unsigned long val;
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
+	switch (val) {
+	case 0:
+		trace_flags &= ~(1 << index);
+		break;
+	case 1:
+		trace_flags |= 1 << index;
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
+static const struct file_operations trace_options_core_fops = {
+	.open = tracing_open_generic,
+	.read = trace_options_core_read,
+	.write = trace_options_core_write,
+};
+
+static struct dentry *trace_options_init_dentry(void)
+{
+	struct dentry *d_tracer;
+	static struct dentry *t_options;
+
+	if (t_options)
+		return t_options;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return NULL;
+
+	t_options = debugfs_create_dir("options", d_tracer);
+	if (!t_options) {
+		pr_warning("Could not create debugfs directory 'options'\n");
+		return NULL;
+	}
+
+	return t_options;
+}
+
+static struct dentry *
+create_trace_option_core_file(const char *option, long index)
+{
+	struct dentry *t_options;
+	struct dentry *entry;
+
+	t_options = trace_options_init_dentry();
+	if (!t_options)
+		return NULL;
+
+	entry = debugfs_create_file(option, 0644, t_options, (void *)index,
+				    &trace_options_core_fops);
+
+	return entry;
+}
+
+static __init void create_trace_options_dir(void)
+{
+	struct dentry *t_options;
+	struct dentry *entry;
+	int i;
+
+	t_options = trace_options_init_dentry();
+	if (!t_options)
+		return;
+
+	for (i = 0; trace_options[i]; i++) {
+		entry = create_trace_option_core_file(trace_options[i], i);
+		if (!entry)
+			pr_warning("Could not create debugfs %s entry\n",
+				   trace_options[i]);
+	}
+}
+
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -3111,6 +3226,8 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace_options' entry\n");
 
+	create_trace_options_dir();
+
 	entry = debugfs_create_file("tracing_cpumask", 0644, d_tracer,
 				    NULL, &tracing_cpumask_fops);
 	if (!entry)
-- 
1.5.6.5

-- 
