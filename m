Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbXILXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbXILXG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXILXGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:06:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40143 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835AbXILXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:06:47 -0400
Date: Wed, 12 Sep 2007 16:06:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709120407.48344.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
 <200709120407.48344.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Nick Piggin wrote:

> In my attack, I cause the kernel to allocate lots of unmovable allocations
> and deplete movable groups. I theoretically then only need to keep a
> small number (1/2^N) of these allocations around in order to DoS a
> page allocation of order N.

True. That is why we want to limit the number of unmovable allocations and 
that is why ZONE_MOVABLE exists to limit those. However, unmovable 
allocations are already rare today. The overwhelming majority of 
allocations are movable and reclaimable. You can see that f.e. by looking 
at /proc/meminfo and see how high SUnreclaim: is (does not catch 
everything but its a good indicator).

> Now there are lots of other little heuristics, *including lumpy reclaim
> and various slab reclaim improvements*, that improve the effectiveness
> or speed of this thing, but at the end of the day, it has the same basic

All of these methods also have their own purpose aside from the mobility 
patches.

> issues. Unless you can move practically any currently unmovable
> allocation (which will either be a lot of intrusive code or require a
> vmapped kernel), then you can't get around the fundamental problem.
> And if you do get around the fundamental problem, you don't really
> need to group pages by mobility any more because they are all
> movable[*].
> 
> So lumpy reclaim does not change my formula nor significantly help
> against a fragmentation attack. AFAIKS.

Lumpy reclaim improves the situation significantly because the 
overwhelming majority of allocation during the lifetime of a systems are 
movable and thus it is able to opportunistically restore the availability 
of higher order pages by reclaiming neighboring pages.

> [*] ok, this isn't quite true because if you can actually put a hard limit on
> unmovable allocations then anti-frag will fundamentally help -- get back to
> me on that when you get patches to move most of the obvious  ones.

We have this hard limit using ZONE_MOVABLE in 2.6.23.

> > The patch currently only supports 64k.
> 
> Sure, and I pointed out the theoretical figure for 64K pages as well. Is that
> figure not problematic to you? Where do you draw the limit for what is
> acceptable? Why? What happens with tiny memory machines where a reserve
> or even the anti-frag patches may not be acceptable and/or work very well?
> When do you require reserve pools? Why are reserve pools acceptable for
> first-class support of filesystems when it has been very loudly been made a
> known policy decision by Linus in the past (and for some valid reasons) that
> we should not put limits on the sizes of caches in the kernel.

64K pages may problematic because it is above the PAGE_ORDER_COSTLY in 
2.6.23. 32K is currently much safer because lumpy reclaim can restore 
these and does so on my systems. I expect the situation for 64K pages to 
improve when more of Mel's patches go in. We have long term experience 
with 32k sized allocation through Andrew's tree.

Reserve pools as handled (by the not yet available) large page pool 
patches (which again has altogether another purpose) are not a limit. The 
reserve pools are used to provide a mininum of higher order pages that is 
not broken down in order to insure that a mininum number of the desired 
order of pages is even available in your worst case scenario. Mainly I 
think that is needed during the period when memory defragmentation is 
still under development.
