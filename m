Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZCMCpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZCMCpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbZCMCio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbZCMCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:29 -0400
Message-Id: <20090313023826.694210967@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/16] tracing: export trace formats to user space
Content-Disposition: inline; filename=0009-tracing-export-trace-formats-to-user-space.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The binary printk saves a pointer to the format string in the ring buffer.
On output, the format is processed. But if the user is reading the
ring buffer through a binary interface, the pointer is meaningless.

This patch creates a file called printk_formats that maps the pointers
to the formats.

 # cat /debug/tracing/printk_formats
0xffffffff80713d40 : "irq_handler_entry: irq=%d handler=%s\n"
0xffffffff80713d48 : "lock_acquire: %s%s%s\n"
0xffffffff80713d50 : "lock_release: %s\n"

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_printk.c |  119 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index f307a11..4867852 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -4,18 +4,19 @@
  * Copyright (C) 2008 Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  */
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
 #include <linux/string.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/mutex.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
 #include <linux/fs.h>
-#include <linux/marker.h>
-#include <linux/uaccess.h>
 
 #include "trace.h"
 
@@ -153,6 +154,114 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	const char **fmt = m->private;
+	const char **next = fmt;
+
+	(*pos)++;
+
+	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
+		return NULL;
+
+	next = fmt;
+	m->private = ++next;
+
+	return fmt;
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
+	return t_next(m, NULL, pos);
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	const char **fmt = v;
+	const char *str = *fmt;
+	int i;
+
+	seq_printf(m, "0x%lx : \"", (unsigned long)fmt);
+
+	/*
+	 * Tabs and new lines need to be converted.
+	 */
+	for (i = 0; str[i]; i++) {
+		switch (str[i]) {
+		case '\n':
+			seq_puts(m, "\\n");
+			break;
+		case '\t':
+			seq_puts(m, "\\t");
+			break;
+		case '\\':
+			seq_puts(m, "\\");
+			break;
+		case '"':
+			seq_puts(m, "\\\"");
+			break;
+		default:
+			seq_putc(m, str[i]);
+		}
+	}
+	seq_puts(m, "\"\n");
+
+	return 0;
+}
+
+static void t_stop(struct seq_file *m, void *p)
+{
+}
+
+static const struct seq_operations show_format_seq_ops = {
+	.start = t_start,
+	.next = t_next,
+	.show = t_show,
+	.stop = t_stop,
+};
+
+static int
+ftrace_formats_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &show_format_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+
+		m->private = __start___trace_bprintk_fmt;
+	}
+	return ret;
+}
+
+static const struct file_operations ftrace_formats_fops = {
+	.open = ftrace_formats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static __init int init_trace_printk_function_export(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("printk_formats", 0444, d_tracer,
+				    NULL, &ftrace_formats_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'printk_formats' entry\n");
+
+	return 0;
+}
+
+fs_initcall(init_trace_printk_function_export);
+
 static __init int init_trace_printk(void)
 {
 	return register_module_notifier(&module_trace_bprintk_format_nb);
-- 
1.6.1.3

-- 
