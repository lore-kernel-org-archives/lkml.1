Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYF3IdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYF3IdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYF3IdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:33:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYF3IdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:33:08 -0400
Date: Mon, 30 Jun 2008 17:36:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] memcg: change shmem handler.
Message-Id: <20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290120270.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290120270.21758@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:22:22 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru,
> so shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

How about a patch like this ?
==
a RFC patch: memcg-change-shmem-handler. 

Should be divided into 2-4 patches, and may have some problem.
(I did many careless misses today.....)

But please see idea/concepts. Maybe right way.

shmem has following characteristics.
In general.
  - seems like file cache
  - swap-backed
  - when it's swapped out, it's removed from radix-tree and added to swap.
  - when it's swapped in, it's removed from swap and added to radix-tree.

With memcg.
  - shmem is treted just as a file-cache. So, started from inactive list.
  - shmem's page fault routine is sensitive to GFP_xxx in which used.
    (GFP_NOWAIT is used) and pre-charge is done before add_to_page_cache.
  - shmem's page is removed by mem_cgroup_uncharge_cache_page(), So,
    shmem's swapcache is not charged.

This patch fixes some mess by
  - PAGE_CGROUP_FLAG_CACHE is deleted (and replaced by FLAG_FILE)
  - PAGE_CGROUP_FLAG_SHMEM is added.
  - add_to_page_cache_nocharge() is added.
    This avoids mem_cgroup_charge_cache_page(). This is useful when page is
    pre-charged.
  - uses add_to_page_cache_nocharge() also in hugemem.
    (I think hugemem controller should be independent from memcg.
     Balbir, how do you think ?)
  - PageSwapBacked() is checked.
    (A imported patch from Hugh Dickins)

As result.
  - shmem will be in SwapBacked/Active list at first.
  - memcg has "shmem/tmpfs" counter.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

--
 include/linux/pagemap.h |   16 +++++++++
 mm/filemap.c            |   49 ++++++++++++++++++++++--------
 mm/hugetlb.c            |    3 +
 mm/memcontrol.c         |   78 +++++++++++++++++++++++++-----------------------
 mm/shmem.c              |   17 ++++++----
 5 files changed, 107 insertions(+), 56 deletions(-)

Index: linux-2.6.26-rc5-mm3-kosaki/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc5-mm3-kosaki.orig/mm/memcontrol.c	2008-06-30 15:02:52.000000000 +0900
+++ linux-2.6.26-rc5-mm3-kosaki/mm/memcontrol.c	2008-06-30 16:26:34.000000000 +0900
@@ -49,6 +49,7 @@
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon/swapcache */
+	MEM_CGROUP_STAT_SHMEM,     /* # of pages charges as shmem/tmpfs */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
@@ -160,10 +161,10 @@
 	struct mem_cgroup *mem_cgroup;
 	int flags;
 };
-#define PAGE_CGROUP_FLAG_CACHE	   (0x1)	/* charged as cache */
-#define PAGE_CGROUP_FLAG_ACTIVE    (0x2)	/* page is active in this cgroup */
-#define PAGE_CGROUP_FLAG_FILE	   (0x4)	/* page is file system backed */
-#define PAGE_CGROUP_FLAG_UNEVICTABLE (0x8)	/* page is unevictableable */
+#define PAGE_CGROUP_FLAG_ACTIVE    (0x1)	/* page is active in this cgroup */
+#define PAGE_CGROUP_FLAG_FILE	   (0x2)	/* page is file system backed */
+#define PAGE_CGROUP_FLAG_UNEVICTABLE (0x4)	/* page is unevictableable */
+#define PAGE_CGROUP_FLAG_SHMEM	   (0x8)       /* page is shmem/tmpfs */
 
 static int page_cgroup_nid(struct page_cgroup *pc)
 {
@@ -178,6 +179,7 @@
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+	MEM_CGROUP_CHARGE_TYPE_SHMEM,
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 };
 
@@ -191,8 +193,10 @@
 	struct mem_cgroup_stat *stat = &mem->stat;
 
 	VM_BUG_ON(!irqs_disabled());
-	if (flags & PAGE_CGROUP_FLAG_CACHE)
+	if (flags & PAGE_CGROUP_FLAG_FILE)
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
+	else if (flags & PAGE_CGROUP_FLAG_SHMEM)
+		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_SHMEM, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
 
@@ -573,12 +577,19 @@
 	 * If a page is accounted as a page cache, insert to inactive list.
 	 * If anon, insert to active list.
 	 */
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE) {
-		pc->flags = PAGE_CGROUP_FLAG_CACHE;
-		if (page_is_file_cache(page))
-			pc->flags |= PAGE_CGROUP_FLAG_FILE;
-	} else
+	switch (ctype) {
+	case MEM_CGROUP_CHARGE_TYPE_CACHE:
+		pc->flags = PAGE_CGROUP_FLAG_FILE;
+		break;
+	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
+		pc->flags = PAGE_CGROUP_FLAG_SHMEM | PAGE_CGROUP_FLAG_ACTIVE;
+		break;
+	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
+		break;
+	default:
+		BUG();
+	}
 
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
@@ -625,28 +636,10 @@
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	/*
-	 * Corner case handling. This is called from add_to_page_cache()
-	 * in usual. But some FS (shmem) precharges this page before calling it
-	 * and call add_to_page_cache() with GFP_NOWAIT.
-	 *
-	 * For GFP_NOWAIT case, the page may be pre-charged before calling
-	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
-	 * charge twice. (It works but has to pay a bit larger cost.)
-	 */
-	if (!(gfp_mask & __GFP_WAIT)) {
-		struct page_cgroup *pc;
+	enum charge_type ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 
-		lock_page_cgroup(page);
-		pc = page_get_page_cgroup(page);
-		if (pc) {
-			VM_BUG_ON(pc->page != page);
-			VM_BUG_ON(!pc->mem_cgroup);
-			unlock_page_cgroup(page);
-			return 0;
-		}
-		unlock_page_cgroup(page);
-	}
+	if (PageSwapBacked(page))
+		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -678,11 +671,19 @@
 		goto unlock;
 
 	VM_BUG_ON(pc->page != page);
-
+	/*
+	 * There are 2 cases.
+	 * 1. anon pages are swapped out.
+	 * 2. shmem pages are swapped out.
+	 * In both case, PageSwapCache() returns 1 and we don't want to
+	 * uncharge it.
+	 */
+	if (PageSwapCache(page))
+		goto unlock;
+	/* When the page is unmapped, file-cache and shmem memory is alive */
 	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
-	    && ((pc->flags & PAGE_CGROUP_FLAG_CACHE)
-		|| page_mapped(page)
-		|| PageSwapCache(page)))
+	    && ((pc->flags & (PAGE_CGROUP_FLAG_FILE | PAGE_CGROUP_FLAG_SHMEM))
+		|| page_mapped(page)))
 		goto unlock;
 
 	mz = page_cgroup_zoneinfo(pc);
@@ -732,8 +733,10 @@
 	if (pc) {
 		mem = pc->mem_cgroup;
 		css_get(&mem->css);
-		if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
+		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
 			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+		else if (pc->flags & PAGE_CGROUP_FLAG_SHMEM)
+			ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 	}
 	unlock_page_cgroup(page);
 	if (mem) {
@@ -785,6 +788,8 @@
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
 	} while (!progress && --retry);
 
+	css_put(&mem->css);
+
 	if (!retry)
 		return -ENOMEM;
 	return 0;
@@ -920,6 +925,7 @@
 } mem_cgroup_stat_desc[] = {
 	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
 	[MEM_CGROUP_STAT_RSS] = { "anon/swapcache", PAGE_SIZE, },
+	[MEM_CGROUP_STAT_SHMEM] = { "shmem/tmpfs", PAGE_SIZE, },
 	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
 	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
 };
Index: linux-2.6.26-rc5-mm3-kosaki/include/linux/pagemap.h
===================================================================
--- linux-2.6.26-rc5-mm3-kosaki.orig/include/linux/pagemap.h	2008-06-30 15:00:04.000000000 +0900
+++ linux-2.6.26-rc5-mm3-kosaki/include/linux/pagemap.h	2008-06-30 15:03:02.000000000 +0900
@@ -258,6 +258,22 @@
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+/*
+ * If the page is pre-charged before add_to_page_cache() this routine is
+ * light-weight.
+ */
+int add_to_page_cache_nocharge(struct page *page, struct address_space *mapping,
+				pgoff_t index, gfp_t gfp_mask);
+#else
+static inline int add_to_page_cache_nocharge(struct page *page,
+				struct address_space *mapping, pgoff_t index,
+				gfp_t mask)
+{
+	return add_to_page_cache(page, mapping, index, gfp_mask);
+}
+#endif
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 
Index: linux-2.6.26-rc5-mm3-kosaki/mm/filemap.c
===================================================================
--- linux-2.6.26-rc5-mm3-kosaki.orig/mm/filemap.c	2008-06-30 15:00:04.000000000 +0900
+++ linux-2.6.26-rc5-mm3-kosaki/mm/filemap.c	2008-06-30 15:23:36.000000000 +0900
@@ -442,8 +442,9 @@
 	return err;
 }
 
+
 /**
- * add_to_page_cache - add newly allocated pagecache pages
+ * add_to_page_cache_nocharge() - add newly allocated pagecache pages
  * @page:	page to add
  * @mapping:	the page's address_space
  * @offset:	page index
@@ -454,22 +455,20 @@
  * The other page state flags were set by rmqueue().
  *
  * This function does not add the page to the LRU.  The caller must do that.
+ * This doesn't call memory resource control routine.
  */
-int add_to_page_cache(struct page *page, struct address_space *mapping,
-		pgoff_t offset, gfp_t gfp_mask)
+
+int add_to_page_cache_nocharge(struct page *page,
+			       struct address_space *mapping,
+			       pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = mem_cgroup_cache_charge(page, current->mm,
-					gfp_mask & ~__GFP_HIGHMEM);
-	if (error)
-		goto out;
 
-	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
+	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
 		page_cache_get(page);
 		SetPageLocked(page);
 		page->mapping = mapping;
 		page->index = offset;
-
 		spin_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (likely(!error)) {
@@ -478,15 +477,39 @@
 		} else {
 			page->mapping = NULL;
 			ClearPageLocked(page);
-			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
 		}
 
 		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
-	} else
-		mem_cgroup_uncharge_cache_page(page);
-out:
+	}
+	return error;
+}
+
+/**
+ * add_to_page_cache - add newly allocated pagecache pages
+ * @page:	page to add
+ * @mapping:	the page's address_space
+ * @offset:	page index
+ * @gfp_mask:	page allocation mode
+ *
+ * This function is used to add newly allocated pagecache pages;
+ * the page is new, so we can just run SetPageLocked() against it.
+ * The other page state flags were set by rmqueue().
+ *
+ * This function does not add the page to the LRU.  The caller must do that.
+ */
+int add_to_page_cache(struct page *page, struct address_space *mapping,
+		pgoff_t offset, gfp_t gfp_mask)
+{
+	int error = mem_cgroup_cache_charge(page, current->mm,
+					gfp_mask & ~__GFP_HIGHMEM);
+	if (!error) {
+		error = add_to_page_cache_nocharge(page, mapping, offset,
+						  gfp_mask);
+		if (error)
+			mem_cgroup_uncharge_cache_page(page);
+	}
 	return error;
 }
 EXPORT_SYMBOL(add_to_page_cache);
Index: linux-2.6.26-rc5-mm3-kosaki/mm/shmem.c
===================================================================
--- linux-2.6.26-rc5-mm3-kosaki.orig/mm/shmem.c	2008-06-30 15:00:04.000000000 +0900
+++ linux-2.6.26-rc5-mm3-kosaki/mm/shmem.c	2008-06-30 15:37:11.000000000 +0900
@@ -940,10 +940,8 @@
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val)
-		error = add_to_page_cache(page, inode->i_mapping, idx,
+		error = add_to_page_cache_nocharge(page, inode->i_mapping, idx,
 					GFP_NOWAIT);
-	else /* we don't have to account this page. */
-		mem_cgroup_uncharge_cache_page(page);
 
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
@@ -955,6 +953,7 @@
 			 */
 			if (PageUptodate(filepage))
 				error = 0;
+			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(filepage);
 		}
 	}
@@ -965,7 +964,9 @@
 		shmem_swp_set(info, ptr, 0);
 		swap_free(entry);
 		error = 1;	/* not an error, but entry was found */
-	}
+	} else
+		mem_cgroup_uncharge_cache_page(page);
+
 	if (ptr)
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
@@ -1375,6 +1376,7 @@
 				error = -ENOMEM;
 				goto failed;
 			}
+			SetPageSwapBacked(filepage);
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
@@ -1387,7 +1389,6 @@
 				goto failed;
 			}
 
-			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
@@ -1400,7 +1401,8 @@
 			if (ret)
 				mem_cgroup_uncharge_cache_page(filepage);
 			else
-				ret = add_to_page_cache_lru(filepage, mapping,
+				ret = add_to_page_cache_nocharge(filepage,
+						mapping,
 						idx, GFP_NOWAIT);
 			/*
 			 * At add_to_page_cache_lru() failure, uncharge will
@@ -1408,6 +1410,7 @@
 			 */
 			if (ret) {
 				spin_unlock(&info->lock);
+				mem_cgroup_uncharge_cache_page(filepage);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
@@ -1415,6 +1418,8 @@
 				if (error)
 					goto failed;
 				goto repeat;
+			} else {
+				lru_cache_add_active_anon(filepage);
 			}
 			info->flags |= SHMEM_PAGEIN;
 		}
Index: linux-2.6.26-rc5-mm3-kosaki/mm/hugetlb.c
===================================================================
--- linux-2.6.26-rc5-mm3-kosaki.orig/mm/hugetlb.c	2008-06-25 18:07:09.000000000 +0900
+++ linux-2.6.26-rc5-mm3-kosaki/mm/hugetlb.c	2008-06-30 15:08:16.000000000 +0900
@@ -1813,7 +1813,8 @@
 			int err;
 			struct inode *inode = mapping->host;
 
-			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
+			err = add_to_page_cache_nocharge(page, mapping,
+						idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
 				if (err == -EEXIST)

