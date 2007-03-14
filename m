Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXCNRVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXCNRVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXCNRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:21:44 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:43154 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXCNRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:21:43 -0400
Date: Wed, 14 Mar 2007 17:21:41 +0000
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Message-ID: <20070314172141.GA17891@skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703140911.16537.bjorn.helgaas@hp.com> <20070314161327.GA14416@skynet.ie> <200703141052.19792.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200703141052.19792.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/03/07 10:52), Bjorn Helgaas didst pronounce:
> On Wednesday 14 March 2007 10:13, Mel Gorman wrote:
> > Ok. This looks like another case of HOLES_IN_ZONE hilarity with page_zone().
> > As I take a new look at the BUG_ON check in move_freepages(), it isn't even
> > necessary as move_freepages_block() already checks the zone boundaries.  At a
> > later date when the code has survived a while without new bug reports, I'll
> > submit a patch that simply deletes this check because it should be redundant.
> > Just in case, I'd like to preserve the check in the non-HOLES_IN_ZONE
> > case for now.
> > 
> > Can you try this patch please? It should apply on top of Yasunori Goto's
> > patch.
> > ...
> > +#ifndef CONFIG_HOLES_IN_ZONE
> > +	/*
> > +	 * page_zone is not safe to call in this context when
> > +	 * CONFIG_HOLES_IN_ZONE is set but this bug check is
> > +	 * redundant anyway as we check zone boundaries in
> > +	 * move_freepages_block()
> > +	 */
> >  	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
> > +#endif
> >  
> 
> Your patch applied fine, but I'm sorry to say it still doesn't
> work.  I added this patch on top of yours:
> 
> --- work-mm10.orig/mm/page_alloc.c      2007-03-14 09:34:42.000000000 -0700
> +++ work-mm10/mm/page_alloc.c   2007-03-14 09:42:31.000000000 -0700
> @@ -707,6 +707,10 @@
>         unsigned long order;
>         int blocks_moved = 0;
>  
> +       printk("%s: zone %s zone_start_pfn 0x%lx start_page 0x%p end_page 0x%p\n",
> +               __FUNCTION__, zone->name, zone->zone_start_pfn, start_page,
> +               end_page);
> +
>  #ifndef CONFIG_HOLES_IN_ZONE
>         /*
>          * page_zone is not safe to call in this context when
> 
> and it crashed like this.  Let me know if I can collect more information
> for you.

Can you tell me if the faulting line was at the check for PageBuddy?  Can you
also apply the following patch and boot with loglevel=8 please? The
patch moves the check for pfn_valid() before PageBuddy() is called.

Thanks

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-bjorn_testfix/mm/page_alloc.c linux-2.6.21-rc3-mm2-bjorn_testfix-2/mm/page_alloc.c
--- linux-2.6.21-rc3-mm2-bjorn_testfix/mm/page_alloc.c	2007-03-14 16:01:00.000000000 +0000
+++ linux-2.6.21-rc3-mm2-bjorn_testfix-2/mm/page_alloc.c	2007-03-14 17:17:57.000000000 +0000
@@ -718,10 +718,6 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page < end_page;) {
-		if (!PageBuddy(page)) {
-			page++;
-			continue;
-		}
 #ifdef CONFIG_HOLES_IN_ZONE
 		if (!pfn_valid(page_to_pfn(page))) {
 			page++;
@@ -729,6 +725,11 @@ int move_freepages(struct zone *zone,
 		}
 #endif
 
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
+
 		order = page_order(page);
 		list_del(&page->lru);
 		list_add(&page->lru,
