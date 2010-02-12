Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0BLTLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:11:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0BLTKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:10:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=F9KLgmAPckAA:10 a=meVymXHHAAAA:8 a=9DcKq9c0iHUYqopoYuMA:9 a=D8vsoQDJNhxReQHqO-4A:7 a=E_VHN-OzjHV5Gef0bG4ng3wiwZ4A:4 a=jeBq3FmKZ4MA:10 a=1_X8OVmPVmbHi_3Y:21 a=6ySDTm4DI66oUtG4:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100212191036.974694872@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Feb 2010 14:09:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 1/2][RFC] tracing: Add EXTRACT_TRACE_SYMBOL() macro
References: <20100212190907.954438555@goodmis.org>
Content-Disposition: inline; filename=extract-trace-syms.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace events that are created with the TRACE_EVENT family macros
can be read by binary readers, such as perf and trace-cmd. In order
to translate the binary data, the events also have a format file
associated with them. This format file explains the offset, size and
signess of elements in the raw binary data of an event.

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

This patch adds an EXTRACT_TRACE_SYMBOL() macro that lets a trace header
define symbols that it uses, and will be converted into numbers.
These symbols will be shown in an "event_symbols" file in the event
directory.

By adding this macro with all the softirq names:

   EXTRACT_TRACE_SYMBOL(HI_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(TIMER_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(NET_TX_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(NET_RX_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(BLOCK_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(BLOCK_IOPOLL_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(TASKLET_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(SCHED_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(HRTIMER_SOFTIRQ);
   EXTRACT_TRACE_SYMBOL(RCU_SOFTIRQ);

in the events/irq.h file, this produces the output:


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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 include/asm-generic/vmlinux.lds.h |    4 +
 include/linux/tracepoint.h        |    2 
 include/trace/define_trace.h      |   16 ++++++
 kernel/trace/trace_events.c       |   92 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+)

Index: linux-trace.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-trace.git.orig/include/asm-generic/vmlinux.lds.h	2010-02-11 14:30:03.000000000 -0500
+++ linux-trace.git/include/asm-generic/vmlinux.lds.h	2010-02-12 11:35:48.000000000 -0500
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
--- linux-trace.git.orig/include/linux/tracepoint.h	2010-02-11 14:30:03.000000000 -0500
+++ linux-trace.git/include/linux/tracepoint.h	2010-02-12 11:35:48.000000000 -0500
@@ -292,4 +292,6 @@ static inline void tracepoint_synchroniz
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#define EXTRACT_TRACE_SYMBOL(symbol)
+
 #endif /* ifdef TRACE_EVENT (see note above) */
Index: linux-trace.git/include/trace/define_trace.h
===================================================================
--- linux-trace.git.orig/include/trace/define_trace.h	2010-02-11 14:30:03.000000000 -0500
+++ linux-trace.git/include/trace/define_trace.h	2010-02-12 11:35:48.000000000 -0500
@@ -43,6 +43,19 @@
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
 
+#undef EXTRACT_TRACE_SYMBOL
+#define EXTRACT_TRACE_SYMBOL(symbol)					\
+	struct {							\
+		u64			val;				\
+		const char		*name;				\
+		int			size;				\
+	}  ___trace_sym_##symbol					\
+	__attribute__((section("_trace_symbols"), aligned(32)))	= {	\
+		.name = #symbol,					\
+		.val = (u64)(symbol),					\
+		.size = sizeof(symbol)					\
+	}
+
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
 
@@ -65,6 +78,9 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#undef EXTRACT_TRACE_SYMBOL
+#define EXTRACT_TRACE_SYMBOL(symbol)
+
 #ifdef CONFIG_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
Index: linux-trace.git/kernel/trace/trace_events.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace_events.c	2010-02-11 14:30:03.000000000 -0500
+++ linux-trace.git/kernel/trace/trace_events.c	2010-02-12 13:00:15.000000000 -0500
@@ -28,6 +28,20 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
+/*
+ * Would have liked to put trace_syms in a header for define_trace.h to
+ * use, but found that it simply caused include hell.
+ */
+struct trace_syms {
+	u64			val;
+	const char		*name;
+	int			size;
+};
+
+extern struct trace_syms __start_trace_syms;
+extern struct trace_syms __stop_trace_syms;
+
+
 int trace_define_field(struct ftrace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type)
@@ -287,6 +301,73 @@ ftrace_event_write(struct file *file, co
 }
 
 static void *
+sym_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct trace_syms *sym;
+
+	/* The symbols are aligned at 32 bytes */
+	sym = (void *)&__start_trace_syms + *pos * 32;
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
@@ -815,6 +896,13 @@ static const struct file_operations ftra
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
@@ -1280,6 +1368,10 @@ static __init int event_trace_init(void)
 			  ring_buffer_print_entry_header,
 			  &ftrace_show_header_fops);
 
+	/* Event symbols */
+	trace_create_file("event_symbols", 0444, d_events,
+			  NULL, &ftrace_event_symbols_fops);
+
 	trace_create_file("enable", 0644, d_events,
 			  NULL, &ftrace_system_enable_fops);
 

