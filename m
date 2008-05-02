Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbYEBJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbYEBJrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbYEBJrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:47:09 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35870 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbYEBJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:47:05 -0400
Date: Fri, 2 May 2008 11:46:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] CPA: Add statistics about state of direct mapping v4
Message-ID: <20080502094649.GA11185@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 May 2008 09:39:55.0663 (UTC) FILETIME=[7AB111F0:01C8AC38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposted several times, all feedback incorporated, still missing in git. -AK]

---

CPA: Add statistics about state of direct mapping v4

Add information about the mapping state of the direct mapping to 
/proc/meminfo. I chose /proc/meminfo because that is where all the other
memory statistics are too and it is a generally useful metric even
outside debugging situations. A lot of split kernel pages means the 
kernel will run slower.

This way we can see how many large pages are really used for it and how
many are split.

Useful for general insight into the kernel.

v2: Add hotplug locking to 64bit to plug a very obscure theoretical race. 
    32bit doesn't need it because it doesn't support hotadd for lowmem.
    Fix some typos
v3: Rename dpages_cnt
    Add CONFIG ifdef for count update as requested by tglx
    Expand description
v4: Fix stupid bugs added in v3
    Move update_page_count to pageattr.c

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>

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
@@ -312,6 +312,8 @@ __meminit void early_iounmap(void *addr,
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
+	unsigned long pages = 0;
+
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
@@ -328,9 +330,11 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
+		pages++;
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
+	update_page_count(PG_LEVEL_2M, pages);
 	return address;
 }
 
@@ -350,6 +354,7 @@ phys_pmd_update(pud_t *pud, unsigned lon
 static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 {
+	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
 	int i = pud_index(addr);
 
@@ -374,6 +379,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		}
 
 		if (direct_gbpages) {
+			pages++;
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
@@ -390,6 +396,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		unmap_low_page(pmd);
 	}
 	__flush_tlb_all();
+	update_page_count(PG_LEVEL_1G, pages);
 
 	return last_map_addr >> PAGE_SHIFT;
 }
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -34,6 +34,19 @@ struct cpa_data {
 	unsigned	force_split : 1;
 };
 
+static unsigned long direct_pages_count[PG_LEVEL_NUM];
+
+void __meminit update_page_count(int level, unsigned long pages)
+{
+#ifdef CONFIG_PROC_FS
+	unsigned long flags;
+	/* Protect against CPA */
+	spin_lock_irqsave(&pgd_lock, flags);
+	direct_pages_count[level] += pages;
+	spin_unlock_irqrestore(&pgd_lock, flags);
+#endif
+}
+
 #ifdef CONFIG_X86_64
 
 static inline unsigned long highmap_start_pfn(void)
@@ -500,6 +513,12 @@ static int split_large_page(pte_t *kpte,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
+	if (address >= (unsigned long)__va(0) &&
+		address < (unsigned long)__va(max_pfn_mapped << PAGE_SHIFT)) {
+		direct_pages_count[level]--;
+		direct_pages_count[level - 1] += PTRS_PER_PTE;
+	}
+
 	/*
 	 * Install the new, split up pagetable. Important details here:
 	 *
@@ -1029,6 +1048,22 @@ bool kernel_page_present(struct page *pa
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#ifdef CONFIG_PROC_FS
+int arch_report_meminfo(char *page)
+{
+	int n;
+	n = sprintf(page, "DirectMap4k:  %8lu\n"
+			  "DirectMap2M:  %8lu\n",
+			direct_pages_count[PG_LEVEL_4K],
+			direct_pages_count[PG_LEVEL_2M]);
+#ifdef CONFIG_X86_64
+	n += sprintf(page + n, "DirectMap1G:  %8lu\n",
+			direct_pages_count[PG_LEVEL_1G]);
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
@@ -358,8 +358,11 @@ enum {
 	PG_LEVEL_4K,
 	PG_LEVEL_2M,
 	PG_LEVEL_1G,
+	PG_LEVEL_NUM
 };
 
+void update_page_count(int level, unsigned long pages);
+
 /*
  * Helper function that returns the kernel pagetable entry controlling
  * the virtual address 'address'. NULL means no pagetable entry present.
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -162,6 +162,7 @@ static void __init kernel_physical_mappi
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned pages_2m = 0, pages_4k = 0;
 
 	pgd_idx = pgd_index(PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
@@ -197,6 +198,7 @@ static void __init kernel_physical_mappi
 				    is_kernel_text(addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
+				pages_2m++;
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
@@ -213,11 +215,14 @@ static void __init kernel_physical_mappi
 				if (is_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
+				pages_4k++;
 				set_pte(pte, pfn_pte(pfn, prot));
 			}
 			max_pfn_mapped = pfn;
 		}
 	}
+	update_page_count(PG_LEVEL_2M, pages_2m);
+	update_page_count(PG_LEVEL_4K, pages_4k);
 }
 
 static inline int page_kills_ppro(unsigned long pagenr)
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
@@ -221,6 +226,8 @@ static int meminfo_read_proc(char *page,
 
 		len += hugetlb_report_meminfo(page + len);
 
+	len += arch_report_meminfo(page + len);
+
 	return proc_calc_metrics(page, start, off, count, eof, len);
 #undef K
 }
