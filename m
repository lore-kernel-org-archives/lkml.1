Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZBIRbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZBIRbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZBIRaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:30:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZBIRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:30:01 -0500
Message-Id: <20090209172956.784717880@goodmis.org>
References: <20090209172830.087244662@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 12:28:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] tracing: Move pipe waiting code out of tracing_read_pipe().
Content-Disposition: inline; filename=0002-tracing-Move-pipe-waiting-code-out-of-tracing_read_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

This moves the pipe waiting code from tracing_read_pipe() into
tracing_wait_pipe(), which is useful to implement other fops, like
splice_read.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   69 +++++++++++++++++++++++++++++---------------------
 1 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e29fdb..11fde0a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2388,37 +2388,15 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 	}
 }
 
-/*
- * Consumer reader.
- */
-static ssize_t
-tracing_read_pipe(struct file *filp, char __user *ubuf,
-		  size_t cnt, loff_t *ppos)
+/* Must be called with trace_types_lock mutex held. */
+static int tracing_wait_pipe(struct file *filp)
 {
 	struct trace_iterator *iter = filp->private_data;
-	ssize_t sret;
-
-	/* return any leftover data */
-	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (sret != -EBUSY)
-		return sret;
-
-	trace_seq_reset(&iter->seq);
 
-	mutex_lock(&trace_types_lock);
-	if (iter->trace->read) {
-		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
-		if (sret)
-			goto out;
-	}
-
-waitagain:
-	sret = 0;
 	while (trace_empty(iter)) {
 
 		if ((filp->f_flags & O_NONBLOCK)) {
-			sret = -EAGAIN;
-			goto out;
+			return -EAGAIN;
 		}
 
 		/*
@@ -2443,12 +2421,11 @@ waitagain:
 		iter->tr->waiter = NULL;
 
 		if (signal_pending(current)) {
-			sret = -EINTR;
-			goto out;
+			return -EINTR;
 		}
 
 		if (iter->trace != current_trace)
-			goto out;
+			return 0;
 
 		/*
 		 * We block until we read something and tracing is disabled.
@@ -2465,9 +2442,43 @@ waitagain:
 		continue;
 	}
 
+	return 1;
+}
+
+/*
+ * Consumer reader.
+ */
+static ssize_t
+tracing_read_pipe(struct file *filp, char __user *ubuf,
+		  size_t cnt, loff_t *ppos)
+{
+	struct trace_iterator *iter = filp->private_data;
+	ssize_t sret;
+
+	/* return any leftover data */
+	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	if (sret != -EBUSY)
+		return sret;
+
+	trace_seq_reset(&iter->seq);
+
+	mutex_lock(&trace_types_lock);
+	if (iter->trace->read) {
+		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
+		if (sret)
+			goto out;
+	}
+
+waitagain:
+	sret = tracing_wait_pipe(filp);
+	if (sret <= 0)
+		goto out;
+
 	/* stop when tracing is finished */
-	if (trace_empty(iter))
+	if (trace_empty(iter)) {
+		sret = 0;
 		goto out;
+	}
 
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
-- 
1.5.6.5

-- 
