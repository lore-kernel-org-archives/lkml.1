Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbZFKPGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbZFKPGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZFKPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:06:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54192 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZFKPG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:06:28 -0400
Date: Thu, 11 Jun 2009 16:06:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com
Subject: Re: [PATCH 1/3] remove wrong rotation at lumpy reclaim
Message-ID: <20090611150627.GH7302@csn.ul.ie>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com> <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 05:00:18PM +0900, KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can
> be pushed back to "src" list by list_move(). But the page may not be from
> "src" list. And list_move() itself is unnecessary because the page is
> not on top of LRU. Then, leave it as it is if __isolate_lru_page() fails.
> 
> This patch doesn't change the logic as "we should exit loop or not" and
> just fixes buggy list_move().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> Index: lumpy-reclaim-trial/mm/vmscan.c
> ===================================================================
> --- lumpy-reclaim-trial.orig/mm/vmscan.c
> +++ lumpy-reclaim-trial/mm/vmscan.c
> @@ -936,18 +936,11 @@ static unsigned long isolate_lru_pages(u
>  			/* Check that we have not crossed a zone boundary. */
>  			if (unlikely(page_zone_id(cursor_page) != zone_id))
>  				continue;
> -			switch (__isolate_lru_page(cursor_page, mode, file)) {
> -			case 0:
> +			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>  				list_move(&cursor_page->lru, dst);
>  				nr_taken++;
>  				scan++;
>  				break;
> -
> -			case -EBUSY:
> -				/* else it is being freed elsewhere */
> -				list_move(&cursor_page->lru, src);
> -			default:
> -				break;	/* ! on LRU or wrong list */
>  			}
>  		}
>  	}
> 

At very minimum, this avoids an unnecessary reshuffling of the LRU lists
during lumpy reclaim. Thanks

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
