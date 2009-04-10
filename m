Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZDJXzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZDJXzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 19:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZDJXzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 19:55:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbZDJXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 19:55:03 -0400
Date: Fri, 10 Apr 2009 16:48:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, lpk@581.spb.su, wli@movementarian.org,
       npiggin@suse.de, fengguang.wu@intel.com, torvalds@linux-foundation.org,
       yinghan@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/9] readahead: clean up and simplify the code for
 filemap page fault readahead
Message-Id: <20090410164803.0c6cc25d.akpm@linux-foundation.org>
In-Reply-To: <20090410061254.530720232@intel.com>
References: <20090410060957.442203404@intel.com>
	<20090410061254.530720232@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 14:10:03 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> @@ -1553,18 +1581,18 @@ retry_find:
>  	if (unlikely(!PageUptodate(page)))
>  		goto page_not_uptodate;
>  
> -	/* Must recheck i_size under page lock */
> +	/*
> +	 * Found the page and have a reference on it.
> +	 * We must recheck i_size under page lock.
> +	 */
>  	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> -	if (unlikely(vmf->pgoff >= size)) {
> +	if (unlikely(offset >= size)) {
>  		unlock_page(page);
>  		page_cache_release(page);
>  		return VM_FAULT_SIGBUS;
>  	}

This hunk broke
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch.


I fixed it thusly:

	/*
	 * Found the page and have a reference on it.
	 * We must recheck i_size under page lock.
	 */
	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
	if (unlikely(offset >= size)) {
		unlock_page(page);
		page_cache_release(page);
		return VM_FAULT_SIGBUS;
	}
+	update_page_reclaim_stat(page);
	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
	vmf->page = page;
	return ret | VM_FAULT_LOCKED;

which seems logical to me.

Although now I look at it, it seems that
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch should
go into 2.6.30?

Ah.  But I have a note here that I didn't like it, because it adds lots
of new spinlocking to fastpaths.  So I'll leave things as they stand
until we have had a little talk about that.



From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Unfortunately, the following two patches had conflicting concepts.

  1. commit 9ff473b9a72942c5ac0ad35607cae28d8d59ed7a
     (vmscan: evict streaming IO first)

  2. commit bf3f3bc5e734706730c12a323f9b2068052aa1f0
     (mm: don't mark_page_accessed in fault path)

(1) requires that a page fault update reclaim stat via
    mark_page_accessed(), but

(2) removed mark_page_accessed().

However, (1) actually only needed to update reclaim stat, but not activate
the page.  Then, the fault-path can call update_page_reclaim_stat() to
solve this conflict.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/filemap.c         |    2 +-
 mm/memory.c          |    2 ++
 mm/swap.c            |   24 +++++++++++++++++++-----
 4 files changed, 23 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-update_page_reclaim_stat-is-called-from-page-fault-path include/linux/swap.h
--- a/include/linux/swap.h~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/include/linux/swap.h
@@ -179,6 +179,7 @@ extern void __lru_cache_add(struct page 
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
+extern void update_page_reclaim_stat(struct page *page);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
diff -puN mm/filemap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/filemap.c
--- a/mm/filemap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/filemap.c
@@ -1595,7 +1595,7 @@ retry_find:
 		page_cache_release(page);
 		return VM_FAULT_SIGBUS;
 	}
-
+	update_page_reclaim_stat(page);
 	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
diff -puN mm/memory.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/memory.c
--- a/mm/memory.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/memory.c
@@ -2507,6 +2507,8 @@ static int do_swap_page(struct mm_struct
 		try_to_free_swap(page);
 	unlock_page(page);
 
+	update_page_reclaim_stat(page);
+
 	if (write_access) {
 		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
 		if (ret & VM_FAULT_ERROR)
diff -puN mm/swap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/swap.c
--- a/mm/swap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/swap.c
@@ -151,8 +151,9 @@ void  rotate_reclaimable_page(struct pag
 	}
 }
 
-static void update_page_reclaim_stat(struct zone *zone, struct page *page,
-				     int file, int rotated)
+static void update_page_reclaim_stat_locked(struct zone *zone,
+					    struct page *page,
+					    int file, int rotated)
 {
 	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
 	struct zone_reclaim_stat *memcg_reclaim_stat;
@@ -171,6 +172,19 @@ static void update_page_reclaim_stat(str
 		memcg_reclaim_stat->recent_rotated[file]++;
 }
 
+void update_page_reclaim_stat(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	/* if the page isn't reclaimable, it doesn't update reclaim stat */
+	if (PageLRU(page) && !PageUnevictable(page)) {
+		update_page_reclaim_stat_locked(zone, page,
+					 !!page_is_file_cache(page), 1);
+	}
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 /*
  * FIXME: speed this up?
  */
@@ -182,14 +196,14 @@ void activate_page(struct page *page)
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = LRU_BASE + file;
-		del_page_from_lru_list(zone, page, lru);
 
+		del_page_from_lru_list(zone, page, lru);
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		update_page_reclaim_stat(zone, page, !!file, 1);
+		update_page_reclaim_stat_locked(zone, page, !!file, 1);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -427,7 +441,7 @@ void ____pagevec_lru_add(struct pagevec 
 		file = is_file_lru(lru);
 		if (active)
 			SetPageActive(page);
-		update_page_reclaim_stat(zone, page, file, active);
+		update_page_reclaim_stat_locked(zone, page, file, active);
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
_

