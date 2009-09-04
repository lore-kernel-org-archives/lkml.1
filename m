Return-Path: <linux-kernel-owner+w=401wt.eu-S934375AbZIEABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbZIEABd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZIEABa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193AbZIEABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:25 -0400
Message-Id: <20090905000126.612983151@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/18] tracing: add trace_array_printk for internal tracers to use
Content-Disposition: inline; filename=0015-tracing-add-trace_array_printk-for-internal-tracers-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a trace_array_printk to allow a tracer to use the
trace_printk on its own trace array.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   24 ++++++++++++++++++++++--
 kernel/trace/trace.h |    5 +++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0c61836..ef08328 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1201,7 +1201,23 @@ out:
 }
 EXPORT_SYMBOL_GPL(trace_vbprintk);
 
-int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
+int trace_array_printk(struct trace_array *tr,
+		       unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_array_vprintk(tr, ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
+int trace_array_vprintk(struct trace_array *tr,
+			unsigned long ip, const char *fmt, va_list args)
 {
 	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
@@ -1209,7 +1225,6 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	int cpu, len = 0, size, pc;
 	struct print_entry *entry;
@@ -1260,6 +1275,11 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	return len;
 }
+
+int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
+{
+	return trace_array_printk(&global_trace, ip, fmt, args);
+}
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
 enum trace_file_type {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4d30414..fa1dccb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -566,6 +566,11 @@ extern int
 trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
 trace_vprintk(unsigned long ip, const char *fmt, va_list args);
+extern int
+trace_array_vprintk(struct trace_array *tr,
+		    unsigned long ip, const char *fmt, va_list args);
+int trace_array_printk(struct trace_array *tr,
+		       unsigned long ip, const char *fmt, ...);
 
 extern unsigned long trace_flags;
 
-- 
1.6.3.3

-- 
