Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZDODRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZDODRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZDODQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:16:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZDODQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:16:10 -0400
Message-Id: <20090415031605.445499740@goodmis.org>
References: <20090415031511.128139334@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 23:15:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 4/4] tracing/events: add trace-events-sample
Content-Disposition: inline; filename=0004-tracing-events-add-trace-events-sample.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a sample to the samples directory on how to create
and use TRACE_EVENT trace points.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 samples/Kconfig                            |    7 ++
 samples/Makefile                           |    2 +-
 samples/trace_events/Makefile              |    8 ++
 samples/trace_events/trace-events-sample.c |   56 +++++++++++++
 samples/trace_events/trace-events-sample.h |  124 ++++++++++++++++++++++++++++
 5 files changed, 196 insertions(+), 1 deletions(-)
 create mode 100644 samples/trace_events/Makefile
 create mode 100644 samples/trace_events/trace-events-sample.c
 create mode 100644 samples/trace_events/trace-events-sample.h

diff --git a/samples/Kconfig b/samples/Kconfig
index 4b02f5a..93f41c0 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -19,6 +19,13 @@ config SAMPLE_TRACEPOINTS
 	help
 	  This build tracepoints example modules.
 
+config SAMPLE_TRACE_EVENTS
+	tristate "Build trace_events examples"
+	depends on EVENT_TRACING
+	default m
+	help
+	  This build trace event example modules.
+
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
 	help
diff --git a/samples/Makefile b/samples/Makefile
index 10eaca8..13e4b47 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace_events/
diff --git a/samples/trace_events/Makefile b/samples/trace_events/Makefile
new file mode 100644
index 0000000..06c6dea
--- /dev/null
+++ b/samples/trace_events/Makefile
@@ -0,0 +1,8 @@
+# builds the trace events example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+PWD := $(shell pwd)
+
+CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+
+obj-$(CONFIG_SAMPLE_TRACE_EVENTS) += trace-events-sample.o
diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
new file mode 100644
index 0000000..f33b3ba
--- /dev/null
+++ b/samples/trace_events/trace-events-sample.c
@@ -0,0 +1,56 @@
+#include <linux/module.h>
+#include <linux/kthread.h>
+
+/*
+ * Any file that uses trace points, must include the header.
+ * But only one file, must include the header by defining
+ * CREATE_TRACE_POINTS first.  This will make the C code that
+ * creates the handles for the trace points.
+ */
+#define CREATE_TRACE_POINTS
+#include "trace-events-sample.h"
+
+
+static void simple_thread_func(int cnt)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(HZ);
+	trace_foo_bar("hello", cnt);
+
+	if (!(cnt % 10))
+		/* It is really important that I say "hi!" */
+		printk(KERN_EMERG "hi!\n");
+}
+
+static int simple_thread(void *arg)
+{
+	int cnt = 0;
+
+	while (!kthread_should_stop())
+		simple_thread_func(cnt++);
+
+	return 0;
+}
+
+static struct task_struct *simple_tsk;
+
+static int __init trace_event_init(void)
+{
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample");
+	if (IS_ERR(simple_tsk))
+		return -1;
+
+	return 0;
+}
+
+static void __exit trace_event_exit(void)
+{
+	kthread_stop(simple_tsk);
+}
+
+module_init(trace_event_init);
+module_exit(trace_event_exit);
+
+MODULE_AUTHOR("Steven Rostedt");
+MODULE_DESCRIPTION("trace-events-sample");
+MODULE_LICENSE("GPL");
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
new file mode 100644
index 0000000..eab4644
--- /dev/null
+++ b/samples/trace_events/trace-events-sample.h
@@ -0,0 +1,124 @@
+/*
+ * Notice that this file is not protected like a normal header.
+ * We also must allow for rereading of this file. The
+ *
+ *  || defined(TRACE_HEADER_MULTI_READ)
+ *
+ * serves this purpose.
+ */
+#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENT_SAMPLE_H
+
+/*
+ * All trace headers should include tracepoint.h, until we finally
+ * make it into a standard header.
+ */
+#include <linux/tracepoint.h>
+
+/*
+ * If TRACE_SYSTEM is defined, that will be the directory created
+ * in the ftrace directory under /debugfs/tracing/events/<system>
+ *
+ * The define_trace.h belowe will also look for a file name of
+ * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
+ *
+ * If you want a different system than file name, you can override
+ * the header name by defining TRACE_INCLUDE_FILE
+ *
+ * If this file was called, goofy.h, then we would define:
+ *
+ * #define TRACE_INCLUDE_FILE goofy
+ *
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM trace-events-sample
+
+/*
+ * The TRACE_EVENT macro is broken up into 5 parts.
+ *
+ * name: name of the trace point. This is also how to enable the tracepoint.
+ *   A function called trace_foo_bar() will be created.
+ *
+ * proto: the prototype of the function trace_foo_bar()
+ *   Here it is trace_foo_bar(char *foo, int bar).
+ *
+ * args:  must match the arguments in the prototype.
+ *    Here it is simply "foo, bar".
+ *
+ * struct:  This defines the way the data will be stored in the ring buffer.
+ *    There are currently two types of elements. __field and __array.
+ *    a __field is broken up into (type, name). Where type can be any
+ *    type but an array.
+ *    For an array. there are three fields. (type, name, size). The
+ *    type of elements in the array, the name of the field and the size
+ *    of the array.
+ *
+ *    __array( char, foo, 10) is the same as saying   char foo[10].
+ *
+ * fast_assign: This is a C like function that is used to store the items
+ *    into the ring buffer.
+ *
+ * printk: This is a way to print out the data in pretty print. This is
+ *    useful if the system crashes and you are logging via a serial line,
+ *    the data can be printed to the console using this "printk" method.
+ *
+ * Note, that for both the assign and the printk, __entry is the handler
+ * to the data structure in the ring buffer, and is defined by the
+ * TP_STRUCT__entry.
+ */
+TRACE_EVENT(foo_bar,
+
+	TP_PROTO(char *foo, int bar),
+
+	TP_ARGS(foo, bar),
+
+	TP_STRUCT__entry(
+		__array(	char,	foo,    10		)
+		__field(	int,	bar			)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->foo, foo, 10);
+		__entry->bar	= bar;
+	),
+
+	TP_printk("foo %s %d", __entry->foo, __entry->bar)
+);
+#endif
+
+/***** NOTICE! The #if protection ends here. *****/
+
+
+/*
+ * There are several ways I could have done this. If I left out the
+ * TRACE_INCLUDE_PATH, then it would default to the kernel source
+ * include/trace/events directory.
+ *
+ * I could specify a path from the define_trace.h file back to this
+ * file.
+ *
+ * #define TRACE_INCLUDE_PATH ../../samples/trace_events
+ *
+ * But I chose to simply make it use the current directory and then in
+ * the Makefile I added:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+ *
+ * This will make sure the current path is part of the include
+ * structure for our file so that we can find it.
+ *
+ * I could have made only the top level directory the include:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(PWD)
+ *
+ * And then let the path to this directory be the TRACE_INCLUDE_PATH:
+ *
+ * #define TRACE_INCLUDE_PATH samples/trace_events
+ *
+ * But then if something defines "samples" or "trace_events" then we
+ * could risk that being converted too, and give us an unexpected
+ * result.
+ */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#include <trace/define_trace.h>
-- 
1.6.2.1

-- 
