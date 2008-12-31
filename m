Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYLaDBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYLaDBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYLaC7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:59:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYLaC73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:59:29 -0500
Message-ID: <495ADF57.8030008@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 10:56:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] ftrace: show ftrace_bprintk()'s formats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: let user knows the format

Create a file on <debugfs-dir>/tracing/ to show ftrace_bprintk()'s formats.

This formats will help for these condition:
1) User get binary data from core file.(formats are backup before coredump)
2) User splice ring_buffer to a file.
User can use formats for parsing the binary data in userspace.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 trace.c         |    8 +++++
 trace.h         |    1
 trace_bprintk.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 61c9108..085cc8a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2944,6 +2944,14 @@ static __init int tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'trace_marker' entry\n");
 
+#ifdef CONFIG_TRACE_BPRINTK
+	entry = debugfs_create_file("trace_bprintk_formats", 0444, d_tracer,
+				    NULL, &trace_bprintk_fmt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'trace_bprintk_formats' entry\n");
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6885d13..c50826d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -128,6 +128,7 @@ struct bprintk_entry {
 	u32 buf[];
 };
 #ifdef CONFIG_TRACE_BPRINTK
+extern struct file_operations trace_bprintk_fmt_fops;
 extern int trace_bprintk_enable;
 #endif
 
diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_bprintk.c
index 84c7a9c..cbe89dd 100644
--- a/kernel/trace/trace_bprintk.c
+++ b/kernel/trace/trace_bprintk.c
@@ -156,6 +156,85 @@ static struct notifier_block module_trace_bprintk_format_nb = {
 	.notifier_call = module_trace_bprintk_format_notify,
 };
 
+/* shows ftrace_bprintk()'s format */
+extern char *__start___trace_bprintk_fmt[], *__stop___trace_bprintk_fmt[];
+
+static void *fmt_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t tmp;
+	struct trace_bprintk_fmt *tb_fmt;
+
+	lock_btrace();
+	if (*pos < __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt)
+		return __stop___trace_bprintk_fmt[*pos - 1];
+
+	tmp = __start___trace_bprintk_fmt + *pos - __stop___trace_bprintk_fmt;
+	list_for_each_entry(tb_fmt, &trace_bprintk_fmt_list, list) {
+		if (tmp-- == 0)
+			return tb_fmt->fmt;
+	}
+	return NULL;
+}
+
+static void *fmt_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	char *fmt = p;
+	struct list_head *list;
+
+	++*pos;
+	if (*pos < __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt)
+		return __stop___trace_bprintk_fmt[*pos - 1];
+
+	if (__start___trace_bprintk_fmt + *pos - __stop___trace_bprintk_fmt)
+		list = &container_of(fmt, struct trace_bprintk_fmt, fmt[0])
+				->list;
+	else
+		list = &trace_bprintk_fmt_list;
+
+	if (list->next != &trace_bprintk_fmt_list)
+		return list_entry(list->next, struct trace_bprintk_fmt, list)
+				->fmt;
+	return NULL;
+}
+
+static void fmt_stop(struct seq_file *m, void *p)
+{
+	unlock_btrace();
+}
+
+static int fmt_show(struct seq_file *m, void *p)
+{
+	seq_printf(m, "addr=%p fmt=%s\n", p, (char *)p);
+	return 0;
+}
+
+static struct seq_operations trace_bprintk_fmt_seq_ops = {
+	.start		= fmt_start,
+	.next		= fmt_next,
+	.stop		= fmt_stop,
+	.show		= fmt_show,
+};
+
+static int fmt_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &trace_bprintk_fmt_seq_ops);
+	if (!ret)
+		get_btrace_metadata();
+	return ret;
+}
+
+static int fmt_release(struct inode *inode, struct file *file)
+{
+	put_btrace_metadata();
+	return seq_release(inode, file);
+}
+
+struct file_operations trace_bprintk_fmt_fops = {
+	.open		= fmt_open,
+	.read		= seq_read,
+	.release	= fmt_release,
+};
+
 /* events tracer */
 int trace_bprintk_enable;
 





