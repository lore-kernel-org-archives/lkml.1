Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZFIIUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZFIIUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbZFIITo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:19:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35956 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbZFIITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:19:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] Properly account for the number of page cache pages zone_reclaim() can reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090609171027.DD79.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 17:19:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

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
> 
> The ideal would be that the number of tmpfs pages would also be known
> and account for like NR_FILE_MAPPED as swap is required to discard them.
> A means of working this out quickly was not obvious but a comment is added
> noting the problem.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ba211c1..ffe2f32 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2380,6 +2380,21 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  {
>  	int node_id;
>  	int ret;
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

I think I and you tackle the same issue.
Please see vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch in -mm.

My intension mean, tmpfs page and swapcache increased NR_FILE_PAGES.
but they can't be reclaimed by zone_reclaim_mode==1.

Then, I decide to use following calculation.

+	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
+				 zone_page_state(zone, NR_ACTIVE_FILE) -
+				 zone_page_state(zone, NR_FILE_MAPPED);


> +	pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
> +	if (!(zone_reclaim_mode & RECLAIM_WRITE))
> +		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_DIRTY);
> +	if (!(zone_reclaim_mode & RECLAIM_SWAP))
> +		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_MAPPED);

if you hope to solve tmpfs issue, RECLAIM_WRITE/RECLAIM_SWAP are unrelated, I think.
Plus, Could you please see vmscan-zone_reclaim-use-may_swap.patch in -mm?
it improve RECLAIM_SWAP by another way.



>  
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
> 



