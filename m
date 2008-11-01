Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYKANGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYKANGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 09:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYKANFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 09:05:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYKANFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 09:05:54 -0400
Subject: [PATCH] ftrace: ftrace_dump_on_oops=[tracer]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 14:05:44 +0100
Message-Id: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems useful to debug crashes that happen before I read userspace.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d2c115b..74c27ee 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -765,6 +765,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	ftrace_dump_on_oops=[tracer]
+			[ftrace] will dump the trace buffers on oops and
+			optionally set and start the specified tracer.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b8c90d..41845ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -79,9 +79,12 @@ static int tracing_disabled = 1;
  */
 int ftrace_dump_on_oops;
 
+static int tracing_set_tracer(char *buf);
+
 static int __init set_ftrace_dump_on_oops(char *str)
 {
 	ftrace_dump_on_oops = 1;
+	tracing_set_tracer(str);
 	return 1;
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
@@ -2394,29 +2397,11 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
-static ssize_t
-tracing_set_trace_write(struct file *filp, const char __user *ubuf,
-			size_t cnt, loff_t *ppos)
+static int tracing_set_tracer(char *buf)
 {
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
-	char buf[max_tracer_type_len+1];
-	int i;
-	size_t ret;
-
-	ret = cnt;
-
-	if (cnt > max_tracer_type_len)
-		cnt = max_tracer_type_len;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	/* strip ending whitespace. */
-	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
-		buf[i] = 0;
+	int ret = 0;
 
 	mutex_lock(&trace_types_lock);
 	for (t = trace_types; t; t = t->next) {
@@ -2440,6 +2425,33 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&trace_types_lock);
 
+	return ret;
+}
+
+static ssize_t
+tracing_set_trace_write(struct file *filp, const char __user *ubuf,
+			size_t cnt, loff_t *ppos)
+{
+	char buf[max_tracer_type_len+1];
+	int i;
+	size_t ret;
+
+	if (cnt > max_tracer_type_len)
+		cnt = max_tracer_type_len;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	/* strip ending whitespace. */
+	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
+		buf[i] = 0;
+
+	ret = tracing_set_tracer(buf);
+	if (!ret)
+		ret = cnt;
+
 	if (ret > 0)
 		filp->f_pos += ret;
 


