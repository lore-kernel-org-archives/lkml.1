Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZLNJrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZLNJrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZLNJri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:47:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:48241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbZLNJrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:47:35 -0500
Date: Mon, 14 Dec 2009 09:47:03 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC4EF.3090106@cn.fujitsu.com>
References: <4B1DC4EF.3090106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Use seq file for trace_options
Message-ID: <tip-fdb372ed4cadbfe9dbba0e932a77d0523682e690@git.kernel.org>
Git-Commit-ID: fdb372ed4cadbfe9dbba0e932a77d0523682e690
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdb372ed4cadbfe9dbba0e932a77d0523682e690
Gitweb:     http://git.kernel.org/tip/fdb372ed4cadbfe9dbba0e932a77d0523682e690
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:15:59 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:27 +0100

tracing: Use seq file for trace_options

Code simplification for reading trace_options.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-reference: <4B1DC4EF.3090106@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   60 ++++++++++++++-----------------------------------
 1 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88bd9ae..a6c41cc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2316,67 +2316,32 @@ static const struct file_operations tracing_cpumask_fops = {
 	.write		= tracing_cpumask_write,
 };
 
-static ssize_t
-tracing_trace_options_read(struct file *filp, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
+static int tracing_trace_options_show(struct seq_file *m, void *v)
 {
 	struct tracer_opt *trace_opts;
 	u32 tracer_flags;
-	int len = 0;
-	char *buf;
-	int r = 0;
 	int i;
 
-
-	/* calculate max size */
-	for (i = 0; trace_options[i]; i++) {
-		len += strlen(trace_options[i]);
-		len += 3; /* "no" and newline */
-	}
-
 	mutex_lock(&trace_types_lock);
 	tracer_flags = current_trace->flags->val;
 	trace_opts = current_trace->flags->opts;
 
-	/*
-	 * Increase the size with names of options specific
-	 * of the current tracer.
-	 */
-	for (i = 0; trace_opts[i].name; i++) {
-		len += strlen(trace_opts[i].name);
-		len += 3; /* "no" and newline */
-	}
-
-	/* +1 for \0 */
-	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (!buf) {
-		mutex_unlock(&trace_types_lock);
-		return -ENOMEM;
-	}
-
 	for (i = 0; trace_options[i]; i++) {
 		if (trace_flags & (1 << i))
-			r += sprintf(buf + r, "%s\n", trace_options[i]);
+			seq_printf(m, "%s\n", trace_options[i]);
 		else
-			r += sprintf(buf + r, "no%s\n", trace_options[i]);
+			seq_printf(m, "no%s\n", trace_options[i]);
 	}
 
 	for (i = 0; trace_opts[i].name; i++) {
 		if (tracer_flags & trace_opts[i].bit)
-			r += sprintf(buf + r, "%s\n",
-				trace_opts[i].name);
+			seq_printf(m, "%s\n", trace_opts[i].name);
 		else
-			r += sprintf(buf + r, "no%s\n",
-				trace_opts[i].name);
+			seq_printf(m, "no%s\n", trace_opts[i].name);
 	}
 	mutex_unlock(&trace_types_lock);
 
-	WARN_ON(r >= len + 1);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-
-	kfree(buf);
-	return r;
+	return 0;
 }
 
 /* Try to assign a tracer specific option */
@@ -2471,9 +2436,18 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_trace_options_open(struct inode *inode, struct file *file)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+	return single_open(file, tracing_trace_options_show, NULL);
+}
+
 static const struct file_operations tracing_iter_fops = {
-	.open		= tracing_open_generic,
-	.read		= tracing_trace_options_read,
+	.open		= tracing_trace_options_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= tracing_trace_options_write,
 };
 
