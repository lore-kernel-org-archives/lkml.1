Return-Path: <linux-kernel-owner+w=401wt.eu-S1767401AbXECFsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767401AbXECFsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 01:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767403AbXECFsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 01:48:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25414 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767401AbXECFsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 01:48:16 -0400
Date: Wed, 2 May 2007 22:48:09 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Message-ID: <20070503054809.GF26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46394139.605@goop.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 06:56:09PM -0700, Jeremy Fitzhardinge wrote:
> This fixes two bugs:
>  - the stack allocation must be marked __cpuinit, since it gets called
>    on resume as well.
>  - presumably the interrupt stack should be freed on unplug if its
>    going to get reallocated on every plug.
> [ Only non-vmalloced stacks tested. ]
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/i386/kernel/irq.c |   42 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 37 insertions(+), 5 deletions(-)

Updated patch follows. Please add your Signed-off-by: if it meets your
approval; I am operating on the assumption I should never do so myself.
I'm a bit unsure of how to handle cpu 0 vs. potential freeing of per_cpu
areas and error returns from __cpuinit affairs, but anyhow:

This fixes three bugs:
  - the stack allocation must be marked __cpuinit, since it gets called
    on resume as well.
  - presumably the interrupt stack should be freed on unplug if its
    going to get reallocated on every plug.
  - the vm_struct got leaked by thread info freeing callbacks.
Signed-off-by: William Irwin <bill.irwin@oracle.com>


Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-05-02 19:33:23.937945981 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-05-02 21:17:41.134523293 -0700
@@ -142,18 +142,19 @@
  * These should really be __section__(".bss.page_aligned") as well, but
  * gcc's 3.0 and earlier don't handle that correctly.
  */
-static DEFINE_PER_CPU(char *, softirq_stack);
-static DEFINE_PER_CPU(char *, hardirq_stack);
-
+struct irq_stack_info {
+	char *stack;
 #ifdef CONFIG_DEBUG_STACK
-static void * __init irq_remap_stack(void *stack)
-{
-	int i;
 	struct page *pages[THREAD_SIZE/PAGE_SIZE];
+#endif /* CONFIG_DEBUG_STACK */
+};
+static DEFINE_PER_CPU(struct irq_stack_info, softirq_stack_info);
+static DEFINE_PER_CPU(struct irq_stack_info, hardirq_stack_info);
 
-	for (i = 0; i < ARRAY_SIZE(pages); ++i)
-		pages[i] =  virt_to_page(stack + PAGE_SIZE*i);
-	return vmap(pages, THREAD_SIZE/PAGE_SIZE, VM_IOREMAP, PAGE_KERNEL);
+#ifdef CONFIG_DEBUG_STACK
+static void * __init irq_remap_stack(struct irq_stack_info *info)
+{
+	return vmap(info->pages, ARRAY_SIZE(info->pages), VM_IOREMAP, PAGE_KERNEL);
 }
 
 static int __init irq_guard_cpu0(void)
@@ -161,59 +162,110 @@
 	unsigned long flags;
 	void *tmp;
 
-	tmp = irq_remap_stack(per_cpu(softirq_stack, 0));
+	tmp = irq_remap_stack(&per_cpu(softirq_stack_info, 0));
 	if (!tmp)
 		return -ENOMEM;
 	else {
 		local_irq_save(flags);
-		per_cpu(softirq_stack, 0) = tmp;
+		per_cpu(softirq_stack_info, 0).stack = tmp;
 		local_irq_restore(flags);
 	}
-	tmp = irq_remap_stack(per_cpu(hardirq_stack, 0));
+	tmp = irq_remap_stack(&per_cpu(hardirq_stack_info, 0));
 	if (!tmp)
 		return -ENOMEM;
 	else {
 		local_irq_save(flags);
-		per_cpu(hardirq_stack, 0) = tmp;
+		per_cpu(hardirq_stack_info, 0).stack = tmp;
 		local_irq_restore(flags);
 	}
 	return 0;
 }
 core_initcall(irq_guard_cpu0);
 
-static void * __init __alloc_irqstack(int cpu)
+static int __cpuinit __alloc_irqstack(int cpu, struct irq_stack_info *info)
 {
 	int i;
-	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
-	struct vm_struct *area;
 
-	if (!slab_is_available())
-		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+	if (!slab_is_available()) {
+		WARN_ON(cpu != 0);
+		info->stack = __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
 						__pa(MAX_DMA_ADDRESS));
+		info->pages[0] = virt_to_page(info->stack);
+		for (i = 1; i < ARRAY_SIZE(info->pages); ++i)
+			info->pages[i] = info->pages[0] + i;
+		return 0;
+	}
+	for (i = 0; i < ARRAY_SIZE(info->pages); ++i) {
+		if (!cpu)
+			WARN_ON(!info->pages[i]);
+		else {
+			info->pages[i] = alloc_page(GFP_HIGHUSER);
+			if (!info->pages[i])
+				goto out;
+		}
+	}
+	info->stack = irq_remap_stack(info);
+	if (info->stack)
+		return 0;
+out:
+	if (cpu) {
+		for (--i; i >= 0; --i) {
+			__free_page(info->pages[i]);
+			info->pages[i] = NULL;
+		}
+	}
+	return -1;
+}
+
+static void __cpuinit __free_irqstack(int cpu, struct irq_stack_info *info)
+{
+	int i;
 
-	/* failures here are unrecoverable anyway */
-	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
-	for (i = 0; i < ARRAY_SIZE(pages); ++i)
-		pages[i] = alloc_page(GFP_HIGHUSER);
-	map_vm_area(area, PAGE_KERNEL, &tmp);
-	return area->addr;
+	vunmap(info->stack);
+	/* cpu 0 bootmem allocates its underlying pages */
+	if (!cpu)
+		return;
+	for (i = 0; i < ARRAY_SIZE(info->pages); ++i) {
+		__free_page(info->pages[i]);
+		info->pages[i] = NULL;
+	}
 }
 #else /* !CONFIG_DEBUG_STACK */
-static void * __init __alloc_irqstack(int cpu)
+static int __cpuinit __alloc_irqstack(int cpu, struct irq_stack_info *info)
 {
-	if (!slab_is_available())
-		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+	if (cpu)
+		info->stack = (void *)__get_free_pages(GFP_KERNEL,
+					ilog2(THREAD_SIZE/PAGE_SIZE));
+	else if (!slab_is_available())
+		info->stack = __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
 						__pa(MAX_DMA_ADDRESS));
+	else
+		BUG_ON(!info->stack);
+	return 0;
+}
 
-	return (void *)__get_free_pages(GFP_KERNEL,
-					ilog2(THREAD_SIZE/PAGE_SIZE));
+static void __cpuinit __free_irqstack(int cpu, struct irq_stack_info *info)
+{
+	if (cpu)
+		free_pages((unsigned long)info->stack, ilog2(THREAD_SIZE/PAGE_SIZE));
 }
 #endif /* !CONFIG_DEBUG_STACK */
 
-static void __init alloc_irqstacks(int cpu)
+static int __cpuinit alloc_irqstacks(int cpu)
+{
+	if (__alloc_irqstack(cpu, &per_cpu(softirq_stack_info, cpu)))
+		return -1;
+	if (__alloc_irqstack(cpu, &per_cpu(hardirq_stack_info, cpu))) {
+		__free_irqstack(cpu, &per_cpu(softirq_stack_info, cpu));
+		return -1;
+	}
+	return 0;
+}
+
+static void __cpuinit free_irqstacks(int cpu)
 {
-	per_cpu(softirq_stack, cpu) = __alloc_irqstack(cpu);
-	per_cpu(hardirq_stack, cpu) = __alloc_irqstack(cpu);
+	__free_irqstack(cpu, &per_cpu(softirq_stack_info, cpu));
+	__free_irqstack(cpu, &per_cpu(hardirq_stack_info, cpu));
 }
 
 /*
@@ -228,7 +280,7 @@
 
 	alloc_irqstacks(cpu);
 
-	irqctx = (union irq_ctx*)per_cpu(hardirq_stack, cpu);
+	irqctx = (union irq_ctx*)per_cpu(hardirq_stack_info, cpu).stack;
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
@@ -237,7 +289,7 @@
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = (union irq_ctx*)per_cpu(softirq_stack, cpu);
+	irqctx = (union irq_ctx*)per_cpu(softirq_stack_info, cpu).stack;
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
@@ -252,6 +304,7 @@
 
 void irq_ctx_exit(int cpu)
 {
+	free_irqstacks(cpu);
 	per_cpu(hardirq_ctx, cpu) = NULL;
 }
 
Index: stack-paranoia/arch/i386/kernel/process.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/process.c	2007-05-02 20:15:05.412496892 -0700
+++ stack-paranoia/arch/i386/kernel/process.c	2007-05-02 21:15:15.958250168 -0700
@@ -327,43 +327,38 @@
 struct thread_info *alloc_thread_info(struct task_struct *unused)
 {
 	int i;
-	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
-	struct vm_struct *area;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE];
+	struct thread_info *info;
 
 	/*
 	 * passing VM_IOREMAP for the sake of alignment is why
 	 * all this is done by hand.
 	 */
-	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
-	if (!area)
-		return NULL;
 	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i) {
 		pages[i] = alloc_page(GFP_HIGHUSER);
 		if (!pages[i])
 			goto out_free_pages;
 	}
-	/* implicitly transfer page refcounts to the vm_struct */
-	if (map_vm_area(area, PAGE_KERNEL, &tmp))
-		goto out_remove_area;
-	/* it may be worth poisoning, save thread_info proper */
-	return (struct thread_info *)area->addr;
-out_remove_area:
-	remove_vm_area(area);
+	info = vmap(pages, THREAD_SIZE/PAGE_SIZE, VM_IOREMAP, PAGE_KERNEL);
+	if (info)
+		return info;
 out_free_pages:
-	do {
-		__free_page(pages[--i]);
-	} while (i >= 0);
+	for (--i; i >= 0; --i)
+		__free_page(pages[i]);
 	return NULL;
 }
 
 static void work_free_thread_info(struct work_struct *work)
 {
 	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE];
 	void *p = work;
 
 	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
-		__free_page(vmalloc_to_page(p + PAGE_SIZE*i));
-	vfree(p);
+		pages[i] = vmalloc_to_page(p + PAGE_SIZE*i);
+	vunmap(work);
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
+		__free_page(pages[i]);
 }
 
 void free_thread_info(struct thread_info *info)

