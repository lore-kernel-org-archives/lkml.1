Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZFDVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZFDVXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZFDVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:23:04 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:16719 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZFDVXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:23:04 -0400
X-Trace: 209634527/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.50.0/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.50.0
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwFAKXXJ0pQKTIA/2dsb2JhbACBT818gj+BTAU
X-IronPort-AV: E=Sophos;i="4.41,307,1241391600"; 
   d="scan'208";a="209634527"
Date: Thu, 4 Jun 2009 22:22:42 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [patch] mm: release swap slots for actively used pages
In-Reply-To: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0906042155370.12649@sister.anvils>
References: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Johannes Weiner wrote:

> For anonymous pages activated by the reclaim scan or faulted from an
> evicted page table entry we should always try to free up swap space.
> 
> Both events indicate that the page is in active use and a possible
> change in the working set.  Thus removing the slot association from
> the page increases the chance of the page being placed near its new
> LRU buddies on the next eviction and helps keeping the amount of stale
> swap cache entries low.
> 
> try_to_free_swap() inherently only succeeds when the last user of the
> swap slot vanishes so it is safe to use from places where that single
> mapping just brought the page back to life.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>

You're absolutely right to question these now ancient vm_swap_full()
tests.  But I'm not convinced that you're right in this patch.  You
seem to be overlooking non-dirty cases e.g. at process startup data
is read in from file, perhaps modified, or otherwise constructed in
a large anonymous buffer, never subsequently changed, but under later
memory pressure written out to swap.

With your patch, we keep freeing that swap, so it has to get written
to swap again each time there's memory pressure; whereas without your
patch, it's already there on swap, no subsequent writes needed.

Yes, access patterns may change, and it may sometimes be advantageous
to rewrite even the unchanged pages, to somewhere near their related
pages; but I don't think we can ever be sure of winning at that game.

So the do_swap_page() part of your patch looks plain wrong to me:
if it's a page which isn't going to be modified, it ought to remain
in swap (unless swap getting full or page now locked); and if it's
going to be modified, then do_wp_page()'s reuse_swap_page() should
already be dealing with it appropriately.

And the vmscan.c activate test should be checking PageDirty?

Hugh

> ---
>  mm/memory.c |    3 +--
>  mm/vmscan.c |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b4e40e..407ebf7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2671,8 +2671,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	mem_cgroup_commit_charge_swapin(page, ptr);
>  
>  	swap_free(entry);
> -	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
> -		try_to_free_swap(page);
> +	try_to_free_swap(page);
>  	unlock_page(page);
>  
>  	if (write_access) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 621708f..2f0549d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -788,7 +788,7 @@ cull_mlocked:
>  
>  activate_locked:
>  		/* Not a candidate for swapping, so reclaim swap space. */
> -		if (PageSwapCache(page) && vm_swap_full())
> +		if (PageSwapCache(page))
>  			try_to_free_swap(page);
>  		VM_BUG_ON(PageActive(page));
>  		SetPageActive(page);
> -- 
> 1.6.3
