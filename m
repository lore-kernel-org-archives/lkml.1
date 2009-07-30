Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZG3Tzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZG3Tzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZG3Tzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:55:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:32887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZG3Tzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:55:41 -0400
Date: Thu, 30 Jul 2009 19:55:13 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A67D907.2010500@cn.fujitsu.com>
References: <4A67D907.2010500@cn.fujitsu.com>
Subject: [tip:tracing/urgent] function-graph: Fix seqfile memory leak
Message-ID: <tip-87827111a5538633b18e5c641ced673c4c2bb6ce@git.kernel.org>
Git-Commit-ID: 87827111a5538633b18e5c641ced673c4c2bb6ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Jul 2009 19:55:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87827111a5538633b18e5c641ced673c4c2bb6ce
Gitweb:     http://git.kernel.org/tip/87827111a5538633b18e5c641ced673c4c2bb6ce
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 23 Jul 2009 11:29:11 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 09:53:23 -0400

function-graph: Fix seqfile memory leak

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
 
