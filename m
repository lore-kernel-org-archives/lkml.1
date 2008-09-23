Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbYIWJ0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbYIWJ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYIWJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:26:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYIWJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=j0Zs384e90AEIkdgQ/GMmaojAZBTGn1iokmJRxQRqNlM1zsUPq02o1FcfkMCg4h5XU
         cLp1MnLMs9ppEbx+E6ihX+sijjauc0Tnmrv1DxiepqSbO+hdf1CmrzO+0/ps0OR+kHP8
         qdHD/omLAcGKgugk+4lm3arqbRCCpkkslHpW4=
Message-ID: <48D8C5A8.3080803@gmail.com>
Date: Tue, 23 Sep 2008 11:32:08 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [Patch -tip 1/4] Tracing/ftrace: Add the initcall tracer
Content-Type: multipart/mixed;
 boundary="------------000603050509020707070209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000603050509020707070209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Add the initcall tracer. It will be able to trace the initcalls which follow SMP initialization.
It is intended to be used with scripts/bootgraph.pl after some small improvements.
Note that it is not active after its init. To avoid tracing (and so crashing) before the whole tracing engine init,
you have to explicitly call start_initcall_trace() after do_pre_smp_initcalls() to enable it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------000603050509020707070209
Content-Type: text/plain;
 name="patch1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch1.diff"

diff --git a/dev/null b/kernel/trace/trace_initcall.c
new file mode 100644
index 0000000..139bb9b
--- /dev/null
+++ b/kernel/trace/trace_initcall.c
@@ -0,0 +1,101 @@
+/*
+ * ring buffer based initcalls tracer
+ *
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+
+#include "trace.h"
+
+static struct trace_array *initcall_trace;
+static int trace_initcall_enabled;
+
+
+/* Should be started after do_pre_smp_initcalls() in init/main.c */
+void start_initcall_trace(void)
+{
+	trace_initcall_enabled = 1;
+}
+
+void stop_initcall_trace(struct trace_array *tr)
+{
+	trace_initcall_enabled = 0;
+}
+
+static void initcall_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	initcall_trace = tr;
+
+	trace_initcall_enabled = 0;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr->data[cpu]);
+}
+
+static void initcall_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_initcall_trace();
+	else
+		stop_initcall_trace(tr);
+}
+
+static int initcall_print_line(struct trace_iterator *iter)
+{
+	int ret = 1;
+	struct trace_entry *entry = iter->ent;
+	struct initcall_trace *it = &entry->field.initcall;
+	struct trace_seq *s = &iter->seq;
+
+	if (iter->ent->type == TRACE_INITCALL)
+		ret = trace_seq_printf(s, "%pF called from %i "
+				       "returned %d after %Ld msecs\n",
+				       it->func, it->caller, it->result,
+				       it->duration);
+	if (ret)
+		return 1;
+	return 0;
+}
+
+struct tracer initcall_tracer __read_mostly =
+{
+	.name		= "initcall",
+	.init		= initcall_trace_init,
+	.reset		= stop_initcall_trace,
+	.ctrl_update	= initcall_trace_ctrl_update,
+	.print_line	= initcall_print_line,
+};
+
+
+void trace_initcall(struct initcall_trace *it)
+{
+	struct trace_entry *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = initcall_trace;
+
+	if (!trace_initcall_enabled)
+		return;
+
+	preempt_disable();
+	data = tr->data[smp_processor_id()];
+
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&data->lock);
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type = TRACE_INITCALL;
+	entry->field.initcall = *it;
+
+	__raw_spin_unlock(&data->lock);
+	raw_local_irq_restore(irq_flags);
+	trace_wake_up();
+
+	preempt_enable();
+}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cb2c3fb..597c5e8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/mmiotrace.h>
+#include <linux/ftrace.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -19,6 +20,7 @@ enum trace_type {
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
+	TRACE_INITCALL,
 
 	__TRACE_LAST_TYPE
 };
@@ -108,6 +110,7 @@ struct trace_field {
 		struct print_entry		print;
 		struct mmiotrace_rw		mmiorw;
 		struct mmiotrace_map		mmiomap;
+		struct initcall_trace		initcall;
 	};
 };
 
@@ -370,5 +373,6 @@ enum trace_iterator_flags {
 };
 
 extern struct tracer nop_trace;
+extern struct tracer initcall_tracer;
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 5de9903..b96b342 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -5,6 +5,8 @@
 
 #include <linux/linkage.h>
 #include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/types.h>
 
 extern int ftrace_enabled;
 extern int
@@ -209,4 +211,21 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 
+struct initcall_trace {
+	pid_t			caller;
+	initcall_t		func;
+	int			result;
+	unsigned long long 	duration;
+};
+
+#ifdef CONFIG_INITCALL_TRACER
+extern void trace_initcall(struct initcall_trace *it);
+extern void start_initcall_trace(void);
+#else
+static inline void trace_initcall(struct initcall_trace *it) { }
+static inline void start_initcall_trace(void) { }
+#endif
+
+
+
 #endif /* _LINUX_FTRACE_H */

--------------000603050509020707070209--
