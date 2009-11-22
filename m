Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715AbZKVKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbZKVKZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZKVKZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:25:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:47408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbZKVKZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:25:19 -0500
Date: Sun, 22 Nov 2009 10:24:48 GMT
From: tip-bot for Carsten Emde <Carsten.Emde@osadl.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, Carsten.Emde@osadl.org, tglx@linutronix.de,
       C.Emde@osadl.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Carsten.Emde@osadl.org, tglx@linutronix.de,
       C.Emde@osadl.org
In-Reply-To: <4B01AE5D.1010801@osadl.org>
References: <4B01AE5D.1010801@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix trace_marker output
Message-ID: <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
Git-Commit-ID: c13d2f7c3231e873f30db92b96c8caa48f100f33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c13d2f7c3231e873f30db92b96c8caa48f100f33
Gitweb:     http://git.kernel.org/tip/c13d2f7c3231e873f30db92b96c8caa48f100f33
Author:     Carsten Emde <Carsten.Emde@osadl.org>
AuthorDate: Mon, 16 Nov 2009 20:56:13 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 17 Nov 2009 09:19:06 -0500

tracing: Fix trace_marker output

When a string was written to <debugfs>/tracing/trace_marker, some
strange characters appeared in the trace output instead of the
string, since a vprint function erroneously called a vararg print
function with a va_list argument. This patch fixes the problem and
simplifies the related code.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
LKML-Reference: <4B01AE5D.1010801@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   39 ++++++++++++++-------------------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 03c7fd5..12b49ca 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1361,10 +1361,11 @@ int trace_array_vprintk(struct trace_array *tr,
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
@@ -1373,10 +1374,10 @@ int trace_array_vprintk(struct trace_array *tr,
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
 
@@ -3319,22 +3320,11 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
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
@@ -3342,7 +3332,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (cnt > TRACE_BUF_SIZE)
 		cnt = TRACE_BUF_SIZE;
 
-	buf = kmalloc(cnt + 1, GFP_KERNEL);
+	buf = kmalloc(cnt + 2, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
@@ -3350,14 +3340,13 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
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
 
