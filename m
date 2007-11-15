Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXKOKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXKOKNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXKOKN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:13:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36380 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136AbXKOKNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:13:25 -0500
Date: Thu, 15 Nov 2007 10:13:22 +0000
To: akpm@linux-foundation.org
Cc: linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix boot problem with iSeries lacking hugepage support
Message-ID: <20071115101322.GA5128@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a fix for 2.6.24.

Ordinarily the size of a pageblock is determined at compile-time based on the
hugepage size. On PPC64, the hugepage size is determined at runtime based on
what is supported by the machine. With legacy machines such as iSeries that do
not support hugepages, HPAGE_SHIFT becomes 0. This results in pageblock_order
being set to -PAGE_SHIFT and a crash results shortly afterwards.

This patch sets HUGETLB_PAGE_SIZE_VARIABLE for PPC64 and adds a function
to select a sensible value for pageblock order by default.  It checks that
HPAGE_SHIFT is a sensible value before using the hugepage size; if it is
not MAX_ORDER-1 is used.

Credit goes to Stephen Rothwell for identifying the bug and testing candidate
patches.  Additional credit goes to Andy Whitcroft for spotting a problem
with respects to IA-64 before releasing. Additional credit to David Gibson
for testing with the libhugetlbfs test suite.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--- 
 arch/powerpc/Kconfig |    5 +++++
 mm/page_alloc.c      |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.24-rc2-mm1-clean/arch/powerpc/Kconfig linux-2.6.24-rc2-005_iSeries_fix/arch/powerpc/Kconfig
--- linux-2.6.24-rc2-mm1-clean/arch/powerpc/Kconfig	2007-11-14 11:38:05.000000000 +0000
+++ linux-2.6.24-rc2-005_iSeries_fix/arch/powerpc/Kconfig	2007-11-14 11:39:12.000000000 +0000
@@ -187,6 +187,11 @@ config FORCE_MAX_ZONEORDER
 	default "9" if PPC_64K_PAGES
 	default "13"
 
+config HUGETLB_PAGE_SIZE_VARIABLE
+	bool
+	depends on HUGETLB_PAGE
+	default y
+
 config MATH_EMULATION
 	bool "Math emulation"
 	depends on 4xx || 8xx || E200 || PPC_MPC832x || E500
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.24-rc2-mm1-clean/mm/page_alloc.c linux-2.6.24-rc2-005_iSeries_fix/mm/page_alloc.c
--- linux-2.6.24-rc2-mm1-clean/mm/page_alloc.c	2007-11-14 11:38:08.000000000 +0000
+++ linux-2.6.24-rc2-005_iSeries_fix/mm/page_alloc.c	2007-11-14 13:45:19.000000000 +0000
@@ -3342,6 +3342,16 @@ static void inline setup_usemap(struct p
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
+
+/* Return a sensible default order for the pageblock size. */
+static inline int __init pageblock_default_order(void)
+{
+	if (HPAGE_SHIFT > PAGE_SHIFT)
+		return HUGETLB_PAGE_ORDER;
+
+	return MAX_ORDER-1;
+}
+
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
 static inline void __init set_pageblock_order(unsigned int order)
 {
@@ -3357,7 +3367,7 @@ static inline void __init set_pageblock_
 }
 #else /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-/* Defined this way to avoid accidently referencing HUGETLB_PAGE_ORDER */
+#define pageblock_default_order(x) (0)
 #define set_pageblock_order(x)	do {} while (0)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
@@ -3442,7 +3452,7 @@ static void __meminit free_area_init_cor
 		if (!size)
 			continue;
 
-		set_pageblock_order(HUGETLB_PAGE_ORDER);
+		set_pageblock_order(pageblock_default_order());
 		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
