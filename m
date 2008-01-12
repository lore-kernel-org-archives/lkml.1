Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbYALFbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbYALFbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYALFbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:31:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33903 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYALFbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:31:34 -0500
Date: Fri, 11 Jan 2008 21:31:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@tglx.de, hpa@zytor.com
Subject: [patch 4/8] x86: pull EBP calculation earlier into the backtrace
 path
Message-ID: <20080111213125.311dfa09@laptopd505.fenrus.org>
In-Reply-To: <20080111212623.518e1527@laptopd505.fenrus.org>
References: <20080111212623.518e1527@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: pull EBP calculation earlier into the backtrace path
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, we take the stack pointer early during the backtrace path, but
only calculate EBP several functions deep later, making it hard to reconcile
the stack and EBP backtraces (as well as showing several internal backtrace
functions on the stack with EBP based backtracing).

This patch moves the EBP taking to the same place we take the stack pointer;
sadly this ripples through several layers of the back tracing stack,
but it's not all that bad in the end I hope.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/process_32.c   |    2 +-
 arch/x86/kernel/process_64.c   |    2 +-
 arch/x86/kernel/stacktrace.c   |    2 +-
 arch/x86/kernel/traps_32.c     |   39 +++++++++++++++++----------------------
 arch/x86/oprofile/backtrace.c  |    2 +-
 include/asm-x86/processor_32.h |    3 ++-
 include/asm-x86/proto.h        |    3 ++-
 include/asm-x86/stacktrace.h   |    1 +
 8 files changed, 26 insertions(+), 28 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/process_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/process_32.c
@@ -358,7 +358,7 @@ void __show_registers(struct pt_regs *re
 void show_regs(struct pt_regs *regs)
 {
 	__show_registers(regs, 1);
-	show_trace(NULL, regs, &regs->esp);
+	show_trace(NULL, regs, &regs->esp, regs->ebp);
 }
 
 /*
Index: linux-2.6.24-rc7/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/process_64.c
@@ -368,7 +368,7 @@ void show_regs(struct pt_regs *regs)
 {
 	printk("CPU %d:", smp_processor_id());
 	__show_regs(regs);
-	show_trace(NULL, regs, (void *)(regs + 1));
+	show_trace(NULL, regs, (void *)(regs + 1), regs->rbp);
 }
 
 /*
Index: linux-2.6.24-rc7/arch/x86/kernel/stacktrace.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/stacktrace.c
+++ linux-2.6.24-rc7/arch/x86/kernel/stacktrace.c
@@ -45,7 +45,7 @@ static const struct stacktrace_ops save_
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
Index: linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
@@ -119,15 +119,6 @@ static inline unsigned long print_contex
 {
 	struct stack_frame *frame = (struct stack_frame *)ebp;
 
-	/*
-	 * if EBP is "deeper" into the stack than the actual stack pointer,
-	 * we need to rewind the stack pointer a little to start at the
-	 * first stack frame, but only if EBP is in this stack frame.
-	 */
-	if (stack > (unsigned long *) ebp
-			&& valid_stack_ptr(tinfo, frame, sizeof(*frame)))
-		stack = (unsigned long *) ebp;
-
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
@@ -138,7 +129,7 @@ static inline unsigned long print_contex
 				frame = frame->next_frame;
 				ebp = (unsigned long) frame;
 			} else {
-				ops->address(data, addr, 0);
+				ops->address(data, addr, ebp == 0);
 			}
 		}
 		stack++;
@@ -149,11 +140,9 @@ static inline unsigned long print_contex
 #define MSG(msg) ops->warning(data, msg)
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
-	        unsigned long *stack,
+		unsigned long *stack, unsigned long ebp,
 		const struct stacktrace_ops *ops, void *data)
 {
-	unsigned long ebp = 0;
-
 	if (!task)
 		task = current;
 
@@ -233,20 +222,20 @@ static const struct stacktrace_ops print
 
 static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long * stack, char *log_lvl)
+		unsigned long *stack, unsigned long ebp, char *log_lvl)
 {
-	dump_trace(task, regs, stack, &print_trace_ops, log_lvl);
+	dump_trace(task, regs, stack, ebp, &print_trace_ops, log_lvl);
 	printk("%s =======================\n", log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long * stack)
+		unsigned long *stack, unsigned long ebp)
 {
-	show_trace_log_lvl(task, regs, stack, "");
+	show_trace_log_lvl(task, regs, stack, ebp, "");
 }
 
 static void show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			       unsigned long *esp, char *log_lvl)
+		       unsigned long *esp, unsigned long ebp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -267,13 +256,13 @@ static void show_stack_log_lvl(struct ta
 		printk("%08lx ", *stack++);
 	}
 	printk("\n%sCall Trace:\n", log_lvl);
-	show_trace_log_lvl(task, regs, esp, log_lvl);
+	show_trace_log_lvl(task, regs, esp, ebp, log_lvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *esp)
 {
 	printk("       ");
-	show_stack_log_lvl(task, NULL, esp, "");
+	show_stack_log_lvl(task, NULL, esp, 0, "");
 }
 
 /*
@@ -282,13 +271,19 @@ void show_stack(struct task_struct *task
 void dump_stack(void)
 {
 	unsigned long stack;
+	unsigned long ebp = 0;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!ebp)
+		asm("movl %%ebp, %0" : "=r" (ebp):);
+#endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(current, NULL, &stack);
+	show_trace(current, NULL, &stack, ebp);
 }
 
 EXPORT_SYMBOL(dump_stack);
@@ -313,7 +308,7 @@ void show_registers(struct pt_regs *regs
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, &regs->esp, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->esp, 0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
Index: linux-2.6.24-rc7/arch/x86/oprofile/backtrace.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/oprofile/backtrace.c
+++ linux-2.6.24-rc7/arch/x86/oprofile/backtrace.c
@@ -81,7 +81,7 @@ x86_backtrace(struct pt_regs * const reg
 
 	if (!user_mode_vm(regs)) {
 		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack,
+			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);
 		return;
 	}
Index: linux-2.6.24-rc7/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-x86/processor_32.h
+++ linux-2.6.24-rc7/include/asm-x86/processor_32.h
@@ -423,7 +423,8 @@ extern void prepare_to_copy(struct task_
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
-void show_trace(struct task_struct *task, struct pt_regs *regs, unsigned long *stack);
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long ebp);
 
 unsigned long get_wchan(struct task_struct *p);
 
Index: linux-2.6.24-rc7/include/asm-x86/proto.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-x86/proto.h
+++ linux-2.6.24-rc7/include/asm-x86/proto.h
@@ -53,7 +53,8 @@ extern void load_gs_index(unsigned gs);
 
 extern unsigned long end_pfn_map; 
 
-extern void show_trace(struct task_struct *, struct pt_regs *, unsigned long * rsp);
+extern void show_trace(struct task_struct *, struct pt_regs *,
+		unsigned long *rsp, unsigned long ebp);
 extern void show_registers(struct pt_regs *regs);
 
 extern void exception_table_check(void);
Index: linux-2.6.24-rc7/include/asm-x86/stacktrace.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-x86/stacktrace.h
+++ linux-2.6.24-rc7/include/asm-x86/stacktrace.h
@@ -15,6 +15,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
+		unsigned long ebp,
 		const struct stacktrace_ops *ops, void *data);
 
 #endif



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
