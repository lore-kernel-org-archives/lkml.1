Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYF2Hhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYF2Hhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYF2Hhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:37:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:18161 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYF2Hhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LTTXYKvrpXMhxb780Snp6PVzJseXM+C6kvAmhAI1x1UOecgH/jjU8WcR+AAlgVEief
         66GPUwKbQNgZLviZTufJbwT6LVKVL/DSArcc3xI0CrTQO4DbMTSJ1WONCAu6vghwYneL
         lgJ3ZRTA3HIsdRBqcXnvCI+WFXogK1lpBHsic=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: fix init_memory_mapping over boundary v4 - diff to v3
Date: Sun, 29 Jun 2008 00:39:06 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <200806281749.02000.yhlu.kernel@gmail.com>
In-Reply-To: <200806281749.02000.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806290039.06761.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some end boundary is only page alignment, instead of 2M alignment,
so call ker_phycial_mapping_init three times.
then don't overmap above the max_low_pfn

v2: make init_memory_mapping more solid: start could be any value other than 0
v3: fix NON PAE by handling left over in kernel_physical_mapping
v4: revert back to v2, and use PMD_SHIFT to calculate boundary
    also adjust size for pre-allocated table size

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_32.c |   89 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -184,8 +184,9 @@ static inline int is_kernel_text(unsigne
  * PAGE_OFFSET:
  */
 static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
-						unsigned long start,
-						unsigned long end)
+						unsigned long start_pfn,
+						unsigned long end_pfn,
+						int use_pse)
 {
 	int pgd_idx, pmd_idx, pte_ofs;
 	unsigned long pfn;
@@ -193,33 +194,33 @@ static void __init kernel_physical_mappi
 	pmd_t *pmd;
 	pte_t *pte;
 	unsigned pages_2m = 0, pages_4k = 0;
-	unsigned limit_pfn = end >> PAGE_SHIFT;
 
-	pgd_idx = pgd_index(start + PAGE_OFFSET);
-	pgd = pgd_base + pgd_idx;
-	pfn = start >> PAGE_SHIFT;
+	if (!cpu_has_pse)
+		use_pse = 0;
 
+	pfn = start_pfn;
+	pgd_idx = pgd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
+	pgd = pgd_base + pgd_idx;
 	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
 		pmd = one_md_table_init(pgd);
-		if (pfn >= limit_pfn)
-			continue;
 
-		for (pmd_idx = 0;
-		     pmd_idx < PTRS_PER_PMD && pfn < limit_pfn;
+		if (pfn >= end_pfn)
+			continue;
+#ifdef CONFIG_X86_PAE
+		pmd_idx = pmd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
+		pmd += pmd_idx;
+#else
+		pmd_idx = 0;
+#endif
+		for (; pmd_idx < PTRS_PER_PMD && pfn < end_pfn;
 		     pmd++, pmd_idx++) {
 			unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
 
 			/*
 			 * Map with big pages if possible, otherwise
 			 * create normal page tables:
-			 *
-			 * Don't use a large page for the first 2/4MB of memory
-			 * because there are often fixed size MTRRs in there
-			 * and overlapping MTRRs into large pages can cause
-			 * slowdowns.
 			 */
-			if (cpu_has_pse && !(pgd_idx == 0 && pmd_idx == 0) &&
-				(pfn + PTRS_PER_PTE) <= limit_pfn) {
+			if (use_pse) {
 				unsigned int addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 
@@ -238,8 +239,9 @@ static void __init kernel_physical_mappi
 			}
 			pte = one_page_table_init(pmd);
 
-			for (pte_ofs = 0;
-			     pte_ofs < PTRS_PER_PTE && pfn < limit_pfn;
+			pte_ofs = pte_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
+			pte += pte_ofs;
+			for (; pte_ofs < PTRS_PER_PTE && pfn < end_pfn;
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
 
@@ -738,14 +740,18 @@ static void __init find_early_table_spac
 
 	if (cpu_has_pse) {
 		unsigned long extra;
-		extra = end - ((end>>21) << 21);
-		extra += (2UL<<20);
+
+		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		extra += PMD_SIZE;
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
+	/* for fixmap */
+	tables += PAGE_SIZE * 2;
+
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables
@@ -770,6 +776,8 @@ unsigned long __init_refok init_memory_m
 						unsigned long end)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
+	unsigned long start_pfn, end_pfn;
+	unsigned long big_page_start;
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -794,7 +802,44 @@ unsigned long __init_refok init_memory_m
 		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
 	}
 
-	kernel_physical_mapping_init(pgd_base, start, end);
+	/*
+	 * Don't use a large page for the first 2/4MB of memory
+	 * because there are often fixed size MTRRs in there
+	 * and overlapping MTRRs into large pages can cause
+	 * slowdowns.
+	 */
+	big_page_start = PMD_SIZE;
+
+	if (start < big_page_start) {
+		start_pfn = start >> PAGE_SHIFT;
+		end_pfn = min(big_page_start>>PAGE_SHIFT, end>>PAGE_SHIFT);
+	} else {
+		/* head is not big page alignment ? */
+		start_pfn = start >> PAGE_SHIFT;
+		end_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+				 << (PMD_SHIFT - PAGE_SHIFT);
+	}
+	if (start_pfn < end_pfn)
+		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn, 0);
+
+	/* big page range */
+	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < (big_page_start >> PAGE_SHIFT))
+		start_pfn =  big_page_start >> PAGE_SHIFT;
+	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn)
+		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
+						cpu_has_pse);
+
+	/* tail is not big page alignment ? */
+	start_pfn = end_pfn;
+	if (start_pfn > (big_page_start>>PAGE_SHIFT)) {
+		end_pfn = end >> PAGE_SHIFT;
+		if (start_pfn < end_pfn)
+			kernel_physical_mapping_init(pgd_base, start_pfn,
+							 end_pfn, 0);
+	}
 
 	early_ioremap_page_table_range_init(pgd_base);
 
