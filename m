Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZCMCmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZCMCmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbZCMCih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539AbZCMCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:29 -0400
Message-Id: <20090313023826.503765882@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/16] tracing: have event_trace_printk use static tracer
Content-Disposition: inline; filename=0008-tracing-have-event_trace_printk-use-static-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: speed up on event tracing

The event_trace_printk is currently a wrapper function that calls
trace_vprintk. Because it uses a variable for the fmt it misses out
on the optimization of using the binary printk.

This patch makes event_trace_printk into a macro wrapper to use the
fmt as the same as the trace_printks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h        |   17 +++++++++++++++++
 kernel/trace/trace_events.c |   10 ----------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cede1ab..35cfa7b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -773,4 +773,21 @@ void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
+extern const char *__start___trace_bprintk_fmt[];
+extern const char *__stop___trace_bprintk_fmt[];
+
+#define event_trace_printk(ip, fmt, args...)				\
+do {									\
+	__trace_printk_check_format(fmt, ##args);			\
+	tracing_record_cmdline(current);				\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
+	} else								\
+		__trace_printk(ip, fmt, ##args);			\
+} while (0)
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ca624df..238ea95 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -24,16 +24,6 @@ static DEFINE_MUTEX(event_mutex);
 	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
 	     event++)
 
-void event_trace_printk(unsigned long ip, const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	tracing_record_cmdline(current);
-	trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
-	va_end(ap);
-}
-
 static void ftrace_clear_events(void)
 {
 	struct ftrace_event_call *call = (void *)__start_ftrace_events;
-- 
1.6.1.3

-- 
