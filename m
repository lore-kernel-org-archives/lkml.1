Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXIKQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXIKQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbXIKQcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:32:04 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:32898 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229AbXIKQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:32:01 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jrn Engel <joern@logfs.org>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709110713.54781.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Tue, 11 Sep 2007 07:13:54 +1000")
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<200709110713.54781.nickpiggin@yahoo.com.au>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
Date: Tue, 11 Sep 2007 18:02:15 +0200
Message-ID: <87hcm1gph4.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Tuesday 11 September 2007 22:12, Jörn Engel wrote:
>> On Tue, 11 September 2007 04:52:19 +1000, Nick Piggin wrote:
>> > On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:
>> > > 5. VM scalability
>> > >    Large block sizes mean less state keeping for the information being
>> > >    transferred. For a 1TB file one needs to handle 256 million page
>> > >    structs in the VM if one uses 4k page size. A 64k page size reduces
>> > >    that amount to 16 million. If the limitation in existing filesystems
>> > >    are removed then even higher reductions become possible. For very
>> > >    large files like that a page size of 2 MB may be beneficial which
>> > >    will reduce the number of page struct to handle to 512k. The
>> > > variable nature of the block size means that the size can be tuned at
>> > > file system creation time for the anticipated needs on a volume.
>> >
>> > The idea that there even _is_ a bug to fail when higher order pages
>> > cannot be allocated was also brushed aside by some people at the
>> > vm/fs summit. I don't know if those people had gone through the
>> > math about this, but it goes somewhat like this: if you use a 64K
>> > page size, you can "run out of memory" with 93% of your pages free.
>> > If you use a 2MB page size, you can fail with 99.8% of your pages
>> > still free. That's 64GB of memory used on a 32TB Altix.
>>
>> While I agree with your concern, those numbers are quite silly.  The
>
> They are the theoretical worst case. Obviously with a non trivially
> sized system and non-DoS workload, they will not be reached.

I would think it should be pretty hard to have only one page out of
each 2MB chunk allocated and non evictable (writeable, swappable or
movable). Wouldn't that require some kernel driver to allocate all
pages and then selectively free them in such a pattern as to keep one
page per 2MB chunk?

Assuming nothing tries to allocate a large chunk of ram while holding
to many locks for the kernel to free it.

>> chances of 99.8% of pages being free and the remaining 0.2% being
>> perfectly spread across all 2MB large_pages are lower than those of SHA1
>> creating a collision.  I don't see anyone abandoning git or rsync, so
>> your extreme example clearly is the wrong one.
>>
>> Again, I agree with your concern, even though your example makes it look
>> silly.
>
> It is not simply a question of once-off chance for an all-at-once layout
> to fail in this way. Fragmentation slowly builds over time, and especially
> if you do actually use higher-order pages for a significant number of
> things (unlike we do today), then the problem will become worse. If you
> have any part of your workload that is affected by fragmentation, then
> it will cause unfragmented regions to eventually be used for fragmentation
> inducing allocations (by definition -- if it did not, eg. then there would be
> no fragmentation problem and no need for Mel's patches).

It might be naive (stop me as soon as I go into dream world) but I
would think there are two kinds of fragmentation:

Hard fragments - physical pages the kernel can't move around
Soft fragments - virtual pages/cache that happen to cause a fragment

I would further assume most ram is used on soft fragments and that the
kernel will free them up by flushing or swapping the data when there
is sufficient need. With defragmentation support the kernel could
prevent some flushings or swapping by moving the data from one
physical page to another. But that would just reduce unneccessary work
and not change the availability of larger pages.

Further I would assume that there are two kinds of hard fragments:
Fragments allocated once at start time and temporary fragments.

At boot time (or when a module is loaded or something) you get a tiny
amount of ram allocated that will remain busy for basically ever. You
get some fragmentation right there that you can never get rid of.

At runtime a lot of pages are allocated and quickly freed again. They
get preferably positions in regions where there already is
fragmentation. In regions where there are suitable sized holes
already. They would only break a free 2MB chunk into smaller chunks if
there is no small hole to be found.

Now a trick I would use is to put kernel allocated pages at one end of
the ram and virtual/cache pages at the other end. Small kernel allocs
would find holes at the start of the ram while big allocs would have
to move more to the middle or end of the ram to find a large enough
hole. And virtual/cache pages could always be cleared out to free
large continious chunks.

Splitting the two types would prevent fragmentation of freeable and
not freeable regions giving us always a large pool to pull compound
pages from.

One could also split the ram into regions of different page sizes,
meaning that some large compound pages may not be split below a
certain limit. E.g. some amount of ram would be reserved for chunk
>=64k only. This should be configurable via sys.

> I don't know what happens as time tends towards infinity, but I don't think
> it will be good.

It depends on the lifetime of the allocations. If the lifetime is
uniform enough then larger chunks of memory allocated for small
objects will always be freed after a short time. If the lifetime
varies widely then it can happen that one page of a larger chunk
remains busy far longer than the rest causing fragmentation.

I'm hopeing that we don't have such wide variance in lifetime that we
run into a ENOMEM. I'm hoping allocation and freeing are not random
events that would result in an expectancy of an infinite number of
allocations to be alife as time tends towards infinity. I'm hoping
there is enough dependence between the two to impose an upper limit on
the fragmentation.

> At millions of allocations per second, how long does it take to produce
> an unacceptable number of free pages before the ENOMEM condition?
> Furthermore, what *is* an unacceptable number? I don't know. I am not
> trying to push this feature in, so the burden is not mine to make sure it
> is OK.

I think the only acceptable solution is to have the code cope with
large pages being unavailable and use multiple smaller chunks instead
in a tight spot. By all means try to use a large continious chunk but
never fail just because we are too fragmented. I'm sure modern system
with 4+GB ram will not run into the wall but i'm equaly sure older
systems with as little as 64MB quickly will. Handling the fragmented
case is the only way to make sure we keep running.

> Yes, we already have some of these problems today. Introducing more
> and worse problems and justifying them because of existing ones is much
> more silly than my quoting of the numbers. IMO.

MfG
        Goswin
