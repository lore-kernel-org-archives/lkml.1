Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYAJTYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYAJTYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYAJTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:24:15 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53170 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755495AbYAJTYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:24:13 -0500
Date: Thu, 10 Jan 2008 11:24:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199990565.5331.130.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801101118070.20353@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> 
 <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
  <1199919548.6245.74.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> 
 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> 
 <1199987366.5331.92.camel@cinder.waste.org> 
 <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org>
 <1199990565.5331.130.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Matt Mackall wrote:

> One idea I've been kicking around is pushing the boundary for the buddy
> allocator back a bit (to 64k, say) and using SL*B under that. The page
> allocators would call into buddy for larger than 64k (rare!) and SL*B
> otherwise. This would let us greatly improve our handling of things like
> task structs and skbs and possibly also things like 8k stacks and jumbo
> frames. As SL*B would never be competing with the page allocator for
> contiguous pages (the buddy allocator's granularity would be 64k), I
> don't think this would exacerbate the page-level fragmentation issues.

This would create another large page size (and that would have my 
enthusiastic support). It would decrease listlock effect drastically for 
SLUB. Even the initial simplistic implementation of SLUB was superior on 
the database transaction tests (I think it was up ~1%) on IA64 from the 
get go. Likely due to the larger 16k page size there. The larger page size 
could also be used for the page cache (ducking and running.....)? A 64k 
page size that could be allocated without zone locks would be very good 
for SLUB.

However, isnt this is basically confessing that the page allocator is not 
efficient for 4k page allocations? I have seen some weaknesses there. The 
overhead in the allocation path in particular is bad and I was thinking 
about applying the same ideas used in SLUB also to the page allocator in 
order to bring the cycle count down from 500-1000 to 60 or so. Since both 
SLUB and SLOB use the page allocator for allocs >PAGE_SIZE this would not 
only benefit the general kernel but also the slab allocations.
