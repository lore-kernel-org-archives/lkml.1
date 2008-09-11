Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYIKVeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYIKVeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYIKVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:14060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYIKVdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="438420520"
Message-Id: <20080911204150.433630000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:49 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/7] x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
Content-Disposition: inline; filename=rename_init_pte_macros.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/head_32.S
===================================================================
--- tip.orig/arch/x86/kernel/head_32.S	2008-09-11 11:13:58.000000000 -0700
+++ tip/arch/x86/kernel/head_32.S	2008-09-11 11:14:20.000000000 -0700
@@ -172,10 +172,6 @@
  *
  * Note that the stack is not yet set up!
  */
-#define PTE_ATTR	0x007		/* PRESENT+RW+USER */
-#define PDE_ATTR	0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
-#define PGD_ATTR	0x001		/* PRESENT (no other attributes) */
-
 default_entry:
 #ifdef CONFIG_X86_PAE
 
@@ -196,9 +192,9 @@
 	movl $pa(pg0), %edi
 	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_pmd), %edx
-	movl $PTE_ATTR, %eax
+	movl $PTE_IDENT_ATTR, %eax
 10:
-	leal PDE_ATTR(%edi),%ecx		/* Create PMD entry */
+	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PMD entry */
 	movl %ecx,(%edx)			/* Store PMD entry */
 						/* Upper half already zero */
 	addl $8,%edx
@@ -215,7 +211,7 @@
 	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
 	 * bytes beyond the end of our own page tables.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
+	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
@@ -224,7 +220,7 @@
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
 	movl %eax,pa(swapper_pg_pmd+0x1000*KPMDS-8)
 #else	/* Not PAE */
 
@@ -233,9 +229,9 @@
 	movl $pa(pg0), %edi
 	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_dir), %edx
-	movl $PTE_ATTR, %eax
+	movl $PTE_IDENT_ATTR, %eax
 10:
-	leal PDE_ATTR(%edi),%ecx		/* Create PDE entry */
+	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PDE entry */
 	movl %ecx,(%edx)			/* Store identity PDE entry */
 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
 	addl $4,%edx
@@ -249,7 +245,7 @@
 	 * bytes beyond the end of our own page tables; the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
+	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
 	movl %edi,pa(init_pg_tables_end)
@@ -257,7 +253,7 @@
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
 	movl %eax,pa(swapper_pg_dir+0xffc)
 #endif
 	jmp 3f
@@ -634,19 +630,19 @@
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0		/* low identity map */
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
 # if KPMDS == 3
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x1000),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x2000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x2000),0
 # elif KPMDS == 2
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x1000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
 # elif KPMDS == 1
 	.long	0,0
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
Index: tip/arch/x86/kernel/head_64.S
===================================================================
--- tip.orig/arch/x86/kernel/head_64.S	2008-09-11 11:13:58.000000000 -0700
+++ tip/arch/x86/kernel/head_64.S	2008-09-11 11:14:20.000000000 -0700
@@ -110,7 +110,7 @@
 	movq	%rdi, %rax
 	shrq	$PMD_SHIFT, %rax
 	andq	$(PTRS_PER_PMD - 1), %rax
-	leaq	__PAGE_KERNEL_LARGE_EXEC(%rdi), %rdx
+	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
 	leaq	level2_spare_pgt(%rip), %rbx
 	movq	%rdx, 0(%rbx, %rax, 8)
 ident_complete:
@@ -374,7 +374,7 @@
 	/* Since I easily can, map the first 1G.
 	 * Don't set NX because code runs from these pages.
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
+	PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
 	/*
Index: tip/include/asm-x86/pgtable.h
===================================================================
--- tip.orig/include/asm-x86/pgtable.h	2008-09-11 11:13:58.000000000 -0700
+++ tip/include/asm-x86/pgtable.h	2008-09-11 11:15:53.000000000 -0700
@@ -132,6 +132,17 @@
 #define __S110	PAGE_SHARED_EXEC
 #define __S111	PAGE_SHARED_EXEC
 
+/*
+ * early identity mapping  pte attrib macros.
+ */
+#ifdef CONFIG_X86_64
+#define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
+#else
+#define PTE_IDENT_ATTR	 0x007		/* PRESENT+RW+USER */
+#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*

-- 

