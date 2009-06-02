Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbZFBSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbZFBSq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFBSqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:46:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFBSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:46:00 -0400
Message-Id: <20090602184601.206454309@goodmis.org>
References: <20090602183036.621443366@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 14:30:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/3] function-graph: enable the stack after initialization of other variables
Content-Disposition: inline; filename=0002-function-graph-enable-the-stack-after-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function graph tracer checks if the task_struct has ret_stack defined
to know if it is OK or not to use it. The initialization is done for
all tasks by one process, but the idle tasks use the same initialization
used by new tasks.

If an interrupt happens on an idle task that just had the ret_stack
created, but before the rest of the initialization took place, then
we can corrupt the return address of the functions.

This patch moves the setting of the task_struct's ret_stack to after
the other variables have been initialized.

[ Impact: prevent kernel panic on idle task when starting function graph ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                |    9 +++++++--
 kernel/trace/trace_functions_graph.c |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ebff62e..20e0660 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2739,15 +2739,20 @@ void unregister_ftrace_graph(void)
 void ftrace_graph_init_task(struct task_struct *t)
 {
 	if (atomic_read(&ftrace_graph_active)) {
-		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+		struct ftrace_ret_stack *ret_stack;
+
+		ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
 				* sizeof(struct ftrace_ret_stack),
 				GFP_KERNEL);
-		if (!t->ret_stack)
+		if (!ret_stack)
 			return;
 		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 		t->ftrace_timestamp = 0;
+		/* make curr_ret_stack visable before we add the ret_stack */
+		smp_wmb();
+		t->ret_stack = ret_stack;
 	} else
 		t->ret_stack = NULL;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d28687e..baeb5fe 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -65,6 +65,12 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 	if (!current->ret_stack)
 		return -EBUSY;
 
+	/*
+	 * We must make sure the ret_stack is tested before we read
+	 * anything else.
+	 */
+	smp_rmb();
+
 	/* The return trace stack is full */
 	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
 		atomic_inc(&current->trace_overrun);
-- 
1.6.3.1

-- 
