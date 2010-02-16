Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0BPFcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:32:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50184 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0BPFcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:32:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem allocations
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
References: <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
Message-Id: <20100216142856.72F4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 14:32:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > If memory has been depleted in lowmem zones even with the protection
> > > afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
> > > killing current users will help.  The memory is either reclaimable (or
> > > migratable) already, in which case we should not invoke the oom killer at
> > > all, or it is pinned by an application for I/O.  Killing such an
> > > application may leave the hardware in an unspecified state and there is
> > > no guarantee that it will be able to make a timely exit.
> > > 
> > > Lowmem allocations are now failed in oom conditions so that the task can
> > > perhaps recover or try again later.  Killing current is an unnecessary
> > > result for simply making a GFP_DMA or GFP_DMA32 page allocation and no
> > > lowmem allocations use the now-deprecated __GFP_NOFAIL bit so retrying is
> > > unnecessary.
> > > 
> > > Previously, the heuristic provided some protection for those tasks with 
> > > CAP_SYS_RAWIO, but this is no longer necessary since we will not be
> > > killing tasks for the purposes of ISA allocations.
> > > 
> > > high_zoneidx is gfp_zone(gfp_flags), meaning that ZONE_NORMAL will be the
> > > default for all allocations that are not __GFP_DMA, __GFP_DMA32,
> > > __GFP_HIGHMEM, and __GFP_MOVABLE on kernels configured to support those
> > > flags.  Testing for high_zoneidx being less than ZONE_NORMAL will only
> > > return true for allocations that have either __GFP_DMA or __GFP_DMA32.
> > > 
> > > Acked-by: Rik van Riel <riel@redhat.com>
> > > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  mm/page_alloc.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1914,6 +1914,9 @@ rebalance:
> > >  	 * running out of options and have to consider going OOM
> > >  	 */
> > >  	if (!did_some_progress) {
> > > +		/* The oom killer won't necessarily free lowmem */
> > > +		if (high_zoneidx < ZONE_NORMAL)
> > > +			goto nopage;
> > >  		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> > >  			if (oom_killer_disabled)
> > >  				goto nopage;
> > 
> > WARN_ON((high_zoneidx < ZONE_NORMAL) && (gfp_mask & __GFP_NOFAIL))
> > plz.
> > 
> 
> As I already explained when you first brought this up, the possibility of 
> not invoking the oom killer is not unique to GFP_DMA, it is also possible 
> for GFP_NOFS.  Since __GFP_NOFAIL is deprecated and there are no current 
> users of GFP_DMA | __GFP_NOFAIL, that warning is completely unnecessary.  
> We're not adding any additional __GFP_NOFAIL allocations.

No current user? I don't think so.

	int bio_integrity_prep(struct bio *bio)
	{
	(snip)
	        buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->bounce_gfp);

and 

	void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
	{
	(snip)
	        if (dma) {
	                init_emergency_isa_pool();
	                q->bounce_gfp = GFP_NOIO | GFP_DMA;
	                q->limits.bounce_pfn = b_pfn;
	        }



I don't like rumor based discussion, I like fact based one.

Thanks.



