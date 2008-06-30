Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYF3H5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYF3H5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYF3H5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:57:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50179 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYF3H5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:57:34 -0400
Date: Mon, 30 Jun 2008 16:56:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48688FCB.9040205@linux.vnet.ibm.com>
References: <20080630161657.37E3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48688FCB.9040205@linux.vnet.ibm.com>
Message-Id: <20080630165125.37E6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>  #endif /* _LINUX_MEMCONTROL_H */
> >> diff -puN mm/vmscan.c~memory-controller-soft-limit-reclaim-on-contention mm/vmscan.c
> >> diff -puN mm/page_alloc.c~memory-controller-soft-limit-reclaim-on-contention mm/page_alloc.c
> >> --- linux-2.6.26-rc5/mm/page_alloc.c~memory-controller-soft-limit-reclaim-on-contention	2008-06-27 20:43:10.000000000 +0530
> >> +++ linux-2.6.26-rc5-balbir/mm/page_alloc.c	2008-06-27 20:43:10.000000000 +0530
> >> @@ -1669,7 +1669,14 @@ nofail_alloc:
> >>  	reclaim_state.reclaimed_slab = 0;
> >>  	p->reclaim_state = &reclaim_state;
> >>  
> >> -	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
> >> +	/*
> >> +	 * First try to reclaim from memory control groups that have
> >> +	 * exceeded their soft limit
> >> +	 */
> >> +	did_some_progress = mem_cgroup_reclaim_on_contention(gfp_mask);
> >> +	if (!did_some_progress)
> >> +		did_some_progress = try_to_free_pages(zonelist, order,
> >> +							gfp_mask);
> > 
> > try_to_free_mem_cgroup_pages() assume memcg need only one page.
> > but this code break it.
> > 
> > if anyone need several continuous memory, mem_cgroup_reclaim_on_contention() reclaim 
> > one or a very few page and return >0, then cause page allocation failure.
> > 
> > shouldn't we extend try_to_free_mem_cgroup_pages() agruments?
> > 
> > 
> > in addition, if we don't assume try_to_free_mem_cgroup_pages() need one page,
> > we should implement lumpy reclaim to mem_cgroup_isolate_pages().
> > otherwise, cpu wasting significant increase.
> 
> The memory controller currently controls just *user* pages, which are all of
> order 1. Since pages are faulted in at different times, lumpy reclaim was not
> the highest priority for the memory controller. NOTE: the pages are duplicated
> on the per-zone LRU, so lumpy reclaim from there should work just fine.

yes, memcg used only one page.
but mem_cgroup_reclaim_on_contention() reclaim for generic alloc_pages(), instead for memcg.
we can't assume memcg usage.
isn't it?




