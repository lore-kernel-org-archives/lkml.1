Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbYALFfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbYALFfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbYALFeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:34:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33950 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762824AbYALFef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:34:35 -0500
Date: Fri, 11 Jan 2008 21:29:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, tglx@tglx.de,
       hpa@zytor.com
Subject: [patch 2/8] x86: Add the capability to print fuzzy backtraces
Message-ID: <20080111212944.12f80c26@laptopd505.fenrus.org>
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

Subject: x86: Add the capability to print fuzzy backtraces
From: Arjan van de Ven <arjan@linux.intel.com>

For enhancing the 32 bit EBP based backtracer, I need the capability
for the backtracer to tell it's customer that an entry is either
reliable or unreliable, and the backtrace printing code then needs to
print the unreliable ones slightly different.

This patch adds the basic capability, the next patch will add a user
of this capability.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/stacktrace.c  |    2 +-
 arch/x86/kernel/traps_32.c    |    8 +++++---
 arch/x86/kernel/traps_64.c    |   37 ++++++++++++++++++++++---------------
 arch/x86/oprofile/backtrace.c |    2 +-
 include/asm-x86/stacktrace.h  |    2 +-
 5 files changed, 30 insertions(+), 21 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
@@ -125,7 +125,7 @@ static inline unsigned long print_contex
 
 		addr = frame->return_address;
 		if (__kernel_text_address(addr))
-			ops->address(data, addr);
+			ops->address(data, addr, 1);
 		/*
 		 * break out of recursive entries (such as
 		 * end_of_stack_stop_unwind_function). Also,
@@ -144,7 +144,7 @@ static inline unsigned long print_contex
 
 		addr = *stack++;
 		if (__kernel_text_address(addr))
-			ops->address(data, addr);
+			ops->address(data, addr, 1);
 	}
 #endif
 	return ebp;
@@ -219,9 +219,11 @@ static int print_trace_stack(void *data,
 /*
  * Print one address/symbol entries per line.
  */
-static void print_trace_address(void *data, unsigned long addr)
+static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	printk("%s [<%08lx>] ", (char *)data, addr);
+	if (!reliable)
+		printk("? ");
 	print_symbol("%s\n", addr);
 	touch_nmi_watchdog();
 }
Index: linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
@@ -99,13 +99,14 @@ static inline void preempt_conditional_c
 int kstack_depth_to_print = 12;
 
 #ifdef CONFIG_KALLSYMS
-void printk_address(unsigned long address)
+void printk_address(unsigned long address, int reliable)
 {
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
 	char *delim = ":";
 	char namebuf[128];
+	char reliab[4] = "";;
 
 	symname = kallsyms_lookup(address, &symsize, &offset,
 					&modname, namebuf);
@@ -113,13 +114,16 @@ void printk_address(unsigned long addres
 		printk(" [<%016lx>]\n", address);
 		return;
 	}
+	if (!reliable)
+		strcpy(reliab,"? ");
+
 	if (!modname)
 		modname = delim = ""; 		
-	printk(" [<%016lx>] %s%s%s%s+0x%lx/0x%lx\n",
-		address, delim, modname, delim, symname, offset, symsize);
+	printk(" [<%016lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
+		address, reliab, delim, modname, delim, symname, offset, symsize);
 }
 #else
-void printk_address(unsigned long address)
+void printk_address(unsigned long address, int reliable)
 {
 	printk(" [<%016lx>]\n", address);
 }
@@ -215,7 +219,7 @@ static inline int valid_stack_ptr(struct
 }
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack,
+		unsigned long *stack, unsigned long ebp,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
@@ -252,7 +256,7 @@ void dump_trace(struct task_struct *tsk,
 			 * down the cause of the crash will be able to figure \
 			 * out the call path that was taken. \
 			 */ \
-			ops->address(data, addr);   \
+			ops->address(data, addr, 1);   \
 		} \
 	} while (0)
 
@@ -331,10 +335,10 @@ static int print_trace_stack(void *data,
 	return 0;
 }
 
-static void print_trace_address(void *data, unsigned long addr)
+static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
-	printk_address(addr);
+	printk_address(addr, reliable);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
@@ -345,15 +349,17 @@ static const struct stacktrace_ops print
 };
 
 void
-show_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack)
+show_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
+		unsigned long ebp)
 {
 	printk("\nCall Trace:\n");
-	dump_trace(tsk, regs, stack, &print_trace_ops, NULL);
+	dump_trace(tsk, regs, stack, ebp, &print_trace_ops, NULL);
 	printk("\n");
 }
 
 static void
-_show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *rsp)
+_show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *rsp,
+							unsigned long ebp)
 {
 	unsigned long *stack;
 	int i;
@@ -387,12 +393,12 @@ _show_stack(struct task_struct *tsk, str
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	show_trace(tsk, regs, rsp);
+	show_trace(tsk, regs, rsp, ebp);
 }
 
 void show_stack(struct task_struct *tsk, unsigned long * rsp)
 {
-	_show_stack(tsk, NULL, rsp);
+	_show_stack(tsk, NULL, rsp, 0);
 }
 
 /*
@@ -401,13 +407,14 @@ void show_stack(struct task_struct *tsk,
 void dump_stack(void)
 {
 	unsigned long dummy;
+	unsigned long ebp = 0;
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &dummy);
+	show_trace(NULL, NULL, &dummy, ebp);
 }
 
 EXPORT_SYMBOL(dump_stack);
@@ -432,7 +439,7 @@ void show_registers(struct pt_regs *regs
 	 */
 	if (in_kernel) {
 		printk("Stack: ");
-		_show_stack(NULL, regs, (unsigned long*)rsp);
+		_show_stack(NULL, regs, (unsigned long *)rsp, regs->rbp);
 
 		printk("\nCode: ");
 		if (regs->rip < PAGE_OFFSET)
Index: linux-2.6.24-rc7/arch/x86/oprofile/backtrace.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/oprofile/backtrace.c
+++ linux-2.6.24-rc7/arch/x86/oprofile/backtrace.c
@@ -32,7 +32,7 @@ static int backtrace_stack(void *data, c
 	return 0;
 }
 
-static void backtrace_address(void *data, unsigned long addr)
+static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	unsigned int *depth = data;
 
Index: linux-2.6.24-rc7/include/asm-x86/stacktrace.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-x86/stacktrace.h
+++ linux-2.6.24-rc7/include/asm-x86/stacktrace.h
@@ -9,7 +9,7 @@ struct stacktrace_ops {
 	void (*warning)(void *data, char *msg);
 	/* msg must contain %s for the symbol */
 	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
-	void (*address)(void *data, unsigned long address);
+	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
 };
Index: linux-2.6.24-rc7/arch/x86/kernel/stacktrace.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/stacktrace.c
+++ linux-2.6.24-rc7/arch/x86/kernel/stacktrace.c
@@ -22,7 +22,7 @@ static int save_stack_stack(void *data, 
 	return -1;
 }
 
-static void save_stack_address(void *data, unsigned long addr)
+static void save_stack_address(void *data, unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = (struct stack_trace *)data;
 	if (trace->skip > 0) {



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
