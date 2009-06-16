Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZFPJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZFPJlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZFPJlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:41:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39971 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZFPJlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:41:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/2] vmscan: Fix use of delta in zone_pagecache_reclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245064482-19245-2-git-send-email-mel@csn.ul.ie>
References: <1245064482-19245-1-git-send-email-mel@csn.ul.ie> <1245064482-19245-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20090616184030.99A9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Jun 2009 18:41:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> zone_pagecache_reclaimable() works out how many pages are in a state
> that zone_reclaim() can reclaim based on the current zone_reclaim_mode.
> As part of this, it calculates a delta to the number of unmapped pages.
> The code was meant to check delta would not cause underflows and then apply
> it but it got accidentally removed.
> 
> This patch properly uses delta. It's excessively paranoid at the moment
> because it's impossible to underflow but the current form will make future
> patches to zone_pagecache_reclaimable() fixing any other scan-heuristic
> breakage easier to read and acts as self-documentation reminding authors
> of future patches to consider underflow.
> 
> This is a fix to patch
> vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
> and they should be merged together.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 026f452..bd8e3ed 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2398,7 +2398,11 @@ static long zone_pagecache_reclaimable(struct zone *zone)
>  	if (!(zone_reclaim_mode & RECLAIM_WRITE))
>  		delta += zone_page_state(zone, NR_FILE_DIRTY);
>  
> -	return nr_pagecache_reclaimable;
> +	/* Watch for any possible underflows due to delta */
> +	if (unlikely(delta > nr_pagecache_reclaimable))
> +		delta = nr_pagecache_reclaimable;
> +
> +	return nr_pagecache_reclaimable - delta;
>  }

looks good. thanks.



