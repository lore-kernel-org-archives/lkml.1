Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZBIRbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZBIRbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZBIRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:30:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbZBIRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:30:01 -0500
Message-Id: <20090209172956.561364185@goodmis.org>
References: <20090209172830.087244662@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 12:28:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] tracing: splice support for tracing_pipe
Content-Disposition: inline; filename=0001-tracing-splice-support-for-tracing_pipe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Added and implemented tracing_pipe_fops->splice_read(). This allows
userspace programs to get tracing data more efficiently.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h |    6 ++
 2 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b1e9a9..9e29fdb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -31,6 +31,7 @@
 #include <linux/fs.h>
 #include <linux/kprobes.h>
 #include <linux/writeback.h>
+#include <linux/splice.h>
 
 #include <linux/stacktrace.h>
 #include <linux/ring_buffer.h>
@@ -364,6 +365,25 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	return cnt;
 }
 
+ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
+{
+	int len;
+	void *ret;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = memcpy(buf, s->buffer + s->readpos, cnt);
+	if (!ret)
+		return -EFAULT;
+
+	s->readpos += len;
+	return cnt;
+}
+
 static void
 trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
@@ -2493,6 +2513,121 @@ out:
 	return sret;
 }
 
+static void tracing_pipe_buf_release(struct pipe_inode_info *pipe,
+				     struct pipe_buffer *buf)
+{
+	__free_page(buf->page);
+}
+
+static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
+				     unsigned int idx)
+{
+	__free_page(spd->pages[idx]);
+}
+
+static struct pipe_buf_operations tracing_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = tracing_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+static ssize_t tracing_splice_read_pipe(struct file *filp,
+					loff_t *ppos,
+					struct pipe_inode_info *pipe,
+					size_t len,
+					unsigned int flags)
+{
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct trace_iterator *iter = filp->private_data;
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.nr_pages = 0, /* This gets updated below. */
+		.flags = flags,
+		.ops = &tracing_pipe_buf_ops,
+		.spd_release = tracing_spd_release_pipe,
+	};
+	ssize_t ret;
+	size_t count, rem;
+	unsigned int i;
+
+	mutex_lock(&trace_types_lock);
+
+	if (iter->trace->splice_read) {
+		ret = iter->trace->splice_read(iter, filp,
+					       ppos, pipe, len, flags);
+		if (ret)
+			goto out;
+	}
+
+	ret = tracing_wait_pipe(filp);
+	if (ret <= 0)
+		goto out;
+
+	if (!iter->ent && !find_next_entry_inc(iter)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* Fill as many pages as possible. */
+	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
+		pages[i] = alloc_page(GFP_KERNEL);
+
+		/* Seq buffer is page-sized, exactly what we need. */
+		for (;;) {
+			count = iter->seq.len;
+			ret = print_trace_line(iter);
+			count = iter->seq.len - count;
+			if (rem < count) {
+				rem = 0;
+				iter->seq.len -= count;
+				break;
+			}
+			if (ret == TRACE_TYPE_PARTIAL_LINE) {
+				iter->seq.len -= count;
+				break;
+			}
+
+			trace_consume(iter);
+			rem -= count;
+			if (!find_next_entry_inc(iter))	{
+				rem = 0;
+				iter->ent = NULL;
+				break;
+			}
+		}
+
+		/* Copy the data into the page, so we can start over. */
+		ret = trace_seq_to_buffer(&iter->seq,
+					  page_address(pages[i]),
+					  iter->seq.len);
+		if (ret < 0) {
+			__free_page(pages[i]);
+			break;
+		}
+		partial[i].offset = 0;
+		partial[i].len = iter->seq.len;
+
+		trace_seq_reset(&iter->seq);
+	}
+
+	mutex_unlock(&trace_types_lock);
+
+	spd.nr_pages = i;
+
+	return splice_to_pipe(pipe, &spd);
+
+out:
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
@@ -2656,6 +2791,7 @@ static struct file_operations tracing_pipe_fops = {
 	.open		= tracing_open_pipe,
 	.poll		= tracing_poll_pipe,
 	.read		= tracing_read_pipe,
+	.splice_read	= tracing_splice_read_pipe,
 	.release	= tracing_release_pipe,
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7b0518a..dbff020 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -353,6 +353,12 @@ struct tracer {
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
 					size_t cnt, loff_t *ppos);
+	ssize_t			(*splice_read)(struct trace_iterator *iter,
+					       struct file *filp,
+					       loff_t *ppos,
+					       struct pipe_inode_info *pipe,
+					       size_t len,
+					       unsigned int flags);
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
-- 
1.5.6.5

-- 
