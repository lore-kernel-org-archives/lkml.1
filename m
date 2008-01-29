Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYA2FIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYA2FIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYA2FGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:35 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:61553 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYA2FGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:34 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/9] GBPAGES: Split LARGE_PAGE_SIZE/MASK into PUD_PAGE_SIZE/PMD_PAGE_SIZE
Message-Id: <20080129050631.A60EE1B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:31 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:15.0377 (UTC) FILETIME=[D6082010:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Split the existing LARGE_PAGE_SIZE/MASK macro into two new macros
PUD_PAGE_SIZE/MASK and PMD_PAGE_SIZE/MASK. 

Fix up all callers to use the new names.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/boot/compressed/head_64.S |    8 ++++----
 arch/x86/kernel/head_64.S          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    2 +-
 arch/x86/mm/init_64.c              |    6 +++---
 arch/x86/mm/pageattr.c             |    2 +-
 include/asm-x86/page.h             |    4 ++--
 include/asm-x86/page_32.h          |    4 ++++
 include/asm-x86/page_64.h          |    3 +++
 8 files changed, 20 insertions(+), 13 deletions(-)

Index: linux/include/asm-x86/page_64.h
===================================================================
--- linux.orig/include/asm-x86/page_64.h
+++ linux/include/asm-x86/page_64.h
@@ -23,6 +23,9 @@
 #define MCE_STACK 5
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
+#define PUD_PAGE_SIZE (_AC(1, UL) << PUD_SHIFT)
+#define PUD_PAGE_MASK (~(PUD_PAGE_SIZE-1))
+
 #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
Index: linux/arch/x86/boot/compressed/head_64.S
===================================================================
--- linux.orig/arch/x86/boot/compressed/head_64.S
+++ linux/arch/x86/boot/compressed/head_64.S
@@ -80,8 +80,8 @@ startup_32:
 
 #ifdef CONFIG_RELOCATABLE
 	movl	%ebp, %ebx
-	addl	$(LARGE_PAGE_SIZE -1), %ebx
-	andl	$LARGE_PAGE_MASK, %ebx
+	addl	$(PMD_PAGE_SIZE -1), %ebx
+	andl	$PMD_PAGE_MASK, %ebx
 #else
 	movl	$CONFIG_PHYSICAL_START, %ebx
 #endif
@@ -220,8 +220,8 @@ ENTRY(startup_64)
 	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
-	addq	$(LARGE_PAGE_SIZE - 1), %rbp
-	andq	$LARGE_PAGE_MASK, %rbp
+	addq	$(PMD_PAGE_SIZE - 1), %rbp
+	andq	$PMD_PAGE_MASK, %rbp
 	movq	%rbp, %rbx
 #else
 	movq	$CONFIG_PHYSICAL_START, %rbp
Index: linux/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux.orig/arch/x86/kernel/pci-gart_64.c
+++ linux/arch/x86/kernel/pci-gart_64.c
@@ -501,7 +501,7 @@ static __init unsigned long check_iommu_
 	}
 
 	a = aper + iommu_size;
-	iommu_size -= round_up(a, LARGE_PAGE_SIZE) - a;
+	iommu_size -= round_up(a, PMD_PAGE_SIZE) - a;
 
 	if (iommu_size < 64*1024*1024) {
 		printk(KERN_WARNING
Index: linux/arch/x86/kernel/head_64.S
===================================================================
--- linux.orig/arch/x86/kernel/head_64.S
+++ linux/arch/x86/kernel/head_64.S
@@ -63,7 +63,7 @@ startup_64:
 
 	/* Is the address not 2M aligned? */
 	movq	%rbp, %rax
-	andl	$~LARGE_PAGE_MASK, %eax
+	andl	$~PMD_PAGE_MASK, %eax
 	testl	%eax, %eax
 	jnz	bad_address
 
@@ -88,7 +88,7 @@ startup_64:
 
 	/* Add an Identity mapping if I am above 1G */
 	leaq	_text(%rip), %rdi
-	andq	$LARGE_PAGE_MASK, %rdi
+	andq	$PMD_PAGE_MASK, %rdi
 
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -443,10 +443,10 @@ __clear_kernel_mapping(unsigned long add
 {
 	unsigned long end = address + size;
 
-	BUG_ON(address & ~LARGE_PAGE_MASK);
-	BUG_ON(size & ~LARGE_PAGE_MASK);
+	BUG_ON(address & ~PMD_PAGE_MASK);
+	BUG_ON(size & ~PMD_PAGE_MASK);
 
-	for (; address < end; address += LARGE_PAGE_SIZE) {
+	for (; address < end; address += PMD_PAGE_SIZE) {
 		pgd_t *pgd = pgd_offset_k(address);
 		pud_t *pud;
 		pmd_t *pmd;
Index: linux/include/asm-x86/page_32.h
===================================================================
--- linux.orig/include/asm-x86/page_32.h
+++ linux/include/asm-x86/page_32.h
@@ -13,6 +13,10 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
+/* Eventually 32bit should be moved over to the new names too */
+#define LARGE_PAGE_SIZE PMD_PAGE_SIZE
+#define LARGE_PAGE_MASK PMD_PAGE_MASK
+
 #ifdef CONFIG_X86_PAE
 #define __PHYSICAL_MASK_SHIFT	36
 #define __VIRTUAL_MASK_SHIFT	32
Index: linux/include/asm-x86/page.h
===================================================================
--- linux.orig/include/asm-x86/page.h
+++ linux/include/asm-x86/page.h
@@ -13,8 +13,8 @@
 #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
 #define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))
 
-#define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
-#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
+#define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
+#define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
 
 #define HPAGE_SHIFT		PMD_SHIFT
 #define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -218,7 +218,7 @@ static int split_large_page(pte_t *kpte,
 	}
 
 	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK;
+	addr = address & PMD_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
 #ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
