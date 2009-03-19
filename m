Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZCSUDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZCSUDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZCSUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200200.979823880@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/7] tracing: remove recording function depth from trace_printk
Content-Disposition: inline; filename=0006-tracing-remove-recording-function-depth-from-trace_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function depth in trace_printk was to facilitate the function
graph output. Now that the function graph calculates the depth within
the trace output, we no longer need to record the depth when the
trace_printk is called.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c             |    8 +++-----
 kernel/trace/trace.h             |    6 ++----
 kernel/trace/trace_event_types.h |    2 --
 kernel/trace/trace_mmiotrace.c   |    2 +-
 kernel/trace/trace_printk.c      |    8 ++++----
 5 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c637cb6..f7f359d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1194,7 +1194,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
  * trace_vbprintk - write binary msg to tracing buffer
  *
  */
-int trace_vbprintk(unsigned long ip, int depth, const char *fmt, va_list args)
+int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	static raw_spinlock_t trace_buf_lock =
 		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
@@ -1236,7 +1236,6 @@ int trace_vbprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
 	entry->ip			= ip;
-	entry->depth			= depth;
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
@@ -1254,7 +1253,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(trace_vbprintk);
 
-int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
+int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
@@ -1291,7 +1290,6 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
 	entry->ip			= ip;
-	entry->depth			= depth;
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
@@ -3140,7 +3138,7 @@ static int mark_printk(const char *fmt, ...)
 	int ret;
 	va_list args;
 	va_start(args, fmt);
-	ret = trace_vprintk(0, -1, fmt, args);
+	ret = trace_vprintk(0, fmt, args);
 	va_end(args);
 	return ret;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 38276d1..7c9a0cb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -123,7 +123,6 @@ struct userstack_entry {
 struct bprint_entry {
 	struct trace_entry	ent;
 	unsigned long		ip;
-	int			depth;
 	const char		*fmt;
 	u32			buf[];
 };
@@ -131,7 +130,6 @@ struct bprint_entry {
 struct print_entry {
 	struct trace_entry	ent;
 	unsigned long		ip;
-	int			depth;
 	char			buf[];
 };
 
@@ -598,9 +596,9 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 extern void *head_page(struct trace_array_cpu *data);
 extern long ns2usecs(cycle_t nsec);
 extern int
-trace_vbprintk(unsigned long ip, int depth, const char *fmt, va_list args);
+trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
-trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
+trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 0199150..fd78bee 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -105,7 +105,6 @@ TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
 TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD(unsigned int, depth, depth)
 		TRACE_FIELD(char *, fmt, fmt)
 		TRACE_FIELD_ZERO_CHAR(buf)
 	),
@@ -115,7 +114,6 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD(unsigned int, depth, depth)
 		TRACE_FIELD_ZERO_CHAR(buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index f095916..8e37fcd 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -359,5 +359,5 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 
 int mmio_trace_printk(const char *fmt, va_list args)
 {
-	return trace_vprintk(0, -1, fmt, args);
+	return trace_vprintk(0, fmt, args);
 }
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 4867852..eb81556 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -112,7 +112,7 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 		return 0;
 
 	va_start(ap, fmt);
-	ret = trace_vbprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	ret = trace_vbprintk(ip, fmt, ap);
 	va_end(ap);
 	return ret;
 }
@@ -126,7 +126,7 @@ int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
 	if (!(trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
-	return trace_vbprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	return trace_vbprintk(ip, fmt, ap);
 }
 EXPORT_SYMBOL_GPL(__ftrace_vbprintk);
 
@@ -139,7 +139,7 @@ int __trace_printk(unsigned long ip, const char *fmt, ...)
 		return 0;
 
 	va_start(ap, fmt);
-	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	ret = trace_vprintk(ip, fmt, ap);
 	va_end(ap);
 	return ret;
 }
@@ -150,7 +150,7 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 	if (!(trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
-	return trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	return trace_vprintk(ip, fmt, ap);
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
-- 
1.6.2

-- 
