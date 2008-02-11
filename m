Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYBKJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYBKJwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYBKJu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:27 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28223 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYBKJuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:25 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/8] CPA: Add statistics about state of direct mapping
Message-Id: <20080211095023.7F93F1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:23 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:44:02.0344 (UTC) FILETIME=[A243DA80:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add information about the mapping state of the direct mapping to /proc/meminfo.

This way we can see how many large pages are really used for it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c     |    2 ++
 arch/x86/mm/init_64.c     |    2 ++
 arch/x86/mm/pageattr.c    |   21 +++++++++++++++++++++
 fs/proc/proc_misc.c       |    7 +++++++
 include/asm-x86/pgtable.h |    3 +++
 5 files changed, 35 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -306,6 +306,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
+		dpages_cnt[PG_LEVEL_2M]++;
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
@@ -351,6 +352,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		}
 
 		if (direct_gbpages) {
+			dpages_cnt[PG_LEVEL_1G]++;
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			true_end = (addr & PUD_MASK) + PUD_SIZE;
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -18,6 +18,8 @@
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 
+unsigned long dpages_cnt[PG_LEVEL_NUM];
+
 /*
  * The current flushing context - we pass it instead of 5 arguments:
  */
@@ -516,6 +518,11 @@ static int split_large_page(pte_t *kpte,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
+	if (address >= __va(0) && address < __va(end_pfn_map)) {
+		dpages_cnt[level]--;
+		dpages_cnt[level - 1] += PTRS_PER_PTE;
+	}
+
 	/*
 	 * Install the new, split up pagetable. Important details here:
 	 *
@@ -961,6 +968,22 @@ __initcall(debug_pagealloc_proc_init);
 
 #endif
 
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
@@ -192,6 +192,7 @@ static void __init kernel_physical_mappi
 				    is_kernel_text(addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
+				dpages_cnt[PG_LEVEL_2M]++;
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
@@ -208,6 +209,7 @@ static void __init kernel_physical_mappi
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
@@ -122,6 +122,11 @@ static int uptime_read_proc(char *page, 
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
@@ -218,6 +223,8 @@ static int meminfo_read_proc(char *page,
 
 		len += hugetlb_report_meminfo(page + len);
 
+	len += arch_report_meminfo(page + len);
+
 	return proc_calc_metrics(page, start, off, count, eof, len);
 #undef K
 }
