Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXCUTPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXCUTPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbXCUTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:15:46 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1762 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796AbXCUTPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:15:44 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <hansendc@us.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] add pfn_valid_within helper for sub-MAX_ORDER hole detection
References: <exportbomb.1174504472@pinky>
InReply-To: <exportbomb.1174504472@pinky>
Message-ID: <2b7fba2bc49877d95f3ad13735324444@pinky>
Date: Wed, 21 Mar 2007 19:15:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Generally we work under the assumption that memory the mem_map
array is contigious and valid out to MAX_ORDER_NR_PAGES block
of pages, ie. that if we have validated any page within this
MAX_ORDER_NR_PAGES block we need not check any other.  This is not
true when CONFIG_HOLES_IN_ZONE is set and we must check each and
every reference we make from a pfn.

Add a pfn_valid_within() helper which should be used when scanning
pages within a MAX_ORDER_NR_PAGES block when we have already
checked the validility of the block normally with pfn_valid().
This can then be optimised away when we do not have holes within
a MAX_ORDER_NR_PAGES block of pages.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7206c77..8c87d79 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -837,6 +837,18 @@ void sparse_init(void);
 void memory_present(int nid, unsigned long start, unsigned long end);
 unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
 
+/*
+ * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
+ * need to check pfn validility within that MAX_ORDER_NR_PAGES block.
+ * pfn_valid_within() should be used in this case; we optimise this away
+ * when we have no holes within a MAX_ORDER_NR_PAGES block.
+ */
+#ifdef CONFIG_HOLES_IN_ZONE
+#define pfn_valid_within(pfn) pfn_valid(pfn)
+#else
+#define pfn_valid_within(pfn) (1)
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3d7a9e2..695b5a6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -206,10 +206,8 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 
 static int page_is_consistent(struct zone *zone, struct page *page)
 {
-#ifdef CONFIG_HOLES_IN_ZONE
-	if (!pfn_valid(page_to_pfn(page)))
+	if (!pfn_valid_within(page_to_pfn(page)))
 		return 0;
-#endif
 	if (zone != page_zone(page))
 		return 0;
 
@@ -411,10 +409,8 @@ __find_combined_index(unsigned long page_idx, unsigned int order)
 static inline int page_is_buddy(struct page *page, struct page *buddy,
 								int order)
 {
-#ifdef CONFIG_HOLES_IN_ZONE
-	if (!pfn_valid(page_to_pfn(buddy)))
+	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
-#endif
 
 	if (page_zone_id(page) != page_zone_id(buddy))
 		return 0;
