Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZISSEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZISSEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZISSEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:04:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZISSEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:04:05 -0400
Date: Sat, 19 Sep 2009 18:03:37 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4AB32364.7020602@cn.fujitsu.com>
References: <4AB32364.7020602@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] function-graph: use ftrace_graph_funcs directly
Message-ID: <tip-a4ec5e0c2681b8cf99ddabf118705847f7460f19@git.kernel.org>
Git-Commit-ID: a4ec5e0c2681b8cf99ddabf118705847f7460f19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 18:03:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4ec5e0c2681b8cf99ddabf118705847f7460f19
Gitweb:     http://git.kernel.org/tip/a4ec5e0c2681b8cf99ddabf118705847f7460f19
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 18 Sep 2009 14:06:28 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 19 Sep 2009 11:26:54 -0400

function-graph: use ftrace_graph_funcs directly

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
