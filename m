Return-Path: <linux-kernel-owner+w=401wt.eu-S1163342AbXD1SBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163342AbXD1SBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163349AbXD1SBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:39000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163350AbXD1R7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:03 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [15/22] x86_64: Remove the identity mapping as early as possible
Message-Id: <20070428175902.89908151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


With the rewrite of the SMP trampoline and the early page
allocator there is nothing that needs identity mapped pages,
once we start executing C code.

So add zap_identity_mappings into head64.c and remove
zap_low_mappings() from much later in the code.  The functions
 are subtly different thus the name change.

This also kills boot_level4_pgt which was from an earlier
attempt to move the identity mappings as early as possible,
and is now no longer needed.  Essentially I have replaced
boot_level4_pgt with trampoline_level4_pgt in trampoline.S

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/head.S    |   39 ++++++++++++++-------------------------
 arch/x86_64/kernel/head64.c  |   17 +++++++++++------
 arch/x86_64/kernel/setup.c   |    2 --
 arch/x86_64/kernel/setup64.c |    1 -
 arch/x86_64/mm/init.c        |   24 ------------------------
 include/asm-x86_64/pgtable.h |    1 -
 include/asm-x86_64/proto.h   |    2 --
 7 files changed, 25 insertions(+), 61 deletions(-)

Index: linux/arch/x86_64/kernel/head64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/head64.c
+++ linux/arch/x86_64/kernel/head64.c
@@ -18,8 +18,16 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 #include <asm/sections.h>
 
+static void __init zap_identity_mappings(void)
+{
+	pgd_t *pgd = pgd_offset_k(0UL);
+	pgd_clear(pgd);
+	__flush_tlb();
+}
+
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
 static void __init clear_bss(void)
@@ -57,18 +65,15 @@ void __init x86_64_start_kernel(char * r
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/* Make NULL pointers segfault */
+	zap_identity_mappings();
+
 	for (i = 0; i < IDT_ENTRIES; i++)
 		set_intr_gate(i, early_idt_handler);
 	asm volatile("lidt %0" :: "m" (idt_descr));
 
 	early_printk("Kernel alive\n");
 
-	/*
-	 * switch to init_level4_pgt from boot_level4_pgt
-	 */
-	memcpy(init_level4_pgt, boot_level4_pgt, PTRS_PER_PGD*sizeof(pgd_t));
-	asm volatile("movq %0,%%cr3" :: "r" (__pa_symbol(&init_level4_pgt)));
-
  	for (i = 0; i < NR_CPUS; i++)
  		cpu_pda(i) = &boot_cpu_pda[i];
 
Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -71,7 +71,7 @@ startup_32:
 	movl	%eax, %cr4
 
 	/* Setup early boot stage 4 level pagetables */
-	movl	$(boot_level4_pgt - __START_KERNEL_map), %eax
+	movl	$(init_level4_pgt - __START_KERNEL_map), %eax
 	movl	%eax, %cr3
 
 	/* Setup EFER (Extended Feature Enable Register) */
@@ -115,7 +115,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr4
 
 	/* Setup early boot stage 4 level pagetables. */
-	movq	$(boot_level4_pgt - __START_KERNEL_map), %rax
+	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
 	movq	%rax, %cr3
 
 	/* Check if nx is implemented */
@@ -274,9 +274,19 @@ ENTRY(name)
 	i = i + 1 ;				\
 	.endr
 
+	/*
+	 * This default setting generates an ident mapping at address 0x100000
+	 * and a mapping for the kernel that precisely maps virtual address
+	 * 0xffffffff80000000 to physical address 0x000000. (always using
+	 * 2Mbyte large pages provided by PAE mode)
+	 */
 NEXT_PAGE(init_level4_pgt)
-	/* This gets initialized in x86_64_start_kernel */
-	.fill	512,8,0
+	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill	257,8,0
+	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill	252,8,0
+	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
+	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
 
 NEXT_PAGE(level3_ident_pgt)
 	.quad	level2_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
@@ -307,27 +317,6 @@ NEXT_PAGE(level2_kernel_pgt)
 #undef NEXT_PAGE
 
 	.data
-
-#ifndef CONFIG_HOTPLUG_CPU
-	__INITDATA
-#endif
-	/*
-	 * This default setting generates an ident mapping at address 0x100000
-	 * and a mapping for the kernel that precisely maps virtual address
-	 * 0xffffffff80000000 to physical address 0x000000. (always using
-	 * 2Mbyte large pages provided by PAE mode)
-	 */
-	.align PAGE_SIZE
-ENTRY(boot_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	257,8,0
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	252,8,0
-	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
-
-	.data
-
 	.align 16
 	.globl cpu_gdt_descr
 cpu_gdt_descr:
Index: linux/arch/x86_64/kernel/setup64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup64.c
+++ linux/arch/x86_64/kernel/setup64.c
@@ -201,7 +201,6 @@ void __cpuinit cpu_init (void)
 	/* CPU 0 is initialised in head64.c */
 	if (cpu != 0) {
 		pda_init(cpu);
-		zap_low_mappings(cpu);
 	} else 
 		estacks = boot_exception_stacks; 
 
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -274,8 +274,6 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
-	zap_low_mappings(0);
-
 #ifdef CONFIG_ACPI
 	/*
 	 * Initialize the ACPI boot-time table parser (gets the RSDP and SDT).
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -378,21 +378,6 @@ void __meminit init_memory_mapping(unsig
 	__flush_tlb_all();
 }
 
-void __cpuinit zap_low_mappings(int cpu)
-{
-	if (cpu == 0) {
-		pgd_t *pgd = pgd_offset_k(0UL);
-		pgd_clear(pgd);
-	} else {
-		/*
-		 * For AP's, zap the low identity mappings by changing the cr3
-		 * to init_level4_pgt and doing local flush tlb all
-		 */
-		asm volatile("movq %0,%%cr3" :: "r" (__pa_symbol(&init_level4_pgt)));
-	}
-	__flush_tlb_all();
-}
-
 #ifndef CONFIG_NUMA
 void __init paging_init(void)
 {
@@ -569,15 +554,6 @@ void __init mem_init(void)
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
-
-#ifdef CONFIG_SMP
-	/*
-	 * Sync boot_level4_pgt mappings with the init_level4_pgt
-	 * except for the low identity mappings which are already zapped
-	 * in init_level4_pgt. This sync-up is essential for AP's bringup
-	 */
-	memcpy(boot_level4_pgt+1, init_level4_pgt+1, (PTRS_PER_PGD-1)*sizeof(pgd_t));
-#endif
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -17,7 +17,6 @@ extern pud_t level3_kernel_pgt[512];
 extern pud_t level3_ident_pgt[512];
 extern pmd_t level2_kernel_pgt[512];
 extern pgd_t init_level4_pgt[];
-extern pgd_t boot_level4_pgt[];
 extern unsigned long __supported_pte_mask;
 
 #define swapper_pg_dir init_level4_pgt
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -11,8 +11,6 @@ struct pt_regs;
 extern void start_kernel(void);
 extern void pda_init(int); 
 
-extern void zap_low_mappings(int cpu);
-
 extern void early_idt_handler(void);
 
 extern void mcheck_init(struct cpuinfo_x86 *c);
