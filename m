Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZFYOJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZFYOJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFYOJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:09:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZFYOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:09:39 -0400
Message-ID: <4A438522.7040309@redhat.com>
Date: Thu, 25 Jun 2009 10:09:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] prevent to reclaim anon page of lumpy reclaim for no
 swap space
References: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
In-Reply-To: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> This patch prevent to reclaim anon page in case of no swap space.
> VM already prevent to reclaim anon page in various place.
> But it doesnt't prevent it for lumpy reclaim.
> 
> It shuffles lru list unnecessary so that it is pointless.
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/vmscan.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 026f452..fb401fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page, int mode, int file)
>  	 * When this function is being called for lumpy reclaim, we
>  	 * initially look into all LRU pages, active, inactive and
>  	 * unevictable; only give shrink_page_list evictable pages.
> +
> +	 * If we don't have enough swap space, reclaiming of anon page
> +	 * is pointless.
>  	 */
> +	if (nr_swap_pages <= 0 && PageAnon(page))
> +		return ret;
> +

Should that be something like this:

	if (nr_swap_pages <= 0 && (PageAnon(page) && !PageSwapCache(page)))

We can still reclaim anonymous pages that already have
a swap slot assigned to them.

-- 
All rights reversed.
