Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419Ab0ANHXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0ANHXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402Ab0ANHXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:23:22 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:41777 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0ANHXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gR77Z9S13DH+oZ6AKF9Va4+VtQi51vkVUyXc60hH4n8wrg1KoFooTOpau3OKhqxhxy
         RDr+nl0eG0opgPuSNBe0dgtGfyN8JWDu2Qm94BqqgJIXqipCTNBTzsRY/Nhpxvbh8A60
         Fn3oLwxI7bY6XMX++5JOkq0FRUlPDivCvth+c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] tracing: Drop the tr check from the graph tracing path
Date: Thu, 14 Jan 2010 08:23:15 +0100
Message-Id: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time we save a function entry from the function graph tracer,
we check if the trace array is set, which is wasteful because it is
set anyway before we start the tracer. All we need is to ensure we
have good read and write orderings. When we set the trace array, we
just need to guarantee it to be visible before starting tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.6.2.3

