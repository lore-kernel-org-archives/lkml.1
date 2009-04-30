Return-Path: <linux-kernel-owner+w=401wt.eu-S1765679AbZD3TGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765679AbZD3TGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764745AbZD3TDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:03:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764403AbZD3TC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:59 -0400
Message-Id: <20090430185717.842190075@arndb.de>
References: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:37 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH v2 9/9] asm-generic: add generic NOMMU versions of some headers
Content-Disposition: inline; filename=0009-asm-generic-add-generic-NOMMU-versions-of-some-head.patch
X-Provags-ID: V01U2FsdGVkX1+5yMVBVGcevF3WunCUmD+ObysvpO1gBDhOuUF
 EixnmkEXnYOASXeSF0k05I1uQRFp0RDcnRKhi9mwUZz9zVgWvD
 WH/BiDEqApdyv57v81VaQ==
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
 include/asm-generic/cache.h       |   12 ++
 include/asm-generic/cacheflush.h  |   30 +++++
 include/asm-generic/mmu.h         |   14 +++
 include/asm-generic/mmu_context.h |   45 +++++++
 include/asm-generic/page.h        |   99 ++++++++++++++++
 include/asm-generic/pgalloc.h     |   12 ++
 include/asm-generic/segment.h     |    9 ++
 include/asm-generic/tlbflush.h    |   18 +++
 include/asm-generic/uaccess.h     |  235 +++++++++++++++++++++++++++++++++++++
 9 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/page.h
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/tlbflush.h
 create mode 100644 include/asm-generic/uaccess.h

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
index 0000000..eb34fb0
--- /dev/null
+++ b/include/asm-generic/mmu.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_GENERIC_MMU_H
+#define __ASM_GENERIC_MMU_H
+
+/*
+ * This is the mmu.h header for nommu implementations.
+ * Architectures with an MMU need something more complex.
+ */
+
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
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
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
new file mode 100644
index 0000000..e05f6a9
--- /dev/null
+++ b/include/asm-generic/uaccess.h
@@ -0,0 +1,235 @@
+#ifndef __ASM_GENERIC_UACCESS_H
+#define __ASM_GENERIC_UACCESS_H
+
+/*
+ * User space memory access functions, these should work
+ * on a ny machine that has kernel and user data in the same
+ * address space, e.g. all NOMMU machines.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <asm/segment.h>
+
+#ifndef get_fs
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+#define KERNEL_DS	MAKE_MM_SEG(~0UL)
+#define USER_DS		MAKE_MM_SEG(TASK_SIZE - 1)
+
+#define get_ds() (KERNEL_DS)
+#define get_fs() (current_thread_info()->addr_limit)
+
+static inline void set_fs(mm_segment_t fs)
+{
+	current_thread_info()->addr_limit = fs;
+}
+#endif
+
+#define segment_eq(a, b) ((a).seg == (b).seg)
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
+
+/*
+ * The architecture should really override this if possible, at least
+ * doing a check on the get_fs()
+ */
+#ifndef __access_ok
+static inline int __access_ok(unsigned long addr, unsigned long size)
+{
+	return 1;
+}
+#endif
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern unsigned long search_exception_table(unsigned long);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ */
+#ifndef __put_user
+#define __put_user(x, ptr)				\
+({							\
+	int __pu_err = 0;				\
+	typeof(*(ptr)) __pu_val = (x);			\
+	switch (sizeof (*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+		*(ptr) = (__pu_val);			\
+		break;					\
+	case 8:						\
+		memcpy(ptr, &__pu_val, sizeof (*(ptr)));\
+		break;					\
+	default:					\
+		__pu_err = __put_user_bad();		\
+		break;					\
+	}						\
+	__pu_err;					\
+})
+extern int __put_user_bad(void);
+#endif
+
+#define put_user(x, ptr) (				\
+	__access_ok(ptr, sizeof (*ptr)) ?		\
+		__put_user(x, ptr) :			\
+		-EFAULT)
+
+#ifndef __get_user
+#define __get_user(x, ptr)				\
+({							\
+	int __gu_err = 0;				\
+	unsigned long __gu_val = (unsigned long)*ptr;	\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+	case 8:						\
+		break;					\
+	default:					\
+		__gu_err = __get_user_bad();		\
+		__gu_val = 0;				\
+		break;					\
+	}						\
+	(x) = (typeof(*ptr))__gu_val;			\
+	__gu_err;					\
+})
+extern int __get_user_bad(void);
+#endif
+
+#define get_user(x, ptr) (				\
+	__access_ok(ptr, sizeof (*ptr)) ?		\
+		__get_user(x, ptr) :			\
+		-EFAULT)
+
+#ifndef __copy_from_user
+static inline __must_check long __copy_from_user(void *to,
+		const void __user *from, unsigned long n)
+{
+	memcpy(to, (const void __force *)from, n);
+	return 0;
+}
+#endif
+
+#ifndef __copy_to_user
+static inline __must_check long __copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	memcpy((void __force *)to, from, n);
+	return 0;
+}
+#endif
+
+#ifndef __copy_from_user_inatomic
+#define __copy_from_user_inatomic __copy_from_user
+#endif
+
+#ifndef __copy_to_user_inatomic
+#define __copy_to_user_inatomic __copy_to_user
+#endif
+
+static inline long copy_from_user(void *to,
+		const void __user * from, unsigned long n)
+{
+	might_sleep();
+	if (__access_ok(from, n))
+		return __copy_from_user(to, from, n);
+	else
+		return n;
+}
+
+static inline long copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	might_sleep();
+	if (__access_ok(to, n))
+		return __copy_to_user(to, from, n);
+	else
+		return n;
+}
+
+/*
+ * Copy a null terminated string from userspace.
+ */
+#ifndef __strncpy_from_user
+static inline long
+__strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	char *tmp;
+	strncpy(dst, src, count);
+	for (tmp = dst; *tmp && count > 0; tmp++, count--)
+		;
+	return (tmp - dst);
+}
+#endif
+
+static inline long
+strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	if (!__access_ok(src, 1))
+		return -EFAULT;
+	return __strncpy_from_user(dst, src, count);
+}
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 on exception, a value greater than N if too long
+ */
+#ifndef strnlen_user
+static inline long strnlen_user(const char __user *src, long n)
+{
+	return strlen((void * __force)src) + 1;
+}
+#endif
+
+static inline long strlen_user(const char __user *src)
+{
+	return strnlen_user(src, 32767);
+}
+
+/*
+ * Zero Userspace
+ */
+#ifndef __clear_user
+static inline __must_check unsigned long
+__clear_user(void __user *to, unsigned long n)
+{
+	memset((void __force *)to, 0, n);
+	return 0;
+}
+#endif
+
+static inline __must_check unsigned long
+clear_user(void __user *to, unsigned long n)
+{
+	might_sleep();
+	if (!__access_ok(to, n))
+		return n;
+
+	return __clear_user(to, n);
+}
+
+#endif /* __ASM_GENERIC_UACCESS_H */
-- 
1.5.6.3

-- 

