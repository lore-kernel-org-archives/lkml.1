Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZFTQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZFTQxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZFTQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:53:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZFTQxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:53:15 -0400
Date: Sat, 20 Jun 2009 18:53:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090620165300.GA26119@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      tracing/urgent: fix unbalanced ftrace_start_up
      tracing/urgent: warn in case of ftrace_start_up inbalance

Li Zefan (6):
      tracing: fix a typo in tracing_cpumask_write()
      tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
      tracing/filters: operand can be negative
      tracing/filters: strloc should be unsigned short
      tracing/filters: free filter_string in destroy_preds()
      tracing/filters: fix race between filter setting and module unload

Rusty Russell (1):
      cpumask: use new operators in kernel/trace

Steven Rostedt (14):
      ring-buffer: prevent adding write in discarded area
      ring-buffer: have benchmark test handle discarded events
      ring-buffer: remove unused variable
      ring-buffer: use commit counters for commit pointer accounting
      tracing: update sample event documentation
      ring-buffer: use BUF_PAGE_HDR_SIZE in calculating index
      ring-buffer: remove useless warn on check
      ring-buffer: remove useless compile check for buffer_page size
      ring-buffer: check for less than two in size allocation
      ring-buffer: add locks around rb_per_cpu_empty
      ring-buffer: do not grab locks in nmi
      ring-buffer: have benchmark test print to trace buffer
      function-graph: disable when both x86_32 and optimize for size are configured
      function-graph: add stack frame test

Wu Zhangjin (1):
      tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h


 arch/powerpc/kernel/ftrace.c               |    2 +-
 arch/s390/kernel/ftrace.c                  |    2 +-
 arch/x86/Kconfig                           |    1 +
 arch/x86/kernel/entry_32.S                 |    2 +
 arch/x86/kernel/entry_64.S                 |    2 +
 arch/x86/kernel/ftrace.c                   |    6 +-
 include/linux/ftrace.h                     |    4 +-
 include/linux/trace_seq.h                  |    2 +
 kernel/trace/Kconfig                       |    8 +
 kernel/trace/ftrace.c                      |    7 +
 kernel/trace/kmemtrace.c                   |    2 +-
 kernel/trace/ring_buffer.c                 |  309 +++++++++++++++++-----------
 kernel/trace/ring_buffer_benchmark.c       |   45 +++--
 kernel/trace/trace.c                       |    8 +-
 kernel/trace/trace_events_filter.c         |   37 ++--
 kernel/trace/trace_functions.c             |    8 +-
 kernel/trace/trace_functions_graph.c       |   36 +++-
 samples/trace_events/Makefile              |    8 +
 samples/trace_events/trace-events-sample.h |   27 ++-
 19 files changed, 331 insertions(+), 185 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 2d182f1..58d6a61 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -605,7 +605,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth, 0) == -EBUSY) {
 		*parent = old;
 		return;
 	}
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 82ddfd3..3e298e6 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -190,7 +190,7 @@ unsigned long prepare_ftrace_return(unsigned long ip, unsigned long parent)
 		goto out;
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		goto out;
-	if (ftrace_push_return_trace(parent, ip, &trace.depth) == -EBUSY)
+	if (ftrace_push_return_trace(parent, ip, &trace.depth, 0) == -EBUSY)
 		goto out;
 	trace.func = ftrace_mcount_call_adjust(ip) & PSW_ADDR_INSN;
 	/* Only trace if the calling function expects to. */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 356d2ec..fcf12af 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -33,6 +33,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_FTRACE_SYSCALLS
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..0d4b285 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1154,6 +1154,7 @@ ENTRY(ftrace_graph_caller)
 	pushl %edx
 	movl 0xc(%esp), %edx
 	lea 0x4(%ebp), %eax
+	movl (%ebp), %ecx
 	subl $MCOUNT_INSN_SIZE, %edx
 	call prepare_ftrace_return
 	popl %edx
@@ -1168,6 +1169,7 @@ return_to_handler:
 	pushl %eax
 	pushl %ecx
 	pushl %edx
+	movl %ebp, %eax
 	call ftrace_return_to_handler
 	movl %eax, 0xc(%esp)
 	popl %edx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index de74f0a..c251be7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -135,6 +135,7 @@ ENTRY(ftrace_graph_caller)
 
 	leaq 8(%rbp), %rdi
 	movq 0x38(%rsp), %rsi
+	movq (%rbp), %rdx
 	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
@@ -150,6 +151,7 @@ GLOBAL(return_to_handler)
 	/* Save the return values */
 	movq %rax, (%rsp)
 	movq %rdx, 8(%rsp)
+	movq %rbp, %rdi
 
 	call ftrace_return_to_handler
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b79c553..d94e1ea 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -408,7 +408,8 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long frame_pointer)
 {
 	unsigned long old;
 	int faulted;
@@ -453,7 +454,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
+		    frame_pointer) == -EBUSY) {
 		*parent = old;
 		return;
 	}
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 39b95c5..dc3b132 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -362,6 +362,7 @@ struct ftrace_ret_stack {
 	unsigned long func;
 	unsigned long long calltime;
 	unsigned long long subtime;
+	unsigned long fp;
 };
 
 /*
@@ -372,7 +373,8 @@ struct ftrace_ret_stack {
 extern void return_to_handler(void);
 
 extern int
-ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth);
+ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
+			 unsigned long frame_pointer);
 
 /*
  * Sometimes we don't want to trace a function with the function
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c68bccb..c134dd1 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -3,6 +3,8 @@
 
 #include <linux/fs.h>
 
+#include <asm/page.h>
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE.
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 4a13e5a..b17ed87 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -18,6 +18,13 @@ config HAVE_FUNCTION_TRACER
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
 
+config HAVE_FUNCTION_GRAPH_FP_TEST
+	bool
+	help
+	 An arch may pass in a unique value (frame pointer) to both the
+	 entering and exiting of a function. On exit, the value is compared
+	 and if it does not match, then it will panic the kernel.
+
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
@@ -121,6 +128,7 @@ config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
+	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bb60732..3718d55 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1224,6 +1224,13 @@ static void ftrace_shutdown(int command)
 		return;
 
 	ftrace_start_up--;
+	/*
+	 * Just warn in case of unbalance, no need to kill ftrace, it's not
+	 * critical but the ftrace_call callers may be never nopped again after
+	 * further ftrace uses.
+	 */
+	WARN_ON_ONCE(ftrace_start_up < 0);
+
 	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 86cdf67..1edaa95 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -186,7 +186,7 @@ static int kmem_trace_init(struct trace_array *tr)
 	int cpu;
 	kmemtrace_array = tr;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
 
 	kmemtrace_start_probes();
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2e642b2..589b3ee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -205,6 +205,7 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+#define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
 
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
@@ -414,6 +415,8 @@ struct ring_buffer_per_cpu {
 	unsigned long			overrun;
 	unsigned long			read;
 	local_t				entries;
+	local_t				committing;
+	local_t				commits;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -617,12 +620,6 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 	kfree(cpu_buffer);
 }
 
-/*
- * Causes compile errors if the struct buffer_page gets bigger
- * than the struct page.
- */
-extern int ring_buffer_page_too_big(void);
-
 #ifdef CONFIG_HOTPLUG_CPU
 static int rb_cpu_notify(struct notifier_block *self,
 			 unsigned long action, void *hcpu);
@@ -645,11 +642,6 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	int bsize;
 	int cpu;
 
-	/* Paranoid! Optimizes out when all is well */
-	if (sizeof(struct buffer_page) > sizeof(struct page))
-		ring_buffer_page_too_big();
-
-
 	/* keep it in its own cache line */
 	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
 			 GFP_KERNEL);
@@ -665,8 +657,8 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->reader_lock_key = key;
 
 	/* need at least two pages */
-	if (buffer->pages == 1)
-		buffer->pages++;
+	if (buffer->pages < 2)
+		buffer->pages = 2;
 
 	/*
 	 * In case of non-hotplug cpu, if the ring-buffer is allocated
@@ -1010,12 +1002,12 @@ rb_event_index(struct ring_buffer_event *event)
 {
 	unsigned long addr = (unsigned long)event;
 
-	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+	return (addr & ~PAGE_MASK) - BUF_PAGE_HDR_SIZE;
 }
 
 static inline int
-rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
-	     struct ring_buffer_event *event)
+rb_event_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
+		   struct ring_buffer_event *event)
 {
 	unsigned long addr = (unsigned long)event;
 	unsigned long index;
@@ -1028,31 +1020,6 @@ rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static void
-rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
-		    struct ring_buffer_event *event)
-{
-	unsigned long addr = (unsigned long)event;
-	unsigned long index;
-
-	index = rb_event_index(event);
-	addr &= PAGE_MASK;
-
-	while (cpu_buffer->commit_page->page != (void *)addr) {
-		if (RB_WARN_ON(cpu_buffer,
-			  cpu_buffer->commit_page == cpu_buffer->tail_page))
-			return;
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
-		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
-		cpu_buffer->write_stamp =
-			cpu_buffer->commit_page->page->time_stamp;
-	}
-
-	/* Now set the commit to the event's index */
-	local_set(&cpu_buffer->commit_page->page->commit, index);
-}
-
-static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	/*
@@ -1170,6 +1137,59 @@ static unsigned rb_calculate_event_length(unsigned length)
 	return length;
 }
 
+static inline void
+rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
+	      struct buffer_page *tail_page,
+	      unsigned long tail, unsigned long length)
+{
+	struct ring_buffer_event *event;
+
+	/*
+	 * Only the event that crossed the page boundary
+	 * must fill the old tail_page with padding.
+	 */
+	if (tail >= BUF_PAGE_SIZE) {
+		local_sub(length, &tail_page->write);
+		return;
+	}
+
+	event = __rb_page_index(tail_page, tail);
+
+	/*
+	 * If this event is bigger than the minimum size, then
+	 * we need to be careful that we don't subtract the
+	 * write counter enough to allow another writer to slip
+	 * in on this page.
+	 * We put in a discarded commit instead, to make sure
+	 * that this space is not used again.
+	 *
+	 * If we are less than the minimum size, we don't need to
+	 * worry about it.
+	 */
+	if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE)) {
+		/* No room for any events */
+
+		/* Mark the rest of the page with padding */
+		rb_event_set_padding(event);
+
+		/* Set the write back to the previous setting */
+		local_sub(length, &tail_page->write);
+		return;
+	}
+
+	/* Put in a discarded event */
+	event->array[0] = (BUF_PAGE_SIZE - tail) - RB_EVNT_HDR_SIZE;
+	event->type_len = RINGBUF_TYPE_PADDING;
+	/* time delta must be non zero */
+	event->time_delta = 1;
+	/* Account for this as an entry */
+	local_inc(&tail_page->entries);
+	local_inc(&cpu_buffer->entries);
+
+	/* Set write to end of buffer */
+	length = (tail + length) - BUF_PAGE_SIZE;
+	local_sub(length, &tail_page->write);
+}
 
 static struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
@@ -1179,7 +1199,6 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
-	struct ring_buffer_event *event;
 	bool lock_taken = false;
 	unsigned long flags;
 
@@ -1264,26 +1283,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		cpu_buffer->tail_page->page->time_stamp = *ts;
 	}
 
-	/*
-	 * The actual tail page has moved forward.
-	 */
-	if (tail < BUF_PAGE_SIZE) {
-		/* Mark the rest of the page with padding */
-		event = __rb_page_index(tail_page, tail);
-		rb_event_set_padding(event);
-	}
-
-	/* Set the write back to the previous setting */
-	local_sub(length, &tail_page->write);
-
-	/*
-	 * If this was a commit entry that failed,
-	 * increment that too
-	 */
-	if (tail_page == cpu_buffer->commit_page &&
-	    tail == rb_commit_index(cpu_buffer)) {
-		rb_set_commit_to_write(cpu_buffer);
-	}
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	__raw_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
@@ -1293,7 +1293,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
  out_reset:
 	/* reset write */
-	local_sub(length, &tail_page->write);
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	if (likely(lock_taken))
 		__raw_spin_unlock(&cpu_buffer->lock);
@@ -1323,9 +1323,6 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* We reserved something on the buffer */
 
-	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
-		return NULL;
-
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
@@ -1334,11 +1331,11 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		local_inc(&tail_page->entries);
 
 	/*
-	 * If this is a commit and the tail is zero, then update
-	 * this page's time stamp.
+	 * If this is the first commit on the page, then update
+	 * its timestamp.
 	 */
-	if (!tail && rb_is_commit(cpu_buffer, event))
-		cpu_buffer->commit_page->page->time_stamp = *ts;
+	if (!tail)
+		tail_page->page->time_stamp = *ts;
 
 	return event;
 }
@@ -1407,16 +1404,16 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		return -EAGAIN;
 
 	/* Only a commited time event can update the write stamp */
-	if (rb_is_commit(cpu_buffer, event)) {
+	if (rb_event_is_commit(cpu_buffer, event)) {
 		/*
-		 * If this is the first on the page, then we need to
-		 * update the page itself, and just put in a zero.
+		 * If this is the first on the page, then it was
+		 * updated with the page itself. Try to discard it
+		 * and if we can't just make it zero.
 		 */
 		if (rb_event_index(event)) {
 			event->time_delta = *delta & TS_MASK;
 			event->array[0] = *delta >> TS_SHIFT;
 		} else {
-			cpu_buffer->commit_page->page->time_stamp = *ts;
 			/* try to discard, since we do not need this */
 			if (!rb_try_to_discard(cpu_buffer, event)) {
 				/* nope, just zero it */
@@ -1442,6 +1439,44 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	return ret;
 }
 
+static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	local_inc(&cpu_buffer->committing);
+	local_inc(&cpu_buffer->commits);
+}
+
+static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	unsigned long commits;
+
+	if (RB_WARN_ON(cpu_buffer,
+		       !local_read(&cpu_buffer->committing)))
+		return;
+
+ again:
+	commits = local_read(&cpu_buffer->commits);
+	/* synchronize with interrupts */
+	barrier();
+	if (local_read(&cpu_buffer->committing) == 1)
+		rb_set_commit_to_write(cpu_buffer);
+
+	local_dec(&cpu_buffer->committing);
+
+	/* synchronize with interrupts */
+	barrier();
+
+	/*
+	 * Need to account for interrupts coming in between the
+	 * updating of the commit page and the clearing of the
+	 * committing counter.
+	 */
+	if (unlikely(local_read(&cpu_buffer->commits) != commits) &&
+	    !local_read(&cpu_buffer->committing)) {
+		local_inc(&cpu_buffer->committing);
+		goto again;
+	}
+}
+
 static struct ring_buffer_event *
 rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
@@ -1451,6 +1486,8 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	int commit = 0;
 	int nr_loops = 0;
 
+	rb_start_commit(cpu_buffer);
+
 	length = rb_calculate_event_length(length);
  again:
 	/*
@@ -1463,7 +1500,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * Bail!
 	 */
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
-		return NULL;
+		goto out_fail;
 
 	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
 
@@ -1494,7 +1531,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
 			if (commit == -EBUSY)
-				return NULL;
+				goto out_fail;
 
 			if (commit == -EAGAIN)
 				goto again;
@@ -1508,28 +1545,19 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
-	if (!event) {
-		if (unlikely(commit))
-			/*
-			 * Ouch! We needed a timestamp and it was commited. But
-			 * we didn't get our event reserved.
-			 */
-			rb_set_commit_to_write(cpu_buffer);
-		return NULL;
-	}
+	if (!event)
+		goto out_fail;
 
-	/*
-	 * If the timestamp was commited, make the commit our entry
-	 * now so that we will update it when needed.
-	 */
-	if (unlikely(commit))
-		rb_set_commit_event(cpu_buffer, event);
-	else if (!rb_is_commit(cpu_buffer, event))
+	if (!rb_event_is_commit(cpu_buffer, event))
 		delta = 0;
 
 	event->time_delta = delta;
 
 	return event;
+
+ out_fail:
+	rb_end_commit(cpu_buffer);
+	return NULL;
 }
 
 #define TRACE_RECURSIVE_DEPTH 16
@@ -1639,13 +1667,14 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	local_inc(&cpu_buffer->entries);
 
-	/* Only process further if we own the commit */
-	if (!rb_is_commit(cpu_buffer, event))
-		return;
-
-	cpu_buffer->write_stamp += event->time_delta;
+	/*
+	 * The event first in the commit queue updates the
+	 * time stamp.
+	 */
+	if (rb_event_is_commit(cpu_buffer, event))
+		cpu_buffer->write_stamp += event->time_delta;
 
-	rb_set_commit_to_write(cpu_buffer);
+	rb_end_commit(cpu_buffer);
 }
 
 /**
@@ -1734,15 +1763,15 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	/* The event is discarded regardless */
 	rb_event_discard(event);
 
+	cpu = smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
 	/*
 	 * This must only be called if the event has not been
 	 * committed yet. Thus we can assume that preemption
 	 * is still disabled.
 	 */
-	RB_WARN_ON(buffer, preemptible());
-
-	cpu = smp_processor_id();
-	cpu_buffer = buffer->buffers[cpu];
+	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
 	if (!rb_try_to_discard(cpu_buffer, event))
 		goto out;
@@ -1753,13 +1782,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	local_inc(&cpu_buffer->entries);
  out:
-	/*
-	 * If a write came in and pushed the tail page
-	 * we still need to update the commit pointer
-	 * if we were the commit.
-	 */
-	if (rb_is_commit(cpu_buffer, event))
-		rb_set_commit_to_write(cpu_buffer);
+	rb_end_commit(cpu_buffer);
 
 	trace_recursive_unlock();
 
@@ -2443,6 +2466,21 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_peek);
 
+static inline int rb_ok_to_lock(void)
+{
+	/*
+	 * If an NMI die dumps out the content of the ring buffer
+	 * do not grab locks. We also permanently disable the ring
+	 * buffer too. A one time deal is all you get from reading
+	 * the ring buffer from an NMI.
+	 */
+	if (likely(!in_nmi() && !oops_in_progress))
+		return 1;
+
+	tracing_off_permanent();
+	return 0;
+}
+
 /**
  * ring_buffer_peek - peek at the next event to be read
  * @buffer: The ring buffer to read
@@ -2458,14 +2496,20 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
 	unsigned long flags;
+	int dolock;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
+	dolock = rb_ok_to_lock();
  again:
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(buffer, cpu, ts);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
@@ -2517,6 +2561,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
+	int dolock;
+
+	dolock = rb_ok_to_lock();
 
  again:
 	/* might be called in atomic */
@@ -2526,7 +2573,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
 	if (!event)
@@ -2535,7 +2584,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	rb_advance_reader(cpu_buffer);
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
  out:
 	preempt_enable();
@@ -2677,6 +2728,8 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->overrun = 0;
 	cpu_buffer->read = 0;
 	local_set(&cpu_buffer->entries, 0);
+	local_set(&cpu_buffer->committing, 0);
+	local_set(&cpu_buffer->commits, 0);
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -2731,12 +2784,25 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset);
 int ring_buffer_empty(struct ring_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+	int dolock;
 	int cpu;
+	int ret;
+
+	dolock = rb_ok_to_lock();
 
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		if (!rb_per_cpu_empty(cpu_buffer))
+		local_irq_save(flags);
+		if (dolock)
+			spin_lock(&cpu_buffer->reader_lock);
+		ret = rb_per_cpu_empty(cpu_buffer);
+		if (dolock)
+			spin_unlock(&cpu_buffer->reader_lock);
+		local_irq_restore(flags);
+
+		if (!ret)
 			return 0;
 	}
 
@@ -2752,14 +2818,23 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+	int dolock;
 	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
+	dolock = rb_ok_to_lock();
+
 	cpu_buffer = buffer->buffers[cpu];
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 	ret = rb_per_cpu_empty(cpu_buffer);
-
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
 	return ret;
 }
@@ -3105,7 +3180,7 @@ static int rb_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (cpu_isset(cpu, *buffer->cpumask))
+		if (cpumask_test_cpu(cpu, buffer->cpumask))
 			return NOTIFY_OK;
 
 		buffer->buffers[cpu] =
@@ -3116,7 +3191,7 @@ static int rb_cpu_notify(struct notifier_block *self,
 			return NOTIFY_OK;
 		}
 		smp_wmb();
-		cpu_set(cpu, *buffer->cpumask);
+		cpumask_set_cpu(cpu, buffer->cpumask);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 8d68e14..573d3cc 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -102,8 +102,10 @@ static enum event_status read_page(int cpu)
 			event = (void *)&rpage->data[i];
 			switch (event->type_len) {
 			case RINGBUF_TYPE_PADDING:
-				/* We don't expect any padding */
-				KILL_TEST();
+				/* failed writes may be discarded events */
+				if (!event->time_delta)
+					KILL_TEST();
+				inc = event->array[0] + 4;
 				break;
 			case RINGBUF_TYPE_TIME_EXTEND:
 				inc = 8;
@@ -119,7 +121,7 @@ static enum event_status read_page(int cpu)
 					KILL_TEST();
 					break;
 				}
-				inc = event->array[0];
+				inc = event->array[0] + 4;
 				break;
 			default:
 				entry = ring_buffer_event_data(event);
@@ -201,7 +203,7 @@ static void ring_buffer_producer(void)
 	 * Hammer the buffer for 10 secs (this may
 	 * make the system stall)
 	 */
-	pr_info("Starting ring buffer hammer\n");
+	trace_printk("Starting ring buffer hammer\n");
 	do_gettimeofday(&start_tv);
 	do {
 		struct ring_buffer_event *event;
@@ -237,7 +239,7 @@ static void ring_buffer_producer(void)
 #endif
 
 	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
-	pr_info("End ring buffer hammer\n");
+	trace_printk("End ring buffer hammer\n");
 
 	if (consumer) {
 		/* Init both completions here to avoid races */
@@ -260,49 +262,50 @@ static void ring_buffer_producer(void)
 	overruns = ring_buffer_overruns(buffer);
 
 	if (kill_test)
-		pr_info("ERROR!\n");
-	pr_info("Time:     %lld (usecs)\n", time);
-	pr_info("Overruns: %lld\n", overruns);
+		trace_printk("ERROR!\n");
+	trace_printk("Time:     %lld (usecs)\n", time);
+	trace_printk("Overruns: %lld\n", overruns);
 	if (disable_reader)
-		pr_info("Read:     (reader disabled)\n");
+		trace_printk("Read:     (reader disabled)\n");
 	else
-		pr_info("Read:     %ld  (by %s)\n", read,
+		trace_printk("Read:     %ld  (by %s)\n", read,
 			read_events ? "events" : "pages");
-	pr_info("Entries:  %lld\n", entries);
-	pr_info("Total:    %lld\n", entries + overruns + read);
-	pr_info("Missed:   %ld\n", missed);
-	pr_info("Hit:      %ld\n", hit);
+	trace_printk("Entries:  %lld\n", entries);
+	trace_printk("Total:    %lld\n", entries + overruns + read);
+	trace_printk("Missed:   %ld\n", missed);
+	trace_printk("Hit:      %ld\n", hit);
 
 	/* Convert time from usecs to millisecs */
 	do_div(time, USEC_PER_MSEC);
 	if (time)
 		hit /= (long)time;
 	else
-		pr_info("TIME IS ZERO??\n");
+		trace_printk("TIME IS ZERO??\n");
 
-	pr_info("Entries per millisec: %ld\n", hit);
+	trace_printk("Entries per millisec: %ld\n", hit);
 
 	if (hit) {
 		/* Calculate the average time in nanosecs */
 		avg = NSEC_PER_MSEC / hit;
-		pr_info("%ld ns per entry\n", avg);
+		trace_printk("%ld ns per entry\n", avg);
 	}
 
 	if (missed) {
 		if (time)
 			missed /= (long)time;
 
-		pr_info("Total iterations per millisec: %ld\n", hit + missed);
+		trace_printk("Total iterations per millisec: %ld\n",
+			     hit + missed);
 
 		/* it is possible that hit + missed will overflow and be zero */
 		if (!(hit + missed)) {
-			pr_info("hit + missed overflowed and totalled zero!\n");
+			trace_printk("hit + missed overflowed and totalled zero!\n");
 			hit--; /* make it non zero */
 		}
 
 		/* Caculate the average time in nanosecs */
 		avg = NSEC_PER_MSEC / (hit + missed);
-		pr_info("%ld ns per entry\n", avg);
+		trace_printk("%ld ns per entry\n", avg);
 	}
 }
 
@@ -353,7 +356,7 @@ static int ring_buffer_producer_thread(void *arg)
 
 		ring_buffer_producer();
 
-		pr_info("Sleeping for 10 secs\n");
+		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ * SLEEP_TIME);
 		__set_current_state(TASK_RUNNING);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8acd9b8..0f57f1b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2191,11 +2191,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 
-	mutex_lock(&tracing_cpumask_update_lock);
 	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
+	mutex_lock(&tracing_cpumask_update_lock);
+
 	local_irq_disable();
 	__raw_spin_lock(&ftrace_max_lock);
 	for_each_tracing_cpu(cpu) {
@@ -2223,8 +2224,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	return count;
 
 err_unlock:
-	mutex_unlock(&tracing_cpumask_update_lock);
-	free_cpumask_var(tracing_cpumask);
+	free_cpumask_var(tracing_cpumask_new);
 
 	return err;
 }
@@ -3627,7 +3627,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_seq *s;
 	unsigned long cnt;
 
-	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return ENOMEM;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index db6e54b..936c621 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -27,8 +27,6 @@
 #include "trace.h"
 #include "trace_output.h"
 
-static DEFINE_MUTEX(filter_mutex);
-
 enum filter_op_ids
 {
 	OP_OR,
@@ -178,7 +176,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 static int filter_pred_strloc(struct filter_pred *pred, void *event,
 			      int val1, int val2)
 {
-	int str_loc = *(int *)(event + pred->offset);
+	unsigned short str_loc = *(unsigned short *)(event + pred->offset);
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
@@ -294,12 +292,12 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	struct event_filter *filter = call->filter;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 	if (filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 }
 
 void print_subsystem_event_filter(struct event_subsystem *system,
@@ -307,12 +305,12 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 {
 	struct event_filter *filter = system->filter;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 	if (filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 }
 
 static struct ftrace_event_field *
@@ -381,6 +379,7 @@ void destroy_preds(struct ftrace_event_call *call)
 			filter_free_pred(filter->preds[i]);
 	}
 	kfree(filter->preds);
+	kfree(filter->filter_string);
 	kfree(filter);
 	call->filter = NULL;
 }
@@ -433,7 +432,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 		filter->n_preds = 0;
 	}
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
@@ -443,7 +441,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 			remove_filter_string(call->filter);
 		}
 	}
-	mutex_unlock(&event_mutex);
 }
 
 static int filter_add_pred_fn(struct filter_parse_state *ps,
@@ -546,6 +543,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	filter_pred_fn_t fn;
 	unsigned long long val;
 	int string_type;
+	int ret;
 
 	pred->fn = filter_pred_none;
 
@@ -581,7 +579,11 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			pred->not = 1;
 		return filter_add_pred_fn(ps, call, pred, fn);
 	} else {
-		if (strict_strtoull(pred->str_val, 0, &val)) {
+		if (field->is_signed)
+			ret = strict_strtoll(pred->str_val, 0, &val);
+		else
+			ret = strict_strtoull(pred->str_val, 0, &val);
+		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
 		}
@@ -625,7 +627,6 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 	filter->preds[filter->n_preds] = pred;
 	filter->n_preds++;
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->define_fields)
@@ -636,14 +637,12 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 
 		err = filter_add_pred(ps, call, pred);
 		if (err) {
-			mutex_unlock(&event_mutex);
 			filter_free_subsystem_preds(system);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			goto out;
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
-	mutex_unlock(&event_mutex);
 out:
 	return err;
 }
@@ -1070,12 +1069,12 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	struct filter_parse_state *ps;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable_preds(call);
 		remove_filter_string(call->filter);
-		mutex_unlock(&filter_mutex);
+		mutex_unlock(&event_mutex);
 		return 0;
 	}
 
@@ -1103,7 +1102,7 @@ out:
 	postfix_clear(ps);
 	kfree(ps);
 out_unlock:
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 
 	return err;
 }
@@ -1115,12 +1114,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	struct filter_parse_state *ps;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
-		mutex_unlock(&filter_mutex);
+		mutex_unlock(&event_mutex);
 		return 0;
 	}
 
@@ -1148,7 +1147,7 @@ out:
 	postfix_clear(ps);
 	kfree(ps);
 out_unlock:
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 
 	return err;
 }
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c9a0b7d..90f1347 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -193,9 +193,11 @@ static void tracing_start_function_trace(void)
 static void tracing_stop_function_trace(void)
 {
 	ftrace_function_enabled = 0;
-	/* OK if they are not registered */
-	unregister_ftrace_function(&trace_stack_ops);
-	unregister_ftrace_function(&trace_ops);
+
+	if (func_flags.val & TRACE_FUNC_OPT_STACK)
+		unregister_ftrace_function(&trace_stack_ops);
+	else
+		unregister_ftrace_function(&trace_ops);
 }
 
 static int func_set_flag(u32 old_flags, u32 bit, int set)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8b59241..d2249ab 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -57,7 +57,8 @@ static struct tracer_flags tracer_flags = {
 
 /* Add a function return address to the trace stack on thread info.*/
 int
-ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
+ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
+			 unsigned long frame_pointer)
 {
 	unsigned long long calltime;
 	int index;
@@ -85,6 +86,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 	current->ret_stack[index].func = func;
 	current->ret_stack[index].calltime = calltime;
 	current->ret_stack[index].subtime = 0;
+	current->ret_stack[index].fp = frame_pointer;
 	*depth = index;
 
 	return 0;
@@ -92,7 +94,8 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 
 /* Retrieve a function return address to the trace stack on thread info.*/
 static void
-ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
+ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
+			unsigned long frame_pointer)
 {
 	int index;
 
@@ -106,6 +109,31 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 		return;
 	}
 
+#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
+	/*
+	 * The arch may choose to record the frame pointer used
+	 * and check it here to make sure that it is what we expect it
+	 * to be. If gcc does not set the place holder of the return
+	 * address in the frame pointer, and does a copy instead, then
+	 * the function graph trace will fail. This test detects this
+	 * case.
+	 *
+	 * Currently, x86_32 with optimize for size (-Os) makes the latest
+	 * gcc do the above.
+	 */
+	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
+		ftrace_graph_stop();
+		WARN(1, "Bad frame pointer: expected %lx, received %lx\n"
+		     "  from func %pF return to %lx\n",
+		     current->ret_stack[index].fp,
+		     frame_pointer,
+		     (void *)current->ret_stack[index].func,
+		     current->ret_stack[index].ret);
+		*ret = (unsigned long)panic;
+		return;
+	}
+#endif
+
 	*ret = current->ret_stack[index].ret;
 	trace->func = current->ret_stack[index].func;
 	trace->calltime = current->ret_stack[index].calltime;
@@ -117,12 +145,12 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
  * Send the trace to the ring-buffer.
  * @return the original return address.
  */
-unsigned long ftrace_return_to_handler(void)
+unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 {
 	struct ftrace_graph_ret trace;
 	unsigned long ret;
 
-	ftrace_pop_return_trace(&trace, &ret);
+	ftrace_pop_return_trace(&trace, &ret, frame_pointer);
 	trace.rettime = trace_clock_local();
 	ftrace_graph_return(&trace);
 	barrier();
diff --git a/samples/trace_events/Makefile b/samples/trace_events/Makefile
index 0d428dc..0f8d921 100644
--- a/samples/trace_events/Makefile
+++ b/samples/trace_events/Makefile
@@ -1,6 +1,14 @@
 # builds the trace events example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
+# If you include a trace header outside of include/trace/events
+# then the file that does the #define CREATE_TRACE_POINTS must
+# have that tracer file in its main search path. This is because
+# define_trace.h will include it, and must be able to find it from
+# the include/trace directory.
+#
+# Here trace-events-sample.c does the CREATE_TRACE_POINTS.
+#
 CFLAGS_trace-events-sample.o := -I$(src)
 
 obj-$(CONFIG_SAMPLE_TRACE_EVENTS) += trace-events-sample.o
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 128a897..9977a75 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -19,16 +19,21 @@
  * If TRACE_SYSTEM is defined, that will be the directory created
  * in the ftrace directory under /debugfs/tracing/events/<system>
  *
- * The define_trace.h belowe will also look for a file name of
+ * The define_trace.h below will also look for a file name of
  * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
+ * In this case, it would look for sample.h
  *
- * If you want a different system than file name, you can override
- * the header name by defining TRACE_INCLUDE_FILE
+ * If the header name will be different than the system name
+ * (as in this case), then you can override the header name that
+ * define_trace.h will look up by defining TRACE_INCLUDE_FILE
  *
- * If this file was called, goofy.h, then we would define:
+ * This file is called trace-events-sample.h but we want the system
+ * to be called "sample". Therefore we must define the name of this
+ * file:
  *
- * #define TRACE_INCLUDE_FILE goofy
+ * #define TRACE_INCLUDE_FILE trace-events-sample
  *
+ * As we do an the bottom of this file.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sample
@@ -99,13 +104,13 @@ TRACE_EVENT(foo_bar,
  *
  * #define TRACE_INCLUDE_PATH ../../samples/trace_events
  *
- * But I chose to simply make it use the current directory and then in
- * the Makefile I added:
+ * But the safest and easiest way to simply make it use the directory
+ * that the file is in is to add in the Makefile:
  *
- * CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+ * CFLAGS_trace-events-sample.o := -I$(src)
  *
  * This will make sure the current path is part of the include
- * structure for our file so that we can find it.
+ * structure for our file so that define_trace.h can find it.
  *
  * I could have made only the top level directory the include:
  *
@@ -115,8 +120,8 @@ TRACE_EVENT(foo_bar,
  *
  * #define TRACE_INCLUDE_PATH samples/trace_events
  *
- * But then if something defines "samples" or "trace_events" then we
- * could risk that being converted too, and give us an unexpected
+ * But then if something defines "samples" or "trace_events" as a macro
+ * then we could risk that being converted too, and give us an unexpected
  * result.
  */
 #undef TRACE_INCLUDE_PATH
