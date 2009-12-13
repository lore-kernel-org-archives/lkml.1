Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZLMNKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZLMNKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZLMNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53483 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753062AbZLMNIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LKGy3wDVyrgqLf5q8QHjeNkqyqJeT5sJowrxF89S5XKf52rT7/lJtgEeoWbXZNcOjB
         YS/4ffaf04DC1knB6EHHW3frsnZWCXg2uD5PmbgnXbtNcFnmWHb0991k826PnjumNRg6
         L0F4Z+3tY4WjQpXRO6jgb+S1oRxCCCF5cmDUw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/13] tracing: Use seq file for trace_options
Date: Sun, 13 Dec 2009 14:08:08 +0100
Message-Id: <1260709694-5166-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
 
-- 
1.6.2.3

