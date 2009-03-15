Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZCODpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZCODpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZCODpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:45:17 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:24125 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753901AbZCODpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:45:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LpItWwOrfIzZw5GdRg8eeEi6ODs4yFRMxn4NtrczlUInXGV47wvGFalsoEMndm9bbZWCzJbMJ+N19hrV8iX/0ob3Wy9xL5jTLtt1oY7a0waEIqdNRJ3avngMqK/eH0OOU7CuuWMXNNk8SB560NpLONvs+C/1lsxjjhqo9L+hRaU=  ;
X-YMail-OSG: DzU6DoUVM1ngF3vEs92pzyptQOSL0d5YiDLa53jnW0nLX92DFVVSq4aouUlede.9ASUjdRcUco7jH.uu3YTj8K1tzNkxxtFtSh9u9tik6n4cSOniEN7A1IWKquiQnaFmaez5zkP0_S2gqUyhNBbDu1g6_pdOCnQPvAJ7t1mAGOemjD8r.h6sof8vLvY8EQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sun, 15 Mar 2009 14:45:04 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <200903141941.10030.phillips@phunq.net>
In-Reply-To: <200903141941.10030.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151445.04552.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 13:41:09 Daniel Phillips wrote:
> On Thursday 12 March 2009, Nick Piggin wrote:
> > On Thursday 12 March 2009 23:24:33 Daniel Phillips wrote:
> > > > fsblocks in their refcount mode don't tend to _cache_ physical block
> > > > addresses either, because they're only kept around for as long as
> > > > they are required (eg. to write out the page to avoid memory
> > > > allocation deadlock problems).
> > > >
> > > > But some filesystems don't do very fast block lookups and do want a
> > > > cache. I did a little extent map library on the side for that.
> > >
> > > Sure, good plan.  We are attacking the transfer path, so that all the
> > > transfer state goes directly from the filesystem into a BIO and doesn't
> > > need that twisty path back and forth to the block library.  The BIO
> > > remembers the physical address across the transfer cycle.  If you must
> > > still support those twisty paths for compatibility with the existing
> > > buffer.c scheme, you have a much harder project.
> >
> > I don't quite know what you mean. You have a set of dirty cache that
> > needs to be written. So you need to know the block addresses in order
> > to create the bio of course.
> >
> > fsblock allocates the block and maps[*] the block at pagecache *dirty*
> > time, and holds onto it until writeout is finished.
>
> As it happens, Tux3 also physically allocates each _physical_ metadata
> block (i.e., what is currently called buffer cache) at the time it is
> dirtied.  I don't know if this is the best thing to do, but it is
> interesting that you do the same thing.  I also don't know if I want to
> trust a library to get this right, before having completely proved out
> the idea in a non-trival filesystem.  But good luck with that!  It

I'm not sure why it would be a big problem. fsblock isn't allocating
the block itself of course, it just asks the filesystem to. It's
trivial to do for fsblock.


> seems to me like a very good idea to take Ted up on his offer and try
> out your library on Ext4.  This is just a gut feeling, but I think you
> will need many iterations to refine the idea.  Just working, and even
> showing benchmark improvement is not enough.  If it is a core API
> proposal, it needs a huge body of proof.  If you end up like JBD with
> just one user, because it actually only implements the semantics of
> exactly one filesystem, then the extra overhead of unused generality
> will just mean more lines of code to maintain and more places for bugs
> to hide.

I don't know what you're thinking is so difficult with it. I've already
converted minix, ext2, and xfs and they seem to work fine. There is not
really fundamentally anything that buffer heads can do that fsblock can't.


> This is all general philosophy of course.  Actually reading your code
> would help a lot.  By comparision, I intend the block handles library
> to be a few hundred lines of code, including new incarnations of
> buffer.c functionality like block_read/write_*.  If this is indeed
> possible, and it does the job with 4 bytes per block on a 1K block/4K
> page configuration as it does in the prototype, then I think I would
> prefer a per-filesystem solution and let it evolve that way for a long
> time before attempting a library.  But that is just me.

If you're tracking pagecache state in these things, then I can't see how
it can get any easier just because it is smaller. In which case, your
concerns about duplicating functionality of this layer.


> I suppose you would like to see some code?
>
> > In something like
> > ext2, finding the offset->block map can require buffercache allocations
> > so it is technically deadlocky if you have to do it at writeout time.
>
> I am not sure what "technically" means.  Pretty much everything you do

Technically means that it is deadlocky. Today, practically every Linux
filesystem technically has memory deadlocks. In practice, the mm does
keep reserves around to help this and so it is very very hard to hit.


> in this area has high deadlock risk.  That is one of the things that
> scares me about trying to handle every filesystem uniformly.  How would
> filesystem writers even know what the deadlock avoidance rules are,
> thus what they need to do in their own filesystem to avoid it?

The rule is simple: if forward progress requires resource allocation,
then you would ensure resource deadlocks are avoided or can be recovered
from.

I don't think many fs developers actually care very much, but obviously
a rewrite of such core functionality must not introduce such deadlocks
by design.


> Anyway, the Tux3 reason for doing the allocation at dirty time is, this
> is the only time the filesystem knows what the parent block of a given
> metadata block is.  Note that we move btree blocks around when they are
> dirtied, and thus need to know the parent in order to update the parent
> pointer to the child.  This is a complication you will not run into in
> any of the filesystems you have poked at so far.  This subtle detail is
> very much filesystem specific, or it is specific to the class of
> filesystems that do remap on write.  Good luck knowing how to generalize
> that before Linux has seen even one of them up and doing real production
> work.

Uh, this kind of stuff is completely not what fsblock would try to do.
fsblock gives the filesystem notifications when the block gets dirtied,
when the block is prepared for writeout, etc.

It is up to the filesystem to do everything else (with the postcondition
that the block is mapped after being prepared for writeout).


> > [*] except in the case of delalloc. fsblock does its best, but for
> > complex filesystems like delalloc, some memory reservation would have
> > to be done by the fs.
>
> And that is a whole, huge and critical topic.  Again, something that I
> feel needs to be analyzed per filesystem, until we have considerably
> more experience with the issues.

Again, fsblock does as much as it can up to guaranteeing fsblock metadata
(and hence, any filesystem private data is attached to the fsblock) is
allocated as long as the block is dirty.

Of course the actual delalloc scheme is filesystem specific and can't be
handled by fsblock.


> > I haven't done much about this in fsblock yet. I think some things need
> > a bit of changing in the pagecache layer (in the block library, eg.
> > write_begin/write_end doesn't have enough info to reserve/allocate a big
> > range of blocks -- we need a callback higher up to tell the filesystem
> > that we will be writing xxx range in the file, so get things ready for
> > us).
>
> That would be write_cache_pages, it already exists and seems perfectly
> serviceable.

No it isn't. That's completely different.


> > As far as the per-block pagecache state (as opposed to the per-block fs
> > state), I don't see any reason it is a problem for efficiency. We have to
> > do per-page operations anyway.
>
> I don't see a distinction between page cache vs fs state for a block.
> Tux3 has these scalar block states:
>
>   EMPTY - not read into cache yet
>   CLEAN - cache data matches disk data (which might be a hole)
>   DIRTY0 .. DIRTY3 - dirty in one of up to four pipelined delta updates
>
> Besides the per-page block reference count (hmm, do we really need it?
> Why not rely on the page reference count?) there is no cache-specific
> state, it is all "fs" state.

dirty / uptodate is a property of the cache.


> To complete the enumeration of state Tux3 represents in block handles,
> there is also a per-block lock bit, used for reading blocks, the same
> as buffer lock.  So far there is no writeback bit, which does not seem
> to be needed, because the flow of block writeback is subtly different
> from page writeback.  I am not prepared to defend that assertion just
> yet!  But I think the reason for this is, there is no such thing as
> redirty for metadata blocks in Tux3, there is only "dirty in a later
> delta", and that implies redirecting the block to a new physical
> location that has its own, separate block state.  Anyway, this is a
> pretty good example of why you may find it difficult to generalize your
> library to handle every filesystem.  Is there any existing filesystem
> that works this way?  How would you know in advance what features to
> include in your library to handle it?  Will some future filesystem
> have very different requirements, not handled by your library?  If you
> have finally captured every feature, will they interact?  Will all
> these features be confusing to use and hard to analyze?  I am not
> saying you can't solve all these problems, just that it is bound to be
> hard, take a long time, and might possibly end up less elegant than a
> more lightweight approach that leaves the top level logic in the hands
> of the filesystem.

It's not meant to handle every possible feature of every current and
future fs! It's meant to replace buffer-head. If there is some common
filesystem feature in future that makes sense to generalise and support
in fsblock then great.

