Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXJXJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXJXJwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJXJw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:52:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48361 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbXJXJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:52:27 -0400
Date: Wed, 24 Oct 2007 05:52:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC/git patch] move samples/ to Documentation/markers/
Message-ID: <20071024095226.GA30326@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


IMO, adding a toplevel samples/ just for two example sources was a bit
unnecessary, and not how we normally treat examples.  Usually examples
are stored in Documentation/ such as
Documentation/filesystems/configfs/configfs_example.c or less
frequently, they are inlined in an existing subdir like
drivers/usb/usb-skeleton.c or drivers/net/pci-skeleton.c.

Please most humbly :) consider pulling from 'samples' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git samples

to receive the following updates:

 .../markers/marker-example.c                       |    0 
 Documentation/{ => markers}/markers.txt            |    2 +-
 {samples => Documentation}/markers/probe-example.c |    0 
 Makefile                                           |    3 ---
 lib/Kconfig.debug                                  |    1 -
 samples/Kconfig                                    |   16 ----------------
 samples/Makefile                                   |    3 ---
 samples/markers/Makefile                           |    4 ----
 8 files changed, 1 insertions(+), 28 deletions(-)
 rename {samples => Documentation}/markers/marker-example.c (100%)
 rename Documentation/{ => markers}/markers.txt (98%)
 rename {samples => Documentation}/markers/probe-example.c (100%)
 delete mode 100644 samples/Kconfig
 delete mode 100644 samples/Makefile
 delete mode 100644 samples/markers/Makefile

Jeff Garzik (1):
      Move markers samples and docs to Documentation/markers/

diff --git a/Documentation/markers.txt b/Documentation/markers.txt
deleted file mode 100644
index 295a71b..0000000
--- a/Documentation/markers.txt
+++ /dev/null
@@ -1,81 +0,0 @@
- 	             Using the Linux Kernel Markers
-
-			    Mathieu Desnoyers
-
-
-This document introduces Linux Kernel Markers and their use. It provides
-examples of how to insert markers in the kernel and connect probe functions to
-them and provides some examples of probe functions.
-
-
-* Purpose of markers
-
-A marker placed in code provides a hook to call a function (probe) that you can
-provide at runtime. A marker can be "on" (a probe is connected to it) or "off"
-(no probe is attached). When a marker is "off" it has no effect, except for
-adding a tiny time penalty (checking a condition for a branch) and space
-penalty (adding a few bytes for the function call at the end of the
-instrumented function and adds a data structure in a separate section).  When a
-marker is "on", the function you provide is called each time the marker is
-executed, in the execution context of the caller. When the function provided
-ends its execution, it returns to the caller (continuing from the marker site).
-
-You can put markers at important locations in the code. Markers are
-lightweight hooks that can pass an arbitrary number of parameters,
-described in a printk-like format string, to the attached probe function.
-
-They can be used for tracing and performance accounting.
-
-
-* Usage
-
-In order to use the macro trace_mark, you should include linux/marker.h.
-
-#include <linux/marker.h>
-
-And,
-
-trace_mark(subsystem_event, "%d %s", someint, somestring);
-Where :
-- subsystem_event is an identifier unique to your event
-    - subsystem is the name of your subsystem.
-    - event is the name of the event to mark.
-- "%d %s" is the formatted string for the serializer.
-- someint is an integer.
-- somestring is a char pointer.
-
-Connecting a function (probe) to a marker is done by providing a probe (function
-to call) for the specific marker through marker_probe_register() and can be
-activated by calling marker_arm(). Marker deactivation can be done by calling
-marker_disarm() as many times as marker_arm() has been called. Removing a probe
-is done through marker_probe_unregister(); it will disarm the probe and make
-sure there is no caller left using the probe when it returns. Probe removal is
-preempt-safe because preemption is disabled around the probe call. See the
-"Probe example" section below for a sample probe module.
-
-The marker mechanism supports inserting multiple instances of the same marker.
-Markers can be put in inline functions, inlined static functions, and
-unrolled loops as well as regular functions.
-
-The naming scheme "subsystem_event" is suggested here as a convention intended
-to limit collisions. Marker names are global to the kernel: they are considered
-as being the same whether they are in the core kernel image or in modules.
-Conflicting format strings for markers with the same name will cause the markers
-to be detected to have a different format string not to be armed and will output
-a printk warning which identifies the inconsistency:
-
-"Format mismatch for probe probe_name (format), marker (format)"
-
-
-* Probe / marker example
-
-See the example provided in samples/markers/src
-
-Compile them with your kernel.
-
-Run, as root :
-modprobe marker-example (insmod order is not important)
-modprobe probe-example
-cat /proc/marker-example (returns an expected error)
-rmmod marker-example probe-example
-dmesg
diff --git a/Documentation/markers/marker-example.c b/Documentation/markers/marker-example.c
new file mode 100644
index 0000000..e787c6d
--- /dev/null
+++ b/Documentation/markers/marker-example.c
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
diff --git a/Documentation/markers/markers.txt b/Documentation/markers/markers.txt
new file mode 100644
index 0000000..f098277
--- /dev/null
+++ b/Documentation/markers/markers.txt
@@ -0,0 +1,81 @@
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
+A marker placed in code provides a hook to call a function (probe) that you can
+provide at runtime. A marker can be "on" (a probe is connected to it) or "off"
+(no probe is attached). When a marker is "off" it has no effect, except for
+adding a tiny time penalty (checking a condition for a branch) and space
+penalty (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section).  When a
+marker is "on", the function you provide is called each time the marker is
+executed, in the execution context of the caller. When the function provided
+ends its execution, it returns to the caller (continuing from the marker site).
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
+And,
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
+unrolled loops as well as regular functions.
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
+* Probe / marker example
+
+See the examples provided in Documentation/markers/*.c
+
+Compile them with your kernel.
+
+Run, as root :
+modprobe marker-example (insmod order is not important)
+modprobe probe-example
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg
diff --git a/Documentation/markers/probe-example.c b/Documentation/markers/probe-example.c
new file mode 100644
index 0000000..238b2e3
--- /dev/null
+++ b/Documentation/markers/probe-example.c
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
diff --git a/Makefile b/Makefile
index 2a47290..83894ae 100644
--- a/Makefile
+++ b/Makefile
@@ -774,9 +774,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1faa508..b26313c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -509,4 +509,3 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-source "samples/Kconfig"
diff --git a/samples/Kconfig b/samples/Kconfig
deleted file mode 100644
index 57bb223..0000000
--- a/samples/Kconfig
+++ /dev/null
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
diff --git a/samples/Makefile b/samples/Makefile
deleted file mode 100644
index 5a4f0b6..0000000
--- a/samples/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-# Makefile for Linux samples code
-
-obj-$(CONFIG_SAMPLES)	+= markers/
diff --git a/samples/markers/Makefile b/samples/markers/Makefile
deleted file mode 100644
index 6d72312..0000000
--- a/samples/markers/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# builds the kprobes example kernel modules;
-# then to use one (as root):  insmod <module_name.ko>
-
-obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o
diff --git a/samples/markers/marker-example.c b/samples/markers/marker-example.c
deleted file mode 100644
index e787c6d..0000000
--- a/samples/markers/marker-example.c
+++ /dev/null
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
diff --git a/samples/markers/probe-example.c b/samples/markers/probe-example.c
deleted file mode 100644
index 238b2e3..0000000
--- a/samples/markers/probe-example.c
+++ /dev/null
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
