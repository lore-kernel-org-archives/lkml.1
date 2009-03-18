Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZCRDd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZCRDd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZCRDcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCRDcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:51 -0400
Message-Id: <20090318033249.216553481@goodmis.org>
References: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] tracing: add global-clock option to provide cross CPU clock to traces
Content-Disposition: inline; filename=0002-tracing-add-global-clock-option-to-provide-cross-CP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: feature to allow better serialized clock

This patch adds an option called "global-clock" that will allow
the tracer to switch to a slower but more accurate (across CPUs)
clock.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   34 ++++++++++++++++++++++++++++++----
 kernel/trace/trace.h |    1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3be2f78..2f994ca 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -315,6 +315,7 @@ static const char *trace_options[] = {
 	"printk-msg-only",
 	"context-info",
 	"latency-format",
+	"global-clock",
 	NULL
 };
 
@@ -2251,6 +2252,34 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 	return 0;
 }
 
+static void set_tracer_flags(unsigned int mask, int enabled)
+{
+	/* do nothing if flag is already set */
+	if (!!(trace_flags & mask) == !!enabled)
+		return;
+
+	if (enabled)
+		trace_flags |= mask;
+	else
+		trace_flags &= ~mask;
+
+	if (mask == TRACE_ITER_GLOBAL_CLK) {
+		u64 (*func)(void);
+
+		if (enabled)
+			func = trace_clock_global;
+		else
+			func = trace_clock_local;
+
+		mutex_lock(&trace_types_lock);
+		ring_buffer_set_clock(global_trace.buffer, func);
+
+		if (max_tr.buffer)
+			ring_buffer_set_clock(max_tr.buffer, func);
+		mutex_unlock(&trace_types_lock);
+	}
+}
+
 static ssize_t
 tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
@@ -2278,10 +2307,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		int len = strlen(trace_options[i]);
 
 		if (strncmp(cmp, trace_options[i], len) == 0) {
-			if (neg)
-				trace_flags &= ~(1 << i);
-			else
-				trace_flags |= (1 << i);
+			set_tracer_flags(1 << i, !neg);
 			break;
 		}
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b0ecad8..26a7a28 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -667,6 +667,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
 	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
+	TRACE_ITER_GLOBAL_CLK		= 0x80000,
 };
 
 /*
-- 
1.6.2

-- 
