Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYA3VLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYA3VLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbYA3VF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:57 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39663 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYA3VFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:38 -0500
Message-Id: <20080130210527.338001311@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 16/23 -v8] trace generic call to schedule switch
Content-Disposition: inline; filename=trace-sched-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hooks into the schedule switch tracing to
allow other latency traces to hook into the schedule switches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/trace_sched_switch.c |  135 +++++++++++++++++++++++++++++++++------
 lib/tracing/tracer.h             |   14 ++++
 2 files changed, 131 insertions(+), 18 deletions(-)

Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-30 15:33:38.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-30 15:34:21.000000000 -0500
@@ -113,4 +113,18 @@ static inline notrace cycle_t now(void)
 	return get_monotonic_cycles();
 }
 
+#ifdef CONFIG_CONTEXT_SWITCH_TRACER
+typedef void (*tracer_switch_func_t)(void *private,
+				     struct task_struct *prev,
+				     struct task_struct *next);
+struct tracer_switch_ops {
+	tracer_switch_func_t func;
+	void *private;
+	struct tracer_switch_ops *next;
+};
+
+extern int register_tracer_switch(struct tracer_switch_ops *ops);
+extern int unregister_tracer_switch(struct tracer_switch_ops *ops);
+#endif /* CONFIG_CONTEXT_SWITCH_TRACER */
+
 #endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-mcount.git/lib/tracing/trace_sched_switch.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_sched_switch.c	2008-01-30 15:33:38.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_sched_switch.c	2008-01-30 15:34:21.000000000 -0500
@@ -18,34 +18,22 @@ static struct tracing_trace *tracer_trac
 static int trace_enabled __read_mostly;
 static atomic_t sched_ref;
 int tracing_sched_switch_enabled __read_mostly;
+static DEFINE_SPINLOCK(sched_switch_func_lock);
 
-static notrace void sched_switch_callback(const struct marker *mdata,
-					  void *private_data,
-					  const char *format, ...)
+static void notrace sched_switch_func(void *private,
+				      struct task_struct *prev,
+				      struct task_struct *next)
 {
-	struct tracing_trace **p = mdata->private;
-	struct tracing_trace *tr = *p;
+	struct tracing_trace **ptr = private;
+	struct tracing_trace *tr = *ptr;
 	struct tracing_trace_cpu *data;
-	struct task_struct *prev;
-	struct task_struct *next;
 	unsigned long flags;
 	long disabled;
-	va_list ap;
 	int cpu;
 
-	if (!atomic_read(&sched_ref))
-		return;
-
-	tracing_record_cmdline(current);
-
 	if (!trace_enabled)
 		return;
 
-	va_start(ap, format);
-	prev = va_arg(ap, typeof(prev));
-	next = va_arg(ap, typeof(next));
-	va_end(ap);
-
 	raw_local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
@@ -58,6 +46,117 @@ static notrace void sched_switch_callbac
 	raw_local_irq_restore(flags);
 }
 
+static struct tracer_switch_ops sched_switch_ops __read_mostly =
+{
+	.func = sched_switch_func,
+	.private = &tracer_trace,
+};
+
+static tracer_switch_func_t tracer_switch_func __read_mostly =
+	sched_switch_func;
+
+static struct tracer_switch_ops *tracer_switch_func_ops __read_mostly =
+	&sched_switch_ops;
+
+static void notrace sched_switch_func_loop(void *private,
+					   struct task_struct *prev,
+					   struct task_struct *next)
+{
+	struct tracer_switch_ops *ops = tracer_switch_func_ops;
+
+	/* take care of alpha acting funny */
+	read_barrier_depends();
+
+	for (; ops != NULL; ops = ops->next) {
+		/* silly alpha */
+		read_barrier_depends();
+		ops->func(ops->private, prev, next);
+	}
+}
+
+notrace int register_tracer_switch(struct tracer_switch_ops *ops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sched_switch_func_lock, flags);
+	ops->next = tracer_switch_func_ops;
+	/*
+	 * We are entering ops into the switch list but another
+	 * CPU might be walking that list. We need to make sure
+	 * the ops->next pointer is valid before another CPU sees
+	 * the ops pointer included into the switch list.
+	 */
+	smp_wmb();
+	tracer_switch_func_ops = ops;
+
+	if (ops->next == &sched_switch_ops)
+		tracer_switch_func = sched_switch_func_loop;
+
+	spin_unlock_irqrestore(&sched_switch_func_lock, flags);
+
+	return 0;
+}
+
+notrace int unregister_tracer_switch(struct tracer_switch_ops *ops)
+{
+	unsigned long flags;
+	struct tracer_switch_ops **p = &tracer_switch_func_ops;
+	int ret;
+
+	spin_lock_irqsave(&sched_switch_func_lock, flags);
+
+	/*
+	 * If the sched_switch is the only one left, then
+	 *  only call that function.
+	 */
+	if (*p == ops && ops->next == &sched_switch_ops) {
+		tracer_switch_func = sched_switch_func;
+		tracer_switch_func_ops = &sched_switch_ops;
+		goto out;
+	}
+
+	for (; *p != &sched_switch_ops; p = &(*p)->next)
+		if (*p == ops)
+			break;
+
+	if (*p != ops) {
+		ret = -1;
+		goto out;
+	}
+
+	*p = (*p)->next;
+
+ out:
+	spin_unlock_irqrestore(&sched_switch_func_lock, flags);
+
+	return 0;
+}
+
+static notrace void sched_switch_callback(const struct marker *mdata,
+					  void *private_data,
+					  const char *format, ...)
+{
+	struct task_struct *prev;
+	struct task_struct *next;
+	va_list ap;
+
+	if (!atomic_read(&sched_ref))
+		return;
+
+	tracing_record_cmdline(current);
+
+	va_start(ap, format);
+	prev = va_arg(ap, typeof(prev));
+	next = va_arg(ap, typeof(next));
+	va_end(ap);
+
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, it still needs the ptr passed to it.
+	 */
+	tracer_switch_func(mdata->private, prev, next);
+}
+
 static notrace void sched_switch_reset(struct tracing_trace *tr)
 {
 	int cpu;

-- 
