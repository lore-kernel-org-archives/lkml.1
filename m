Return-Path: <linux-kernel-owner+w=401wt.eu-S1765850AbZFLNep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765850AbZFLNep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764839AbZFLN1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:27:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:24144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZFLN1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:27:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,209,1243839600"; 
   d="scan'208";a="153567381"
Date: Fri, 12 Jun 2009 21:27:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] HWPOISON: fix tasklist_lock/anon_vma locking order
Message-ID: <20090612132714.GB6751@localhost>
References: <20090611142239.192891591@intel.com> <20090611144430.540500784@intel.com> <20090612100308.GD25568@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612100308.GD25568@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:03:08PM +0800, Andi Kleen wrote:
> On Thu, Jun 11, 2009 at 10:22:41PM +0800, Wu Fengguang wrote:
> > To avoid possible deadlock. Proposed by Nick Piggin:
> 
> I disagree with the description. There's no possible deadlock right now.
> It would be purely out of paranoia.
> 
> > 
> >   You have tasklist_lock(R) nesting outside i_mmap_lock, and inside anon_vma
> >   lock. And anon_vma lock nests inside i_mmap_lock.
> > 
> >   This seems fragile. If rwlocks ever become FIFO or tasklist_lock changes
> 
> I was a bit dubious on this reasoning. If rwlocks become FIFO a lot of
> stuff will likely break.
> 
> >   type (maybe -rt kernels do it), then you could have a task holding
> 
> I think they tried but backed off quickly again
> 
> It's ok with a less scare-mongering description.

Why not merge it into the original patch and add a simple changelog
line there? I tried the last 6.5 patchset and it didn't apply cleanly
to the latest -mm tree. And this patch was updated:

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
