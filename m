Return-Path: <linux-kernel-owner+w=401wt.eu-S1946131AbXD3Xpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946131AbXD3Xpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946150AbXD3Xpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:45:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60143 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946127AbXD3Xot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:44:49 -0400
Date: Mon, 30 Apr 2007 16:40:30 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
       gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, hch@infradead.org, jengelh@linux01.gwdg.de,
       zwane@infradead.org, neilb@suse.de, jens.axboe@oracle.com,
       eric@provenscaling.com, wli@holomorphy.com
Subject: [3/3] use vmalloc() to arrange guard pages for stacks
Message-ID: <20070430234030.GJ26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
	gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, hch@infradead.org,
	jengelh@linux01.gwdg.de, zwane@infradead.org, neilb@suse.de,
	jens.axboe@oracle.com, eric@provenscaling.com
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com> <20070430233712.GI26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430233712.GI26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces CONFIG_DEBUG_STACK, which vmalloc()'s task and IRQ
stacks in order to establish guard pages. In such a manner any stack
overflow that references pages immediately adjacent to the stack is
immediately trapped with a fault, which precludes silent memory corruption
or difficult-to-decipher failure modes resulting from stack corruption.

It furthermore adds a check to __pa() to catch drivers trying to DMA off
the stack, which more generally flags incorrect attempts to use __pa()
on vmallocspace addresses.

Signed-off-by: William Irwin <bill.irwin@oracle.com>


Index: stack-paranoia/arch/i386/Kconfig.debug
===================================================================
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 14:43:02.849863948 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 14:58:50.483866532 -0700
@@ -35,6 +35,16 @@
 
 	  This option will slow down process creation somewhat.
 
+config DEBUG_STACK
+	bool "Debug stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  Allocates the stack physically discontiguously and from high
+	  memory. Furthermore an unmapped guard page follows the stack,
+	  which results in immediately trapping stack overflows instead
+	  of silent corruption. This is not for end-users. It's intended
+	  to trigger fatal system errors under various forms of stack abuse.
+
 comment "Page alloc debug is incompatible with Software Suspend on i386"
 	depends on DEBUG_KERNEL && SOFTWARE_SUSPEND
 
Index: stack-paranoia/arch/i386/kernel/process.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/process.c	2007-04-30 14:43:02.857864404 -0700
+++ stack-paranoia/arch/i386/kernel/process.c	2007-04-30 14:56:16.499091440 -0700
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
@@ -322,6 +323,58 @@
 	show_trace(NULL, regs, &regs->esp);
 }
 
+#ifdef CONFIG_DEBUG_STACK
+struct thread_info *alloc_thread_info(struct task_struct *unused)
+{
+	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
+	struct vm_struct *area;
+
+	/*
+	 * passing VM_IOREMAP for the sake of alignment is why
+	 * all this is done by hand.
+	 */
+	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
+	if (!area)
+		return NULL;
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i) {
+		pages[i] = alloc_page(GFP_HIGHUSER);
+		if (!pages[i])
+			goto out_free_pages;
+	}
+	/* implicitly transfer page refcounts to the vm_struct */
+	if (map_vm_area(area, PAGE_KERNEL, &tmp))
+		goto out_remove_area;
+	/* it may be worth poisoning, save thread_info proper */
+	return (struct thread_info *)area->addr;
+out_remove_area:
+	remove_vm_area(area);
+out_free_pages:
+	do {
+		__free_page(pages[--i]);
+	} while (i >= 0);
+	return NULL;
+}
+
+static void work_free_thread_info(struct work_struct *work)
+{
+	int i;
+	void *p = work;
+
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
+		__free_page(vmalloc_to_page(p + PAGE_SIZE*i));
+	vfree(p);
+}
+
+void free_thread_info(struct thread_info *info)
+{
+	struct work_struct *work = (struct work_struct *)info;
+
+	INIT_WORK(work, work_free_thread_info);
+	schedule_work(work);
+}
+#endif
+
 /*
  * This gets run with %ebx containing the
  * function to call, and %edx containing
Index: stack-paranoia/include/asm-i386/module.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/module.h	2007-04-30 14:43:02.905867139 -0700
+++ stack-paranoia/include/asm-i386/module.h	2007-04-30 14:59:27.005947807 -0700
@@ -68,6 +68,13 @@
 #define MODULE_STACKSIZE ""
 #endif
 
-#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+#ifdef CONFIG_DEBUG_STACK
+#define MODULE_DEBUG_STACK "DEBUG_STACKS "
+#else
+#define MODULE_DEBUG_STACK ""
+#endif
+
+#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE \
+		MODULE_DEBUG_STACK
 
 #endif /* _ASM_I386_MODULE_H */
Index: stack-paranoia/include/asm-i386/thread_info.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/thread_info.h	2007-04-30 14:43:02.913867595 -0700
+++ stack-paranoia/include/asm-i386/thread_info.h	2007-04-30 15:00:59.963245141 -0700
@@ -94,6 +94,11 @@
 }
 
 /* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK
+struct task_struct;
+struct thread_info *alloc_thread_info(struct task_struct *);
+void free_thread_info(struct thread_info *);
+#else /* !CONFIG_DEBUG_STACK */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
 #else
@@ -101,6 +106,7 @@
 #endif
 
 #define free_thread_info(info)	kfree(info)
+#endif /* !CONFIG_DEBUG_STACK */
 
 #else /* !__ASSEMBLY__ */
 
Index: stack-paranoia/arch/i386/kernel/doublefault.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/doublefault.c	2007-04-30 14:43:02.877865543 -0700
+++ stack-paranoia/arch/i386/kernel/doublefault.c	2007-04-30 14:47:16.200301566 -0700
@@ -62,5 +62,5 @@
 	.ss		= __KERNEL_DS,
 	.ds		= __USER_DS,
 
-	.__cr3		= __pa(swapper_pg_dir)
+	.__cr3		= (unsigned long)swapper_pg_dir - PAGE_OFFSET,
 };
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 14:43:02.869865087 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 14:57:02.933737599 -0700
@@ -18,7 +18,7 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
-
+#include <linux/mm.h>
 #include <asm/apic.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -145,6 +145,60 @@
 static DEFINE_PER_CPU(char *, softirq_stack);
 static DEFINE_PER_CPU(char *, hardirq_stack);
 
+#ifdef CONFIG_DEBUG_STACK
+static void * __init irq_remap_stack(void *stack)
+{
+	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE];
+
+	for (i = 0; i < ARRAY_SIZE(pages); ++i)
+		pages[i] =  virt_to_page(stack + PAGE_SIZE*i);
+	return vmap(pages, THREAD_SIZE/PAGE_SIZE, VM_IOREMAP, PAGE_KERNEL);
+}
+
+static int __init irq_guard_cpu0(void)
+{
+	unsigned long flags;
+	void *tmp;
+
+	tmp = irq_remap_stack(per_cpu(softirq_stack, 0));
+	if (!tmp)
+		return -ENOMEM;
+	else {
+		local_irq_save(flags);
+		per_cpu(softirq_stack, 0) = tmp;
+		local_irq_restore(flags);
+	}
+	tmp = irq_remap_stack(per_cpu(hardirq_stack, 0));
+	if (!tmp)
+		return -ENOMEM;
+	else {
+		local_irq_save(flags);
+		per_cpu(hardirq_stack, 0) = tmp;
+		local_irq_restore(flags);
+	}
+	return 0;
+}
+core_initcall(irq_guard_cpu0);
+
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
+#else /* !CONFIG_DEBUG_STACK */
 static void * __init __alloc_irqstack(int cpu)
 {
 	if (!cpu)
@@ -154,6 +208,7 @@
 	return (void *)__get_free_pages(GFP_KERNEL,
 					ilog2(THREAD_SIZE/PAGE_SIZE));
 }
+#endif /* !CONFIG_DEBUG_STACK */
 
 static void __init alloc_irqstacks(int cpu)
 {
Index: stack-paranoia/arch/i386/mm/pgtable.c
===================================================================
--- stack-paranoia.orig/arch/i386/mm/pgtable.c	2007-04-30 14:43:02.889866227 -0700
+++ stack-paranoia/arch/i386/mm/pgtable.c	2007-04-30 14:57:31.683375948 -0700
@@ -181,6 +181,17 @@
 #endif
 }
 
+#ifdef CONFIG_DEBUG_STACK
+unsigned long __kvaddr_to_paddr(unsigned long kvaddr)
+{
+	if (high_memory)
+		BUG_ON(kvaddr >= VMALLOC_START);
+	else
+		BUG_ON(kvaddr >= (unsigned long)__va(MAXMEM));
+	return kvaddr - PAGE_OFFSET;
+}
+#endif /* CONFIG_DEBUG_STACK */
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
Index: stack-paranoia/include/asm-i386/page.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/page.h	2007-04-30 14:43:02.929868507 -0700
+++ stack-paranoia/include/asm-i386/page.h	2007-04-30 14:59:53.799474683 -0700
@@ -118,11 +118,17 @@
 #define __PAGE_OFFSET		((unsigned long)CONFIG_PAGE_OFFSET)
 #endif
 
-
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
+
+#if defined(CONFIG_DEBUG_STACK) && !defined(__ASSEMBLY__)
+unsigned long __kvaddr_to_paddr(unsigned long);
+#define __pa(x)			__kvaddr_to_paddr((unsigned long)(x))
+#else /* !CONFIG_DEBUG_STACK */
+#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
+#endif /* !CONFIG_DEBUG_STACK */
+
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
-#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)          __pa(RELOC_HIDE((unsigned long)(x),0))
