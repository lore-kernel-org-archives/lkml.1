Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZBQDsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZBQDsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZBQDsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:48:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZBQDsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:48:00 -0500
Message-ID: <499A3322.3030704@cn.fujitsu.com>
Date: Tue, 17 Feb 2009 11:46:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86,4kstack: use percpu data for hardirq and softirq stack
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: economize memory for large NR_CPUS

percpu data is setup earlier than irq, we can use percpu data
to economize memory.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 irq_32.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 74b9ff7..aafd483 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -16,6 +16,7 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <linux/percpu.h>
 
 #include <asm/apic.h>
 
@@ -55,13 +56,13 @@ static inline void print_stack_overflow(void) { }
 union irq_ctx {
 	struct thread_info      tinfo;
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
-};
+} __attribute__((aligned(PAGE_SIZE)));
 
-static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
-static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
+static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
+static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
-static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
+static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);
 
 static void call_on_stack(void *func, void *stack)
 {
@@ -81,7 +82,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	u32 *isp, arg1, arg2;
 
 	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = hardirq_ctx[smp_processor_id()];
+	irqctx = __get_cpu_var(hardirq_ctx);
 
 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -125,34 +126,34 @@ void __cpuinit irq_ctx_init(int cpu)
 {
 	union irq_ctx *irqctx;
 
-	if (hardirq_ctx[cpu])
+	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = (union irq_ctx*) &hardirq_stack[cpu*THREAD_SIZE];
+	irqctx = &per_cpu(hardirq_stack, cpu);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
-	hardirq_ctx[cpu] = irqctx;
+	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = (union irq_ctx *) &softirq_stack[cpu*THREAD_SIZE];
+	irqctx = &per_cpu(softirq_stack, cpu);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= 0;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
-	softirq_ctx[cpu] = irqctx;
+	per_cpu(softirq_ctx, cpu) = irqctx;
 
 	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",
-	       cpu, hardirq_ctx[cpu], softirq_ctx[cpu]);
+	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
 }
 
 void irq_ctx_exit(int cpu)
 {
-	hardirq_ctx[cpu] = NULL;
+	per_cpu(hardirq_ctx, cpu) = NULL;
 }
 
 asmlinkage void do_softirq(void)
@@ -169,7 +170,7 @@ asmlinkage void do_softirq(void)
 
 	if (local_softirq_pending()) {
 		curctx = current_thread_info();
-		irqctx = softirq_ctx[smp_processor_id()];
+		irqctx = __get_cpu_var(softirq_ctx);
 		irqctx->tinfo.task = curctx->task;
 		irqctx->tinfo.previous_esp = current_stack_pointer;
 


