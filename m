Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYDGT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYDGT4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYDGTzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:55:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYDGTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:55:55 -0400
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804072000410.18591@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
	 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804072000410.18591@blonde.site>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 21:55:15 +0200
Message-Id: <1207598115.29991.23.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 20:40 +0100, Hugh Dickins wrote:
> On Sun, 6 Apr 2008, Christoph Lameter wrote:
> > On Sun, 6 Apr 2008, Hugh Dickins wrote:
> > > 
> > > One very significant factor is SLUB, which
> > > merges slab caches when it can, and on 64-bit happens to merge
> > > both bio cache and sense_slab cache into kmalloc's 128-byte cache:
> > > so that under this swapping load, bios above are liable to gobble
> > > up all the slots needed for scsi_cmnd sense_buffers below.
> > 
> > A reliance on free slots that the slab allocator may provide? That is a 
> > rather bad dependency since it is up to the slab allocator to implement
> > the storage layout for the objects and thus the availability of slots may
> > vary depending on the layout for the objects chosen by the allocator.
> 
> I'm not sure that I understand you.  Yes, different slab allocators
> may lay out slots differently.  But a significant departure from
> existing behaviour may be a bad idea in some circumstances.
> (Hmm, maybe I've written a content-free sentence there!).
> 
> > 
> > Looking at mempool_alloc: Mempools may be used to do atomic allocations 
> > until they fail thereby exhausting reserves and available object in the 
> > partial lists of slab caches?
> 
> Mempools may be used for atomic allocations, but I think that's not
> the case here.  swap_writepage's get_swap_bio says GFP_NOIO, which
> allows (indeed is) __GFP_WAIT, and does not give access to __GFP_HIGH
> reserves.
> 
> Whereas at the __scsi_get_command end, there are GFP_ATOMIC sense_slab
> allocations, which do give access to __GFP_HIGH reserves.
> 
> My supposition is that once a page has been allocated from __GFP_HIGH
> reserves to a scsi sense_slab, swap_writepages are liable to gobble up
> the rest of the page with bio allocations which they wouldn't have had
> access to traditionally (i.e. under SLAB).
> 
> So an unexpected behaviour emerges from SLUB's slab merging.

Somewhere along the line of my swap over network patches I made
'robustified' SLAB to ensure these sorts of things could not happen - it
came at a cost though.

It would basically fail[*] allocations that had a higher low watermark
than what was used to allocate the current slab.

[*] - well, it would attempt to allocate a new slab to raise the current
watermark, but failing that it would fail the allocation.

> Though of course the same might happen in other circumstances, even
> without slab merging: if some kmem_cache allocations are made with
> GFP_ATOMIC, those can give access to reserves to non-__GFP_HIGH
> allocations from the same kmem_cache.
> 
> Maybe PF_MEMALLOC and __GFP_NOMEMALLOC complicate the situation:
> I've given little thought to mempool_alloc's fiddling with the
> gfp_mask (beyond repeatedly misreading it).

My latest series ensures that SLABs allocated using PF_MEMALLOC will not
distribute objects to allocation contexts that are not entitled for as
long as the memory shortage lasts.

I'm not sure how applicable this is to the problem at hand, just letting
you know whats there.

> > In order to make this a significant factor we need to have already 
> > exhausted reserves right? Thus we are already operating at the boundary of 
> > what memory there is. Any non atomic alloc will then allocate a new page 
> > with N elements in order to get one object. The mempool_allocs from the 
> > atomic context will then gooble up the N-1 remaining objects? So the
> > nonatomic alloc will then have to hit the page allocator again...

Relying on this is highly dubious, who is to say that first __GFP_HIGH
alloc came SCSI layer (there could be another merged slab).

Also, when one of these users is PF_MEMALLOC the other users will gobble
up our emergency memory - not as intended.

> We need to have already exhausted reserves, yes: so this isn't an
> issue hitting everyone all the time, and it may be nothing worse
> than a surprising anomaly; but I'm pretty sure it's not how bio
> and scsi command allocation is expected to interact.
> 
> What do you think a SLAB_NOMERGE flag?  The last time I suggested
> something like that (but I was thinking of debug), your comment
> was "Ohh..", which left me in some doubt ;)
> 
> If we had a SLAB_NOMERGE flag, would we want to apply it to the
> bio cache or to the scsi_sense_cache or to both?  My difficulty
> in answering that makes me wonder whether such a flag is right.

If this is critical to avoid memory deadlocks, I would suggest using
mempools (or my reserve framework).

