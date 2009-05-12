Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbZELC6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbZELC6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZELC6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:58:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39047 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZELC6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:58:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] vmscan: merge duplicate code in shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090512025319.GD7518@localhost>
References: <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025319.GD7518@localhost>
Message-Id: <20090512115811.D613.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 11:58:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void move_active_pages_to_lru(enum lru_list lru, struct list_head *list)

it can be static?

> +{
> +	unsigned long pgmoved = 0;
> +
> +	while (!list_empty(&list)) {
> +		page = lru_to_page(&list);
> +		prefetchw_prev_lru_page(page, &list, flags);
> +
> +		VM_BUG_ON(PageLRU(page));
> +		SetPageLRU(page);
> +
> +		VM_BUG_ON(!PageActive(page));
> +		if (lru < LRU_ACTIVE)
> +			ClearPageActive(page);
> +
> +		list_move(&page->lru, &zone->lru[lru].list);
> +		mem_cgroup_add_lru_list(page, lru);
> +		pgmoved++;
> +		if (!pagevec_add(&pvec, page)) {
> +			spin_unlock_irq(&zone->lru_lock);
> +			if (buffer_heads_over_limit)
> +				pagevec_strip(&pvec);
> +			__pagevec_release(&pvec);
> +			spin_lock_irq(&zone->lru_lock);
> +		}
> +	}
> +	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> +	if (lru < LRU_ACTIVE)
> +		__count_vm_events(PGDEACTIVATE, pgmoved);
> +}


