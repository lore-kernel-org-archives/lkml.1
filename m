Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab0BWPD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:03:26 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57247 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0BWPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:03:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G7FsF4MTjPRanmzvYEcknE97E5YznJcglv3DD/nDBHX9iweZztuupT77r2BprV1O2L
         jf83Mmfq+79kmbuI89vJZCzEII1j1d8lV89WyjLsBg6NDy3IVcOeVpmJxp8gG1LA/v+Y
         y6SQhWt7iJ5jmd36iDUXjCSeT+cPePt7sGklA=
Subject: Re: [patch 3/3] vmscan: detect mapped file pages used only once
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1266868150-25984-4-git-send-email-hannes@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
	 <1266868150-25984-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 00:03:13 +0900
Message-ID: <1266937393.2723.46.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 20:49 +0100, Johannes Weiner wrote:
> The VM currently assumes that an inactive, mapped and referenced file
> page is in use and promotes it to the active list.
> 
> However, every mapped file page starts out like this and thus a problem
> arises when workloads create a stream of such pages that are used only
> for a short time.  By flooding the active list with those pages, the VM
> quickly gets into trouble finding eligible reclaim canditates.  The
> result is long allocation latencies and eviction of the wrong pages.
> 
> This patch reuses the PG_referenced page flag (used for unmapped file
> pages) to implement a usage detection that scales with the speed of
> LRU list cycling (i.e. memory pressure).
> 
> If the scanner encounters those pages, the flag is set and the page
> cycled again on the inactive list.  Only if it returns with another
> page table reference it is activated.  Otherwise it is reclaimed as
> 'not recently used cache'.
> 
> This effectively changes the minimum lifetime of a used-once mapped
> file page from a full memory cycle to an inactive list cycle, which
> allows it to occur in linear streams without affecting the stable
> working set of the system.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/rmap.h |    2 +-
>  mm/rmap.c            |    3 ---
>  mm/vmscan.c          |   45 +++++++++++++++++++++++++++++++++++----------
>  3 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index b019ae6..f4accb5 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -181,7 +181,7 @@ static inline int page_referenced(struct page *page, int is_locked,
>  				  unsigned long *vm_flags)
>  {
>  	*vm_flags = 0;
> -	return TestClearPageReferenced(page);
> +	return 0;
>  }
>  
>  #define try_to_unmap(page, refs) SWAP_FAIL
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 278cd27..5a48bda 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -511,9 +511,6 @@ int page_referenced(struct page *page,
>  	int referenced = 0;
>  	int we_locked = 0;
>  
> -	if (TestClearPageReferenced(page))
> -		referenced++;
> -

>From now on, page_referenced see only page table for reference. 
So let's comment it on function description.
like "This function checks reference from only pte"

>  	*vm_flags = 0;
>  	if (page_mapped(page) && page_rmapping(page)) {
>  		if (!is_locked && (!PageAnon(page) || PageKsm(page))) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a8e4cbe..674a78b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -561,18 +561,18 @@ redo:
>  enum page_references {
>  	PAGEREF_RECLAIM,
>  	PAGEREF_RECLAIM_CLEAN,
> +	PAGEREF_KEEP,
>  	PAGEREF_ACTIVATE,
>  };
>  
>  static enum page_references page_check_references(struct page *page,
>  						  struct scan_control *sc)
>  {
> +	int referenced_ptes, referenced_page;
>  	unsigned long vm_flags;
> -	int referenced;
>  
> -	referenced = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
> -	if (!referenced)
> -		return PAGEREF_RECLAIM;
> +	referenced_ptes = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
> +	referenced_page = TestClearPageReferenced(page);
>  
>  	/* Lumpy reclaim - ignore references */
>  	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> @@ -582,11 +582,36 @@ static enum page_references page_check_references(struct page *page,
>  	if (vm_flags & VM_LOCKED)
>  		return PAGEREF_RECLAIM;
>  
> -	if (page_mapped(page))
> -		return PAGEREF_ACTIVATE;
> +	if (referenced_ptes) {
> +		if (PageAnon(page))
> +			return PAGEREF_ACTIVATE;
> +		/*
> +		 * All mapped pages start out with page table
> +		 * references from the instantiating fault, so we need
> +		 * to look twice if a mapped file page is used more
> +		 * than once.
> +		 *
> +		 * Mark it and spare it for another trip around the
> +		 * inactive list.  Another page table reference will
> +		 * lead to its activation.
> +		 *
> +		 * Note: the mark is set for activated pages as well
> +		 * so that recently deactivated but used pages are
> +		 * quickly recovered.
> +		 */
> +		SetPageReferenced(page);
> +
> +		if (referenced_page)
> +			return PAGEREF_ACTIVATE;
> +
> +		return PAGEREF_KEEP;
> +	}
>  
>  	/* Reclaim if clean, defer dirty pages to writeback */
> -	return PAGEREF_RECLAIM_CLEAN;
> +	if (referenced_page)
> +		return PAGEREF_RECLAIM_CLEAN;
> +
> +	return PAGEREF_RECLAIM;
>  }
>  
>  /*
> @@ -654,6 +679,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		switch (references) {
>  		case PAGEREF_ACTIVATE:
>  			goto activate_locked;
> +		case PAGEREF_KEEP:
> +			goto keep_locked;
>  		case PAGEREF_RECLAIM:
>  		case PAGEREF_RECLAIM_CLEAN:
>  			; /* try to reclaim the page below */
> @@ -1356,9 +1383,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			continue;
>  		}
>  
> -		/* page_referenced clears PageReferenced */
> -		if (page_mapped(page) &&
> -		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
> +		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
>  			nr_rotated++;
>  			/*
>  			 * Identify referenced, file-backed active pages and

It looks good to me except PAGEREF_RECLAIM_CLEAN. 

I am glad to meet your this effort, again, Hannes. :)

-- 
Kind regards,
Minchan Kim


