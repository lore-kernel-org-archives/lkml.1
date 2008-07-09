Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYGIPFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYGIPFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbYGIPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:03:06 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41186 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbYGIPDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:03:03 -0400
Message-Id: <20080709150044.358012468@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 03/15] Tracepoints Samples
Content-Disposition: inline; filename=tracepoints-samples.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracepoint example code under samples/.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 samples/Kconfig                                |    6 ++
 samples/Makefile                               |    2 
 samples/tracepoints/Makefile                   |    6 ++
 samples/tracepoints/tp-samples-trace.h         |   13 +++++
 samples/tracepoints/tracepoint-probe-sample.c  |   55 +++++++++++++++++++++++++
 samples/tracepoints/tracepoint-probe-sample2.c |   42 +++++++++++++++++++
 samples/tracepoints/tracepoint-sample.c        |   53 ++++++++++++++++++++++++
 7 files changed, 176 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/samples/Kconfig
===================================================================
--- linux-2.6-lttng.orig/samples/Kconfig	2008-07-09 10:46:33.000000000 -0400
+++ linux-2.6-lttng/samples/Kconfig	2008-07-09 10:57:28.000000000 -0400
@@ -13,6 +13,12 @@ config SAMPLE_MARKERS
 	help
 	  This build markers example modules.
 
+config SAMPLE_TRACEPOINTS
+	tristate "Build tracepoints examples -- loadable modules only"
+	depends on TRACEPOINTS && m
+	help
+	  This build tracepoints example modules.
+
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
 	help
Index: linux-2.6-lttng/samples/tracepoints/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/tracepoints/Makefile	2008-07-09 10:57:28.000000000 -0400
@@ -0,0 +1,6 @@
+# builds the tracepoint example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-sample.o
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample.o
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample2.o
Index: linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample.c	2008-07-09 10:57:28.000000000 -0400
@@ -0,0 +1,55 @@
+/*
+ * tracepoint-probe-sample.c
+ *
+ * sample tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/dcache.h>
+#include "tp-samples-trace.h"
+
+/*
+ * Here the caller only guarantees locking for struct file and struct inode.
+ * Locking must therefore be done in the probe to use the dentry.
+ */
+static void probe_subsys_event(struct inode *inode, struct file *file)
+{
+	path_get(&file->f_path);
+	dget(file->f_path.dentry);
+	printk(KERN_INFO "Event is encountered with filename %s\n",
+		file->f_path.dentry->d_name.name);
+	dput(file->f_path.dentry);
+	path_put(&file->f_path);
+}
+
+static void probe_subsys_eventb(void)
+{
+	printk(KERN_INFO "Event B is encountered\n");
+}
+
+int __init tp_sample_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_subsys_event(probe_subsys_event);
+	WARN_ON(ret);
+	ret = register_trace_subsys_eventb(probe_subsys_eventb);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(tp_sample_trace_init);
+
+void __exit tp_sample_trace_exit(void)
+{
+	unregister_trace_subsys_eventb(probe_subsys_eventb);
+	unregister_trace_subsys_event(probe_subsys_event);
+}
+
+module_exit(tp_sample_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint Probes Samples");
Index: linux-2.6-lttng/samples/tracepoints/tracepoint-sample.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/tracepoints/tracepoint-sample.c	2008-07-09 10:57:28.000000000 -0400
@@ -0,0 +1,53 @@
+/* tracepoint-sample.c
+ *
+ * Executes a tracepoint when /proc/tracepoint-example is opened.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/proc_fs.h>
+#include "tp-samples-trace.h"
+
+struct proc_dir_entry *pentry_example;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_subsys_event(inode, file);
+	for (i = 0; i < 10; i++)
+		trace_subsys_eventb();
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
+	pentry_example = proc_create("tracepoint-example", 0444, NULL,
+		&mark_ops);
+	if (!pentry_example)
+		return -EPERM;
+	return 0;
+}
+
+static void example_exit(void)
+{
+	printk(KERN_ALERT "example exit\n");
+	remove_proc_entry("tracepoint-example", NULL);
+}
+
+module_init(example_init)
+module_exit(example_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint example");
Index: linux-2.6-lttng/samples/tracepoints/tp-samples-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/tracepoints/tp-samples-trace.h	2008-07-09 10:57:28.000000000 -0400
@@ -0,0 +1,13 @@
+#ifndef _TP_SAMPLES_TRACE_H
+#define _TP_SAMPLES_TRACE_H
+
+#include <linux/proc_fs.h>	/* for struct inode and struct file */
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(subsys_event,
+	TPPROTO(struct inode *inode, struct file *file),
+	TPARGS(inode, file));
+DEFINE_TRACE(subsys_eventb,
+	TPPROTO(void),
+	TPARGS());
+#endif
Index: linux-2.6-lttng/samples/Makefile
===================================================================
--- linux-2.6-lttng.orig/samples/Makefile	2008-07-09 10:46:33.000000000 -0400
+++ linux-2.6-lttng/samples/Makefile	2008-07-09 10:57:28.000000000 -0400
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
Index: linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample2.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample2.c	2008-07-09 10:57:28.000000000 -0400
@@ -0,0 +1,42 @@
+/*
+ * tracepoint-probe-sample2.c
+ *
+ * 2nd sample tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include "tp-samples-trace.h"
+
+/*
+ * Here the caller only guarantees locking for struct file and struct inode.
+ * Locking must therefore be done in the probe to use the dentry.
+ */
+static void probe_subsys_event(struct inode *inode, struct file *file)
+{
+	printk(KERN_INFO "Event is encountered with inode number %lu\n",
+		inode->i_ino);
+}
+
+int __init tp_sample_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_subsys_event(probe_subsys_event);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(tp_sample_trace_init);
+
+void __exit tp_sample_trace_exit(void)
+{
+	unregister_trace_subsys_event(probe_subsys_event);
+}
+
+module_exit(tp_sample_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint Probes Samples");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
