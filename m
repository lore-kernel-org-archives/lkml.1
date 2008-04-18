Return-Path: <linux-kernel-owner+w=401wt.eu-S964794AbYDRUKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbYDRUKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbYDRUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304AbYDRUIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:08:52 -0400
Message-Id: <20080418200850.596115914@goodmis.org>
References: <20080418200538.788522018@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 16:05:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: comment code
Content-Disposition: inline; filename=ftrace-comment-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first installment of adding documentation to the ftrace.
Expect many more patches of this kind in the near future.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h |    7 ++
 2 files changed, 141 insertions(+), 1 deletion(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-18 15:53:08.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-18 16:01:14.000000000 -0400
@@ -67,26 +67,79 @@ cycle_t ftrace_now(int cpu)
 	return cpu_clock(cpu);
 }
 
+/*
+ * The global_trace is the descriptor that holds the tracing
+ * buffers for the live tracing. For each CPU, it contains
+ * a link list of pages that will store trace entries. The
+ * page descriptor of the pages in the memory is used to hold
+ * the link list by linking the lru item in the page descriptor
+ * to each of the pages in the buffer per CPU.
+ *
+ * For each active CPU there is a data field that holds the
+ * pages for the buffer for that CPU. Each CPU has the same number
+ * of pages allocated for its buffer.
+ */
 static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
+/*
+ * The max_tr is used to snapshot the global_trace when a maximum
+ * latency is reached. Some tracers will use this to store a maximum
+ * trace while it continues examining live traces.
+ *
+ * The buffers for the max_tr are set up the same as the global_trace.
+ * When a snapshot is taken, the link list of the max_tr is swapped
+ * with the link list of the global_trace and the buffers are reset for
+ * the global_trace so the tracing can continue.
+ */
 static struct trace_array	max_tr;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
 
+/* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
+
+/*
+ * trace_nr_entries is the number of entries that is allocated
+ * for a buffer. Note, the number of entries is always rounded
+ * to ENTRIES_PER_PAGE.
+ */
 static unsigned long		trace_nr_entries = 65536UL;
 
+/* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
+
+/* current_trace points to the tracer that is currently active */
 static struct tracer		*current_trace __read_mostly;
+
+/*
+ * max_tracer_type_len is used to simplify the allocating of
+ * buffers to read userspace tracer names. We keep track of
+ * the longest tracer name registered.
+ */
 static int			max_tracer_type_len;
 
+/*
+ * trace_types_lock is used to protect the trace_types list.
+ * This lock is also used to keep user access serialized.
+ * Accesses from userspace will grab this lock while userspace
+ * activities happen inside the kernel.
+ */
 static DEFINE_MUTEX(trace_types_lock);
+
+/* trace_wait is a waitqueue for tasks blocked on trace_poll */
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
+/* trace_flags holds iter_ctrl options */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT;
 
+/**
+ * trace_wake_up - wake up tasks waiting for trace input
+ *
+ * Simply wakes up any task that is blocked on the trace_wait
+ * queue. These is used with trace_poll for tasks polling the trace.
+ */
 void trace_wake_up(void)
 {
 	/*
@@ -120,6 +173,14 @@ unsigned long nsecs_to_usecs(unsigned lo
 	return nsecs / 1000;
 }
 
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF	- interrupts were disabled
+ *  NEED_RESCED - reschedule is requested
+ *  HARDIRQ	- inside an interrupt handler
+ *  SOFTIRQ	- inside a softirq handler
+ */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_NEED_RESCHED		= 0x02,
@@ -127,10 +188,14 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x08,
 };
 
+/*
+ * TRACE_ITER_SYM_MASK masks the options in trace_flags that
+ * control the output of kernel symbols.
+ */
 #define TRACE_ITER_SYM_MASK \
 	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
 
-/* These must match the bit postions above */
+/* These must match the bit postions in trace_iterator_flags */
 static const char *trace_options[] = {
 	"print-parent",
 	"sym-offset",
@@ -145,6 +210,15 @@ static const char *trace_options[] = {
 	NULL
 };
 
+/*
+ * ftrace_max_lock is used to protect the swapping of buffers
+ * when taking a max snapshot. The buffers themselves are
+ * protected by per_cpu spinlocks. But the action of the swap
+ * needs its own lock.
+ *
+ * This is defined as a raw_spinlock_t in order to help
+ * with performance when lockdep debugging is enabled.
+ */
 static raw_spinlock_t ftrace_max_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
@@ -175,6 +249,13 @@ __update_max_tr(struct trace_array *tr, 
 	tracing_record_cmdline(current);
 }
 
+/**
+ * check_pages - integrity check of trace buffers
+ *
+ * As a safty measure we check to make sure the data pages have not
+ * been corrupted. TODO: configure to disable this because it adds
+ * a bit of overhead.
+ */
 void check_pages(struct trace_array_cpu *data)
 {
 	struct page *page, *tmp;
@@ -188,6 +269,13 @@ void check_pages(struct trace_array_cpu 
 	}
 }
 
+/**
+ * head_page - page address of the first page in per_cpu buffer.
+ *
+ * head_page returns the page address of the first page in
+ * a per_cpu buffer. This also preforms various consistency
+ * checks to make sure the buffer has not been corrupted.
+ */
 void *head_page(struct trace_array_cpu *data)
 {
 	struct page *page;
@@ -202,6 +290,17 @@ void *head_page(struct trace_array_cpu *
 	return page_address(page);
 }
 
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
 int
 trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
@@ -225,6 +324,16 @@ trace_seq_printf(struct trace_seq *s, co
 	return len;
 }
 
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
 static int
 trace_seq_puts(struct trace_seq *s, const char *str)
 {
@@ -320,6 +429,13 @@ trace_print_seq(struct seq_file *m, stru
 	trace_seq_reset(s);
 }
 
+/*
+ * flip the trace buffers between two trace descriptors.
+ * This usually is the buffers between the global_trace and
+ * the max_tr to record a snapshot of a current trace.
+ *
+ * The ftrace_max_lock must be held.
+ */
 static void
 flip_trace(struct trace_array_cpu *tr1, struct trace_array_cpu *tr2)
 {
@@ -341,6 +457,15 @@ flip_trace(struct trace_array_cpu *tr1, 
 	check_pages(tr2);
 }
 
+/**
+ * update_max_tr - snapshot all trace buffers from global_trace to max_tr
+ * @tr: tracer
+ * @tsk: the task with the latency
+ * @cpu: The cpu that initiated the trace.
+ *
+ * Flip the buffers between the @tr and the max_tr and record information
+ * about which task was the cause of this latency.
+ */
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
@@ -365,6 +490,8 @@ update_max_tr(struct trace_array *tr, st
  * @tr - tracer
  * @tsk - task with the latency
  * @cpu - the cpu of the buffer to copy.
+ *
+ * Flip the trace of a single CPU buffer between the @tr and the max_tr.
  */
 void
 update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
@@ -384,6 +511,12 @@ update_max_tr_single(struct trace_array 
 	__raw_spin_unlock(&ftrace_max_lock);
 }
 
+/**
+ * register_tracer - register a tracer with the ftrace system.
+ * @type - the plugin for the tracer
+ *
+ * Register a new plugin tracer.
+ */
 int register_tracer(struct tracer *type)
 {
 	struct tracer *t;
Index: linux-sched-devel.git/kernel/trace/trace.h
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.h	2008-04-18 15:47:22.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.h	2008-04-18 16:01:14.000000000 -0400
@@ -314,6 +314,13 @@ extern long ns2usecs(cycle_t nsec);
 
 extern unsigned long trace_flags;
 
+/*
+ * trace_iterator_flags is an enumeration that defines bit
+ * positions into trace_flags that controls the output.
+ *
+ * NOTE: These bits must match the trace_options array in
+ *       trace.c.
+ */
 enum trace_iterator_flags {
 	TRACE_ITER_PRINT_PARENT		= 0x01,
 	TRACE_ITER_SYM_OFFSET		= 0x02,

-- 
