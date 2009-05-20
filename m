Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZETIJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZETIJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZETIJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:09:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbZETII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:08:56 -0400
Date: Wed, 20 May 2009 17:08:51 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] reset wmark_min and inactive ratio of zone when hotplug happens
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090520162616.744C.A69D9226@jp.fujitsu.com>
References: <20090520162001.3f3bbe5c.minchan.kim@barrios-desktop> <20090520162616.744C.A69D9226@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090520170712.6CEE.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch solve two problems.
> > 
> > Whenever memory hotplug sucessfully happens, zone->present_pages
> > have to be changed.
> > 
> > 1) Now, memory hotplug calls setup_per_zone_wmark_min only when
> > online_pages called, not offline_pages.
> > 
> > It breaks balance.
> > 
> > 2) If zone->present_pages is changed, we also have to change
> > zone->inactive_ratio. That's because inactive_ratio depends
> > on zone->present_pages.
> 
> Good catch!
> looks good to me. but I'm not familiar this area. CC to Goto-san.
> 

Thanks. Looks good!

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>



> 
> 
> 
> 
> > CC: Mel Gorman <mel@csn.ul.ie>
> > CC: Rik van Riel <riel@redhat.com>
> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/memory_hotplug.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 40bf385..1611010 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -423,6 +423,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
> >  	zone->zone_pgdat->node_present_pages += onlined_pages;
> >  
> >  	setup_per_zone_wmark_min();
> > +	calculate_per_zone_inactive_ratio(zone);
> >  	if (onlined_pages) {
> >  		kswapd_run(zone_to_nid(zone));
> >  		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> > @@ -832,6 +833,9 @@ repeat:
> >  	totalram_pages -= offlined_pages;
> >  	num_physpages -= offlined_pages;
> >  
> > +	setup_per_zone_wmark_min();
> > +	calculate_per_zone_inactive_ratio(zone);
> > +
> >  	vm_total_pages = nr_free_pagecache_pages();
> >  	writeback_set_ratelimit();
> >  
> > -- 
> > 1.5.4.3
> > 
> > 
> > 
> > -- 
> > Kinds Regards
> > Minchan Kim
> 
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Yasunori Goto 


