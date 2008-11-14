Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYKNHZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYKNHZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYKNHZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:25:08 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41940 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYKNHZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:25:06 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH for 2.6.28] mm: remove unevictable's show_page_path
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081114155113.0D23.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 14 Nov 2008 16:25:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew, very sorry for the patch posting at late -rc stage.
However, I think this patch is needed 2.6.28 and I've tested it on stress workload.

Could you please pick it up?


--------------------------------------------------
Hugh Dickins reported show_page_path() is buggy and unsafe. 
because

 - lack dput() against d_find_alias()
 - don't concern vma->vm_mm->owner == NULL
 - lack lock_page()

it was only for debugging, so rather than trying to fix it, just remove it now.



Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Rik van Riel <riel@redhat.com>
---
Needed for 2.6.28

 mm/vmscan.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

--- 2.6.28-rc4/mm/vmscan.c	2008-10-24 09:28:26.000000000 +0100
+++ linux/mm/vmscan.c	2008-11-12 11:52:44.000000000 +0000
@@ -2368,39 +2368,6 @@ int page_evictable(struct page *page, st
 	return 1;
 }
 
-static void show_page_path(struct page *page)
-{
-	char buf[256];
-	if (page_is_file_cache(page)) {
-		struct address_space *mapping = page->mapping;
-		struct dentry *dentry;
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-
-		spin_lock(&mapping->i_mmap_lock);
-		dentry = d_find_alias(mapping->host);
-		printk(KERN_INFO "rescued: %s %lu\n",
-		       dentry_path(dentry, buf, 256), pgoff);
-		spin_unlock(&mapping->i_mmap_lock);
-	} else {
-#if defined(CONFIG_MM_OWNER) && defined(CONFIG_MMU)
-		struct anon_vma *anon_vma;
-		struct vm_area_struct *vma;
-
-		anon_vma = page_lock_anon_vma(page);
-		if (!anon_vma)
-			return;
-
-		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-			printk(KERN_INFO "rescued: anon %s\n",
-			       vma->vm_mm->owner->comm);
-			break;
-		}
-		page_unlock_anon_vma(anon_vma);
-#endif
-	}
-}
-
-
 /**
  * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
  * @page: page to check evictability and move to appropriate lru list
@@ -2421,8 +2388,6 @@ retry:
 	if (page_evictable(page, NULL)) {
 		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
 
-		show_page_path(page);
-
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);


