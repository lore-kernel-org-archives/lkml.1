Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYACH1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYACH1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbYACHYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:34 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:40032 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYACHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:20 -0500
Message-Id: <20080103072227.894547203@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:17 -0500
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
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 08/11] tracer add debugfs interface
Content-Disposition: inline; filename=mcount-tracer-debugfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface into debugfs.

  /debugfs/mctracer/ctrl

echoing 1 into the ctrl file turns on the tracer,
and echoing 0 turns it off.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/mcount/tracer.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/mcount/tracer.h |    1 
 2 files changed, 87 insertions(+), 1 deletion(-)

Index: linux-compile.git/lib/mcount/tracer.c
===================================================================
--- linux-compile.git.orig/lib/mcount/tracer.c	2008-01-02 23:07:23.000000000 -0500
+++ linux-compile.git/lib/mcount/tracer.c	2008-01-02 23:12:50.000000000 -0500
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/mcount.h>
 
 #include "tracer.h"
@@ -71,6 +73,89 @@ static inline notrace void trace_functio
 	raw_local_irq_restore(flags);
 }
 
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
+	int val;
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
+	if (tr->ctrl ^ val) {
+		if (val)
+			register_mcount_function(trace_function);
+		else
+			clear_mcount_function();
+		tr->ctrl = val;
+	}
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
+	d_mctracer = debugfs_create_dir("mctracer", NULL);
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
+	 * without debugfs, so we just turn it on.
+	 */
+	register_mcount_function(trace_function);
+}
+#endif /* CONFIG_DEBUG_FS */
 
 static inline notrace int page_order(const unsigned long size)
 {
@@ -107,7 +192,7 @@ static inline notrace int mctracer_alloc
 		size, MCTRACER_NR_ENTRIES, MCTRACER_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", mctracer_trace.entries);
 
-	register_mcount_function(trace_function);
+	mctrace_init_debugfs();
 
 	return 0;
 
Index: linux-compile.git/lib/mcount/tracer.h
===================================================================
--- linux-compile.git.orig/lib/mcount/tracer.h	2008-01-02 23:04:34.000000000 -0500
+++ linux-compile.git/lib/mcount/tracer.h	2008-01-02 23:11:39.000000000 -0500
@@ -13,6 +13,7 @@ struct mctracer_trace {
 	void	      *trace[NR_CPUS];
 	unsigned long trace_idx[NR_CPUS];
 	unsigned long entries;
+	long	      ctrl;
 	atomic_t      cnt;
 	atomic_t      disabled[NR_CPUS];
 	atomic_t      underrun[NR_CPUS];

-- 
