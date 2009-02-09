Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZBIGQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZBIGQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZBIGPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:15:38 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46970 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZBIGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZJL1GETqyxWW0DS5pZCMheUourwj1rpKCHsZztCPXxYG7xa4sYaaqRtCCPTLm6zcCo
         tnMwki9a2bm4neszaHDMQpmUZL1k7oh+BITsiUXm+MkQV6qsp6bh28aJVCcE8q7q3/uI
         kUn+GvHTdDS4lvw0TTN9d7CyPWRKhYzyJYfh4=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, penberg@cs.helsinki.fi, rostedt@goodmis.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] trace: splice support for tracing_pipe
Date: Mon,  9 Feb 2009 08:15:56 +0200
Message-Id: <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
 <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1234159200.git.eduard.munteanu@linux360.ro>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added and implemented tracing_pipe_fops->splice_read(). This allows
userspace programs to get tracing data more efficiently.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/trace.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h |    6 ++
 2 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 130c4f5..5b136ed 100644
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
@@ -2495,6 +2515,121 @@ out:
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
@@ -2658,6 +2793,7 @@ static struct file_operations tracing_pipe_fops = {
 	.open		= tracing_open_pipe,
 	.poll		= tracing_poll_pipe,
 	.read		= tracing_read_pipe,
+	.splice_read	= tracing_splice_read_pipe,
 	.release	= tracing_release_pipe,
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f2742fb..d58c305 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -352,6 +352,12 @@ struct tracer {
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
1.6.0.6

