Return-Path: <linux-kernel-owner+w=401wt.eu-S1946148AbXD3XhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946148AbXD3XhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946132AbXD3Xg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:36:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56933 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946131AbXD3Xg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:36:56 -0400
Date: Mon, 30 Apr 2007 16:33:09 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
       gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, hch@infradead.org, jengelh@linux01.gwdg.de,
       zwane@infradead.org, neilb@suse.de, jens.axboe@oracle.com,
       eric@provenscaling.com, wli@holomorphy.com
Subject: [1/3] dynamically allocate IRQ stacks
Message-ID: <20070430233309.GH26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
	gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, hch@infradead.org,
	jengelh@linux01.gwdg.de, zwane@infradead.org, neilb@suse.de,
	jens.axboe@oracle.com, eric@provenscaling.com
References: <20070430232351.GG26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430232351.GG26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate IRQ stacks in order to conserve memory when using
IRQ stacks. cpu_possible_map is not now initialized in such a manner as
to provide a meaningful indication of how many CPU's might be in the
system, and features to appear in the sequel also require indirection,
so they themselves are not allocatable as per_cpu variables, but rather
only pointers to them.

Signed-off-by: William Irwin <bill.irwin@oracle.com>


Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 14:18:25.645682879 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 14:27:38.513189002 -0700
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
 #ifdef CONFIG_4KSTACKS
 
 	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = hardirq_ctx[smp_processor_id()];
+	irqctx = per_cpu(hardirq_ctx, smp_processor_id());
 
 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -150,11 +152,24 @@
  * These should really be __section__(".bss.page_aligned") as well, but
  * gcc's 3.0 and earlier don't handle that correctly.
  */
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+static DEFINE_PER_CPU(char *, softirq_stack);
+static DEFINE_PER_CPU(char *, hardirq_stack);
 
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+static void * __init __alloc_irqstack(int cpu)
+{
+	if (!cpu)
+		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+						__pa(MAX_DMA_ADDRESS));
+
+	return (void *)__get_free_pages(GFP_KERNEL,
+					ilog2(THREAD_SIZE/PAGE_SIZE));
+}
+
+static void __init alloc_irqstacks(int cpu)
+{
+	per_cpu(softirq_stack, cpu) = __alloc_irqstack(cpu);
+	per_cpu(hardirq_stack, cpu) = __alloc_irqstack(cpu);
+}
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
@@ -163,34 +178,36 @@
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
@@ -209,7 +226,7 @@
 
 	if (local_softirq_pending()) {
 		curctx = current_thread_info();
-		irqctx = softirq_ctx[smp_processor_id()];
+		irqctx = per_cpu(softirq_ctx, smp_processor_id());
 		irqctx->tinfo.task = curctx->task;
 		irqctx->tinfo.previous_esp = current_stack_pointer;
 
