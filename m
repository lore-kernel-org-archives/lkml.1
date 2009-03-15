Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZCOCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZCOCl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZCOClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:41:18 -0400
Received: from phunq.net ([64.81.85.152]:52089 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752366AbZCOClR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:41:17 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 19:41:09 -0700
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120524.34150.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au>
In-Reply-To: <200903130004.40483.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141941.10030.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Nick Piggin wrote:
> On Thursday 12 March 2009 23:24:33 Daniel Phillips wrote:
> > > fsblocks in their refcount mode don't tend to _cache_ physical block
> > > addresses either, because they're only kept around for as long as they
> > > are required (eg. to write out the page to avoid memory allocation
> > > deadlock problems).
> > >
> > > But some filesystems don't do very fast block lookups and do want a
> > > cache. I did a little extent map library on the side for that.
> >
> > Sure, good plan.  We are attacking the transfer path, so that all the
> > transfer state goes directly from the filesystem into a BIO and doesn't
> > need that twisty path back and forth to the block library.  The BIO
> > remembers the physical address across the transfer cycle.  If you must
> > still support those twisty paths for compatibility with the existing
> > buffer.c scheme, you have a much harder project.
> 
> I don't quite know what you mean. You have a set of dirty cache that
> needs to be written. So you need to know the block addresses in order
> to create the bio of course.
> 
> fsblock allocates the block and maps[*] the block at pagecache *dirty*
> time, and holds onto it until writeout is finished.

As it happens, Tux3 also physically allocates each _physical_ metadata
block (i.e., what is currently called buffer cache) at the time it is
dirtied.  I don't know if this is the best thing to do, but it is
interesting that you do the same thing.  I also don't know if I want to
trust a library to get this right, before having completely proved out
the idea in a non-trival filesystem.  But good luck with that!  It
seems to me like a very good idea to take Ted up on his offer and try
out your library on Ext4.  This is just a gut feeling, but I think you
will need many iterations to refine the idea.  Just working, and even
showing benchmark improvement is not enough.  If it is a core API
proposal, it needs a huge body of proof.  If you end up like JBD with
just one user, because it actually only implements the semantics of
exactly one filesystem, then the extra overhead of unused generality
will just mean more lines of code to maintain and more places for bugs
to hide.

This is all general philosophy of course.  Actually reading your code
would help a lot.  By comparision, I intend the block handles library
to be a few hundred lines of code, including new incarnations of
buffer.c functionality like block_read/write_*.  If this is indeed
possible, and it does the job with 4 bytes per block on a 1K block/4K
page configuration as it does in the prototype, then I think I would
prefer a per-filesystem solution and let it evolve that way for a long
time before attempting a library.  But that is just me.

I suppose you would like to see some code?

> In something like 
> ext2, finding the offset->block map can require buffercache allocations
> so it is technically deadlocky if you have to do it at writeout time.

I am not sure what "technically" means.  Pretty much everything you do
in this area has high deadlock risk.  That is one of the things that
scares me about trying to handle every filesystem uniformly.  How would
filesystem writers even know what the deadlock avoidance rules are,
thus what they need to do in their own filesystem to avoid it?

Anyway, the Tux3 reason for doing the allocation at dirty time is, this
is the only time the filesystem knows what the parent block of a given
metadata block is.  Note that we move btree blocks around when they are
dirtied, and thus need to know the parent in order to update the parent
pointer to the child.  This is a complication you will not run into in
any of the filesystems you have poked at so far.  This subtle detail is
very much filesystem specific, or it is specific to the class of
filesystems that do remap on write.  Good luck knowing how to generalize
that before Linux has seen even one of them up and doing real production
work.

> [*] except in the case of delalloc. fsblock does its best, but for
> complex filesystems like delalloc, some memory reservation would have
> to be done by the fs.

And that is a whole, huge and critical topic.  Again, something that I
feel needs to be analyzed per filesystem, until we have considerably
more experience with the issues.

> > > > The block handles patch is one of those fun things we have on hold for
> > > > the time being while we get the more mundane
> > >
> > > Good luck with it. I suspect that doing filesystem-specific layers to
> > > duplicate basically the same functionality but slightly optimised for
> > > the specific filesystem may not be a big win. As you say, this is where
> > > lots of nasty problems have been, so sharing as much code as possible
> > > is a really good idea.
> >
> > The big win will come from avoiding the use of struct buffer_head as
> > an API element for mapping logical cache to disk, which is a narrow
> > constriction when the filesystem wants to do things with extents in
> > btrees.  It is quite painful doing a btree probe for every ->get_block
> > the way it is now.  We want probe... page page page page... submit bio
> > (or put it on a list for delayed allocation).
> >
> > Once we have the desired, nice straight path above then we don't need
> > most of the fields in buffer_head, so tightening it up into a bitmap,
> > a refcount and a pointer back to the page makes a lot of sense.  This
> > in itself may not make a huge difference, but the reduction in cache
> > pressure ought to be measurable and worth the not very many lines of
> > code for the implementation.
> 
> I haven't done much about this in fsblock yet. I think some things need
> a bit of changing in the pagecache layer (in the block library, eg.
> write_begin/write_end doesn't have enough info to reserve/allocate a big
> range of blocks -- we need a callback higher up to tell the filesystem
> that we will be writing xxx range in the file, so get things ready for
> us).

That would be write_cache_pages, it already exists and seems perfectly
serviceable.

> As far as the per-block pagecache state (as opposed to the per-block fs
> state), I don't see any reason it is a problem for efficiency. We have to
> do per-page operations anyway.

I don't see a distinction between page cache vs fs state for a block.
Tux3 has these scalar block states:

  EMPTY - not read into cache yet
  CLEAN - cache data matches disk data (which might be a hole)
  DIRTY0 .. DIRTY3 - dirty in one of up to four pipelined delta updates

Besides the per-page block reference count (hmm, do we really need it?
Why not rely on the page reference count?) there is no cache-specific
state, it is all "fs" state.

To complete the enumeration of state Tux3 represents in block handles,
there is also a per-block lock bit, used for reading blocks, the same
as buffer lock.  So far there is no writeback bit, which does not seem
to be needed, because the flow of block writeback is subtly different
from page writeback.  I am not prepared to defend that assertion just
yet!  But I think the reason for this is, there is no such thing as
redirty for metadata blocks in Tux3, there is only "dirty in a later
delta", and that implies redirecting the block to a new physical
location that has its own, separate block state.  Anyway, this is a
pretty good example of why you may find it difficult to generalize your
library to handle every filesystem.  Is there any existing filesystem
that works this way?  How would you know in advance what features to
include in your library to handle it?  Will some future filesystem
have very different requirements, not handled by your library?  If you
have finally captured every feature, will they interact?  Will all
these features be confusing to use and hard to analyze?  I am not
saying you can't solve all these problems, just that it is bound to be
hard, take a long time, and might possibly end up less elegant than a
more lightweight approach that leaves the top level logic in the hands
of the filesystem.

Regards,

Daniel
