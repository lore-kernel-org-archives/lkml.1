Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZEMXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZEMXCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761908AbZEMW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:57:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760857AbZEMW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 13/15] asm-generic: add generic NOMMU versions of some headers
Date: Wed, 13 May 2009 22:56:36 +0000
Message-Id: <1242255398-23779-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Mio7US3YFbrVwzflnvA3ywiGdl64oIfEul/l
 PWFv7NJSyA0Hz/aO0PmXBIAb3c5NeWfQ3U+A9EMiAtxmmNK0P3
 xUFM2UiKZkn5MWaFgMd0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory management in generic is highly architecture specific,
but on NOMMU architectures, it is mostly trivial, so just
add a default implementation in asm-generic that applies
to all NOMMU architectures.

The two files cache.h and cacheflush.h can possibly also
be used by architectures that have an MMU but never require
flushing the cache or have cache lines larger than 32 bytes.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/cache.h       |   12 +++++
 include/asm-generic/cacheflush.h  |   30 +++++++++++
 include/asm-generic/mmu.h         |   15 ++++++
 include/asm-generic/mmu_context.h |   45 +++++++++++++++++
 include/asm-generic/page.h        |   99 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/pgalloc.h     |   12 +++++
 include/asm-generic/segment.h     |    9 +++
 include/asm-generic/tlbflush.h    |   18 +++++++
 8 files changed, 240 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/page.h
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/tlbflush.h

diff --git a/include/asm-generic/cache.h b/include/asm-generic/cache.h
new file mode 100644
index 0000000..1bfcfe5
--- /dev/null
+++ b/include/asm-generic/cache.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_CACHE_H
+#define __ASM_GENERIC_CACHE_H
+/*
+ * 32 bytes appears to be the most common cache line size,
+ * so make that the default here. Architectures with larger
+ * cache lines need to provide their own cache.h.
+ */
+
+#define L1_CACHE_SHIFT		5
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#endif /* __ASM_GENERIC_CACHE_H */
diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
new file mode 100644
index 0000000..ba4ec39
--- /dev/null
+++ b/include/asm-generic/cacheflush.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_CACHEFLUSH_H
+#define __ASM_CACHEFLUSH_H
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/*
+ * The cache doesn't need to be flushed when TLB entries change when
+ * the cache is mapped to physical memory, not virtual memory
+ */
+#define flush_cache_all()			do { } while (0)
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	do { } while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define flush_dcache_page(page)			do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+#define flush_icache_range(start, end)		do { } while (0)
+#define flush_icache_page(vma,pg)		do { } while (0)
+#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#endif /* __ASM_CACHEFLUSH_H */
diff --git a/include/asm-generic/mmu.h b/include/asm-generic/mmu.h
new file mode 100644
index 0000000..4f4aa56
--- /dev/null
+++ b/include/asm-generic/mmu.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_GENERIC_MMU_H
+#define __ASM_GENERIC_MMU_H
+
+/*
+ * This is the mmu.h header for nommu implementations.
+ * Architectures with an MMU need something more complex.
+ */
+#ifndef __ASSEMBLY__
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+#endif
+
+#endif /* __ASM_GENERIC_MMU_H */
diff --git a/include/asm-generic/mmu_context.h b/include/asm-generic/mmu_context.h
new file mode 100644
index 0000000..a7eec91
--- /dev/null
+++ b/include/asm-generic/mmu_context.h
@@ -0,0 +1,45 @@
+#ifndef __ASM_GENERIC_MMU_CONTEXT_H
+#define __ASM_GENERIC_MMU_CONTEXT_H
+
+/*
+ * Generic hooks for NOMMU architectures, which do not need to do
+ * anything special here.
+ */
+
+#include <asm-generic/mm_hooks.h>
+
+struct task_struct;
+struct mm_struct;
+
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+			struct task_struct *tsk)
+{
+}
+
+static inline int init_new_context(struct task_struct *tsk,
+			struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+}
+
+static inline void deactivate_mm(struct task_struct *task,
+			struct mm_struct *mm)
+{
+}
+
+static inline void switch_mm(struct mm_struct *prev,
+			struct mm_struct *next,
+			struct task_struct *tsk)
+{
+}
+
+static inline void activate_mm(struct mm_struct *prev_mm,
+			       struct mm_struct *next_mm)
+{
+}
+
+#endif /* __ASM_GENERIC_MMU_CONTEXT_H */
diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
new file mode 100644
index 0000000..75fec18
--- /dev/null
+++ b/include/asm-generic/page.h
@@ -0,0 +1,99 @@
+#ifndef __ASM_GENERIC_PAGE_H
+#define __ASM_GENERIC_PAGE_H
+/*
+ * Generic page.h implementation, for NOMMU architectures.
+ * This provides the dummy definitions for the memory management.
+ */
+
+#ifdef CONFIG_MMU
+#error need to prove a real asm/page.h
+#endif
+
+
+/* PAGE_SHIFT determines the page size */
+
+#define PAGE_SHIFT	12
+#ifdef __ASSEMBLY__
+#define PAGE_SIZE	(1 << PAGE_SHIFT)
+#else
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#endif
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)	free_page(addr)
+
+#define clear_page(page)	memset((page), 0, PAGE_SIZE)
+#define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(page, vaddr, pg)	clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct {
+	unsigned long pte;
+} pte_t;
+typedef struct {
+	unsigned long pmd[16];
+} pmd_t;
+typedef struct {
+	unsigned long pgd;
+} pgd_t;
+typedef struct {
+	unsigned long pgprot;
+} pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((&x)->pmd[0])
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pmd(x)	((pmd_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+extern unsigned long memory_start;
+extern unsigned long memory_end;
+
+#endif /* !__ASSEMBLY__ */
+
+#ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
+#define PAGE_OFFSET		(CONFIG_KERNEL_RAM_BASE_ADDRESS)
+#else
+#define PAGE_OFFSET		(0)
+#endif
+
+#ifndef __ASSEMBLY__
+
+#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
+#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
+
+#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
+#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
+
+#define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
+#define page_to_virt(page)	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+
+#ifndef page_to_phys
+#define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
+#endif
+
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+
+#define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
+				((void *)(kaddr) < (void *)memory_end))
+
+#endif /* __ASSEMBLY__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* __ASM_GENERIC_PAGE_H */
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
new file mode 100644
index 0000000..9e429d0
--- /dev/null
+++ b/include/asm-generic/pgalloc.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_PGALLOC_H
+#define __ASM_GENERIC_PGALLOC_H
+/*
+ * an empty file is enough for a nommu architecture
+ */
+#ifdef CONFIG_MMU
+#error need to implement an architecture specific asm/pgalloc.h
+#endif
+
+#define check_pgt_cache()          do { } while (0)
+
+#endif /* __ASM_GENERIC_PGALLOC_H */
diff --git a/include/asm-generic/segment.h b/include/asm-generic/segment.h
new file mode 100644
index 0000000..5580eac
--- /dev/null
+++ b/include/asm-generic/segment.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_SEGMENT_H
+#define __ASM_GENERIC_SEGMENT_H
+/*
+ * Only here because we have some old header files that expect it...
+ *
+ * New architectures probably don't want to have their own version.
+ */
+
+#endif /* __ASM_GENERIC_SEGMENT_H */
diff --git a/include/asm-generic/tlbflush.h b/include/asm-generic/tlbflush.h
new file mode 100644
index 0000000..c7af037
--- /dev/null
+++ b/include/asm-generic/tlbflush.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_GENERIC_TLBFLUSH_H
+#define __ASM_GENERIC_TLBFLUSH_H
+/*
+ * This is a dummy tlbflush implementation that can be used on all
+ * nommu architectures.
+ * If you have an MMU, you need to write your own functions.
+ */
+#ifdef CONFIG_MMU
+#error need to implement an architecture specific asm/tlbflush.h
+#endif
+
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+	BUG();
+}
+
+
+#endif /* __ASM_GENERIC_TLBFLUSH_H */
-- 
1.6.0.4

