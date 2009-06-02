Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZFBWDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZFBWDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZFBWDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:03:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54588 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZFBWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:03:09 -0400
Message-Id: <20090602220309.764167406@goodmis.org>
References: <20090602220212.894951549@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 18:02:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org
Subject: [PATCH 2/2] function-graph: always initialize task ret_stack
Content-Disposition: inline; filename=0002-function-graph-always-initialize-task-ret_stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On creating a new task while running the function graph tracer, if
we fail to allocate the ret_stack, and then fail the fork, the
code will free the parent ret_stack. This is because the child
duplicated the parent and currently points to the parent's ret_stack.

This patch always initializes the task's ret_stack to NULL.

[ Impact: prevent crash of parent on low memory during fork ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1664d3f..bb081f3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2738,6 +2738,9 @@ void unregister_ftrace_graph(void)
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
+	/* Make sure we do not use the parent ret_stack */
+	t->ret_stack = NULL;
+
 	if (atomic_read(&ftrace_graph_active)) {
 		struct ftrace_ret_stack *ret_stack;
 
@@ -2753,8 +2756,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 		/* make curr_ret_stack visable before we add the ret_stack */
 		smp_wmb();
 		t->ret_stack = ret_stack;
-	} else
-		t->ret_stack = NULL;
+	}
 }
 
 void ftrace_graph_exit_task(struct task_struct *t)
-- 
1.6.3.1

-- 
