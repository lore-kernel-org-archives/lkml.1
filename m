Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbXH1MOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbXH1MOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXH1MOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:14:04 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31940
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbXH1MOB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:14:01 -0400
Message-Id: <46D42DC7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 13:14:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: per-CPU double fault TSS and stack
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the double fault handler use CPU-specific stacks. Add some
abstraction to simplify future changes of other exception handlers to
also go through task gates. Add a new notification of the event
through the die notifier chain, also providing some environmental
adjustments so that various infrastructural things work independent of
the fact that the fault and the callbacks are running on other then
the normal kernel stack.

Signed-Off-By: Jan Beulich <jbeulich@novell.com>
Acked-By: Andi Kleen <ak@suse.de>

 arch/i386/kernel/cpu/common.c  |   63 ++++++++++++++++++++++++++++--
 arch/i386/kernel/doublefault.c |   85 +++++++++++++++++++++++++----------------
 arch/i386/kernel/traps.c       |   30 +++++++++++++-
 include/asm-i386/kdebug.h      |    1 
 include/asm-i386/processor.h   |    8 +++
 include/asm-i386/segment.h     |   16 +++++--
 include/asm-i386/thread_info.h |    9 +++-
 7 files changed, 168 insertions(+), 44 deletions(-)

--- linux-2.6.23-rc4/arch/i386/kernel/cpu/common.c	2007-08-28 09:38:03.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/arch/i386/kernel/cpu/common.c	2007-08-28 13:16:03.000000000 +0200
@@ -650,6 +650,16 @@ void switch_to_new_gdt(void)
 	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void *noinline __init_refok
+#else
+static inline void *__init
+#endif
+do_alloc_bootmem(unsigned long size, unsigned long align, unsigned long goal)
+{
+	return __alloc_bootmem(size, align, goal);
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -659,6 +669,9 @@ void switch_to_new_gdt(void)
 void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
+#if N_EXCEPTION_TSS
+	unsigned i;
+#endif
 	struct task_struct *curr = current;
 	struct tss_struct * t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
@@ -696,9 +709,53 @@ void __cpuinit cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-#ifdef CONFIG_DOUBLEFAULT
-	/* Set up doublefault TSS pointer in the GDT */
-	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
+#if N_EXCEPTION_TSS
+#if EXCEPTION_STACK_ORDER > THREAD_ORDER
+#error Assertion failed: EXCEPTION_STACK_ORDER <= THREAD_ORDER
+#endif
+	for (i = 0; i < N_EXCEPTION_TSS; ++i) {
+		unsigned long stack;
+
+		/* Set up exception handling TSS */
+		exception_tss[cpu][i].ebx = (unsigned long)&exception_tss[cpu][i];
+
+		/* Set up exception handling stacks */
+#ifdef CONFIG_SMP
+		if (cpu) {
+			stack = __get_free_pages(GFP_ATOMIC, THREAD_ORDER);
+			if (!stack)
+				panic("Cannot allocate exception stack %u %d\n",
+				      i, cpu);
+		}
+		else
+#endif
+			stack = (unsigned long)do_alloc_bootmem(EXCEPTION_STACK_SIZE,
+								THREAD_SIZE,
+								__pa(MAX_DMA_ADDRESS));
+		stack += EXCEPTION_STACK_SIZE;
+		exception_tss[cpu][i].esp = exception_tss[cpu][i].esp0 = stack;
+#ifdef CONFIG_SMP
+		if (cpu) {
+			unsigned j;
+
+			for (j = EXCEPTION_STACK_ORDER; j < THREAD_ORDER; ++j) {
+				/* set_page_refs sets the page count only for the first
+				   page, but since we split the larger-order page here,
+				   we need to adjust the page count before freeing the
+				   pieces. */
+				struct page * page = virt_to_page((void *)stack);
+
+				BUG_ON(page_count(page));
+				init_page_count(page);
+				free_pages(stack, j);
+				stack += (PAGE_SIZE << j);
+			}
+		}
+#endif
+
+		/* Set up exception handling TSS pointer in the GDT */
+		__set_tss_desc(cpu, GDT_ENTRY_EXCEPTION_TSS + i, &exception_tss[cpu][i]);
+	}
 #endif
 
 	/* Clear %gs. */
--- linux-2.6.23-rc4/arch/i386/kernel/doublefault.c	2007-08-28 09:38:03.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/arch/i386/kernel/doublefault.c	2007-08-22 15:40:55.000000000 +0200
@@ -3,68 +3,87 @@
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
+extern unsigned long max_low_pfn;
+#define ptr_ok(x, l) ((x) >= PAGE_OFFSET \
+                      && (x) + (l) <= PAGE_OFFSET + max_low_pfn * PAGE_SIZE - 1)
 
-#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
+#define THREAD_INFO_FROM(x) ((struct thread_info *)((x) & ~(THREAD_SIZE - 1)))
 
-static void doublefault_fn(void)
+register const struct i386_hw_tss *self __asm__("ebx");
+
+void doublefault_fn(void)
 {
-	struct Xgt_desc_struct gdt_desc = {0, 0};
+	struct Xgt_desc_struct gdt_desc;
 	unsigned long gdt, tss;
 
 	store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
-	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
+	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size + 1);
 
-	if (ptr_ok(gdt)) {
+	if (ptr_ok(gdt, gdt_desc.size)) {
 		gdt += GDT_ENTRY_TSS << 3;
 		tss = *(u16 *)(gdt+2);
 		tss += *(u8 *)(gdt+4) << 16;
 		tss += *(u8 *)(gdt+7) << 24;
 		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
-		if (ptr_ok(tss)) {
-			struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
+		if (ptr_ok(tss, *(u16 *)gdt)) {
+			const struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
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
+			*THREAD_INFO_FROM(self->esp) = *THREAD_INFO_FROM(t->esp0 - 1);
 
 			printk(KERN_EMERG "eip = %08lx, esp = %08lx\n", t->eip, t->esp);
 
 			printk(KERN_EMERG "eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
 				t->eax, t->ebx, t->ecx, t->edx);
-			printk(KERN_EMERG "esi = %08lx, edi = %08lx\n",
-				t->esi, t->edi);
+			printk(KERN_EMERG "esi = %08lx, edi = %08lx, ebp = %08lx\n",
+				t->esi, t->edi, t->ebp);
+
+			regs.common.ebx = t->ebx;
+			regs.common.ecx = t->ecx;
+			regs.common.edx = t->edx;
+			regs.common.esi = t->esi;
+			regs.common.edi = t->edi;
+			regs.common.ebp = t->ebp;
+			regs.common.eax = t->eax;
+			regs.common.xds = t->ds;
+			regs.common.xes = t->es;
+			regs.common.orig_eax = -1;
+			regs.common.eip = t->eip;
+			regs.common.xcs = t->cs;
+			regs.common.eflags = t->eflags;
+			regs.common.esp = t->esp;
+			regs.common.xss = t->ss;
+			if (t->eflags & X86_EFLAGS_VM) {
+				regs.common.xds = 0;
+				regs.common.xes = 0;
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
-		.esp0		= STACK_START,
-		.ss0		= __KERNEL_DS,
-		.ldt		= 0,
-		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,
-
-		.eip		= (unsigned long) doublefault_fn,
-		/* 0x2 bit is always set */
-		.eflags		= X86_EFLAGS_SF | 0x2,
-		.esp		= STACK_START,
-		.es		= __USER_DS,
-		.cs		= __KERNEL_CS,
-		.ss		= __KERNEL_DS,
-		.ds		= __USER_DS,
-		.fs		= __KERNEL_PERCPU,
-
-		.__cr3		= __pa(swapper_pg_dir)
-	}
-};
--- linux-2.6.23-rc4/arch/i386/kernel/traps.c	2007-08-28 09:38:03.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/arch/i386/kernel/traps.c	2007-08-22 15:16:06.000000000 +0200
@@ -67,6 +67,30 @@ int panic_on_unrecovered_nmi;
 
 asmlinkage int system_call(void);
 
+#if N_EXCEPTION_TSS
+void doublefault_fn(void);
+
+struct i386_hw_tss exception_tss[NR_CPUS][N_EXCEPTION_TSS] __cacheline_aligned = {
+	[0 ... NR_CPUS-1] = {
+		[0 ... N_EXCEPTION_TSS-1] = {
+			.cs       = __KERNEL_CS,
+			.ss       = __KERNEL_DS,
+			.ss0      = __KERNEL_DS,
+			.__cr3    = __pa(swapper_pg_dir),
+			.io_bitmap_base = INVALID_IO_BITMAP_OFFSET,
+			.ds       = __USER_DS,
+			.es       = __USER_DS,
+			.fs       = __KERNEL_PERCPU,
+			/* 0x2 bit is always set */
+			.eflags	  = X86_EFLAGS_SF | 0x2,
+		},
+#ifdef CONFIG_DOUBLEFAULT
+		[DOUBLEFAULT_TSS].eip = (unsigned long)doublefault_fn
+#endif
+	}
+};
+#endif
+
 /* Do we ignore FPU interrupts ? */
 char ignore_fpu_irq = 0;
 
@@ -1148,10 +1172,12 @@ static void __init set_system_gate(unsig
 	_set_gate(n, DESCTYPE_TRAP | DESCTYPE_DPL3, addr, __KERNEL_CS);
 }
 
+#if N_EXCEPTION_TSS
 static void __init set_task_gate(unsigned int n, unsigned int gdt_entry)
 {
 	_set_gate(n, DESCTYPE_TASK, (void *)0, (gdt_entry<<3));
 }
+#endif
 
 
 void __init trap_init(void)
@@ -1176,7 +1202,9 @@ void __init trap_init(void)
 	set_trap_gate(5,&bounds);
 	set_trap_gate(6,&invalid_op);
 	set_trap_gate(7,&device_not_available);
-	set_task_gate(8,GDT_ENTRY_DOUBLEFAULT_TSS);
+#ifdef DOUBLEFAULT_TSS
+	set_task_gate(8,GDT_ENTRY_EXCEPTION_TSS + DOUBLEFAULT_TSS);
+#endif
 	set_trap_gate(9,&coprocessor_segment_overrun);
 	set_trap_gate(10,&invalid_TSS);
 	set_trap_gate(11,&segment_not_present);
--- linux-2.6.23-rc4/include/asm-i386/kdebug.h	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/include/asm-i386/kdebug.h	2007-08-22 15:00:39.000000000 +0200
@@ -28,6 +28,7 @@ enum die_val {
 	DIE_CALL,
 	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
+	DIE_DOUBLE_FAULT
 };
 
 #endif
--- linux-2.6.23-rc4/include/asm-i386/processor.h	2007-08-28 09:39:14.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/include/asm-i386/processor.h	2007-08-22 15:24:04.000000000 +0200
@@ -99,7 +99,6 @@ struct cpuinfo_x86 {
 
 extern struct cpuinfo_x86 boot_cpu_data;
 extern struct cpuinfo_x86 new_cpu_data;
-extern struct tss_struct doublefault_tss;
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 
 #ifdef CONFIG_SMP
@@ -389,6 +388,13 @@ struct thread_struct {
 	.io_bitmap	= { [ 0 ... IO_BITMAP_LONGS] = ~0 },		\
 }
 
+#define EXCEPTION_STACK_ORDER 0
+#define EXCEPTION_STACK_SIZE (PAGE_SIZE << EXCEPTION_STACK_ORDER)
+
+#if N_EXCEPTION_TSS
+extern struct i386_hw_tss exception_tss[NR_CPUS][N_EXCEPTION_TSS];
+#endif
+
 #define start_thread(regs, new_eip, new_esp) do {		\
 	__asm__("movl %0,%%gs": :"r" (0));			\
 	regs->xfs = 0;						\
--- linux-2.6.23-rc4/include/asm-i386/segment.h	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/include/asm-i386/segment.h	2007-08-22 15:18:31.000000000 +0200
@@ -43,7 +43,8 @@
  *  28 - unused
  *  29 - unused
  *  30 - unused
- *  31 - TSS for double fault handler
+ *  31 - TSS for first exception handler (double fault)
+ *  32+  TSSes for further exception handlers
  */
 #define GDT_ENTRY_TLS_ENTRIES	3
 #define GDT_ENTRY_TLS_MIN	6
@@ -81,12 +82,19 @@
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
 #define GDT_SIZE (GDT_ENTRIES * 8)
 
 /* Simple and small GDT entries for booting only */
--- linux-2.6.23-rc4/include/asm-i386/thread_info.h	2007-08-28 09:39:14.000000000 +0200
+++ 2.6.23-rc4-i386-double-fault/include/asm-i386/thread_info.h	2007-08-22 15:36:47.000000000 +0200
@@ -54,9 +54,14 @@ struct thread_info {
 
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


