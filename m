Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0CMDAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:00:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab0CMC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:58:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=vq4x9zN42s4A:10 a=GzHTLUccyWwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=b4-7jKNdfTALavJWy6AA:9 a=VoB_kqMqjAiOZfFostMA:7 a=j_EsQd4Vausfcf7P2FycM_uvsGIA:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100313025854.558236650@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Mar 2010 21:56:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: [PATCH 2/5] function-graph: Init curr_ret_stack with ret_stack
References: <20100313025655.104950166@goodmis.org>
Content-Disposition: inline; filename=0002-function-graph-Init-curr_ret_stack-with-ret_stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the graph tracer is active, and a task is forked but the allocating of
the processes graph stack fails, it can cause crash later on.

This is due to the temporary stack being NULL, but the curr_ret_stack
variable is copied from the parent. If it is not -1, then in
ftrace_graph_probe_sched_switch() the following:

	for (index = next->curr_ret_stack; index >= 0; index--)
		next->ret_stack[index].calltime += timestamp;

Will cause a kernel OOPS.

Found with Li Zefan's ftrace_stress_test.

Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d4d1238..bb53edb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3349,6 +3349,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 {
 	/* Make sure we do not use the parent ret_stack */
 	t->ret_stack = NULL;
+	t->curr_ret_stack = -1;
 
 	if (ftrace_graph_active) {
 		struct ftrace_ret_stack *ret_stack;
@@ -3358,7 +3359,6 @@ void ftrace_graph_init_task(struct task_struct *t)
 				GFP_KERNEL);
 		if (!ret_stack)
 			return;
-		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 		t->ftrace_timestamp = 0;
-- 
1.7.0


