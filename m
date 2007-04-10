Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXDJX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXDJX0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXDJX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:26:23 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:40784 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbXDJX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:26:22 -0400
Date: Tue, 10 Apr 2007 19:26:20 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-doc-update-flags-example
Message-ID: <20070410232620.GG7092@Krystal>
References: <20070410231126.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410231126.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:24:33 up 67 days, 13:31,  6 users,  load average: 1.31, 1.48, 1.85
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update marker Documentation to be in sync with the flag bitmask
change. Give more complete probe example.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/Documentation/marker.txt
+++ b/Documentation/marker.txt
@@ -12,11 +12,11 @@ probe module examples. This is what connects to a marker.
 * Purpose of markers
 
 A marker placed in your code provides a hook to a function (probe) that
-you can provide at runtime. A marker can be on (a probe is connected to it)
-or off (no probe is attached). An "off" marker has no effect. When turned on,
+you can provide at runtime. A marker can be "on" (a probe is connected to it)
+or "off" (no probe is attached). An "off" marker has no effect. When turned on,
 the function you provide is called each time the marker is executed in the
 execution context of the caller. When the function provided ends its execution,
-it returns to the caller (probe site).
+it returns to the caller (marker site).
 
 You can put markers at important locations in the code. They act as
 lightweight hooks that can pass an arbitrary number of parameters,
@@ -40,20 +40,14 @@ In order to use the macro MARK, you should include linux/marker.h.
 
 Add, in your code :
 
-MARK(subsystem_event, "%d %s %p[struct task_struct]",
-  someint, somestring, current);
+MARK(subsystem_event, "%d %s", someint, somestring);
 Where :
 - subsystem_event is an identifier unique to your event
     - subsystem is the name of your subsystem.
     - event is the name of the event to mark.
-- "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
+- "%d %s" is the formatted string for the serializer.
 - someint is an integer.
 - somestring is a char pointer.
-- current is a pointer to a struct task_struct.
-
-The expression %p[struct task_struct] is a suggested marker definition
-standard that could eventually be used for pointer type checking in
-sparse. The brackets contain the type to which the pointer refers.
 
 Connecting a function (probe) to a marker is done by providing a probe
 (function to call) for the specific marker through marker_set_probe(). It will
@@ -73,7 +67,7 @@ will not call the scheduler due to the tests in preempt_schedule().
 * Optimization for a given architecture
 
 You will find, in asm-*/marker.h, optimisations for given architectures
-(currently i386 and powerpc). They use a load immediate instead of a data read,
+(currently i386 and powerpc). They use a load immediate instead of a data load,
 which saves a data cache hit, but also requires cross CPU code modification. In
 order to support embedded systems which use read-only memory for their code, the
 optimization can be disabled through menu options.
@@ -81,25 +75,35 @@ optimization can be disabled through menu options.
 The MF_* flags can be used to control the type of marker. See the
 include/marker.h header for the list of flags. They can be specified as the
 first parameter of the _MARK() macro, such as the following example which is
-safe wrt lockdep.c (useful for marking lockdep.c functions).
+safe with respect to lockdep.c (useful for marking lockdep.c and printk
+functions).
 
-_MARK(_MF_DEFAULT | ~_MF_LOCKDEP, subsystem_eventb,
-  MARK_NOARGS);
+_MARK(MF_DEFAULT | ~MF_LOCKDEP, subsystem_eventb, MARK_NOARGS);
 
 Another example is to specify that a specific marker must never call printk :
-_MARK(_MF_DEFAULT | ~_MF_PRINTK, subsystem_eventc,
-  "%d %s %p[struct task_struct]",
-  someint, somestring, current);
+_MARK(MF_DEFAULT | ~MF_PRINTK, subsystem_eventc,
+  "%d %s", someint, somestring,);
 
-Flag compatibility is checked before connecting the probe to the marker.
+Flag compatibility is checked before connecting the probe to the marker : the
+right flags must be given to _marker_set_enable().
 
 
 * Probe example
 
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
 ------------------------------ CUT -------------------------------------
 /* probe-example.c
  *
- * Loads a function at a marker call site.
+ * Connects a two functions to marker call sites.
  *
  * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -109,67 +113,83 @@ Flag compatibility is checked before connecting the probe to the marker.
 
 #include <linux/sched.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/marker.h>
+#include <asm/atomic.h>
+
+#define NUM_PROBES (sizeof(probe_array) / sizeof(struct probe_data))
 
-#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
-void probe_subsystem_event(const char *format, ...)
+struct probe_data {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+void probe_subsystem_event(const struct __mark_marker_c *mdata,
+		const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */
 	unsigned int value;
 	const char *mystr;
-	struct task_struct *task;
 
 	/* Assign args */
 	va_start(ap, format);
 	value = va_arg(ap, typeof(value));
 	mystr = va_arg(ap, typeof(mystr));
-	task = va_arg(ap, typeof(task));
-
-	/* Call tracer */
-	trace_subsystem_event(value, mystr, task);
 
-	/* Or call printk */
-	vprintk(format, ap);
+	/* Call printk */
+	printk("Value %u, string %s\n", value, mystr);
 
-	/* or count, check rights... */
+	/* or count, check rights, serialize data in a buffer */
 
 	va_end(ap);
 }
 
-#define SUBSYSTEM_EVENTB_FORMAT MARK_NOARGS
-void probe_subsystem_eventb(const char *format, ...)
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct __mark_marker_c *mdata,
+	const char *format, ...)
 {
-	/* Increment counters, trace, ... but _never_ generate a call to
-	 * lockdep.c ! */
+	/* Increment counter */
+	atomic_inc(&eventb_count);
 }
 
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
 static int __init probe_init(void)
 {
 	int result;
-	result = marker_set_probe("subsystem_event",
-			SUBSYSTEM_EVENT_FORMAT,
-			probe_subsystem_event);
-	if (!result)
-		goto cleanup;
-	result = _marker_set_probe(_MF_DEFAULT & ~_MF_LOCKDEP,
-			"subsystem_eventb",
-			SUBSYSTEM_EVENTB_FORMAT,
-			probe_subsystem_eventb);
-	if (!result)
-		goto cleanup;
+	uint8_t eID;
+
+	for (eID = 0; eID < NUM_PROBES; eID++) {
+		result = marker_set_probe(probe_array[eID].name,
+				probe_array[eID].format,
+				probe_array[eID].probe_func, &probe_array[eID]);
+		if (!result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[eID].name);
+	}
 	return 0;
-
-cleanup:
-	marker_remove_probe(probe_subsystem_event);
-	marker_remove_probe(probe_subsystem_eventb);
-	return -EPERM;
 }
 
 static void __exit probe_fini(void)
 {
-	marker_remove_probe(probe_subsystem_event);
-	marker_remove_probe(probe_subsystem_eventb);
+	uint8_t eID;
+
+	for (eID = 0; eID < NUM_PROBES; eID++) {
+		marker_remove_probe(probe_array[eID].name);
+	}
+	synchronize_sched();	/* Wait for probes to finish */
+	printk("Number of event b : %u\n", atomic_read(&eventb_count));
 }
 
 module_init(probe_init);
@@ -179,4 +199,68 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mathieu Desnoyers");
 MODULE_DESCRIPTION("SUBSYSTEM Probe");
 ------------------------------ CUT -------------------------------------
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
+	MARK(subsystem_event, "%d %s", 123, "example string");
+	for (i=0; i<10; i++) {
+		MARK(subsystem_eventb, MARK_NOARGS);
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
 
+module_init(example_init)
+module_exit(example_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Linux Trace Toolkit example");
+------------------------------ CUT -------------------------------------
+Sequence of operations : (as root)
+make
+insmod marker-example.ko
+insmod probe-example.ko
+  (it is important to load the probe after the marked code)
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg
+------------------------------ CUT -------------------------------------
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
