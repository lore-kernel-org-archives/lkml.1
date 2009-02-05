Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZBETFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZBETFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZBETFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:05:05 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42937 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZBETFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:05:03 -0500
Date: Thu, 5 Feb 2009 19:04:14 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <1233714090.2604.186.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0902051839540.1445@blonde.anvils>
References: <20090121143008.GV24891@wotan.suse.de> 
 <Pine.LNX.4.64.0901211705570.7020@blonde.anvils> 
 <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com> 
 <Pine.LNX.4.64.0901221239260.21677@blonde.anvils> 
 <Pine.LNX.4.64.0901231357250.9011@blonde.anvils>  <1233545923.2604.60.camel@ymzhang>
  <1233565214.17835.13.camel@penberg-laptop>  <1233646145.2604.137.camel@ymzhang>
  <Pine.LNX.4.64.0902031150110.5290@blonde.anvils> <1233714090.2604.186.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Zhang, Yanmin wrote:
> On Tue, 2009-02-03 at 12:18 +0000, Hugh Dickins wrote:
> > On Tue, 3 Feb 2009, Zhang, Yanmin wrote:
> > > 
> > > Would you like to test it on your machines?
> > 
> > Indeed I shall, starting in a few hours when I've finished with trying
> > the script I promised yesterday to send you.  And I won't be at all
> > surprised if your patch eliminates my worst cases, because I don't
> > expect to have any significant amount of free memory during my testing,
> > and my swap testing suffers from slub's thirst for higher orders.
> > 
> > But I don't believe the kind of check you're making is appropriate,
> > and I do believe that when you try more extensive testing, you'll find
> > regressions in other tests which were relying on the higher orders.
> 
> Yes, I agree. And we need find such tests which causes both memory used up
> and lots of higher-order allocations.

Sceptical though I am about your free_pages test in slub's allocate_slab(),
I can confirm that your patch does well on my swapping loads, performing
slightly (not necessarily significantly) better than slab on those loads
(though not quite as well on the "immune" machine where slub was already
keeping up with slab; and I haven't even bothered to try it on the machine
which behaves so very badly that no conclusions can yet be drawn).

I then tried a patch I thought obviously better than yours: just mask
off __GFP_WAIT in that __GFP_NOWARN|__GFP_NORETRY preliminary call to
alloc_slab_page(): so we're not trying to infer anything about high-
order availability from the number of free order-0 pages, but actually
going to look for it and taking it if it's free, forgetting it if not.

That didn't work well at all: almost as bad as the unmodified slub.c.
I decided that was due to __alloc_pages_internal()'s
wakeup_kswapd(zone, order): just expressing an interest in a high-
order page was enough to send it off trying to reclaim them, though
not directly.  Hacked in a condition to suppress that in this case:
worked a lot better, but not nearly as well as yours.  I supposed
that was somehow(?) due to the subsequent get_page_from_freelist()
calls with different watermarking: hacked in another __GFP flag to
break out to nopage just like the NUMA_BUILD GFP_THISNODE case does.
Much better, getting close, but still not as good as yours.  

I think I'd better turn back to things I understand better!

Hugh
