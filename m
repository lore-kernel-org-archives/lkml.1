Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbXLFMrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbXLFMrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXLFMmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:50 -0500
Received: from nic2.axis.se ([193.13.178.10]:35731 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbXLFMmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:32 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <933a9803fffedcffcfd9d89a7a3250b4e5453ad1.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 14:11:29 +0100
Subject: [PATCH 16/47] Minor CRIS generic kernel/traps.c changes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Collect extern declarations at top of file.
- Change raw_printk to printk, use oops_in_progress instead.
- Fix formatting and whitespace.
- Allow the watchdog to be disabled during oops.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/kernel/traps.c |  226 ++++++++++++++++++++++++++++------------------
 1 files changed, 139 insertions(+), 87 deletions(-)

diff --git a/arch/cris/kernel/traps.c b/arch/cris/kernel/traps.c
index 520d922..541efbf 100644
--- a/arch/cris/kernel/traps.c
+++ b/arch/cris/kernel/traps.c
@@ -1,66 +1,78 @@
-/* $Id: traps.c,v 1.11 2005/01/24 16:03:19 orjanf Exp $
- *
+/*
  *  linux/arch/cris/traps.c
  *
- *  Here we handle the break vectors not used by the system call 
- *  mechanism, as well as some general stack/register dumping 
+ *  Here we handle the break vectors not used by the system call
+ *  mechanism, as well as some general stack/register dumping
  *  things.
- * 
- *  Copyright (C) 2000-2002 Axis Communications AB
+ *
+ *  Copyright (C) 2000-2007 Axis Communications AB
  *
  *  Authors:   Bjorn Wesen
- *  	       Hans-Peter Nilsson
+ *             Hans-Peter Nilsson
  *
  */
 
 #include <linux/init.h>
 #include <linux/module.h>
+
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 
+extern void arch_enable_nmi(void);
+extern void stop_watchdog(void);
+extern void reset_watchdog(void);
+extern void show_registers(struct pt_regs *regs);
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+extern void handle_BUG(struct pt_regs *regs);
+#else
+#define handle_BUG(regs)
+#endif
+
 static int kstack_depth_to_print = 24;
 
-extern int raw_printk(const char *fmt, ...);
+void (*nmi_handler)(struct pt_regs *);
 
-void show_trace(unsigned long * stack)
+void
+show_trace(unsigned long *stack)
 {
 	unsigned long addr, module_start, module_end;
 	extern char _stext, _etext;
 	int i;
 
-        raw_printk("\nCall Trace: ");
+	printk("\nCall Trace: ");
 
-        i = 1;
-        module_start = VMALLOC_START;
-        module_end = VMALLOC_END;
+	i = 1;
+	module_start = VMALLOC_START;
+	module_end = VMALLOC_END;
 
-        while (((long) stack & (THREAD_SIZE-1)) != 0) {
-		if (__get_user (addr, stack)) {
+	while (((long)stack & (THREAD_SIZE-1)) != 0) {
+		if (__get_user(addr, stack)) {
 			/* This message matches "failing address" marked
 			   s390 in ksymoops, so lines containing it will
 			   not be filtered out by ksymoops.  */
-			raw_printk ("Failing address 0x%lx\n", (unsigned long)stack);
+			printk("Failing address 0x%lx\n", (unsigned long)stack);
 			break;
 		}
 		stack++;
 
-                /*
-                 * If the address is either in the text segment of the
-                 * kernel, or in the region which contains vmalloc'ed
-                 * memory, it *may* be the address of a calling
-                 * routine; if so, print it so that someone tracing
-                 * down the cause of the crash will be able to figure
-                 * out the call path that was taken.
-                 */
-                if (((addr >= (unsigned long) &_stext) &&
-                     (addr <= (unsigned long) &_etext)) ||
-                    ((addr >= module_start) && (addr <= module_end))) {
-                        if (i && ((i % 8) == 0))
-                                raw_printk("\n       ");
-                        raw_printk("[<%08lx>] ", addr);
-                        i++;
-                }
-        }
+		/*
+		 * If the address is either in the text segment of the
+		 * kernel, or in the region which contains vmalloc'ed
+		 * memory, it *may* be the address of a calling
+		 * routine; if so, print it so that someone tracing
+		 * down the cause of the crash will be able to figure
+		 * out the call path that was taken.
+		 */
+		if (((addr >= (unsigned long)&_stext) &&
+		     (addr <= (unsigned long)&_etext)) ||
+		    ((addr >= module_start) && (addr <= module_end))) {
+			if (i && ((i % 8) == 0))
+				printk("\n       ");
+			printk("[<%08lx>] ", addr);
+			i++;
+		}
+	}
 }
 
 /*
@@ -78,109 +90,149 @@ void show_trace(unsigned long * stack)
  * with the ksymoops maintainer.
  */
 
-void 
+void
 show_stack(struct task_struct *task, unsigned long *sp)
 {
-        unsigned long *stack, addr;
-        int i;
+	unsigned long *stack, addr;
+	int i;
 
 	/*
 	 * debugging aid: "show_stack(NULL);" prints a
 	 * back trace.
 	 */
 
-        if(sp == NULL) {
+	if (sp == NULL) {
 		if (task)
 			sp = (unsigned long*)task->thread.ksp;
 		else
 			sp = (unsigned long*)rdsp();
 	}
 
-        stack = sp;
+	stack = sp;
 
-	raw_printk("\nStack from %08lx:\n       ", (unsigned long)stack);
-        for(i = 0; i < kstack_depth_to_print; i++) {
-                if (((long) stack & (THREAD_SIZE-1)) == 0)
-                        break;
-                if (i && ((i % 8) == 0))
-                        raw_printk("\n       ");
-		if (__get_user (addr, stack)) {
+	printk("\nStack from %08lx:\n       ", (unsigned long)stack);
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (((long)stack & (THREAD_SIZE-1)) == 0)
+			break;
+		if (i && ((i % 8) == 0))
+			printk("\n       ");
+		if (__get_user(addr, stack)) {
 			/* This message matches "failing address" marked
 			   s390 in ksymoops, so lines containing it will
 			   not be filtered out by ksymoops.  */
-			raw_printk ("Failing address 0x%lx\n", (unsigned long)stack);
+			printk("Failing address 0x%lx\n", (unsigned long)stack);
 			break;
 		}
 		stack++;
-		raw_printk("%08lx ", addr);
-        }
+		printk("%08lx ", addr);
+	}
 	show_trace(sp);
 }
 
-static void (*nmi_handler)(struct pt_regs*);
-extern void arch_enable_nmi(void);
+#if 0
+/* displays a short stack trace */
 
-void set_nmi_handler(void (*handler)(struct pt_regs*))
+int
+show_stack(void)
 {
-  nmi_handler = handler;
-  arch_enable_nmi();
+	unsigned long *sp = (unsigned long *)rdusp();
+	int i;
+
+	printk("Stack dump [0x%08lx]:\n", (unsigned long)sp);
+	for (i = 0; i < 16; i++)
+		printk("sp + %d: 0x%08lx\n", i*4, sp[i]);
+	return 0;
 }
+#endif
 
-void handle_nmi(struct pt_regs* regs)
+void
+dump_stack(void)
 {
-  if (nmi_handler)
-    nmi_handler(regs);
+	show_stack(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void
+set_nmi_handler(void (*handler)(struct pt_regs *))
+{
+	nmi_handler = handler;
+	arch_enable_nmi();
 }
 
 #ifdef CONFIG_DEBUG_NMI_OOPS
-void oops_nmi_handler(struct pt_regs* regs)
+void
+oops_nmi_handler(struct pt_regs *regs)
 {
-  stop_watchdog();
-  raw_printk("NMI!\n");
-  show_registers(regs);
+	stop_watchdog();
+	oops_in_progress = 1;
+	printk("NMI!\n");
+	show_registers(regs);
+	oops_in_progress = 0;
 }
 
-static int
-__init oops_nmi_register(void)
+static int __init
+oops_nmi_register(void)
 {
-  set_nmi_handler(oops_nmi_handler);
-  return 0;
+	set_nmi_handler(oops_nmi_handler);
+	return 0;
 }
 
 __initcall(oops_nmi_register);
 
 #endif
 
-#if 0
-/* displays a short stack trace */
-
-int 
-show_stack()
+/*
+ * This gets called from entry.S when the watchdog has bitten. Show something
+ * similiar to an Oops dump, and if the kernel is configured to be a nice
+ * doggy, then halt instead of reboot.
+ */
+void
+watchdog_bite_hook(struct pt_regs *regs)
 {
-	unsigned long *sp = (unsigned long *)rdusp();
-	int i;
-	raw_printk("Stack dump [0x%08lx]:\n", (unsigned long)sp);
-	for(i = 0; i < 16; i++)
-		raw_printk("sp + %d: 0x%08lx\n", i*4, sp[i]);
-	return 0;
-}
+#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
+	local_irq_disable();
+	stop_watchdog();
+	show_registers(regs);
+
+	while (1)
+		; /* Do nothing. */
+#else
+	show_registers(regs);
 #endif
+}
 
-void dump_stack(void)
+/* This is normally the Oops function. */
+void
+die_if_kernel(const char *str, struct pt_regs *regs, long err)
 {
-	show_stack(NULL, NULL);
-}
+	if (user_mode(regs))
+		return;
 
-EXPORT_SYMBOL(dump_stack);
+#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
+	/*
+	 * This printout might take too long and could trigger
+	 * the watchdog normally. If NICE_DOGGY is set, simply
+	 * stop the watchdog during the printout.
+	 */
+	stop_watchdog();
+#endif
 
-void __init 
-trap_init(void)
-{
-	/* Nothing needs to be done */
+	handle_BUG(regs);
+
+	printk("%s: %04lx\n", str, err & 0xffff);
+
+	show_registers(regs);
+
+	oops_in_progress = 0;
+
+#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
+	reset_watchdog();
+#endif
+	do_exit(SIGSEGV);
 }
 
-void spinning_cpu(void* addr)
+void __init
+trap_init(void)
 {
-  raw_printk("CPU %d spinning on %X\n", smp_processor_id(), addr);
-  dump_stack();
+	/* Nothing needs to be done */
 }
-- 
1.5.3.6.970.gd25430

