Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZJ2Mqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZJ2Mqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZJ2Mqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:46:44 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:11905 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779AbZJ2Mqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:46:43 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86: Get bp from the IRQ regs instead of directly from the CPU
References: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
	<ye8ljj3mlj5.fsf@camel16.daimi.au.dk> <20091023105047.GA10071@elte.hu>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 29 Oct 2009 13:46:46 +0100
In-Reply-To: <20091023105047.GA10071@elte.hu>
Message-ID: <ye87hue2wqx.fsf@camel27.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.146
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> >  arch/x86/kernel/cpu/perf_event.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index b5801c3..39b1d0c 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -2177,10 +2177,18 @@ static const struct stacktrace_ops backtrace_ops = {
> >  static void
> >  perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
> >  {
> > +	unsigned long bp;
> > +    
> >  	callchain_store(entry, PERF_CONTEXT_KERNEL);
> >  	callchain_store(entry, regs->ip);
> >  
> > -	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
> > +#ifdef CONFIG_FRAME_POINTER
> > +	bp = regs->bp;
> > +#else
> > +	bp = 0;
> > +#endif
> > +	
> > +	dump_trace(NULL, regs, NULL, bp, &backtrace_ops, entry);
> >  }
> 
> Wouldnt it be better to push this logic into dump_trace() itself? That 
> way other ways of backtrace generation would be improved as well, not 
> just perf events call-chains.

Yes, it would, and I wrote the patch for that below, but then
discovered that getting bp from the IRQ registers makes stacktracing
not work at all on 64 bit. As I read entry_64.S, rbp ends up being
stored in regs->bx; maybe that's related.

I'll try and track down what is going on later.


Soren




>From ce007534805fcfcc5d6b630bac5761f137fbbb1a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?S=C3=B8ren=20Sandmann=20Pedersen?= <sandmann@redhat.com>
Date: Thu, 22 Oct 2009 08:30:14 -0400
Subject: [PATCH] x86: Eliminate bp argument from the stack tracing routines

The various stack tracing routines take a 'bp' argument in which the
caller is supposed to provide the base pointer to use, or 0 if doesn't
have one. Since bp is garbage whenever CONFIG_FRAME_POINTER is not
defined, this means all callers in principle should either always pass
0, or be conditional on CONFIG_FRAME_POINTER.

However, there are only really three use cases for stack tracing and
in all cases, dump_trace can figure out the desired bp for itself.

(a) Trace the current task, including IRQ stack if any
(b) Trace the current task, but skip IRQ stack
(c) Trace some other task

In all cases, if CONFIG_FRAME_POINTER is not defined, just use 0 for
bp.  If it _is_ defined, then

- in case (a) bp should be gotten directly from the CPU's register, so
  the caller should pass NULL for regs,

- in case (b) the caller should should pass the IRQ registers to
  dump_trace(),

- in case (c) bp should be gotten from the top of the task's stack, so
  the caller should pass NULL for regs.

Hence, the bp argument is not necessary because the combination of
task and regs is sufficient to determine an appropriate value for bp.
---
 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |    2 +-
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   12 ++++++------
 arch/x86/kernel/dumpstack.h       |    4 ++--
 arch/x86/kernel/dumpstack_32.c    |   18 +++++++++++-------
 arch/x86/kernel/dumpstack_64.c    |   17 +++++++++++------
 arch/x86/kernel/process_32.c      |    2 +-
 arch/x86/kernel/process_64.c      |    2 +-
 arch/x86/kernel/stacktrace.c      |    8 ++++----
 arch/x86/mm/kmemcheck/error.c     |    2 +-
 arch/x86/oprofile/backtrace.c     |    2 +-
 include/linux/stacktrace.h        |    4 +++-
 kernel/trace/trace_sysprof.c      |    8 +-------
 14 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fa7c0b9..7017cad 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -28,7 +28,7 @@ extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
-		       unsigned long *sp, unsigned long bp);
+		       unsigned long *sp);
 extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index cf86a5e..761487a 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -17,7 +17,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+		unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data);
 
 #endif /* _ASM_X86_STACKTRACE_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b5801c3..5db9ae6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2180,7 +2180,7 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, &backtrace_ops, entry);
 }
 
 /*
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2d8a371..e180862 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -149,21 +149,21 @@ static const struct stacktrace_ops print_trace_ops = {
 
 void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
+		unsigned long *stack, char *log_lvl)
 {
 	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+	dump_trace(task, regs, stack, &print_trace_ops, log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
+		unsigned long *stack)
 {
-	show_trace_log_lvl(task, regs, stack, bp, "");
+	show_trace_log_lvl(task, regs, stack, "");
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	show_stack_log_lvl(task, NULL, sp, "");
 }
 
 /*
@@ -184,7 +184,7 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
+	show_trace(NULL, NULL, &stack);
 }
 EXPORT_SYMBOL(dump_stack);
 
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 81086c2..4c90b51 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -22,11 +22,11 @@ print_context_stack(struct thread_info *tinfo,
 
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl);
+		unsigned long *stack, char *log_lvl);
 
 extern void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl);
+		unsigned long *sp, char *log_lvl);
 
 extern unsigned int code_bytes;
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f7dd2a7..2069bdf 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -24,11 +24,12 @@ int x86_is_stack_id(int id, char *name)
 	return 0;
 }
 
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+void dump_trace(struct task_struct *task,
+		struct pt_regs *regs, unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
+	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -41,7 +42,9 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	}
 
 #ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
+	if (regs) {
+		bp = regs->bp;
+	} else {
 		if (task == current) {
 			/* Grab bp right from our regs */
 			get_bp(bp);
@@ -50,6 +53,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			bp = *(unsigned long *) task->thread.sp;
 		}
 	}
+#else
+	bp = 0;
 #endif
 
 	for (;;) {
@@ -72,7 +77,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		unsigned long *sp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -94,7 +99,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk("\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 
@@ -119,8 +124,7 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk(KERN_EMERG "Stack:\n");
-		show_stack_log_lvl(NULL, regs, &regs->sp,
-				0, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..d091eee 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -108,8 +108,8 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+void dump_trace(struct task_struct *task,
+		struct pt_regs *regs, unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
@@ -118,6 +118,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
+	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -130,7 +131,9 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	}
 
 #ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
+	if (regs) {
+		bp = regs->bp;
+	} else {
 		if (task == current) {
 			/* Grab bp right from our regs */
 			get_bp(bp);
@@ -139,6 +142,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			bp = *(unsigned long *) task->thread.sp;
 		}
 	}
+#else
+	bp = 0;
 #endif
 
 	/*
@@ -202,7 +207,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		unsigned long *sp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -241,7 +246,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk("\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 void show_registers(struct pt_regs *regs)
@@ -269,7 +274,7 @@ void show_registers(struct pt_regs *regs)
 
 		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, KERN_EMERG);
+				   KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..c4f3753 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -188,7 +188,7 @@ void __show_regs(struct pt_regs *regs, int all)
 void show_regs(struct pt_regs *regs)
 {
 	__show_regs(regs, 1);
-	show_trace(NULL, regs, &regs->sp, regs->bp);
+	show_trace(NULL, regs, &regs->sp);
 }
 
 /*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..ddfcd37 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -228,7 +228,7 @@ void show_regs(struct pt_regs *regs)
 {
 	printk(KERN_INFO "CPU %d:", smp_processor_id());
 	__show_regs(regs, 1);
-	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
+	show_trace(NULL, regs, (void *)(regs + 1));
 }
 
 void release_thread(struct task_struct *dead_task)
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c3eb207..d5c00d3 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -71,22 +71,22 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
-void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp)
+void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
 {
-	dump_trace(current, NULL, NULL, bp, &save_stack_ops, trace);
+	dump_trace(current, regs, NULL, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
+	dump_trace(tsk, NULL, NULL, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 4901d0d..dc9b197 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -186,7 +186,7 @@ void kmemcheck_error_save(enum kmemcheck_shadow state,
 	e->trace.entries = e->trace_entries;
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 0;
-	save_stack_trace_bp(&e->trace, regs->bp);
+	save_stack_trace_regs(&e->trace, regs);
 
 	/* Round address down to nearest 16 bytes */
 	shadow_copy = kmemcheck_shadow_lookup(address
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 044897b..00e33b5 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -80,7 +80,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
 		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack, 0,
+			dump_trace(NULL, regs, (unsigned long *)stack,
 				   &backtrace_ops, &depth);
 		return;
 	}
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 51efbef..25310f1 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -2,6 +2,7 @@
 #define __LINUX_STACKTRACE_H
 
 struct task_struct;
+struct pt_regs;
 
 #ifdef CONFIG_STACKTRACE
 struct task_struct;
@@ -13,7 +14,8 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
-extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
+extern void save_stack_trace_regs(struct stack_trace *trace,
+				  struct pt_regs *regs);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index f669396..3db232b 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -100,7 +100,6 @@ trace_kernel(struct pt_regs *regs, struct trace_array *tr,
 	     struct trace_array_cpu *data)
 {
 	struct backtrace_info info;
-	unsigned long bp;
 	char *stack;
 
 	info.tr = tr;
@@ -110,13 +109,8 @@ trace_kernel(struct pt_regs *regs, struct trace_array *tr,
 	__trace_special(info.tr, info.data, 1, regs->ip, 0);
 
 	stack = ((char *)regs + sizeof(struct pt_regs));
-#ifdef CONFIG_FRAME_POINTER
-	bp = regs->bp;
-#else
-	bp = 0;
-#endif
 
-	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, &info);
+	dump_trace(NULL, regs, (void *)stack, &backtrace_ops, &info);
 
 	return info.pos;
 }
-- 
1.6.5.1

