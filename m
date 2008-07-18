Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYGRMau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYGRMau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbYGRMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:30:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30234 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbYGRMaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:30:23 -0400
Message-Id: <4880A912.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:30:42 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: improve double fault handling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the double fault handler use CPU-specific stacks. Add some
abstraction to simplify future change of other exception handlers to go
through task gates.
Add a new notification of the event through the die notifier chain,
also providing some environmental adjustments so that various
infrastructural things work independent of the fact that the fault and
the callbacks are running on other then the normal kernel stack.

Signed-Off-By: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>

---
 arch/x86/kernel/cpu/common.c     |   17 +++++--
 arch/x86/kernel/doublefault_32.c |   86 ++++++++++++++++++++++++---------------
 arch/x86/kernel/smpboot.c        |   44 +++++++++++++++++++
 arch/x86/kernel/traps_32.c       |   51 ++++++++++++++++++++++-
 drivers/lguest/segments.c        |    3 -
 include/asm-x86/kdebug.h         |    1 
 include/asm-x86/processor.h      |    7 ++-
 include/asm-x86/segment.h        |   15 ++++--
 include/asm-x86/thread_info_32.h |    9 +++-
 9 files changed, 187 insertions(+), 46 deletions(-)

--- linux-2.6.26/arch/x86/kernel/cpu/common.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/arch/x86/kernel/cpu/common.c	2008-06-25 14:43:16.000000000 +0200
@@ -650,6 +650,13 @@ void switch_to_new_gdt(void)
 	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
+static void *__init_refok alloc_boot_stack(void)
+{
+	BUILD_BUG_ON(EXCEPTION_STACK_ORDER > THREAD_ORDER);
+	return __alloc_bootmem(EXCEPTION_STACK_SIZE, THREAD_SIZE,
+			       __pa(MAX_DMA_ADDRESS));
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -690,10 +697,12 @@ void __cpuinit cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-#ifdef CONFIG_DOUBLEFAULT
-	/* Set up doublefault TSS pointer in the GDT */
-	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
-#endif
+	if (cpu == 0) {
+		unsigned i;
+
+		for (i = 0; i < N_EXCEPTION_TSS; ++i)
+			setup_exception_tss(cpu, i, alloc_boot_stack);
+	}
 
 	/* Clear %gs. */
 	asm volatile ("mov %0, %%gs" : : "r" (0));
--- linux-2.6.26/arch/x86/kernel/doublefault_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.26-i386-double-fault/arch/x86/kernel/doublefault_32.c	2008-06-25 14:43:16.000000000 +0200
@@ -3,69 +3,89 @@
 #include <linux/init.h>
 #include <linux/init_task.h>
 #include <linux/fs.h>
+#include <linux/kdebug.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/desc.h>
 
-#define DOUBLEFAULT_STACKSIZE (1024)
-static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
-#define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
+#define ptr_ok(x, l) ((x) >= PAGE_OFFSET && (x) + (l) < (unsigned long)high_memory)
 
-#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
+#define THREAD_INFO_FROM(x) ((struct thread_info *)((x) & ~(THREAD_SIZE - 1)))
 
-static void doublefault_fn(void)
+register const struct x86_hw_tss *self __asm__("ebx");
+
+void doublefault_fn(void)
 {
-	struct desc_ptr gdt_desc = {0, 0};
+	struct desc_ptr gdt_desc;
 	unsigned long gdt, tss;
 
 	store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
-	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
+	printk(KERN_EMERG "PANIC: double fault on CPU#%lu, gdt at %08lx [%d bytes]\n",
+	       self->sp2, gdt, gdt_desc.size + 1);
 
-	if (ptr_ok(gdt)) {
+	if (ptr_ok(gdt, gdt_desc.size)) {
 		gdt += GDT_ENTRY_TSS << 3;
 		tss = *(u16 *)(gdt+2);
 		tss += *(u8 *)(gdt+4) << 16;
 		tss += *(u8 *)(gdt+7) << 24;
 		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
-		if (ptr_ok(tss)) {
-			struct x86_hw_tss *t = (struct x86_hw_tss *)tss;
+		if (ptr_ok(tss, *(u16 *)gdt)) {
+			const struct x86_hw_tss *t = (struct x86_hw_tss *)tss;
+			struct {
+				struct pt_regs common;
+				struct {
+					unsigned long es;
+					unsigned long ds;
+					unsigned long fs;
+					unsigned long gs;
+				} vm86;
+			} regs;
+
+			/* for current/current_thread_info to work... */
+			*THREAD_INFO_FROM(self->sp) = *THREAD_INFO_FROM(t->sp0 - 1);
 
 			printk(KERN_EMERG "eip = %08lx, esp = %08lx\n",
 			       t->ip, t->sp);
 
 			printk(KERN_EMERG "eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
 				t->ax, t->bx, t->cx, t->dx);
-			printk(KERN_EMERG "esi = %08lx, edi = %08lx\n",
-				t->si, t->di);
+			printk(KERN_EMERG "esi = %08lx, edi = %08lx, ebp = %08lx\n",
+				t->si, t->di, t->bp);
+
+			regs.common.bx = t->bx;
+			regs.common.cx = t->cx;
+			regs.common.dx = t->dx;
+			regs.common.si = t->si;
+			regs.common.di = t->di;
+			regs.common.bp = t->bp;
+			regs.common.ax = t->ax;
+			regs.common.ds = t->ds;
+			regs.common.es = t->es;
+			regs.common.fs = t->fs;
+			regs.common.orig_ax = -1;
+			regs.common.ip = t->ip;
+			regs.common.cs = t->cs;
+			regs.common.flags = t->flags;
+			regs.common.sp = t->sp;
+			regs.common.ss = t->ss;
+			if (t->flags & X86_EFLAGS_VM) {
+				regs.common.ds = 0;
+				regs.common.es = 0;
+				regs.common.fs = 0;
+				regs.vm86.es = t->es;
+				regs.vm86.ds = t->ds;
+				regs.vm86.fs = t->fs;
+				regs.vm86.gs = t->gs;
+			}
+			notify_die(DIE_DOUBLE_FAULT, "double fault", &regs.common, 0, 8, SIGKILL);
 		}
 	}
 
 	for (;;)
 		cpu_relax();
 }
-
-struct tss_struct doublefault_tss __cacheline_aligned = {
-	.x86_tss = {
-		.sp0		= STACK_START,
-		.ss0		= __KERNEL_DS,
-		.ldt		= 0,
-		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,
-
-		.ip		= (unsigned long) doublefault_fn,
-		/* 0x2 bit is always set */
-		.flags		= X86_EFLAGS_SF | 0x2,
-		.sp		= STACK_START,
-		.es		= __USER_DS,
-		.cs		= __KERNEL_CS,
-		.ss		= __KERNEL_DS,
-		.ds		= __USER_DS,
-		.fs		= __KERNEL_PERCPU,
-
-		.__cr3		= __pa(swapper_pg_dir)
-	}
-};
--- linux-2.6.26/arch/x86/kernel/smpboot.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/arch/x86/kernel/smpboot.c	2008-06-25 14:46:27.000000000 +0200
@@ -832,6 +832,45 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
+#ifdef CONFIG_X86_32
+static int __cpuinit map_exception_stack(pte_t *pte, struct page *pmd_page,
+					 unsigned long addr, void *data)
+{
+	struct page **pages = data;
+
+	*pte = mk_pte(pages[(addr >> PAGE_SHIFT)
+			    & ((1 << EXCEPTION_STACK_ORDER) - 1)],
+		      PAGE_KERNEL);
+	return 0;
+}
+
+static void *__cpuinit alloc_exception_stack(void)
+{
+	struct vm_struct *area;
+	void *stack;
+	unsigned int i;
+	struct page *pages[1 << EXCEPTION_STACK_ORDER];
+
+	BUILD_BUG_ON(EXCEPTION_STACK_ORDER > THREAD_ORDER);
+	/* Try not wasting virtual space. */
+	for (i = EXCEPTION_STACK_SIZE; i < 2 * THREAD_SIZE; i += PAGE_SIZE) {
+		area = get_vm_area(i, 0);
+		BUG_ON(!area);
+		stack = PTR_ALIGN(area->addr, THREAD_SIZE);
+		if (stack + EXCEPTION_STACK_SIZE <= area->addr + i)
+			break;
+		free_vm_area(area);
+	}
+	for (i = 0; !(i >> EXCEPTION_STACK_ORDER); ++i) {
+		pages[i] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
+		BUG_ON(!pages[i]);
+	}
+	apply_to_page_range(&init_mm, (unsigned long)stack,
+			    EXCEPTION_STACK_SIZE, map_exception_stack, pages);
+	return stack;
+}
+#endif
+
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -906,6 +945,11 @@ do_rest:
 	per_cpu(current_task, cpu) = c_idle.idle;
 	init_gdt(cpu);
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+#define i start_ip
+	for (i = 0; i < N_EXCEPTION_TSS; ++i)
+		setup_exception_tss(cpu, i, alloc_exception_stack);
+	vmalloc_sync_all();
+#undef i
 	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	stack_start.sp = (void *) c_idle.idle->thread.sp;
--- linux-2.6.26/arch/x86/kernel/traps_32.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/arch/x86/kernel/traps_32.c	2008-06-25 14:49:20.000000000 +0200
@@ -67,6 +67,29 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 asmlinkage int system_call(void);
 
+#if N_EXCEPTION_TSS
+void doublefault_fn(void);
+
+static DEFINE_PER_CPU(struct x86_hw_tss[N_EXCEPTION_TSS], exception_tss) =
+{
+	[0 ... N_EXCEPTION_TSS-1] =
+	{
+		.cs       = __KERNEL_CS,
+		.ss       = __KERNEL_DS,
+		.ss0      = __KERNEL_DS,
+		.__cr3    = __pa(swapper_pg_dir),
+		.io_bitmap_base = INVALID_IO_BITMAP_OFFSET,
+		.ds       = __USER_DS,
+		.es       = __USER_DS,
+		.fs       = __KERNEL_PERCPU,
+		.flags	  = X86_EFLAGS_SF | 0x2, /* 0x2 bit is always set */
+	},
+#ifdef CONFIG_DOUBLEFAULT
+	[DOUBLEFAULT_TSS].ip = (unsigned long)doublefault_fn
+#endif
+};
+#endif
+
 /* Do we ignore FPU interrupts ? */
 char ignore_fpu_irq;
 
@@ -1184,6 +1207,30 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
+#if N_EXCEPTION_TSS
+void __cpuinit setup_exception_tss(unsigned int cpu, unsigned int idx,
+				   void *(*alloc_stack)(void))
+{
+	struct x86_hw_tss *tss = per_cpu(exception_tss, cpu) + idx;
+
+	/* Set up exception handling TSS. */
+	tss->bx = (unsigned long)tss;
+	tss->sp2 = cpu;
+
+	/* Set up exception handling stack. */
+	if (!tss->sp) {
+		char *stack;
+
+		stack = alloc_stack() + EXCEPTION_STACK_SIZE;
+		tss->sp = (unsigned long)stack;
+		tss->sp0 = (unsigned long)stack;
+	}
+
+	/* Set up exception handling TSS pointer in the GDT. */
+	__set_tss_desc(cpu, GDT_ENTRY_EXCEPTION_TSS + idx, tss);
+}
+#endif
+
 void __init trap_init(void)
 {
 	int i;
@@ -1207,7 +1254,9 @@ void __init trap_init(void)
 	set_trap_gate(5,  &bounds);
 	set_trap_gate(6,  &invalid_op);
 	set_trap_gate(7,  &device_not_available);
-	set_task_gate(8,  GDT_ENTRY_DOUBLEFAULT_TSS);
+#ifdef DOUBLEFAULT_TSS
+	set_task_gate(8,  GDT_ENTRY_EXCEPTION_TSS + DOUBLEFAULT_TSS);
+#endif
 	set_trap_gate(9,  &coprocessor_segment_overrun);
 	set_trap_gate(10, &invalid_TSS);
 	set_trap_gate(11, &segment_not_present);
--- linux-2.6.26/drivers/lguest/segments.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.26-i386-double-fault/drivers/lguest/segments.c	2008-06-25 14:43:16.000000000 +0200
@@ -50,7 +50,8 @@ static int ignored_gdt(unsigned int num)
 	return (num == GDT_ENTRY_TSS
 		|| num == GDT_ENTRY_LGUEST_CS
 		|| num == GDT_ENTRY_LGUEST_DS
-		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
+		|| (num >= GDT_ENTRY_EXCEPTION_TSS
+		    && num < GDT_ENTRY_EXCEPTION_TSS + N_EXCEPTION_TSS));
 }
 
 /*H:630 Once the Guest gave us new GDT entries, we fix them up a little.  We
--- linux-2.6.26/include/asm-x86/kdebug.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/include/asm-x86/kdebug.h	2008-06-25 14:50:04.000000000 +0200
@@ -20,6 +20,7 @@ enum die_val {
 	DIE_CALL,
 	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
+	DIE_DOUBLE_FAULT,
 	DIE_NMIUNKNOWN,
 };
 
--- linux-2.6.26/include/asm-x86/processor.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/include/asm-x86/processor.h	2008-06-25 14:52:11.000000000 +0200
@@ -128,7 +128,6 @@ struct cpuinfo_x86 {
 extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
-extern struct tss_struct	doublefault_tss;
 extern __u32			cleared_cpu_caps[NCAPINTS];
 
 #ifdef CONFIG_SMP
@@ -841,6 +840,12 @@ static inline void spin_lock_prefetch(co
 	.io_bitmap		= { [0 ... IO_BITMAP_LONGS] = ~0 },	  \
 }
 
+#define EXCEPTION_STACK_ORDER 0
+#define EXCEPTION_STACK_SIZE (PAGE_SIZE << EXCEPTION_STACK_ORDER)
+
+void __cpuinit setup_exception_tss(unsigned int cpu, unsigned int idx,
+				   void *(*alloc_stack)(void));
+
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 #define THREAD_SIZE_LONGS      (THREAD_SIZE/sizeof(unsigned long))
--- linux-2.6.26/include/asm-x86/segment.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/include/asm-x86/segment.h	2008-06-25 14:43:16.000000000 +0200
@@ -55,7 +55,7 @@
  *  28 - unused
  *  29 - unused
  *  30 - unused
- *  31 - TSS for double fault handler
+ *  31+  TSSes for exception handlers
  */
 #define GDT_ENTRY_TLS_MIN	6
 #define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
@@ -90,12 +90,19 @@
 #define __KERNEL_PERCPU 0
 #endif
 
-#define GDT_ENTRY_DOUBLEFAULT_TSS	31
+#define GDT_ENTRY_EXCEPTION_TSS	31
+#ifdef CONFIG_DOUBLEFAULT
+#define DOUBLEFAULT_TSS 0
+#define N_EXCEPTION_TSS 1
+#else
+#undef GDT_ENTRY_EXCEPTION_TSS
+#define N_EXCEPTION_TSS 0
+#endif
 
 /*
- * The GDT has 32 entries
+ * The GDT has 31+ entries
  */
-#define GDT_ENTRIES 32
+#define GDT_ENTRIES (31 + N_EXCEPTION_TSS)
 
 /* The PnP BIOS entries in the GDT */
 #define GDT_ENTRY_PNPBIOS_CS32		(GDT_ENTRY_PNPBIOS_BASE + 0)
--- linux-2.6.26/include/asm-x86/thread_info_32.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-double-fault/include/asm-x86/thread_info_32.h	2008-06-25 14:43:16.000000000 +0200
@@ -53,9 +53,14 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 #ifdef CONFIG_4KSTACKS
-#define THREAD_SIZE            (4096)
+#define THREAD_ORDER 0
 #else
-#define THREAD_SIZE		(8192)
+#define THREAD_ORDER 1
+#endif
+#ifndef __ASSEMBLY__
+#define THREAD_SIZE (PAGE_SIZE << THREAD_ORDER)
+#else
+#define THREAD_SIZE (PAGE_SIZE_asm << THREAD_ORDER)
 #endif
 
 #define STACK_WARN             (THREAD_SIZE/8)


