Return-Path: <linux-kernel-owner+w=401wt.eu-S1767165AbXEBWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767165AbXEBWwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767168AbXEBWwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:52:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33571 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767165AbXEBWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:52:47 -0400
Date: Wed, 2 May 2007 15:48:23 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, wli@holomorphy.com
Subject: Re: [4/6] go BUG on vmallocspace in __pa()
Message-ID: <20070502224823.GC26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174510.GG19966@holomorphy.com> <46391127.3000608@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46391127.3000608@goop.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> +unsigned long __kvaddr_to_paddr(unsigned long kvaddr)
>> +{
>> +	if (high_memory)
>> +		BUG_ON(kvaddr >= VMALLOC_START);
>> +	else
>> +		BUG_ON(kvaddr >= (unsigned long)__va(MAXMEM));
>> +	return kvaddr - PAGE_OFFSET;
>> +}

On Wed, May 02, 2007 at 03:31:03PM -0700, Jeremy Fitzhardinge wrote:
> Needs to be exported so that modules can use __pa.  Though I suspect
> most modules doing so are buggy:

Done.


-- wli

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
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-05-01 10:18:50.942170611 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-05-01 10:19:47.145373449 -0700
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
--- stack-paranoia.orig/arch/i386/kernel/process.c	2007-05-01 10:18:50.950171067 -0700
+++ stack-paranoia/arch/i386/kernel/process.c	2007-05-01 10:19:47.145373449 -0700
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
--- stack-paranoia.orig/include/asm-i386/module.h	2007-05-01 10:18:50.998173802 -0700
+++ stack-paranoia/include/asm-i386/module.h	2007-05-01 10:19:47.145373449 -0700
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
--- stack-paranoia.orig/include/asm-i386/thread_info.h	2007-05-01 10:18:51.006174258 -0700
+++ stack-paranoia/include/asm-i386/thread_info.h	2007-05-01 10:19:47.149373677 -0700
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
--- stack-paranoia.orig/arch/i386/kernel/doublefault.c	2007-05-01 10:18:50.962171751 -0700
+++ stack-paranoia/arch/i386/kernel/doublefault.c	2007-05-01 10:19:47.149373677 -0700
@@ -62,5 +62,5 @@
 	.ss		= __KERNEL_DS,
 	.ds		= __USER_DS,
 
-	.__cr3		= __pa(swapper_pg_dir)
+	.__cr3		= (unsigned long)swapper_pg_dir - PAGE_OFFSET,
 };
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-05-01 10:19:43.941190853 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-05-01 10:20:41.160451593 -0700
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
+	if (!slab_is_available())
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
 	if (!slab_is_available())
@@ -154,6 +208,7 @@
 	return (void *)__get_free_pages(GFP_KERNEL,
 					ilog2(THREAD_SIZE/PAGE_SIZE));
 }
+#endif /* !CONFIG_DEBUG_STACK */
 
 static void __init alloc_irqstacks(int cpu)
 {
Index: stack-paranoia/arch/i386/mm/pgtable.c
===================================================================
--- stack-paranoia.orig/arch/i386/mm/pgtable.c	2007-05-01 10:18:50.986173118 -0700
+++ stack-paranoia/arch/i386/mm/pgtable.c	2007-05-02 15:45:13.877793914 -0700
@@ -181,6 +181,18 @@
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
+EXPORT_SYMBOL(__kvaddr_to_paddr);
+#endif /* CONFIG_DEBUG_STACK */
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
Index: stack-paranoia/include/asm-i386/page.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/page.h	2007-05-01 10:18:51.022175170 -0700
+++ stack-paranoia/include/asm-i386/page.h	2007-05-01 10:19:47.149373677 -0700
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
