Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbXGJCco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbXGJCco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbXGJCcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:32:35 -0400
Received: from waste.org ([66.93.16.53]:53395 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418AbXGJCce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:32:34 -0400
Date: Mon, 9 Jul 2007 21:32:05 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070710023205.GD11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <4692E3BF.9010305@yahoo.com.au> <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 06:51:51PM -0700, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> > > O(n) memory savings? What is that?
> > 
> > Allocate n things and your memory waste is proportional to n (well that's
> > O(n) waste, so I guess by savings I mean that SLOB's memory saving compared
> > to SLUB are proportional to n).
> 
> n is the size of the object?
> 
> Its linear correlated to the object size. It does not grow 
> exponentially as object size grows. Waste in the kmalloc array in the 
> worst case is < objsize.

N is the number of objects.

So, for large N, the overhead of SLUB of allocations of size m, where
m % alignment == 0 (for simplicity):

 kmem_cache_alloc case:

  (PAGE_SIZE % m) / m

 kmalloc case:

  nextpowerof2(m) - m

And for SLOB (with Nick's improvements):

 kmem_cache_alloc case:

  0 (the remainder of the page is usable for other allocs)

 kmalloc case:

  2 bytes (or whatever the minimal arch alignment is)

SLUB wins by two bytes on kmallocs that happen to be a power of two,
ties on kmem_cache_allocs that happen to evenly divide PAGE_SIZE and
kmallocs 2 bytes smaller than a power of 2, and loses everywhere else.

It also loses whenever a particular type/size has both short-lived and
long-lived objects because of pinning. This effect is worse on small
machines as it's easier to pin all of memory.

The downsides of current SLOB are:

 - single lock
 - potentially long walks to find free blocks

The average case walk has been shortened quite a bit by Nick's
patches. The combinatorics here are enough to make Knuth hand-wave,
but we can in theory get close to O(1) performance when we don't have
much memory pressure. Needs some serious benchmarking. When we DO have
memory pressure, both SLOB and SLUB will degrade to forcing the kernel
to walk a bunch of pages.

-- 
Mathematics is the supreme nostalgia of our time.
