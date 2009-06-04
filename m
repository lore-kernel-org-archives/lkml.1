Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZFDVar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZFDVar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZFDV2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:28:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZFDV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:28:35 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200906041128.112757038@firstfloor.org>
In-Reply-To: <200906041128.112757038@firstfloor.org>
To: npiggin@suse.de, akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: [PATCH] [11/15] HWPOISON: Refactor truncate to allow direct truncating of page v2
Message-Id: <20090604212823.16F901D0293@basil.firstfloor.org>
Date: Thu,  4 Jun 2009 23:28:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Nick Piggin <npiggin@suse.de>

Extract out truncate_inode_page() out of the truncate path so that
it can be used by memory-failure.c

[AK: description, headers, fix typos]
v2: Some white space changes from Fengguang Wu 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mm.h |    2 ++
 mm/truncate.c      |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

Index: linux/mm/truncate.c
===================================================================
--- linux.orig/mm/truncate.c
+++ linux/mm/truncate.c
@@ -135,6 +135,16 @@ invalidate_complete_page(struct address_
 	return ret;
 }
 
+void truncate_inode_page(struct address_space *mapping, struct page *page)
+{
+	if (page_mapped(page)) {
+		unmap_mapping_range(mapping,
+				   (loff_t)page->index << PAGE_CACHE_SHIFT,
+				   PAGE_CACHE_SIZE, 0);
+	}
+	truncate_complete_page(mapping, page);
+}
+
 /**
  * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
@@ -196,12 +206,7 @@ void truncate_inode_pages_range(struct a
 				unlock_page(page);
 				continue;
 			}
-			if (page_mapped(page)) {
-				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
-			}
-			truncate_complete_page(mapping, page);
+			truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
@@ -238,15 +243,10 @@ void truncate_inode_pages_range(struct a
 				break;
 			lock_page(page);
 			wait_on_page_writeback(page);
-			if (page_mapped(page)) {
-				unmap_mapping_range(mapping,
-				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
-			}
+			truncate_inode_page(mapping, page);
 			if (page->index > next)
 				next = page->index;
 			next++;
-			truncate_complete_page(mapping, page);
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -811,6 +811,8 @@ static inline void unmap_shared_mapping_
 extern int vmtruncate(struct inode * inode, loff_t offset);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
+void truncate_inode_page(struct address_space *mapping, struct page *page);
+
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, int write_access);
