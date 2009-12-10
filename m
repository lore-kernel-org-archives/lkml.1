Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZLJHuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZLJHuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760707AbZLJHuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:50:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:46505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbZLJHuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:50:15 -0500
Date: Thu, 10 Dec 2009 07:49:45 GMT
From: tip-bot for Carsten Emde <Carsten.Emde@osadl.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       olof@lixom.net, rostedt@goodmis.org, Carsten.Emde@osadl.org,
       tglx@linutronix.de, C.Emde@osadl.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       olof@lixom.net, rostedt@goodmis.org, Carsten.Emde@osadl.org,
       tglx@linutronix.de, C.Emde@osadl.org
In-Reply-To: <4B1BAB74.104@osadl.org>
References: <4B1BAB74.104@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
Message-ID: <tip-f2942487ffb0c0a80b2312f667ea30dd55a24bb0@git.kernel.org>
Git-Commit-ID: f2942487ffb0c0a80b2312f667ea30dd55a24bb0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2942487ffb0c0a80b2312f667ea30dd55a24bb0
Gitweb:     http://git.kernel.org/tip/f2942487ffb0c0a80b2312f667ea30dd55a24bb0
Author:     Carsten Emde <Carsten.Emde@osadl.org>
AuthorDate: Sun, 6 Dec 2009 14:02:44 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Dec 2009 14:20:08 -0500

tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

Olof Johansson stated the following:

  Comparing a va_list with NULL is bogus. It's supposed to be treated like
  an opaque type and only be manipulated with va_* accessors.

Olof noticed that this code broke the ARM builds:

    kernel/trace/trace.c: In function 'trace_array_vprintk':
    kernel/trace/trace.c:1364: error: invalid operands to binary == (have 'va_list' and 'void *')
    kernel/trace/trace.c: In function 'tracing_mark_write':
    kernel/trace/trace.c:3349: error: incompatible type for argument 3 of 'trace_vprintk'

This patch partly reverts c13d2f7c3231e873f30db92b96c8caa48f100f33 and
re-installs the original mark_printk() mechanism.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
LKML-Reference: <4B1BAB74.104@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 484114d..88bd9ae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1361,11 +1361,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&trace_buf_lock);
-	if (args == NULL) {
-		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
-		len = strlen(trace_buf);
-	} else
-		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
@@ -3353,6 +3349,16 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int mark_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
@@ -3379,7 +3385,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = trace_vprintk(0, buf, NULL);
+	cnt = mark_printk("%s", buf);
 	kfree(buf);
 	*fpos += cnt;
 
