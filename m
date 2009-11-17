Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZKQPUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZKQPUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZKQPUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:20:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZKQPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:20:17 -0500
Subject: [PATCH][GIT PULL][v2.6.32] tracing: Fix trace_marker output
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B01AE5D.1010801@osadl.org>
References: <4B01AE5D.1010801@osadl.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 17 Nov 2009 10:20:22 -0500
Message-Id: <1258471222.22249.463.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Think we may be able to slip this into 32?

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Carsten Emde (1):
      tracing: Fix trace_marker output

----
 kernel/trace/trace.c |   39 ++++++++++++++-------------------------
 1 files changed, 14 insertions(+), 25 deletions(-)
---------------------------
commit c13d2f7c3231e873f30db92b96c8caa48f100f33
Author: Carsten Emde <Carsten.Emde@osadl.org>
Date:   Mon Nov 16 20:56:13 2009 +0100

    tracing: Fix trace_marker output
    
    When a string was written to <debugfs>/tracing/trace_marker, some
    strange characters appeared in the trace output instead of the
    string, since a vprint function erroneously called a vararg print
    function with a va_list argument. This patch fixes the problem and
    simplifies the related code.
    
    Signed-off-by: Carsten Emde <C.Emde@osadl.org>
    LKML-Reference: <4B01AE5D.1010801@osadl.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
 


