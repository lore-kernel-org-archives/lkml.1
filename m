Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYAJTmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYAJTmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYAJTmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:42:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYAJTmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:42:31 -0500
Date: Thu, 10 Jan 2008 11:41:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199990565.5331.130.camel@cinder.waste.org>
Message-ID: <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>  <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>  <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>  <1199314218.4497.109.camel@cinder.waste.org> 
 <20080103085239.GA10813@elte.hu>  <1199378818.8274.25.camel@cinder.waste.org>  <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>  <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> 
 <1199641910.8215.28.camel@cinder.waste.org>  <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>  <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>  <1199919548.6245.74.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>  <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>  <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>  <1199987366.5331.92.camel@cinder.waste.org> 
 <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org> <1199990565.5331.130.camel@cinder.waste.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Matt Mackall wrote:
> 
> One idea I've been kicking around is pushing the boundary for the buddy
> allocator back a bit (to 64k, say) and using SL*B under that. The page
> allocators would call into buddy for larger than 64k (rare!) and SL*B
> otherwise. This would let us greatly improve our handling of things like
> task structs and skbs and possibly also things like 8k stacks and jumbo
> frames.

Yes, something like that may well be reasonable. It could possibly solve 
some of the issues for bigger page cache sizes too, but one issue is that 
many things actually end up having those power-of-two alignment 
constraints too - so an 8kB allocation would often still have to be 
naturally aligned, which then removes some of the freedom.

> Crazy?

It sounds like it might be worth trying out - there's just no way to know 
how well it would work. Buddy allocators sure as hell have problems too, 
no question about that. It's not like the page allocator is perfect.

It's not even clear that a buddy allocator even for the high-order pages 
is at all the right choice. Almost nobody actually wants >64kB blocks, and 
the ones that *do* want bigger allocations tend to want *much* bigger 
ones, so it's quite possible that it could be worth it to have something 
like a three-level allocator:

 - huge pages (superpages for those crazy db people)

   Just a simple linked list of these things is fine, we'd never care 
   about coalescing large pages together anyway.

 - "large pages" (on the order of ~64kB) - with *perhaps* a buddy bitmap 
   setup to try to coalesce back into huge-pages, but more likely just 
   admitting that you'd need something like migration to ever get back a 
   hugepage that got split into large-pages.

   So maybe a simple bitmap allocator per huge-page for large pages. Say 
   you have a 4MB huge-page, and just a 64-bit free-bitmap per huge-page 
   when you split it into large pages.

 - slab/slub/slob for anything else, and "get_free_page()" ends up being 
   just a shorthand for saying "naturally aligned kmalloc of size 
   "PAGE_SIZE<<order"

and maybe it would all work out ok. 

			Linus
