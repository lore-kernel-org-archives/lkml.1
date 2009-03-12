Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZCLNE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZCLNE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZCLNEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:04:46 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35757 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753063AbZCLNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:04:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QPgLEaLjgim9g7i3Hu2fCP2nTMrYcJxZiVv0onWRbiAXU6xX6MmdrsYj6ac8MstCkwYVKupZsSBYZ2AZy0zACkO5TP1107LA72s+706gqpdOduR9WALVOlEsiRTijIlDwjOM14OTHUs68KNSrhZrvSPnJW/r8KFPt4STR1FMFsY=  ;
X-YMail-OSG: lZ7ueOMVM1ktqjUOmvT7G5tm1h1y5iVvAbqb.h.oLMijc8bxNbDQUpRMsZGsZU.TVZjuyCg_vzK0bRjlm5sLgnIi5NMQLtx_4xrGXe6vJbwXnWzt_KVldmSPsaHrTg1y0yEFwMLcg3m9F1eznf5Ubp7AaSsRhUa3PZIF6xDtd8ZOHGBxC8ZjNggRs7IvxA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Fri, 13 Mar 2009 00:04:40 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au> <200903120524.34150.phillips@phunq.net>
In-Reply-To: <200903120524.34150.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130004.40483.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 23:24:33 Daniel Phillips wrote:
> On Thursday 12 March 2009, Nick Piggin wrote:

> > That's good for cache efficiency. As far as total # slab allocations
> > themselves go, fsblock probably tends to do more of them than buffer.c
> > because it frees them proactively when their refcounts reach 0 (by
> > default, one can switch to a lazy mode like buffer heads).
>
> I think that's a very good thing to do and intend to do the same.  If
> it shows on a profiler, then the filesystem should keep its own free
> list to avoid whatever slab thing creates the bottleneck.

slab allocation/free fastpath is on the order of 100 cycles, which is
a cache miss. I have a feeling that actually doing lots of allocs and
frees can work better because it keeps reusing the same memory for
different objects being operated on, so you get fewer cache misses.
(anyway it doesn't seem to be measurable in fsblock when switching
between cached and refcounted mode).


> > fsblocks in their refcount mode don't tend to _cache_ physical block
> > addresses either, because they're only kept around for as long as they
> > are required (eg. to write out the page to avoid memory allocation
> > deadlock problems).
> >
> > But some filesystems don't do very fast block lookups and do want a
> > cache. I did a little extent map library on the side for that.
>
> Sure, good plan.  We are attacking the transfer path, so that all the
> transfer state goes directly from the filesystem into a BIO and doesn't
> need that twisty path back and forth to the block library.  The BIO
> remembers the physical address across the transfer cycle.  If you must
> still support those twisty paths for compatibility with the existing
> buffer.c scheme, you have a much harder project.

I don't quite know what you mean. You have a set of dirty cache that
needs to be written. So you need to know the block addresses in order
to create the bio of course.

fsblock allocates the block and maps[*] the block at pagecache *dirty*
time, and holds onto it until writeout is finished. In something like
ext2, finding the offset->block map can require buffercache allocations
so it is technically deadlocky if you have to do it at writeout time.

[*] except in the case of delalloc. fsblock does its best, but for
complex filesystems like delalloc, some memory reservation would have
to be done by the fs.


> > > The block handles patch is one of those fun things we have on hold for
> > > the time being while we get the more mundane
> >
> > Good luck with it. I suspect that doing filesystem-specific layers to
> > duplicate basically the same functionality but slightly optimised for
> > the specific filesystem may not be a big win. As you say, this is where
> > lots of nasty problems have been, so sharing as much code as possible
> > is a really good idea.
>
> The big win will come from avoiding the use of struct buffer_head as
> an API element for mapping logical cache to disk, which is a narrow
> constriction when the filesystem wants to do things with extents in
> btrees.  It is quite painful doing a btree probe for every ->get_block
> the way it is now.  We want probe... page page page page... submit bio
> (or put it on a list for delayed allocation).
>
> Once we have the desired, nice straight path above then we don't need
> most of the fields in buffer_head, so tightening it up into a bitmap,
> a refcount and a pointer back to the page makes a lot of sense.  This
> in itself may not make a huge difference, but the reduction in cache
> pressure ought to be measurable and worth the not very many lines of
> code for the implementation.

I haven't done much about this in fsblock yet. I think some things need
a bit of changing in the pagecache layer (in the block library, eg.
write_begin/write_end doesn't have enough info to reserve/allocate a big
range of blocks -- we need a callback higher up to tell the filesystem
that we will be writing xxx range in the file, so get things ready for
us).

As far as the per-block pagecache state (as opposed to the per-block fs
state), I don't see any reason it is a problem for efficiency. We have to
do per-page operations anyway.


> > I would be very interested in anything like this that could beat fsblock
> > in functionality or performance anywhere, even if it is taking shortcuts
> > by being less generic.
> >
> > If there is a significant gain to be had from less generic, perhaps it
> > could still be made into a library usable by more than 1 fs.
>
> I don't see any reason right off that it is not generic, except that it
> does not try to fill the API role that buffer_head has, and so it isn't
> a small, easy change to an existing filesystem.  It ought to be useful
> for new designs though.  Mind you, the code hasn't been tried yet, it
> is currently just a state-smashing API waiting for the filesystem to
> evolve into the necessary shape, which is going to take another month
> or two.
>
> The Tux3 userspace buffer emulation already works much like the kernel
> block handles will work, in that it doesn't cache a physical address,
> and maintains cache state as a scalar value instead of a set of bits,
> so we already have a fair amount of experience with the model.  When it
> does get to the top of the list of things to do, it should slot in
> smoothly.  At that point we could hand it to you to try your generic
> API, which seems to implement similar ideas.

Cool. I will be interested to see how it works.

Thanks,
Nick

