Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZAMKma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZAMKma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZAMKj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:51174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbZAMKjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:24 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] x86_64: merge 64 and 32 SMP percpu handling
Date: Tue, 13 Jan 2009 19:38:13 +0900
Message-Id: <1231843097-18003-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that pda is allocated as part of percpu, percpu doesn't need to be
accessed through pda.  Unify x86_64 SMP percpu access with x86_32 SMP
one.  Other than the segment register, operand size and the base of
percpu symbols, they behave identical now.

This patch replaces now unnecessary pda->data_offset with a dummy
field which is necessary to keep stack_canary at its place.  This
patch also moves per_cpu_offset initialization out of init_gdt() into
setup_per_cpu_areas().  Note that this change also necessitates
explicit per_cpu_offset initializations in voyager_smp.c.

With this change, x86_OP_percpu()'s are as efficient on x86_64 as on
x86_32 and also x86_64 can use assembly PER_CPU macros.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/pda.h          |    3 +-
 arch/x86/include/asm/percpu.h       |  127 +++++++++++------------------------
 arch/x86/kernel/asm-offsets_64.c    |    1 -
 arch/x86/kernel/entry_64.S          |    7 +-
 arch/x86/kernel/head64.c            |    2 -
 arch/x86/kernel/setup_percpu.c      |   15 ++--
 arch/x86/kernel/smpcommon.c         |    3 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +
 8 files changed, 55 insertions(+), 105 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2d5b49c..e91558e 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -11,8 +11,7 @@
 /* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
 	struct task_struct *pcurrent;	/* 0  Current process */
-	unsigned long data_offset;	/* 8 Per cpu data offset from linker
-					   address */
+	unsigned long dummy;
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0ed77cf..556f84b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -1,62 +1,13 @@
 #ifndef _ASM_X86_PERCPU_H
 #define _ASM_X86_PERCPU_H
 
-#ifndef __ASSEMBLY__
 #ifdef CONFIG_X86_64
-extern void load_pda_offset(int cpu);
+#define __percpu_seg		gs
+#define __percpu_mov_op		movq
 #else
-static inline void load_pda_offset(int cpu) { }
-#endif
-#endif
-
-#ifdef CONFIG_X86_64
-#include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
-#include <asm/pda.h>
-
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
+#define __percpu_seg		fs
+#define __percpu_mov_op		movl
 #endif
-#include <asm-generic/percpu.h>
-
-DECLARE_PER_CPU(struct x8664_pda, pda);
-
-/*
- * These are supposed to be implemented as a single instruction which
- * operates on the per-cpu data base segment.  x86-64 doesn't have
- * that yet, so this is a fairly inefficient workaround for the
- * meantime.  The single instruction is atomic with respect to
- * preemption and interrupts, so we need to explicitly disable
- * interrupts here to achieve the same effect.  However, because it
- * can be used from within interrupt-disable/enable, we can't actually
- * disable interrupts; disabling preemption is enough.
- */
-#define x86_read_percpu(var)						\
-	({								\
-		typeof(per_cpu_var(var)) __tmp;				\
-		preempt_disable();					\
-		__tmp = __get_cpu_var(var);				\
-		preempt_enable();					\
-		__tmp;							\
-	})
-
-#define x86_write_percpu(var, val)					\
-	do {								\
-		preempt_disable();					\
-		__get_cpu_var(var) = (val);				\
-		preempt_enable();					\
-	} while(0)
-
-#else /* CONFIG_X86_64 */
 
 #ifdef __ASSEMBLY__
 
@@ -73,42 +24,26 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-#define PER_CPU(var, reg)				\
-	movl %fs:per_cpu__##this_cpu_off, reg;		\
+#define PER_CPU(var, reg)						\
+	__percpu_mov_op %__percpu_seg:per_cpu__this_cpu_off, reg;	\
 	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%fs:per_cpu__##var
+#define PER_CPU_VAR(var)	%__percpu_seg:per_cpu__##var
 #else /* ! SMP */
-#define PER_CPU(var, reg)			\
-	movl $per_cpu__##var, reg
+#define PER_CPU(var, reg)						\
+	__percpu_mov_op $per_cpu__##var, reg
 #define PER_CPU_VAR(var)	per_cpu__##var
 #endif	/* SMP */
 
 #else /* ...!ASSEMBLY */
 
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-
-#define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
-#define __percpu_seg "%%fs:"
+#include <linux/stringify.h>
 
-#else  /* !SMP */
-
-#define __percpu_seg ""
-
-#endif	/* SMP */
+#ifdef CONFIG_SMP
+#define __percpu_seg_str	"%%"__stringify(__percpu_seg)":"
+#define __my_cpu_offset		x86_read_percpu(this_cpu_off)
+#else
+#define __percpu_seg_str
+#endif
 
 #include <asm-generic/percpu.h>
 
@@ -128,20 +63,25 @@ do {							\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b %1,"__percpu_seg"%0"		\
+		asm(op "b %1,"__percpu_seg_str"%0"	\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 2:						\
-		asm(op "w %1,"__percpu_seg"%0"		\
+		asm(op "w %1,"__percpu_seg_str"%0"	\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 4:						\
-		asm(op "l %1,"__percpu_seg"%0"		\
+		asm(op "l %1,"__percpu_seg_str"%0"	\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
+	case 8:						\
+		asm(op "q %1,"__percpu_seg_str"%0"	\
+		    : "+m" (var)			\
+		    : "r" ((T__)val));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 } while (0)
@@ -151,17 +91,22 @@ do {							\
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_seg"%1,%0"		\
+		asm(op "b "__percpu_seg_str"%1,%0"	\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 2:						\
-		asm(op "w "__percpu_seg"%1,%0"		\
+		asm(op "w "__percpu_seg_str"%1,%0"	\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 4:						\
-		asm(op "l "__percpu_seg"%1,%0"		\
+		asm(op "l "__percpu_seg_str"%1,%0"	\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg_str"%1,%0"	\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
@@ -175,8 +120,14 @@ do {							\
 #define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
 #define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
+
+#ifdef CONFIG_X86_64
+extern void load_pda_offset(int cpu);
+#else
+static inline void load_pda_offset(int cpu) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index f8d1b04..f4cc81b 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -55,7 +55,6 @@ int main(void)
 	ENTRY(irqcount);
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
-	ENTRY(data_offset);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e28c7a9..4833f3a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -52,6 +52,7 @@
 #include <asm/irqflags.h>
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
+#include <asm/percpu.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -1072,10 +1073,10 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	movq %gs:pda_data_offset, %rbp
-	subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	PER_CPU(init_tss, %rbp)
+	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index ff39bdd..9194074 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -38,8 +38,6 @@ void __init x86_64_init_pda(void)
 #else
 	cpu_pda(0) = &_boot_cpu_pda;
 #endif
-	cpu_pda(0)->data_offset =
-		(unsigned long)(__per_cpu_load - __per_cpu_start);
 	pda_init(0);
 }
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 24d3e0d..76a2498 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -105,14 +105,14 @@ static void __init setup_per_cpu_maps(void)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
+#ifdef CONFIG_X86_64
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+	[0] = (unsigned long)__per_cpu_load,
+};
+#else
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(__per_cpu_offset);
 #endif
+EXPORT_SYMBOL(__per_cpu_offset);
 
 /*
  * Great future plan:
@@ -159,6 +159,7 @@ void __init setup_per_cpu_areas(void)
 #endif
 
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
+		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 #ifdef CONFIG_X86_64
 		cpu_pda(cpu) = (void *)ptr;
 
@@ -171,7 +172,7 @@ void __init setup_per_cpu_areas(void)
 		else
 			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
 #endif
-		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 397e309..84395fa 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -4,10 +4,10 @@
 #include <linux/module.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_X86_32
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
+#ifdef CONFIG_X86_32
 /*
  * Initialize the CPU's GDT.  This is either the boot CPU doing itself
  * (still using the master per-cpu area), or a CPU doing it for a
@@ -24,7 +24,6 @@ __cpuinit void init_gdt(int cpu)
 	write_gdt_entry(get_cpu_gdt_table(cpu),
 			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
 
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 5214500..7d79a52 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -539,6 +539,7 @@ static void __init do_boot_cpu(__u8 cpu)
 	stack_start.sp = (void *)idle->thread.sp;
 
 	init_gdt(cpu);
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
@@ -1756,6 +1757,7 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	switch_to_new_gdt();
 
 	cpu_set(smp_processor_id(), cpu_online_map);
-- 
1.5.6

