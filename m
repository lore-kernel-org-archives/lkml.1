Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXD3Kay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXD3Kay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXD3K2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:33 -0400
Received: from mail.suse.de ([195.135.220.2]:51220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXD3K2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:00 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [25/40] i386: Convert PDA into the percpu section
Message-Id: <20070430102759.6BAA9151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Currently x86 (similar to x84-64) has a special per-cpu structure
called "i386_pda" which can be easily and efficiently referenced via
the %fs register.  An ELF section is more flexible than a structure,
allowing any piece of code to use this area.  Indeed, such a section
already exists: the per-cpu area.

So this patch:
(1) Removes the PDA and uses per-cpu variables for each current member.
(2) Replaces the __KERNEL_PDA segment with __KERNEL_PERCPU.
(3) Creates a per-cpu mirror of __per_cpu_offset called this_cpu_off, which
    can be used to calculate addresses for this CPU's variables.
(4) Simplifies startup, because %fs doesn't need to be loaded with a
    special segment at early boot; it can be deferred until the first
    percpu area is allocated (or never for UP).

The result is less code and one less x86-specific concept.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
---
 arch/i386/kernel/asm-offsets.c |    5 -
 arch/i386/kernel/cpu/common.c  |   17 -----
 arch/i386/kernel/entry.S       |    5 -
 arch/i386/kernel/head.S        |   31 +--------
 arch/i386/kernel/i386_ksyms.c  |    2 
 arch/i386/kernel/irq.c         |    3 
 arch/i386/kernel/process.c     |   12 ++-
 arch/i386/kernel/smpboot.c     |   32 ++++-----
 arch/i386/kernel/vmi.c         |    6 -
 arch/i386/kernel/vmlinux.lds.S |    1 
 include/asm-i386/current.h     |    5 -
 include/asm-i386/irq_regs.h    |   12 ++-
 include/asm-i386/pda.h         |   99 ------------------------------
 include/asm-i386/percpu.h      |  132 ++++++++++++++++++++++++++++++++++++++---
 include/asm-i386/processor.h   |    2 
 include/asm-i386/segment.h     |    6 -
 include/asm-i386/smp.h         |    4 -
 17 files changed, 178 insertions(+), 196 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/i386/kernel/asm-offsets.c
+++ linux/arch/i386/kernel/asm-offsets.c
@@ -15,7 +15,6 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/elf.h>
-#include <asm/pda.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -101,10 +100,6 @@ void foo(void)
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
-	BLANK();
- 	OFFSET(PDA_cpu, i386_pda, cpu_number);
-	OFFSET(PDA_pcurrent, i386_pda, pcurrent);
-
 #ifdef CONFIG_PARAVIRT
 	BLANK();
 	OFFSET(PARAVIRT_enabled, paravirt_ops, paravirt_enabled);
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -18,7 +18,6 @@
 #include <asm/apic.h>
 #include <mach_apic.h>
 #endif
-#include <asm/pda.h>
 
 #include "cpu.h"
 
@@ -47,13 +46,10 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page
 	[GDT_ENTRY_APMBIOS_BASE+2] = { 0x0000ffff, 0x00409200 }, /* data */
 
 	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
-	[GDT_ENTRY_PDA] = { 0x00000000, 0x00c09200 }, /* set in setup_pda */
+	[GDT_ENTRY_PERCPU] = { 0x00000000, 0x00000000 },
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
-DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
-EXPORT_PER_CPU_SYMBOL(_cpu_pda);
-
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_fxsr __cpuinitdata;
 static int disable_x86_serial_nr __cpuinitdata = 1;
@@ -634,21 +630,14 @@ void __init early_cpu_init(void)
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
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
@@ -132,7 +132,7 @@ VM_MASK		= 0x00020000
 	movl $(__USER_DS), %edx; \
 	movl %edx, %ds; \
 	movl %edx, %es; \
-	movl $(__KERNEL_PDA), %edx; \
+	movl $(__KERNEL_PERCPU), %edx; \
 	movl %edx, %fs
 
 #define RESTORE_INT_REGS \
@@ -556,7 +556,6 @@ END(syscall_badsys)
 
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
-	movl %fs:PDA_cpu, %ebx; \
 	PER_CPU(gdt_page, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
@@ -681,7 +680,7 @@ error_code:
 	pushl %fs
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET fs, 0*/
-	movl $(__KERNEL_PDA), %ecx
+	movl $(__KERNEL_PERCPU), %ecx
 	movl %ecx, %fs
 	UNWIND_ESPFIX_STACK
 	popl %ecx
Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -317,12 +317,12 @@ is386:	movl $2,%ecx		# set MP
 	movl %eax,%cr0
 
 	call check_x87
-	call setup_pda
 	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
 	movl %eax,%ss			# after changing gdt.
+	movl %eax,%fs			# gets reset once there's real percpu
 
 	movl $(__USER_DS),%eax		# DS/ES contains default USER segment
 	movl %eax,%ds
@@ -332,16 +332,17 @@ is386:	movl $2,%ecx		# set MP
 	movl %eax,%gs
 	lldt %ax
 
-	movl $(__KERNEL_PDA),%eax
-	mov  %eax,%fs
-
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 #ifdef CONFIG_SMP
 	movb ready, %cl
 	movb $1, ready
 	cmpb $0,%cl		# the first CPU calls start_kernel
-	jne initialize_secondary # all other CPUs call initialize_secondary
+	je   1f
+	movl $(__KERNEL_PERCPU), %eax
+	movl %eax,%fs		# set this cpu's percpu
+	jmp initialize_secondary # all other CPUs call initialize_secondary
+1:
 #endif /* CONFIG_SMP */
 	jmp start_kernel
 
@@ -365,23 +366,6 @@ check_x87:
 	ret
 
 /*
- * Point the GDT at this CPU's PDA.  On boot this will be
- * cpu_gdt_table and boot_pda; for secondary CPUs, these will be
- * that CPU's GDT and PDA.
- */
-ENTRY(setup_pda)
-	/* get the PDA pointer */
-	movl start_pda, %eax
-
-	/* slot the PDA address into the GDT */
-	mov early_gdt_descr+2, %ecx
-	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
-	shr $16, %eax
-	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
-	mov %ah, (__KERNEL_PDA+4+3)(%ecx)		/* base & 0xff000000 */
-	ret
-
-/*
  *  setup_idt
  *
  *  sets up a idt with 256 entries pointing to
@@ -553,9 +537,6 @@ ENTRY(empty_zero_page)
  * This starts the data section.
  */
 .data
-ENTRY(start_pda)
-	.long boot_pda
-
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 	.long __BOOT_DS
Index: linux/arch/i386/kernel/i386_ksyms.c
===================================================================
--- linux.orig/arch/i386/kernel/i386_ksyms.c
+++ linux/arch/i386/kernel/i386_ksyms.c
@@ -28,5 +28,3 @@ EXPORT_SYMBOL(__read_lock_failed);
 #endif
 
 EXPORT_SYMBOL(csum_partial);
-
-EXPORT_SYMBOL(_proxy_pda);
Index: linux/arch/i386/kernel/irq.c
===================================================================
--- linux.orig/arch/i386/kernel/irq.c
+++ linux/arch/i386/kernel/irq.c
@@ -24,6 +24,9 @@
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
+DEFINE_PER_CPU(struct pt_regs *, irq_regs);
+EXPORT_PER_CPU_SYMBOL(irq_regs);
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
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
 
@@ -66,6 +66,12 @@ static int hlt_counter;
 unsigned long boot_option_idle_override = 0;
 EXPORT_SYMBOL(boot_option_idle_override);
 
+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+
 /*
  * Return saved PC of a blocked thread.
  */
@@ -342,7 +348,7 @@ int kernel_thread(int (*fn)(void *), voi
 
 	regs.xds = __USER_DS;
 	regs.xes = __USER_DS;
-	regs.xfs = __KERNEL_PDA;
+	regs.xfs = __KERNEL_PERCPU;
 	regs.orig_eax = -1;
 	regs.eip = (unsigned long) kernel_thread_helper;
 	regs.xcs = __KERNEL_CS | get_kernel_rpl();
@@ -711,7 +717,7 @@ struct task_struct fastcall * __switch_t
 	if (prev->gs | next->gs)
 		loadsegment(gs, next->gs);
 
-	write_pda(pcurrent, next_p);
+	x86_write_percpu(current_task, next_p);
 
 	return prev_p;
 }
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -53,7 +53,6 @@
 #include <asm/desc.h>
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
-#include <asm/pda.h>
 
 #include <mach_apic.h>
 #include <mach_wakecpu.h>
@@ -99,6 +98,9 @@ EXPORT_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
 /*
  * Trampoline 80x86 program as an array.
  */
@@ -456,7 +458,6 @@ extern struct {
 	void * esp;
 	unsigned short ss;
 } stack_start;
-extern struct i386_pda *start_pda;
 
 #ifdef CONFIG_NUMA
 
@@ -784,20 +785,17 @@ static inline struct task_struct * alloc
 /* Initialize the CPU's GDT.  This is either the boot CPU doing itself
    (still using the master per-cpu area), or a CPU doing it for a
    secondary which will soon come up. */
-static __cpuinit void init_gdt(int cpu, struct task_struct *idle)
+static __cpuinit void init_gdt(int cpu)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
-			(u32 *)&gdt[GDT_ENTRY_PDA].b,
-			(unsigned long)pda, sizeof(*pda) - 1,
-			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
-
-	memset(pda, 0, sizeof(*pda));
-	pda->_pda = pda;
-	pda->cpu_number = cpu;
-	pda->pcurrent = idle;
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x80 | DESCTYPE_S | 0x2, 0x8);
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
 }
 
 /* Defined in head.S */
@@ -824,9 +822,9 @@ static int __cpuinit do_boot_cpu(int api
 	if (IS_ERR(idle))
 		panic("failed fork for CPU %d", cpu);
 
-	init_gdt(cpu, idle);
+	init_gdt(cpu);
+ 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
-	start_pda = cpu_pda(cpu);
 
 	idle->thread.eip = (unsigned long) start_secondary;
 	/* start_eip had better be page-aligned! */
@@ -1188,14 +1186,14 @@ static inline void switch_to_new_gdt(voi
 	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
 void __init native_smp_prepare_boot_cpu(void)
 {
 	unsigned int cpu = smp_processor_id();
 
-	init_gdt(cpu, current);
+	init_gdt(cpu);
 	switch_to_new_gdt();
 
 	cpu_set(cpu, cpu_online_map);
Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -504,8 +504,6 @@ static void vmi_pmd_clear(pmd_t *pmd)
 #endif
 
 #ifdef CONFIG_SMP
-extern void setup_pda(void);
-
 static void __devinit
 vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 		     unsigned long start_esp)
@@ -530,13 +528,11 @@ vmi_startup_ipi_hook(int phys_apicid, un
 
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
-	ap.fs = __KERNEL_PDA;
+	ap.fs = __KERNEL_PERCPU;
 	ap.gs = 0;
 
 	ap.eflags = 0;
 
-	setup_pda();
-
 #ifdef CONFIG_X86_PAE
 	/* efer should match BSP efer. */
 	if (cpu_has_nx) {
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -26,7 +26,6 @@ OUTPUT_FORMAT("elf32-i386", "elf32-i386"
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
 jiffies = jiffies_64;
-_proxy_pda = 1;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
Index: linux/include/asm-i386/current.h
===================================================================
--- linux.orig/include/asm-i386/current.h
+++ linux/include/asm-i386/current.h
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
Index: linux/include/asm-i386/irq_regs.h
===================================================================
--- linux.orig/include/asm-i386/irq_regs.h
+++ linux/include/asm-i386/irq_regs.h
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
Index: linux/include/asm-i386/pda.h
===================================================================
--- linux.orig/include/asm-i386/pda.h
+++ /dev/null
@@ -1,99 +0,0 @@
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
-#define cpu_pda(i)	(&per_cpu(_cpu_pda, (i)))
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
-#endif	/* _I386_PDA_H */
Index: linux/include/asm-i386/percpu.h
===================================================================
--- linux.orig/include/asm-i386/percpu.h
+++ linux/include/asm-i386/percpu.h
@@ -1,9 +1,30 @@
 #ifndef __ARCH_I386_PERCPU__
 #define __ARCH_I386_PERCPU__
 
-#ifndef __ASSEMBLY__
-#include <asm-generic/percpu.h>
-#else
+#ifdef __ASSEMBLY__
+
+/*
+ * PER_CPU finds an address of a per-cpu variable.
+ *
+ * Args:
+ *    var - variable name
+ *    reg - 32bit register
+ *
+ * The resulting address is stored in the "reg" argument.
+ *
+ * Example:
+ *    PER_CPU(cpu_gdt_descr, %ebx)
+ */
+#ifdef CONFIG_SMP
+#define PER_CPU(var, reg)			\
+	movl %fs:per_cpu__this_cpu_off, reg;		\
+	addl $per_cpu__##var, reg
+#else /* ! SMP */
+#define PER_CPU(var, reg) \
+	movl $per_cpu__##var, reg;
+#endif	/* SMP */
+
+#else /* ...!ASSEMBLY */
 
 /*
  * PER_CPU finds an address of a per-cpu variable.
@@ -18,14 +39,107 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-#define PER_CPU(var, cpu) \
-	movl __per_cpu_offset(,cpu,4), cpu;	\
-	addl $per_cpu__##var, cpu;
-#else /* ! SMP */
-#define PER_CPU(var, cpu) \
-	movl $per_cpu__##var, cpu;
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
 #endif	/* SMP */
 
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
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -377,7 +377,7 @@ struct thread_struct {
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
-	.fs = __KERNEL_PDA,						\
+	.fs = __KERNEL_PERCPU,						\
 }
 
 /*
Index: linux/include/asm-i386/segment.h
===================================================================
--- linux.orig/include/asm-i386/segment.h
+++ linux/include/asm-i386/segment.h
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
 
Index: linux/include/asm-i386/smp.h
===================================================================
--- linux.orig/include/asm-i386/smp.h
+++ linux/include/asm-i386/smp.h
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/pda.h>
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(__ASSEMBLY__)
@@ -112,7 +111,8 @@ do { } while (0)
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-#define raw_smp_processor_id() (read_pda(cpu_number))
+DECLARE_PER_CPU(int, cpu_number);
+#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
 
 extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_callin_map;
