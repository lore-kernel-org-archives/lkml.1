Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYAJTp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYAJTp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYAJTps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:45:48 -0500
Received: from waste.org ([66.93.16.53]:60676 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYAJTpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:45:46 -0500
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801101118070.20353@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <1199987366.5331.92.camel@cinder.waste.org>
	 <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org>
	 <1199990565.5331.130.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101118070.20353@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 13:44:42 -0600
Message-Id: <1199994282.5331.173.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 11:24 -0800, Christoph Lameter wrote:
> On Thu, 10 Jan 2008, Matt Mackall wrote:
> 
> > One idea I've been kicking around is pushing the boundary for the buddy
> > allocator back a bit (to 64k, say) and using SL*B under that. The page
> > allocators would call into buddy for larger than 64k (rare!) and SL*B
> > otherwise. This would let us greatly improve our handling of things like
> > task structs and skbs and possibly also things like 8k stacks and jumbo
> > frames. As SL*B would never be competing with the page allocator for
> > contiguous pages (the buddy allocator's granularity would be 64k), I
> > don't think this would exacerbate the page-level fragmentation issues.
> 
> This would create another large page size (and that would have my 
> enthusiastic support).

Well, I think we'd still have the same page size, in the sense that we'd
have a struct page for every hardware page and we'd still have hardware
page-sized pages in the page cache. We'd just change how we allocated
them. Right now we've got a stack that looks like:

 buddy / page allocator
 SL*B allocator
 kmalloc

And we'd change that to:

 buddy allocator
 SL*B allocator
 page allocator / kmalloc

So get_free_page() would still hand you back a hardware page, it would
just do it through SL*B.

>  It would decrease listlock effect drastically for SLUB.

Not sure what you're referring to here.

> However, isnt this is basically confessing that the page allocator is not 
> efficient for 4k page allocations?

Well I wasn't thinking of doing this for any performance reasons. But
there certainly could be some.
-- 
Mathematics is the supreme nostalgia of our time.

