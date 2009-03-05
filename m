Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZCEX1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZCEX1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZCEX0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:26:47 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33565 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbZCEX0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:26:46 -0500
Message-Id: <20090305225520.011236565@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 37/41] Markers : multi-probes test
Content-Disposition: inline; filename=markers-multi-probes-test.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 samples/markers/Makefile     |    2 
 samples/markers/test-multi.c |  116 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/samples/markers/Makefile
===================================================================
--- linux-2.6-lttng.orig/samples/markers/Makefile	2009-01-09 18:15:52.000000000 -0500
+++ linux-2.6-lttng/samples/markers/Makefile	2009-01-09 18:17:56.000000000 -0500
@@ -1,4 +1,4 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o
+obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o test-multi.o
Index: linux-2.6-lttng/samples/markers/test-multi.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/markers/test-multi.c	2009-01-09 18:17:56.000000000 -0500
@@ -0,0 +1,116 @@
+/* test-multi.c
+ *
+ * Connects multiple callbacks.
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
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventa(void *probe_data, void *call_data,
+	const char *format, va_list *args)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+void probe_subsystem_eventb(void *probe_data, void *call_data,
+	const char *format, va_list *args)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+void probe_subsystem_eventc(void *probe_data, void *call_data,
+	const char *format, va_list *args)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+void probe_subsystem_eventd(void *probe_data, void *call_data,
+	const char *format, va_list *args)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+static struct probe_data probe_array[] =
+{
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0xa },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0xb },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0xc },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0xd },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0x10 },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0x20 },
+	{	.name = "test_multi",
+		.format = MARK_NOARGS,
+		.probe_func = (marker_probe_func*)0x30 },
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
+				probe_array[i].probe_func, (void*)(long)i);
+		if (result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[i].name);
+	}
+	return 0;
+}
+
+static void __exit probe_fini(void)
+{
+	int result;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		result = marker_probe_unregister(probe_array[i].name,
+			probe_array[i].probe_func, (void*)(long)i);
+		if (result)
+			printk(KERN_INFO "Unable to unregister probe %s\n",
+				probe_array[i].name);
+	}
+	printk(KERN_INFO "Number of event b : %u\n",
+		atomic_read(&eventb_count));
+	marker_synchronize_unregister();
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
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
