Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362Ab0ARCUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0ARCUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748Ab0ARCUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:20:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55671 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0ARCUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:20:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-mm" <linux-mm@kvack.org>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201001180125.59413.rjw@sisk.pl>
References: <1263745267.2162.42.camel@barrios-desktop> <201001180125.59413.rjw@sisk.pl>
Message-Id: <20100118111703.AE36.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 11:20:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1963,10 +1963,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
>  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
>  			preferred_zone, migratetype);
> -	if (unlikely(!page))
> +	if (unlikely(!page)) {
> +		mm_lock_suspend(gfp_mask);
>  		page = __alloc_pages_slowpath(gfp_mask, order,
>  				zonelist, high_zoneidx, nodemask,
>  				preferred_zone, migratetype);
> +		mm_unlock_suspend(gfp_mask);
> +	}
>  
>  	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
>  	return page;

I think we don't need read side lock at all. generally, no lock might makes race.
But in this case, changing gfp_allowed_mask and nvidia suspend method should be
serialized higher level. Why the above two code need to run concurrently?



