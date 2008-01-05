Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYAEUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYAEUSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYAEUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:16:29 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757294AbYAEUQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:16:23 -0500
Date: Sat, 5 Jan 2008 12:16:22 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <1199485818.3821.46.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801051206580.14866@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801041223250.11479@schroedinger.engr.sgi.com> 
 <1199480150.3821.23.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801041321490.12189@schroedinger.engr.sgi.com>
 <1199485818.3821.46.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Matt Mackall wrote:

> > SLUB 32	    (all memory of the 4k page is used for 128 byte objects)
> > SLAB 29/30  (management structure occupies first two/three objects)
> > SLOB 30(?)  (Alignment results in object being 136 byte of effective size,
> > 		we have 16 bytes leftover that could be used for a
> > 		very small allocation. Right?)
> 
> Don't know how you got to 136, the minimum alignment is 4 on x86. But I

Right I am thinking about 64 bit systems where the alignment is 8 bytes.

> already said in my last email that SLUB would win for the special case
> of power of two allocations. But as long as we're looking at worst
> cases, let's consider an alloc of 257 bytes..

Yup that hits it by forcing a rounding up to a size of 512 bytes because 
there is no intermediate cache size before 1024. The rounding up is 
a pretty weak spot in terms of memory use.

> SLUB  8 (1016 bytes wasted)
> SLOB 15 (105 bytes wasted, with 136 bytes still usable)

Well we can actually turn this around. What I gave was not actually the 
worst case for SLOB. The worst case is an 8 byte allocation where SLOB 
needs double the memory of SLUB.

SLUB 	512	(Nothing wasted)
SLOB 	256	(Half of the page wasted for metadata)
SLAB	119	(32 byte mininum alloc size + management struct needs)

But these are all extreme cases. Depends on the mix of allocs who wins and 
from what I can tell the avoiding of rounding up to a power of two gives 
SLOB a key advantage. If we would find the worst offenders there and use 
kmem_cache_alloc instead then we may be able to offset that advantage.



