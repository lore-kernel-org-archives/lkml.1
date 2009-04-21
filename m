Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZDUJ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZDUJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUJzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:55:55 -0400
Received: from cmpxchg.org ([85.214.51.133]:49189 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbZDUJzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:55:54 -0400
Date: Tue, 21 Apr 2009 11:54:29 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-ID: <20090421095429.GB3639@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org> <1240259085-25872-3-git-send-email-hannes@cmpxchg.org> <20090421095857.b989ce44.kamezawa.hiroyu@jp.fujitsu.com> <20090421085231.GB2527@cmpxchg.org> <20090421182331.5c96615e.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421182331.5c96615e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:23:31PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 21 Apr 2009 10:52:31 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > Keeping multiple pages locked while they stay on private list ? 
> > 
> > Yeah, it's a bit suboptimal but I don't see a way around it.
> > 
> Hmm, seems to increase stale swap cache dramatically under memcg ;)

Hmpf, not good.

> > > BTW, isn't it better to add "allocate multiple swap space at once" function
> > > like
> > >  - void get_swap_pages(nr, swp_entry_array[])
> > > ? "nr" will not be bigger than SWAP_CLUSTER_MAX.
> > 
> > It will sometimes be, see __zone_reclaim().
> > 
> Hm ? If I read the code correctly, __zone_reclaim() just call shrink_zone() and
> "nr" to shrink_page_list() is SWAP_CLUSTER_MAX, at most.

shrink_zone() and shrink_inactive_list() use whatever is set in
sc->swap_cluster_max and for __zone_reclaim() this is:

	.swap_cluster_max = max_t(unsigned long, nr_pages, SWAP_CLUSTER_MAX)

SWAP_CLUSTER_MAX is 32 (2^5), so if you have an order 6 allocation
doing reclaim, you end up with sc->swap_cluster_max == 64 already.
Not common, but it happens.

> > I had such a function once.  The interesting part is: how and when do
> > you call it?  If you drop the page lock in between, you need to redo
> > the checks for unevictability and whether the page has become mapped
> > etc.
> > 
> > You also need to have the pages in swap cache as soon as possible or
> > optimistic swap-in will 'steal' your swap slots.  See add_to_swap()
> > when the cache radix tree says -EEXIST.
> > 
> 
> If I was you, modify "offset" calculation of
>   get_swap_pages()
>      -> scan_swap_map()
> to allow that a cpu  tends to find countinous swap page cluster.
> Too difficult ?

This goes in the direction of extent-based allocations.  I tried that
once by providing every reclaimer with a cookie that is passed in for
swap allocations and used to find per-reclaimer offsets.

Something went wrong, I can not quite remember.  Will have another
look at this.
