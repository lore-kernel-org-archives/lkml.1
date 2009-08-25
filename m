Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZHYIJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZHYIJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZHYIJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:09:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZHYIJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:09:50 -0400
Message-ID: <4A939D08.6050604@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 16:12:56 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ftrace: Move setting of clock-source out of options
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com> <4A939CDF.2000407@cn.fujitsu.com>
In-Reply-To: <4A939CDF.2000407@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many clock source for tracing system but we can only
enable/disable one bit by trace/options file.
We can move setting of clock-source out of options and add a separate
file for it:
 # cat trace_clock
 [local] global
 # echo global > trace_clock
 # cat trace_clock
 local [global]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace.c |   92 ++++++++++++++++++++++++++++++++++++++++---------
 kernel/trace/trace.h |    7 ++--
 2 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b7d873b..5af6f83 100644
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
@@ -3910,6 +3965,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("trace_clock", 0644, d_tracer, NULL,
+			  &trace_clock_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 606073c..0545c2b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -586,6 +586,8 @@ trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
+extern int trace_clock_id;
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
@@ -674,9 +676,8 @@ enum trace_iterator_flags {
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
1.5.5.3

