Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYHUN2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYHUN2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYHUN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:28:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47255 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYHUN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:28:08 -0400
Date: Thu, 21 Aug 2008 14:28:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
       akpm@linux-foundation.org
Subject: [PATCH] Skip memory holes in FLATMEM when reading /proc/pagetypeinfo (resend)
Message-ID: <20080821132804.GA6206@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend. The last patch went to Russell King with lkml cc'd as I
wasn't subscribed to the linux-arm list. However, I haven't heard it being
picked up so trying linux-arm this time.

===

Ordinarily, memory holes in flatmem still have a valid memmap and is safe
to use. However, an architecture (ARM) frees up the memmap backing memory
holes on the assumption it is never used. /proc/pagetypeinfo reads the
whole range of pages in a zone believing that the memmap is valid and that
pfn_valid will return false if it is not. On ARM, freeing the memmap breaks
the page->zone linkages even though pfn_valid() returns true and the kernel
can oops shortly afterwards due to accessing a bogus struct zone *.

This patch lets architectures say when FLATMEM can have holes in the
memmap. Rather than an expensive check for valid memory, /proc/pagetypeinfo
will confirm that the page linkages are still valid by checking page->zone
is still the expected zone. The lookup of page_zone is safe as there is a
limited range of memory that is accessed when calling page_zone.  Even if
page_zone happens to return the correct zone, the impact is that the counters
in /proc/pagetypeinfo are slightly off but fragmentation monitoring is
unlikely to be relevant on an embedded system.

Reported-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4b8acd2..70dba16 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -810,6 +810,11 @@ config OABI_COMPAT
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
 	  at all). If in doubt say Y.
 
+config ARCH_FLATMEM_HAS_HOLES
+	bool
+	default y
+	depends on FLATMEM
+
 config ARCH_DISCONTIGMEM_ENABLE
 	bool
 	default (ARCH_LH7A40X && !LH7A40X_CONTIGMEM)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b0d08e6..98aa882 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -516,9 +516,26 @@ static void pagetypeinfo_showblockcount_print(struct seq_file *m,
 			continue;
 
 		page = pfn_to_page(pfn);
+#ifdef CONFIG_ARCH_FLATMEM_HAS_HOLES
+		/*
+		 * Ordinarily, memory holes in flatmem still have a valid
+		 * memmap for the PFN range. However, an architecture for
+		 * embedded systems (e.g. ARM) can free up the memmap backing
+		 * holes to save memory on the assumption the memmap is
+		 * never used. The page_zone linkages are then broken even
+		 * though pfn_valid() returns true. Skip the page if the
+		 * linkages are broken. Even if this test passed, the impact
+		 * is that the counters for the movable type are off but
+		 * fragmentation monitoring is likely meaningless on small
+		 * systems.
+		 */
+		if (page_zone(page) != zone)
+			continue;
+#endif
 		mtype = get_pageblock_migratetype(page);
 
-		count[mtype]++;
+		if (mtype < MIGRATE_TYPES)
+			count[mtype]++;
 	}
 
 	/* Print counts */
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
