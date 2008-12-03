Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYLCEve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYLCEve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYLCEur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045044.222038233@goodmis.org>
References: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: add checks on ret stack in function graph
Content-Disposition: inline; filename=0005-ftrace-add-checks-on-ret-stack-in-function-graph.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Import: robustness checks

Add more checks in the function graph code to detect errors and
perhaps print out better information if a bug happens.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d278ad2..f98c407 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -420,6 +420,15 @@ static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 	int index;
 
 	index = current->curr_ret_stack;
+
+	if (unlikely(index < 0)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic, otherwise we have no where to go */
+		*ret = (unsigned long)panic;
+		return;
+	}
+
 	*ret = current->ret_stack[index].ret;
 	trace->func = current->ret_stack[index].func;
 	trace->calltime = current->ret_stack[index].calltime;
@@ -427,6 +436,7 @@ static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 	trace->depth = index;
 	barrier();
 	current->curr_ret_stack--;
+
 }
 
 /*
@@ -442,6 +452,13 @@ unsigned long ftrace_return_to_handler(void)
 	trace.rettime = cpu_clock(raw_smp_processor_id());
 	ftrace_graph_return(&trace);
 
+	if (unlikely(!ret)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic. What else to do? */
+		ret = (unsigned long)panic;
+	}
+
 	return ret;
 }
 
-- 
1.5.6.5

-- 
