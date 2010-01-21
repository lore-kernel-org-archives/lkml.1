Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357Ab0AUFrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0AUFrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903Ab0AUFrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:47:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:27260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0AUFri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:47:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,315,1262592000"; 
   d="scan'208";a="485743822"
Date: Thu, 21 Jan 2010 13:47:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Frost <frost@cs.ucla.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <steved@redhat.com>, David Howells <dhowells@redhat.com>,
       Xu Chenfeng <xcf@ustc.edu.cn>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH] mm/readahead.c: update the LRU positions of in-core
	pages, too
Message-ID: <20100121054734.GC24236@localhost>
References: <20100120215536.GN27212@frostnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20100120215536.GN27212@frostnet.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Wed, Jan 20, 2010 at 01:55:36PM -0800, Chris Frost wrote:
> This patch changes readahead to move pages that are already in memory and
> in the inactive list to the top of the list. This mirrors the behavior
> of non-in-core pages. The position of pages already in the active list
> remains unchanged.
 
This is good in general. 

> @@ -170,19 +201,24 @@ __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  		rcu_read_lock();
>  		page = radix_tree_lookup(&mapping->page_tree, page_offset);
>  		rcu_read_unlock();
> -		if (page)
> -			continue;
> -
> -		page = page_cache_alloc_cold(mapping);
> -		if (!page)
> -			break;
> -		page->index = page_offset;
> -		list_add(&page->lru, &page_pool);
> -		if (page_idx == nr_to_read - lookahead_size)
> -			SetPageReadahead(page);
> -		ret++;
> +		if (page) {
> +			page_cache_get(page);

This is racy - the page may have already be freed and possibly reused
by others in the mean time.

If you do page_cache_get() on a random page, it may trigger bad_page()
in the buddy page allocator, or the VM_BUG_ON() in put_page_testzero().

> +			if (!pagevec_add(&retain_vec, page))
> +				retain_pages(&retain_vec);
> +		} else {
> +			page = page_cache_alloc_cold(mapping);
> +			if (!page)
> +				break;
> +			page->index = page_offset;
> +			list_add(&page->lru, &page_pool);
> +			if (page_idx == nr_to_read - lookahead_size)
> +				SetPageReadahead(page);
> +			ret++;
> +		}

Years ago I wrote a similar function, which can be called for both
in-kernel-readahead (when it decides not to bring in new pages, but
only retain existing pages) and fadvise-readahead (where it want to
read new pages as well as retain existing pages).

For better chance of code reuse, would you rebase the patch on it?
(You'll have to do some cleanups first.)

+/*
+ * Move pages in danger (of thrashing) to the head of inactive_list.
+ * Not expected to happen frequently.
+ */
+static unsigned long rescue_pages(struct address_space *mapping,
+				  struct file_ra_state *ra,
+				  pgoff_t index, unsigned long nr_pages)
+{
+	struct page *grabbed_page;
+	struct page *page;
+	struct zone *zone;
+	int pgrescue = 0;
+
+	dprintk("rescue_pages(ino=%lu, index=%lu, nr=%lu)\n",
+			mapping->host->i_ino, index, nr_pages);
+
+	for(; nr_pages;) {
+		grabbed_page = page = find_get_page(mapping, index);
+		if (!page) {
+			index++;
+			nr_pages--;
+			continue;
+		}
+
+		zone = page_zone(page);
+		spin_lock_irq(&zone->lru_lock);
+
+		if (!PageLRU(page)) {
+			index++;
+			nr_pages--;
+			goto next_unlock;
+		}
+
+		do {
+			struct page *the_page = page;
+			page = list_entry((page)->lru.prev, struct page, lru);
+			index++;
+			nr_pages--;
+			ClearPageReadahead(the_page);
+			if (!PageActive(the_page) &&
+					!PageLocked(the_page) &&
+					page_count(the_page) == 1) {
+				list_move(&the_page->lru, &zone->inactive_list);
+				pgrescue++;
+			}
+		} while (nr_pages &&
+				page_mapping(page) == mapping &&
+				page_index(page) == index);
+
+next_unlock:
+		spin_unlock_irq(&zone->lru_lock);
+		page_cache_release(grabbed_page);
+		cond_resched();
+	}
+
+	ra_account(ra, RA_EVENT_READAHEAD_RESCUE, pgrescue);
+	return pgrescue;
+}

Thanks,
Fengguang
