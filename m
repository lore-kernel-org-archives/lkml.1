Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZCENnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZCENnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZCENjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:39:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:50049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbZCENjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:39:07 -0500
Date: Thu, 5 Mar 2009 13:38:36 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-15-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-15-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: fix up some bad global variable names in mm/init.c
Message-ID: <tip-298af9d89f3f5292e81a0a00f729c415adc4d8fb@git.kernel.org>
Git-Commit-ID: 298af9d89f3f5292e81a0a00f729c415adc4d8fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:38:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  298af9d89f3f5292e81a0a00f729c415adc4d8fb
Gitweb:     http://git.kernel.org/tip/298af9d89f3f5292e81a0a00f729c415adc4d8fb
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:06 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:17 +0100

x86: fix up some bad global variable names in mm/init.c

Impact: cleanup

The table_start, table_end, and table_top are too generic for global
namespace so rename them to be more specific.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-15-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c    |   26 +++++++++++++-------------
 arch/x86/mm/init_32.c |   14 +++++++-------
 arch/x86/mm/init_64.c |   10 +++++-----
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3a21b13..5bbdfe7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -23,9 +23,9 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long page_size_mask);
 #endif
 
-unsigned long __initdata table_start;
-unsigned long __meminitdata table_end;
-unsigned long __meminitdata table_top;
+unsigned long __initdata e820_table_start;
+unsigned long __meminitdata e820_table_end;
+unsigned long __meminitdata e820_table_top;
 
 int after_bootmem;
 
@@ -78,21 +78,21 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
-	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
 					tables, PAGE_SIZE);
 #else /* CONFIG_X86_64 */
 	start = 0x8000;
-	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 #endif
-	if (table_start == -1UL)
+	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
-	table_start >>= PAGE_SHIFT;
-	table_end = table_start;
-	table_top = table_start + (tables >> PAGE_SHIFT);
+	e820_table_start >>= PAGE_SHIFT;
+	e820_table_end = e820_table_start;
+	e820_table_top = e820_table_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
+		end, e820_table_start << PAGE_SHIFT, e820_table_top << PAGE_SHIFT);
 }
 
 struct map_range {
@@ -324,9 +324,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 #endif
 	__flush_tlb_all();
 
-	if (!after_bootmem && table_end > table_start)
-		reserve_early(table_start << PAGE_SHIFT,
-				 table_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem && e820_table_end > e820_table_start)
+		reserve_early(e820_table_start << PAGE_SHIFT,
+				 e820_table_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 187522a..e9df0d9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -59,16 +59,16 @@ unsigned long highstart_pfn, highend_pfn;
 static noinline int do_test_wp_bit(void);
 
 
-extern unsigned long __initdata table_start;
-extern unsigned long __meminitdata table_end;
-extern unsigned long __meminitdata table_top;
+extern unsigned long __initdata e820_table_start;
+extern unsigned long __meminitdata e820_table_end;
+extern unsigned long __meminitdata e820_table_top;
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = table_end++;
+	unsigned long pfn = e820_table_end++;
 	void *adr;
 
-	if (pfn >= table_top)
+	if (pfn >= e820_table_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
@@ -149,8 +149,8 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
 	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
 	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
-	    && ((__pa(pte) >> PAGE_SHIFT) < table_start
-		|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
+	    && ((__pa(pte) >> PAGE_SHIFT) < e820_table_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= e820_table_end)) {
 		pte_t *newpte;
 		int i;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a32fe07..a1d33c5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -283,13 +283,13 @@ void __init cleanup_highmap(void)
 	}
 }
 
-extern unsigned long __initdata table_start;
-extern unsigned long __meminitdata table_end;
-extern unsigned long __meminitdata table_top;
+extern unsigned long __initdata e820_table_start;
+extern unsigned long __meminitdata e820_table_end;
+extern unsigned long __meminitdata e820_table_top;
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = table_end++;
+	unsigned long pfn = e820_table_end++;
 	void *adr;
 
 	if (after_bootmem) {
@@ -299,7 +299,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= table_top)
+	if (pfn >= e820_table_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
