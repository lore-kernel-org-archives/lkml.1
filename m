Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZHZGlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZHZGlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZHZGlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:41:49 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:57033 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZHZGls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:41:48 -0400
Subject: Subject: [PATCH 07/33] score: create head files cache.h
	cacheflush.h tlb.h tlbflush.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:12:49 +0800
Message-Id: <1251267169.3073.5.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1fd54dc23e1585555fb202ca9d77b3df540aaae7 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:59 +0800
Subject: [PATCH 07/33] score: create head files cache.h cacheflush.h tlb.h tlbflush.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/cache.h      |    7 ++
 arch/score/include/asm/cacheflush.h |   45 +++++++++++
 arch/score/include/asm/tlb.h        |   17 ++++
 arch/score/include/asm/tlbflush.h   |  142 +++++++++++++++++++++++++++++++++++
 4 files changed, 211 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/cache.h
 create mode 100644 arch/score/include/asm/cacheflush.h
 create mode 100644 arch/score/include/asm/tlb.h
 create mode 100644 arch/score/include/asm/tlbflush.h

diff --git a/arch/score/include/asm/cache.h b/arch/score/include/asm/cache.h
new file mode 100644
index 0000000..ae3d59f
--- /dev/null
+++ b/arch/score/include/asm/cache.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_SCORE_CACHE_H
+#define _ASM_SCORE_CACHE_H
+
+#define L1_CACHE_SHIFT		4
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#endif /* _ASM_SCORE_CACHE_H */
diff --git a/arch/score/include/asm/cacheflush.h b/arch/score/include/asm/cacheflush.h
new file mode 100644
index 0000000..07cc8fc
--- /dev/null
+++ b/arch/score/include/asm/cacheflush.h
@@ -0,0 +1,45 @@
+#ifndef _ASM_SCORE_CACHEFLUSH_H
+#define _ASM_SCORE_CACHEFLUSH_H
+
+/* Keep includes the same across arches. */
+#include <linux/mm.h>
+
+extern void flush_cache_all(void);
+extern void flush_cache_mm(struct mm_struct *mm);
+extern void flush_cache_range(struct vm_area_struct *vma,
+				unsigned long start, unsigned long end);
+extern void flush_cache_page(struct vm_area_struct *vma,
+				unsigned long page, unsigned long pfn);
+extern void flush_cache_sigtramp(unsigned long addr);
+extern void flush_icache_all(void);
+extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void flush_dcache_range(unsigned long start, unsigned long end);
+
+#define flush_cache_dup_mm(mm)			do {} while (0)
+#define flush_dcache_page(page)			do {} while (0)
+#define flush_dcache_mmap_lock(mapping)		do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)	do {} while (0)
+#define flush_cache_vmap(start, end)		do {} while (0)
+#define flush_cache_vunmap(start, end)		do {} while (0)
+
+static inline void flush_icache_page(struct vm_area_struct *vma,
+	struct page *page)
+{
+	if (vma->vm_flags & VM_EXEC) {
+		void *v = page_address(page);
+		flush_icache_range((unsigned long) v,
+				(unsigned long) v + PAGE_SIZE);
+	}
+}
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
+	do {							\
+		memcpy(dst, src, len);				\
+		if ((vma->vm_flags & VM_EXEC))			\
+			flush_cache_page(vma, vaddr, page_to_pfn(page));\
+	} while (0)
+
+#endif /* _ASM_SCORE_CACHEFLUSH_H */
diff --git a/arch/score/include/asm/tlb.h b/arch/score/include/asm/tlb.h
new file mode 100644
index 0000000..46882ed
--- /dev/null
+++ b/arch/score/include/asm/tlb.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_SCORE_TLB_H
+#define _ASM_SCORE_TLB_H
+
+/*
+ * SCORE doesn't need any special per-pte or per-vma handling, except
+ * we need to flush cache for area to be unmapped.
+ */
+#define tlb_start_vma(tlb, vma)		do {} while (0)
+#define tlb_end_vma(tlb, vma)		do {} while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do {} while (0)
+#define tlb_flush(tlb)			flush_tlb_mm((tlb)->mm)
+
+extern void score7_FTLB_refill_Handler(void);
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_SCORE_TLB_H */
diff --git a/arch/score/include/asm/tlbflush.h b/arch/score/include/asm/tlbflush.h
new file mode 100644
index 0000000..9cce978
--- /dev/null
+++ b/arch/score/include/asm/tlbflush.h
@@ -0,0 +1,142 @@
+#ifndef _ASM_SCORE_TLBFLUSH_H
+#define _ASM_SCORE_TLBFLUSH_H
+
+#include <linux/mm.h>
+
+/*
+ * TLB flushing:
+ *
+ * - flush_tlb_all() flushes all processes TLB entries
+ * - flush_tlb_mm(mm) flushes the specified mm context TLB entries
+ * - flush_tlb_page(vma, vmaddr) flushes one page
+ * - flush_tlb_range(vma, start, end) flushes a range of pages
+ * - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ */
+extern void local_flush_tlb_all(void);
+extern void local_flush_tlb_mm(struct mm_struct *mm);
+extern void local_flush_tlb_range(struct vm_area_struct *vma,
+	unsigned long start, unsigned long end);
+extern void local_flush_tlb_kernel_range(unsigned long start,
+	unsigned long end);
+extern void local_flush_tlb_page(struct vm_area_struct *vma,
+	unsigned long page);
+extern void local_flush_tlb_one(unsigned long vaddr);
+
+#define flush_tlb_all()			local_flush_tlb_all()
+#define flush_tlb_mm(mm)		local_flush_tlb_mm(mm)
+#define flush_tlb_range(vma, vmaddr, end) \
+	local_flush_tlb_range(vma, vmaddr, end)
+#define flush_tlb_kernel_range(vmaddr, end) \
+	local_flush_tlb_kernel_range(vmaddr, end)
+#define flush_tlb_page(vma, page)	local_flush_tlb_page(vma, page)
+#define flush_tlb_one(vaddr)		local_flush_tlb_one(vaddr)
+
+#ifndef __ASSEMBLY__
+
+static inline unsigned long pevn_get(void)
+{
+	unsigned long val;
+
+	__asm__ __volatile__(
+		"mfcr %0, cr11\n"
+		"nop\nnop\n"
+		: "=r" (val));
+
+	return val;
+}
+
+static inline void pevn_set(unsigned long val)
+{
+	__asm__ __volatile__(
+		"mtcr %0, cr11\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+	: : "r" (val));
+}
+
+static inline void pectx_set(unsigned long val)
+{
+	__asm__ __volatile__(
+		"mtcr %0, cr12\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+	: : "r" (val));
+}
+
+static inline unsigned long pectx_get(void)
+{
+	unsigned long val;
+	__asm__ __volatile__(
+		"mfcr %0, cr12\n"
+		"nop\nnop\n"
+	: "=r" (val));
+	return val;
+}
+static inline unsigned long tlblock_get(void)
+{
+	unsigned long val;
+
+	__asm__ __volatile__(
+		"mfcr %0, cr7\n"
+		"nop\nnop\n"
+	: "=r" (val));
+	return val;
+}
+static inline void tlblock_set(unsigned long val)
+{
+	__asm__ __volatile__(
+		"mtcr %0, cr7\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+	: : "r" (val));
+}
+
+static inline void tlbpt_set(unsigned long val)
+{
+	__asm__ __volatile__(
+		"mtcr %0, cr8\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+		: : "r" (val));
+}
+
+static inline long tlbpt_get(void)
+{
+	long val;
+
+	__asm__ __volatile__(
+		"mfcr %0, cr8\n"
+		"nop\nnop\n"
+		: "=r" (val));
+
+	return val;
+}
+
+static inline void peaddr_set(unsigned long val)
+{
+	__asm__ __volatile__(
+		"mtcr %0, cr9\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+		: : "r" (val));
+}
+
+/* TLB operations. */
+static inline void tlb_probe(void)
+{
+	__asm__ __volatile__("stlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_read(void)
+{
+	__asm__ __volatile__("mftlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_indexed(void)
+{
+	__asm__ __volatile__("mtptlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_random(void)
+{
+	__asm__ __volatile__("mtrtlb;nop;nop;nop;nop;nop");
+}
+
+#endif /* Not __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_TLBFLUSH_H */
-- 
1.6.2



