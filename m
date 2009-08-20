Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZHTMAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZHTMAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZHTMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:00:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZHTMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:00:13 -0400
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1250690853.8282.59.camel@twins>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.728070630@chello.nl>  <1250690853.8282.59.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Aug 2009 14:00:06 +0200
Message-Id: <1250769606.8282.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 16:07 +0200, Peter Zijlstra wrote:
> On Wed, 2009-08-19 at 11:18 +0200, Peter Zijlstra wrote:
> 
> > +static inline bool perf_paranoid_anon(void)
> > +{
> > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
> >  }
> >  
> >  static inline bool perf_paranoid_kernel(void)
> >  {
> > -	return sysctl_perf_counter_paranoid > 1;
> > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 2;
> > +}
> 
> OK, this is buggy:
> 
>  - capable() uses current, which is unlikely to be counter->owner,
>  - but even security_real_capable(counter->owner, ...) wouldn't
>    work, since the ->capable() callback isn't NMI safe
>    (selinux takes locks and does allocations in that path).
> 
> This puts a severe strain on more complex anonymizers since its
> basically impossible to tell if counter->owner has permissions on
> current from NMI context.
> 
> I'll fix up this patch to pre-compute the perf_paranoid_anon_ip() per
> counter based on creation time state, unless somebody has a better idea.
> 
> I could possibly only anonymize IRQ context (SoftIRQ context is
> difficult since in_softirq() means both in-softirq and
> softirq-disabled).

Something like the below maybe.. its 3 patches folded and I've no clue
how to adapt the ppc code, what do people think?

compile tested on x86-64 only.

---
 arch/x86/include/asm/stacktrace.h  |   14 +++++--
 arch/x86/kernel/cpu/perf_counter.c |   66 +++++++++++++++++++++++++++++++----
 arch/x86/kernel/dumpstack.c        |   10 +++--
 arch/x86/kernel/dumpstack_32.c     |    8 +----
 arch/x86/kernel/dumpstack_64.c     |   13 ++-----
 arch/x86/kernel/stacktrace.c       |    8 +++--
 arch/x86/oprofile/backtrace.c      |    5 ++-
 include/linux/perf_counter.h       |    5 ++-
 kernel/perf_counter.c              |   30 ++++++++++++----
 kernel/trace/trace_sysprof.c       |    5 ++-
 10 files changed, 117 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index cf86a5e..7066caa 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -3,17 +3,23 @@
 
 extern int kstack_depth_to_print;
 
-int x86_is_stack_id(int id, char *name);
-
 /* Generic stack tracer with callbacks */
 
+enum stack_type {
+	STACK_UNKNOWN	= -1,
+	STACK_PROCESS   = 0,
+	STACK_INTERRUPT = 1,
+	STACK_EXCEPTION = 2,
+};
+
 struct stacktrace_ops {
 	void (*warning)(void *data, char *msg);
 	/* msg must contain %s for the symbol */
 	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
-	void (*address)(void *data, unsigned long address, int reliable);
+	void (*address)(void *data, unsigned long stack,
+			unsigned long address, int reliable);
 	/* On negative return stop dumping */
-	int (*stack)(void *data, char *name);
+	int (*stack)(void *data, int type, char *name);
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 396e35d..a6ddb3b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -2108,7 +2108,7 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, nmi_entry);
-static DEFINE_PER_CPU(int, in_nmi_frame);
+static DEFINE_PER_CPU(int, skip_frame);
 
 
 static void
@@ -2122,21 +2122,49 @@ static void backtrace_warning(void *data, char *msg)
 	/* Ignore warnings */
 }
 
-static int backtrace_stack(void *data, char *name)
+static int backtrace_stack(void *data, int type, char *name)
 {
-	per_cpu(in_nmi_frame, smp_processor_id()) =
-			x86_is_stack_id(NMI_STACK, name);
+	struct perf_callchain_entry *entry = data;
+	int skip = 0;
+
+	/*
+	 * Always skip exception (NMI) context
+	 */
+	if (type == STACK_EXCEPTION)
+		skip = 1;
+
+	/*
+	 * If we're restricted, don't show IRQ context
+	 */
+	if (entry->restricted && type == STACK_INTERRUPT)
+		skip = 1;
+
+	__get_cpu_var(skip_frame) = skip;
 
 	return 0;
 }
 
-static void backtrace_address(void *data, unsigned long addr, int reliable)
+static void backtrace_address(void *data, unsigned long stack,
+			      unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (per_cpu(in_nmi_frame, smp_processor_id()))
+	if (__get_cpu_var(skip_frame))
 		return;
 
+#ifdef CONFIG_4KSTACKS
+	if (entry->restricted) {
+		struct thread_info *tinfo = current_thread_info();
+		unsigned long task_stack = (unsigned long)tinfo;
+
+		/*
+		 * If its not on the task stack, don't show it.
+		 */
+		if (stack < task_stack || stack >= task_stack + PAGE_SIZE)
+			return;
+	}
+#endif
+
 	if (reliable)
 		callchain_store(entry, addr);
 }
@@ -2153,8 +2181,28 @@ static const struct stacktrace_ops backtrace_ops = {
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
+	int irq = hardirq_count() - (in_nmi() ? 0 : HARDIRQ_OFFSET);
+
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
-	callchain_store(entry, regs->ip);
+	if (entry->restricted && !irq)
+		callchain_store(entry, regs->ip);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * i386 is a friggin mess, 4KSTACKS makes it somewhat saner but
+	 * still don't have a way to identify NMI entries as they are
+	 * nested onto whatever stack is there.
+	 *
+	 * So until i386 starts using per context stacks unconditionally
+	 * and fixed up the unwinder (dump_trace behaves differently between
+	 * i386 and x86_64), we'll have to unconditionally truncate kernel
+	 * stacks that have IRQ context bits in them.
+	 */
+#ifndef CONFIG_4KSTACKS
+	if (irq)
+		return;
+#endif
+#endif
 
 	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
@@ -2255,7 +2303,8 @@ perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		perf_callchain_user(regs, entry);
 }
 
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+struct perf_callchain_entry *
+perf_callchain(struct perf_counter *counter, struct pt_regs *regs)
 {
 	struct perf_callchain_entry *entry;
 
@@ -2265,6 +2314,7 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 		entry = &__get_cpu_var(irq_entry);
 
 	entry->nr = 0;
+	entry->restricted = counter->restricted;
 
 	perf_do_callchain(regs, entry);
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2d8a371..978ae89 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -51,7 +51,7 @@ print_ftrace_graph_addr(unsigned long addr, void *data,
 	index -= *graph;
 	ret_addr = task->ret_stack[index].ret;
 
-	ops->address(data, ret_addr, 1);
+	ops->address(data, 0, ret_addr, 1);
 
 	(*graph)++;
 }
@@ -96,12 +96,14 @@ print_context_stack(struct thread_info *tinfo,
 
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + sizeof(long)) {
-				ops->address(data, addr, 1);
+			unsigned long stk = (unsigned long)stack;
+
+			if (stk == bp + sizeof(long)) {
+				ops->address(data, stk, addr, 1);
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
 			} else {
-				ops->address(data, addr, 0);
+				ops->address(data, stk, addr, 0);
 			}
 			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 		}
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index bca5fba..be633ed 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -19,12 +19,6 @@
 
 #include "dumpstack.h"
 
-/* Just a stub for now */
-int x86_is_stack_id(int id, char *name)
-{
-	return 0;
-}
-
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
@@ -64,7 +58,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
 			break;
-		if (ops->stack(data, "IRQ") < 0)
+		if (ops->stack(data, STACK_UNKNOWN, "IRQ") < 0)
 			break;
 		touch_nmi_watchdog();
 	}
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 54b0a32..9309c5c 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -32,11 +32,6 @@ static char x86_stack_ids[][8] = {
 #endif
 	};
 
-int x86_is_stack_id(int id, char *name)
-{
-	return x86_stack_ids[id - 1] == name;
-}
-
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 					unsigned *usedp, char **idp)
 {
@@ -155,12 +150,12 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 						&used, &id);
 
 		if (estack_end) {
-			if (ops->stack(data, id) < 0)
+			if (ops->stack(data, STACK_EXCEPTION, id) < 0)
 				break;
 
 			bp = print_context_stack(tinfo, stack, bp, ops,
 						 data, estack_end, &graph);
-			ops->stack(data, "<EOE>");
+			ops->stack(data, STACK_PROCESS, "<EOE>");
 			/*
 			 * We link to the next stack via the
 			 * second-to-last pointer (index -2 to end) in the
@@ -175,7 +170,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
 
 			if (stack >= irq_stack && stack < irq_stack_end) {
-				if (ops->stack(data, "IRQ") < 0)
+				if (ops->stack(data, STACK_INTERRUPT, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
 					ops, data, irq_stack_end, &graph);
@@ -186,7 +181,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				 */
 				stack = (unsigned long *) (irq_stack_end[-1]);
 				irq_stack_end = NULL;
-				ops->stack(data, "EOI");
+				ops->stack(data, STACK_PROCESS, "EOI");
 				continue;
 			}
 		}
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c3eb207..a1415f4 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -18,12 +18,13 @@ save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
 }
 
-static int save_stack_stack(void *data, char *name)
+static int save_stack_stack(void *data, int type, char *name)
 {
 	return 0;
 }
 
-static void save_stack_address(void *data, unsigned long addr, int reliable)
+static void save_stack_address(void *data, unsigned long stack,
+			       unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = data;
 	if (!reliable)
@@ -37,7 +38,8 @@ static void save_stack_address(void *data, unsigned long addr, int reliable)
 }
 
 static void
-save_stack_address_nosched(void *data, unsigned long addr, int reliable)
+save_stack_address_nosched(void *data, unsigned long stack,
+			   unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = (struct stack_trace *)data;
 	if (!reliable)
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 044897b..7232bc9 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -26,13 +26,14 @@ static void backtrace_warning(void *data, char *msg)
 	/* Ignore warnings */
 }
 
-static int backtrace_stack(void *data, char *name)
+static int backtrace_stack(void *data, int type, char *name)
 {
 	/* Yes, we want all stacks */
 	return 0;
 }
 
-static void backtrace_address(void *data, unsigned long addr, int reliable)
+static void backtrace_address(void *data, unsigned long stack,
+			      unsigned long addr, int reliable)
 {
 	unsigned int *depth = data;
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9ba1822..2b0528f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -439,6 +439,7 @@ enum perf_callchain_context {
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
+	int				restricted;
 };
 
 struct perf_raw_record {
@@ -535,6 +536,7 @@ struct perf_counter {
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
 	int				nr_siblings;
+	int				restricted;
 	struct perf_counter		*group_leader;
 	const struct pmu		*pmu;
 
@@ -754,7 +756,8 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern struct perf_callchain_entry *
+perf_callchain(struct perf_counter *counter, struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
 extern int sysctl_perf_counter_mlock;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 36f65e2..cc8450e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -50,16 +50,28 @@ static atomic_t nr_task_counters __read_mostly;
  *  1 - disallow cpu counters to unpriv
  *  2 - disallow kernel profiling to unpriv
  */
-int sysctl_perf_counter_paranoid __read_mostly;
+int sysctl_perf_counter_paranoid __read_mostly = 1;
 
 static inline bool perf_paranoid_cpu(void)
 {
-	return sysctl_perf_counter_paranoid > 0;
+	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 0;
 }
 
 static inline bool perf_paranoid_kernel(void)
 {
-	return sysctl_perf_counter_paranoid > 1;
+	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
+}
+
+/*
+ * When paranoid == 1 we're limiting kernel profiling to not include
+ * other users' information, this includes IRQ stack traces.
+ */
+static bool perf_counter_restricted(struct perf_counter *counter)
+{
+	if (counter->restricted)
+		return hardirq_count() - (in_nmi() ? 0 : HARDIRQ_OFFSET);
+
+	return 0;
 }
 
 int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
@@ -1571,7 +1583,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	 */
 	if (cpu != -1) {
 		/* Must be root to operate on a CPU counter: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu())
 			return ERR_PTR(-EACCES);
 
 		if (cpu < 0 || cpu > num_possible_cpus())
@@ -2458,7 +2470,8 @@ void perf_counter_do_pending(void)
  * Callchain support -- arch specific
  */
 
-__weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+__weak struct perf_callchain_entry *
+perf_callchain(struct perf_counter *counter, struct pt_regs *regs)
 {
 	return NULL;
 }
@@ -2846,6 +2859,8 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 
 	if (sample_type & PERF_SAMPLE_IP) {
 		ip = perf_instruction_pointer(data->regs);
+		if (perf_counter_restricted(counter))
+			ip = 0;
 		header.size += sizeof(ip);
 	}
 
@@ -2889,7 +2904,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		header.size += perf_counter_read_size(counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		callchain = perf_callchain(data->regs);
+		callchain = perf_callchain(counter, data->regs);
 
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
@@ -4049,6 +4064,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	counter->pmu		= NULL;
 	counter->ctx		= ctx;
 	counter->oncpu		= -1;
+	counter->restricted	= perf_paranoid_cpu();
 
 	counter->parent		= parent_counter;
 
@@ -4231,7 +4247,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 		return ret;
 
 	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_kernel())
 			return -EACCES;
 	}
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index f669396..d7d2d0d 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -71,13 +71,14 @@ static void backtrace_warning(void *data, char *msg)
 	/* Ignore warnings */
 }
 
-static int backtrace_stack(void *data, char *name)
+static int backtrace_stack(void *data, int type, char *name)
 {
 	/* Don't bother with IRQ stacks for now */
 	return -1;
 }
 
-static void backtrace_address(void *data, unsigned long addr, int reliable)
+static void backtrace_address(void *data, unsigned long stack,
+			      unsigned long addr, int reliable)
 {
 	struct backtrace_info *info = data;
 

