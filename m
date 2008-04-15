Return-Path: <linux-kernel-owner+w=401wt.eu-S1764730AbYDOLzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764730AbYDOLzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbYDOLzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:55:25 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54586 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793AbYDOLzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:55:24 -0400
Date: Tue, 15 Apr 2008 17:25:15 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, a.p.zijlstra@chello.nl, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
Subject: [RFC PATCH 2/2] Marker handler for the probes in futex file
Message-ID: <20080415115514.GB6975@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415115314.GA6975@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files define and implement marker handlers for the probes in
futex.c. They may be built by choosing the CONFIG_FUTEX_DEBUG option
(can be built as a kernel module also).
 
They export data to the user using debugfs_printk and the output
is available in futex_debug_trace/ directory under the debugfs mount.
Separate directories under this are created for each marker probe.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/futex_markers.h |   63 +++++++++++++
 init/Kconfig                  |   13 ++
 kernel/Makefile               |    1 
 kernel/futex_markers.c        |  201 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 278 insertions(+)

Index: linux-2.6.25-rc8-mm1/init/Kconfig
===================================================================
--- linux-2.6.25-rc8-mm1.orig/init/Kconfig
+++ linux-2.6.25-rc8-mm1/init/Kconfig
@@ -646,6 +646,19 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config FUTEX_DEBUG
+	tristate "Enable debugging for Futex - currently stats in debugfs"
+	depends on FUTEX
+	depends on DEBUG_FS && MARKERS && TRACE
+	default m
+	help
+	  This option provides debugging data for Futex system calls
+	  in debugfs.
+
+	  Say Y/M here if you want to enable Futex debugging
+	  in-kernel/module.
+	  Say N if you are unsure.
+
 config ANON_INODES
 	bool
 
Index: linux-2.6.25-rc8-mm1/kernel/futex_markers.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc8-mm1/kernel/futex_markers.c
@@ -0,0 +1,201 @@
+/*
+ * futex_markers.c - Marker handler for probes in futex.c
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/futex_markers.h>
+
+#define FUTEX_DEBUG_STRING_SIZE 1024
+#define FUTEX_DEBUG_DIR_MAXLEN 25
+
+static void futex_event_debug_worker(const char *marker_name,
+				const char *format_str,
+				enum futex_ops_ futex_event, va_list *ap);
+
+/*
+ * This function helps to direct the output to one of the directories
+ */
+static inline char *choose_output_dir(enum futex_ops_ futex_event)
+{
+	char *temp = NULL;
+
+	switch (futex_event) {
+	case do_futex_probe:
+		temp = "do_futex_probe_debug";
+		break;
+	case futex_wait_called:
+	case futex_wait_uval:
+	case futex_wait_after_sched:
+	case futex_wait_failed:
+		temp = "futex_wait_debug";
+		break;
+	case futex_wake_called:
+	case futex_wake_failed:
+		temp = "futex_wake_debug";
+		break;
+	case futex_cmp_requeue_called:
+	case futex_cmp_requeue_uaddr2_failed:
+	case futex_cmp_requeue_failed:
+		temp = "futex_cmp_requeue_debug";
+		break;
+	case futex_lock_pi_called:
+	case futex_lock_pi_failed:
+		temp = "futex_lock_pi_debug";
+		break;
+	case futex_unlock_pi_called:
+	case futex_unlock_pi_failed:
+		temp = "futex_unlock_pi_debug";
+		break;
+	}
+	return temp;
+}
+
+/*
+ * Use the macro to define the other marker handlers
+ */
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wake_called);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_cmp_requeue_called);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wait_called);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wait_uval);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wait_after_sched);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_lock_pi_called);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_unlock_pi_called);
+
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wait_failed);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_wake_failed);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_cmp_requeue_failed);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_cmp_requeue_uaddr2_failed);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_lock_pi_failed);
+DEFINE_FUTEX_OP_MARKER_HANDLER(futex_unlock_pi_failed);
+
+DEFINE_FUTEX_OP_MARKER_HANDLER(do_futex_probe);
+
+static struct futex_debug_probe futex_debug_probe_array[] =
+{
+	INIT_FUTEX_DEBUG_PROBE(futex_wake_called,
+			"uaddr:%p fshared:%p nr_wake:%d bitset:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_wait_called,
+			"uaddr:%p fshared:%p val:%u abs_time:%p bitset:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_wait_uval, "uaddr:%p uval:%u"),
+	INIT_FUTEX_DEBUG_PROBE(futex_wait_after_sched, "uaddr:%p"),
+	INIT_FUTEX_DEBUG_PROBE(futex_cmp_requeue_called,
+			"uaddr1:%p fshared:%p uaddr2:%p nr_wake:%d "
+			"nr_requeue:%d cmpval:%p"),
+	INIT_FUTEX_DEBUG_PROBE(futex_lock_pi_called,
+			"uaddr:%p fshared:%p detect:%d time:%p trylock:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_unlock_pi_called, "uaddr:%p fshared:%p"),
+
+	INIT_FUTEX_DEBUG_PROBE(futex_wait_failed, "uaddr:%p ret:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_wake_failed, "uaddr:%p ret:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_cmp_requeue_failed, "uaddr1:%p ret:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_cmp_requeue_uaddr2_failed,
+			"uaddr1:%p uaddr2:%p ret:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_lock_pi_failed, "uaddr:%p ret:%d"),
+	INIT_FUTEX_DEBUG_PROBE(futex_unlock_pi_failed, "uaddr:%p ret:%d"),
+
+	INIT_FUTEX_DEBUG_PROBE(do_futex_probe,
+			"uaddr: %lu op:%d val:%lu timeout:%p "
+			"uaddr2:%lu val2:%lu val3:%lu ret:%d")
+};
+
+static void futex_event_debug_worker(const char *marker_name,
+				const char *format_str,
+				enum futex_ops_ futex_event, va_list *ap)
+{
+	unsigned long long temp_ts = 0;
+	struct debugfs_printk_data *dpk;
+	char *print_string;
+	int err_condition = 0;
+
+	/* Capture the kernel timestamp as soon as we enter the handler */
+	temp_ts = ktime_to_ns(ktime_get());
+
+
+	dpk = kzalloc(sizeof(*dpk), GFP_KERNEL);
+	if (!dpk)
+		err_condition = 1;
+
+	dpk->parent_dir = FUTEX_TRACE_ROOT_DIR;
+	dpk->dir = choose_output_dir(futex_event);
+	print_string = kzalloc(FUTEX_DEBUG_STRING_SIZE, GFP_KERNEL);
+	if (!print_string) {
+		err_condition = 1;
+		goto out;
+	}
+
+	snprintf(print_string, FUTEX_DEBUG_STRING_SIZE,
+		"%s TS:%llu PID:%u Process:%s %s\n", marker_name,
+		temp_ts, current->pid, current->comm, format_str);
+
+	debugfs_printk(dpk, print_string, ap);
+
+	/* Exit code. Free the memory held */
+ out:
+	kfree(dpk);
+
+	if (err_condition)
+		printk(KERN_ERR "Unable to find required free memory. "
+				"Futex Debug message discarded");
+}
+
+static int __init futex_debug_init(void)
+{
+	int ret;
+	int i;
+	struct futex_debug_probe *p;
+
+	for (i = 0; i < ARRAY_SIZE(futex_debug_probe_array); i++) {
+		p = &futex_debug_probe_array[i];
+		ret = marker_probe_register(p->name, p->format,
+							p->probe_func, p);
+		if (ret)
+			printk(KERN_INFO "Unable to register Futex Debug "
+				"probe %s\n", futex_debug_probe_array[i].name);
+
+		if (ret)
+			printk(KERN_INFO "Unable to arm Futex Debug probe %s\n",
+				p->name);
+	}
+	printk(KERN_INFO "Futex Debug markers registered\n");
+
+	return ret;
+}
+
+static void __exit futex_debug_cleanup(void)
+{
+	int i;
+	struct futex_debug_probe *p;
+
+	for (i = 0; i < ARRAY_SIZE(futex_debug_probe_array); i++) {
+		p = &futex_debug_probe_array[i];
+		marker_probe_unregister(p->name, p->probe_func, p);
+	}
+	printk(KERN_INFO "Futex Debug markers unregistered\n");
+
+	trace_cleanup_all(FUTEX_TRACE_ROOT_DIR);
+}
+
+MODULE_LICENSE("GPL");
+
+module_init(futex_debug_init);
+module_exit(futex_debug_cleanup);
Index: linux-2.6.25-rc8-mm1/include/linux/futex_markers.h
===================================================================
--- /dev/null
+++ linux-2.6.25-rc8-mm1/include/linux/futex_markers.h
@@ -0,0 +1,63 @@
+/*
+ * futex_markers.h
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/marker.h>
+#include <linux/ktime.h>
+#include <linux/trace.h>
+
+#define FUTEX_TRACE_BUF_SIZE 4096
+#define FUTEX_TRACE_SUB_BUF_NR 40
+#define FUTEX_TRACE_ROOT_DIR "futex_debug_trace"
+
+struct futex_debug_probe {
+	char *name;
+	char *format;
+	marker_probe_func *probe_func;
+};
+
+enum futex_ops_ {
+	do_futex_probe,
+	futex_wait_called, futex_wait_uval,
+	futex_wait_after_sched, futex_wait_failed,
+	futex_wake_called, futex_wake_failed,
+	futex_cmp_requeue_called, futex_cmp_requeue_uaddr2_failed,
+	futex_cmp_requeue_failed,
+	futex_lock_pi_called, futex_lock_pi_failed,
+	futex_unlock_pi_called, futex_unlock_pi_failed
+};
+
+#define DEFINE_FUTEX_OP_MARKER_HANDLER(futex_event) \
+static void futex_event##_callback(const struct marker *mdata, \
+			void *private_data, const char *format, va_list *ap) \
+{ \
+	/* \
+	 * futex_event - Used to identify the type of futex event (enum) \
+	 * __stringify(futex_event) - helps print the type of futex event as a \
+	 *                            string in trace_printf() \
+	 * ap - Contains the parameters exported to the marker handler \
+	 */ \
+	futex_event_debug_worker(mdata->name, mdata->format, futex_event, ap); \
+ \
+}
+
+#define INIT_FUTEX_DEBUG_PROBE(futex_debug_event, format_specifier) \
+{ \
+	.name = __stringify(futex_debug_event), \
+	.format = format_specifier, \
+	.probe_func = futex_debug_event##_callback \
+}
Index: linux-2.6.25-rc8-mm1/kernel/Makefile
===================================================================
--- linux-2.6.25-rc8-mm1.orig/kernel/Makefile
+++ linux-2.6.25-rc8-mm1/kernel/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
+obj-$(CONFIG_FUTEX_DEBUG) += futex_markers.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
