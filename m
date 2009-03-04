Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZCDUCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZCDUCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZCDUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:02:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:33013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757760AbZCDUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:02:13 -0500
Date: Wed, 4 Mar 2009 20:00:39 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49AE48B4.8010907@kernel.org>
References: <49AE48B4.8010907@kernel.org>
Subject: [tip:x86/mm] x86: make 32-bit init_memory_mapping range change more like 64-bit
Message-ID: <tip-b68adb16f29c8ea02f21f5ebf65bcabffe217e9f@git.kernel.org>
Git-Commit-ID: b68adb16f29c8ea02f21f5ebf65bcabffe217e9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 20:00:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b68adb16f29c8ea02f21f5ebf65bcabffe217e9f
Gitweb:     http://git.kernel.org/tip/b68adb16f29c8ea02f21f5ebf65bcabffe217e9f
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 01:24:04 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:55:03 +0100

x86: make 32-bit init_memory_mapping range change more like 64-bit

Impact: cleanup

make code more readable and more like 64-bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AE48B4.8010907@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |  126 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 94 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 67bdb59..37aeaf3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -885,29 +885,55 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 		(table_start << PAGE_SHIFT) + tables);
 }
 
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+#define NR_RANGE_MR 3
+
+static int save_mr(struct map_range *mr, int nr_range,
+		   unsigned long start_pfn, unsigned long end_pfn,
+		   unsigned long page_size_mask)
+{
+	if (start_pfn < end_pfn) {
+		if (nr_range >= NR_RANGE_MR)
+			panic("run out of range for init_memory_mapping\n");
+		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
+		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
+		mr[nr_range].page_size_mask = page_size_mask;
+		nr_range++;
+	}
+
+	return nr_range;
+}
+
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 						unsigned long end)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
+	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
-	unsigned long big_page_start;
+	unsigned long pos;
+
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range, i;
+	int use_pse;
+
+	printk(KERN_INFO "init_memory_mapping: %08lx-%08lx\n", start, end);
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
 	 * large pages into small in interrupt context, etc.
 	 */
-	int use_pse = 0;
+	use_pse = 0;
 #else
-	int use_pse = cpu_has_pse;
+	use_pse = cpu_has_pse;
 #endif
 
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 */
-	if (!after_init_bootmem)
-		find_early_table_space(end, use_pse);
-
 #ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
@@ -924,45 +950,81 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+
+	if (use_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
 	 * because there are often fixed size MTRRs in there
 	 * and overlapping MTRRs into large pages can cause
 	 * slowdowns.
 	 */
-	big_page_start = PMD_SIZE;
-
-	if (start < big_page_start) {
-		start_pfn = start >> PAGE_SHIFT;
-		end_pfn = min(big_page_start>>PAGE_SHIFT, end>>PAGE_SHIFT);
-	} else {
-		/* head is not big page alignment ? */
-		start_pfn = start >> PAGE_SHIFT;
-		end_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+	/* head could not be big page alignment ? */
+	start_pfn = start >> PAGE_SHIFT;
+	pos = start_pfn << PAGE_SHIFT;
+	if (pos == 0)
+		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+	else
+		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 				 << (PMD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > (end>>PAGE_SHIFT))
+		end_pfn = end>>PAGE_SHIFT;
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+		pos = end_pfn << PAGE_SHIFT;
 	}
-	if (start_pfn < end_pfn)
-		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn, 0);
 
 	/* big page range */
-	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < (big_page_start >> PAGE_SHIFT))
-		start_pfn =  big_page_start >> PAGE_SHIFT;
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn)
-		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
-					     use_pse);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* tail is not big page alignment ? */
-	start_pfn = end_pfn;
-	if (start_pfn > (big_page_start>>PAGE_SHIFT)) {
-		end_pfn = end >> PAGE_SHIFT;
-		if (start_pfn < end_pfn)
-			kernel_physical_mapping_init(pgd_base, start_pfn,
-							 end_pfn, 0);
+	start_pfn = pos>>PAGE_SHIFT;
+	end_pfn = end>>PAGE_SHIFT;
+	if (start_pfn < end_pfn)
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+
+	/* try to merge same page size and continuous */
+	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
+		unsigned long old_start;
+		if (mr[i].end != mr[i+1].start ||
+		    mr[i].page_size_mask != mr[i+1].page_size_mask)
+			continue;
+		/* move it */
+		old_start = mr[i].start;
+		memmove(&mr[i], &mr[i+1],
+			(nr_range - 1 - i) * sizeof(struct map_range));
+		mr[i--].start = old_start;
+		nr_range--;
 	}
 
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG " %08lx - %08lx page %s\n",
+			mr[i].start, mr[i].end,
+			(mr[i].page_size_mask & (1<<PG_LEVEL_2M)) ?
+				  "big page" : "4k");
+
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 */
+	if (!after_init_bootmem)
+		find_early_table_space(end, use_pse);
+
+	for (i = 0; i < nr_range; i++)
+		kernel_physical_mapping_init(pgd_base,
+				mr[i].start >> PAGE_SHIFT,
+				mr[i].end >> PAGE_SHIFT,
+				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
+
 	early_ioremap_page_table_range_init(pgd_base);
 
 	load_cr3(swapper_pg_dir);
