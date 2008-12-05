Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYLETkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYLETkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYLETkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:40:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51033 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYLETkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:40:21 -0500
Date: Fri, 5 Dec 2008 14:39:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: [rfc] [patch] hook tracer to dynamic debug
Message-ID: <20081205193928.GA3134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Currently, the dynamic debug framework uses 'printk' for output. Here,
i've hooked the backend of the dynamic debug framework to the tracing 
framework. This allows the dynamic debug output to be seaprated from the
system log, and allows for higher performance. I've implemented it as a
compile time option, but a user might want to be able to toggle b/w
'printk' and the tracer at run-time...other ideas? Patch is against the -tip 
tree...

thanks,

-Jason


diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
index 2d528d0..9d9a38b 100644
--- a/include/linux/dynamic_printk.h
+++ b/include/linux/dynamic_printk.h
@@ -31,6 +31,15 @@ struct mod_debug {
 int register_dynamic_debug_module(char *mod_name, int type, char *share_name,
 					char *flags, int hash, int hash2);
 
+
+#ifdef CONFIG_DYNAMIC_DEBUG_TRACER
+#define dynamic_printk dynamic_debug_trace_printk
+extern void dynamic_debug_trace_printk(const char *fmt, ...);
+#else
+#define dynamic_printk printk
+#endif
+
+
 #if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 extern int unregister_dynamic_debug_module(char *mod_name);
 extern int __dynamic_dbg_enabled_helper(char *modname, int type,
@@ -54,7 +63,7 @@ extern int __dynamic_dbg_enabled_helper(char *modname, int type,
 	{ mod_name, mod_name, NULL, TYPE_BOOLEAN, DEBUG_HASH, DEBUG_HASH2 };\
 	if (__dynamic_dbg_enabled(KBUILD_MODNAME, TYPE_BOOLEAN,		    \
 						0, 0, DEBUG_HASH))	    \
-		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		    \
+		dynamic_printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,	    \
 				##__VA_ARGS__);				    \
 	} while (0)
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index bde6f03..e810912 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -149,6 +149,13 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
+config DYNAMIC_DEBUG_TRACER
+	bool "Trace dynamic debug"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer records all dynamic debug output.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	depends on DEBUG_KERNEL
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 62dc561..b84337e 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -33,5 +33,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_BTS_TRACER) += trace_bts.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
+obj-$(CONFIG_DYNAMIC_DEBUG_TRACER) += trace_dynamic_debug.o
+
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_dynamic_debug.c b/kernel/trace/trace_dynamic_debug.c
new file mode 100644
index 0000000..43eaf8a
--- /dev/null
+++ b/kernel/trace/trace_dynamic_debug.c
@@ -0,0 +1,142 @@
+/*
+ * dynamic_debug tracer
+ *
+ * Copyright (C) 2008 Jason Baron <jbaron@redhat.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/marker.h>
+#include <trace/sched.h>
+
+#include "trace.h"
+
+static struct trace_array	*ctx_trace;
+static int __read_mostly	debug_enabled;
+static int			debug_ref;
+static DEFINE_MUTEX(debug_register_mutex);
+
+void dynamic_debug_trace_printk(const char *fmt, ...)
+{
+	va_list args;
+
+	if (!debug_enabled)
+		return;
+
+	va_start(args, fmt);
+	trace_vprintk(0, -1, fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(dynamic_debug_trace_printk);
+
+static void dynamic_debug_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static void tracing_start_dynamic_debug(void)
+{
+	mutex_lock(&debug_register_mutex);
+	debug_ref++;
+	mutex_unlock(&debug_register_mutex);
+}
+
+static void tracing_stop_dynamic_debug(void)
+{
+	mutex_lock(&debug_register_mutex);
+	debug_ref--;
+	mutex_unlock(&debug_register_mutex);
+}
+
+/**
+ * tracing_start_sched_switch_record - start tracing context switches
+ *
+ * Turns on context switch tracing for a tracer.
+ */
+void tracing_start_dynamic_debug_record(void)
+{
+	if (unlikely(!ctx_trace)) {
+		WARN_ON(1);
+		return;
+	}
+
+	tracing_start_dynamic_debug();
+
+	mutex_lock(&debug_register_mutex);
+	debug_enabled++;
+	mutex_unlock(&debug_register_mutex);
+}
+
+/**
+ * tracing_stop_sched_switch_record - start tracing context switches
+ *
+ * Turns off context switch tracing for a tracer.
+ */
+void tracing_stop_dynamic_debug_record(void)
+{
+	mutex_lock(&debug_register_mutex);
+	debug_enabled--;
+	WARN_ON(debug_enabled < 0);
+	mutex_unlock(&debug_register_mutex);
+
+	tracing_stop_dynamic_debug();
+}
+
+static void start_dynamic_debug_trace(struct trace_array *tr)
+{
+	dynamic_debug_reset(tr);
+	tracing_start_dynamic_debug_record();
+}
+
+static void stop_dynamic_debug_trace(struct trace_array *tr)
+{
+	tracing_stop_dynamic_debug_record();
+}
+
+static int dynamic_debug_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+	start_dynamic_debug_trace(tr);
+	return 0;
+}
+
+static void dynamic_debug_trace_reset(struct trace_array *tr)
+{
+	if (debug_ref)
+		stop_dynamic_debug_trace(tr);
+}
+
+static void dynamic_debug_trace_start(struct trace_array *tr)
+{
+	dynamic_debug_reset(tr);
+	tracing_start_dynamic_debug();
+}
+
+static void dynamic_debug_trace_stop(struct trace_array *tr)
+{
+	tracing_stop_dynamic_debug();
+}
+
+static struct tracer dynamic_debug_trace __read_mostly =
+{
+	.name		= "dynamic_debug",
+	.init		= dynamic_debug_trace_init,
+	.reset		= dynamic_debug_trace_reset,
+	.start		= dynamic_debug_trace_start,
+	.stop		= dynamic_debug_trace_stop,
+};
+
+__init static int init_dynamic_debug_trace(void)
+{
+	return register_tracer(&dynamic_debug_trace);
+}
+device_initcall(init_dynamic_debug_trace);
