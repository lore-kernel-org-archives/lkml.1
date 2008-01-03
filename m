Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYADFkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYADFkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYADFjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:35 -0500
Received: from gw.goop.org ([64.81.55.164]:48760 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYADFjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 8] x86: page.h: unify constants
X-Mercurial-Node: ba0ec40a50a7aef1a3153cea124c35e261f5a2df
Message-Id: <ba0ec40a50a7aef1a315.1199391058@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:10:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Jeremy Fitzhardinge <jeremy@xensource.com>
# Date 1199317360 28800
# Node ID ba0ec40a50a7aef1a3153cea124c35e261f5a2df
# Parent  c45c263179cb78284b6b869c574457df088027d1
x86: page.h: unify constants

There are many constants which are shared by 32 and 64-bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |  130 +++++++++++++++++++++++++++++++++++++++++----
 include/asm-x86/page_32.h |   46 ---------------
 include/asm-x86/page_64.h |   73 -------------------------
 3 files changed, 119 insertions(+), 130 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -1,13 +1,116 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+#ifndef _ASM_X86_PAGE_H
+#define _ASM_X86_PAGE_H
+
+#include <linux/const.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	12
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
+
+#define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
+#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
+
+#define HPAGE_SHIFT		PMD_SHIFT
+#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
+#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
+#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
+
+#define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
+#define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
+
+
+#ifdef CONFIG_X86_64
+#define THREAD_ORDER	1
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define CURRENT_MASK (~(THREAD_SIZE-1))
+
+#define EXCEPTION_STACK_ORDER 0
+#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
+
+#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
+#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
+
+#define IRQSTACK_ORDER 2
+#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
+
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
+
+#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
+
+#define __PHYSICAL_START	CONFIG_PHYSICAL_START
+#define __KERNEL_ALIGN		0x200000
+
+/*
+ * Make sure kernel is aligned to 2MB address. Catching it at compile
+ * time is better. Change your config file and compile the kernel
+ * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+ */
+#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
+#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
+#endif
+
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+
+/* See Documentation/x86_64/mm.txt for a description of the memory map. */
+#define __PHYSICAL_MASK_SHIFT	46
+#define __VIRTUAL_MASK_SHIFT	48
+
+#define KERNEL_TEXT_SIZE  (40*1024*1024)
+#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
+
+#endif	/* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
+
+/*
+ * This handles the memory map.
+ *
+ * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
+ * a virtual address space of one gigabyte, which limits the
+ * amount of physical memory you can use to about 950MB.
+ *
+ * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
+ * and CONFIG_HIGHMEM64G options in the kernel configuration.
+ */
+#define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
+
+#ifdef CONFIG_X86_PAE
+#define __PHYSICAL_MASK_SHIFT	36
+#define __VIRTUAL_MASK_SHIFT	32
+#else  /* !CONFIG_X86_PAE */
+#define __PHYSICAL_MASK_SHIFT	32
+#define __VIRTUAL_MASK_SHIFT	32
+#endif	/* CONFIG_X86_PAE */
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#endif
+
+#endif	/* CONFIG_X86_32 */
+
+#define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+
+#ifdef CONFIG_X86_32
+# include "page_32.h"
 #else
-# ifdef __i386__
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+# include "page_64.h"
 #endif
+
+#endif	/* _ASM_X86_PAGE_H */
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -1,13 +1,5 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H
-
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
@@ -111,7 +103,6 @@ static inline pte_t native_make_pte(unsi
 #define __pmd(x)	native_make_pmd(x)
 #endif
 
-#define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
 #else  /* !CONFIG_X86_PAE */
 typedef struct { unsigned long pte_low; } pte_t;
@@ -139,18 +130,10 @@ static inline pte_t native_make_pte(unsi
 	return (pte_t) { .pte_low = val };
 }
 
-#define HPAGE_SHIFT	22
 #include <asm-generic/pgtable-nopmd.h>
 #endif	/* CONFIG_X86_PAE */
 
 #define PTE_MASK	PAGE_MASK
-
-#ifdef CONFIG_HUGETLB_PAGE
-#define HPAGE_SIZE	((1UL) << HPAGE_SHIFT)
-#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
-#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
 
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
@@ -163,22 +146,6 @@ static inline pte_t native_make_pte(unsi
 #endif
 
 #endif /* !__ASSEMBLY__ */
-
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-/*
- * This handles the memory map.. We could make this a config
- * option, but too many people screw it up, and too few need
- * it.
- *
- * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
- * a virtual address space of one gigabyte, which limits the
- * amount of physical memory you can use to about 950MB. 
- *
- * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
- * and CONFIG_HIGHMEM64G options in the kernel configuration.
- */
 
 #ifndef __ASSEMBLY__
 
@@ -196,14 +163,6 @@ extern int page_is_ram(unsigned long pag
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef __ASSEMBLY__
-#define __PAGE_OFFSET		CONFIG_PAGE_OFFSET
-#else
-#define __PAGE_OFFSET		((unsigned long)CONFIG_PAGE_OFFSET)
-#endif
-
-
-#define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
 #define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
@@ -219,11 +178,6 @@ extern int page_is_ram(unsigned long pag
 
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -1,41 +1,5 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
-
-#include <linux/const.h>
-
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
-
-#define THREAD_ORDER 1 
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
-#define CURRENT_MASK (~(THREAD_SIZE-1))
-
-#define EXCEPTION_STACK_ORDER 0
-#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
-
-#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
-#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
-
-#define IRQSTACK_ORDER 2
-#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
-
-#define STACKFAULT_STACK 1
-#define DOUBLEFAULT_STACK 2
-#define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
-#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
-
-#define HPAGE_SHIFT PMD_SHIFT
-#define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
-#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
-#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
@@ -90,35 +54,6 @@ extern unsigned long phys_base;
 
 #endif /* !__ASSEMBLY__ */
 
-#define __PHYSICAL_START	CONFIG_PHYSICAL_START
-#define __KERNEL_ALIGN		0x200000
-
-/*
- * Make sure kernel is aligned to 2MB address. Catching it at compile
- * time is better. Change your config file and compile the kernel
- * for a 2MB aligned address (CONFIG_PHYSICAL_START)
- */
-#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
-#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
-#endif
-
-#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
-#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
-
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
-#define __PHYSICAL_MASK_SHIFT	46
-#define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
-#define __VIRTUAL_MASK_SHIFT	48
-#define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
-
-#define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
-#define PAGE_OFFSET		__PAGE_OFFSET
-
 #ifndef __ASSEMBLY__
 
 #include <asm/bug.h>
@@ -138,10 +73,6 @@ extern unsigned long __phys_addr(unsigne
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #define __HAVE_ARCH_GATE_AREA 1	
 #define vmemmap ((struct page *)VMEMMAP_START)
 


