Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZCENhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZCENhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZCENhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:49864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZCENhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:11 -0500
Date: Thu, 5 Mar 2009 13:36:31 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-1-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-1-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: init_memory_mapping() trivial cleanups
Message-ID: <tip-c3f5d2d8b5fa6eb0cc1c47fd162bf6432f206f42@git.kernel.org>
Git-Commit-ID: c3f5d2d8b5fa6eb0cc1c47fd162bf6432f206f42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3f5d2d8b5fa6eb0cc1c47fd162bf6432f206f42
Gitweb:     http://git.kernel.org/tip/c3f5d2d8b5fa6eb0cc1c47fd162bf6432f206f42
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:52 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:10 +0100

x86: init_memory_mapping() trivial cleanups

Impact: cleanup

To reduce the diff between the 32-bit and 64-bit versions of
init_memory_mapping(), fix up all trivial issues.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   42 +++++++++++++++++++++++++-----------------
 arch/x86/mm/init_64.c |   26 +++++++++++++++-----------
 2 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c351456..ad4e03c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -868,11 +868,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
-	table_top = table_start + (tables>>PAGE_SHIFT);
+	table_top = table_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT,
-		(table_start << PAGE_SHIFT) + tables);
+		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
 }
 
 struct map_range {
@@ -899,8 +898,13 @@ static int save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
 unsigned long __init_refok init_memory_mapping(unsigned long start,
-						unsigned long end)
+					       unsigned long end)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long page_size_mask = 0;
@@ -911,7 +915,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	int nr_range, i;
 	int use_pse;
 
-	printk(KERN_INFO "init_memory_mapping: %08lx-%08lx\n", start, end);
+	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
@@ -940,19 +944,19 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
-
 	if (use_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
 	 * because there are often fixed size MTRRs in there
 	 * and overlapping MTRRs into large pages can cause
 	 * slowdowns.
 	 */
-	/* head could not be big page alignment ? */
+	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
 	pos = start_pfn << PAGE_SHIFT;
 	if (pos == 0)
@@ -960,14 +964,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	else
 		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 				 << (PMD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > (end>>PAGE_SHIFT))
-		end_pfn = end>>PAGE_SHIFT;
+	if (end_pfn > (end >> PAGE_SHIFT))
+		end_pfn = end >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pos = end_pfn << PAGE_SHIFT;
 	}
 
-	/* big page range */
+	/* big page (2M) range */
 	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
@@ -977,7 +981,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		pos = end_pfn << PAGE_SHIFT;
 	}
 
-	/* tail is not big page alignment ? */
+	/* tail is not big page (2M) alignment */
 	start_pfn = pos>>PAGE_SHIFT;
 	end_pfn = end>>PAGE_SHIFT;
 	if (start_pfn < end_pfn)
@@ -998,13 +1002,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	}
 
 	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG " %08lx - %08lx page %s\n",
-			mr[i].start, mr[i].end,
-			(mr[i].page_size_mask & (1<<PG_LEVEL_2M)) ?
-				  "big page" : "4k");
+		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
+				mr[i].start, mr[i].end,
+			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
+			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
 	/*
 	 * Find space for the kernel direct mapping tables.
+	 *
+	 * Later we should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before the
+	 * nodes are discovered.
 	 */
 	if (!after_init_bootmem)
 		find_early_table_space(end, use_pse);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d325186..cdb3be1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -554,20 +554,25 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+
 	if (use_gbpages) {
 		unsigned long extra;
+
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
 	} else
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (use_pse) {
 		unsigned long extra;
+
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	/*
@@ -647,7 +652,6 @@ static int save_mr(struct map_range *mr, int nr_range,
 		   unsigned long start_pfn, unsigned long end_pfn,
 		   unsigned long page_size_mask)
 {
-
 	if (start_pfn < end_pfn) {
 		if (nr_range >= NR_RANGE_MR)
 			panic("run out of range for init_memory_mapping\n");
@@ -679,13 +683,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
 	if (!after_bootmem)
 		init_gbpages();
 
@@ -709,7 +706,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
 
-	/* head if not big page alignment ?*/
+	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
 	pos = start_pfn << PAGE_SHIFT;
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
@@ -721,7 +718,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		pos = end_pfn << PAGE_SHIFT;
 	}
 
-	/* big page (2M) range*/
+	/* big page (2M) range */
 	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
 	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
@@ -769,7 +766,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		/* move it */
 		old_start = mr[i].start;
 		memmove(&mr[i], &mr[i+1],
-			 (nr_range - 1 - i) * sizeof (struct map_range));
+			(nr_range - 1 - i) * sizeof(struct map_range));
 		mr[i--].start = old_start;
 		nr_range--;
 	}
@@ -780,6 +777,13 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 *
+	 * Later we should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before the
+	 * nodes are discovered.
+	 */
 	if (!after_bootmem)
 		find_early_table_space(end, use_pse, use_gbpages);
 
