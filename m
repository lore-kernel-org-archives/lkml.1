Return-Path: <linux-kernel-owner+w=401wt.eu-S934754AbZLHDQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbZLHDQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934700AbZLHDQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:16:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934741AbZLHDQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:16:18 -0500
Message-ID: <4B1DC4EF.3090106@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 11:15:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/13] tracing: Use seq file for trace_options
References: <4B1DC476.3030700@cn.fujitsu.com>
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code simplification for reading trace_options.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |   60 ++++++++++++++-----------------------------------
 1 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 874f289..e989fc9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2291,67 +2291,32 @@ static const struct file_operations tracing_cpumask_fops = {
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
@@ -2446,9 +2411,18 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
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
 
-- 
1.6.3

