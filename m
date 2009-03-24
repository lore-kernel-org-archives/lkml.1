Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZCXN5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZCXN5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZCXN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:56:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZCXN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:56:13 -0400
Message-Id: <20090324135610.441707783@goodmis.org>
References: <20090324135422.026619569@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 09:54:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] function-graph: ignore times across schedule
Content-Disposition: inline; filename=0003-function-graph-ignore-times-across-schedule.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: more accurate timings

The current method of function graph tracing does not take into
account the time spent when a task is not running. This shows functions
that call schedule have increased costs:

 3) + 18.664 us   |      }
 ------------------------------------------
 3)    <idle>-0    =>  kblockd-123
 ------------------------------------------

 3)               |      finish_task_switch() {
 3)   1.441 us    |        _spin_unlock_irq();
 3)   3.966 us    |      }
 3) ! 2959.433 us |    }
 3) ! 2961.465 us |  }

This patch uses the tracepoint in the scheduling context switch to
account for time that has elapsed while a task is scheduled out.
Now we see:

 ------------------------------------------
 3)    <idle>-0    =>  edac-po-1067
 ------------------------------------------

 3)               |      finish_task_switch() {
 3)   0.685 us    |        _spin_unlock_irq();
 3)   2.331 us    |      }
 3) + 41.439 us   |    }
 3) + 42.663 us   |  }

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/trace/ftrace.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89cd308..471e36d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1409,6 +1409,8 @@ struct task_struct {
 	int curr_ret_stack;
 	/* Stack of return addresses for return function tracing */
 	struct ftrace_ret_stack	*ret_stack;
+	/* time stamp for last schedule */
+	unsigned long long ftrace_timestamp;
 	/*
 	 * Number of functions that haven't been traced
 	 * because of depth overrun.
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c81a759..0b90364 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -29,6 +29,8 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 
+#include <trace/sched.h>
+
 #include <asm/ftrace.h>
 
 #include "trace.h"
@@ -2590,6 +2592,31 @@ free:
 	return ret;
 }
 
+static void
+ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
+				struct task_struct *next)
+{
+	unsigned long long timestamp;
+	int index;
+
+	timestamp = trace_clock_local();
+
+	prev->ftrace_timestamp = timestamp;
+
+	/* only process tasks that we timestamped */
+	if (!next->ftrace_timestamp)
+		return;
+
+	/*
+	 * Update all the counters in next to make up for the
+	 * time next was sleeping.
+	 */
+	timestamp -= next->ftrace_timestamp;
+
+	for (index = next->curr_ret_stack; index >= 0; index--)
+		next->ret_stack[index].calltime += timestamp;
+}
+
 /* Allocate a return stack for each task */
 static int start_graph_tracing(void)
 {
@@ -2611,6 +2638,13 @@ static int start_graph_tracing(void)
 		ret = alloc_retstack_tasklist(ret_stack_list);
 	} while (ret == -EAGAIN);
 
+	if (!ret) {
+		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch);
+		if (ret)
+			pr_info("ftrace_graph: Couldn't activate tracepoint"
+				" probe to kernel_sched_switch\n");
+	}
+
 	kfree(ret_stack_list);
 	return ret;
 }
@@ -2674,6 +2708,7 @@ void unregister_ftrace_graph(void)
 	mutex_lock(&ftrace_lock);
 
 	atomic_dec(&ftrace_graph_active);
+	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
@@ -2694,6 +2729,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
+		t->ftrace_timestamp = 0;
 	} else
 		t->ret_stack = NULL;
 }
-- 
1.6.2

-- 
