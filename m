Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZFIC0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZFIC0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZFICZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:25:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:11660 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZFICZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:25:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,328,1241420400"; 
   d="scan'208";a="152075691"
Date: Tue, 9 Jun 2009 10:25:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Properly account for the number of page cache
	pages zone_reclaim() can reclaim
Message-ID: <20090609022549.GB6740@localhost>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:01:29PM +0800, Mel Gorman wrote:
> On NUMA machines, the administrator can configure zone_relcaim_mode that
> is a more targetted form of direct reclaim. On machines with large NUMA
> distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
> unmapped pages will be reclaimed if the zone watermarks are not being met.
> 
> There is a heuristic that determines if the scan is worthwhile but the
> problem is that the heuristic is not being properly applied and is basically
> assuming zone_reclaim_mode is 1 if it is enabled.
> 
> This patch makes zone_reclaim() makes a better attempt at working out how
> many pages it might be able to reclaim given the current reclaim_mode. If it
> cannot clean pages, then NR_FILE_DIRTY number of pages are not candidates. If
> it cannot swap, then NR_FILE_MAPPED are not. This indirectly addresses tmpfs
> as those pages tend to be dirty as they are not cleaned by pdflush or sync.

No, tmpfs pages are not accounted in NR_FILE_DIRTY because of the
BDI_CAP_NO_ACCT_AND_WRITEBACK bits.

> The ideal would be that the number of tmpfs pages would also be known
> and account for like NR_FILE_MAPPED as swap is required to discard them.
> A means of working this out quickly was not obvious but a comment is added
> noting the problem.

I'd rather prefer it be accounted separately than to muck up NR_FILE_MAPPED :)

> +	int pagecache_reclaimable;
> +
> +	/*
> +	 * Work out how many page cache pages we can reclaim in this mode.
> +	 *
> +	 * NOTE: Ideally, tmpfs pages would be accounted as if they were
> +	 *       NR_FILE_MAPPED as swap is required to discard those
> +	 *       pages even when they are clean. However, there is no
> +	 *       way of quickly identifying the number of tmpfs pages
> +	 */

So can you remove the note on NR_FILE_MAPPED?

> +	pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
> +	if (!(zone_reclaim_mode & RECLAIM_WRITE))
> +		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_DIRTY);

> +	if (!(zone_reclaim_mode & RECLAIM_SWAP))
> +		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_MAPPED);

So the "if" can be removed because NR_FILE_MAPPED is not related to swapping?

Thanks,
Fengguang

>  	/*
>  	 * Zone reclaim reclaims unmapped file backed pages and
> @@ -2391,8 +2406,7 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	 * if less than a specified percentage of the zone is used by
>  	 * unmapped file backed pages.
>  	 */
> -	if (zone_page_state(zone, NR_FILE_PAGES) -
> -	    zone_page_state(zone, NR_FILE_MAPPED) <= zone->min_unmapped_pages
> +	if (pagecache_reclaimable <= zone->min_unmapped_pages
>  	    && zone_page_state(zone, NR_SLAB_RECLAIMABLE)
>  			<= zone->min_slab_pages)
>  		return 0;
> -- 
> 1.5.6.5
