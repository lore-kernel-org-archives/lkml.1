Return-Path: <linux-kernel-owner+w=401wt.eu-S1031573AbXD3RoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031573AbXD3RoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031578AbXD3RoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:44:01 -0400
Received: from holomorphy.com ([66.93.40.71]:56427 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031573AbXD3Rnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:43:41 -0400
Date: Mon, 30 Apr 2007 10:44:05 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [3/6] make IRQ stacks independently configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174405.GF19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> Here's what I did for i386 for someone concerned about blowing the stack.

Divorce IRQ stack configuration from CONFIG_4KSTACKS, as it's believed to
be an important safety measure regardless of stack size by some users.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/Kconfig.debug
===================================================================
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 10:32:56.182682722 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 10:34:07.058721717 -0700
@@ -35,6 +35,14 @@
 
 	  This option will slow down process creation somewhat.
 
+config IRQSTACKS
+	bool "IRQ stacks"
+	depends on DEBUG_KERNEL
+	help
+	  Arranges for per-cpu interrupt stacks so that interrupts
+	  and interrupt-time processing don't consume space on task
+	  stacks.
+
 config VMALLOC_STACK
 	bool "vmalloc() the stack"
 	depends on DEBUG_KERNEL
@@ -76,8 +84,7 @@
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
 	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
+	  on the VM subsystem for higher order allocations.
 
 config 8KSTACKS
 	bool "Use 8KB for kernel stacks"
@@ -90,7 +97,6 @@
 	  If you say Y here, the kernel will use a 16KB stacksize.
 	  This impedes running more threads on a system and also increases
 	  the pressure on the VM subsystem for higher order allocations.
-	  This option will also use IRQ stacks to for additional safety.
 
 config 32KSTACKS
 	bool "Use 32KB for kernel stacks"
@@ -98,15 +104,14 @@
 	  If you say Y here, the kernel will use a 32KB stacksize.
 	  This impedes running more threads on a system and also increases
 	  the pressure on the VM subsystem for higher order allocations.
-	  This option will also use IRQ stacks to for additional safety.
 
 config 64KSTACKS
 	bool "Use 64KB for kernel stacks"
+	depends on !IRQSTACKS
 	help
 	  If you say Y here, the kernel will use a 64KB stacksize.
 	  This impedes running more threads on a system and also increases
 	  the pressure on the VM subsystem for higher order allocations.
-	  This option will also use IRQ stacks to for additional safety.
 
 endchoice
 
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 10:26:15.967875780 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 10:34:07.058721717 -0700
@@ -47,7 +47,7 @@
 #endif
 }
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_IRQSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -71,7 +71,7 @@
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_IRQSTACKS
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
@@ -99,7 +99,7 @@
 	}
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_IRQSTACKS
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = hardirq_ctx[smp_processor_id()];
@@ -144,7 +144,7 @@
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_IRQSTACKS
 
 /*
  * These should really be __section__(".bss.page_aligned") as well, but
Index: stack-paranoia/include/asm-i386/irq.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/irq.h	2007-04-30 10:26:31.904783972 -0700
+++ stack-paranoia/include/asm-i386/irq.h	2007-04-30 10:34:07.058721717 -0700
@@ -24,7 +24,7 @@
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_IRQSTACKS
   extern void irq_ctx_init(int cpu);
   extern void irq_ctx_exit(int cpu);
 # define __ARCH_HAS_DO_SOFTIRQ
Index: stack-paranoia/include/asm-i386/module.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/module.h	2007-04-30 10:32:56.182682722 -0700
+++ stack-paranoia/include/asm-i386/module.h	2007-04-30 10:34:07.058721717 -0700
@@ -80,7 +80,13 @@
 #define MODULE_VMALLOC_STACK ""
 #endif
 
+#ifdef CONFIG_IRQSTACKS
+#define MODULE_IRQSTACKS "IRQSTACKS "
+#else
+#define MODULE_IRQSTACKS ""
+#endif
+
 #define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE \
-		MODULE_VMALLOC_STACK
+		MODULE_VMALLOC_STACK MODULE_IRQSTACKS
 
 #endif /* _ASM_I386_MODULE_H */
