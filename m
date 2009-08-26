Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZHZFCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZHZFCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZHZFCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:02:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58588 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZHZFAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:51 -0400
Message-Id: <20090826050052.110745123@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 6/8] ftrace: Move setting of clock-source out of options
Content-Disposition: inline; filename=0006-ftrace-Move-setting-of-clock-source-out-of-options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

There are many clock sources for the tracing system but we can only
enable/disable one at a time with the trace/options file.
We can move the setting of clock-source out of options and add a separate
file for it:
 # cat trace_clock
 [local] global
 # echo global > trace_clock
 # cat trace_clock
 local [global]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A939D08.6050604@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   92 ++++++++++++++++++++++++++++++++++++++++---------
 kernel/trace/trace.h |    7 ++--
 2 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8ac2043..63dbc7f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -323,12 +323,21 @@ static const char *trace_options[] = {
 	"printk-msg-only",
 	"context-info",
 	"latency-format",
-	"global-clock",
 	"sleep-time",
 	"graph-time",
 	NULL
 };
 
+static struct {
+	u64 (*func)(void);
+	const char *name;
+} trace_clocks[] = {
+	{ trace_clock_local,	"local" },
+	{ trace_clock_global,	"global" },
+};
+
+int trace_clock_id;
+
 /*
  * ftrace_max_lock is used to protect the swapping of buffers
  * when taking a max snapshot. The buffers themselves are
@@ -2159,22 +2168,6 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_flags |= mask;
 	else
 		trace_flags &= ~mask;
-
-	if (mask == TRACE_ITER_GLOBAL_CLK) {
-		u64 (*func)(void);
-
-		if (enabled)
-			func = trace_clock_global;
-		else
-			func = trace_clock_local;
-
-		mutex_lock(&trace_types_lock);
-		ring_buffer_set_clock(global_trace.buffer, func);
-
-		if (max_tr.buffer)
-			ring_buffer_set_clock(max_tr.buffer, func);
-		mutex_unlock(&trace_types_lock);
-	}
 }
 
 static ssize_t
@@ -3142,6 +3135,62 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int bufiter = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
+		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
+			"%s%s%s%s", i ? " " : "",
+			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
+			i == trace_clock_id ? "]" : "");
+	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
+}
+
+static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *fpos)
+{
+	char buf[64];
+	const char *clockstr;
+	int i;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	clockstr = strstrip(buf);
+
+	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++) {
+		if (strcmp(trace_clocks[i].name, clockstr) == 0)
+			break;
+	}
+	if (i == ARRAY_SIZE(trace_clocks))
+		return -EINVAL;
+
+	trace_clock_id = i;
+
+	mutex_lock(&trace_types_lock);
+
+	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func);
+	if (max_tr.buffer)
+		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
+
+	mutex_unlock(&trace_types_lock);
+
+	*fpos += cnt;
+
+	return cnt;
+}
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -3179,6 +3228,12 @@ static const struct file_operations tracing_mark_fops = {
 	.write		= tracing_mark_write,
 };
 
+static const struct file_operations trace_clock_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_clock_read,
+	.write		= tracing_clock_write,
+};
+
 struct ftrace_buffer_info {
 	struct trace_array	*tr;
 	void			*spare;
@@ -3918,6 +3973,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("trace_clock", 0644, d_tracer, NULL,
+			  &trace_clock_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 64dda57..654fd65 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -568,6 +568,8 @@ trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
+extern int trace_clock_id;
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
@@ -656,9 +658,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
 	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
-	TRACE_ITER_GLOBAL_CLK		= 0x80000,
-	TRACE_ITER_SLEEP_TIME		= 0x100000,
-	TRACE_ITER_GRAPH_TIME		= 0x200000,
+	TRACE_ITER_SLEEP_TIME		= 0x80000,
+	TRACE_ITER_GRAPH_TIME		= 0x100000,
 };
 
 /*
-- 
1.6.3.3

-- 
