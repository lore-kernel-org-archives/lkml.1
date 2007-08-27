Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXH0QR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXH0QR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbXH0QHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:07:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45618 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759973AbXH0QHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:07:16 -0400
Message-Id: <20070827160710.501642576@polymtl.ca>
References: <20070827160540.007809201@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 12:05:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/4] Linux Kernel Markers - Documentation
Content-Disposition: inline; filename=linux-kernel-markers-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:07:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: "Frank Ch. Eigler" <fche@redhat.com>
---

 Documentation/marker.txt |  257 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)

Index: linux-2.6-lttng/Documentation/marker.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/marker.txt	2007-08-17 11:56:20.000000000 -0400
@@ -0,0 +1,257 @@
+ 	             Using the Linux Kernel Markers
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Markers and their use. It provides
+examples of how to insert markers in the kernel and connect probe functions to
+them and provides some examples of probe functions.
+
+
+* Purpose of markers
+
+A marker placed in your code provides a hook to call a function (probe) that
+you can provide at runtime. A marker can be "on" (a probe is connected to it) or
+"off" (no probe is attached). When a marker is "off" it has no effect, except
+for adding a tiny time penality (checking a condition for a branch) and space
+penality (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section). The
+immediate values are used to minimize the impact on data cache, encoding the
+condition in the instruction stream. When a marker is "on", the function you
+provide is called each time the marker is executed, in the execution context of
+the caller. When the function provided ends its execution, it returns to the
+caller (continuing from the marker site).
+
+You can put markers at important locations in the code. Markers are
+lightweight hooks that can pass an arbitrary number of parameters,
+described in a printk-like format string, to the attached probe function.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+In order to use the macro trace_mark, you should include linux/marker.h.
+
+#include <linux/marker.h>
+
+Add, in your code :
+
+trace_mark(subsystem_event, "%d %s", someint, somestring);
+Where :
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
+- "%d %s" is the formatted string for the serializer.
+- someint is an integer.
+- somestring is a char pointer.
+
+Connecting a function (probe) to a marker is done by providing a probe (function
+to call) for the specific marker through marker_probe_register() and can be
+activated by calling marker_arm(). Marker deactivation can be done by calling
+marker_disarm() as many times as marker_arm() has been called. Removing a probe
+is done through marker_probe_unregister(); it will disarm the probe and make
+sure there is no caller left using the probe when it returns. Probe removal is
+preempt-safe because preemption is disabled around the probe call. See the
+"Probe example" section below for a sample probe module.
+
+The marker mechanism supports inserting multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions, and
+unrolled loops.
+
+The naming scheme "subsystem_event" is suggested here as a convention intended
+to limit collisions. Marker names are global to the kernel: they are considered
+as being the same whether they are in the core kernel image or in modules.
+Conflicting format strings for markers with the same name will cause the markers
+to be detected to have a different format string not to be armed and will output
+a printk warning which identifies the inconsistency:
+
+"Format mismatch for probe probe_name (format), marker (format)"
+
+
+* Optimization for a given architecture
+
+One can implement optimized markers for a given architecture by replacing
+asm-$ARCH/marker.h.
+
+To force use of a non-optimized version of the markers, _trace_mark() should be
+used. It takes the same parameters as the normal markers, but it does not use
+the immediate values based on code patching.
+
+
+* Probe example
+
+You can build the kernel modules, probe-example.ko and marker-example.ko,
+using the following Makefile:
+------------------------------ CUT -------------------------------------
+obj-m := probe-example.o marker-example.o
+KDIR := /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+default:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+clean:
+	rm -f *.mod.c *.ko *.o
+------------------------------ CUT -------------------------------------
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
+void probe_subsystem_event(const struct __mark_marker *mdata,
+		const char *format, ...)
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
+	printk("Value %u, string %s\n", value, mystr);
+
+	/* or count, check rights, serialize data in a buffer */
+
+	va_end(ap);
+}
+
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct __mark_marker *mdata,
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
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		marker_probe_unregister(probe_array[i].name);
+	}
+	printk("Number of event b : %u\n", atomic_read(&eventb_count));
+}
+
+module_init(probe_init);
+module_exit(probe_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("SUBSYSTEM Probe");
+------------------------------ CUT -------------------------------------
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
+struct proc_dir_entry *pentry_example = NULL;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	for (i=0; i<10; i++) {
+		trace_mark(subsystem_eventb, MARK_NOARGS);
+	}
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
+MODULE_DESCRIPTION("Linux Trace Toolkit example");
+------------------------------ CUT -------------------------------------
+Sequence of operations : (as root)
+make
+insmod marker-example.ko (insmod order is not important)
+insmod probe-example.ko
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg
+------------------------------ CUT -------------------------------------

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
