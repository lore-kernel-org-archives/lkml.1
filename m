Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZGWOFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZGWOFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZGWOFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:05:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZGWOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:05:16 -0400
Message-Id: <20090723140514.389283861@goodmis.org>
References: <20090723140259.100790900@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 10:03:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] function-graph: Fix seqfile memory leak
Content-Disposition: inline; filename=0002-function-graph-Fix-seqfile-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Every time we cat set_graph_function, we leak memory allocated
by seq_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A67D907.2010500@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..1f3ec2a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2596,6 +2596,14 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 }
 
 static int
+ftrace_graph_release(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
+	return 0;
+}
+
+static int
 ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 {
 	struct dyn_ftrace *rec;
@@ -2724,9 +2732,10 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 }
 
 static const struct file_operations ftrace_graph_fops = {
-	.open = ftrace_graph_open,
-	.read = seq_read,
-	.write = ftrace_graph_write,
+	.open		= ftrace_graph_open,
+	.read		= seq_read,
+	.write		= ftrace_graph_write,
+	.release	= ftrace_graph_release,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-- 
1.6.3.3

-- 
