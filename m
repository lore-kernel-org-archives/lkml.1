Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbZFKIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbZFKIo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761045AbZFKIos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:44:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52878 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZFKIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:44:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] check unevictable flag in lumy reclaim v2
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
In-Reply-To: <20090611173819.0f76e431.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090611172249.6D3C.A69D9226@jp.fujitsu.com> <20090611173819.0f76e431.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090611174420.6D42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 17:44:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> How about this ?
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Lumpy reclaim check pages from their pfn. Then, it can find unevictable pages
> in its loop.
> Abort lumpy reclaim when we find Unevictable page, we never get a lump
> of pages for requested order.
> 
> Changelog: v1->v2
>  - rewrote commet.

Great.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: lumpy-reclaim-trial/mm/vmscan.c
> ===================================================================
> --- lumpy-reclaim-trial.orig/mm/vmscan.c
> +++ lumpy-reclaim-trial/mm/vmscan.c
> @@ -936,6 +936,15 @@ static unsigned long isolate_lru_pages(u
>  			/* Check that we have not crossed a zone boundary. */
>  			if (unlikely(page_zone_id(cursor_page) != zone_id))
>  				continue;
> +			/*
> +			 * We tries to free all pages in this range to create
> +			 * a free large page. Then, if the range includes a page
> +			 * never be reclaimed, we have no reason to do more.
> +			 * PageUnevictable page is not a page which can be
> +			 * easily freed. Abort this scan now.
> +			 */
> +			if (unlikely(PageUnevictable(cursor_page)))
> +				break;
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>  				list_move(&cursor_page->lru, dst);
>  				nr_taken++;
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



