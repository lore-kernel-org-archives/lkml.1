Return-Path: <linux-kernel-owner+w=401wt.eu-S934932AbXHJOOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932AbXHJOOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934159AbXHJOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:14:16 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:16740 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933035AbXHJOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:14:14 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] Adds full stack to critical-section tracing
To: mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 10 Aug 2007 08:14:13 -0600
Message-ID: <20070810141413.12966.13475.stgit@lsg>
In-Reply-To: <20070810140745.12966.8464.stgit@lsg>
References: <20070810140745.12966.8464.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


---

 include/linux/sched.h  |    7 +++++--
 kernel/latency_trace.c |   18 +++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8ebb43c..233d26c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1306,10 +1306,13 @@ struct task_struct {
 #endif
 
 #define MAX_PREEMPT_TRACE 25
+#define MAX_PREEMPT_TRACE_DEPTH 5
 
 #ifdef CONFIG_PREEMPT_TRACE
-	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
-	unsigned long preempt_trace_parent_eip[MAX_PREEMPT_TRACE];
+	struct {
+		struct stack_trace trace;
+		unsigned long      data[MAX_PREEMPT_TRACE_DEPTH];
+	} preempt_trace[MAX_PREEMPT_TRACE];
 #endif
 
 #define MAX_LOCK_STACK	MAX_PREEMPT_TRACE
diff --git a/kernel/latency_trace.c b/kernel/latency_trace.c
index 1113744..9b83262 100644
--- a/kernel/latency_trace.c
+++ b/kernel/latency_trace.c
@@ -2049,8 +2049,15 @@ void notrace add_preempt_count(unsigned int val)
 	if (val <= 10) {
 		unsigned int idx = preempt_count() & PREEMPT_MASK;
 		if (idx < MAX_PREEMPT_TRACE) {
-			current->preempt_trace_eip[idx] = eip;
-			current->preempt_trace_parent_eip[idx] = parent_eip;
+			struct stack_trace *trace;
+
+			trace = &current->preempt_trace[idx].trace;
+			trace->nr_entries = 0;
+			trace->max_entries = MAX_PREEMPT_TRACE_DEPTH;
+			trace->skip = 0;
+			trace->entries = current->preempt_trace[idx].data;
+
+			save_stack_trace(trace);
 		}
 	}
 #endif
@@ -2708,11 +2715,8 @@ static void print_preempt_trace(struct task_struct *task)
 	printk("| %d-level deep critical section nesting:\n", lim);
 	printk("----------------------------------------\n");
 	for (i = 1; i <= lim; i++) {
-		printk(".. [<%08lx>] .... ", task->preempt_trace_eip[i]);
-		print_symbol("%s\n", task->preempt_trace_eip[i]);
-		printk(".....[<%08lx>] ..   ( <= ",
-				task->preempt_trace_parent_eip[i]);
-		print_symbol("%s)\n", task->preempt_trace_parent_eip[i]);
+		printk("  ---- Critial Section #%d ----\n", i);
+		print_stack_trace(&task->preempt_trace[i].trace, 5);
 	}
 	printk("\n");
 }

