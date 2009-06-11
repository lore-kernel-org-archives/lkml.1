Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbZFKOxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbZFKOxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZFKOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:53:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:64158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZFKOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="153176946"
Message-Id: <20090611144430.947740750@intel.com>
References: <20090611142239.192891591@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Jun 2009 22:22:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 5/5] HWPOISON: use the safer invalidate page for possible metadata pages
Content-Disposition: inline; filename=hwpoison-skip-metadata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As recommended by Nick Piggin.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mm.h  |    1 +
 mm/memory-failure.c |   23 +++++++++++++----------
 mm/truncate.c       |    3 +--
 3 files changed, 15 insertions(+), 12 deletions(-)

--- sound-2.6.orig/mm/memory-failure.c
+++ sound-2.6/mm/memory-failure.c
@@ -113,6 +113,10 @@ static int me_pagecache_clean(struct pag
 	if (!isolate_lru_page(p))
 		page_cache_release(p);
 
+	mapping = page_mapping(p);
+	if (mapping == NULL)
+		return RECOVERED;
+
 	/*
 	 * Now truncate the page in the page cache. This is really
 	 * more like a "temporary hole punch"
@@ -120,20 +124,19 @@ static int me_pagecache_clean(struct pag
 	 * has a reference, because it could be file system metadata
 	 * and that's not safe to truncate.
 	 */
-	mapping = page_mapping(p);
-	if (mapping && S_ISBLK(mapping->host->i_mode) && page_count(p) > 1) {
+	if (!S_ISREG(mapping->host->i_mode) &&
+	    !invalidate_complete_page(mapping, p)) {
 		printk(KERN_ERR
-		       "MCE %#lx: page looks like a unsupported file system metadata page\n",
+		       "MCE %#lx: failed to invalidate metadata page\n",
 		       pfn);
 		return FAILED;
 	}
-	if (mapping) {
-		truncate_inode_page(mapping, p);
-		if (page_has_private(p) && !try_to_release_page(p, GFP_NOIO)) {
-			pr_debug(KERN_ERR "MCE %#lx: failed to release buffers\n",
-				 pfn);
-			return FAILED;
-		}
+
+	truncate_inode_page(mapping, p);
+	if (page_has_private(p) && !try_to_release_page(p, GFP_NOIO)) {
+		pr_debug(KERN_ERR "MCE %#lx: failed to release buffers\n",
+			 pfn);
+		return FAILED;
 	}
 	return RECOVERED;
 }
--- sound-2.6.orig/include/linux/mm.h
+++ sound-2.6/include/linux/mm.h
@@ -817,6 +817,7 @@ extern int vmtruncate(struct inode * ino
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
 void truncate_inode_page(struct address_space *mapping, struct page *page);
+int invalidate_complete_page(struct address_space *mapping, struct page *page);
 
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
--- sound-2.6.orig/mm/truncate.c
+++ sound-2.6/mm/truncate.c
@@ -118,8 +118,7 @@ truncate_complete_page(struct address_sp
  *
  * Returns non-zero if the page was successfully invalidated.
  */
-static int
-invalidate_complete_page(struct address_space *mapping, struct page *page)
+int invalidate_complete_page(struct address_space *mapping, struct page *page)
 {
 	int ret;
 

-- 

