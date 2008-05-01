Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbYEACSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbYEACSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbYEACRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:24 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57505 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758823AbYEACRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:22 -0400
Date: Thu, 1 May 2008 12:16:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GcUQ004101@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: add pretty back strace
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

With this patch and
 CONFIG_FRAME_POINTER=y
 CONFIG_KALLSYMS=y
The backtrace shows resolved function names and their numeric
address.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/kernel/traps.c linux-2.6.25-uc0/arch/m68knommu/kernel/traps.c
--- linux-2.6.25/arch/m68knommu/kernel/traps.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/traps.c	2008-04-28 17:05:44.000000000 +1000
@@ -28,6 +28,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
+#include <linux/kallsyms.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -102,56 +103,47 @@ asmlinkage void buserr_c(struct frame *f
 	force_sig(SIGSEGV, current);
 }
 
-
 int kstack_depth_to_print = 48;
 
-void show_stack(struct task_struct *task, unsigned long *stack)
+static void __show_stack(struct task_struct *task, unsigned long *stack)
 {
 	unsigned long *endstack, addr;
-	extern char _start, _etext;
+	unsigned long *last_stack;
 	int i;
 
-	if (!stack) {
-		if (task)
-			stack = (unsigned long *)task->thread.ksp;
-		else
-			stack = (unsigned long *)&stack;
-	}
+	if (!stack)
+		stack = (unsigned long *)task->thread.ksp;
 
 	addr = (unsigned long) stack;
 	endstack = (unsigned long *) PAGE_ALIGN(addr);
 
 	printk(KERN_EMERG "Stack from %08lx:", (unsigned long)stack);
 	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack + 1 > endstack)
+		if (stack + 1 + i > endstack)
 			break;
 		if (i % 8 == 0)
 			printk("\n" KERN_EMERG "       ");
-		printk(" %08lx", *stack++);
+		printk(" %08lx", *(stack + i));
 	}
 	printk("\n");
 
-	printk(KERN_EMERG "Call Trace:");
-	i = 0;
-	while (stack + 1 <= endstack) {
-		addr = *stack++;
-		/*
-		 * If the address is either in the text segment of the
-		 * kernel, or in the region which contains vmalloc'ed
-		 * memory, it *may* be the address of a calling
-		 * routine; if so, print it so that someone tracing
-		 * down the cause of the crash will be able to figure
-		 * out the call path that was taken.
-		 */
-		if (((addr >= (unsigned long) &_start) &&
-		     (addr <= (unsigned long) &_etext))) {
-			if (i % 4 == 0)
-				printk("\n" KERN_EMERG "       ");
-			printk(" [<%08lx>]", addr);
-			i++;
-		}
+#ifdef CONFIG_FRAME_POINTER
+	printk(KERN_EMERG "Call Trace:\n");
+
+	last_stack = stack - 1;
+	while (stack <= endstack && stack > last_stack) {
+
+		addr = *(stack + 1);
+		printk(KERN_EMERG " [%08lx] ", addr);
+		print_symbol(KERN_CONT "%s\n", addr);
+
+		last_stack = stack;
+		stack = (unsigned long *)*stack;
 	}
 	printk("\n");
+#else
+	printk(KERN_EMERG "CONFIG_FRAME_POINTER disabled, no symbolic call trace\n");
+#endif
 }
 
 void bad_super_trap(struct frame *fp)
@@ -298,19 +290,47 @@ asmlinkage void set_esp0(unsigned long s
 	current->thread.esp0 = ssp;
 }
 
-
 /*
  * The architecture-independent backtrace generator
  */
 void dump_stack(void)
 {
-	unsigned long stack;
-
-	show_stack(current, &stack);
+	/*
+	 * We need frame pointers for this little trick, which works as follows:
+	 *
+	 * +------------+ 0x00
+	 * | Next SP	|	-> 0x0c
+	 * +------------+ 0x04
+	 * | Caller	|
+	 * +------------+ 0x08
+	 * | Local vars	|	-> our stack var
+	 * +------------+ 0x0c
+	 * | Next SP	|	-> 0x18, that is what we pass to show_stack()
+	 * +------------+ 0x10
+	 * | Caller	|
+	 * +------------+ 0x14
+	 * | Local vars	|
+	 * +------------+ 0x18
+	 * | ...	|
+	 * +------------+
+	 */
+
+	unsigned long *stack;
+
+	stack = (unsigned long *)&stack;
+	stack++;
+	__show_stack(current, stack);
 }
-
 EXPORT_SYMBOL(dump_stack);
 
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	if (!stack && !task)
+		dump_stack();
+	else
+		__show_stack(task, stack);
+}
+
 #ifdef CONFIG_M68KFPU_EMU
 asmlinkage void fpemu_signal(int signal, int code, void *addr)
 {
