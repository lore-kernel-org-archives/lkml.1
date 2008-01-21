Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYAUP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYAUP0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbYAUPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:32 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:49238 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYAUPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:01 -0500
Message-Id: <20080121152353.916022518@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:50 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 19/23 -v4] trace generic call to schedule switch
Content-Disposition: inline; filename=trace-sched-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hooks into the schedule switch tracing to
allow other latency traces to hook into the schedule switches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/trace_sched_switch.c |  121 ++++++++++++++++++++++++++++++++++-----
 lib/tracing/tracer.h             |   14 ++++
 2 files changed, 120 insertions(+), 15 deletions(-)

Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-18 23:16:28.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-18 23:24:55.000000000 -0500
@@ -110,4 +110,18 @@ static inline notrace int page_order(con
 	return ilog2(roundup_pow_of_two(nr_pages));
 }
 
+#ifdef CONFIG_CONTEXT_SWITCH_TRACER
+typedef void (*tracer_switch_func_t)(struct tracing_trace *tr,
+				     struct task_struct *prev,
+				     struct task_struct *next);
+struct tracer_switch_ops {
+	tracer_switch_func_t func;
+	struct tracing_trace *tr;
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
--- linux-mcount.git.orig/lib/tracing/trace_sched_switch.c	2008-01-18 23:16:28.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_sched_switch.c	2008-01-18 23:25:11.000000000 -0500
@@ -19,6 +19,7 @@ static DEFINE_PER_CPU(struct tracing_tra
 
 static int trace_enabled __read_mostly;
 static unsigned long trace_nr_entries = (16384UL);
+static DEFINE_SPINLOCK(sched_switch_func_lock);
 
 static int __init set_nr_entries(char *str)
 {
@@ -29,22 +30,118 @@ static int __init set_nr_entries(char *s
 }
 __setup("trace_ctx_entries=", set_nr_entries);
 
+static void notrace sched_switch_func(struct tracing_trace *tr,
+				      struct task_struct *prev,
+				      struct task_struct *next)
+{
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	int cpu;
+
+	if (likely(!trace_enabled))
+		return;
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	atomic_inc(&data->disabled);
+
+	if (likely(atomic_read(&data->disabled) == 1))
+		tracing_sched_switch_trace(tr, data, prev, next, flags);
+
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
+static struct tracer_switch_ops sched_switch_ops __read_mostly =
+{
+	.func = sched_switch_func,
+	.tr   = &sched_switch_trace,
+};
+
+static tracer_switch_func_t tracer_switch_func __read_mostly =
+	sched_switch_func;
+
+static struct tracer_switch_ops *tracer_switch_func_ops __read_mostly =
+	&sched_switch_ops;
+
+static void notrace sched_switch_func_loop(struct tracing_trace *tr,
+					   struct task_struct *prev,
+					   struct task_struct *next)
+{
+	struct tracer_switch_ops *ops = tracer_switch_func_ops;
+
+	for (; ops != NULL; ops = ops->next)
+		ops->func(ops->tr, prev, next);
+}
+
+notrace int register_tracer_switch(struct tracer_switch_ops *ops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sched_switch_func_lock, flags);
+	ops->next = tracer_switch_func_ops;
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
 static notrace void sched_switch_callback(const struct marker *mdata,
 					  void *private_data,
 					  const char *format, ...)
 {
 	struct tracing_trace *tr = mdata->private;
-	struct tracing_trace_cpu *data;
 	struct task_struct *prev;
 	struct task_struct *next;
-	unsigned long flags;
 	va_list ap;
-	int cpu;
 
 	if (unlikely(atomic_read(&trace_record_cmdline)))
 		tracing_record_cmdline(current);
 
-	if (likely(!trace_enabled))
+	/* short circuit all this if nothing's enabled */
+	if (likely(tracer_switch_func == sched_switch_func &&
+		   !trace_enabled))
 		return;
 
 	va_start(ap, format);
@@ -52,17 +149,11 @@ static notrace void sched_switch_callbac
 	next = va_arg(ap, typeof(next));
 	va_end(ap);
 
-
-	raw_local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	atomic_inc(&data->disabled);
-
-	if (likely(atomic_read(&data->disabled) == 1))
-		tracing_sched_switch_trace(tr, data, prev, next, flags);
-
-	atomic_dec(&data->disabled);
-	raw_local_irq_restore(flags);
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, then it needs the tr passed to it.
+	 */
+	tracer_switch_func(tr, prev, next);
 }
 
 static notrace void sched_switch_reset(struct tracing_trace *tr)

-- 
