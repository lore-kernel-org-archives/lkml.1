Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYJWOmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYJWOmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYJWOm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:42:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39733 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYJWOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:42:27 -0400
Date: Thu, 23 Oct 2008 10:40:06 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, nhorman@tuxdriver.com
Subject: [PATCH] x86: unify appropriate bits from dumpstack_32 and dumpstack_64
Message-ID: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	As promised, now that dumpstack_32 and dumpstack_64 have so many bits in
common, we should merge the in-sync bits into a common file, to prevent them
from diverging again.  This patch removes bits which are common between
dumpstack_32.c and dumpstack_64.c and places them in a common dumpstack.c which
is built for both 32 and 64 bit arches.  

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 Makefile       |    2 
 dumpstack.c    |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dumpstack.h    |   39 ++++++
 dumpstack_32.c |  294 ----------------------------------------------------
 dumpstack_64.c |  285 --------------------------------------------------
 5 files changed, 363 insertions(+), 576 deletions(-)


diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 01dc4c7..e657ec7 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,7 +25,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time_$(BITS).o ioport.o ldt.o
+obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
new file mode 100644
index 0000000..5962176
--- /dev/null
+++ b/arch/x86/kernel/dumpstack.c
@@ -0,0 +1,319 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/bug.h>
+#include <linux/nmi.h>
+#include <linux/sysfs.h>
+
+#include <asm/stacktrace.h>
+
+#include "dumpstack.h"
+
+int panic_on_unrecovered_nmi;
+unsigned int code_bytes = 64;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
+static int die_counter;
+
+void printk_address(unsigned long address, int reliable)
+{
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
+}
+
+/*
+ * x86-64 can have up to three kernel stacks:
+ * process stack
+ * interrupt stack
+ * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
+ */
+
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size, void *end)
+{
+	void *t = tinfo;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
+}
+
+unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+		unsigned long addr;
+
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, bp == 0);
+			}
+		}
+		stack++;
+	}
+	return bp;
+}
+
+
+static void
+print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	printk(data);
+	print_symbol(msg, symbol);
+	printk("\n");
+}
+
+static void print_trace_warning(void *data, char *msg)
+{
+	printk("%s%s\n", (char *)data, msg);
+}
+
+static int print_trace_stack(void *data, char *name)
+{
+	printk("%s <%s> ", (char *)data, name);
+	return 0;
+}
+
+/*
+ * Print one address/symbol entries per line.
+ */
+static void print_trace_address(void *data, unsigned long addr, int reliable)
+{
+	touch_nmi_watchdog();
+	printk(data);
+	printk_address(addr, reliable);
+}
+
+static const struct stacktrace_ops print_trace_ops = {
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
+};
+
+void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
+{
+	printk("%sCall Trace:\n", log_lvl);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+}
+
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_log_lvl(task, NULL, sp, 0, "");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		get_bp(bp);
+#endif
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	show_trace(NULL, NULL, &stack, bp);
+}
+EXPORT_SYMBOL(dump_stack);
+
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	oops_enter();
+
+	/* racy, but better than risking deadlock. */
+	raw_local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (!__raw_spin_trylock(&die_lock)) {
+		if (cpu == die_owner)
+			/* nested oops. should stop eventually */;
+		else
+			__raw_spin_lock(&die_lock);
+	}
+	die_nest_count++;
+	die_owner = cpu;
+	console_verbose();
+	bust_spinlocks(1);
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	if (regs && kexec_should_crash(current))
+		crash_kexec(regs);
+
+	bust_spinlocks(0);
+	die_owner = -1;
+	add_taint(TAINT_DIE);
+	die_nest_count--;
+	if (!die_nest_count)
+		/* Nest count reaches zero, release the lock. */
+		__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+	oops_exit();
+
+	if (!signr)
+		return;
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+	if (panic_on_oops)
+		panic("Fatal exception");
+	do_exit(signr);
+}
+
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+{
+#ifdef CONFIG_X86_32
+	unsigned short ss;
+	unsigned long sp;
+#endif
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+	sysfs_printk_last_file();
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
+
+	show_registers(regs);
+#ifdef CONFIG_X86_32
+	sp = (unsigned long) (&regs->sp);
+	savesegment(ss, ss);
+	if (user_mode(regs)) {
+		sp = regs->sp;
+		ss = regs->ss & 0xffff;
+	}
+	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+	print_symbol("%s", regs->ip);
+	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+#else
+	/* Executive summary in case the oops scrolled away */
+	printk(KERN_ALERT "RIP ");
+	printk_address(regs->ip, 1);
+	printk(" RSP <%016lx>\n", regs->sp);
+#endif
+	return 0;
+}
+
+/*
+ * This is gone through when something in the kernel has done something bad
+ * and is about to be terminated:
+ */
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned long flags = oops_begin();
+	int sig = SIGSEGV;
+
+	if (!user_mode_vm(regs))
+		report_bug(regs->ip, regs);
+
+	if (__die(str, regs, err))
+		sig = 0;
+	oops_end(flags, regs, sig);
+}
+
+void notrace __kprobes
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	unsigned long flags;
+
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	/*
+	 * We are in trouble anyway, lets at least try
+	 * to get a message out.
+	 */
+	flags = oops_begin();
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	oops_end(flags, regs, 0);
+	if (do_panic || panic_on_oops)
+		panic("Non maskable interrupt");
+	nmi_exit();
+	local_irq_enable();
+	do_exit(SIGBUS);
+}
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
+static int __init kstack_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+	return 0;
+}
+early_param("kstack", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
new file mode 100644
index 0000000..3119a80
--- /dev/null
+++ b/arch/x86/kernel/dumpstack.h
@@ -0,0 +1,39 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+
+#ifndef DUMPSTACK_H
+#define DUMPSTACK_H
+
+#ifdef CONFIG_X86_32
+#define STACKSLOTS_PER_LINE 8
+#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+#else
+#define STACKSLOTS_PER_LINE 4
+#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+#endif
+
+extern unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end);
+
+extern void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl);
+
+extern void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl);
+
+extern unsigned int code_bytes;
+extern int kstack_depth_to_print;
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+#endif
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f2046c5..7b031b1 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -17,64 +17,7 @@
 
 #include <asm/stacktrace.h>
 
-#define STACKSLOTS_PER_LINE 8
-#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
-static unsigned int code_bytes = 64;
-static int die_counter;
-
-void printk_address(unsigned long address, int reliable)
-{
-	printk(" [<%p>] %s%pS\n", (void *) address,
-			reliable ? "" : "? ", (void *) address);
-}
-
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size, void *end)
-{
-	void *t = tinfo;
-	if (end) {
-		if (p < end && p >= (end-THREAD_SIZE))
-			return 1;
-		else
-			return 0;
-	}
-	return p > t && p < t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + sizeof(long)) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
+#include "dumpstack.h"
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
@@ -119,57 +62,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 }
 EXPORT_SYMBOL(dump_trace);
 
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
-static int print_trace_stack(void *data, char *name)
-{
-	printk("%s <%s> ", (char *)data, name);
-	return 0;
-}
-
-/*
- * Print one address/symbol entries per line.
- */
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	touch_nmi_watchdog();
-	printk(data);
-	printk_address(addr, reliable);
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
-
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
-{
-	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-}
-
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
-{
-	show_trace_log_lvl(task, regs, stack, bp, "");
-}
-
-static void
+void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *sp, unsigned long bp, char *log_lvl)
 {
@@ -196,33 +89,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_log_lvl(task, NULL, sp, 0, "");
-}
-
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		get_bp(bp);
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-
-EXPORT_SYMBOL(dump_stack);
 
 void show_registers(struct pt_regs *regs)
 {
@@ -283,159 +149,3 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	int cpu;
-	unsigned long flags;
-
-	oops_enter();
-
-	/* racy, but better than risking deadlock. */
-	raw_local_irq_save(flags);
-	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner)
-			/* nested oops. should stop eventually */;
-		else
-			__raw_spin_lock(&die_lock);
-	}
-	die_nest_count++;
-	die_owner = cpu;
-	console_verbose();
-	bust_spinlocks(1);
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	if (regs && kexec_should_crash(current))
-		crash_kexec(regs);
-
-	bust_spinlocks(0);
-	die_owner = -1;
-	add_taint(TAINT_DIE);
-	die_nest_count--;
-	if (!die_nest_count)
-		/* Nest count reaches zero, release the lock. */
-		__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-	oops_exit();
-
-	if (!signr)
-		return;
-	if (in_interrupt())
-		panic("Fatal exception in interrupt");
-	if (panic_on_oops)
-		panic("Fatal exception");
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned short ss;
-	unsigned long sp;
-
-	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	sysfs_printk_last_file();
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
-		return 1;
-
-	show_registers(regs);
-	/* Executive summary in case the oops scrolled away */
-	sp = (unsigned long) (&regs->sp);
-	savesegment(ss, ss);
-	if (user_mode(regs)) {
-		sp = regs->sp;
-		ss = regs->ss & 0xffff;
-	}
-	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-	print_symbol("%s", regs->ip);
-	printk(" SS:ESP %04x:%08lx\n", ss, sp);
-	return 0;
-}
-
-/*
- * This is gone through when something in the kernel has done something bad
- * and is about to be terminated:
- */
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-	int sig = SIGSEGV;
-
-	if (!user_mode_vm(regs))
-		report_bug(regs->ip, regs);
-
-	if (__die(str, regs, err))
-		sig = 0;
-	oops_end(flags, regs, sig);
-}
-
-void notrace __kprobes
-die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	unsigned long flags;
-
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/*
-	 * We are in trouble anyway, lets at least try
-	 * to get a message out.
-	 */
-	flags = oops_begin();
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	oops_end(flags, regs, 0);
-	if (do_panic || panic_on_oops)
-		panic("Non maskable interrupt");
-	nmi_exit();
-	local_irq_enable();
-	do_exit(SIGBUS);
-}
-
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
-static int __init kstack_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-	return 0;
-}
-early_param("kstack", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 28c67aa..33ff102 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -17,19 +17,7 @@
 
 #include <asm/stacktrace.h>
 
-#define STACKSLOTS_PER_LINE 4
-#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
-static unsigned int code_bytes = 64;
-static int die_counter;
-
-void printk_address(unsigned long address, int reliable)
-{
-	printk(" [<%p>] %s%pS\n", (void *) address,
-			reliable ? "" : "? ", (void *) address);
-}
+#include "dumpstack.h"
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 					unsigned *usedp, char **idp)
@@ -113,51 +101,6 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size, void *end)
-{
-	void *t = tinfo;
-	if (end) {
-		if (p < end && p >= (end-THREAD_SIZE))
-			return 1;
-		else
-			return 0;
-	}
-	return p > t && p < t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + sizeof(long)) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
-
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
@@ -248,57 +191,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 }
 EXPORT_SYMBOL(dump_trace);
 
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
-static int print_trace_stack(void *data, char *name)
-{
-	printk("%s <%s> ", (char *)data, name);
-	return 0;
-}
-
-/*
- * Print one address/symbol entries per line.
- */
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	touch_nmi_watchdog();
-	printk(data);
-	printk_address(addr, reliable);
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
-
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
-{
-	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-}
-
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
-{
-	show_trace_log_lvl(task, regs, stack, bp, "");
-}
-
-static void
+void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *sp, unsigned long bp, char *log_lvl)
 {
@@ -342,33 +235,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_log_lvl(task, NULL, sp, 0, "");
-}
-
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		get_bp(bp);
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void show_registers(struct pt_regs *regs)
 {
 	int i;
@@ -429,150 +295,3 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	int cpu;
-	unsigned long flags;
-
-	oops_enter();
-
-	/* racy, but better than risking deadlock. */
-	raw_local_irq_save(flags);
-	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner)
-			/* nested oops. should stop eventually */;
-		else
-			__raw_spin_lock(&die_lock);
-	}
-	die_nest_count++;
-	die_owner = cpu;
-	console_verbose();
-	bust_spinlocks(1);
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	if (regs && kexec_should_crash(current))
-		crash_kexec(regs);
-
-	bust_spinlocks(0);
-	die_owner = -1;
-	add_taint(TAINT_DIE);
-	die_nest_count--;
-	if (!die_nest_count)
-		/* Nest count reaches zero, release the lock. */
-		__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-	oops_exit();
-
-	if (!signr)
-		return;
-	if (in_interrupt())
-		panic("Fatal exception in interrupt");
-	if (panic_on_oops)
-		panic("Fatal exception");
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	sysfs_printk_last_file();
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
-		return 1;
-
-	show_registers(regs);
-	/* Executive summary in case the oops scrolled away */
-	printk(KERN_ALERT "RIP ");
-	printk_address(regs->ip, 1);
-	printk(" RSP <%016lx>\n", regs->sp);
-	return 0;
-}
-
-/*
- * This is gone through when something in the kernel has done something bad
- * and is about to be terminated:
- */
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-	int sig = SIGSEGV;
-
-	if (!user_mode_vm(regs))
-		report_bug(regs->ip, regs);
-
-	if (__die(str, regs, err))
-		sig = 0;
-	oops_end(flags, regs, sig);
-}
-
-void notrace __kprobes
-die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	unsigned long flags;
-
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/*
-	 * We are in trouble anyway, lets at least try
-	 * to get a message out.
-	 */
-	flags = oops_begin();
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	oops_end(flags, regs, 0);
-	if (do_panic || panic_on_oops)
-		panic("Non maskable interrupt");
-	nmi_exit();
-	local_irq_enable();
-	do_exit(SIGBUS);
-}
-
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
-static int __init kstack_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-	return 0;
-}
-early_param("kstack", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
