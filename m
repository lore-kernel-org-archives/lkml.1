Return-Path: <linux-kernel-owner+w=401wt.eu-S1161495AbXECIEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161495AbXECIEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161504AbXECIEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:04:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27834 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495AbXECIET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:04:19 -0400
Date: Thu, 3 May 2007 01:04:09 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Bill Irwin <bill.irwin@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Message-ID: <20070503080409.GJ26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070503054809.GF26598@holomorphy.com> <46397AA1.8090606@goop.org> <20070503061233.GG26598@holomorphy.com> <46398A31.6040701@goop.org> <20070503073930.GI26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503073930.GI26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:39:30AM -0700, Bill Irwin wrote:
> As an aside, it looks like failures here need to eventually propagate
> to __cpu_up(). irq_ctx_init() needs to return a status, and its callers
> need to check it. irq_ctx_init() probably also needs to be __cpuinit.

Ignoring the general irq_ctx_init() cleanup this takes care of it.


Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-05-03 00:41:26.779223079 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-05-03 01:04:06.984736774 -0700
@@ -279,35 +279,31 @@
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
  */
-void irq_ctx_init(int cpu)
+static void __cpuinit
+__irq_ctx_init(union irq_ctx **irqctx, struct irq_stack_info *info,
+	       int cpu, int preempt_count)
 {
-	union irq_ctx *irqctx;
+	*irqctx = (union irq_ctx*)info->stack;
+	(*irqctx)->tinfo.task              = NULL;
+	(*irqctx)->tinfo.exec_domain       = NULL;
+	(*irqctx)->tinfo.cpu               = cpu;
+	(*irqctx)->tinfo.preempt_count     = preempt_count;
+	(*irqctx)->tinfo.addr_limit        = MAKE_MM_SEG(0);
+}
 
+int irq_ctx_init(int cpu)
+{
 	if (per_cpu(hardirq_ctx, cpu))
-		return;
-
-	alloc_irqstacks(cpu);
-
-	irqctx = (union irq_ctx*)per_cpu(hardirq_stack_info, cpu).stack;
-	irqctx->tinfo.task              = NULL;
-	irqctx->tinfo.exec_domain       = NULL;
-	irqctx->tinfo.cpu               = cpu;
-	irqctx->tinfo.preempt_count     = HARDIRQ_OFFSET;
-	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
-
-	per_cpu(hardirq_ctx, cpu) = irqctx;
-
-	irqctx = (union irq_ctx*)per_cpu(softirq_stack_info, cpu).stack;
-	irqctx->tinfo.task              = NULL;
-	irqctx->tinfo.exec_domain       = NULL;
-	irqctx->tinfo.cpu               = cpu;
-	irqctx->tinfo.preempt_count     = 0;
-	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
-
-	per_cpu(softirq_ctx, cpu) = irqctx;
-
+		return 0;
+	if (alloc_irqstacks(cpu))
+		return -1;
+	__irq_ctx_init(&per_cpu(hardirq_ctx, cpu),
+		       &per_cpu(hardirq_stack_info, cpu), cpu, HARDIRQ_OFFSET);
+	__irq_ctx_init(&per_cpu(softirq_ctx, cpu),
+		       &per_cpu(softirq_stack_info, cpu), cpu, 0);
 	printk("CPU %u irqstacks, hard=%p soft=%p\n",
 		cpu, per_cpu(hardirq_ctx, cpu), per_cpu(softirq_ctx, cpu));
+	return 0;
 }
 
 void irq_ctx_exit(int cpu)
Index: stack-paranoia/include/asm-i386/irq.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/irq.h	2007-05-03 00:48:40.015911831 -0700
+++ stack-paranoia/include/asm-i386/irq.h	2007-05-03 00:48:45.056199061 -0700
@@ -24,7 +24,7 @@
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-void irq_ctx_init(int);
+int irq_ctx_init(int);
 void irq_ctx_exit(int);
 #define __ARCH_HAS_DO_SOFTIRQ
 
Index: stack-paranoia/arch/i386/kernel/i8259.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/i8259.c	2007-05-03 00:49:04.185289165 -0700
+++ stack-paranoia/arch/i386/kernel/i8259.c	2007-05-03 00:54:49.104945016 -0700
@@ -417,5 +417,8 @@
 	if (boot_cpu_data.hard_math && !cpu_has_fpu)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
-	irq_ctx_init(smp_processor_id());
+	if (irq_ctx_init(smp_processor_id()))
+		printk(KERN_INFO
+		       "Couldn't allocate IRQ context for CPU %d\n",
+		       smp_processor_id());
 }
Index: stack-paranoia/arch/i386/kernel/smpboot.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/smpboot.c	2007-05-03 00:49:32.942927970 -0700
+++ stack-paranoia/arch/i386/kernel/smpboot.c	2007-05-03 00:52:03.739521378 -0700
@@ -828,9 +828,11 @@
 	printk("Booting processor %d/%d eip %lx\n", cpu, apicid, start_eip);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	stack_start.esp = (void *) idle->thread.esp;
-
-	irq_ctx_init(cpu);
-
+	if (irq_ctx_init(cpu)) {
+		printk(KERN_INFO
+		       "Couldn't allocate IRQ contexts for CPU %d\n", cpu);
+		return -1;
+	}
 	x86_cpu_to_apicid[cpu] = apicid;
 	/*
 	 * This grunge runs the startup process for
Index: stack-paranoia/arch/i386/mach-voyager/voyager_smp.c
===================================================================
--- stack-paranoia.orig/arch/i386/mach-voyager/voyager_smp.c	2007-05-03 00:52:39.609565495 -0700
+++ stack-paranoia/arch/i386/mach-voyager/voyager_smp.c	2007-05-03 00:53:32.516580494 -0700
@@ -589,8 +589,12 @@
 		return;
 	}
 
-	irq_ctx_init(cpu);
-
+	if (irq_ctx_init(cpu)) {
+		printk(KERN_INFO
+		       "Couldn't allocate IRQ context for CPU %d\n", cpu);
+		cpucount--;
+		return;
+	}
 	/* Note: Don't modify initial ss override */
 	VDEBUG(("VOYAGER SMP: Booting CPU%d at 0x%lx[%x:%x], stack %p\n", cpu, 
 		(unsigned long)hijack_source.val, hijack_source.idt.Segment,
