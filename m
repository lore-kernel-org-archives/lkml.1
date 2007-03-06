Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXCFNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXCFNFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXCFNE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:04:59 -0500
Received: from ozlabs.org ([203.10.76.45]:56672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbXCFNE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:04:57 -0500
Subject: [PATCH 8/8] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173186107.4644.41.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <1173186107.4644.41.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 00:03:34 +1100
Message-Id: <1173186214.4644.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently x86 (similar to x84-64) has a special per-cpu structure
called "i386_pda" which can be easily and efficiently referenced via
the %fs register.  An ELF section is more flexible than a structure,
allowing any piece of code to use this area.  Indeed, such a section
already exists: the per-cpu area.

So this patch
(1) Removes the PDA and uses per-cpu variables for each current member.
(2) Replaces the __KERNEL_PDA segment with __KERNEL_PERCPU.
(3) Creates a per-cpu mirror of __per_cpu_offset called this_cpu_off, which
    can be used to calculate addresses for this CPU's variables.
(4) Moves the boot cpu's GDT/percpu setup to smp_prepare_boot_cpu(),
    immediately after the per-cpu areas are allocated.

The result is one less x86-specific concept.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r b30bbd45ba64 arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/asm-offsets.c	Tue Mar 06 23:35:03 2007 +1100
@@ -15,7 +15,6 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/elf.h>
-#include <asm/pda.h>
 #ifdef CONFIG_LGUEST_GUEST
 #include <asm/lguest.h>
 #include "../lguest/lg.h"
@@ -105,10 +104,6 @@ void foo(void)
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
-	BLANK();
- 	OFFSET(PDA_cpu, i386_pda, cpu_number);
-	OFFSET(PDA_pcurrent, i386_pda, pcurrent);
-
 #ifdef CONFIG_PARAVIRT
 	BLANK();
 	OFFSET(PARAVIRT_enabled, paravirt_ops, paravirt_enabled);
diff -r b30bbd45ba64 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Tue Mar 06 23:37:51 2007 +1100
@@ -18,14 +18,11 @@
 #include <asm/apic.h>
 #include <mach_apic.h>
 #endif
-#include <asm/pda.h>
 
 #include "cpu.h"
 
 DEFINE_PER_CPU(struct gdt_page, gdt_page);
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
-DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
-EXPORT_PER_CPU_SYMBOL(_cpu_pda);
 
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_fxsr __cpuinitdata;
@@ -600,51 +597,44 @@ void __init early_cpu_init(void)
 #endif
 }
 
-/* Make sure %gs is initialized properly in idle threads */
+/* Make sure %fs is initialized properly in idle threads */
 struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
-	regs->xfs = __KERNEL_PDA;
+	regs->xfs = __KERNEL_PERCPU;
 	return regs;
 }
 
-/* Initial PDA used by boot CPU */
-struct i386_pda boot_pda = {
-	._pda = &boot_pda,
-	.cpu_number = 0,
-	.pcurrent = &init_task,
-};
-
 static inline void set_kernel_fs(void)
 {
-	/* Set %fs for this CPU's PDA.  Memory clobber is to create a
-	   barrier with respect to any PDA operations, so the compiler
-	   doesn't move any before here. */
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
-}
-
-/* Initialize the CPU's GDT and PDA.  This is either the boot CPU doing itself
+	/* Set %fs for this CPU's per-cpu area.  Memory clobber is to
+	   create a barrier with respect to any per-cpu operations, so the
+	   compiler doesn't move any before here. */
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+}
+
+/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
    (still using boot_gdt_table), or a CPU doing it for a secondary which
    will soon come up. */
 __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
 	struct desc_struct *gdt = per_cpu(gdt_page, cpu).gdt;
-	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
-
-	/* Based on boot_gdt_table: set PDA so it can be used immediately */
+
+	/* Based on boot_gdt_table: set percpu so it can be used immediately */
  	memcpy(gdt, boot_gdt_table, GDT_SIZE);
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
-			(u32 *)&gdt[GDT_ENTRY_PDA].b,
-			(unsigned long)pda, sizeof(*pda) - 1,
+#ifdef CONFIG_SMP
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
 			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
-
-	memset(pda, 0, sizeof(*pda));
-	pda->_pda = pda;
-	pda->cpu_number = cpu;
-	pda->pcurrent = idle;
-}
-
-/* Move this CPU from boot_gdt_table & boot_pda to this cpu's proper one. */
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+#endif /* SMP*/
+
+	per_cpu(current_task, cpu) = idle;
+}
+
+/* Move this CPU from boot_gdt_table to this cpu's proper one. */
 void __cpuinit cpu_set_gdt(int cpu)
 {
 	struct Xgt_desc_struct gdt_descr;
@@ -738,8 +728,7 @@ void __cpuinit cpu_init(void)
 	int cpu = smp_processor_id();
 	struct task_struct *curr = current;
 
-	/* Set up the real GDT and PDA, so we can transition from the
-	   boot_gdt_table & boot_pda. */
+	/* Set up the real GDT so we can transition from the boot_gdt_table. */
 	init_gdt(cpu, curr);
 	cpu_set_gdt(cpu);
 	_cpu_init(cpu, curr);
diff -r b30bbd45ba64 arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/entry.S	Tue Mar 06 23:35:03 2007 +1100
@@ -132,7 +132,7 @@ 1:
 	movl $(__USER_DS), %edx; \
 	movl %edx, %ds; \
 	movl %edx, %es; \
-	movl $(__KERNEL_PDA), %edx; \
+	movl $(__KERNEL_PERCPU), %edx; \
 	movl %edx, %fs
 
 #define RESTORE_INT_REGS \
@@ -557,7 +557,6 @@ END(syscall_badsys)
 
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
-	movl %fs:PDA_cpu, %ebx; \
 	PER_CPU(gdt_page, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
@@ -682,7 +681,7 @@ error_code:
 	pushl %fs
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET fs, 0*/
-	movl $(__KERNEL_PDA), %ecx
+	movl $(__KERNEL_PERCPU), %ecx
 	movl %ecx, %fs
 	UNWIND_ESPFIX_STACK
 	popl %ecx
diff -r b30bbd45ba64 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/head.S	Tue Mar 06 23:35:03 2007 +1100
@@ -318,7 +318,6 @@ 2:	movl %cr0,%eax
 	movl %eax,%cr0
 
 	call check_x87
-	call setup_pda
 	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
@@ -333,7 +332,7 @@ 1:	movl $(__KERNEL_DS),%eax	# reload all
 	movl %eax,%gs
 	lldt %ax
 
-	movl $(__KERNEL_PDA),%eax
+	movl $(__KERNEL_PERCPU),%eax
 	mov  %eax,%fs
 
 	cld			# gcc2 wants the direction flag cleared at all times
@@ -363,16 +362,6 @@ check_x87:
 	ALIGN
 1:	movb $1,X86_HARD_MATH
 	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
-	ret
-
-/* Initialize the boot_gdt_table's GDT_ENTRY_PDA (can't be done statically) */
-setup_pda:
-	movl $boot_pda, %eax
-	movl $boot_gdt_table, %ecx
-	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
-	shr $16, %eax
-	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
-	mov %ah, (__KERNEL_PDA+4+3)(%ecx)		/* base & 0xff000000 */
 	ret
 
 /*
@@ -635,7 +624,7 @@ ENTRY(boot_gdt_table)
 	.quad 0x004092000000ffff	/* 0xc8 APM DS    data */
 
 	.quad 0x00c0920000000000	/* 0xd0 - ESPFIX SS */
-	.quad 0x00cf92000000ffff	/* 0xd8 - PDA */
+	.quad 0x00cf92000000ffff	/* 0xd8 - per-cpu */
 	.quad 0x0000000000000000	/* 0xe0 - unused */
 	.quad 0x0000000000000000	/* 0xe8 - unused */
 	.quad 0x0000000000000000	/* 0xf0 - unused */
diff -r b30bbd45ba64 arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/irq.c	Tue Mar 06 23:35:03 2007 +1100
@@ -23,6 +23,9 @@
 
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
+
+DEFINE_PER_CPU(struct pt_regs *, irq_regs);
+EXPORT_PER_CPU_SYMBOL(irq_regs);
 
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
diff -r b30bbd45ba64 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/process.c	Tue Mar 06 23:35:03 2007 +1100
@@ -39,6 +39,7 @@
 #include <linux/random.h>
 #include <linux/personality.h>
 #include <linux/tick.h>
+#include <linux/percpu.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -57,7 +58,6 @@
 
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
-#include <asm/pda.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -65,6 +65,12 @@ static int hlt_counter;
 
 unsigned long boot_option_idle_override = 0;
 EXPORT_SYMBOL(boot_option_idle_override);
+
+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
 
 /*
  * Return saved PC of a blocked thread.
@@ -343,7 +349,7 @@ int kernel_thread(int (*fn)(void *), voi
 
 	regs.xds = __USER_DS;
 	regs.xes = __USER_DS;
-	regs.xfs = __KERNEL_PDA;
+	regs.xfs = __KERNEL_PERCPU;
 	regs.orig_eax = -1;
 	regs.eip = (unsigned long) kernel_thread_helper;
 	regs.xcs = __KERNEL_CS | get_kernel_rpl();
@@ -712,7 +718,7 @@ struct task_struct fastcall * __switch_t
 	if (prev->gs | next->gs)
 		loadsegment(gs, next->gs);
 
-	write_pda(pcurrent, next_p);
+	x86_write_percpu(current_task, next_p);
 
 	return prev_p;
 }
diff -r b30bbd45ba64 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/smpboot.c	Tue Mar 06 23:35:03 2007 +1100
@@ -52,7 +52,6 @@
 #include <asm/desc.h>
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
-#include <asm/pda.h>
 
 #include <mach_apic.h>
 #include <mach_wakecpu.h>
@@ -97,6 +96,9 @@ EXPORT_SYMBOL(x86_cpu_to_apicid);
 EXPORT_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
+
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 /*
  * Trampoline 80x86 program as an array.
@@ -461,7 +463,6 @@ extern struct {
 	void * esp;
 	unsigned short ss;
 } stack_start;
-extern struct i386_pda *start_pda;
 
 #ifdef CONFIG_NUMA
 
@@ -1167,6 +1168,10 @@ void __devinit smp_prepare_boot_cpu(void
 	cpu_set(smp_processor_id(), cpu_present_map);
 	cpu_set(smp_processor_id(), cpu_possible_map);
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+
+	/* Set up %fs to point to our per-CPU area now it's allocated */
+	init_gdt(smp_processor_id(), &init_task);
+	cpu_set_gdt(smp_processor_id());
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -r b30bbd45ba64 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/kernel/vmi.c	Tue Mar 06 23:35:04 2007 +1100
@@ -549,7 +549,7 @@ vmi_startup_ipi_hook(int phys_apicid, un
 
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
-	ap.fs = __KERNEL_PDA;
+	ap.fs = __KERNEL_PERCPU;
 	ap.gs = 0;
 
 	ap.eflags = 0;
diff -r b30bbd45ba64 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/lguest/core.c	Tue Mar 06 23:35:04 2007 +1100
@@ -302,7 +302,7 @@ int run_guest(struct lguest *lg, char *_
 
 		/* Host state to be restored after the guest returns. */
 		asm("sidt %0":"=m"(lg->state->host.idt));
-		lg->state->host.gdt = __get_cpu_var(cpu_gdt_descr);
+		asm("sgdt %0":"=m"(lg->state->host.gdt));
 
 		/* Even if *we* don't want FPU trap, guest might... */
 		set_ts(lg->ts);
diff -r b30bbd45ba64 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Tue Mar 06 23:35:01 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Tue Mar 06 23:35:04 2007 +1100
@@ -34,7 +34,6 @@
 #include <asm/desc.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
-#include <asm/pda.h>
 #include <asm/asm-offsets.h>
 #include <asm/mce.h>
 
@@ -509,13 +508,8 @@ static __attribute_used__ __init void lg
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
 
-	/* set up PDA descriptor */
-	pack_descriptor((u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].a,
-			(u32 *)&cpu_gdt_table[GDT_ENTRY_PDA].b,
-			(unsigned)&boot_pda, sizeof(boot_pda)-1,
-			0x80 | DESCTYPE_S | 0x02, 0);
-	load_gdt(&early_gdt_descr);
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
+	init_gdt(0, &init_task);
+	cpu_set_gdt(0);
 
 	reserve_top_address(lguest_data.reserve_mem);
 
diff -r b30bbd45ba64 include/asm-i386/current.h
--- a/include/asm-i386/current.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/current.h	Tue Mar 06 23:35:04 2007 +1100
@@ -1,14 +1,15 @@
 #ifndef _I386_CURRENT_H
 #define _I386_CURRENT_H
 
-#include <asm/pda.h>
 #include <linux/compiler.h>
+#include <asm/percpu.h>
 
 struct task_struct;
 
+DECLARE_PER_CPU(struct task_struct *, current_task);
 static __always_inline struct task_struct *get_current(void)
 {
-	return read_pda(pcurrent);
+	return x86_read_percpu(current_task);
 }
  
 #define current get_current()
diff -r b30bbd45ba64 include/asm-i386/irq_regs.h
--- a/include/asm-i386/irq_regs.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/irq_regs.h	Tue Mar 06 23:35:04 2007 +1100
@@ -1,25 +1,27 @@
 /*
  * Per-cpu current frame pointer - the location of the last exception frame on
- * the stack, stored in the PDA.
+ * the stack, stored in the per-cpu area.
  *
  * Jeremy Fitzhardinge <jeremy@goop.org>
  */
 #ifndef _ASM_I386_IRQ_REGS_H
 #define _ASM_I386_IRQ_REGS_H
 
-#include <asm/pda.h>
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
 {
-	return read_pda(irq_regs);
+	return x86_read_percpu(irq_regs);
 }
 
 static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 {
 	struct pt_regs *old_regs;
 
-	old_regs = read_pda(irq_regs);
-	write_pda(irq_regs, new_regs);
+	old_regs = get_irq_regs();
+	x86_write_percpu(irq_regs, new_regs);
 
 	return old_regs;
 }
diff -r b30bbd45ba64 include/asm-i386/pda.h
--- a/include/asm-i386/pda.h	Tue Mar 06 23:35:01 2007 +1100
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,100 +0,0 @@
-/*
-   Per-processor Data Areas
-   Jeremy Fitzhardinge <jeremy@goop.org> 2006
-   Based on asm-x86_64/pda.h by Andi Kleen.
- */
-#ifndef _I386_PDA_H
-#define _I386_PDA_H
-
-#include <linux/stddef.h>
-#include <linux/types.h>
-#include <asm/percpu.h>
-
-struct i386_pda
-{
-	struct i386_pda *_pda;		/* pointer to self */
-
-	int cpu_number;
-	struct task_struct *pcurrent;	/* current process */
-	struct pt_regs *irq_regs;
-};
-
-DECLARE_PER_CPU(struct i386_pda, _cpu_pda);
-
-#define pda_offset(field) offsetof(struct i386_pda, field)
-
-extern void __bad_pda_field(void);
-
-/* This variable is never instantiated.  It is only used as a stand-in
-   for the real per-cpu PDA memory, so that gcc can understand what
-   memory operations the inline asms() below are performing.  This
-   eliminates the need to make the asms volatile or have memory
-   clobbers, so gcc can readily analyse them. */
-extern struct i386_pda _proxy_pda;
-
-#define pda_to_op(op,field,val)						\
-	do {								\
-		typedef typeof(_proxy_pda.field) T__;			\
-		if (0) { T__ tmp__; tmp__ = (val); }			\
-		switch (sizeof(_proxy_pda.field)) {			\
-		case 1:							\
-			asm(op "b %1,%%fs:%c2"				\
-			    : "+m" (_proxy_pda.field)			\
-			    :"ri" ((T__)val),				\
-			     "i"(pda_offset(field)));			\
-			break;						\
-		case 2:							\
-			asm(op "w %1,%%fs:%c2"				\
-			    : "+m" (_proxy_pda.field)			\
-			    :"ri" ((T__)val),				\
-			     "i"(pda_offset(field)));			\
-			break;						\
-		case 4:							\
-			asm(op "l %1,%%fs:%c2"				\
-			    : "+m" (_proxy_pda.field)			\
-			    :"ri" ((T__)val),				\
-			     "i"(pda_offset(field)));			\
-			break;						\
-		default: __bad_pda_field();				\
-		}							\
-	} while (0)
-
-#define pda_from_op(op,field)						\
-	({								\
-		typeof(_proxy_pda.field) ret__;				\
-		switch (sizeof(_proxy_pda.field)) {			\
-		case 1:							\
-			asm(op "b %%fs:%c1,%0"				\
-			    : "=r" (ret__)				\
-			    : "i" (pda_offset(field)),			\
-			      "m" (_proxy_pda.field));			\
-			break;						\
-		case 2:							\
-			asm(op "w %%fs:%c1,%0"				\
-			    : "=r" (ret__)				\
-			    : "i" (pda_offset(field)),			\
-			      "m" (_proxy_pda.field));			\
-			break;						\
-		case 4:							\
-			asm(op "l %%fs:%c1,%0"				\
-			    : "=r" (ret__)				\
-			    : "i" (pda_offset(field)),			\
-			      "m" (_proxy_pda.field));			\
-			break;						\
-		default: __bad_pda_field();				\
-		}							\
-		ret__; })
-
-/* Return a pointer to a pda field */
-#define pda_addr(field)							\
-	((typeof(_proxy_pda.field) *)((unsigned char *)read_pda(_pda) + \
-				      pda_offset(field)))
-
-#define read_pda(field) pda_from_op("mov",field)
-#define write_pda(field,val) pda_to_op("mov",field,val)
-#define add_pda(field,val) pda_to_op("add",field,val)
-#define sub_pda(field,val) pda_to_op("sub",field,val)
-#define or_pda(field,val) pda_to_op("or",field,val)
-
-extern struct i386_pda boot_pda;
-#endif	/* _I386_PDA_H */
diff -r b30bbd45ba64 include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/percpu.h	Tue Mar 06 23:35:04 2007 +1100
@@ -1,31 +1,133 @@
 #ifndef __ARCH_I386_PERCPU__
 #define __ARCH_I386_PERCPU__
 
-#ifndef __ASSEMBLY__
-#include <asm-generic/percpu.h>
-#else
+#ifdef __ASSEMBLY__
 
 /*
  * PER_CPU finds an address of a per-cpu variable.
  *
  * Args:
  *    var - variable name
- *    cpu - 32bit register containing the current CPU number
+ *    reg - 32bit register
  *
- * The resulting address is stored in the "cpu" argument.
+ * The resulting address is stored in the "reg" argument.
  *
  * Example:
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-#define PER_CPU(var, cpu) \
-	movl __per_cpu_offset(,cpu,4), cpu;	\
-	addl $per_cpu__##var, cpu;
+#define PER_CPU(var, reg)			\
+	movl %fs:per_cpu__this_cpu_off, reg;		\
+	addl $per_cpu__##var, reg
 #else /* ! SMP */
-#define PER_CPU(var, cpu) \
-	movl $per_cpu__##var, cpu;
+#define PER_CPU(var, reg) \
+	movl $per_cpu__##var, reg
 #endif	/* SMP */
 
+#else /* ...!ASSEMBLY */
+
+#ifdef CONFIG_SMP
+/* Same as generic implementation except for optimized local access. */
+#define __GENERIC_PER_CPU
+
+/* This is used for other cpus to find our section. */
+extern unsigned long __per_cpu_offset[];
+
+/* Separate out the type, so (int[3], foo) works. */
+#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU(type, name) \
+    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
+/* var is in discarded region: offset to particular copy we want */
+#define per_cpu(var, cpu) (*({				\
+	extern int simple_indentifier_##var(void);	\
+	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
+
+#define __raw_get_cpu_var(var) (*({					\
+	extern int simple_indentifier_##var(void);			\
+	RELOC_HIDE(&per_cpu__##var, x86_read_percpu(this_cpu_off));	\
+}))
+
+#define __get_cpu_var(var) __raw_get_cpu_var(var)
+
+/* A macro to avoid #include hell... */
+#define percpu_modcopy(pcpudst, src, size)			\
+do {								\
+	unsigned int __i;					\
+	for_each_possible_cpu(__i)				\
+		memcpy((pcpudst)+__per_cpu_offset[__i],		\
+		       (src), (size));				\
+} while (0)
+
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
+/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
+#define __percpu_seg "%%fs:"
+#else  /* !SMP */
+#include <asm-generic/percpu.h>
+#define __percpu_seg ""
+#endif	/* SMP */
+
+/* For arch-specific code, we can use direct single-insn ops (they
+ * don't give an lvalue though). */
+extern void __bad_percpu_size(void);
+
+#define percpu_to_op(op,var,val)				\
+	do {							\
+		typedef typeof(var) T__;			\
+		if (0) { T__ tmp__; tmp__ = (val); }		\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 2:						\
+			asm(op "w %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 4:						\
+			asm(op "l %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+	} while (0)
+
+#define percpu_from_op(op,var)					\
+	({							\
+		typeof(var) ret__;				\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 2:						\
+			asm(op "w "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 4:						\
+			asm(op "l "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+		ret__; })
+
+#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
+#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
+#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
+#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
+#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ARCH_I386_PERCPU__ */
diff -r b30bbd45ba64 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/processor.h	Tue Mar 06 23:35:04 2007 +1100
@@ -425,7 +425,7 @@ struct thread_struct {
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
-	.fs = __KERNEL_PDA,						\
+	.fs = __KERNEL_PERCPU,						\
 }
 
 /*
diff -r b30bbd45ba64 include/asm-i386/segment.h
--- a/include/asm-i386/segment.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/segment.h	Tue Mar 06 23:35:04 2007 +1100
@@ -39,7 +39,7 @@
  *  25 - APM BIOS support 
  *
  *  26 - ESPFIX small SS
- *  27 - PDA				[ per-cpu private data area ]
+ *  27 - per-cpu			[ offset to per-cpu data area ]
  *  28 - unused
  *  29 - unused
  *  30 - unused
@@ -74,8 +74,8 @@
 #define GDT_ENTRY_ESPFIX_SS		(GDT_ENTRY_KERNEL_BASE + 14)
 #define __ESPFIX_SS (GDT_ENTRY_ESPFIX_SS * 8)
 
-#define GDT_ENTRY_PDA			(GDT_ENTRY_KERNEL_BASE + 15)
-#define __KERNEL_PDA (GDT_ENTRY_PDA * 8)
+#define GDT_ENTRY_PERCPU			(GDT_ENTRY_KERNEL_BASE + 15)
+#define __KERNEL_PERCPU (GDT_ENTRY_PERCPU * 8)
 
 #define GDT_ENTRY_DOUBLEFAULT_TSS	31
 
diff -r b30bbd45ba64 include/asm-i386/smp.h
--- a/include/asm-i386/smp.h	Tue Mar 06 23:35:01 2007 +1100
+++ b/include/asm-i386/smp.h	Tue Mar 06 23:35:04 2007 +1100
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/pda.h>
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(__ASSEMBLY__)
@@ -59,7 +58,8 @@ do { } while (0)
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-#define raw_smp_processor_id() (read_pda(cpu_number))
+DECLARE_PER_CPU(int, cpu_number);
+#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
 
 extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_callin_map;


