Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYFWJ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYFWJ4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYFWJ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:56:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3229 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYFWJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:56:30 -0400
Date: Mon, 23 Jun 2008 10:53:10 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma splits
Message-ID: <20080623095310.GH29804@shadowen.org>
References: <1213989474-5586-1-git-send-email-apw@shadowen.org> <1213989474-5586-3-git-send-email-apw@shadowen.org> <20080623080048.GJ21597@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623080048.GJ21597@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 09:00:48AM +0100, Mel Gorman wrote:
> Typical. I spotted this after I pushed send.....
> 
> > <SNIP>
> 
> > @@ -266,14 +326,19 @@ static void decrement_hugepage_resv_vma(struct hstate *h,
> >  		 * private mappings.
> >  		 */
> >  		if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> > -			unsigned long flags, reserve;
> > +			unsigned long idx = vma_pagecache_offset(h,
> > +							vma, address);
> > +			struct resv_map *reservations = vma_resv_map(vma);
> > +
> >  			h->resv_huge_pages--;
> > -			flags = (unsigned long)vma->vm_private_data &
> > -							HPAGE_RESV_MASK;
> > -			reserve = (unsigned long)vma->vm_private_data - 1;
> > -			vma->vm_private_data = (void *)(reserve | flags);
> > +
> > +			/* Mark this page used in the map. */
> > +			if (region_chg(&reservations->regions, idx, idx + 1) < 0)
> > +				return -1;
> > +			region_add(&reservations->regions, idx, idx + 1);
> >  		}
> 
> decrement_hugepage_resv_vma() is called with hugetlb_lock held and region_chg
> calls kmalloc(GFP_KERNEL).  Hence it's possible we would sleep with that
> spinlock held which is a bit uncool. The allocation needs to happen outside
> the lock. Right?

Yes, good spot.  Luckily this pair of calls can be separated, as the
first is a prepare and the second a commit.  So I can trivially pull
the allocation outside the lock.

Had a quick go at this and it looks like I can move both out of the lock
to a much more logical spot and clean the patch up significantly.  Will
fold in your other comments and post up a V2 once it has been tested.

Thanks.

-apw
