Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZFKIV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZFKIV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZFKIVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:21:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51279 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZFKIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:21:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] remove wrong rotation at lumpy reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
In-Reply-To: <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com> <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090611172054.6D39.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 17:21:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Looks goold. Thanks fixing annoy bug.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



