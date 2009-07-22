Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZGVIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZGVIk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZGVIkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:40:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZGVIkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:40:23 -0400
Message-ID: <4A66D01E.2000600@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 16:38:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip 2/2] function-graph: use ftrace_graph_funcs directly
References: <4A66D004.7020205@cn.fujitsu.com>
In-Reply-To: <4A66D004.7020205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to store ftrace_graph_funcs in file->private.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c6c0c07..7179bff 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2463,11 +2463,9 @@ unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
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
@@ -2531,16 +2529,10 @@ ftrace_graph_open(struct inode *inode, struct file *file)
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
@@ -2601,7 +2593,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	unsigned char buffer[FTRACE_BUFF_MAX+1];
-	unsigned long *array;
+	unsigned long *array = ftrace_graph_funcs;
 	size_t read = 0;
 	ssize_t ret;
 	int index = 0;
@@ -2617,12 +2609,6 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	if (file->f_mode & FMODE_READ) {
-		struct seq_file *m = file->private_data;
-		array = m->private;
-	} else
-		array = file->private_data;
-
 	ret = get_user(ch, ubuf++);
 	if (ret)
 		goto out;
-- 
1.6.3

