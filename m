Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0BZFlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:41:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0BZFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:41:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=9Fulqbb0gIwA:10 a=meVymXHHAAAA:8 a=tTdOZbhj7dMmE-vcBlIA:9 a=llCa2_4y6lSEm2W0-bIA:7 a=gZs3om4A2ia_Aqb_GmYpen6WirwA:4 a=jeBq3FmKZ4MA:10 a=EaO8D0tRBMR4Xh18:21 a=XNZEWc_DyhgQVNyb:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100226054125.278472284@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 26 Feb 2010 00:38:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 1/2 v2] tracing: Add EXTRACT_TRACE_SYMBOL() macro
References: <20100226053831.050130780@goodmis.org>
Content-Disposition: inline; filename=extract-trace-syms-v2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace events that are created with the TRACE_EVENT family macros
can be read by binary readers, such as perf and trace-cmd. In order
to translate the binary data, the events also have a format file
associated with them. This format file explains the offset, size and
signedness of elements in the raw binary data of an event.

At the end of the format file, there is a description on how to print
this data. A helper function is used to map numbers into strings
called __print_symbolic(). A problem arises when these numbers are
defined as enums in the kernel. The macros that export this data into
the format file does not translate the enums into numbers. Thus we
have in the irq.h file:

 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
 #define show_softirq_name(val)				\
	__print_symbolic(val,				\
			 softirq_name(HI),		\
			 softirq_name(TIMER),		\
			 softirq_name(NET_TX),		\
			 softirq_name(NET_RX),		\
			 softirq_name(BLOCK),		\
			 softirq_name(BLOCK_IOPOLL),	\
			 softirq_name(TASKLET),		\
			 softirq_name(SCHED),		\
			 softirq_name(HRTIMER),		\
			 softirq_name(RCU))


	TP_printk("vec=%d [action=%s]", __entry->vec,
		  show_softirq_name(__entry->vec))


Which shows up in the event format file as:

  print fmt: "vec=%d [action=%s]", REC->vec, __print_symbolic(REC->vec, { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, { BLOCK_IOPOLL_SOFTIRQ, "BLOCK_IOPOLL" }, { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" })


The parser has no idea of how to translate "HI_SOFTIRQ" into a number.

This patch adds an EXTRACT_TRACE_SYMBOLS() macro that lets a trace header
define symbols that it uses, and will be converted into numbers.
These symbols will be shown in an "event_symbols" file in the event
directory.

Enums that use this also need to be converted into the following format:

 #define ENUMS 				\
	C(ENUM1)			\
	C(ENUM2)			\
	C(ENUM3)

 #define C(name) name
 enum { ENUMS };
 #undef C

Then the trace header can do the following:

  #define C(name)  TRACE_SYMBOL_PARSE(#name, name, sizeof(name))
  EXTRACT_TRACE_SYMBOLS(mysyms, ENUMS)

For example, for the softirq names we can now have:

 #define C(sirq) \
	TRACE_SYMBOL_PARSE(#sirq, sirq##_SOFTIRQ, sizeof(sirq##_SOFTIRQ))

 EXTRACT_TRACE_SYMBOLS(softirqs, SOFTIRQ_NAMES)

where the SOFTIRQ_NAMES are defined as:

 #define SOFTIRQ_NAMES			\
	C(HI),				\
	C(TIMER),			\
	C(NET_TX),			\
	[...]
	C(RCU)
 #define C(name) name##_SOFTIRQ
 enum { SOFTIRQ_NAMES, NR_SOFTIRQS };

This produces:

   [tracing/]$ cat events/event_symbols
   # Symbol:Size:Value
   # =================
   HI_SOFTIRQ:4:0
   TIMER_SOFTIRQ:4:1
   NET_TX_SOFTIRQ:4:2
   NET_RX_SOFTIRQ:4:3
   BLOCK_SOFTIRQ:4:4
   BLOCK_IOPOLL_SOFTIRQ:4:5
   TASKLET_SOFTIRQ:4:6
   SCHED_SOFTIRQ:4:7
   HRTIMER_SOFTIRQ:4:8
   RCU_SOFTIRQ:4:9

Now a parser can read this file and replace symbols it encounters in the
format files with an actual number.

Changes since v1:
 -  Added separate header to store struct trace_syms
 -  Document fields of struct trace_syms
      (both suggested by Andrew Morton)
 -  Coupled the enums with the exports with one macro
       (suggested by Frederic Weisbecker)

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 include/asm-generic/vmlinux.lds.h |    4 +
 include/linux/tracepoint.h        |    2 
 include/trace/define_trace.h      |   18 ++++++++
 include/trace/trace_syms.h        |   14 ++++++
 kernel/trace/trace_events.c       |   84 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 121 insertions(+), 1 deletion(-)

Index: linux-trace.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-trace.git.orig/include/asm-generic/vmlinux.lds.h	2010-02-12 13:35:15.000000000 -0500
+++ linux-trace.git/include/asm-generic/vmlinux.lds.h	2010-02-25 15:15:12.000000000 -0500
@@ -163,6 +163,10 @@
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
 	*(__verbose)                                                    \
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
+	. = ALIGN(32);							\
+	VMLINUX_SYMBOL(__start_trace_syms) = .;				\
+	*(_trace_symbols)						\
+	VMLINUX_SYMBOL(__stop_trace_syms) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
Index: linux-trace.git/include/linux/tracepoint.h
===================================================================
--- linux-trace.git.orig/include/linux/tracepoint.h	2010-02-12 13:35:15.000000000 -0500
+++ linux-trace.git/include/linux/tracepoint.h	2010-02-25 22:47:10.000000000 -0500
@@ -292,4 +292,6 @@ static inline void tracepoint_synchroniz
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#define EXTRACT_TRACE_SYMBOLS(name, symbols)
+
 #endif /* ifdef TRACE_EVENT (see note above) */
Index: linux-trace.git/include/trace/define_trace.h
===================================================================
--- linux-trace.git.orig/include/trace/define_trace.h	2010-02-12 13:35:15.000000000 -0500
+++ linux-trace.git/include/trace/define_trace.h	2010-02-25 23:53:52.000000000 -0500
@@ -20,6 +20,7 @@
 /* Prevent recursion */
 #undef CREATE_TRACE_POINTS
 
+#include <trace/trace_syms.h>
 #include <linux/stringify.h>
 
 #undef TRACE_EVENT
@@ -43,6 +44,20 @@
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
 
+#undef EXTRACT_TRACE_SYMBOLS
+#define EXTRACT_TRACE_SYMBOLS(name, symbols)	\
+	struct trace_syms ___trace_sym_##name[]					\
+	__attribute__((section("_trace_symbols"), aligned(4)))	= {	\
+		symbols							\
+	}
+
+#define TRACE_SYMBOL_PARSE(symbol, value, sym_size)			\
+	{								\
+		.name = symbol,						\
+		.val = (u64)(value),					\
+		.size = sym_size					\
+	}
+
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
 
@@ -65,6 +80,9 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#undef EXTRACT_TRACE_SYMBOLS
+#define EXTRACT_TRACE_SYMBOLS(name, symbols)
+
 #ifdef CONFIG_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
Index: linux-trace.git/kernel/trace/trace_events.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace_events.c	2010-02-25 10:42:53.000000000 -0500
+++ linux-trace.git/kernel/trace/trace_events.c	2010-02-25 23:16:26.000000000 -0500
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
-
+#include <trace/trace_syms.h>
 #include <asm/setup.h>
 
 #include "trace_output.h"
@@ -28,6 +28,10 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
+extern struct trace_syms __start_trace_syms;
+extern struct trace_syms __stop_trace_syms;
+
+
 int trace_define_field(struct ftrace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type)
@@ -285,6 +289,73 @@ ftrace_event_write(struct file *file, co
 }
 
 static void *
+sym_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct trace_syms *sym;
+
+	/* The symbols are aligned at 32 bytes */
+	sym = &__start_trace_syms + *pos;
+
+	if (sym >= &__stop_trace_syms)
+		return NULL;
+
+	(*pos)++;
+
+	return sym;
+}
+
+static void *sym_start(struct seq_file *m, loff_t *pos)
+{
+	return sym_next(m, NULL, pos);
+}
+
+static int sym_show(struct seq_file *m, void *v)
+{
+	struct trace_syms *sym = v;
+
+	/* Show header on first index */
+	if (sym == &__start_trace_syms)
+		seq_printf(m, "# Symbol:Size:Value\n"
+			   "# =================\n");
+
+	seq_printf(m, "%s:%d:", sym->name, sym->size);
+	switch (sym->size) {
+	case 1:
+		seq_printf(m, "%u\n", (unsigned char)sym->val);
+		break;
+	case 2:
+		seq_printf(m, "%u\n", (unsigned short)sym->val);
+		break;
+	case 4:
+		seq_printf(m, "%u\n", (unsigned int)sym->val);
+		break;
+	default:
+		seq_printf(m, "%llu\n", sym->val);
+		break;
+	}
+
+	return 0;
+}
+
+static void sym_stop(struct seq_file *m, void *p)
+{
+}
+
+static const struct seq_operations show_event_sym_seq_ops = {
+	.start = sym_start,
+	.next = sym_next,
+	.show = sym_show,
+	.stop = sym_stop,
+};
+
+static int
+ftrace_event_sym_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &show_event_sym_seq_ops);
+}
+
+
+static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_event_call *call = v;
@@ -813,6 +884,13 @@ static const struct file_operations ftra
 	.write = subsystem_filter_write,
 };
 
+static const struct file_operations ftrace_event_symbols_fops = {
+	.open = ftrace_event_sym_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
 static const struct file_operations ftrace_system_enable_fops = {
 	.open = tracing_open_generic,
 	.read = system_enable_read,
@@ -1278,6 +1356,10 @@ static __init int event_trace_init(void)
 			  ring_buffer_print_entry_header,
 			  &ftrace_show_header_fops);
 
+	/* Event symbols */
+	trace_create_file("event_symbols", 0444, d_events,
+			  NULL, &ftrace_event_symbols_fops);
+
 	trace_create_file("enable", 0644, d_events,
 			  NULL, &ftrace_system_enable_fops);
 
Index: linux-trace.git/include/trace/trace_syms.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-trace.git/include/trace/trace_syms.h	2010-02-25 15:27:10.000000000 -0500
@@ -0,0 +1,14 @@
+#ifndef _TRACE_SYMS_H
+#define _TRACE_SYMS_H
+
+/*
+ * This is used by trace/define_trace.h and needs to be in its
+ * own header to prevent inclusion hell.
+ */
+struct trace_syms {
+	u64			val;	/* value of the symbol		*/
+	const char		*name;	/* name of symbol to export	*/
+	int			size;	/* size of the value		*/
+};
+
+#endif /* _TRACE_SYMS_H */

