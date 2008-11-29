Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYK2V6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYK2V6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYK2V6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:58:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbYK2V6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:58:05 -0500
Date: Sat, 29 Nov 2008 13:57:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-Id: <20081129135712.817e912c.akpm@linux-foundation.org>
In-Reply-To: <4931B5B1.8030601@redhat.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
	<20081128231933.8daef193.akpm@linux-foundation.org>
	<4931721D.7010001@redhat.com>
	<20081129094537.a224098a.akpm@linux-foundation.org>
	<493182C8.1080303@redhat.com>
	<20081129102608.f8228afd.akpm@linux-foundation.org>
	<49318CDE.4020505@redhat.com>
	<20081129105120.cfb8c035.akpm@linux-foundation.org>
	<49319109.7030904@redhat.com>
	<20081129122901.6243d2fa.akpm@linux-foundation.org>
	<4931B5B1.8030601@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 16:35:45 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 29 Nov 2008 13:59:21 -0500 Rik van Riel <riel@redhat.com> wrote:
> > 
> >> Andrew Morton wrote:
> >>> On Sat, 29 Nov 2008 13:41:34 -0500 Rik van Riel <riel@redhat.com> wrote:
> >>>
> >>>> Andrew Morton wrote:
> >>>>> On Sat, 29 Nov 2008 12:58:32 -0500 Rik van Riel <riel@redhat.com> wrote:
> >>>>>
> >>>>>>> Will this new patch reintroduce the problem which
> >>>>>>> 26e4931632352e3c95a61edac22d12ebb72038fe fixed?
> >>>> No, that problem is already taken care of by the fact that
> >>>> active pages always get deactivated in the current VM,
> >>>> regardless of whether or not they were referenced.
> >>> err, sorry, that was the wrong commit. 
> >>> 26e4931632352e3c95a61edac22d12ebb72038fe _introduced_ the problem, as
> >>> predicted in the changelog.
> >>>
> >>> 265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3 later fixed it up.
> >> The patch I sent in this thread does not do any baling out,
> >> it only skips zones where the number of free pages is more
> >> than 4 times zone->pages_high.
> > 
> > But that will have the same effect as baling out.  Moreso, in fact.
> 
> Kswapd already does the same in balance_pgdat.
> 
> Unequal pressure is sometimes desired, because allocation
> pressure is not equal between zones.  Having lots of
> lowmem allocations should not lead to gigabytes of swapped
> out highmem.  A numactl pinned application should not cause
> memory on other NUMA nodes to be swapped out.
> 
> Equal pressure between the zones makes sense when allocation
> pressure is similar.
> 
> When allocation pressure is different, we have a choice
> between evicting potentially useful data from memory or
> applying uneven pressure on zones.
> 
> >> Equal pressure is still applied to the other zones.
> >>
> >> This should not be a problem since we do not enter direct
> >> reclaim unless the free pages in every zone in our zonelist
> >> are below zone->pages_low.
> >>
> >> Zone skipping is only done by tasks that have been in the
> >> direct reclaim code for a long time.
> > 
> >>From 265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3:
> > 
> >     We currently have a problem with the balancing of reclaim
> >     between zones: much more reclaim happens against highmem than
> >     against lowmem.
> > 
> > This problem will be reintroduced, will it not?
> 
> We already have that behaviour in balance_pgdat().

I expect that was the case back in March 2004. 
265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3 removed the bale-out only for
the direct reclaim path.

> We do not do any reclaim on zones higher than the first
> zone where the zone_watermark_ok call returns true:
> 
>             if (!zone_watermark_ok(zone, order, zone->pages_high,
>                                                 0, 0)) {
>                       end_zone = i;
>                       break;
>             }
> 
> Further down in balance_pgdat(), we skip reclaiming from zones
> that have way too much memory free.
> 
>           /*
>            * We put equal pressure on every zone, unless one
>            * zone has way too many pages free already.
>            */
>           if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
>                                                  end_zone, 0))
>                    shrink_zone(priority, zone, &sc);
> 
> All my patch does is add one of these sanity checks to the
> direct reclaim path.

It's a change in behaviour, not a "sanity check"!

The bottom line here is that we don't fully understand the problem
which 265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3 fixed, hence we cannot
say whether this proposed change will reintroduce it.

Why did it matter that "much more reclaim happens against highmem than
against lowmem"?  What were the observeable effects of this?

