Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZFIJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZFIJcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZFIJcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:32:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:41512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbZFIJb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:31:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,330,1241420400"; 
   d="scan'208";a="152182383"
Date: Tue, 9 Jun 2009 17:31:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] [11/15] HWPOISON: Refactor truncate to allow direct
	truncating of page v3
Message-ID: <20090609093159.GA8244@localhost>
References: <200906041128.112757038@firstfloor.org> <20090604212823.16F901D0293@basil.firstfloor.org> <20090609091821.GA16940@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609091821.GA16940@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 05:18:21PM +0800, Nick Piggin wrote:
> On Thu, Jun 04, 2009 at 11:28:23PM +0200, Andi Kleen wrote:
> > 
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Extract out truncate_inode_page() out of the truncate path so that
> > it can be used by memory-failure.c
> > 
> > [AK: description, headers, fix typos]
> > v2: Some white space changes from Fengguang Wu 
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Thank you muchly :) Seems the description is still missing? Something
> like the below?
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Andi is on vocation, so let me do the updates :)

Thanks,
Fengguang

---
HWPOISON: Refactor truncate to allow direct truncating of page v3
From: Nick Piggin <npiggin@suse.de>

Extract out truncate_inode_page() out of the truncate path so that
it can be used by memory-failure.c

[AK: description, headers, fix typos]
v2: Some white space changes from Fengguang Wu 
v3: add comments

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/mm.h |    2 ++
 mm/truncate.c      |   34 ++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 12 deletions(-)

--- linux.orig/mm/truncate.c
+++ linux/mm/truncate.c
@@ -135,6 +135,26 @@ invalidate_complete_page(struct address_
 	return ret;
 }
 
+/*
+ * Remove one page from its pagecache mapping. The page must be locked.
+ * This does not truncate the file on disk, it performs the pagecache
+ * side of the truncate operation. Dirty data will be discarded, and
+ * concurrent page references are ignored.
+ *
+ * Generic mm/fs code cannot call this on filesystem metadata mappings
+ * because those can assume that a page reference is enough to pin the
+ * page to its mapping.
+ */
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
@@ -196,12 +216,7 @@ void truncate_inode_pages_range(struct a
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
@@ -238,15 +253,10 @@ void truncate_inode_pages_range(struct a
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
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -808,6 +808,8 @@ static inline void unmap_shared_mapping_
 extern int vmtruncate(struct inode * inode, loff_t offset);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
+void truncate_inode_page(struct address_space *mapping, struct page *page);
+
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, int write_access);
