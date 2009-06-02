Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZFBSqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZFBSqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZFBSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:46:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFBSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:46:00 -0400
Message-Id: <20090602184601.361575345@goodmis.org>
References: <20090602183036.621443366@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 14:30:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/3] function-graph: add memory barriers for accessing tasks ret_stack
Content-Disposition: inline; filename=0003-function-graph-add-memory-barriers-for-accessing-tas.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code that handles the tasks ret_stack allocation for every task
assumes that only an interrupt can cause issues (even though interrupts
are disabled).

In reality, the code is allocating the ret_stack for tasks that may be
running on other CPUs and there are not efficient memory barriers to
handle this case.

[ Impact: prevent crash due to using of uninitialized ret_stack variables ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 20e0660..1664d3f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2580,12 +2580,12 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 
 		if (t->ret_stack == NULL) {
-			t->curr_ret_stack = -1;
-			/* Make sure IRQs see the -1 first: */
-			barrier();
-			t->ret_stack = ret_stack_list[start++];
 			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
+			t->curr_ret_stack = -1;
+			/* Make sure the tasks see the -1 first: */
+			smp_wmb();
+			t->ret_stack = ret_stack_list[start++];
 		}
 	} while_each_thread(g, t);
 
-- 
1.6.3.1

-- 
