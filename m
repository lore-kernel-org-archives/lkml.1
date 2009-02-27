Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZB0Fg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZB0Fg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZB0Fet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053442.805973933@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] tracing: use pointer error returns for __tracing_open
Content-Disposition: inline; filename=0004-tracing-use-pointer-error-returns-for-__tracing_ope.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix compile warning and clean up

When I first wrote __tracing_open, instead of passing the error
code via the ERR_PTR macros, I lazily used a separate parameter
to hold the return for errors.

When Frederic Weisbecker updated that function, he used the Linux
kernel ERR_PTR for the returns. This caused the parameter return
to possibly not be initialized on error. gcc correctly pointed this
out with a warning.

This patch converts the entire function to use the Linux kernel
ERR_PTR macro methods.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   46 ++++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6c89ec6..304e02c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1684,23 +1684,20 @@ static struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct inode *inode, struct file *file, int *ret)
+__tracing_open(struct inode *inode, struct file *file)
 {
 	long cpu_file = (long) inode->i_private;
+	void *fail_ret = ERR_PTR(-ENOMEM);
 	struct trace_iterator *iter;
 	struct seq_file *m;
-	int cpu;
+	int cpu, ret;
 
-	if (tracing_disabled) {
-		*ret = -ENODEV;
-		return NULL;
-	}
+	if (tracing_disabled)
+		return ERR_PTR(-ENODEV);
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter) {
-		*ret = -ENOMEM;
-		goto out;
-	}
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
@@ -1708,10 +1705,9 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	 */
 	mutex_lock(&trace_types_lock);
 	iter->trace = kzalloc(sizeof(*iter->trace), GFP_KERNEL);
-	if (!iter->trace) {
-		*ret = -ENOMEM;
+	if (!iter->trace)
 		goto fail;
-	}
+
 	if (current_trace)
 		*iter->trace = *current_trace;
 
@@ -1750,9 +1746,11 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	}
 
 	/* TODO stop tracer */
-	*ret = seq_open(file, &tracer_seq_ops);
-	if (*ret)
+	ret = seq_open(file, &tracer_seq_ops);
+	if (ret < 0) {
+		fail_ret = ERR_PTR(ret);
 		goto fail_buffer;
+	}
 
 	m = file->private_data;
 	m->private = iter;
@@ -1762,7 +1760,6 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 
 	mutex_unlock(&trace_types_lock);
 
- out:
 	return iter;
 
  fail_buffer:
@@ -1775,7 +1772,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	kfree(iter->trace);
 	kfree(iter);
 
-	return ERR_PTR(-ENOMEM);
+	return fail_ret;
 }
 
 int tracing_open_generic(struct inode *inode, struct file *filp)
@@ -1815,9 +1812,12 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 static int tracing_open(struct inode *inode, struct file *file)
 {
-	int ret;
+	struct trace_iterator *iter;
+	int ret = 0;
 
-	__tracing_open(inode, file, &ret);
+	iter = __tracing_open(inode, file);
+	if (IS_ERR(iter))
+		ret = PTR_ERR(iter);
 
 	return ret;
 }
@@ -1825,11 +1825,13 @@ static int tracing_open(struct inode *inode, struct file *file)
 static int tracing_lt_open(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter;
-	int ret;
+	int ret = 0;
 
-	iter = __tracing_open(inode, file, &ret);
+	iter = __tracing_open(inode, file);
 
-	if (!ret)
+	if (IS_ERR(iter))
+		ret = PTR_ERR(iter);
+	else
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	return ret;
-- 
1.5.6.5

-- 
