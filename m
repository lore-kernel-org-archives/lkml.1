Return-Path: <linux-kernel-owner+w=401wt.eu-S966551AbXEHKqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966551AbXEHKqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966481AbXEHKqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:46:38 -0400
Received: from holomorphy.com ([66.93.40.71]:38141 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966480AbXEHKqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:46:36 -0400
Date: Tue, 8 May 2007 03:46:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-ID: <20070508104617.GI19966@holomorphy.com>
References: <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org> <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org> <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org> <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org> <20070508053132.GZ31925@holomorphy.com> <20070508085950.GB8034@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20070508085950.GB8034@one.firstfloor.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2007 at 10:31:32PM -0700, William Lee Irwin III wrote:
>> I think Andi's handling the mergework on those patches, but I'll check
>> in to see if I should rediff vs. -mm or what if you want them.
>> Andi, what's the verdict on those stack patches?

On Tue, May 08, 2007 at 10:59:50AM +0200, Andi Kleen wrote:
> I planned to merge them partially. Add the separate 4/8/irqstack options,
> add the vmalloc support, but not support the > 8K stacks. Haven't yet.

I respun things to incorporate some of hch's suggestions and to fix
an issue Jeremy Fitzhardinge had with CPU hotplug, and some suggestion
from someone else, too.

Basically what changed was:
( 1) drop the large stack config option patch entirely
( 2) fold the __pa() check into the vmalloc stack patch under #ifdef
( 3) rename CONFIG_VMALLOC_STACK to CONFIG_DEBUG_STACK
( 4) fold guarding CPU 0's IRQ stack into the vmalloc stack patch
( 5) make IRQ stacks unconditional instead of independently configurable
( 6) check slab_is_available() for CPU 0's bootmem vs. get_free_pages()
( 7) mark various things __cpuinit that needed to be
( 8) handle and propagate allocation errors up to __cpu_up()
( 9) redo CPU 0's IRQ stack allocation to normalize it for hotplug
(10) use a struct for IRQ stack state instead of 3 per_cpu vars

The current patch series needs the two fixup patches at the end folded
back into the patches it fixes up, but follows in its entirety as a
series of MIME attachments. I've no idea what it applies against.


-- wli

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Description: dynamic-irq-stacks.patch
Content-Disposition: attachment; filename="dynamic-irq-stacks.patch"

Subject: dynamically allocate IRQ stacks

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
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-05-01 10:19:38.028853928 -0700
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
+	if (!slab_is_available())
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
 

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Description: unconditional-i386-irq-stacks.patch
Content-Disposition: attachment; filename="unconditional-i386-irq-stacks.patch"

IRQ stacks are a valuable stability feature. This patch makes them
unconditional, as there is no circumstance under which they do not
improve stability and they have no meaningful performance impact.

Signed-off-by: William Irwin <bill.irwin@oracle.com>


Index: stack-paranoia/include/asm-i386/irq.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/irq.h	2007-04-30 14:29:14.390652748 -0700
+++ stack-paranoia/include/asm-i386/irq.h	2007-04-30 14:32:46.742754004 -0700
@@ -24,14 +24,9 @@
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-#ifdef CONFIG_4KSTACKS
-  extern void irq_ctx_init(int cpu);
-  extern void irq_ctx_exit(int cpu);
-# define __ARCH_HAS_DO_SOFTIRQ
-#else
-# define irq_ctx_init(cpu) do { } while (0)
-# define irq_ctx_exit(cpu) do { } while (0)
-#endif
+void irq_ctx_init(int);
+void irq_ctx_exit(int);
+#define __ARCH_HAS_DO_SOFTIRQ
 
 #ifdef CONFIG_IRQBALANCE
 extern int irqbalance_disable(char *str);
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 14:31:14.717509785 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 14:43:02.869865087 -0700
@@ -49,7 +49,6 @@
 #endif
 }
 
-#ifdef CONFIG_4KSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -60,7 +59,6 @@
 
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
-#endif
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -73,10 +71,8 @@
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
-#endif
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -100,9 +96,6 @@
 		}
 	}
 #endif
-
-#ifdef CONFIG_4KSTACKS
-
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = per_cpu(hardirq_ctx, smp_processor_id());
 
@@ -138,7 +131,6 @@
 			: "memory", "cc"
 		);
 	} else
-#endif
 		desc->handle_irq(irq, desc);
 
 	irq_exit();
@@ -146,8 +138,6 @@
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
-
 /*
  * These should really be __section__(".bss.page_aligned") as well, but
  * gcc's 3.0 and earlier don't handle that correctly.
@@ -251,7 +241,6 @@
 }
 
 EXPORT_SYMBOL(do_softirq);
-#endif
 
 /*
  * Interrupt statistics:

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Description: debug-stack.patch
Content-Disposition: attachment; filename="debug-stack.patch"

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

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Description: fitz.patch
Content-Disposition: attachment; filename="fitz.patch"

Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-05-02 19:33:23.937945981 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-05-02 23:37:07.879316906 -0700
@@ -142,78 +142,138 @@
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
-}
-
-static int __init irq_guard_cpu0(void)
+#ifdef CONFIG_DEBUG_STACK
+static int __init irq_remap_stack(struct irq_stack_info *info)
 {
+	struct page *page, *pages[THREAD_SIZE/PAGE_SIZE];
 	unsigned long flags;
+	int i;
 	void *tmp;
 
-	tmp = irq_remap_stack(per_cpu(softirq_stack, 0));
-	if (!tmp)
-		return -ENOMEM;
-	else {
-		local_irq_save(flags);
-		per_cpu(softirq_stack, 0) = tmp;
-		local_irq_restore(flags);
+	for (i = 0; i < ARRAY_SIZE(pages); ++i) {
+		pages[i] = alloc_page(GFP_HIGHUSER);
+		if (!pages[i])
+			goto out_free_pages;
 	}
-	tmp = irq_remap_stack(per_cpu(hardirq_stack, 0));
+	tmp = vmap(pages, ARRAY_SIZE(info->pages), VM_IOREMAP, PAGE_KERNEL);
 	if (!tmp)
-		return -ENOMEM;
+		goto out_free_pages;
 	else {
 		local_irq_save(flags);
-		per_cpu(hardirq_stack, 0) = tmp;
+		memcpy(info->pages, pages, sizeof(pages));
+		page = virt_to_page(info->stack);
+		for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i) {
+			ClearPageReserved(&page[i]);
+			init_page_count(&page[i]);
+			__free_page(&page[i]);
+		}
+		info->stack = tmp;
 		local_irq_restore(flags);
 	}
 	return 0;
+out_free_pages:
+	for (--i; i >= 0; --i)
+		__free_page(pages[i]);
+	return -1;
+}
+
+static int __init irq_guard_cpu0(void)
+{
+	if (irq_remap_stack(&per_cpu(softirq_stack_info, 0)))
+		return -ENOMEM;
+	if (irq_remap_stack(&per_cpu(hardirq_stack_info, 0)))
+		return -ENOMEM;
+	return 0;
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
+		info->stack = __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
 						__pa(MAX_DMA_ADDRESS));
+		info->pages[0] = virt_to_page(info->stack);
+		for (i = 1; i < ARRAY_SIZE(info->pages); ++i)
+			info->pages[i] = info->pages[0] + i;
+		return 0;
+	}
+	for (i = 0; i < ARRAY_SIZE(info->pages); ++i) {
+		info->pages[i] = alloc_page(GFP_HIGHUSER);
+		if (!info->pages[i])
+			goto out;
+	}
+	info->stack = vmap(info->pages, ARRAY_SIZE(info->pages), VM_IOREMAP,
+								 PAGE_KERNEL);
+	if (info->stack)
+		return 0;
+out:
+	for (--i; i >= 0; --i) {
+		__free_page(info->pages[i]);
+		info->pages[i] = NULL;
+	}
+	return -1;
+}
 
-	/* failures here are unrecoverable anyway */
-	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
-	for (i = 0; i < ARRAY_SIZE(pages); ++i)
-		pages[i] = alloc_page(GFP_HIGHUSER);
-	map_vm_area(area, PAGE_KERNEL, &tmp);
-	return area->addr;
+static void __cpuinit __free_irqstack(int cpu, struct irq_stack_info *info)
+{
+	int i;
+
+	vunmap(info->stack);
+	for (i = 0; i < ARRAY_SIZE(info->pages); ++i) {
+		if (!PageReserved(info->pages[i]))
+			__free_page(info->pages[i]);
+		info->pages[i] = NULL;
+	}
+	info->stack = NULL;
 }
 #else /* !CONFIG_DEBUG_STACK */
-static void * __init __alloc_irqstack(int cpu)
+static int __cpuinit __alloc_irqstack(int cpu, struct irq_stack_info *info)
 {
 	if (!slab_is_available())
-		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
+		info->stack = __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
 						__pa(MAX_DMA_ADDRESS));
-
-	return (void *)__get_free_pages(GFP_KERNEL,
+	else
+		info->stack = (void *)__get_free_pages(GFP_KERNEL,
 					ilog2(THREAD_SIZE/PAGE_SIZE));
+	return info->stack ? 0 : -1;
+}
+
+static void __cpuinit __free_irqstack(int cpu, struct irq_stack_info *info)
+{
+	struct page *page = virt_to_page(info->stack);
+
+	if (!PageReserved(page))
+		__free_pages(page, ilog2(THREAD_SIZE/PAGE_SIZE));
+	info->stack = NULL;
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
@@ -228,7 +288,7 @@
 
 	alloc_irqstacks(cpu);
 
-	irqctx = (union irq_ctx*)per_cpu(hardirq_stack, cpu);
+	irqctx = (union irq_ctx*)per_cpu(hardirq_stack_info, cpu).stack;
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
@@ -237,7 +297,7 @@
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = (union irq_ctx*)per_cpu(softirq_stack, cpu);
+	irqctx = (union irq_ctx*)per_cpu(softirq_stack_info, cpu).stack;
 	irqctx->tinfo.task              = NULL;
 	irqctx->tinfo.exec_domain       = NULL;
 	irqctx->tinfo.cpu               = cpu;
@@ -252,6 +312,7 @@
 
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

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Description: irq-ctx-status.patch
Content-Disposition: attachment; filename="irq-ctx-status.patch"

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

--x+6KMIRAuhnl3hBn--
