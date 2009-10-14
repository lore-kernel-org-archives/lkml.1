Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZJNGFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZJNGFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZJNGFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:05:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbZJNGDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:31 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/16] percpu: remove per_cpu__ prefix.
Date: Wed, 14 Oct 2009 15:02:02 +0900
Message-Id: <1255500125-3210-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Now that the return from alloc_percpu is compatible with the address
of per-cpu vars, it makes sense to hand around the address of per-cpu
variables.  To make this sane, we remove the per_cpu__ prefix we used
created to stop people accidentally using these vars directly.

Now we have sparse, we can use that (next patch).

tj: * Updated to convert stuff which were missed by or added after the
      original patch.

    * Kill per_cpu_var() macro.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/blackfin/mach-common/entry.S       |    4 +-
 arch/cris/arch-v10/kernel/entry.S       |    2 +-
 arch/cris/arch-v32/mm/mmu.S             |    2 +-
 arch/ia64/include/asm/percpu.h          |    4 +-
 arch/ia64/kernel/ia64_ksyms.c           |    4 +-
 arch/ia64/mm/discontig.c                |    2 +-
 arch/microblaze/include/asm/entry.h     |    2 +-
 arch/parisc/lib/fixup.S                 |    8 +++---
 arch/powerpc/platforms/pseries/hvCall.S |    2 +-
 arch/sparc/kernel/nmi.c                 |    6 ++--
 arch/sparc/kernel/rtrap_64.S            |    8 +++---
 arch/x86/include/asm/percpu.h           |   37 ++++++++++++++----------------
 arch/x86/include/asm/system.h           |    8 +++---
 arch/x86/kernel/apic/nmi.c              |    6 ++--
 arch/x86/kernel/head_32.S               |    6 ++--
 arch/x86/kernel/vmlinux.lds.S           |    4 +-
 arch/x86/xen/xen-asm_32.S               |    4 +-
 include/asm-generic/percpu.h            |   12 +++++-----
 include/linux/percpu-defs.h             |   18 +++++----------
 include/linux/percpu.h                  |    5 +--
 include/linux/vmstat.h                  |    8 +++---
 kernel/rcutorture.c                     |    8 +++---
 kernel/trace/trace.c                    |    6 ++--
 kernel/trace/trace_functions_graph.c    |    4 +-
 24 files changed, 80 insertions(+), 90 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 1e7cac2..a3ea7e9 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -835,8 +835,8 @@ ENDPROC(_resume)
 
 ENTRY(_ret_from_exception)
 #ifdef CONFIG_IPIPE
-	p2.l = _per_cpu__ipipe_percpu_domain;
-	p2.h = _per_cpu__ipipe_percpu_domain;
+	p2.l = _ipipe_percpu_domain;
+	p2.h = _ipipe_percpu_domain;
 	r0.l = _ipipe_root;
 	r0.h = _ipipe_root;
 	r2 = [p2];
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 2c18d08..c52bef3 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -358,7 +358,7 @@ mmu_bus_fault:
 1:	btstq	12, $r1		   ; Refill?
 	bpl	2f
 	lsrq	24, $r1     ; Get PGD index (bit 24-31)
-	move.d  [per_cpu__current_pgd], $r0 ; PGD for the current process
+	move.d  [current_pgd], $r0 ; PGD for the current process
 	move.d	[$r0+$r1.d], $r0   ; Get PMD
 	beq	2f
 	nop
diff --git a/arch/cris/arch-v32/mm/mmu.S b/arch/cris/arch-v32/mm/mmu.S
index 2238d15..f125d91 100644
--- a/arch/cris/arch-v32/mm/mmu.S
+++ b/arch/cris/arch-v32/mm/mmu.S
@@ -115,7 +115,7 @@
 #ifdef CONFIG_SMP
 	move    $s7, $acr	; PGD
 #else
-	move.d  per_cpu__current_pgd, $acr ; PGD
+	move.d  current_pgd, $acr ; PGD
 #endif
 	; Look up PMD in PGD
 	lsrq	24, $r0	; Get PMD index into PGD (bit 24-31)
diff --git a/arch/ia64/include/asm/percpu.h b/arch/ia64/include/asm/percpu.h
index 30cf465..f7c00a5 100644
--- a/arch/ia64/include/asm/percpu.h
+++ b/arch/ia64/include/asm/percpu.h
@@ -9,7 +9,7 @@
 #define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
 
 #ifdef __ASSEMBLY__
-# define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
+# define THIS_CPU(var)	(var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
 
 
@@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	per_cpu__##var
+#define __ia64_per_cpu_var(var)	var
 
 #include <asm-generic/percpu.h>
 
diff --git a/arch/ia64/kernel/ia64_ksyms.c b/arch/ia64/kernel/ia64_ksyms.c
index 461b999..7f4a0ed 100644
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -30,9 +30,9 @@ EXPORT_SYMBOL(max_low_pfn);	/* defined by bootmem.c, but not exported by generic
 #endif
 
 #include <asm/processor.h>
-EXPORT_SYMBOL(per_cpu__ia64_cpu_info);
+EXPORT_SYMBOL(ia64_cpu_info);
 #ifdef CONFIG_SMP
-EXPORT_SYMBOL(per_cpu__local_per_cpu_offset);
+EXPORT_SYMBOL(local_per_cpu_offset);
 #endif
 
 #include <asm/uaccess.h>
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 19c4b21..8d586d1 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -459,7 +459,7 @@ static void __init initialize_pernode_data(void)
 		cpu = 0;
 		node = node_cpuid[cpu].nid;
 		cpu0_cpu_info = (struct cpuinfo_ia64 *)(__phys_per_cpu_start +
-			((char *)&per_cpu__ia64_cpu_info - __per_cpu_start));
+			((char *)&ia64_cpu_info - __per_cpu_start));
 		cpu0_cpu_info->node_data = mem_data[node].node_data;
 	}
 #endif /* CONFIG_SMP */
diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
index 61abbd2..ec89f2a 100644
--- a/arch/microblaze/include/asm/entry.h
+++ b/arch/microblaze/include/asm/entry.h
@@ -21,7 +21,7 @@
  * places
  */
 
-#define PER_CPU(var) per_cpu__##var
+#define PER_CPU(var) var
 
 # ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned int, KSP); /* Saved kernel stack pointer */
diff --git a/arch/parisc/lib/fixup.S b/arch/parisc/lib/fixup.S
index d172d42..f8c45cc 100644
--- a/arch/parisc/lib/fixup.S
+++ b/arch/parisc/lib/fixup.S
@@ -36,8 +36,8 @@
 #endif
 	/* t2 = &__per_cpu_offset[smp_processor_id()]; */
 	LDREGX \t2(\t1),\t2 
-	addil LT%per_cpu__exception_data,%r27
-	LDREG RT%per_cpu__exception_data(%r1),\t1
+	addil LT%exception_data,%r27
+	LDREG RT%exception_data(%r1),\t1
 	/* t1 = &__get_cpu_var(exception_data) */
 	add,l \t1,\t2,\t1
 	/* t1 = t1->fault_ip */
@@ -46,8 +46,8 @@
 #else
 	.macro  get_fault_ip t1 t2
 	/* t1 = &__get_cpu_var(exception_data) */
-	addil LT%per_cpu__exception_data,%r27
-	LDREG RT%per_cpu__exception_data(%r1),\t2
+	addil LT%exception_data,%r27
+	LDREG RT%exception_data(%r1),\t2
 	/* t1 = t2->fault_ip */
 	LDREG EXCDATA_IP(\t2), \t1
 	.endm
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index c1427b3..580f789 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -55,7 +55,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_PURR);				\
 	/* calculate address of stat structure r4 = opcode */	\
 	srdi	r4,r4,2;		/* index into array */	\
 	mulli	r4,r4,HCALL_STAT_SIZE;				\
-	LOAD_REG_ADDR(r7, per_cpu__hcall_stats);		\
+	LOAD_REG_ADDR(r7, hcall_stats);				\
 	add	r4,r4,r7;					\
 	ld	r7,PACA_DATA_OFFSET(r13); /* per cpu offset */	\
 	add	r4,r4,r7;					\
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index f30f4a1..2ad288f 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -112,13 +112,13 @@ notrace __kprobes void perfctr_irq(int irq, struct pt_regs *regs)
 		touched = 1;
 	}
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
-		__this_cpu_inc(per_cpu_var(alert_counter));
-		if (__this_cpu_read(per_cpu_var(alert_counter)) == 30 * nmi_hz)
+		__this_cpu_inc(alert_counter);
+		if (__this_cpu_read(alert_counter) == 30 * nmi_hz)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		__this_cpu_write(per_cpu_var(alert_counter), 0);
+		__this_cpu_write(alert_counter, 0);
 	}
 	if (__get_cpu_var(wd_enabled)) {
 		write_pic(picl_value(nmi_hz));
diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index fd3cee4..1ddec40 100644
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -149,11 +149,11 @@ rtrap_nmi:	ldx			[%sp + PTREGS_OFF + PT_V9_TSTATE], %l1
 rtrap_irq:
 rtrap:
 #ifndef CONFIG_SMP
-		sethi			%hi(per_cpu____cpu_data), %l0
-		lduw			[%l0 + %lo(per_cpu____cpu_data)], %l1
+		sethi			%hi(__cpu_data), %l0
+		lduw			[%l0 + %lo(__cpu_data)], %l1
 #else
-		sethi			%hi(per_cpu____cpu_data), %l0
-		or			%l0, %lo(per_cpu____cpu_data), %l0
+		sethi			%hi(__cpu_data), %l0
+		or			%l0, %lo(__cpu_data), %l0
 		lduw			[%l0 + %g5], %l1
 #endif
 		cmp			%l1, 0
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0c44196..4c170cc 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -25,19 +25,18 @@
  */
 #ifdef CONFIG_SMP
 #define PER_CPU(var, reg)						\
-	__percpu_mov_op %__percpu_seg:per_cpu__this_cpu_off, reg;	\
-	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%__percpu_seg:per_cpu__##var
+	__percpu_mov_op %__percpu_seg:this_cpu_off, reg;		\
+	lea var(reg), reg
+#define PER_CPU_VAR(var)	%__percpu_seg:var
 #else /* ! SMP */
-#define PER_CPU(var, reg)						\
-	__percpu_mov_op $per_cpu__##var, reg
-#define PER_CPU_VAR(var)	per_cpu__##var
+#define PER_CPU(var, reg)	__percpu_mov_op $var, reg
+#define PER_CPU_VAR(var)	var
 #endif	/* SMP */
 
 #ifdef CONFIG_X86_64_SMP
 #define INIT_PER_CPU_VAR(var)  init_per_cpu__##var
 #else
-#define INIT_PER_CPU_VAR(var)  per_cpu__##var
+#define INIT_PER_CPU_VAR(var)  var
 #endif
 
 #else /* ...!ASSEMBLY */
@@ -60,12 +59,12 @@
  * There also must be an entry in vmlinux_64.lds.S
  */
 #define DECLARE_INIT_PER_CPU(var) \
-       extern typeof(per_cpu_var(var)) init_per_cpu_var(var)
+       extern typeof(var) init_per_cpu_var(var)
 
 #ifdef CONFIG_X86_64_SMP
 #define init_per_cpu_var(var)  init_per_cpu__##var
 #else
-#define init_per_cpu_var(var)  per_cpu_var(var)
+#define init_per_cpu_var(var)  var
 #endif
 
 /* For arch-specific code, we can use direct single-insn ops (they
@@ -142,16 +141,14 @@ do {							\
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
-					       "m" (per_cpu__##var))
-#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
-					       "p" (&per_cpu__##var))
-#define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
-#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
-#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
-#define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
-#define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
-#define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
+#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
+#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
+#define percpu_write(var, val)		percpu_to_op("mov", var, val)
+#define percpu_add(var, val)		percpu_to_op("add", var, val)
+#define percpu_sub(var, val)		percpu_to_op("sub", var, val)
+#define percpu_and(var, val)		percpu_to_op("and", var, val)
+#define percpu_or(var, val)		percpu_to_op("or", var, val)
+#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -236,7 +233,7 @@ do {							\
 ({									\
 	int old__;							\
 	asm volatile("btr %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
-		     : "=r" (old__), "+m" (per_cpu__##var)		\
+		     : "=r" (old__), "+m" (var)				\
 		     : "dIr" (bit));					\
 	old__;								\
 })
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index f08f973..de10c19 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -31,7 +31,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
 	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
 #define __switch_canary_oparam						\
-	, [stack_canary] "=m" (per_cpu_var(stack_canary.canary))
+	, [stack_canary] "=m" (stack_canary.canary)
 #define __switch_canary_iparam						\
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
@@ -113,7 +113,7 @@ do {									\
 	"movq %P[task_canary](%%rsi),%%r8\n\t"				  \
 	"movq %%r8,"__percpu_arg([gs_canary])"\n\t"
 #define __switch_canary_oparam						  \
-	, [gs_canary] "=m" (per_cpu_var(irq_stack_union.stack_canary))
+	, [gs_canary] "=m" (irq_stack_union.stack_canary)
 #define __switch_canary_iparam						  \
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
@@ -134,7 +134,7 @@ do {									\
 	     __switch_canary						  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     "movq %%rax,%%rdi\n\t" 					  \
-	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"	  \
+	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"		  \
 	     "jnz   ret_from_fork\n\t"					  \
 	     RESTORE_CONTEXT						  \
 	     : "=a" (last)					  	  \
@@ -144,7 +144,7 @@ do {									\
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [_tif_fork] "i" (_TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [current_task] "m" (per_cpu_var(current_task))		  \
+	       [current_task] "m" (current_task)			  \
 	       __switch_canary_iparam					  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index e631cc4..4540437 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -437,8 +437,8 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		__this_cpu_inc(per_cpu_var(alert_counter));
-		if (__this_cpu_read(per_cpu_var(alert_counter)) == 5 * nmi_hz)
+		__this_cpu_inc(alert_counter);
+		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
@@ -446,7 +446,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		__this_cpu_write(per_cpu_var(alert_counter), 0);
+		__this_cpu_write(alert_counter, 0);
 	}
 
 	/* see if the nmi watchdog went off */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 050c278..fd39eaf 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -438,8 +438,8 @@ is386:	movl $2,%ecx		# set MP
 	 */
 	cmpb $0,ready
 	jne 1f
-	movl $per_cpu__gdt_page,%eax
-	movl $per_cpu__stack_canary,%ecx
+	movl $gdt_page,%eax
+	movl $stack_canary,%ecx
 	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
 	shrl $16, %ecx
 	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
@@ -702,7 +702,7 @@ idt_descr:
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
-	.long per_cpu__gdt_page		/* Overwritten for secondary CPUs */
+	.long gdt_page			/* Overwritten for secondary CPUs */
 
 /*
  * The boot_gdt must mirror the equivalent in setup.S and is
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..ecb9271 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -312,7 +312,7 @@ SECTIONS
  * Per-cpu symbols which need to be offset from __per_cpu_load
  * for the boot processor.
  */
-#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
+#define INIT_PER_CPU(x) init_per_cpu__##x = x + __per_cpu_load
 INIT_PER_CPU(gdt_page);
 INIT_PER_CPU(irq_stack_union);
 
@@ -323,7 +323,7 @@ INIT_PER_CPU(irq_stack_union);
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
 #ifdef CONFIG_SMP
-. = ASSERT((per_cpu__irq_stack_union == 0),
+. = ASSERT((irq_stack_union == 0),
            "irq_stack_union is not at start of per-cpu area");
 #endif
 
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 88e15de..22a2093 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -90,9 +90,9 @@ ENTRY(xen_iret)
 	GET_THREAD_INFO(%eax)
 	movl TI_cpu(%eax), %eax
 	movl __per_cpu_offset(,%eax,4), %eax
-	mov per_cpu__xen_vcpu(%eax), %eax
+	mov xen_vcpu(%eax), %eax
 #else
-	movl per_cpu__xen_vcpu, %eax
+	movl xen_vcpu, %eax
 #endif
 
 	/* check IF state we're restoring */
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 8087b90..ca6f049 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -50,11 +50,11 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  * offset.
  */
 #define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
 #define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
+	(*SHIFT_PERCPU_PTR(&(var), my_cpu_offset))
 #define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
+	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))
 
 #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
 #define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
@@ -66,9 +66,9 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
-#define __get_cpu_var(var)			per_cpu_var(var)
-#define __raw_get_cpu_var(var)			per_cpu_var(var)
+#define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
+#define __get_cpu_var(var)			(var)
+#define __raw_get_cpu_var(var)			(var)
 #define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
 #define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
 
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 5a5d6ce..ee99f6c 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -2,12 +2,6 @@
 #define _LINUX_PERCPU_DEFS_H
 
 /*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
-
-/*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
  * 'sec' argument.  This may be used to affect the parameters governing the
@@ -56,24 +50,24 @@
  */
 #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
 	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
-	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
+	extern __PCPU_ATTRS(sec) __typeof__(type) name
 
 #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
 	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
 	extern __PCPU_DUMMY_ATTRS char __pcpu_unique_##name;		\
 	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
 	__PCPU_ATTRS(sec) PER_CPU_DEF_ATTRIBUTES __weak			\
-	__typeof__(type) per_cpu__##name
+	__typeof__(type) name
 #else
 /*
  * Normal declaration and definition macros.
  */
 #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
-	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
+	extern __PCPU_ATTRS(sec) __typeof__(type) name
 
 #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
 	__PCPU_ATTRS(sec) PER_CPU_DEF_ATTRIBUTES			\
-	__typeof__(type) per_cpu__##name
+	__typeof__(type) name
 #endif
 
 /*
@@ -137,8 +131,8 @@
 /*
  * Intermodule exports for per-CPU variables.
  */
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(var)
 
 
 #endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 522f421..e12410e 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -182,7 +182,7 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 #ifndef percpu_read
 # define percpu_read(var)						\
   ({									\
-	typeof(per_cpu_var(var)) __tmp_var__;				\
+	typeof(var) __tmp_var__;					\
 	__tmp_var__ = get_cpu_var(var);					\
 	put_cpu_var(var);						\
 	__tmp_var__;							\
@@ -253,8 +253,7 @@ do {									\
 
 /*
  * Optimized manipulation for memory allocated through the per cpu
- * allocator or for addresses of per cpu variables (can be determined
- * using per_cpu_var(xx).
+ * allocator or for addresses of per cpu variables.
  *
  * These operation guarantee exclusivity of access for other operations
  * on the *same* processor. The assumption is that per cpu data is only
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index d858897..3e489fd 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -76,22 +76,22 @@ DECLARE_PER_CPU(struct vm_event_state, vm_event_states);
 
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
+	__this_cpu_inc(vm_event_states.event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
 {
-	this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
+	this_cpu_inc(vm_event_states.event[item]);
 }
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
+	__this_cpu_add(vm_event_states.event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
 {
-	this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
+	this_cpu_add(vm_event_states.event[item], delta);
 }
 
 extern void all_vm_events(unsigned long *);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 178967b..e339ab3 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -731,13 +731,13 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
-	__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
+	__this_cpu_inc(rcu_torture_count[pipe_count]);
 	completed = cur_ops->completed() - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
 		/* Should not happen, but... */
 		completed = RCU_TORTURE_PIPE_LEN;
 	}
-	__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
+	__this_cpu_inc(rcu_torture_batch[completed]);
 	preempt_enable();
 	cur_ops->readunlock(idx);
 }
@@ -786,13 +786,13 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
-		__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
+		__this_cpu_inc(rcu_torture_count[pipe_count]);
 		completed = cur_ops->completed() - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
 			/* Should not happen, but... */
 			completed = RCU_TORTURE_PIPE_LEN;
 		}
-		__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
+		__this_cpu_inc(rcu_torture_batch[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 85a5ed7..b808177 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -91,12 +91,12 @@ DEFINE_PER_CPU(int, ftrace_cpu_disabled);
 static inline void ftrace_disable_cpu(void)
 {
 	preempt_disable();
-	__this_cpu_inc(per_cpu_var(ftrace_cpu_disabled));
+	__this_cpu_inc(ftrace_cpu_disabled);
 }
 
 static inline void ftrace_enable_cpu(void)
 {
-	__this_cpu_dec(per_cpu_var(ftrace_cpu_disabled));
+	__this_cpu_dec(ftrace_cpu_disabled);
 	preempt_enable();
 }
 
@@ -1085,7 +1085,7 @@ trace_function(struct trace_array *tr,
 	struct ftrace_entry *entry;
 
 	/* If we are reading the ring buffer, don't trace */
-	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
 		return;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_FN, sizeof(*entry),
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 90a6daa..8614e32 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -176,7 +176,7 @@ static int __trace_graph_entry(struct trace_array *tr,
 	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ent_entry *entry;
 
-	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
 		return 0;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
@@ -240,7 +240,7 @@ static void __trace_graph_return(struct trace_array *tr,
 	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ret_entry *entry;
 
-	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
 		return;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
-- 
1.6.4.2

