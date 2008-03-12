Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYCLCzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYCLCzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYCLCxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:25937 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYCLCxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:35 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080312353.598285931@firstfloor.org>
In-Reply-To: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [7/7] CPA: Add statistics about state of direct mapping v2
Message-Id: <20080312025333.BAF5F1B41D1@basil.firstfloor.org>
Date: Wed, 12 Mar 2008 03:53:33 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:47:01.0645 (UTC) FILETIME=[5928ABD0:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add information about the mapping state of the direct mapping to 
/proc/meminfo.

This way we can see how many large pages are really used for it and how
many are split.

Useful for debugging and general insight into the kernel.

v2: Add hotplug locking to 64bit to plug a very obscure theoretical race. 
    32bit doesn't need it because it doesn't support hotadd for lowmem.
    Fix some typos

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c     |    2 ++
 arch/x86/mm/init_64.c     |    2 ++
 arch/x86/mm/pageattr.c    |   24 ++++++++++++++++++++++++
 fs/proc/proc_misc.c       |    7 +++++++
 include/asm-x86/pgtable.h |    3 +++
 5 files changed, 38 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -319,6 +319,8 @@ __meminit void early_iounmap(void *addr,
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
+	unsigned long flags;
+	unsigned pages = 0;
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
@@ -335,9 +337,15 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
+		pages++;
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
+
+	/* Protect against CPA */
+	spin_lock_irqsave(&pgd_lock, flags);
+	dpages_cnt[PG_LEVEL_2M] += pages;
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	return address;
 }
 
@@ -356,6 +364,8 @@ phys_pmd_update(pud_t *pud, unsigned lon
 static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 {
+	unsigned long flags;
+	unsigned pages = 0;
 	unsigned long true_end = end;
 	int i = pud_index(addr);
 
@@ -380,6 +390,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		}
 
 		if (direct_gbpages) {
+			dpages_cnt[PG_LEVEL_1G]++;
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			true_end = (addr & PUD_MASK) + PUD_SIZE;
@@ -397,6 +408,11 @@ phys_pud_init(pud_t *pud_page, unsigned 
 	}
 	__flush_tlb_all();
 
+	/* Protect against CPA */
+	spin_lock_irqsave(&pgd_lock, flags);
+	dpages_cnt[PG_LEVEL_1G] += pages;
+	spin_unlock_irqrestore(&pgd_lock, flags);
+
 	return true_end >> PAGE_SHIFT;
 }
 
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -18,6 +18,8 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 
+unsigned long dpages_cnt[PG_LEVEL_NUM];
+
 /*
  * The current flushing context - we pass it instead of 5 arguments:
  */
@@ -499,6 +501,12 @@ static int split_large_page(pte_t *kpte,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
+	if (address >= (unsigned long)__va(0) &&
+		address < (unsigned long)__va(end_pfn_map << PAGE_SHIFT)) {
+		dpages_cnt[level]--;
+		dpages_cnt[level - 1] += PTRS_PER_PTE;
+	}
+
 	/*
 	 * Install the new, split up pagetable. Important details here:
 	 *
@@ -948,6 +956,22 @@ bool kernel_page_present(struct page *pa
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#ifdef CONFIG_PROC_FS
+int arch_report_meminfo(char *page)
+{
+	int n;
+	n = sprintf(page, "DirectMap4k:  %8lu\n"
+			  "DirectMap2M:  %8lu\n",
+			dpages_cnt[PG_LEVEL_4K],
+			dpages_cnt[PG_LEVEL_2M]);
+#ifdef CONFIG_X86_64
+	n += sprintf(page + n, "DirectMap1G:  %8lu\n",
+			dpages_cnt[PG_LEVEL_1G]);
+#endif
+	return n;
+}
+#endif
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -247,8 +247,11 @@ enum {
 	PG_LEVEL_4K,
 	PG_LEVEL_2M,
 	PG_LEVEL_1G,
+	PG_LEVEL_NUM
 };
 
+extern unsigned long dpages_cnt[PG_LEVEL_NUM];
+
 /*
  * Helper function that returns the kernel pagetable entry controlling
  * the virtual address 'address'. NULL means no pagetable entry present.
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -198,6 +198,7 @@ static void __init kernel_physical_mappi
 				    is_kernel_text(addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
+				dpages_cnt[PG_LEVEL_2M]++;
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
@@ -214,6 +215,7 @@ static void __init kernel_physical_mappi
 				if (is_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
+				dpages_cnt[PG_LEVEL_4K]++;
 				set_pte(pte, pfn_pte(pfn, prot));
 			}
 			end_pfn_map = pfn;
Index: linux/fs/proc/proc_misc.c
===================================================================
--- linux.orig/fs/proc/proc_misc.c
+++ linux/fs/proc/proc_misc.c
@@ -123,6 +123,11 @@ static int uptime_read_proc(char *page, 
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
+int __attribute__((weak)) arch_report_meminfo(char *page)
+{
+	return 0;
+}
+
 static int meminfo_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
 {
@@ -219,6 +224,8 @@ static int meminfo_read_proc(char *page,
 
 		len += hugetlb_report_meminfo(page + len);
 
+	len += arch_report_meminfo(page + len);
+
 	return proc_calc_metrics(page, start, off, count, eof, len);
 #undef K
 }
