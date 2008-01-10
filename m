Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbYAJTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbYAJTvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbYAJTvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:51:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38933 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758262AbYAJTvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:51:06 -0500
Date: Thu, 10 Jan 2008 11:51:05 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199994282.5331.173.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801101147200.20926@schroedinger.engr.sgi.com>
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
 <Pine.LNX.4.64.0801101118070.20353@schroedinger.engr.sgi.com>
 <1199994282.5331.173.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Matt Mackall wrote:

> Well, I think we'd still have the same page size, in the sense that we'd
> have a struct page for every hardware page and we'd still have hardware
> page-sized pages in the page cache. We'd just change how we allocated
> them. Right now we've got a stack that looks like:

We would not change the hardware page. Cannot do that. But we would have 
preferential threadment for 64k and 2M pages in the page allocator?

>  buddy / page allocator
>  SL*B allocator
>  kmalloc
> 
> And we'd change that to:
> 
>  buddy allocator
>  SL*B allocator
>  page allocator / kmalloc
> 
> So get_free_page() would still hand you back a hardware page, it would
> just do it through SL*B.

Hmm.... Not sure what effect this would have. We already have the pcp's 
that have a similar effect.
 
> >  It would decrease listlock effect drastically for SLUB.
> 
> Not sure what you're referring to here.

Allocations in 64k chunks means 16 times less basic allocation blocks to 
manage for the slab allocators. So the metadata to be maintained by the 
allocators is reduces by that factor. SLUB only needs to touch the 
list_lock (in some situations like a free to a non cpu slab) if a block 
becomes completely empty or is going from fully allocated to partially 
allocated. The larger the block size the more objects are in a block and 
the less of these actions that need a per node lock are needed.

