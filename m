Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbYB1Xnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbYB1Xnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYB1Xnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:43:31 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37302 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYB1Xn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:43:29 -0500
Date: Thu, 28 Feb 2008 15:41:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 14/21] scan noreclaim list for reclaimable pages
Message-Id: <20080228154152.9648b7b8.randy.dunlap@oracle.com>
In-Reply-To: <20080228192929.203173998@redhat.com>
References: <20080228192908.126720629@redhat.com>
	<20080228192929.203173998@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 14:29:22 -0500 Rik van Riel wrote:

> V2 -> V3:
> + rebase to 23-mm1 atop RvR's split LRU series
> 
> New in V2
> 
> This patch adds a function to scan individual or all zones' noreclaim
> lists and move any pages that have become reclaimable onto the respective
> zone's inactive list, where shrink_inactive_list() will deal with them.
> 
> This replaces the function to splice the entire noreclaim list onto the
> active list for rescan by shrink_active_list().  That method had problems
> with vmstat accounting and complicated '[__]isolate_lru_pages()'.  Now,
> __isolate_lru_page() will never isolate a non-reclaimable page.  The
> only time it should see one is when scanning nearby pages for lumpy
> reclaim.
> 
>   TODO:  This approach may still need some refinement.
>          E.g., put back to active list?
> 
> DEBUGGING ONLY: NOT FOR UPSTREAM MERGE
> 
> Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> Signed-off-by:  Rik van Riel <riel@redhat.com>


Hi,

I haven't looked at all 21 patches, but please use kernel-doc
notation as it's defined.  See Documentation/kernel-doc-nano-HOWTO.txt
for details, or ask.

> Index: linux-2.6.25-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/mm/vmscan.c	2008-02-28 11:05:04.000000000 -0500
> +++ linux-2.6.25-rc2-mm1/mm/vmscan.c	2008-02-28 12:48:01.000000000 -0500
> @@ -2295,4 +2296,144 @@ int page_reclaimable(struct page *page, 
>  
>  	return 1;
>  }
> +
> +/**
> + * scan_zone_noreclaim_pages(@zone)
> + * @zone - zone to scan

E.g.:

 * scan_zone_reclaim_pages - some short description here
 * @zone: zone to scan


> + *
> + * Scan @zone's noreclaim LRU lists to check for pages that have become
> + * reclaimable.  Move those that have to @zone's inactive list where they
> + * become candidates for reclaim, unless shrink_inactive_zone() decides
> + * to reactivate them.  Pages that are still non-reclaimable are rotated
> + * back onto @zone's noreclaim list.
> + */
> +#define SCAN_NORECLAIM_BATCH_SIZE 16UL	/* arbitrary lock hold batch size */

and don't insert macros between the kernel-doc section and the
function definition, please.


> +void scan_zone_noreclaim_pages(struct zone *zone)
> +{
...
> +}

---
~Randy
