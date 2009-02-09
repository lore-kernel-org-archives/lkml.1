Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZBIGP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZBIGP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZBIGPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:15:37 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48643 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZBIGPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AZhC3oS9PbFkH36IQmyouj2GYo4j57BlJpuYwcfUIrtV8dS0RqKsPyWAfp7ldvOBYc
         GgM0+WYDheSw1rPufFNrZiV/dpBw30JJpr2AoDWsfG/wI7K2SoAQKpxT/uy52ZIkXd0S
         EQby+9EEemCV0GR/NCJElvfgqZmL57eQaalo4=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, penberg@cs.helsinki.fi, rostedt@goodmis.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] trace: Move pipe waiting code out of tracing_read_pipe().
Date: Mon,  9 Feb 2009 08:15:55 +0200
Message-Id: <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234159200.git.eduard.munteanu@linux360.ro>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1234159200.git.eduard.munteanu@linux360.ro>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the pipe waiting code from tracing_read_pipe() into
tracing_wait_pipe(), which is useful to implement other fops, like
splice_read.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/trace.c |   69 +++++++++++++++++++++++++++++---------------------
 1 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef4dbac..130c4f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2359,37 +2359,15 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
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
@@ -2414,12 +2392,11 @@ waitagain:
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
@@ -2436,9 +2413,43 @@ waitagain:
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
1.6.0.6

