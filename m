Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZBKXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZBKXTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKXTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:19:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763AbZBKXTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:19:10 -0500
Date: Wed, 11 Feb 2009 15:18:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de,
       hugh@veritas.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 2/2] mm: update_page_reclaim_stat() is called form page
 fault path
Message-Id: <20090211151801.d9e8c84b.akpm@linux-foundation.org>
In-Reply-To: <20090211213340.C3CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090211213201.C3CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090211213340.C3CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 21:35:07 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Unfortunately, following two patch have a bit conflicted concept.
>   1. commit 9ff473b9a72942c5ac0ad35607cae28d8d59ed7a 
>      (vmscan: evict streaming IO first)
>   2. commit bf3f3bc5e734706730c12a323f9b2068052aa1f0
>      (mm: don't mark_page_accessed in fault path)
> 
> (1) require page fault update reclaim stat via mark_page_accessed(), but
> (2) removed mark_page_accessed() perfectly. 
> 
> However, (1) actually only need to update reclaim stat, but not activate page.
> Then, fault-path calling update_page_reclaim_stat() solve thsi confliction.
> 
> ...
>
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1545,6 +1545,7 @@ retry_find:
>  	/*
>  	 * Found the page and have a reference on it.
>  	 */
> +	update_page_reclaim_stat(page);
>  	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
>  	vmf->page = page;
>  	return ret | VM_FAULT_LOCKED;

This is the minor fault hotpath.

> +void update_page_reclaim_stat(struct page *page)
> +{
> +	struct zone *zone = page_zone(page);
> +
> +	spin_lock_irq(&zone->lru_lock);
> +	/* if the page isn't reclaimable, it doesn't update reclaim stat */
> +	if (PageLRU(page) && !PageUnevictable(page)) {
> +		update_page_reclaim_stat_locked(zone, page,
> +					 !!page_is_file_cache(page), 1);
> +	}
> +	spin_unlock_irq(&zone->lru_lock);
> +}

And we just added a spin_lock_irq() and a bunch of other stuff to it.

Can we improve this?

Can we just omit it, even?

Can we update those stats locklessly and accomodate the resulting
inaccuracy over at the codesites where these statistics are actually
used?


