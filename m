Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYAOU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYAOU4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbYAOUuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:52 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:51794 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbYAOUug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:36 -0500
Message-Id: <20080115205022.425102898@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 07/30 v3] tracer add debugfs interface
Content-Disposition: inline; filename=mcount-tracer-debugfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface into debugfs.

  /debugfs/tracing/ctrl

echoing 1 into the ctrl file turns on the tracer,
and echoing 0 turns it off.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/tracing/tracer.h |    1 
 2 files changed, 87 insertions(+), 1 deletion(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-14 14:57:59.000000000 -0500
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/mcount.h>
 
 #include "tracer.h"
@@ -58,9 +60,12 @@ static notrace void trace_function(const
 	int cpu;
 
 	raw_local_irq_save(flags);
-	cpu = raw_smp_processor_id();
 
 	tr = &mctracer_trace;
+	if (!tr->ctrl)
+		goto out;
+
+	cpu = raw_smp_processor_id();
 
 	atomic_inc(&tr->disabled[cpu]);
 	if (likely(atomic_read(&tr->disabled[cpu]) == 1))
@@ -68,6 +73,7 @@ static notrace void trace_function(const
 
 	atomic_dec(&tr->disabled[cpu]);
 
+ out:
 	raw_local_irq_restore(flags);
 }
 
@@ -76,6 +82,83 @@ static struct mcount_ops trace_ops __rea
 	.func = trace_function,
 };
 
+#ifdef CONFIG_DEBUG_FS
+static int mctracer_open_generic(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+
+static ssize_t mctracer_ctrl_read(struct file *filp, char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	struct mctracer_trace *tr = filp->private_data;
+	char buf[16];
+	int r;
+
+	r = sprintf(buf, "%ld\n", tr->ctrl);
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+
+static ssize_t mctracer_ctrl_write(struct file *filp,
+				   const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	struct mctracer_trace *tr = filp->private_data;
+	long val;
+	char buf[16];
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	val = !!simple_strtoul(buf, NULL, 10);
+
+	tr->ctrl = val;
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations mctracer_ctrl_fops = {
+	.open = mctracer_open_generic,
+	.read = mctracer_ctrl_read,
+	.write = mctracer_ctrl_write,
+};
+
+static void mctrace_init_debugfs(void)
+{
+	struct dentry *d_mctracer;
+	struct dentry *entry;
+
+	d_mctracer = debugfs_create_dir("tracing", NULL);
+	if (!d_mctracer) {
+		pr_warning("Could not create debugfs directory mctracer\n");
+		return;
+	}
+
+	entry = debugfs_create_file("ctrl", 0644, d_mctracer,
+				    &mctracer_trace, &mctracer_ctrl_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ctrl' entry\n");
+}
+#else /* CONFIG_DEBUG_FS */
+static void mctrace_init_debugfs(void)
+{
+	/*
+	 * No way to turn on or off the trace function
+	 * without debugfs.
+	 */
+}
+#endif /* CONFIG_DEBUG_FS */
+
 static notrace int page_order(const unsigned long size)
 {
 	const unsigned long nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
@@ -112,6 +195,8 @@ static notrace int mctracer_alloc_buffer
 
 	register_mcount_function(&trace_ops);
 
+	mctrace_init_debugfs();
+
 	return 0;
 
  free_buffers:
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-14 14:57:58.000000000 -0500
@@ -13,6 +13,7 @@ struct mctracer_trace {
 	void	      *trace[NR_CPUS];
 	unsigned long trace_idx[NR_CPUS];
 	unsigned long entries;
+	long	      ctrl;
 	atomic_t      cnt;
 	atomic_t      disabled[NR_CPUS];
 	atomic_t      underrun[NR_CPUS];

-- 
