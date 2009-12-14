Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZLNJrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZLNJrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZLNJrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:47:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:48254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbZLNJrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:47:47 -0500
Date: Mon, 14 Dec 2009 09:47:17 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC4FB.5030407@cn.fujitsu.com>
References: <4B1DC4FB.5030407@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Use seq file for trace_clock
Message-ID: <tip-13f16d209161c95e92aef40e350cc6cf56ac440b@git.kernel.org>
Git-Commit-ID: 13f16d209161c95e92aef40e350cc6cf56ac440b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13f16d209161c95e92aef40e350cc6cf56ac440b
Gitweb:     http://git.kernel.org/tip/13f16d209161c95e92aef40e350cc6cf56ac440b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:16:11 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:27 +0100

tracing: Use seq file for trace_clock

The buffer for the output is as small as 64 bytes, so it'll
overflow if we add more clock type. Use seq file instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC4FB.5030407@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a6c41cc..886268e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3366,21 +3366,18 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
-				  size_t cnt, loff_t *ppos)
+static int tracing_clock_show(struct seq_file *m, void *v)
 {
-	char buf[64];
-	int bufiter = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
-		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
+		seq_printf(m,
 			"%s%s%s%s", i ? " " : "",
 			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
 			i == trace_clock_id ? "]" : "");
-	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
+	seq_putc(m, '\n');
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
+	return 0;
 }
 
 static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
@@ -3422,6 +3419,13 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_clock_open(struct inode *inode, struct file *file)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+	return single_open(file, tracing_clock_show, NULL);
+}
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -3460,8 +3464,10 @@ static const struct file_operations tracing_mark_fops = {
 };
 
 static const struct file_operations trace_clock_fops = {
-	.open		= tracing_open_generic,
-	.read		= tracing_clock_read,
+	.open		= tracing_clock_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= tracing_clock_write,
 };
 
