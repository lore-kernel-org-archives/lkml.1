Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbXJHQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbXJHQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJHQyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:54:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52052 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXJHQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:54:46 -0400
Subject: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Chinner <dgc@sgi.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, mark.fasheh@oracle.com,
       hugh <hugh@veritas.com>, stable <stable@kernel.org>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 18:54:37 +0200
Message-Id: <1191862477.20745.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that with the recent usage of ->page_mkwrite() a little detail
was overlooked.

.22-rc1 merged OCFS2 usage of this hook
.23-rc1 merged XFS usage
.24-rc1 will most likely merge NFS usage

Please consider this for .23 final and maybe even .22.x

---
Subject: mm: set_page_dirty_balance() vs ->page_mkwrite()

All the current page_mkwrite() implementations also set the page dirty. Which
results in the set_page_dirty_balance() call to _not_ call balance, because the
page is already found dirty.

This allows us to dirty a _lot_ of pages without ever hitting
balance_dirty_pages().  Not good (tm).

Force a balance call if ->page_mkwrite() was successful.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/writeback.h |    2 +-
 mm/memory.c               |    9 +++++++--
 mm/page-writeback.c       |    4 ++--
 3 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -137,7 +137,7 @@ int sync_page_range(struct inode *inode,
 			loff_t pos, loff_t count);
 int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
 			   loff_t pos, loff_t count);
-void set_page_dirty_balance(struct page *page);
+void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
 
 /* pdflush.c */
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1559,6 +1559,7 @@ static int do_wp_page(struct mm_struct *
 	struct page *old_page, *new_page;
 	pte_t entry;
 	int reuse = 0, ret = 0;
+	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
@@ -1607,6 +1608,8 @@ static int do_wp_page(struct mm_struct *
 			page_cache_release(old_page);
 			if (!pte_same(*page_table, orig_pte))
 				goto unlock;
+
+			page_mkwrite = 1;
 		}
 		dirty_page = old_page;
 		get_page(dirty_page);
@@ -1691,7 +1694,7 @@ unlock:
 		 * do_no_page is protected similarly.
 		 */
 		wait_on_page_locked(dirty_page);
-		set_page_dirty_balance(dirty_page);
+		set_page_dirty_balance(dirty_page, page_mkwrite);
 		put_page(dirty_page);
 	}
 	return ret;
@@ -2238,6 +2241,7 @@ static int __do_fault(struct mm_struct *
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
 	int ret;
+	int page_mkwrite = 0;
 
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
@@ -2315,6 +2319,7 @@ static int __do_fault(struct mm_struct *
 					anon = 1; /* no anon but release vmf.page */
 					goto out;
 				}
+				page_mkwrite = 1;
 			}
 		}
 
@@ -2375,7 +2380,7 @@ out_unlocked:
 	if (anon)
 		page_cache_release(vmf.page);
 	else if (dirty_page) {
-		set_page_dirty_balance(dirty_page);
+		set_page_dirty_balance(dirty_page, page_mkwrite);
 		put_page(dirty_page);
 	}
 
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -460,9 +460,9 @@ static void balance_dirty_pages(struct a
 		pdflush_operation(background_writeout, 0);
 }
 
-void set_page_dirty_balance(struct page *page)
+void set_page_dirty_balance(struct page *page, int page_mkwrite)
 {
-	if (set_page_dirty(page)) {
+	if (set_page_dirty(page) || page_mkwrite) {
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping)


