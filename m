Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZBIRaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZBIRaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZBIRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:30:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbZBIRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:30:03 -0500
Message-Id: <20090209172956.970104543@goodmis.org>
References: <20090209172830.087244662@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 12:28:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] tracing: clean up splice code
Content-Disposition: inline; filename=0003-tracing-clean-up-splice-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar suggested a series of clean ups for the splice code.
This patch implements those suggestions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   96 ++++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 41 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 11fde0a..d898212 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2537,15 +2537,49 @@ static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
 }
 
 static struct pipe_buf_operations tracing_pipe_buf_ops = {
-	.can_merge = 0,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
-	.confirm = generic_pipe_buf_confirm,
-	.release = tracing_pipe_buf_release,
-	.steal = generic_pipe_buf_steal,
-	.get = generic_pipe_buf_get,
+	.can_merge		= 0,
+	.map			= generic_pipe_buf_map,
+	.unmap			= generic_pipe_buf_unmap,
+	.confirm		= generic_pipe_buf_confirm,
+	.release		= tracing_pipe_buf_release,
+	.steal			= generic_pipe_buf_steal,
+	.get			= generic_pipe_buf_get,
 };
 
+static size_t
+tracing_fill_pipe_page(struct page *pages, size_t rem,
+			struct trace_iterator *iter)
+{
+	size_t count;
+	int ret;
+
+	/* Seq buffer is page-sized, exactly what we need. */
+	for (;;) {
+		count = iter->seq.len;
+		ret = print_trace_line(iter);
+		count = iter->seq.len - count;
+		if (rem < count) {
+			rem = 0;
+			iter->seq.len -= count;
+			break;
+		}
+		if (ret == TRACE_TYPE_PARTIAL_LINE) {
+			iter->seq.len -= count;
+			break;
+		}
+
+		trace_consume(iter);
+		rem -= count;
+		if (!find_next_entry_inc(iter))	{
+			rem = 0;
+			iter->ent = NULL;
+			break;
+		}
+	}
+
+	return rem;
+}
+
 static ssize_t tracing_splice_read_pipe(struct file *filp,
 					loff_t *ppos,
 					struct pipe_inode_info *pipe,
@@ -2556,15 +2590,15 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	struct partial_page partial[PIPE_BUFFERS];
 	struct trace_iterator *iter = filp->private_data;
 	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.nr_pages = 0, /* This gets updated below. */
-		.flags = flags,
-		.ops = &tracing_pipe_buf_ops,
-		.spd_release = tracing_spd_release_pipe,
+		.pages		= pages,
+		.partial	= partial,
+		.nr_pages	= 0, /* This gets updated below. */
+		.flags		= flags,
+		.ops		= &tracing_pipe_buf_ops,
+		.spd_release	= tracing_spd_release_pipe,
 	};
 	ssize_t ret;
-	size_t count, rem;
+	size_t rem;
 	unsigned int i;
 
 	mutex_lock(&trace_types_lock);
@@ -2573,45 +2607,25 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		ret = iter->trace->splice_read(iter, filp,
 					       ppos, pipe, len, flags);
 		if (ret)
-			goto out;
+			goto out_err;
 	}
 
 	ret = tracing_wait_pipe(filp);
 	if (ret <= 0)
-		goto out;
+		goto out_err;
 
 	if (!iter->ent && !find_next_entry_inc(iter)) {
 		ret = -EFAULT;
-		goto out;
+		goto out_err;
 	}
 
 	/* Fill as many pages as possible. */
 	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
+		if (!pages[i])
+			break;
 
-		/* Seq buffer is page-sized, exactly what we need. */
-		for (;;) {
-			count = iter->seq.len;
-			ret = print_trace_line(iter);
-			count = iter->seq.len - count;
-			if (rem < count) {
-				rem = 0;
-				iter->seq.len -= count;
-				break;
-			}
-			if (ret == TRACE_TYPE_PARTIAL_LINE) {
-				iter->seq.len -= count;
-				break;
-			}
-
-			trace_consume(iter);
-			rem -= count;
-			if (!find_next_entry_inc(iter))	{
-				rem = 0;
-				iter->ent = NULL;
-				break;
-			}
-		}
+		rem = tracing_fill_pipe_page(pages[i], rem, iter);
 
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
@@ -2633,7 +2647,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	return splice_to_pipe(pipe, &spd);
 
-out:
+out_err:
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
-- 
1.5.6.5

-- 
