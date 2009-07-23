Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZGWDao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZGWDao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZGWDao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:30:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZGWDan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:30:43 -0400
Message-ID: <4A67D907.2010500@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 11:29:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] function-graph: Fix seqfile memory leak
References: <4A67D8CB.4040909@cn.fujitsu.com>
In-Reply-To: <4A67D8CB.4040909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we cat set_graph_function, we leak memory allocated
by seq_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7179bff..fd5cdeb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2538,6 +2538,14 @@ ftrace_graph_open(struct inode *inode, struct file *file)
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
@@ -2660,9 +2668,10 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
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
1.6.3

