Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYJJKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYJJKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJJKnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:43:23 -0400
Received: from perso1.free.fr ([212.27.63.203]:56666 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYJJKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:43:22 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 06:43:21 EDT
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during initcalls
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 12:36:15
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081010103615.EFB18D1BB8F@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We used to disable the initcall tracing at a specified time (IE: end of builtin initcalls). But we don\'t need it anymore. It will be stopped when initcalls are 
finished.
However we want two things: 

_Start this tracing only after pre-smp initcalls are finished.
_Since we are planning to trace sched_switches at the same time, we want to 
enable them only during the initcall execution. For this purpose, this patch 
introduce two functions to enable/disable the sched_switch tracing during boot.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h    |   24 ++++++++++++++++++++++--
 init/main.c               |    4 +++-
 kernel/trace/trace_boot.c |   28 ++++++++++++++++------------
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 5812dba..135a33f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -213,6 +213,11 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 
+/*
+ * Structure which defines the trace of an initcall.
+ * You don\'t have to fill the func field since it is
+ * only used internally by the tracer.
+ */
 struct boot_trace {
 	pid_t			caller;
 	char 			func[KSYM_NAME_LEN];
@@ -223,13 +228,28 @@ struct boot_trace {
 };
 
 #ifdef CONFIG_BOOT_TRACER
+/* Append the trace on the ring-buffer */
 extern void trace_boot(struct boot_trace *it, initcall_t fn);
+
+/* Tells the tracer that smp_pre_initcall is finished.
+ * So we can start the tracing
+ */
 extern void start_boot_trace(void);
-extern void stop_boot_trace(void);
+
+/* Resume the tracing of other necessary events
+ * such as sched switches
+ */
+extern void enable_boot_trace(void);
+
+/* Suspend this tracing. Actually, only sched_switches tracing have
+ * to be suspended. Initcalls doesn\'t need it.)
+ */
+extern void disable_boot_trace(void);
 #else
 static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
 static inline void start_boot_trace(void) { }
-static inline void stop_boot_trace(void) { }
+static inline void enable_boot_trace(void) { }
+static inline void disable_boot_trace(void) { }
 #endif
 
 
diff --git a/init/main.c b/init/main.c
index 6371981..98c05aa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -729,6 +729,7 @@ int do_one_initcall(initcall_t fn)
 		it.caller = task_pid_nr(current);
 		printk(\"calling  %pF @ %i\\n\", fn, it.caller);
 		it.calltime = ktime_get();
+		enable_boot_trace();
 	}
 
 	it.result = fn();
@@ -740,6 +741,7 @@ int do_one_initcall(initcall_t fn)
 		printk(\"initcall %pF returned %d after %Ld msecs\\n\", fn,
 			it.result, it.duration);
 		trace_boot(&it, fn);
+		disable_boot_trace();
 	}
 
 	msgbuf[0] = 0;
@@ -975,7 +977,7 @@ static int __init kernel_init(void * unused)
 	 * we\'re essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
-	stop_boot_trace();
+
 	init_post();
 	return 0;
 }
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d0a5e50..d104d5b 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -13,23 +13,29 @@
 #include \"trace.h\"
 
 static struct trace_array *boot_trace;
-static int trace_boot_enabled;
+static bool pre_initcalls_finished;
 
-
-/* Should be started after do_pre_smp_initcalls() in init/main.c */
+/* Tells the boot tracer that the pre_smp_initcalls are finished.
+ * So we are ready .
+ * It doesn\'t enable sched events tracing however.
+ * You have to call enable_boot_trace to do so.
+ */
 void start_boot_trace(void)
 {
-	trace_boot_enabled = 1;
+	pre_initcalls_finished = true;
+}
+
+void enable_boot_trace(void)
+{
 }
 
-void stop_boot_trace(void)
+void disable_boot_trace(void)
 {
-	trace_boot_enabled = 0;
 }
 
 void reset_boot_trace(struct trace_array *tr)
 {
-	stop_boot_trace();
+	disable_boot_trace();
 }
 
 static void boot_trace_init(struct trace_array *tr)
@@ -37,8 +43,6 @@ static void boot_trace_init(struct trace_array *tr)
 	int cpu;
 	boot_trace = tr;
 
-	trace_boot_enabled = 0;
-
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
 }
@@ -46,9 +50,9 @@ static void boot_trace_init(struct trace_array *tr)
 static void boot_trace_ctrl_update(struct trace_array *tr)
 {
 	if (tr->ctrl)
-		start_boot_trace();
+		enable_boot_trace();
 	else
-		stop_boot_trace();
+		disable_boot_trace();
 }
 
 static enum print_line_t initcall_print_line(struct trace_iterator *iter)
@@ -99,7 +103,7 @@ void trace_boot(struct boot_trace *it, initcall_t fn)
 	unsigned long irq_flags;
 	struct trace_array *tr = boot_trace;
 
-	if (!trace_boot_enabled)
+	if (!pre_initcalls_finished)
 		return;
 
 	/* Get its name now since this function could

