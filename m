Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYADFmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYADFmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYADFjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:39 -0500
Received: from gw.goop.org ([64.81.55.164]:48768 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYADFjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:36 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 8] x86: page.h: move things back to their own files
X-Mercurial-Node: 22f6a5902285b58bfc1fbbd9e183498c9017bd78
Message-Id: <22f6a5902285b58bfc1f.1199391064@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:04 -0800
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
# Date 1199321648 28800
# Node ID 22f6a5902285b58bfc1fbbd9e183498c9017bd78
# Parent  bba9287641ff90e836d090d80b5c0a846aab7162
x86: page.h: move things back to their own files

Oops, asm/page.h has turned into an #ifdef hellhole.  Move
32/64-specific things back to their own headers to make it somewhat
comprehensible...

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |  212 +--------------------------------------------
 include/asm-x86/page_32.h |  123 +++++++++++++++++++++++---
 include/asm-x86/page_64.h |   74 ++++++++++++++-
 3 files changed, 187 insertions(+), 222 deletions(-)

diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -15,8 +15,7 @@ unifdef-y += mce.h
 unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
-unifdef-y += page_32.h
-unifdef-y += page_64.h
+unifdef-y += page.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -7,6 +7,8 @@
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
 
 #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
 #define PTE_MASK		PHYSICAL_PAGE_MASK
@@ -30,207 +32,10 @@
 #endif
 
 #ifdef CONFIG_X86_64
-#define PAGETABLE_LEVELS	4
-
-#define THREAD_ORDER	1
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
-#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
-
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
-
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
-#define __PHYSICAL_MASK_SHIFT	46
-#define __VIRTUAL_MASK_SHIFT	48
-
-#define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
-
-#ifndef __ASSEMBLY__
-void clear_page(void *page);
-void copy_page(void *to, void *from);
-
-extern unsigned long end_pfn;
-extern unsigned long end_pfn_map;
-extern unsigned long phys_base;
-
-extern unsigned long __phys_addr(unsigned long);
-#define __phys_reloc_hide(x)	(x)
-
-/*
- * These are used to make use of C type-checking..
- */
-typedef unsigned long	pteval_t;
-typedef unsigned long	pmdval_t;
-typedef unsigned long	pudval_t;
-typedef unsigned long	pgdval_t;
-typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
-
-typedef struct { pteval_t pte; } pte_t;
-
-#define native_pte_val(x)	((x).pte)
-#define native_make_pte(x) ((pte_t) { (x) } )
-
-#define vmemmap ((struct page *)VMEMMAP_START)
-
-#endif	/* !__ASSEMBLY__ */
-
+#include <asm/page_64.h>
+#else
+#include <asm/page_32.h>
 #endif	/* CONFIG_X86_64 */
-
-#ifdef CONFIG_X86_32
-
-/*
- * This handles the memory map.
- *
- * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
- * a virtual address space of one gigabyte, which limits the
- * amount of physical memory you can use to about 950MB.
- *
- * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
- * and CONFIG_HIGHMEM64G options in the kernel configuration.
- */
-#define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
-
-#ifdef CONFIG_X86_PAE
-#define __PHYSICAL_MASK_SHIFT	36
-#define __VIRTUAL_MASK_SHIFT	32
-#define PAGETABLE_LEVELS	3
-
-#ifndef __ASSEMBLY__
-typedef u64	pteval_t;
-typedef u64	pmdval_t;
-typedef u64	pudval_t;
-typedef u64	pgdval_t;
-typedef u64	pgprotval_t;
-typedef u64	phys_addr_t;
-
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
-
-static inline unsigned long long native_pte_val(pte_t pte)
-{
-	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
-}
-
-static inline pte_t native_make_pte(unsigned long long val)
-{
-	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
-}
-
-#endif	/* __ASSEMBLY__
- */
-#else  /* !CONFIG_X86_PAE */
-#define __PHYSICAL_MASK_SHIFT	32
-#define __VIRTUAL_MASK_SHIFT	32
-#define PAGETABLE_LEVELS	2
-
-#ifndef __ASSEMBLY__
-typedef unsigned long	pteval_t;
-typedef unsigned long	pmdval_t;
-typedef unsigned long	pudval_t;
-typedef unsigned long	pgdval_t;
-typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
-
-typedef struct { pteval_t pte_low; } pte_t;
-typedef pte_t boot_pte_t;
-
-static inline unsigned long native_pte_val(pte_t pte)
-{
-	return pte.pte_low;
-}
-
-static inline pte_t native_make_pte(unsigned long val)
-{
-	return (pte_t) { .pte_low = val };
-}
-
-#endif	/* __ASSEMBLY__ */
-#endif	/* CONFIG_X86_PAE */
-
-#ifdef CONFIG_HUGETLB_PAGE
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
-
-#ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x)-PAGE_OFFSET)
-#define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
-
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif /* CONFIG_FLATMEM */
-
-extern int nx_enabled;
-
-/*
- * This much address space is reserved for vmalloc() and iomap()
- * as well as fixmap mappings.
- */
-extern unsigned int __VMALLOC_RESERVE;
-extern int sysctl_legacy_va_layout;
-extern int page_is_ram(unsigned long pagenr);
-
-#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
-
-#ifdef CONFIG_X86_USE_3DNOW
-#include <asm/mmx.h>
-
-static inline void clear_page(void *page)
-{
-	mmx_clear_page(page);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	mmx_copy_page(to, from);
-}
-#else  /* !CONFIG_X86_USE_3DNOW */
-#include <linux/string.h>
-
-static inline void clear_page(void *page)
-{
-	memset(page, 0, PAGE_SIZE);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	memcpy(to, from, PAGE_SIZE);
-}
-#endif	/* CONFIG_X86_3DNOW */
-#endif	/* !__ASSEMBLY__ */
-
-#endif	/* CONFIG_X86_32 */
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 
@@ -349,10 +154,5 @@ static inline pmdval_t native_pmd_val(pm
 
 #define __HAVE_ARCH_GATE_AREA 1
 
-#ifdef CONFIG_X86_32
-# include "page_32.h"
-#else
-# include "page_64.h"
-#endif
-
+#endif	/* __KERNEL__ */
 #endif	/* _ASM_X86_PAGE_H */
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -1,23 +1,124 @@
-#ifndef _I386_PAGE_H
-#define _I386_PAGE_H
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
+#ifndef _ASM_X86_PAGE_32_H
+#define _ASM_X86_PAGE_32_H
 
 /*
- * These are used to make use of C type-checking..
+ * This handles the memory map.
+ *
+ * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
+ * a virtual address space of one gigabyte, which limits the
+ * amount of physical memory you can use to about 950MB.
+ *
+ * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
+ * and CONFIG_HIGHMEM64G options in the kernel configuration.
  */
+#define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
-#endif /* !__ASSEMBLY__ */
+#ifdef CONFIG_X86_PAE
+#define __PHYSICAL_MASK_SHIFT	36
+#define __VIRTUAL_MASK_SHIFT	32
+#define PAGETABLE_LEVELS	3
 
 #ifndef __ASSEMBLY__
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
+typedef u64	pgprotval_t;
+typedef u64	phys_addr_t;
 
-struct vm_area_struct;
+typedef struct { unsigned long pte_low, pte_high; } pte_t;
 
-#endif /* __ASSEMBLY__ */
+static inline unsigned long long native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
 
+static inline pte_t native_make_pte(unsigned long long val)
+{
+	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
+}
 
+#endif	/* __ASSEMBLY__
+ */
+#else  /* !CONFIG_X86_PAE */
+#define __PHYSICAL_MASK_SHIFT	32
+#define __VIRTUAL_MASK_SHIFT	32
+#define PAGETABLE_LEVELS	2
 
-#endif /* __KERNEL__ */
+#ifndef __ASSEMBLY__
+typedef unsigned long	pteval_t;
+typedef unsigned long	pmdval_t;
+typedef unsigned long	pudval_t;
+typedef unsigned long	pgdval_t;
+typedef unsigned long	pgprotval_t;
+typedef unsigned long	phys_addr_t;
 
-#endif /* _I386_PAGE_H */
+typedef struct { pteval_t pte_low; } pte_t;
+typedef pte_t boot_pte_t;
+
+static inline unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+static inline pte_t native_make_pte(unsigned long val)
+{
+	return (pte_t) { .pte_low = val };
+}
+
+#endif	/* __ASSEMBLY__ */
+#endif	/* CONFIG_X86_PAE */
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#endif
+
+#ifndef __ASSEMBLY__
+#define __phys_addr(x)		((x)-PAGE_OFFSET)
+#define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
+
+#ifdef CONFIG_FLATMEM
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+#endif /* CONFIG_FLATMEM */
+
+extern int nx_enabled;
+
+/*
+ * This much address space is reserved for vmalloc() and iomap()
+ * as well as fixmap mappings.
+ */
+extern unsigned int __VMALLOC_RESERVE;
+extern int sysctl_legacy_va_layout;
+extern int page_is_ram(unsigned long pagenr);
+
+#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
+#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
+
+#ifdef CONFIG_X86_USE_3DNOW
+#include <asm/mmx.h>
+
+static inline void clear_page(void *page)
+{
+	mmx_clear_page(page);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	mmx_copy_page(to, from);
+}
+#else  /* !CONFIG_X86_USE_3DNOW */
+#include <linux/string.h>
+
+static inline void clear_page(void *page)
+{
+	memset(page, 0, PAGE_SIZE);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	memcpy(to, from, PAGE_SIZE);
+}
+#endif	/* CONFIG_X86_3DNOW */
+#endif	/* !__ASSEMBLY__ */
+
+#endif /* _ASM_X86_PAGE_32_H */
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -1,16 +1,80 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
 
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
+#define PAGETABLE_LEVELS	4
 
-#endif /* !__ASSEMBLY__ */
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
 
 #ifndef __ASSEMBLY__
+void clear_page(void *page);
+void copy_page(void *to, void *from);
 
+extern unsigned long end_pfn;
+extern unsigned long end_pfn_map;
+extern unsigned long phys_base;
 
-#endif /* __ASSEMBLY__ */
+extern unsigned long __phys_addr(unsigned long);
+#define __phys_reloc_hide(x)	(x)
 
-#endif /* __KERNEL__ */
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef unsigned long	pteval_t;
+typedef unsigned long	pmdval_t;
+typedef unsigned long	pudval_t;
+typedef unsigned long	pgdval_t;
+typedef unsigned long	pgprotval_t;
+typedef unsigned long	phys_addr_t;
+
+typedef struct { pteval_t pte; } pte_t;
+
+#define native_pte_val(x)	((x).pte)
+#define native_make_pte(x) ((pte_t) { (x) } )
+
+#define vmemmap ((struct page *)VMEMMAP_START)
+
+#endif	/* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PAGE_H */


