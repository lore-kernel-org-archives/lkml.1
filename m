Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCLMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCLMYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZCLMYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:24:39 -0400
Received: from phunq.net ([64.81.85.152]:54592 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754261AbZCLMYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:24:38 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 05:24:33 -0700
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120315.07610.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au>
In-Reply-To: <200903122203.31502.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120524.34150.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Nick Piggin wrote:
> On Thursday 12 March 2009 21:15:06 Daniel Phillips wrote:
> 
> > By the way, I just spotted your fsblock effort on LWN, and I should
> > mention there is a lot of commonality with a side project we have
> > going in Tux3, called "block handles", which aims to get rid of buffers
> > entirely, leaving a tiny structure attached to the page->private that
> > just records the block states.  Currently, four bits per block.  This
> > can be done entirely _within_ a filesystem.  We are already running
> > some of the code that has to be in place before switching over to this
> > model.
> >
> > Tux3 block handles (as prototyped, not in the current code base) are
> > 16 bytes per page, which for 1K block size on a 32 bit arch is a factor
> > of 14 savings, more on 64 bit arch.  More importantly, it saves lots of
> > individual slab allocations, a feature I gather is part of fsblock as
> > well.
> 
> That's interesting. Do you handle 1K block sizes with 64K page size? :)

Not in its current incarnation.  That would require 32 bytes worth of
state while the current code just has a 4 byte map (4 bits X 8 blocks).
I suppose a reasonable way to extend it would be 4 x 8 byte maps.  Has
somebody spotted a 64K page?

> fsblock isn't quite as small. 20 bytes per block on a 32-bit arch. Yeah,
> so it will do a single 80 byte allocation for 4K page 1K block.
> 
> That's good for cache efficiency. As far as total # slab allocations
> themselves go, fsblock probably tends to do more of them than buffer.c
> because it frees them proactively when their refcounts reach 0 (by
> default, one can switch to a lazy mode like buffer heads).

I think that's a very good thing to do and intend to do the same.  If
it shows on a profiler, then the filesystem should keep its own free
list to avoid whatever slab thing creates the bottleneck.

> That's one of the most important things, so we don't end up with lots
> of these things lying around.

Amen.  Doing nothing.

> eg. I could make it 16 bytes I think, but it would be a little harder
> and would make support for block size > page size much harder so I
> wouldn't bother. Or share the refcount field for all blocks in a page
> and just duplicate state etc, but it just makes code larger and slower
> and harder.

Right, block handles share the refcount for all blocks on one page.

> > We represent up to 8 block states in one 16 byte object.  To make this
> > work, we don't try to emulate the behavior of the venerable block
> > library, but first refactor the filesystem data flow so that we are
> > only using the parts of buffer_head that will be emulated by the block
> > handle.  For example, no caching of physical block address.  It keeps
> > changing in Tux3 anyway, so this is really a useless thing to do.
> 
> fsblocks in their refcount mode don't tend to _cache_ physical block addresses
> either, because they're only kept around for as long as they are required
> (eg. to write out the page to avoid memory allocation deadlock problems).
> 
> But some filesystems don't do very fast block lookups and do want a cache.
> I did a little extent map library on the side for that.

Sure, good plan.  We are attacking the transfer path, so that all the
transfer state goes directly from the filesystem into a BIO and doesn't
need that twisty path back and forth to the block library.  The BIO
remembers the physical address across the transfer cycle.  If you must
still support those twisty paths for compatibility with the existing
buffer.c scheme, you have a much harder project.

> > Anyway, that is more than I meant to write about it.  Good luck to you,
> > you will need it.  Keep in mind that some of the nastiest kernel bugs
> > ever arose from interactions between page and buffer state bits.  You
> 
> Yes, I even fixed several of them too :)
> 
> fsblock simplifies a lot of those games. It protects pagecache state and
> fsblock state for all assocated blocks under a lock, so no weird ordering
> issues, and the two are always kept coherent (to the point that I can do
> writeout by walking dirty fsblocks in block device sector-order, although
> that requires bloat to fsblock struct and isn't straightforward with
> delalloc).
> 
> Of course it is new code so it will have more bugs, but it is better code.

I've started poking at it, starting with the manifesto.  It's a pretty
big reading project.
 
> > The block handles patch is one of those fun things we have on hold for
> > the time being while we get the more mundane
> 
> Good luck with it. I suspect that doing filesystem-specific layers to
> duplicate basically the same functionality but slightly optimised for
> the specific filesystem may not be a big win. As you say, this is where
> lots of nasty problems have been, so sharing as much code as possible
> is a really good idea.

The big win will come from avoiding the use of struct buffer_head as
an API element for mapping logical cache to disk, which is a narrow
constriction when the filesystem wants to do things with extents in
btrees.  It is quite painful doing a btree probe for every ->get_block
the way it is now.  We want probe... page page page page... submit bio
(or put it on a list for delayed allocation).

Once we have the desired, nice straight path above then we don't need
most of the fields in buffer_head, so tightening it up into a bitmap,
a refcount and a pointer back to the page makes a lot of sense.  This
in itself may not make a huge difference, but the reduction in cache
pressure ought to be measurable and worth the not very many lines of
code for the implementation.

> I would be very interested in anything like this that could beat fsblock
> in functionality or performance anywhere, even if it is taking shortcuts
> by being less generic.
> 
> If there is a significant gain to be had from less generic, perhaps it
> could still be made into a library usable by more than 1 fs.

I don't see any reason right off that it is not generic, except that it
does not try to fill the API role that buffer_head has, and so it isn't
a small, easy change to an existing filesystem.  It ought to be useful
for new designs though.  Mind you, the code hasn't been tried yet, it
is currently just a state-smashing API waiting for the filesystem to
evolve into the necessary shape, which is going to take another month
or two.

The Tux3 userspace buffer emulation already works much like the kernel
block handles will work, in that it doesn't cache a physical address,
and maintains cache state as a scalar value instead of a set of bits,
so we already have a fair amount of experience with the model.  When it
does get to the top of the list of things to do, it should slot in
smoothly.  At that point we could hand it to you to try your generic
API, which seems to implement similar ideas.

Regards,

Daniel
