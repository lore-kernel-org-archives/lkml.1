Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZISPxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZISPxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZISPwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:52:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZISPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:52:44 -0400
Message-Id: <20090919155247.536054302@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 19 Sep 2009 11:52:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3] [PATCH 1/3] function-graph: use ftrace_graph_funcs directly
References: <20090919155203.005861436@goodmis.org>
Content-Disposition: inline; filename=0001-function-graph-use-ftrace_graph_funcs-directly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

No need to store ftrace_graph_funcs in file->private.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AB32364.7020602@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cc615f8..c71e91b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2414,11 +2414,9 @@ unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 static void *
 __g_next(struct seq_file *m, loff_t *pos)
 {
-	unsigned long *array = m->private;
-
 	if (*pos >= ftrace_graph_count)
 		return NULL;
-	return &array[*pos];
+	return &ftrace_graph_funcs[*pos];
 }
 
 static void *
@@ -2482,16 +2480,10 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
+	mutex_unlock(&graph_lock);
 
-	if (file->f_mode & FMODE_READ) {
+	if (file->f_mode & FMODE_READ)
 		ret = seq_open(file, &ftrace_graph_seq_ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = ftrace_graph_funcs;
-		}
-	} else
-		file->private_data = ftrace_graph_funcs;
-	mutex_unlock(&graph_lock);
 
 	return ret;
 }
@@ -2560,7 +2552,6 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	unsigned long *array;
 	size_t read = 0;
 	ssize_t ret;
 
@@ -2574,12 +2565,6 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	if (file->f_mode & FMODE_READ) {
-		struct seq_file *m = file->private_data;
-		array = m->private;
-	} else
-		array = file->private_data;
-
 	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
 		ret = -ENOMEM;
 		goto out;
@@ -2591,7 +2576,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		parser.buffer[parser.idx] = 0;
 
 		/* we allow only one expression at a time */
-		ret = ftrace_set_func(array, &ftrace_graph_count,
+		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
 					parser.buffer);
 		if (ret)
 			goto out;
-- 
1.6.3.3


