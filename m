Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0BPAK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:10:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0BPAKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:10:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ILVSARqOJvTsCOwIELPG/ng68XA7EZwY9PGwMUkrYDx8yvL0Iruf1I+YBie8g0zHp
	NWKb50S717nORDz1h16SA==
Date: Mon, 15 Feb 2010 16:10:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem
 allocations
In-Reply-To: <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com> <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > If memory has been depleted in lowmem zones even with the protection
> > afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
> > killing current users will help.  The memory is either reclaimable (or
> > migratable) already, in which case we should not invoke the oom killer at
> > all, or it is pinned by an application for I/O.  Killing such an
> > application may leave the hardware in an unspecified state and there is
> > no guarantee that it will be able to make a timely exit.
> > 
> > Lowmem allocations are now failed in oom conditions so that the task can
> > perhaps recover or try again later.  Killing current is an unnecessary
> > result for simply making a GFP_DMA or GFP_DMA32 page allocation and no
> > lowmem allocations use the now-deprecated __GFP_NOFAIL bit so retrying is
> > unnecessary.
> > 
> > Previously, the heuristic provided some protection for those tasks with 
> > CAP_SYS_RAWIO, but this is no longer necessary since we will not be
> > killing tasks for the purposes of ISA allocations.
> > 
> > high_zoneidx is gfp_zone(gfp_flags), meaning that ZONE_NORMAL will be the
> > default for all allocations that are not __GFP_DMA, __GFP_DMA32,
> > __GFP_HIGHMEM, and __GFP_MOVABLE on kernels configured to support those
> > flags.  Testing for high_zoneidx being less than ZONE_NORMAL will only
> > return true for allocations that have either __GFP_DMA or __GFP_DMA32.
> > 
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  mm/page_alloc.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1914,6 +1914,9 @@ rebalance:
> >  	 * running out of options and have to consider going OOM
> >  	 */
> >  	if (!did_some_progress) {
> > +		/* The oom killer won't necessarily free lowmem */
> > +		if (high_zoneidx < ZONE_NORMAL)
> > +			goto nopage;
> >  		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> >  			if (oom_killer_disabled)
> >  				goto nopage;
> 
> WARN_ON((high_zoneidx < ZONE_NORMAL) && (gfp_mask & __GFP_NOFAIL))
> plz.
> 

As I already explained when you first brought this up, the possibility of 
not invoking the oom killer is not unique to GFP_DMA, it is also possible 
for GFP_NOFS.  Since __GFP_NOFAIL is deprecated and there are no current 
users of GFP_DMA | __GFP_NOFAIL, that warning is completely unnecessary.  
We're not adding any additional __GFP_NOFAIL allocations.
