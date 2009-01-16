Return-Path: <linux-kernel-owner+w=401wt.eu-S936072AbZAPOVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936072AbZAPOVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935309AbZAPORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:17:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:46175 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124AbZAPORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FA/7VqoI7bmmk3AFZAFGyrL5PP7arVeNsLvZMijy9cpxk9PqRODeUig60/rY8qwVi6
         eIvaRiXwdvOC+X1W6Cyf03B7aGqsdVB5EcSY4CKqA3CuS9I0iQVrXi8uXX8RB7rwlm6H
         IDuuj7PcxVBMdFiUlxZFsYyqepbiZzZOmryhg=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 16/17] x86-64: Remove the PDA
Date: Fri, 16 Jan 2009 09:16:35 -0500
Message-Id: <1232115396-26367-16-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-15-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
 <1232115396-26367-12-git-send-email-brgerst@gmail.com>
 <1232115396-26367-13-git-send-email-brgerst@gmail.com>
 <1232115396-26367-14-git-send-email-brgerst@gmail.com>
 <1232115396-26367-15-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the PDA is empty except for the stack canary, it can be removed.
The irqstack is moved to the start of the per-cpu section.  If the stack
protector is enabled, the canary overlaps the bottom 48 bytes of the irqstack
on SMP.  On UP it is a seperate variable, since it is the only thing referenced
via %gs.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h        |    5 -----
 arch/x86/include/asm/processor.h  |    4 ++++
 arch/x86/kernel/asm-offsets_64.c  |    4 ----
 arch/x86/kernel/cpu/common.c      |   10 +++++++++-
 arch/x86/kernel/head_64.S         |    6 +++---
 arch/x86/kernel/process_64.c      |    7 +------
 arch/x86/kernel/setup_percpu.c    |   22 ++++------------------
 arch/x86/kernel/vmlinux_64.lds.S  |    8 ++++++--
 include/asm-generic/vmlinux.lds.h |   35 +----------------------------------
 9 files changed, 28 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 6ca7bc0..ba46416 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -17,11 +17,6 @@ struct x8664_pda {
 	unsigned long unused4;
 	int unused5;
 	unsigned int unused6;		/* 36 was cpunumber */
-#ifdef CONFIG_CC_STACKPROTECTOR
-	unsigned long stack_canary;	/* 40 stack canary value */
-					/* gcc-ABI: this canary MUST be at
-					   offset 40!!! */
-#endif
 	short in_bootmem;		/* pda lives in bootmem */
 } ____cacheline_aligned_in_smp;
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e32ee80..a20e5f5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -381,6 +381,10 @@ DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
 DECLARE_PER_CPU(char, irqstack[IRQSTACKSIZE]);
 DECLARE_PER_CPU(char *, irqstackptr);
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+DECLARE_PER_CPU(unsigned long, stack_canary);
+#endif
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index fbc6045..8793ab3 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -47,10 +47,6 @@ int main(void)
 #endif
 	BLANK();
 #undef ENTRY
-#define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	DEFINE(pda_size, sizeof(struct x8664_pda));
-	BLANK();
-#undef ENTRY
 #ifdef CONFIG_PARAVIRT
 	BLANK();
 	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 716c1e8..cc4e398 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -881,7 +881,15 @@ __setup("clearcpuid=", setup_disablecpuid);
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-DEFINE_PER_CPU_PAGE_ALIGNED(char, irqstack[IRQSTACKSIZE]) __aligned(PAGE_SIZE);
+#ifdef CONFIG_SMP
+/* On SMP, the canary overlaps the bottom of the irqstack */
+#define IRQSTACK_SECTION ".first"
+#else
+#define IRQSTACK_SECTION ".page_aligned"
+DEFINE_PER_CPU(unsigned long, stack_canary);
+#endif
+
+DEFINE_PER_CPU_SECTION(char, irqstack[IRQSTACKSIZE], IRQSTACK_SECTION) __aligned(PAGE_SIZE);
 DEFINE_PER_CPU(char *, irqstackptr) = per_cpu_var(irqstack) + IRQSTACKSIZE - 64;
 
 DEFINE_PER_CPU(unsigned long, kernelstack) = (unsigned long)&init_thread_union -
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b565719..d7ad8bc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -249,8 +249,8 @@ ENTRY(secondary_startup_64)
 	 * secondary CPU,initial_gs should be set to its pda address
 	 * before the CPU runs this code.
 	 *
-	 * On UP, initial_gs points to PER_CPU_VAR(__pda) and doesn't
-	 * change.
+	 * On UP, initial_gs points to the stack canary (offset by -40)
+	 * and doesn't change.
 	 */
 	movl	$MSR_GS_BASE,%ecx
 	movq	initial_gs(%rip),%rax
@@ -283,7 +283,7 @@ ENTRY(secondary_startup_64)
 #ifdef CONFIG_SMP
 	.quad	__per_cpu_load
 #else
-	.quad	PER_CPU_VAR(__pda)
+	.quad	PER_CPU_VAR(stack_canary)-40
 #endif
 	__FINITDATA
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3cf12f4..458e1de 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -627,12 +627,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNELSTACK_OFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
-	/*
-	 * Build time only check to make sure the stack_canary is at
-	 * offset 40 in the pda; this is a gcc ABI requirement
-	 */
-	BUILD_BUG_ON(offsetof(struct x8664_pda, stack_canary) != 40);
+	x86_write_percpu(stack_canary, next_p->stack_canary);
 #endif
 
 	/*
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 916e2cf..5e832b9 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -68,19 +68,6 @@ static void __init setup_node_to_cpumask_map(void);
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-/*
- * On SMP, pda offset also duals as percpu base address and thus it
- * should be at the start of per-cpu area.  To achieve this, it's
- * preallocated in vmlinux_64.lds.S directly instead of using
- * DEFINE_PER_CPU().
- */
-#ifdef CONFIG_X86_64
-#ifndef CONFIG_SMP
-DEFINE_PER_CPU(struct x8664_pda, __pda);
-#endif
-EXPORT_PER_CPU_SYMBOL(__pda);
-#endif /* CONFIG_SMP && CONFIG_X86_64 */
-
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
@@ -191,16 +178,15 @@ void __init setup_per_cpu_areas(void)
 #ifdef CONFIG_X86_64
 		per_cpu(irqstackptr, cpu) = per_cpu(irqstack, cpu) + IRQSTACKSIZE - 64;
 		/*
-		 * CPU0 modified pda in the init data area, reload pda
-		 * offset for CPU0 and clear the area for others.
+		 * CPU0 modified data in the init per-cpu area, reload %gs
+		 * offset for CPU0.
 		 */
 		if (cpu == 0) {
 			/* Memory clobbers used to order pda/percpu accesses */
 			mb();
-			wrmsrl(MSR_GS_BASE, cpu_pda(0));
+			wrmsrl(MSR_GS_BASE, per_cpu_offset(0));
 			mb();
-		} else
-			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
+		}
 #endif
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index a09abb8..c52af06 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -4,6 +4,10 @@
 
 #define LOAD_OFFSET __START_KERNEL_map
 
+#define PER_CPU_SECTIONS \
+	*(.data.percpu.irqstack) \
+	DEFAULT_PER_CPU_SECTIONS
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
@@ -220,8 +224,8 @@ SECTIONS
    * so that it can be accessed as a percpu variable.
    */
   . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR_PREALLOC(0, :percpu, pda_size)
-  per_cpu____pda = __per_cpu_start;
+  PERCPU_VADDR(0, :percpu)
+  per_cpu__stack_canary = __per_cpu_start + 40;
 #else
   PERCPU(PAGE_SIZE)
 #endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e53319c..4e92e0d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -441,40 +441,6 @@
 	. = __per_cpu_load + SIZEOF(.data.percpu);
 
 /**
- * PERCPU_VADDR_PREALLOC - define output section for percpu area with prealloc
- * @vaddr: explicit base address (optional)
- * @phdr: destination PHDR (optional)
- * @prealloc: the size of prealloc area
- *
- * Macro which expands to output section for percpu area.  If @vaddr
- * is not blank, it specifies explicit base address and all percpu
- * symbols will be offset from the given address.  If blank, @vaddr
- * always equals @laddr + LOAD_OFFSET.
- *
- * @phdr defines the output PHDR to use if not blank.  Be warned that
- * output PHDR is sticky.  If @phdr is specified, the next output
- * section in the linker script will go there too.  @phdr should have
- * a leading colon.
- *
- * If @prealloc is non-zero, the specified number of bytes will be
- * reserved at the start of percpu area.  As the prealloc area is
- * likely to break alignment, this macro puts areas in increasing
- * alignment order.
- *
- * This macro defines three symbols, __per_cpu_load, __per_cpu_start
- * and __per_cpu_end.  The first one is the vaddr of loaded percpu
- * init data.  __per_cpu_start equals @vaddr and __per_cpu_end is the
- * end offset.
- */
-#define PERCPU_VADDR_PREALLOC(vaddr, segment, prealloc)			\
-	PERCPU_PROLOG(vaddr)						\
-		. += prealloc;						\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
-		*(.data.percpu.page_aligned)				\
-	PERCPU_EPILOG(segment)
-
-/**
  * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
  * @phdr: destination PHDR (optional)
@@ -485,6 +451,7 @@
  */
 #define PERCPU_VADDR(vaddr, phdr)					\
 	PERCPU_PROLOG(vaddr)						\
+		*(.data.percpu.first)					\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
-- 
1.6.1.rc1

