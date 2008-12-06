Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYLFCnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYLFCnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYLFCnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:43:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:63034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYLFCnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NpIZxKZukaplskhkbYzX2KrhlyKCUXY+d6xbWMjXjh7wvW6M8EwJkBzYPQuB0SJdI4
         kVuQFJ+9kg2sVbeNFf9kOkhQLrzkh1mWatcSqWv+6SRfwq4xYyJkoAZ3ASam23oiJTNR
         rJglx2+CaP04Sli073ktEpukv5HQoBKjuofEc=
Message-ID: <4939E6DD.8020506@gmail.com>
Date: Sat, 06 Dec 2008 03:43:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/function-graph-tracer: append the tracing_graph_flag
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Provide a way to pause the function graph tracer

As suggested by Steven Rostedt, the previous patch that prevented from
spinlock function tracing shouldn't use the raw_spinlock to fix it.
It's much better to follow lockdep with normal spinlock, so this patch
adds a new flag for each task to make the function graph tracer able
to be paused. We also can send an ftrace_printk whithout worrying of
the irrelevant traced spinlock during insertion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index f98c407..1b43086 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -476,7 +476,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 				&return_to_handler;
 
 	/* Nmi's are currently unsupported */
-	if (atomic_read(&in_nmi))
+	if (unlikely(atomic_read(&in_nmi)))
+		return;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
 	/*
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 449fa8e..11cac81 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -401,6 +401,16 @@ static inline int task_curr_ret_stack(struct task_struct *t)
 {
 	return t->curr_ret_stack;
 }
+
+static inline void pause_graph_tracing(void)
+{
+	atomic_inc(&current->tracing_graph_pause);
+}
+
+static inline void unpause_graph_tracing(void)
+{
+	atomic_dec(&current->tracing_graph_pause);
+}
 #else
 
 #define __notrace_funcgraph
@@ -412,6 +422,9 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
 {
 	return -1;
 }
+
+static inline void pause_graph_tracing(void) { }
+static inline void unpause_graph_tracing(void) { }
 #endif
 
 #ifdef CONFIG_TRACING
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a33fea..4e0440c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1389,6 +1389,8 @@ struct task_struct {
 	 * because of depth overrun.
 	 */
 	atomic_t trace_overrun;
+	/* Pause for the tracing */
+	atomic_t tracing_graph_pause;
 #endif
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2971fe4..a12f80e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1998,6 +1998,7 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 			/* Make sure IRQs see the -1 first: */
 			barrier();
 			t->ret_stack = ret_stack_list[start++];
+			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 		}
 	} while_each_thread(g, t);
@@ -2077,6 +2078,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 		if (!t->ret_stack)
 			return;
 		t->curr_ret_stack = -1;
+		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 	} else
 		t->ret_stack = NULL;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1cc0ebf..eeb5ad0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3590,14 +3590,7 @@ static __init int tracer_init_debugfs(void)
 
 int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 {
-	/*
-	 * Raw Spinlock because a normal spinlock would be traced here
-	 * and append an irrelevant couple spin_lock_irqsave/
-	 * spin_unlock_irqrestore traced by ftrace around this
-	 * TRACE_PRINTK trace.
-	 */
-	static raw_spinlock_t trace_buf_lock =
-				(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	static DEFINE_SPINLOCK(trace_buf_lock);
 	static char trace_buf[TRACE_BUF_SIZE];
 
 	struct ring_buffer_event *event;
@@ -3618,8 +3611,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	if (unlikely(atomic_read(&data->disabled)))
 		goto out;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&trace_buf_lock);
+	pause_graph_tracing();
+	spin_lock_irqsave(&trace_buf_lock, irq_flags);
 	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	len = min(len, TRACE_BUF_SIZE-1);
@@ -3640,9 +3633,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
  out_unlock:
-	__raw_spin_unlock(&trace_buf_lock);
-	local_irq_restore(flags);
-
+	spin_unlock_irqrestore(&trace_buf_lock, irq_flags);
+	unpause_graph_tracing();
  out:
 	preempt_enable_notrace();
 
-- 
1.5.6.3

