Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZKPT7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZKPT7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZKPT7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:59:07 -0500
Received: from toro.web-alm.net ([62.245.132.31]:47894 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZKPT7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:59:06 -0500
Message-ID: <4B01AE5D.1010801@osadl.org>
Date: Mon, 16 Nov 2009 20:56:13 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] ftrace: fix trace_marker output
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a string was written to <debugfs>/tracing/trace_marker, some
strange characters appeared in the trace output instead of the
string, since a vprint function erroneously called a vararg print
function with a va_list argument. This patch fixes the problem and
simplifies the related code.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: linux-2.6.31.6-rt19/kernel/trace/trace.c
===================================================================
--- linux-2.6.31.6-rt19.orig/kernel/trace/trace.c
+++ linux-2.6.31.6-rt19/kernel/trace/trace.c
@@ -1376,10 +1376,11 @@ int trace_array_vprintk(struct trace_arr
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&trace_buf_lock);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
-
-	len = min(len, TRACE_BUF_SIZE-1);
-	trace_buf[len] = 0;
+	if (args == NULL) {
+		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
+		len = strlen(trace_buf);
+	} else
+		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
@@ -1388,10 +1389,10 @@ int trace_array_vprintk(struct trace_arr
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
-	entry->ip			= ip;
+	entry->ip = ip;
 
 	memcpy(&entry->buf, trace_buf, len);
-	entry->buf[len] = 0;
+	entry->buf[len] = '\0';
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 
@@ -1408,7 +1409,7 @@ int trace_array_vprintk(struct trace_arr
 
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	return trace_array_printk(&global_trace, ip, fmt, args);
+	return trace_array_vprintk(&global_trace, ip, fmt, args);
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
@@ -3336,22 +3337,11 @@ tracing_entries_write(struct file *filp,
 	return cnt;
 }
 
-static int mark_printk(const char *fmt, ...)
-{
-	int ret;
-	va_list args;
-	va_start(args, fmt);
-	ret = trace_vprintk(0, fmt, args);
-	va_end(args);
-	return ret;
-}
-
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	char *buf;
-	char *end;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3359,7 +3349,7 @@ tracing_mark_write(struct file *filp, co
 	if (cnt > TRACE_BUF_SIZE)
 		cnt = TRACE_BUF_SIZE;
 
-	buf = kmalloc(cnt + 1, GFP_KERNEL);
+	buf = kmalloc(cnt + 2, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
@@ -3367,14 +3357,13 @@ tracing_mark_write(struct file *filp, co
 		kfree(buf);
 		return -EFAULT;
 	}
+	if (buf[cnt-1] != '\n') {
+		buf[cnt] = '\n';
+		buf[cnt+1] = '\0';
+	} else
+		buf[cnt] = '\0';
 
-	/* Cut from the first nil or newline. */
-	buf[cnt] = '\0';
-	end = strchr(buf, '\n');
-	if (end)
-		*end = '\0';
-
-	cnt = mark_printk("%s\n", buf);
+	cnt = trace_vprintk(0, buf, NULL);
 	kfree(buf);
 	*fpos += cnt;
 
