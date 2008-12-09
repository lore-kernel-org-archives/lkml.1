Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYLIWzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYLIWzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYLIWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:55:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:41643 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbYLIWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vkMaxMUsry8Mu8NqQ92poL8yBS7JY86gwhcnbcBl/KAQIvG0ka3CRB87zP6uTj7IbT
         Ou9zFv29IFk8x92j2oCuHkwyJAzCJxOUvJcHfXKxvUhJ3QHOACStJbfxkSUzjhMccNdO
         pOw/+Oef6J8pelCm92qSvxXyjCYKQ4ktdhDrU=
Message-ID: <493EF75D.5070902@gmail.com>
Date: Tue, 09 Dec 2008 23:55:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/function-graph-tracer: Output arrows signal on
 hardirq call/return
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Make more obvious the hardirq calls in the output

When a hardirq is triggered inside the codeflow on output, we have
now two arrows that indicate the entry and return of the hardirq.

 0)               |                                        bit_waitqueue() {
 0)   0.880 us    |                                          __phys_addr();
 0)   2.699 us    |                                        }
 0)               |                                        __wake_up_bit() {
 0)   ==========> |                                        smp_apic_timer_interrupt() {
 0)   0.797 us    |                                          native_apic_mem_write();
 0)   0.715 us    |                                          exit_idle();
 0)               |                                          irq_enter() {
 0)   0.722 us    |                                            idle_cpu();
 0)   5.519 us    |                                          }
 0)               |                                          hrtimer_interrupt() {
 0)               |                                            ktime_get() {
 0)               |                                              ktime_get_ts() {
 0)   0.805 us    |                                                getnstimeofday();

 [...]

 0) ! 108.528 us  |                                          }
 0)               |                                          irq_exit() {
 0)               |                                            do_softirq() {
 0)               |                                              __do_softirq() {
 0)   0.895 us    |                                                __local_bh_disable();
 0)               |                                                run_timer_softirq() {
 0)   0.827 us    |                                                  hrtimer_run_pending();
 0)   1.226 us    |                                                  _spin_lock_irq();
 0)               |                                                  _spin_unlock_irq() {
 0)   6.550 us    |                                                }
 0)   0.924 us    |                                                _local_bh_enable();
 0) + 12.129 us   |                                              }
 0) + 13.911 us   |                                            }
 0)   0.707 us    |                                            idle_cpu();
 0) + 17.009 us   |                                          }
 0) ! 137.419 us  |                                        }
 0)   <========== |
 0)   1.045 us    |                                        }
 0) ! 148.908 us  |                                      }
 0) ! 151.022 us  |                                    }
 0) ! 153.022 us  |                                  }
 0)   0.963 us    |                                  journal_mark_dirty();
 0)   0.925 us    |                                  __brelse();


Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |   66 +++++++++++++++++++++++++++++++--
 1 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index af60eef..4bf39fc 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -231,6 +231,49 @@ trace_branch_is_leaf(struct trace_iterator *iter,
 	return true;
 }
 
+static enum print_line_t
+print_graph_irq(struct trace_seq *s, unsigned long addr,
+				enum trace_type type, int cpu, pid_t pid)
+{
+	int ret;
+
+	if (addr < (unsigned long)__irqentry_text_start ||
+		addr >= (unsigned long)__irqentry_text_end)
+		return TRACE_TYPE_UNHANDLED;
+
+	if (type == TRACE_GRAPH_ENT) {
+		ret = trace_seq_printf(s, "==========> |  ");
+	} else {
+		/* Cpu */
+		if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+			ret = print_graph_cpu(s, cpu);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+		/* Proc */
+		if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+			ret = print_graph_proc(s, pid);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+
+			ret = trace_seq_printf(s, " | ");
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+
+		/* No overhead */
+		if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+			ret = trace_seq_printf(s, "  ");
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+
+		ret = trace_seq_printf(s, "<========== |\n");
+	}
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
 
 static enum print_line_t
 print_graph_duration(unsigned long long duration, struct trace_seq *s)
@@ -344,7 +387,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 
 static enum print_line_t
 print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
-			struct trace_seq *s)
+			struct trace_seq *s, pid_t pid, int cpu)
 {
 	int i;
 	int ret;
@@ -357,8 +400,18 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	/* No time */
-	ret = trace_seq_printf(s, "            |  ");
+	/* Interrupt */
+	ret = print_graph_irq(s, call->func, TRACE_GRAPH_ENT, cpu, pid);
+	if (ret == TRACE_TYPE_UNHANDLED) {
+		/* No time */
+		ret = trace_seq_printf(s, "            |  ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	} else {
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
@@ -410,7 +463,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	if (trace_branch_is_leaf(iter, field))
 		return print_graph_entry_leaf(iter, field, s);
 	else
-		return print_graph_entry_nested(field, s);
+		return print_graph_entry_nested(field, s, iter->ent->pid, cpu);
 
 }
 
@@ -474,6 +527,11 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
+
+	ret = print_graph_irq(s, trace->func, TRACE_GRAPH_RET, cpu, ent->pid);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
-- 
1.6.0.4

