Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZDUI1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZDUI1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZDUI1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:27:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56758 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZDUI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:27:35 -0400
Date: Tue, 21 Apr 2009 09:27:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only
	once
Message-ID: <20090421082732.GB12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-9-git-send-email-mel@csn.ul.ie> <1240299457.771.42.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240299457.771.42.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:37:37AM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> > get_page_from_freelist() can be called multiple times for an
> > allocation.
> > Part of this calculates the preferred_zone which is the first usable
> > zone in the zonelist. This patch calculates preferred_zone once.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 

Thanks

> > @@ -1772,11 +1774,20 @@ __alloc_pages_nodemask(gfp_t gfp_mask,
> > unsigned int order,
> >  	if (unlikely(!zonelist->_zonerefs->zone))
> >  		return NULL;
> >  
> > +	/* The preferred zone is used for statistics later */
> > +	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
> > +							&preferred_zone);
> > +	if (!preferred_zone)
> > +		return NULL;
> 
> You might want to add an explanation to the changelog why this change is
> safe. It looked like a functional change at first glance and it was
> pretty difficult to convince myself that __alloc_pages_slowpath() will
> always return NULL when there's no preferred zone because of the other
> cleanups in this patch series.
> 

Is this better?

get_page_from_freelist() can be called multiple times for an allocation.
Part of this calculates the preferred_zone which is the first usable zone in
the zonelist but the zone depends on the GFP flags specified at the beginning
of the allocation call. This patch calculates preferred_zone once. It's safe
to do this because if preferred_zone is NULL at the start of the call, no
amount of direct reclaim or other actions will change the fact the allocation
will fail.

> > +
> > +	/* First allocation attempt */
> >  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> > -			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
> > +			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
> > +			preferred_zone);
> >  	if (unlikely(!page))
> >  		page = __alloc_pages_slowpath(gfp_mask, order,
> > -				zonelist, high_zoneidx, nodemask);
> > +				zonelist, high_zoneidx, nodemask,
> > +				preferred_zone);
> >  
> >  	return page;
> >  }
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
