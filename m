Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbYF0Whu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbYF0Whu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYF0WhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:37:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:24617 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbYF0WhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CiFu88SoEF43LuM9YbFAAdigAzxCIf3A0QGfO9AkewA0p+k//dwK1024w2M+5nkedO
         oq71mJpI2xzJAOmoQKJmgpOhfkOcR0hL8aXWSoRrDOYX5lgjkFK2jGhv/WSjm58h03HR
         Sa/kyVrzUlGCUXJ5ERQwWQJZASYeH2xq3Ddp4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix init_memory_mapping over boundary
Date: Fri, 27 Jun 2008 15:38:46 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com>
In-Reply-To: <200806252151.29028.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271538.46829.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some end boundary is only page alignment, instead of 2M alignment,
so call ker_phycial_mapping_init three times.
then don't overmap above the max_low_pfn

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_32.c |   74 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 24 deletions(-)

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
@@ -193,32 +194,30 @@ static void __init kernel_physical_mappi
 	pmd_t *pmd;
 	pte_t *pte;
 	unsigned pages_2m = 0, pages_4k = 0;
-	unsigned limit_pfn = end >> PAGE_SHIFT;
 
-	pgd_idx = pgd_index(PAGE_OFFSET);
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
+
+		if (pfn >= end_pfn)
 			continue;
 
-		for (pmd_idx = 0;
-		     pmd_idx < PTRS_PER_PMD && pfn < limit_pfn;
+		pmd_idx = pmd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
+		pmd += pmd_idx;
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
-			if (cpu_has_pse && !(pgd_idx == 0 && pmd_idx == 0)) {
+			if (use_pse) {
 				unsigned int addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 
@@ -233,13 +232,12 @@ static void __init kernel_physical_mappi
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
-				max_pfn_mapped = pfn;
 				continue;
 			}
 			pte = one_page_table_init(pmd);
 
 			for (pte_ofs = 0;
-			     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
+			     pte_ofs < PTRS_PER_PTE && pfn < end_pfn;
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
 
@@ -249,7 +247,6 @@ static void __init kernel_physical_mappi
 				pages_4k++;
 				set_pte(pte, pfn_pte(pfn, prot));
 			}
-			max_pfn_mapped = pfn;
 		}
 	}
 	update_page_count(PG_LEVEL_2M, pages_2m);
@@ -729,7 +726,7 @@ void __init setup_bootmem_allocator(void
 
 static void __init find_early_table_space(unsigned long end)
 {
-	unsigned long puds, pmds, tables, start;
+	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = PAGE_ALIGN(puds * sizeof(pud_t));
@@ -737,10 +734,15 @@ static void __init find_early_table_spac
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
 
-	if (!cpu_has_pse) {
-		int ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		tables += PAGE_ALIGN(ptes * sizeof(pte_t));
-	}
+	if (cpu_has_pse) {
+		int extra;
+		extra = end - ((end>>21) << 21);
+		extra += (2<<20);
+		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	} else
+		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
@@ -766,6 +768,7 @@ unsigned long __init_refok init_memory_m
 						unsigned long end)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
+	unsigned long start_pfn, end_pfn;
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -790,7 +793,30 @@ unsigned long __init_refok init_memory_m
 		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
 	}
 
-	kernel_physical_mapping_init(pgd_base, start, end);
+	/*
+	 * Don't use a large page for the first 2/4MB of memory
+	 * because there are often fixed size MTRRs in there
+	 * and overlapping MTRRs into large pages can cause
+	 * slowdowns.
+	 */
+	if (start < (2<<20)) {
+		start_pfn = start >> PAGE_SHIFT;
+		end_pfn = min(2UL<<(20 - PAGE_SHIFT), end>>PAGE_SHIFT);
+		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn, 0);
+	}
+
+	if (end >= (2<<20)) {
+		start_pfn = 2 << (20 - PAGE_SHIFT);
+		end_pfn = (end >> 21) << (21 - PAGE_SHIFT);
+		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
+						cpu_has_pse);
+
+		start_pfn = end_pfn;
+		end_pfn = end >> PAGE_SHIFT;
+		if (end_pfn > start_pfn)
+			kernel_physical_mapping_init(pgd_base, start_pfn,
+							end_pfn, 0);
+	}
 
 	early_ioremap_page_table_range_init(pgd_base);
 
