Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZLIUwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZLIUwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZLIUwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:52:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbZLIUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:51:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=cn5aVtnoCi0A:10 a=D_SbEOMbAAAA:8 a=6zb38KopAAAA:8 a=meVymXHHAAAA:8 a=fmuKi8Ueh1xfsIMSKxsA:9 a=spRWfdANp4JQBh4XwQoA:7 a=FcpkzUIqyz1mDvxx_zGoUVgTc-AA:4 a=7KbvKZvEaC0A:10 a=D-PNlr3aaKoA:10 a=jeBq3FmKZ4MA:10 a=ANmMLi0tbL9kWTvV:21 a=sHwjeTmzdR6fogko:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091209205113.837905785@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Dec 2009 15:40:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 5/5] [PATCH 5/5] tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
References: <20091209204035.871524827@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Remove-comparing-of-NULL-to-va_list-in-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <Carsten.Emde@osadl.org>

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
 
-- 
1.6.5


