Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbZDAJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbZDAJGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbZDAJGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:06:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762528AbZDAJGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:06:20 -0400
Date: Wed, 1 Apr 2009 18:04:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan:
 rename  sc.may_swap to may_unmap)
Message-Id: <20090401180445.80b11d90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090401040951.GA1548@cmpxchg.org>
References: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
	<20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331104625.B1C7.A69D9226@jp.fujitsu.com>
	<20090401040951.GA1548@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 06:09:51 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Mar 31, 2009 at 10:48:32AM +0900, KOSAKI Motohiro wrote:
> > > > Sorry for too late response.
> > > > I don't know memcg well.
> > > > 
> > > > The memcg managed to use may_swap well with global page reclaim until now.
> > > > I think that was because may_swap can represent both meaning.
> > > > Do we need each variables really ?
> > > > 
> > > > How about using union variable ?
> > > 
> > > or Just removing one of them  ?
> > 
> > I hope all may_unmap user convert to using may_swap.
> > may_swap is more efficient and cleaner meaning.
> 
> How about making may_swap mean the following:
> 
> 	@@ -642,6 +639,8 @@ static unsigned long shrink_page_list(st
> 	 		 * Try to allocate it some swap space here.
> 	 		 */
> 	 		if (PageAnon(page) && !PageSwapCache(page)) {
> 	+			if (!sc->map_swap)
> 	+				goto keep_locked;
> 	 			if (!(sc->gfp_mask & __GFP_IO))
> 	 				goto keep_locked;
> 	 			if (!add_to_swap(page))
> 
> try_to_free_pages() always sets it.
> 
What is the advantage than _not_ scanning ANON LRU at all ?

> try_to_free_mem_cgroup_pages() sets it depending on whether it really
> wants swapping, and only swapping, right?  But the above would still
> reclaim already swapped anon pages and I don't know the memory
> controller.
> 
memory cgroup has 2 calls to this shrink_zone.
 1. memory usage hits the limit.
 2. mem+swap usage hits the limit.

At "2", swap-out doesn't decrease the usage of mem+swap, then set may_swap=0.
So, we want to kick out only file caches.
But, we can reclaim file cache and "unmap file cache and reclaim it!" is 
necessary even if may_swap=0.

Then, scanning only FILE LRU makes sense at may_swap=0 *if* memcg is
the only user of may_swap=0.

Let's see others.

 - __zone_reclaim sets may_unmap to be 0 when they don't want swap-out.
   .....can be replaced with may_swap.

 - shrink_all_memory sets may_swap to be 0. Is this called by hibernation ?
   If you don't want to unmap file caches while hibernation, adding may_unmap
   as *new* paramter makes sense, I think.

The change you proposed is for dropping unused SwapCache pages. Right ?
But this will be dropped by kswapd if necessary.

As far as memcg concerns, scanning ANON LRU even when may_swap=0 is just
a waste of cpu time.

Thanks,
-Kame

