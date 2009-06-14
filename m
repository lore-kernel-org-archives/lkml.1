Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbZFNMFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbZFNMFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbZFNMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52696 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823AbZFNMBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:42 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 16/17] Blackfin: convert page/tlb to asm-generic
Date: Sun, 14 Jun 2009 08:01:17 -0400
Message-Id: <1244980878-2124-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/io.h       |    1 -
 arch/blackfin/include/asm/page.h     |   85 +---------------------------------
 arch/blackfin/include/asm/tlbflush.h |   57 +----------------------
 arch/blackfin/include/asm/ucontext.h |   18 +-------
 4 files changed, 4 insertions(+), 157 deletions(-)

diff --git a/arch/blackfin/include/asm/io.h b/arch/blackfin/include/asm/io.h
index 3022b5c..37053ec 100644
--- a/arch/blackfin/include/asm/io.h
+++ b/arch/blackfin/include/asm/io.h
@@ -222,7 +222,6 @@ extern void blkfin_inv_cache_all(void);
 #define	ioport_unmap(addr)
 
 /* Pages to physical address... */
-#define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
 
 #define phys_to_virt(vaddr)	((void *) (vaddr))
diff --git a/arch/blackfin/include/asm/page.h b/arch/blackfin/include/asm/page.h
index 3ea2016..29dcf75 100644
--- a/arch/blackfin/include/asm/page.h
+++ b/arch/blackfin/include/asm/page.h
@@ -1,88 +1,7 @@
 #ifndef _BLACKFIN_PAGE_H
 #define _BLACKFIN_PAGE_H
 
-/* PAGE_SHIFT determines the page size */
+#include <asm-generic/page.h>
+#define MAP_NR(addr) (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT)
 
-#define PAGE_SHIFT	12
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #endif
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-
-#include <asm/setup.h>
-
-#ifndef __ASSEMBLY__
-
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)
-
-#define clear_page(page)	memset((page), 0, PAGE_SIZE)
-#define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
-
-#define clear_user_page(page, vaddr,pg)	clear_page(page)
-#define copy_user_page(to, from, vaddr,pg)	copy_page(to, from)
-
-/*
- * These are used to make use of C type-checking..
- */
-typedef struct {
-	unsigned long pte;
-} pte_t;
-typedef struct {
-	unsigned long pmd[16];
-} pmd_t;
-typedef struct {
-	unsigned long pgd;
-} pgd_t;
-typedef struct {
-	unsigned long pgprot;
-} pgprot_t;
-typedef struct page *pgtable_t;
-
-#define pte_val(x)	((x).pte)
-#define pmd_val(x)	((&x)->pmd[0])
-#define pgd_val(x)	((x).pgd)
-#define pgprot_val(x)	((x).pgprot)
-
-#define __pte(x)	((pte_t) { (x) } )
-#define __pmd(x)	((pmd_t) { (x) } )
-#define __pgd(x)	((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
-
-extern unsigned long memory_start;
-extern unsigned long memory_end;
-
-#endif				/* !__ASSEMBLY__ */
-
-#include <asm/page_offset.h>
-#include <asm/io.h>
-
-#define PAGE_OFFSET		(PAGE_OFFSET_RAW)
-
-#ifndef __ASSEMBLY__
-
-#define __pa(vaddr)		virt_to_phys((void *)(vaddr))
-#define __va(paddr)		phys_to_virt((unsigned long)(paddr))
-
-#define MAP_NR(addr)		(((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT)
-
-#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
-#define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
-#define page_to_virt(page)	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
-#define VALID_PAGE(page)	((page - mem_map) < max_mapnr)
-
-#define pfn_to_page(pfn)	virt_to_page(pfn_to_virt(pfn))
-#define page_to_pfn(page)	virt_to_pfn(page_to_virt(page))
-#define pfn_valid(pfn)	        ((pfn) < max_mapnr)
-
-#define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
-				((void *)(kaddr) < (void *)memory_end))
-
-#include <asm-generic/getorder.h>
-
-#endif				/* __ASSEMBLY__ */
-
-#endif				/* _BLACKFIN_PAGE_H */
diff --git a/arch/blackfin/include/asm/tlbflush.h b/arch/blackfin/include/asm/tlbflush.h
index 277b400..f1a06c0 100644
--- a/arch/blackfin/include/asm/tlbflush.h
+++ b/arch/blackfin/include/asm/tlbflush.h
@@ -1,56 +1 @@
-#ifndef _BLACKFIN_TLBFLUSH_H
-#define _BLACKFIN_TLBFLUSH_H
-
-/*
- * Copyright (C) 2000 Lineo, David McCullough <davidm@uclinux.org>
- * Copyright (C) 2000-2002, Greg Ungerer <gerg@snapgear.com>
- */
-
-#include <asm/setup.h>
-
-/*
- * flush all user-space atc entries.
- */
-static inline void __flush_tlb(void)
-{
-	BUG();
-}
-
-static inline void __flush_tlb_one(unsigned long addr)
-{
-	BUG();
-}
-
-#define flush_tlb() __flush_tlb()
-
-/*
- * flush all atc entries (both kernel and user-space entries).
- */
-static inline void flush_tlb_all(void)
-{
-	BUG();
-}
-
-static inline void flush_tlb_mm(struct mm_struct *mm)
-{
-	BUG();
-}
-
-static inline void flush_tlb_page(struct vm_area_struct *vma,
-				  unsigned long addr)
-{
-	BUG();
-}
-
-static inline void flush_tlb_range(struct mm_struct *mm,
-				   unsigned long start, unsigned long end)
-{
-	BUG();
-}
-
-static inline void flush_tlb_kernel_page(unsigned long addr)
-{
-	BUG();
-}
-
-#endif
+#include <asm-generic/tlbflush.h>
diff --git a/arch/blackfin/include/asm/ucontext.h b/arch/blackfin/include/asm/ucontext.h
index 4a4e385..9bc07b9 100644
--- a/arch/blackfin/include/asm/ucontext.h
+++ b/arch/blackfin/include/asm/ucontext.h
@@ -1,17 +1 @@
-/** Changes made by Tony Kou   Lineo Inc.    May 2001
- *
- *  Based on: include/m68knommu/ucontext.h
- */
-
-#ifndef _BLACKFIN_UCONTEXT_H
-#define _BLACKFIN_UCONTEXT_H
-
-struct ucontext {
-	unsigned long uc_flags;	/* the others are necessary */
-	struct ucontext *uc_link;
-	stack_t uc_stack;
-	struct sigcontext uc_mcontext;
-	sigset_t uc_sigmask;	/* mask last for extensibility */
-};
-
-#endif				/* _BLACKFIN_UCONTEXT_H */
+#include <asm-generic/ucontext.h>
-- 
1.6.3.1

