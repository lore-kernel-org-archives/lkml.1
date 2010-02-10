Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0BJWwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:52:54 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51860
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754109Ab0BJWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:52:53 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zzab9bh98dN936eM1fa4L9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B7338BF.1070505@am.sony.com>
Date: Wed, 10 Feb 2010 14:52:47 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to function_graph
 tracer
References: <4B733721.3030503@am.sony.com>
In-Reply-To: <4B733721.3030503@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 02:45 PM, Tim Bird wrote:
(a bunch of format_flowed garbage)

Sorry - I updated my mail client and forgot to disable the format_flowed
option.

Here's the patch again, hopefully in better format this time.

This adds support for 'tracing_thresh' to the existing function_graph
tracer.  When 'tracing_thresh' is in effect, function entry events are
not stored - only function exits are stored.  This prevents filtered
functions from filling up the log. An extra option is added to allow
showing the function name with the exit event.  (Otherwise, all you
get are closing braces.)

Note that the 'funcgraph-exit' display option is valuable by itself,
since it makes the output much more 'grep-able'.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
--
 trace.c                 |    5 +++--
 trace_functions_graph.c |   20 +++++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..aa39f8e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -502,9 +502,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 static arch_spinlock_t ftrace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+unsigned long __read_mostly	tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;
 
 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -4176,10 +4177,10 @@ static __init int tracer_init_debugfs(void)
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
+#endif
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
-#endif
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b1342c5..e019e32 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -39,6 +39,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME	0X20
+#define TRACE_GRAPH_PRINT_FUNC_EXIT	0X40
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
 	/* Display absolute time of an entry */
 	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
+	/* Display function name on exit, instead of just closing brace */
+	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
 	{ } /* Empty entry */
 };
 
@@ -202,6 +205,8 @@ static int __trace_graph_entry(struct trace_array *tr,
 	return 1;
 }
 
+extern unsigned long __read_mostly tracing_thresh;
+
 int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = graph_array;
@@ -221,6 +226,10 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	if (!ftrace_graph_addr(trace->func))
 		return 0;
 
+	/* if tracing duration, only save function exits (omit function entries in log) */
+	if (tracing_thresh)
+		return 1;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
@@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
 	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
 		return;
 
+	if (tracing_thresh &&
+		(trace->rettime - trace->calltime < tracing_thresh))
+		return;
+
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
 					  sizeof(*entry), flags, pc);
 	if (!event)
@@ -891,7 +904,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "}\n");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_FUNC_EXIT) {
+		ret = trace_seq_printf(s, "%ps();\n", (void *)trace->func);
+	} else {
+		ret = trace_seq_printf(s, "}\n");
+	}
+
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 




