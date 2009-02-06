Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZBFMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZBFMeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 07:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZBFMeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 07:34:06 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43697 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZBFMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 07:34:05 -0500
Date: Fri, 6 Feb 2009 12:33:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <1233910649.29891.26.camel@penberg-laptop>
Message-ID: <Pine.LNX.4.64.0902061216001.23313@blonde.anvils>
References: <20090121143008.GV24891@wotan.suse.de> 
 <Pine.LNX.4.64.0901211705570.7020@blonde.anvils> 
 <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com> 
 <Pine.LNX.4.64.0901221239260.21677@blonde.anvils> 
 <Pine.LNX.4.64.0901231357250.9011@blonde.anvils>  <1233545923.2604.60.camel@ymzhang>
  <1233565214.17835.13.camel@penberg-laptop>  <1233646145.2604.137.camel@ymzhang>
  <Pine.LNX.4.64.0902031150110.5290@blonde.anvils>  <1233714090.2604.186.camel@ymzhang>
  <Pine.LNX.4.64.0902051839540.1445@blonde.anvils> <1233910649.29891.26.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Pekka Enberg wrote:
> On Thu, 2009-02-05 at 19:04 +0000, Hugh Dickins wrote:
> > I then tried a patch I thought obviously better than yours: just mask
> > off __GFP_WAIT in that __GFP_NOWARN|__GFP_NORETRY preliminary call to
> > alloc_slab_page(): so we're not trying to infer anything about high-
> > order availability from the number of free order-0 pages, but actually
> > going to look for it and taking it if it's free, forgetting it if not.
> > 
> > That didn't work well at all: almost as bad as the unmodified slub.c.
> > I decided that was due to __alloc_pages_internal()'s
> > wakeup_kswapd(zone, order): just expressing an interest in a high-
> > order page was enough to send it off trying to reclaim them, though
> > not directly.  Hacked in a condition to suppress that in this case:
> > worked a lot better, but not nearly as well as yours.  I supposed
> > that was somehow(?) due to the subsequent get_page_from_freelist()
> > calls with different watermarking: hacked in another __GFP flag to
> > break out to nopage just like the NUMA_BUILD GFP_THISNODE case does.
> > Much better, getting close, but still not as good as yours.  
> 
> Did you look at it with oprofile?

No, I didn't.  I didn't say so, but again it was elapsed time that
I was focussing on, so I don't think oprofile would be relevant.
There are some differences in system time, of course, consistent
with your point; but they're generally an order of magnitude less,
so didn't excite my interest.

> One thing to keep in mind is that if
> there are 4K allocations going on, your approach will get double the
> overhead of page allocations (which can be substantial performance hit
> for slab).

Sure, and even the current allocate_slab() is inefficient in that
respect: I've followed it because I do for now have an interest in
the stats, but if stats are configured off then there's no point in
dividing it into two stages; and if they are really intended to be
ORDER_FALLBACK stats, then it shouldn't divide into two stages when
oo_order(s->oo) == oo_order(s->min).  On the other hand, I find it
interesting to see how often the __GFP_NORETRY fails, even when
the order is the same each time (and usually 0).

Hugh
