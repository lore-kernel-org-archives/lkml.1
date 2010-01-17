Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491Ab0AQScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0AQScO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480Ab0AQScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:32:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:34341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0AQSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:31:48 -0500
Date: Sun, 17 Jan 2010 18:30:48 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
References: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Drop the tr check from the graph tracing path
Message-ID: <tip-24a53652e361321b09df5040711e69387344ce09@git.kernel.org>
Git-Commit-ID: 24a53652e361321b09df5040711e69387344ce09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 18:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a53652e361321b09df5040711e69387344ce09
Gitweb:     http://git.kernel.org/tip/24a53652e361321b09df5040711e69387344ce09
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 14 Jan 2010 08:23:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 08:06:25 +0100

tracing: Drop the tr check from the graph tracing path

Each time we save a function entry from the function graph
tracer, we check if the trace array is set, which is wasteful
because it is set anyway before we start the tracer. All we need
is to ensure we have good read and write orderings. When we set
the trace array, we just need to guarantee it to be visible
before starting tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_functions_graph.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b1342c5..f225229 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -212,9 +212,6 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	int cpu;
 	int pc;
 
-	if (unlikely(!tr))
-		return 0;
-
 	if (!ftrace_trace_task(current))
 		return 0;
 
@@ -287,11 +284,20 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 	local_irq_restore(flags);
 }
 
+void set_graph_array(struct trace_array *tr)
+{
+	graph_array = tr;
+
+	/* Make graph_array visible before we start tracing */
+
+	smp_mb();
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int ret;
 
-	graph_array = tr;
+	set_graph_array(tr);
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry);
 	if (ret)
@@ -301,11 +307,6 @@ static int graph_trace_init(struct trace_array *tr)
 	return 0;
 }
 
-void set_graph_array(struct trace_array *tr)
-{
-	graph_array = tr;
-}
-
 static void graph_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_cmdline_record();
