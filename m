Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZIKSsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZIKSsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZIKSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZIKSsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:38 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/21] HWPOISON: Add invalidate_inode_page
Message-Id: <20090911184841.2CB90B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

Add a simple way to invalidate a single page
This is just a refactoring of the truncate.c code.
Originally from Fengguang, modified by Andi Kleen.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mm.h |    2 ++
 mm/truncate.c      |   26 ++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -796,6 +796,8 @@ extern int vmtruncate_range(struct inode
 
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 
+int invalidate_inode_page(struct page *page);
+
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
Index: linux/mm/truncate.c
===================================================================
--- linux.orig/mm/truncate.c
+++ linux/mm/truncate.c
@@ -146,6 +146,24 @@ int truncate_inode_page(struct address_s
 	return truncate_complete_page(mapping, page);
 }
 
+/*
+ * Safely invalidate one page from its pagecache mapping.
+ * It only drops clean, unused pages. The page must be locked.
+ *
+ * Returns 1 if the page is successfully invalidated, otherwise 0.
+ */
+int invalidate_inode_page(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	if (!mapping)
+		return 0;
+	if (PageDirty(page) || PageWriteback(page))
+		return 0;
+	if (page_mapped(page))
+		return 0;
+	return invalidate_complete_page(mapping, page);
+}
+
 /**
  * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
@@ -312,12 +330,8 @@ unsigned long invalidate_mapping_pages(s
 			if (lock_failed)
 				continue;
 
-			if (PageDirty(page) || PageWriteback(page))
-				goto unlock;
-			if (page_mapped(page))
-				goto unlock;
-			ret += invalidate_complete_page(mapping, page);
-unlock:
+			ret += invalidate_inode_page(page);
+
 			unlock_page(page);
 			if (next > end)
 				break;
