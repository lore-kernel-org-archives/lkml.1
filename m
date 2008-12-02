Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbYLBUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbYLBUfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYLBUe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203424.606667175@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: replace raw_local_irq_save with local_irq_save
Content-Disposition: inline; filename=0001-ftrace-replace-raw_local_irq_save-with-local_irq_sa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix for lockdep and ftrace

The raw_local_irq_save/restore confuses lockdep. This patch
converts them to the local_irq_save/restore variants.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/lockdep.c            |    1 +
 kernel/trace/trace.c        |   12 ++++++------
 kernel/trace/trace_branch.c |    4 ++--
 kernel/trace/trace_stack.c  |    8 ++++----
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 670aba8..1eb7c0b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -25,6 +25,7 @@
  * Thanks to Arjan van de Ven for coming up with the initial idea of
  * mapping lock dependencies runtime.
  */
+#define DISABLE_BRANCH_PROFILING
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 91887a2..380de63 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1209,7 +1209,7 @@ void trace_graph_entry(struct ftrace_graph_ent *trace)
 	int cpu;
 	int pc;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -1218,7 +1218,7 @@ void trace_graph_entry(struct ftrace_graph_ent *trace)
 		__trace_graph_entry(tr, data, trace, flags, pc);
 	}
 	atomic_dec(&data->disabled);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 void trace_graph_return(struct ftrace_graph_ret *trace)
@@ -1230,7 +1230,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 	int cpu;
 	int pc;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -1239,7 +1239,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 		__trace_graph_return(tr, data, trace, flags, pc);
 	}
 	atomic_dec(&data->disabled);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -2645,7 +2645,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	if (err)
 		goto err_unlock;
 
-	raw_local_irq_disable();
+	local_irq_disable();
 	__raw_spin_lock(&ftrace_max_lock);
 	for_each_tracing_cpu(cpu) {
 		/*
@@ -2662,7 +2662,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		}
 	}
 	__raw_spin_unlock(&ftrace_max_lock);
-	raw_local_irq_enable();
+	local_irq_enable();
 
 	tracing_cpumask = tracing_cpumask_new;
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index bc97275..6c00feb 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -42,7 +42,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	if (unlikely(!tr))
 		return;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
@@ -74,7 +74,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 static inline
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index fde3be1..06a1611 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -48,7 +48,7 @@ static inline void check_stack(void)
 	if (!object_is_on_stack(&this_size))
 		return;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	__raw_spin_lock(&max_stack_lock);
 
 	/* a race could have already updated it */
@@ -96,7 +96,7 @@ static inline void check_stack(void)
 
  out:
 	__raw_spin_unlock(&max_stack_lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 static void
@@ -162,11 +162,11 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 	if (ret < 0)
 		return ret;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	__raw_spin_lock(&max_stack_lock);
 	*ptr = val;
 	__raw_spin_unlock(&max_stack_lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return count;
 }
-- 
1.5.6.5

-- 
