Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZGMCrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZGMCrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZGMCru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:47:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47317 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZGMCrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:47:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mel@csn.ul.ie, akpm@linux-foundation.org
In-Reply-To: <20090713023030.GA27269@sli10-desk.sh.intel.com>
References: <20090713023030.GA27269@sli10-desk.sh.intel.com>
Message-Id: <20090713113326.624F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 13 Jul 2009 11:47:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When page is back to buddy and its order is bigger than pageblock_order, we can
> switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> has obvious effect when read a block device and then drop caches.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

This patch change hot path, but there is no performance mesurement description.
Also, I don't like modification buddy core for only drop caches.



> ---
>  mm/page_alloc.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2009-07-10 11:36:07.000000000 +0800
> +++ linux/mm/page_alloc.c	2009-07-13 09:25:21.000000000 +0800
> @@ -475,6 +475,15 @@ static inline void __free_one_page(struc
>  		order++;
>  	}
>  	set_page_order(page, order);
> +
> +	if (order >= pageblock_order && migratetype != MIGRATE_MOVABLE) {
> +		int i;
> +
> +		migratetype = MIGRATE_MOVABLE;
> +		for (i = 0; i < (1 << (order - pageblock_order)); i++)
> +			set_pageblock_migratetype(page +
> +				i * pageblock_nr_pages, MIGRATE_MOVABLE);
> +	}
>  	list_add(&page->lru,
>  		&zone->free_area[order].free_list[migratetype]);
>  	zone->free_area[order].nr_free++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



