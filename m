Return-Path: <linux-kernel-owner+w=401wt.eu-S1946545AbXD3RqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946545AbXD3RqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946541AbXD3RqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:46:09 -0400
Received: from holomorphy.com ([66.93.40.71]:50948 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946532AbXD3RqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:46:05 -0400
Date: Mon, 30 Apr 2007 10:46:30 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [5/6] dynamically allocate IRQ stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174630.GH19966@holomorphy.com>
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

Fix up the conflict between IRQ stacks and deep stacks by dynamically
allocating IRQ stacks.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/Kconfig.debug
===================================================================
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 10:34:07.058721717 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 10:36:14.553987258 -0700
@@ -107,7 +107,6 @@
 
 config 64KSTACKS
 	bool "Use 64KB for kernel stacks"
-	depends on !IRQSTACKS
 	help
 	  If you say Y here, the kernel will use a 64KB stacksize.
 	  This impedes running more threads on a system and also increases
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 10:34:07.058721717 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 10:36:14.553987258 -0700
@@ -17,9 +17,11 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/bootmem.h>
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
@@ -56,8 +58,8 @@
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
 };
 
-static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
-static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
+static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
+static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 #endif
 
 /*
@@ -102,7 +104,7 @@
 #ifdef CONFIG_IRQSTACKS
 
 	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = hardirq_ctx[smp_processor_id()];
+	irqctx = per_cpu(hardirq_ctx, smp_processor_id());
 
 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -150,11 +152,44 @@
  * These should really be __section__(".bss.page_aligned") as well, but
  * gcc's 3.0 and earlier don't handle that correctly.
  */
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+static DEFINE_PER_CPU(char *, softirq_stack);
+static DEFINE_PER_CPU(char *, hardirq_stack);
 
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+#ifdef CONFIG_VMALLOC_STACK
+static void * __init __alloc_irqstack(int cpu)
+{
+	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
+	struct vm_struct *area;
+
+	if (!cpu)
+		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+						__pa(MAX_DMA_ADDRESS));
+
+	/* failures here are unrecoverable anyway */
+	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
+	for (i = 0; i < ARRAY_SIZE(pages); ++i)
+		pages[i] = alloc_page(GFP_HIGHUSER);
+	map_vm_area(area, PAGE_KERNEL, &tmp);
+	return area->addr;
+}
+#else /* !CONFIG_VMALLOC_STACK */
+static void * __init __alloc_irqstack(int cpu)
+{
+	if (!cpu)
+		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+						__pa(MAX_DMA_ADDRESS));
+
+	return (void *)__get_free_pages(GFP_KERNEL,
+					ilog2(THREAD_SIZE/PAGE_SIZE));
+}
+#endif /* !CONFIG_VMALLOC_STACK */
+
+static void __init alloc_irqstacks(int cpu)
+{
+	per_cpu(softirq_stack, cpu) = __alloc_irqstack(cpu);
+	per_cpu(hardirq_stack, cpu) = __alloc_irqstack(cpu);
+}
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
@@ -163,34 +198,36 @@
 {
 	union irq_ctx *irqctx;
 
-	if (hardirq_ctx[cpu])
+	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = (union irq_ctx*) &hardirq_stack[cpu*THREAD_SIZE];
+	alloc_irqstacks(cpu);
+
+	irqctx = (union irq_ctx*)per_cpu(hardirq_stack, cpu);
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
 	irqctx->tinfo.preempt_count     = HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
 
-	hardirq_ctx[cpu] = irqctx;
+	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = (union irq_ctx*) &softirq_stack[cpu*THREAD_SIZE];
+	irqctx = (union irq_ctx*)per_cpu(softirq_stack, cpu);
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
 	irqctx->tinfo.preempt_count     = 0;
 	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
 
-	softirq_ctx[cpu] = irqctx;
+	per_cpu(softirq_ctx, cpu) = irqctx;
 
 	printk("CPU %u irqstacks, hard=%p soft=%p\n",
-		cpu,hardirq_ctx[cpu],softirq_ctx[cpu]);
+		cpu, per_cpu(hardirq_ctx, cpu), per_cpu(softirq_ctx, cpu));
 }
 
 void irq_ctx_exit(int cpu)
 {
-	hardirq_ctx[cpu] = NULL;
+	per_cpu(hardirq_ctx, cpu) = NULL;
 }
 
 extern asmlinkage void __do_softirq(void);
@@ -209,7 +246,7 @@
 
 	if (local_softirq_pending()) {
 		curctx = current_thread_info();
-		irqctx = softirq_ctx[smp_processor_id()];
+		irqctx = per_cpu(softirq_ctx, smp_processor_id());
 		irqctx->tinfo.task = curctx->task;
 		irqctx->tinfo.previous_esp = current_stack_pointer;
 
