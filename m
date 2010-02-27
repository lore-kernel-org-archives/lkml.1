Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966708Ab0B0A1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:27:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966662Ab0B0A1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:27:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=o0qKlO5oilcA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5pLrBahQNnY8Uum8Q8UA:9 a=H2VG3F2c9q7T6X4ZmLkA:7 a=6MYDs6TX8bbGgz6O5WC9v4I13lIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
 function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 26 Feb 2010 19:27:19 -0500
Message-ID: <1267230439.6328.149.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (1):
      ftrace: Add function names to dangling } in function graph tracer

----
 kernel/trace/trace_functions_graph.c |   52 ++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 9 deletions(-)
---------------------------
commit f1c7f517a5dc23bce07efa5ed55e2c074ed9d4ba
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Feb 26 17:08:16 2010 -0500

    ftrace: Add function names to dangling } in function graph tracer
    
    The function graph tracer is currently the most invasive tracer
    in the ftrace family. It can easily overflow the buffer even with
    10megs per CPU. This means that events can often be lost.
    
    On start up, or after events are lost, if the function return is
    recorded but the function enter was lost, all we get to see is the
    exiting '}'.
    
    Here is how a typical trace output starts:
    
     [tracing] cat trace
     # tracer: function_graph
     #
     # CPU  DURATION                  FUNCTION CALLS
     # |     |   |                     |   |   |   |
      0) + 91.897 us   |                  }
      0) ! 567.961 us  |                }
      0)   <========== |
      0) ! 579.083 us  |                _raw_spin_lock_irqsave();
      0)   4.694 us    |                _raw_spin_unlock_irqrestore();
      0) ! 594.862 us  |              }
      0) ! 603.361 us  |            }
      0) ! 613.574 us  |          }
      0) ! 623.554 us  |        }
      0)   3.653 us    |        fget_light();
      0)               |        sock_poll() {
    
    There are a series of '}' with no matching "func() {". There's no information
    to what functions these ending brackets belong to.
    
    This patch adds a stack on the per cpu structure used in outputting
    the function graph tracer to keep track of what function was outputted.
    Then on a function exit event, it checks the depth to see if the
    function exit has a matching entry event. If it does, then it only
    prints the '}', otherwise it adds the function name after the '}'.
    
    This allows function exit events to show what function they belong to
    at trace output startup, when the entry was lost due to ring buffer
    overflow, or even after a new task is scheduled in.
    
    Here is what the above trace will look like after this patch:
    
     [tracing] cat trace
     # tracer: function_graph
     #
     # CPU  DURATION                  FUNCTION CALLS
     # |     |   |                     |   |   |   |
      0) + 91.897 us   |                  } (irq_exit)
      0) ! 567.961 us  |                } (smp_apic_timer_interrupt)
      0)   <========== |
      0) ! 579.083 us  |                _raw_spin_lock_irqsave();
      0)   4.694 us    |                _raw_spin_unlock_irqrestore();
      0) ! 594.862 us  |              } (add_wait_queue)
      0) ! 603.361 us  |            } (__pollwait)
      0) ! 613.574 us  |          } (tcp_poll)
      0) ! 623.554 us  |        } (sock_poll)
      0)   3.653 us    |        fget_light();
      0)               |        sock_poll() {
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 112561d..e998a82 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -18,6 +18,7 @@ struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
 	int		ignore;
+	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
 };
 
 struct fgraph_data {
@@ -670,15 +671,21 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	duration = graph_ret->rettime - graph_ret->calltime;
 
 	if (data) {
+		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
 
 		/*
 		 * Comments display at + 1 to depth. Since
 		 * this is a leaf function, keep the comments
 		 * equal to this depth.
 		 */
-		*depth = call->depth - 1;
+		cpu_data->depth = call->depth - 1;
+
+		/* No need to keep this function around for this depth */
+		if (call->depth < FTRACE_RETFUNC_DEPTH)
+			cpu_data->enter_funcs[call->depth] = 0;
 	}
 
 	/* Overhead */
@@ -718,10 +725,15 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	int i;
 
 	if (data) {
+		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
-		*depth = call->depth;
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
+		cpu_data->depth = call->depth;
+
+		/* Save this function pointer to see if the exit matches */
+		if (call->depth < FTRACE_RETFUNC_DEPTH)
+			cpu_data->enter_funcs[call->depth] = call->func;
 	}
 
 	/* No overhead */
@@ -851,18 +863,28 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	struct fgraph_data *data = iter->private;
 	pid_t pid = ent->pid;
 	int cpu = iter->cpu;
+	int func_match = 1;
 	int ret;
 	int i;
 
 	if (data) {
-		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+		struct fgraph_cpu_data *cpu_data;
+		int cpu = iter->cpu;
+
+		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
 
 		/*
 		 * Comments display at + 1 to depth. This is the
 		 * return from a function, we now want the comments
 		 * to display at the same level of the bracket.
 		 */
-		*depth = trace->depth - 1;
+		cpu_data->depth = trace->depth - 1;
+
+		if (trace->depth < FTRACE_RETFUNC_DEPTH) {
+			if (cpu_data->enter_funcs[trace->depth] != trace->func)
+				func_match = 0;
+			cpu_data->enter_funcs[trace->depth] = 0;
+		}
 	}
 
 	if (print_graph_prologue(iter, s, 0, 0))
@@ -887,9 +909,21 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "}\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	/*
+	 * If the return function does not have a matching entry,
+	 * then the entry was lost. Instead of just printing
+	 * the '}' and letting the user guess what function this
+	 * belongs to, write out the function name.
+	 */
+	if (func_match) {
+		ret = trace_seq_printf(s, "}\n");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	} else {
+		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Overrun */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {


