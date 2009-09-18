Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZIRGHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZIRGHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZIRGHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:07:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65370 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZIRGHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:07:39 -0400
Message-ID: <4AB32364.7020602@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 14:06:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3][RESEND] function-graph: use ftrace_graph_funcs directly
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to store ftrace_graph_funcs in file->private.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

The first 2 patches were sent 2 month ago..

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
1.6.3

