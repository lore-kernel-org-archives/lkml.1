Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZIIPEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZIIPEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZIIPEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:04:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41457 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZIIPEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:04:14 -0400
Date: Wed, 9 Sep 2009 16:04:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090909150418.GI24614@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com> <200909061028.48442.elendil@planet.nl> <1252226116.11274.10.camel@penberg-laptop> <20090908105415.GD28127@csn.ul.ie> <84144f020909080411n4e010308qa153039bee1b8336@mail.gmail.com> <20090908141701.GB2617@tuxdriver.com> <4AA67139.80301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4AA67139.80301@lwfinger.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 09:59:05AM -0500, Larry Finger wrote:
> John W. Linville wrote:
> > On Tue, Sep 08, 2009 at 02:11:35PM +0300, Pekka Enberg wrote:
> >> On Tue, Sep 8, 2009 at 1:54 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> >>> My feeling is also that a number of these page allocation failures have
> >>> been related to wireless drivers. Is that accurate? If so, have there
> >>> been changes made to the wireless stack in this cycle that would have
> >>> increased the order of pages allocated?
> >> That's my general feeling as well. We have linux-wireless CC'd so
> >> maybe this rings a bell for them.
> > 
> > AFAIK, this is only the second separate report.  The other related
> > to ipw2200, which actually shares no code with the iwlagn driver and
> > is not based on the mac80211 stack.
> 
> A previous issue concerned the interaction between wireless and SLUB
> debugging that caused O(0) allocations to get bumped to O(1), but that

Ok, but now they are getting bumped to order-2 because that is the allocation
failure that's happening here. That's pretty risky for a __GFP_HIGH|__GFP_COMP
allocation - i.e. high-priority and atomic allocation.

> was not relevant to this case either. I'm not aware of any other page
> allocation problems with wireless.
> 

Are atomic order-2 allocations really expected in wireless or has something
else changed recently? Other than slub-debug, what options have been
recently added that can push kmalloc() requests up slightly and possible
make an order-1 allocation an order-2? If it's not in wireless, has there
been additional padding added to skbuffs in the networking layer that might
have pushed an allocation over an order-1 boundary increasing the size of
the allocation to order-2?

The reporter says that the machine grinds for a bit and recovers which
is consistent with kswapd kicking in to reclaim the contiguous pages but
it's hardly desirable.

Franz, in the full dmesg was there any mention of "SLUB: Unable to allocate
memory on node"? If so, could you post the contents of that as well because
it should tell us more about the slab allocation that failed which vaguely
looks like the path that went splat. Also, did you have any slub debug
options enabled on the command line?

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
