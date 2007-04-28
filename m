Return-Path: <linux-kernel-owner+w=401wt.eu-S1163345AbXD1R67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163345AbXD1R67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163343AbXD1R66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:58:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:34668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031236AbXD1R6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [2/22] x86_64: Assembly safe page.h and pgtable.h
Message-Id: <20070428175848.9D7FD151EA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


This patch makes pgtable.h and page.h safe to include
in assembly files like head.S.  Allowing us to use
symbolic constants instead of hard coded numbers when
refering to the page tables.

This patch copies asm-sparc64/const.h to asm-x86_64 to
get a definition of _AC() a very convinient macro that
allows us to force the type when we are compiling the
code in C and to drop all of the type information when
we are using the constant in assembly.  Previously this
was done with multiple definition of the same constant.
const.h was modified slightly so that it works when given
CONFIG options as arguments.

This patch adds #ifndef __ASSEMBLY__ ... #endif
and _AC(1,UL) where appropriate so the assembler won't
choke on the header files.  Otherwise nothing
should have changed.

AK: added const.h to exported headers to fix headers_check

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/Kbuild    |    1 +
 include/asm-x86_64/const.h   |   20 ++++++++++++++++++++
 include/asm-x86_64/page.h    |   28 ++++++++++------------------
 include/asm-x86_64/pgtable.h |   33 +++++++++++++++++++++------------
 4 files changed, 52 insertions(+), 30 deletions(-)

Index: linux/include/asm-x86_64/const.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/const.h
@@ -0,0 +1,20 @@
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _X86_64_CONST_H
+#define _X86_64_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specificers unilaterally.  We
+ * use the following macros to deal with this.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#endif
+
+
+#endif /* !(_X86_64_CONST_H) */
Index: linux/include/asm-x86_64/page.h
===================================================================
--- linux.orig/include/asm-x86_64/page.h
+++ linux/include/asm-x86_64/page.h
@@ -1,14 +1,11 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
 
+#include <asm/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(0x1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
 
@@ -33,10 +30,10 @@
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
+#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
 
 #define HPAGE_SHIFT PMD_SHIFT
-#define HPAGE_SIZE	((1UL) << HPAGE_SHIFT)
+#define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
@@ -76,29 +73,24 @@ typedef struct { unsigned long pgprot; }
 #define __pgd(x) ((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-#define __PHYSICAL_START	((unsigned long)CONFIG_PHYSICAL_START)
-#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	0xffffffff80000000UL
-#define __PAGE_OFFSET           0xffff810000000000UL
+#endif /* !__ASSEMBLY__ */
 
-#else
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
-#endif /* !__ASSEMBLY__ */
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
 /* See Documentation/x86_64/mm.txt for a description of the memory map. */
 #define __PHYSICAL_MASK_SHIFT	46
-#define __PHYSICAL_MASK		((1UL << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK_SHIFT	48
-#define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
+#define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
-#define KERNEL_TEXT_SIZE  (40UL*1024*1024)
-#define KERNEL_TEXT_START 0xffffffff80000000UL 
+#define KERNEL_TEXT_SIZE  (40*1024*1024)
+#define KERNEL_TEXT_START 0xffffffff80000000
 
 #ifndef __ASSEMBLY__
 
@@ -106,7 +98,7 @@ typedef struct { unsigned long pgprot; }
 
 #endif /* __ASSEMBLY__ */
 
-#define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
+#define PAGE_OFFSET		__PAGE_OFFSET
 
 /* Note: __pa(&symbol_visible_to_c) should be always replaced with __pa_symbol.
    Otherwise you risk miscompilation. */ 
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -1,6 +1,9 @@
 #ifndef _X86_64_PGTABLE_H
 #define _X86_64_PGTABLE_H
 
+#include <asm/const.h>
+#ifndef __ASSEMBLY__
+
 /*
  * This file contains the functions and defines necessary to modify and use
  * the x86-64 page table tree.
@@ -30,6 +33,8 @@ extern void clear_kernel_mapping(unsigne
 extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
+#endif /* !__ASSEMBLY__ */
+
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
  */
@@ -54,6 +59,8 @@ extern unsigned long empty_zero_page[PAG
  */
 #define PTRS_PER_PTE	512
 
+#ifndef __ASSEMBLY__
+
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
 #define pmd_ERROR(e) \
@@ -117,22 +124,23 @@ static inline pte_t ptep_get_and_clear_f
 
 #define pte_pgprot(a)	(__pgprot((a).pte & ~PHYSICAL_PAGE_MASK))
 
-#define PMD_SIZE	(1UL << PMD_SHIFT)
+#endif /* !__ASSEMBLY__ */
+
+#define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
-#define PUD_SIZE	(1UL << PUD_SHIFT)
+#define PUD_SIZE	(_AC(1,UL) << PUD_SHIFT)
 #define PUD_MASK	(~(PUD_SIZE-1))
-#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
-#ifndef __ASSEMBLY__
-#define MAXMEM		 0x3fffffffffffUL
-#define VMALLOC_START    0xffffc20000000000UL
-#define VMALLOC_END      0xffffe1ffffffffffUL
-#define MODULES_VADDR    0xffffffff88000000UL
-#define MODULES_END      0xfffffffffff00000UL
+#define MAXMEM		 0x3fffffffffff
+#define VMALLOC_START    0xffffc20000000000
+#define VMALLOC_END      0xffffe1ffffffffff
+#define MODULES_VADDR    0xffffffff88000000
+#define MODULES_END      0xfffffffffff00000
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #define _PAGE_BIT_PRESENT	0
@@ -158,7 +166,7 @@ static inline pte_t ptep_get_and_clear_f
 #define _PAGE_GLOBAL	0x100	/* Global TLB entry */
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
-#define _PAGE_NX        (1UL<<_PAGE_BIT_NX)
+#define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
@@ -220,6 +228,8 @@ static inline pte_t ptep_get_and_clear_f
 #define __S110	PAGE_SHARED_EXEC
 #define __S111	PAGE_SHARED_EXEC
 
+#ifndef __ASSEMBLY__
+
 static inline unsigned long pgd_bad(pgd_t pgd)
 {
 	return pgd_val(pgd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
@@ -405,8 +415,6 @@ extern spinlock_t pgd_lock;
 extern struct page *pgd_list;
 void vmalloc_sync_all(void);
 
-#endif /* !__ASSEMBLY__ */
-
 extern int kern_addr_valid(unsigned long addr); 
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
@@ -436,5 +444,6 @@ extern int kern_addr_valid(unsigned long
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
 #include <asm-generic/pgtable.h>
+#endif /* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PGTABLE_H */
Index: linux/include/asm-x86_64/Kbuild
===================================================================
--- linux.orig/include/asm-x86_64/Kbuild
+++ linux/include/asm-x86_64/Kbuild
@@ -18,3 +18,4 @@ header-y += vsyscall32.h
 unifdef-y += mce.h
 unifdef-y += mtrr.h
 unifdef-y += vsyscall.h
+unifdef-y += const.h
