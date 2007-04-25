Return-Path: <linux-kernel-owner+w=401wt.eu-S1161598AbXDYCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161598AbXDYCCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 22:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161829AbXDYCCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 22:02:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60130 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161598AbXDYCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 22:02:20 -0400
Date: Wed, 25 Apr 2007 11:00:58 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/2] Align ZONE_MOVABLE to a MAX_ORDER_NR_PAGES boundary
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20070424180112.22005.34624.sendpatchset@skynet.skynet.ie>
References: <20070424180032.22005.82088.sendpatchset@skynet.skynet.ie> <20070424180112.22005.34624.sendpatchset@skynet.skynet.ie>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070425105604.FBB4.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good. :-)
Thanks.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> 
> The boot memory allocator makes assumptions on the alignment of zone
> boundaries even though the buddy allocator has no requirements on the
> alignment of zones. This may cause boot problems in situations where
> ZONE_MOVABLE is populated because the bootmem allocator assumes zones are
> at least order-log2(BITS_PER_LONG) aligned. As the two potential users
> (huge pages and memory hot-remove) of ZONE_MOVABLE would prefer a higher
> alignment, this patch aligns the start of the zone instead of fixing the
> different assumptions made by the bootmem allocator.
> 
> This patch rounds the start of ZONE_MOVABLE in each node to a
> MAX_ORDER_NR_PAGES boundary. If the rounding pushes the start of ZONE_MOVABLE
> above the end of the node then the zone will contain no memory and will not
> be used at runtime. The value is rounded up instead of down as it is
> better to have the kernel-portion of memory larger than requested instead
> of smaller. The impact is that the kernel-usable portion of memory because a
> minimum guarantee instead of the exact size requested by the user.
> 
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Andy Whitcroft <apw@shadowen.org>
> ---
> 
>  page_alloc.c |    5 +++++
>  1 files changed, 5 insertions(+)
> 
> diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-002_commonparse/mm/page_alloc.c linux-2.6.21-rc6-mm1-003_alignmovable/mm/page_alloc.c
> --- linux-2.6.21-rc6-mm1-002_commonparse/mm/page_alloc.c	2007-04-24 09:38:30.000000000 +0100
> +++ linux-2.6.21-rc6-mm1-003_alignmovable/mm/page_alloc.c	2007-04-24 11:15:40.000000000 +0100
> @@ -3642,6 +3642,11 @@ restart:
>  	usable_nodes--;
>  	if (usable_nodes && required_kernelcore > usable_nodes)
>  		goto restart;
> +	
> +	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
> +	for (nid = 0; nid < MAX_NUMNODES; nid++)
> +		zone_movable_pfn[nid] =
> +			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
>  }
>  
>  /**

-- 
Yasunori Goto 


