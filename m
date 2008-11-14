Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYKNEbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYKNEbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYKNEbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:31:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39995 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKNEbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:31:06 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081111144224.GA7826@csn.ul.ie>
References: <20081111221059.8B44.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081111144224.GA7826@csn.ul.ie>
Message-Id: <20081114121005.0D1F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 14 Nov 2008 13:31:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for late responce.
Honestly, I have many bisiness trip in this month ;-)


> > > > > What your patch may help is the situation where the system is under intense
> > > > > memory pressure, is dipping routinely into the lowmem reserves and mixing
> > > > > with high-order atomic allocations. This seems a bit extreme.
> > > > 
> > > > not so extreame.
> > > > 
> > > > The linux page reclaim can't process in interrupt context.
> > > > Sl network subsystem and driver often use MIGRATE_RESERVE memory although
> > > > system have many reclaimable memory.
> > > > 
> > > 
> > > Why are they often using MIGRATE_RESERVE, have you confirmed that? For that
> > > to be happening, it implies that either memory is under intense pressure and
> > > free pages are often below watermarks due to interrupt contexts or they are
> > > frequently allocating high-order pages in interrupt context. Normal order-0
> > > allocations should be getting satisified from elsewhere as if the free page
> > > counts are low, they would be direct reclaiming and that will likely be
> > > outside of the MIGRATE_RESERVE areas.
> > 
> > if inserting printk() in MIGRATE_RESERVE, I can observe MIGRATE_RESERVE
> > page alloc easily although heavy workload don't run.
> > but, there aren't my point.
> > 
> 
> That's interesting. What is the size of a pageblock on your system and
> is min_free_kbytes aligned to that value? If it's not aligned, it would
> explain why MIGRATE_RESERVE pages are being used before the watermarks
> are hit.

hmm, I don't have it yet.
ok, I should investigate more.


> > ok, I guess my patch description was too poor (and a bit pointless).
> > So, I retry it.
> > 
> > (1) in general principal, the system should effort to avoid oom rather than
> >     performance if memory shortage happend.
> >     MIGRATE_RESERVE directly indicate memory shortage happend.
> >     and pcp caching can prevent another cpu allocation.
> 
> MIGRATE_RESERVE does not directly indicate a memory shortage has
> occured. Bear in mind that a number of pageblocks are marked
> MIGRATE_RESERVE based on the value of the watermarks. In general, the
> minimum number of pages kept free will be in the MIGRATE_RESERVE blocks
> but it is not mandatory.
> 
> > (2) MIGRATE_RESERVE is never searched by buffered_rmqueue() because 
> >     allocflags_to_migratetype() never return MIGRATE_RESERVE.
> >     it doesn't work as cache.
> >     IOW, it don't help to increase performance.
> 
> This is true. If MIGRATE_RESERVE pages are routinely being used and placed
> on the pcp lists, the lists are not being used to their full potential
> and your patch would make sense.
> 
> > (3) if the system pass MIGRATE_RESERVE to free_hot_cold_page() continously,
> >     pcp queueing can reduce the number of grabing zone->lock.
> >     However, it is rate. because MIGRATE_RESERVE is emergency memory,
> 
> Again, MIGRATE_RESERVE is not emergency memory.
> 
> >     and it is often used interupt context processing.
> >     continuous emergency memory allocation in interrupt context isn't so sane.
> > 
> > Then, unqueueing MIGRATE_RESERVE page doesn't cause performance degression
> > and, it can (a bit) increase realibility and I think merit is much over demerit.
> > 
> 
> I'm now inclined to agree if you have shown that MIGRATE_RESERVE pages are
> routinely ending up on the PCP lists.

Thanks!

So, now, I have two todo issue.
  - I should mesure performance.
  - I should investigate why MIGRATE_RESERVE is used on my machine.

I expect I finish to the end of next week.

> > Yup, I believe at that time your decision is right.
> > However, I think the condision was changed (or to be able to change).
> > 
> >  (1) legacy pcp implementation deeply relate to struct zone size.
> >      and, to blow up struct zone size cause performance degression
> >      because cache miss increasing.
> >      However, it solved cristoph's cpu-alloc patch
> 
> Indeed.
> 
> >  (2) legacy pcp doesn't have total number of pages restriction.
> >      So, increasing lists directly cause number of pages in pcp.
> >      it can cause oom problem on large numa environment.
> >      However, I think we can implement total number of pages restriction.
> > 
> 
> Yes although knowing what the right size for each of the lists should be
> so that the overall PCP lists are not huge is a tricky one.

Thank you for good advice.




