Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZCDCya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZCDCya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZCDCw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZCDCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:53 -0500
Message-Id: <20090304025251.015368537@goodmis.org>
References: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] tracing: add binary buffer files for use with splice
Content-Disposition: inline; filename=0005-tracing-add-binary-buffer-files-for-use-with-splice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: new feature

This patch creates a directory of files that correspond to the
per CPU ring buffers. These are binary files and are made to
be used with splice. This is the fastest way to extract data from
the ftrace ring buffers.

Thanks to Jiaying Zhang for pushing me to get this code fixed,
 and to Eduard - Gabriel Munteanu for his splice code that helped
 me debug my code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  274 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/trace/trace.h |    1 +
 2 files changed, 268 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ea055aa..12539f7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -11,31 +11,30 @@
  *  Copyright (C) 2004-2006 Ingo Molnar
  *  Copyright (C) 2004 William Lee Irwin III
  */
+#include <linux/ring_buffer.h>
 #include <linux/utsrelease.h>
+#include <linux/stacktrace.h>
+#include <linux/writeback.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
 #include <linux/notifier.h>
+#include <linux/irqflags.h>
 #include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
 #include <linux/linkage.h>
 #include <linux/uaccess.h>
+#include <linux/kprobes.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/splice.h>
 #include <linux/kdebug.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
-#include <linux/kprobes.h>
-#include <linux/writeback.h>
-#include <linux/splice.h>
-
-#include <linux/stacktrace.h>
-#include <linux/ring_buffer.h>
-#include <linux/irqflags.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -3005,6 +3004,246 @@ static struct file_operations tracing_mark_fops = {
 	.write		= tracing_mark_write,
 };
 
+struct ftrace_buffer_info {
+	struct trace_array	*tr;
+	void			*spare;
+	int			cpu;
+	unsigned int		read;
+};
+
+static int tracing_buffers_open(struct inode *inode, struct file *filp)
+{
+	int cpu = (int)(long)inode->i_private;
+	struct ftrace_buffer_info *info;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->tr	= &global_trace;
+	info->cpu	= cpu;
+	info->spare	= ring_buffer_alloc_read_page(info->tr->buffer);
+	/* Force reading ring buffer for first read */
+	info->read	= (unsigned int)-1;
+	if (!info->spare)
+		goto out;
+
+	filp->private_data = info;
+
+	return 0;
+
+ out:
+	kfree(info);
+	return -ENOMEM;
+}
+
+static ssize_t
+tracing_buffers_read(struct file *filp, char __user *ubuf,
+		     size_t count, loff_t *ppos)
+{
+	struct ftrace_buffer_info *info = filp->private_data;
+	unsigned int pos;
+	ssize_t ret;
+	size_t size;
+
+	/* Do we have previous read data to read? */
+	if (info->read < PAGE_SIZE)
+		goto read;
+
+	info->read = 0;
+
+	ret = ring_buffer_read_page(info->tr->buffer,
+				    &info->spare,
+				    count,
+				    info->cpu, 0);
+	if (ret < 0)
+		return 0;
+
+	pos = ring_buffer_page_len(info->spare);
+
+	if (pos < PAGE_SIZE)
+		memset(info->spare + pos, 0, PAGE_SIZE - pos);
+
+read:
+	size = PAGE_SIZE - info->read;
+	if (size > count)
+		size = count;
+
+	ret = copy_to_user(ubuf, info->spare + info->read, size);
+	if (ret)
+		return -EFAULT;
+	*ppos += size;
+	info->read += size;
+
+	return size;
+}
+
+static int tracing_buffers_release(struct inode *inode, struct file *file)
+{
+	struct ftrace_buffer_info *info = file->private_data;
+
+	ring_buffer_free_read_page(info->tr->buffer, info->spare);
+	kfree(info);
+
+	return 0;
+}
+
+struct buffer_ref {
+	struct ring_buffer	*buffer;
+	void			*page;
+	int			ref;
+};
+
+static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
+				    struct pipe_buffer *buf)
+{
+	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
+
+	if (--ref->ref)
+		return;
+
+	ring_buffer_free_read_page(ref->buffer, ref->page);
+	kfree(ref);
+	buf->private = 0;
+}
+
+static int buffer_pipe_buf_steal(struct pipe_inode_info *pipe,
+				 struct pipe_buffer *buf)
+{
+	return 1;
+}
+
+static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
+				struct pipe_buffer *buf)
+{
+	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
+
+	ref->ref++;
+}
+
+/* Pipe buffer operations for a buffer. */
+static struct pipe_buf_operations buffer_pipe_buf_ops = {
+	.can_merge		= 0,
+	.map			= generic_pipe_buf_map,
+	.unmap			= generic_pipe_buf_unmap,
+	.confirm		= generic_pipe_buf_confirm,
+	.release		= buffer_pipe_buf_release,
+	.steal			= buffer_pipe_buf_steal,
+	.get			= buffer_pipe_buf_get,
+};
+
+/*
+ * Callback from splice_to_pipe(), if we need to release some pages
+ * at the end of the spd in case we error'ed out in filling the pipe.
+ */
+static void buffer_spd_release(struct splice_pipe_desc *spd, unsigned int i)
+{
+	struct buffer_ref *ref =
+		(struct buffer_ref *)spd->partial[i].private;
+
+	if (--ref->ref)
+		return;
+
+	ring_buffer_free_read_page(ref->buffer, ref->page);
+	kfree(ref);
+	spd->partial[i].private = 0;
+}
+
+static ssize_t
+tracing_buffers_splice_read(struct file *file, loff_t *ppos,
+			    struct pipe_inode_info *pipe, size_t len,
+			    unsigned int flags)
+{
+	struct ftrace_buffer_info *info = file->private_data;
+	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages		= pages,
+		.partial	= partial,
+		.flags		= flags,
+		.ops		= &buffer_pipe_buf_ops,
+		.spd_release	= buffer_spd_release,
+	};
+	struct buffer_ref *ref;
+	int size, i;
+	size_t ret;
+
+	/*
+	 * We can't seek on a buffer input
+	 */
+	if (unlikely(*ppos))
+		return -ESPIPE;
+
+
+	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
+		struct page *page;
+		int r;
+
+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+		if (!ref)
+			break;
+
+		ref->buffer = info->tr->buffer;
+		ref->page = ring_buffer_alloc_read_page(ref->buffer);
+		if (!ref->page) {
+			kfree(ref);
+			break;
+		}
+
+		r = ring_buffer_read_page(ref->buffer, &ref->page,
+					  len, info->cpu, 0);
+		if (r < 0) {
+			ring_buffer_free_read_page(ref->buffer,
+						   ref->page);
+			kfree(ref);
+			break;
+		}
+
+		/*
+		 * zero out any left over data, this is going to
+		 * user land.
+		 */
+		size = ring_buffer_page_len(ref->page);
+		if (size < PAGE_SIZE)
+			memset(ref->page + size, 0, PAGE_SIZE - size);
+
+		page = virt_to_page(ref->page);
+
+		spd.pages[i] = page;
+		spd.partial[i].len = PAGE_SIZE;
+		spd.partial[i].offset = 0;
+		spd.partial[i].private = (unsigned long)ref;
+		spd.nr_pages++;
+	}
+
+	spd.nr_pages = i;
+
+	/* did we read anything? */
+	if (!spd.nr_pages) {
+		if (flags & SPLICE_F_NONBLOCK)
+			ret = -EAGAIN;
+		else
+			ret = 0;
+		/* TODO: block */
+		return ret;
+	}
+
+	ret = splice_to_pipe(pipe, &spd);
+
+	return ret;
+}
+
+static const struct file_operations tracing_buffers_fops = {
+	.open		= tracing_buffers_open,
+	.read		= tracing_buffers_read,
+	.release	= tracing_buffers_release,
+	.splice_read	= tracing_buffers_splice_read,
+	.llseek		= no_llseek,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int __weak ftrace_arch_read_dyn_info(char *buf, int size)
@@ -3399,6 +3638,7 @@ static __init void create_trace_options_dir(void)
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
+	struct dentry *buffers;
 	struct dentry *entry;
 	int cpu;
 
@@ -3471,6 +3711,26 @@ static __init int tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'trace_marker' entry\n");
 
+	buffers = debugfs_create_dir("binary_buffers", d_tracer);
+
+	if (!buffers)
+		pr_warning("Could not create buffers directory\n");
+	else {
+		int cpu;
+		char buf[64];
+
+		for_each_tracing_cpu(cpu) {
+			sprintf(buf, "%d", cpu);
+
+			entry = debugfs_create_file(buf, 0444, buffers,
+						    (void *)(long)cpu,
+						    &tracing_buffers_fops);
+			if (!entry)
+				pr_warning("Could not create debugfs buffers "
+					   "'%s' entry\n", buf);
+		}
+	}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e606633..561bb5c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -217,6 +217,7 @@ enum trace_flag_type {
  */
 struct trace_array_cpu {
 	atomic_t		disabled;
+	void			*buffer_page;	/* ring buffer spare */
 
 	/* these fields get copied into max-trace: */
 	unsigned long		trace_idx;
-- 
1.5.6.5

-- 
