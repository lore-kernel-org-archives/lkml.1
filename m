Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYIPS6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYIPS6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYIPS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:58:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:50279 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYIPS63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=u2dZSi2p+3vPVZ2k1Yf9leEl3dCXmwvKguCXA2OzqFcmA3xzylIuk6HdH2duO2IaUw
         pTWi2Zfh0u8zp2T2hiHyhmPdxpmFxsVRyGTe7E3X4xRASYbZhw5GPRBH56iINHq3O8xU
         uItIMr7By03MfMuhNxFMq+6NBXLwVi8xVAX2U=
Date: Tue, 16 Sep 2008 21:58:24 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/7] ftrace: add trace_vprintk()
Message-ID: <20080916215824.7b0b69e5@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5579d3e6471201524697d1cc32fb37f1a4f70f95 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 14 Sep 2008 17:27:05 +0300
Subject: [PATCH] ftrace: add trace_vprintk()

trace_vprintk() for easier implementation of tracer specific *_printk
functions. Add check check for no_tracer, and implement
__ftrace_printk() as a wrapper.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace.c |   24 ++++++++++++++++++------
 kernel/trace/trace.h |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d372bc5..406de9c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3054,7 +3054,7 @@ static __init void tracer_init_debugfs(void)
 	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
 #define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
 
-int __ftrace_printk(unsigned long ip, const char *fmt, ...)
+int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	static DEFINE_SPINLOCK(trace_buf_lock);
 	static char trace_buf[TRACE_BUF_SIZE];
@@ -3064,10 +3064,9 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 	struct trace_entry *entry;
 	unsigned long flags;
 	long disabled;
-	va_list ap;
 	int cpu, len = 0, write, written = 0;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK) || !tr->ctrl || tracing_disabled)
+	if (current_trace == &no_tracer || !tr->ctrl || tracing_disabled)
 		return 0;
 
 	local_irq_save(flags);
@@ -3079,9 +3078,7 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 		goto out;
 
 	spin_lock(&trace_buf_lock);
-	va_start(ap, fmt);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
-	va_end(ap);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	len = min(len, TRACE_BUF_SIZE-1);
 	trace_buf[len] = 0;
@@ -3120,6 +3117,21 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_vprintk);
+
+int __ftrace_printk(unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_vprintk(ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(__ftrace_printk);
 
 static int trace_panic_handler(struct notifier_block *this,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9d39aa0..be3b3cf 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -333,6 +333,7 @@ extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
+extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
-- 
1.5.6.4

