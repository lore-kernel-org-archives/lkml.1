Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab0BYXgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:36:49 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:13342
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934488Ab0BYXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:36:48 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz14c3Lab9bhzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B87098B.4040308@am.sony.com>
Date: Thu, 25 Feb 2010 15:36:43 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: add tracing_thresh support to function_graph tracer
 (v3)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for tracing_thresh to the function_graph tracer.  This
version of this feature isolates the checks into new entry and
return functions, to avoid adding more conditional code into the
main function_graph paths.

Also, add support for specifying tracing_thresh on the kernel
command line.  When used like so: "tracing_thresh=200 ftrace=function_graph"
this can be used to analyse system startup.  It is important to disable
tracing soon after boot, in order to avoid losing the trace data.

Note: the elimination of 'notrace' in the definition of '__init'
may be controversial.  This can be removed, or made conditional,
if it's a bit too scary, but it worked OK for me.  Tracing during
kernel startup still works, just with no visibility of routines
declared __init.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 include/linux/init.h                 |    2 +-
 kernel/trace/trace.c                 |   20 ++++++++++++++++++--
 kernel/trace/trace.h                 |    3 ++-
 kernel/trace/trace_functions_graph.c |   32 +++++++++++++++++++++++++++++---
 4 files changed, 50 insertions(+), 7 deletions(-)

--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -40,7 +40,7 @@

 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__section(.init.text) __cold notrace
+#define __init		__section(.init.text) __cold
 #define __initdata	__section(.init.data)
 #define __initconst	__section(.init.rodata)
 #define __exitdata	__section(.exit.data)
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -297,6 +297,21 @@ static int __init set_buf_size(char *str
 }
 __setup("trace_buf_size=", set_buf_size);

+static int __init set_tracing_thresh(char *str)
+{
+	unsigned long threshhold;
+	int ret;
+
+	if (!str)
+		return 0;
+	ret = strict_strtoul(str, 0, &threshhold);
+	if (ret < 0)
+		return 0;
+	tracing_thresh = threshhold * 1000;
+	return 1;
+}
+__setup("tracing_thresh=", set_tracing_thresh);
+
 unsigned long nsecs_to_usecs(unsigned long nsecs)
 {
 	return nsecs / 1000;
@@ -502,9 +517,10 @@ static ssize_t trace_seq_to_buffer(struc
 static arch_spinlock_t ftrace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;

+unsigned long __read_mostly	tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;

 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -4181,10 +4197,10 @@ static __init int tracer_init_debugfs(vo
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
+#endif

 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
-#endif

 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -396,9 +396,10 @@ extern int process_new_ksym_entry(char *

 extern unsigned long nsecs_to_usecs(unsigned long nsecs);

+extern unsigned long tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
-extern unsigned long tracing_thresh;

 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -241,6 +241,14 @@ int trace_graph_entry(struct ftrace_grap
 	return ret;
 }

+int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+{
+	if (tracing_thresh)
+		return 1;
+	else
+		return trace_graph_entry(trace);
+}
+
 static void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
@@ -287,13 +295,27 @@ void trace_graph_return(struct ftrace_gr
 	local_irq_restore(flags);
 }

+void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+{
+	if (tracing_thresh &&
+		(trace->rettime - trace->calltime < tracing_thresh))
+		return;
+	else
+		trace_graph_return(trace);
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int ret;

 	graph_array = tr;
-	ret = register_ftrace_graph(&trace_graph_return,
-				    &trace_graph_entry);
+	if (tracing_thresh)
+		ret = register_ftrace_graph(&trace_graph_thresh_return,
+			    &trace_graph_thresh_entry);
+	else
+		ret = register_ftrace_graph(&trace_graph_return,
+			    &trace_graph_entry);
+
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
@@ -891,7 +913,11 @@ print_graph_return(struct ftrace_graph_r
 			return TRACE_TYPE_PARTIAL_LINE;
 	}

-	ret = trace_seq_printf(s, "}\n");
+	if (tracing_thresh) {
+		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
+	} else {
+		ret = trace_seq_printf(s, "}\n");
+	}
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;



