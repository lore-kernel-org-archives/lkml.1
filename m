Return-Path: <linux-kernel-owner+w=401wt.eu-S1767307AbXECB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767307AbXECB4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 21:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767311AbXECB4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 21:56:18 -0400
Received: from gw.goop.org ([64.81.55.164]:35745 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767307AbXECB4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 21:56:17 -0400
Message-ID: <46394139.605@goop.org>
Date: Wed, 02 May 2007 18:56:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two bugs:
 - the stack allocation must be marked __cpuinit, since it gets called
   on resume as well.
 - presumably the interrupt stack should be freed on unplug if its
   going to get reallocated on every plug.

[ Only non-vmalloced stacks tested. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/i386/kernel/irq.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -195,10 +195,13 @@ static int __init irq_guard_cpu0(void)
 }
 core_initcall(irq_guard_cpu0);
 
-static void * __init __alloc_irqstack(int cpu)
+static DEFINE_PER_CPU(struct page *, irqstack_pages[THREAD_SIZE/PAGE_SIZE]);
+static DEFINE_PER_CPU(struct vm_struct *, irqstack_area);
+
+static void * __cpuinit __alloc_irqstack(int cpu)
 {
 	int i;
-	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
+	struct page **pages = per_cpu(irqstack_pages, cpu), **tmp = pages;
 	struct vm_struct *area;
 
 	if (!cpu)
@@ -207,13 +210,27 @@ static void * __init __alloc_irqstack(in
 
 	/* failures here are unrecoverable anyway */
 	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
-	for (i = 0; i < ARRAY_SIZE(pages); ++i)
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
 		pages[i] = alloc_page(GFP_HIGHUSER);
 	map_vm_area(area, PAGE_KERNEL, &tmp);
+	per_cpu(irqstack_area, cpu) = area;
 	return area->addr;
 }
+
+static void __cpuinit __free_irqstack(int cpu, void *stk)
+{
+	int i;
+
+	if (!cpu)
+		return;
+
+	unmap_vm_area(per_cpu(irqstack_area, cpu));
+
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
+		__free_page(per_cpu(irqstack_pages, cpu)[i]);
+}
 #else /* !CONFIG_VMALLOC_STACK */
-static void * __init __alloc_irqstack(int cpu)
+static void * __cpuinit __alloc_irqstack(int cpu)
 {
 	if (!cpu)
 		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
@@ -222,12 +239,26 @@ static void * __init __alloc_irqstack(in
 	return (void *)__get_free_pages(GFP_KERNEL,
 					ilog2(THREAD_SIZE/PAGE_SIZE));
 }
+
+static void __cpuinit __free_irqstack(int cpu, void *stk)
+{
+	if (!cpu)
+		return;
+
+	free_pages((unsigned long)stk, ilog2(THREAD_SIZE/PAGE_SIZE));
+}
 #endif /* !CONFIG_VMALLOC_STACK */
 
-static void __init alloc_irqstacks(int cpu)
+static void __cpuinit alloc_irqstacks(int cpu)
 {
 	per_cpu(softirq_stack, cpu) = __alloc_irqstack(cpu);
 	per_cpu(hardirq_stack, cpu) = __alloc_irqstack(cpu);
+}
+
+static void __cpuinit free_irqstacks(int cpu)
+{
+	__free_irqstack(cpu, per_cpu(softirq_stack, cpu));
+	__free_irqstack(cpu, per_cpu(hardirq_stack, cpu));
 }
 
 /*
@@ -266,6 +297,7 @@ void irq_ctx_init(int cpu)
 
 void irq_ctx_exit(int cpu)
 {
+	free_irqstacks(cpu);
 	per_cpu(hardirq_ctx, cpu) = NULL;
 }
 

