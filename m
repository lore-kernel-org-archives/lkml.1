Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYJ3AKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYJ3AKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYJ3AKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:10:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYJ3AKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:10:30 -0400
Date: Thu, 30 Oct 2008 09:09:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: gerald.schaefer@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com, dave@linux.vnet.ibm.com
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in
 test_pages_isolated()
Message-Id: <20081030090958.f86d49db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1225290330.10021.7.camel@t60p>
References: <1225290330.10021.7.camel@t60p>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 15:25:30 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> My last bugfix here (adding zone->lock) introduced a new problem: Using
> page_zone(pfn_to_page(pfn)) to get the zone after the for() loop is wrong.
> pfn will then be >= end_pfn, which may be in a different zone or not
> present at all. This may lead to an addressing exception in page_zone()
> or spin_lock_irqsave().
> 
> Now I use __first_valid_page() again after the loop to find a valid page
> for page_zone().
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
Thanks.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/page_isolation.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/page_isolation.c
> ===================================================================
> --- linux-2.6.orig/mm/page_isolation.c
> +++ linux-2.6/mm/page_isolation.c
> @@ -130,10 +130,11 @@ int test_pages_isolated(unsigned long st
>  		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
>  			break;
>  	}
> -	if (pfn < end_pfn)
> +	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
> +	if ((pfn < end_pfn) || !page)
>  		return -EBUSY;
>  	/* Check all pages are free or Marked as ISOLATED */
> -	zone = page_zone(pfn_to_page(pfn));
> +	zone = page_zone(page);
>  	spin_lock_irqsave(&zone->lock, flags);
>  	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
>  	spin_unlock_irqrestore(&zone->lock, flags);
> 
> 

