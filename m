Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZCED2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZCED2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZCED1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZCED1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:15 -0500
Message-Id: <20090305032713.255418626@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: add latency output format option
Content-Disposition: inline; filename=0004-tracing-add-latency-output-format-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the removal of the latency_trace file, we lost the ability
to see some of the finer details in a trace. Like the state of
interrupts enabled, the preempt count, need resched, and if we
are in an interrupt handler, softirq handler or not.

This patch simply creates an option to bring back the old format.
This also removes the warning about an unused variable that held
the latency_trace file operations.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   24 ++----------------------
 kernel/trace/trace.h |    3 ++-
 2 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2e53e6f..55fcbb5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -299,6 +299,7 @@ static const char *trace_options[] = {
 	"sym-userobj",
 	"printk-msg-only",
 	"context-info",
+	"latency-format",
 	NULL
 };
 
@@ -1829,26 +1830,12 @@ static int tracing_open(struct inode *inode, struct file *file)
 	iter = __tracing_open(inode, file);
 	if (IS_ERR(iter))
 		ret = PTR_ERR(iter);
-
-	return ret;
-}
-
-static int tracing_lt_open(struct inode *inode, struct file *file)
-{
-	struct trace_iterator *iter;
-	int ret = 0;
-
-	iter = __tracing_open(inode, file);
-
-	if (IS_ERR(iter))
-		ret = PTR_ERR(iter);
-	else
+	else if (trace_flags & TRACE_ITER_LATENCY_FMT)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	return ret;
 }
 
-
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
@@ -1927,13 +1914,6 @@ static struct file_operations tracing_fops = {
 	.release	= tracing_release,
 };
 
-static struct file_operations tracing_lt_fops = {
-	.open		= tracing_lt_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= tracing_release,
-};
-
 static struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 561bb5c..12cd119 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -651,7 +651,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_USERSTACKTRACE       = 0x4000,
 	TRACE_ITER_SYM_USEROBJ          = 0x8000,
 	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
-	TRACE_ITER_CONTEXT_INFO		= 0x20000 /* Print pid/cpu/time */
+	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
+	TRACE_ITER_LATENCY_FMT		= 0x40000,
 };
 
 /*
-- 
1.6.1.3

-- 
