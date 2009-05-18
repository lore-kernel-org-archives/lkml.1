Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZERDxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZERDxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZERDxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:53:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:9449 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZERDxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143894046"
Date: Mon, 18 May 2009 11:53:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: change the number of the unmapped files in
	zone reclaim
Message-ID: <20090518035319.GA7940@localhost>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120606.587C.A69D9226@jp.fujitsu.com> <20090518031536.GC5869@localhost> <2f11576a0905172035k3f26b8d6r84af555a94b1d70e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f11576a0905172035k3f26b8d6r84af555a94b1d70e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 11:35:31AM +0800, KOSAKI Motohiro wrote:
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -2397,6 +2397,7 @@ static int __zone_reclaim(struct zone *z
> >>               .isolate_pages = isolate_pages_global,
> >>       };
> >>       unsigned long slab_reclaimable;
> >> +     long nr_unmapped_file_pages;
> >>
> >>       disable_swap_token();
> >>       cond_resched();
> >> @@ -2409,9 +2410,11 @@ static int __zone_reclaim(struct zone *z
> >>       reclaim_state.reclaimed_slab = 0;
> >>       p->reclaim_state = &reclaim_state;
> >>
> >> -     if (zone_page_state(zone, NR_FILE_PAGES) -
> >> -             zone_page_state(zone, NR_FILE_MAPPED) >
> >> -             zone->min_unmapped_pages) {
> >> +     nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
> >> +                              zone_page_state(zone, NR_ACTIVE_FILE) -
> >> +                              zone_page_state(zone, NR_FILE_MAPPED);
> >
> > This can possibly go negative.
> 
> Is this a problem?
> negative value mean almost pages are mapped. Thus
> 
>   (nr_unmapped_file_pages > zone->min_unmapped_pages)  => 0
> 
> is ok, I think.

I wonder why you didn't get a gcc warning, because zone->min_unmapped_pages
is a "unsigned long".

Anyway, add a simple note to the code if it works *implicitly*?

Thanks,
Fengguang

> >
> >> +     if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
> >>               /*
> >>                * Free memory by calling shrink zone with increasing
> >>                * priorities until we have enough memory freed.
