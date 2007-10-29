Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbXJ2ObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbXJ2ObR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXJ2OaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:30:21 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39834 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbXJ2O3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:29:46 -0400
Message-Id: <20071029142942.050901326@polymtl.ca>
References: <20071029142646.699058449@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 29 Oct 2007 10:26:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [patch 10/10] Move samples to instrumentation/samples
Content-Disposition: inline; filename=move-samples-to-instrumentation-samples.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 29 Oct 2007 14:29:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the markers samples to instrumentation/samples.

Was previously built late in the kernel build, but is now built at the same time
as instrumentation/ (core-y).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Randy Dunlap <rdunlap@xenotime.net>
---
 Makefile                                 |    3 
 instrumentation/Kconfig                  |    6 +
 instrumentation/Makefile                 |    2 
 instrumentation/samples/Makefile         |    4 +
 instrumentation/samples/marker-example.c |   54 +++++++++++++++++
 instrumentation/samples/probe-example.c  |   98 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug                        |    2 
 samples/Kconfig                          |   16 -----
 samples/Makefile                         |    3 
 samples/markers/Makefile                 |    4 -
 samples/markers/marker-example.c         |   54 -----------------
 samples/markers/probe-example.c          |   98 -------------------------------
 12 files changed, 164 insertions(+), 180 deletions(-)

Index: linux-2.6-lttng.stable/instrumentation/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/instrumentation/Kconfig	2007-10-29 10:01:09.000000000 -0400
+++ linux-2.6-lttng.stable/instrumentation/Kconfig	2007-10-29 10:03:18.000000000 -0400
@@ -59,4 +59,10 @@ config BLK_DEV_IO_TRACE
 
 	  git://brick.kernel.dk/data/git/blktrace.git
 
+config SAMPLE_MARKERS
+	tristate "Build markers examples -- loadable modules only"
+	depends on MARKERS && m
+	help
+	  This build markers example modules.
+
 endif # INSTRUMENTATION
Index: linux-2.6-lttng.stable/samples/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/samples/Kconfig	2007-10-29 10:01:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,16 +0,0 @@
-# samples/Kconfig
-
-menuconfig SAMPLES
-	bool "Sample kernel code"
-	help
-	  You can build and test sample kernel code here.
-
-if SAMPLES
-
-config SAMPLE_MARKERS
-	tristate "Build markers examples -- loadable modules only"
-	depends on MARKERS && m
-	help
-	  This build markers example modules.
-
-endif # SAMPLES
Index: linux-2.6-lttng.stable/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/instrumentation/Makefile	2007-10-29 10:03:14.000000000 -0400
+++ linux-2.6-lttng.stable/instrumentation/Makefile	2007-10-29 10:03:18.000000000 -0400
@@ -11,3 +11,5 @@ ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+
+obj-y += samples/
Index: linux-2.6-lttng.stable/instrumentation/samples/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/samples/Makefile	2007-10-29 10:17:36.000000000 -0400
@@ -0,0 +1,4 @@
+# builds the kprobes example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o
Index: linux-2.6-lttng.stable/samples/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/samples/Makefile	2007-10-29 10:01:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,3 +0,0 @@
-# Makefile for Linux samples code
-
-obj-$(CONFIG_SAMPLES)	+= markers/
Index: linux-2.6-lttng.stable/samples/markers/marker-example.c
===================================================================
--- linux-2.6-lttng.stable.orig/samples/markers/marker-example.c	2007-10-29 10:01:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,54 +0,0 @@
-/* marker-example.c
- *
- * Executes a marker when /proc/marker-example is opened.
- *
- * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
-#include <linux/module.h>
-#include <linux/marker.h>
-#include <linux/sched.h>
-#include <linux/proc_fs.h>
-
-struct proc_dir_entry *pentry_example;
-
-static int my_open(struct inode *inode, struct file *file)
-{
-	int i;
-
-	trace_mark(subsystem_event, "%d %s", 123, "example string");
-	for (i = 0; i < 10; i++)
-		trace_mark(subsystem_eventb, MARK_NOARGS);
-	return -EPERM;
-}
-
-static struct file_operations mark_ops = {
-	.open = my_open,
-};
-
-static int example_init(void)
-{
-	printk(KERN_ALERT "example init\n");
-	pentry_example = create_proc_entry("marker-example", 0444, NULL);
-	if (pentry_example)
-		pentry_example->proc_fops = &mark_ops;
-	else
-		return -EPERM;
-	return 0;
-}
-
-static void example_exit(void)
-{
-	printk(KERN_ALERT "example exit\n");
-	remove_proc_entry("marker-example", NULL);
-}
-
-module_init(example_init)
-module_exit(example_exit)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Marker example");
Index: linux-2.6-lttng.stable/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.stable.orig/samples/markers/probe-example.c	2007-10-29 10:01:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,98 +0,0 @@
-/* probe-example.c
- *
- * Connects two functions to marker call sites.
- *
- * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/marker.h>
-#include <asm/atomic.h>
-
-struct probe_data {
-	const char *name;
-	const char *format;
-	marker_probe_func *probe_func;
-};
-
-void probe_subsystem_event(const struct marker *mdata, void *private,
-	const char *format, ...)
-{
-	va_list ap;
-	/* Declare args */
-	unsigned int value;
-	const char *mystr;
-
-	/* Assign args */
-	va_start(ap, format);
-	value = va_arg(ap, typeof(value));
-	mystr = va_arg(ap, typeof(mystr));
-
-	/* Call printk */
-	printk(KERN_DEBUG "Value %u, string %s\n", value, mystr);
-
-	/* or count, check rights, serialize data in a buffer */
-
-	va_end(ap);
-}
-
-atomic_t eventb_count = ATOMIC_INIT(0);
-
-void probe_subsystem_eventb(const struct marker *mdata, void *private,
-	const char *format, ...)
-{
-	/* Increment counter */
-	atomic_inc(&eventb_count);
-}
-
-static struct probe_data probe_array[] =
-{
-	{	.name = "subsystem_event",
-		.format = "%d %s",
-		.probe_func = probe_subsystem_event },
-	{	.name = "subsystem_eventb",
-		.format = MARK_NOARGS,
-		.probe_func = probe_subsystem_eventb },
-};
-
-static int __init probe_init(void)
-{
-	int result;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		result = marker_probe_register(probe_array[i].name,
-				probe_array[i].format,
-				probe_array[i].probe_func, &probe_array[i]);
-		if (result)
-			printk(KERN_INFO "Unable to register probe %s\n",
-				probe_array[i].name);
-		result = marker_arm(probe_array[i].name);
-		if (result)
-			printk(KERN_INFO "Unable to arm probe %s\n",
-				probe_array[i].name);
-	}
-	return 0;
-}
-
-static void __exit probe_fini(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
-		marker_probe_unregister(probe_array[i].name);
-	printk(KERN_INFO "Number of event b : %u\n",
-			atomic_read(&eventb_count));
-}
-
-module_init(probe_init);
-module_exit(probe_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("SUBSYSTEM Probe");
Index: linux-2.6-lttng.stable/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.stable.orig/lib/Kconfig.debug	2007-10-29 10:03:13.000000000 -0400
+++ linux-2.6-lttng.stable/lib/Kconfig.debug	2007-10-29 10:03:18.000000000 -0400
@@ -508,5 +508,3 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	select FRAME_POINTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
-
-source "samples/Kconfig"
Index: linux-2.6-lttng.stable/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/Makefile	2007-10-29 10:01:09.000000000 -0400
+++ linux-2.6-lttng.stable/Makefile	2007-10-29 10:03:18.000000000 -0400
@@ -775,9 +775,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
Index: linux-2.6-lttng.stable/samples/markers/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/samples/markers/Makefile	2007-10-29 10:01:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,4 +0,0 @@
-# builds the kprobes example kernel modules;
-# then to use one (as root):  insmod <module_name.ko>
-
-obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o
Index: linux-2.6-lttng.stable/instrumentation/samples/marker-example.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/samples/marker-example.c	2007-10-29 10:03:18.000000000 -0400
@@ -0,0 +1,54 @@
+/* marker-example.c
+ *
+ * Executes a marker when /proc/marker-example is opened.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/sched.h>
+#include <linux/proc_fs.h>
+
+struct proc_dir_entry *pentry_example;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	for (i = 0; i < 10; i++)
+		trace_mark(subsystem_eventb, MARK_NOARGS);
+	return -EPERM;
+}
+
+static struct file_operations mark_ops = {
+	.open = my_open,
+};
+
+static int example_init(void)
+{
+	printk(KERN_ALERT "example init\n");
+	pentry_example = create_proc_entry("marker-example", 0444, NULL);
+	if (pentry_example)
+		pentry_example->proc_fops = &mark_ops;
+	else
+		return -EPERM;
+	return 0;
+}
+
+static void example_exit(void)
+{
+	printk(KERN_ALERT "example exit\n");
+	remove_proc_entry("marker-example", NULL);
+}
+
+module_init(example_init)
+module_exit(example_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Marker example");
Index: linux-2.6-lttng.stable/instrumentation/samples/probe-example.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/samples/probe-example.c	2007-10-29 10:03:18.000000000 -0400
@@ -0,0 +1,98 @@
+/* probe-example.c
+ *
+ * Connects two functions to marker call sites.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <asm/atomic.h>
+
+struct probe_data {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+void probe_subsystem_event(const struct marker *mdata, void *private,
+	const char *format, ...)
+{
+	va_list ap;
+	/* Declare args */
+	unsigned int value;
+	const char *mystr;
+
+	/* Assign args */
+	va_start(ap, format);
+	value = va_arg(ap, typeof(value));
+	mystr = va_arg(ap, typeof(mystr));
+
+	/* Call printk */
+	printk(KERN_DEBUG "Value %u, string %s\n", value, mystr);
+
+	/* or count, check rights, serialize data in a buffer */
+
+	va_end(ap);
+}
+
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct marker *mdata, void *private,
+	const char *format, ...)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+static struct probe_data probe_array[] =
+{
+	{	.name = "subsystem_event",
+		.format = "%d %s",
+		.probe_func = probe_subsystem_event },
+	{	.name = "subsystem_eventb",
+		.format = MARK_NOARGS,
+		.probe_func = probe_subsystem_eventb },
+};
+
+static int __init probe_init(void)
+{
+	int result;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		result = marker_probe_register(probe_array[i].name,
+				probe_array[i].format,
+				probe_array[i].probe_func, &probe_array[i]);
+		if (result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[i].name);
+		result = marker_arm(probe_array[i].name);
+		if (result)
+			printk(KERN_INFO "Unable to arm probe %s\n",
+				probe_array[i].name);
+	}
+	return 0;
+}
+
+static void __exit probe_fini(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
+		marker_probe_unregister(probe_array[i].name);
+	printk(KERN_INFO "Number of event b : %u\n",
+			atomic_read(&eventb_count));
+}
+
+module_init(probe_init);
+module_exit(probe_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("SUBSYSTEM Probe");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
