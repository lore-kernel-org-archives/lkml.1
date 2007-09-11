Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXILHMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXILHMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXILHMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:12:46 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:20258 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752085AbXILHMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:12:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l3oP6SE02HpSrH7RAbmpJpEcGBqWZJ/xEQjExrhJb7COahA6ciqnpUPFznzJ4jfAUcALR7vDdB7MCxxt/0SOJe1Q43jFrchLNN/7WcrhdtjcV/T6Zami+nCXGUBrFIJdDpcaUBmVmj3AFnrCj2pljNbvButjBp/0ydF3rhP6XGs=  ;
X-YMail-OSG: pJ4Ig3cVM1kmfhgk7dT6sWBKYXKwDvaBmG2syKRoOikUS1TYt5Q5W9pHiyqfxcYULq1Z0zdZi_Eh7tXjJyUm9Rpwnlp1lAm9vFTFojE0L3JugciGLxQ-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Wed, 12 Sep 2007 01:27:33 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111600.18756.nickpiggin@yahoo.com.au> <20070912014917.GJ995458@sgi.com>
In-Reply-To: <20070912014917.GJ995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120127.33832.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 11:49, David Chinner wrote:
> On Tue, Sep 11, 2007 at 04:00:17PM +1000, Nick Piggin wrote:
> > > > OTOH, I'm not sure how much buy-in there was from the filesystems
> > > > guys. Particularly Christoph H and XFS (which is strange because they
> > > > already do vmapping in places).
> > >
> > > I think they use vmapping because they have to, not because they want
> > > to. They might be a lot happier with fsblock if it used contiguous
> > > pages for large blocks whenever possible - I don't know for sure. The
> > > metadata accessors they might be unhappy with because it's inconvenient
> > > but as Christoph Hellwig pointed out at VM/FS, the filesystems who
> > > really care will convert.
> >
> > Sure, they would rather not to. But there are also a lot of ways you can
> > improve vmap more than what XFS does (or probably what darwin does)
> > (more persistence for cached objects, and batched invalidates for
> > example).
>
> XFS already has persistence across the object life time (which can be many
> tens of seconds for a frequently used buffer)

But you don't do a very good job. When you go above 64 cached mappings,
you purge _all_ of them. fsblock's vmap cache can have a much higher number
(if you want), and purging can just unmap a batch which is decided by a simple
LRU (thus important metadata gets saved).


> and it also does batched 
> unmapping of objects as well.

It also could do a lot better at unmapping. Currently you're just calling
vunmap a lot of times in sequence. That still requires global IPIs and TLB
flushing every time.

This simple patch should easily be able to reduce that number by 2 or 3
orders of magnitude (maybe more on big systems).
http://www.mail-archive.com/linux-arch@vger.kernel.org/msg03956.html

vmap area locking and data structures could also be made a lot better
quite easily, I suspect.


> > There are also a lot of trivial things you can do to make a lot of those
> > accesses not require vmaps (and less trivial things, but even such things
> > as binary searches over multiple pages should be quite possible with a
> > bit of logic).
>
> Yes, we already do the many of these things (via xfs_buf_offset()), but
> that is not good enough for something like a memcpy that spans multiple
> pages in a large block (think btree block compaction, splits and
> recombines).

fsblock_memcpy(fsblock *src, int soff, fsblock *dst, int doff, int size); ?


> IOWs, we already play these vmap harm-minimisation games in the places
> where we can, but still the overhead is high and something we'd prefer
> to be able to avoid.

I don't think you've looked nearly far enough with all this low hanging
fruit.

I just gave 4 things which combined might easily reduce xfs vmap overhead
by several orders of magnitude, all without changing much code at all.
