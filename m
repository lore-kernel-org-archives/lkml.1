Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZFBSql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZFBSql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZFBSqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:46:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZFBSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:46:00 -0400
Message-Id: <20090602184600.925026719@goodmis.org>
References: <20090602183036.621443366@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 14:30:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/3] function-graph: only allocate init tasks if it was not already done
Content-Disposition: inline; filename=0001-function-graph-only-allocate-init-tasks-if-it-was-no.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the function graph tracer is enabled, it calls the initialization
needed for the init tasks that would be called on all created tasks.

The problem is that this is called every time the function graph tracer
is enabled, and the ret_stack is allocated for the idle tasks each time.
Thus, the old ret_stack is lost and a memory leak is created.

This is also dangerous because if an interrupt happened on another CPU
with the init task and the ret_stack is replaced, we then lose all the
return pointers for the interrupt, and a crash would take place.

[ Impact: fix memory leak and possible crash due to race ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1ed080..ebff62e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2643,8 +2643,10 @@ static int start_graph_tracing(void)
 		return -ENOMEM;
 
 	/* The cpu_boot init_task->ret_stack will never be freed */
-	for_each_online_cpu(cpu)
-		ftrace_graph_init_task(idle_task(cpu));
+	for_each_online_cpu(cpu) {
+		if (!idle_task(cpu)->ret_stack)
+			ftrace_graph_init_task(idle_task(cpu));
+	}
 
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
-- 
1.6.3.1

-- 
