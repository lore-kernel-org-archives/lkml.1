Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbZFKXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbZFKXa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZFKXaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:30:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:23065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbZFKXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,205,1243839600"; 
   d="scan'208";a="153365558"
Date: Fri, 12 Jun 2009 07:29:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for mmotm 2/5]
Message-ID: <20090611232937.GB5960@localhost>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com> <20090611192600.6D50.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611192600.6D50.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 06:26:48PM +0800, KOSAKI Motohiro wrote:
> Changes since Wu's original patch
>   - adding vmstat
>   - rename NR_TMPFS_MAPPED to NR_SWAP_BACKED_FILE_MAPPED
> 
> 
> ----------------------
> Subject: [PATCH] introduce NR_SWAP_BACKED_FILE_MAPPED zone stat
> 
> Desirable zone reclaim implementaion want to know the number of
> file-backed and unmapped pages.
> 
> Thus, we need to know number of swap-backed mapped pages for
> calculate above number.
> 
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/mmzone.h |    2 ++
>  mm/rmap.c              |    7 +++++++
>  mm/vmstat.c            |    1 +
>  3 files changed, 10 insertions(+)
> 
> Index: b/include/linux/mmzone.h
> ===================================================================
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -88,6 +88,8 @@ enum zone_stat_item {
>  	NR_ANON_PAGES,	/* Mapped anonymous pages */
>  	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
>  			   only modified from process context */
> +	NR_SWAP_BACKED_FILE_MAPPED, /* Similar to NR_FILE_MAPPED. but

comment it as "a subset of NR_FILE_MAPPED"?

Why move this 'cold' item to the first hot cache line?

> +				       only account swap-backed pages */
>  	NR_FILE_PAGES,
>  	NR_FILE_DIRTY,
>  	NR_WRITEBACK,
> Index: b/mm/rmap.c
> ===================================================================
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -829,6 +829,10 @@ void page_add_file_rmap(struct page *pag
>  {
>  	if (atomic_inc_and_test(&page->_mapcount)) {
>  		__inc_zone_page_state(page, NR_FILE_MAPPED);
> +		if (PageSwapBacked(page))
> +			__inc_zone_page_state(page,
> +					      NR_SWAP_BACKED_FILE_MAPPED);
> +

The line wrapping is not necessary here.

>  		mem_cgroup_update_mapped_file_stat(page, 1);
>  	}
>  }
> @@ -884,6 +888,9 @@ void page_remove_rmap(struct page *page)
>  		__dec_zone_page_state(page, NR_ANON_PAGES);
>  	} else {
>  		__dec_zone_page_state(page, NR_FILE_MAPPED);
> +		if (PageSwapBacked(page))
> +			__dec_zone_page_state(page,
> +					NR_SWAP_BACKED_FILE_MAPPED);

ditto.

>  	}
>  	mem_cgroup_update_mapped_file_stat(page, -1);
>  	/*
> Index: b/mm/vmstat.c
> ===================================================================
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -633,6 +633,7 @@ static const char * const vmstat_text[] 
>  	"nr_mlock",
>  	"nr_anon_pages",
>  	"nr_mapped",
> +	"nr_swap_backed_file_mapped",

An overlong name, in my updated patch, I do it this way.

        "nr_bounce",
        "nr_vmscan_write",
        "nr_writeback_temp",
+       "nr_mapped_swapbacked",
 

The "mapped" comes first because I want to emphasis that
this is a subset of nr_mapped.

Thanks,
Fengguang
