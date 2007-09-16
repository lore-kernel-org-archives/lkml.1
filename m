Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXIPWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXIPWil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXIPWib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:38:31 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:48931 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbXIPWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:38:29 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: mel@skynet.ie (Mel Gorman)
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709111606.10873.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
	<200709120407.48344.nickpiggin@yahoo.com.au>
	<87zlzpqlc8.fsf@informatik.uni-tuebingen.de>
	<1189791772.13629.20.camel@localhost>
	<87tzpwlqg2.fsf@informatik.uni-tuebingen.de>
	<20070916211627.GE16406@skynet.ie>
Date: Mon, 17 Sep 2007 00:38:23 +0200
In-Reply-To: <20070916211627.GE16406@skynet.ie> (Mel Gorman's message of "Sun,
	16 Sep 2007 22:16:27 +0100")
Message-ID: <87zlzm44o0.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mel@skynet.ie (Mel Gorman) writes:

> On (15/09/07 02:31), Goswin von Brederlow didst pronounce:
>> Mel Gorman <mel@csn.ul.ie> writes:
>> 
>> > On Fri, 2007-09-14 at 18:10 +0200, Goswin von Brederlow wrote:
>> >> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>> >> 
>> >> > In my attack, I cause the kernel to allocate lots of unmovable allocations
>> >> > and deplete movable groups. I theoretically then only need to keep a
>> >> > small number (1/2^N) of these allocations around in order to DoS a
>> >> > page allocation of order N.
>> >> 
>> >> I'm assuming that when an unmovable allocation hijacks a movable group
>> >> any further unmovable alloc will evict movable objects out of that
>> >> group before hijacking another one. right?
>> >> 
>> >
>> > No eviction takes place. If an unmovable allocation gets placed in a
>> > movable group, then steps are taken to ensure that future unmovable
>> > allocations will take place in the same range (these decisions take
>> > place in __rmqueue_fallback()). When choosing a movable block to
>> > pollute, it will also choose the lowest possible block in PFN terms to
>> > steal so that fragmentation pollution will be as confined as possible.
>> > Evicting the unmovable pages would be one of those expensive steps that
>> > have been avoided to date.
>> 
>> But then you can have all blocks filled with movable data, free 4K in
>> one group, allocate 4K unmovable to take over the group, free 4k in
>> the next group, take that group and so on. You can end with 4k
>> unmovable in every 64k easily by accident.
>> 
>
> As the mixing takes place at the lowest possible block, it's
> exceptionally difficult to trigger this. Possible, but exceptionally
> difficult.

Why is it difficult?

When user space allocates memory wouldn't it get it contiously? I mean
that is one of the goals, to use larger continious allocations and map
them with a single page table entry where possible, right? And then
you can roughly predict where an munmap() would free a page.

Say the application does map a few GB of file, uses madvice to tell
the kernel it needs a 2MB block (to get a continious 2MB chunk
mapped), waits for it and then munmaps 4K in there. A 4k hole for some
unmovable object to fill. If you can then trigger the creation of an
unmovable object as well (stat some file?) and loop you will fill the
ram quickly. Maybe it only works in 10% but then you just do it 10
times as often.

Over long times it could occur naturally. This is just to demonstrate
it with malice.

> As I have stated repeatedly, the guarantees can be made but potential
> hugepage allocation did not justify it. Large blocks might.
>
>> There should be a lot of preassure for movable objects to vacate a
>> mixed group or you do get fragmentation catastrophs.
>
> We (Andy Whitcroft and I) did implement something like that. It hooked into
> kswapd to clean mixed blocks. If the caller could do the cleaning, it
> did the work instead of kswapd.

Do you have a graphic like
http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg
for that case?

>> Looking at my
>> little test program evicting movable objects from a mixed group should
>> not be that expensive as it doesn't happen often.
>
> It happens regularly if the size of the block you need to keep clean is
> lower than min_free_kbytes. In the case of hugepages, that was always
> the case.

That assumes that the number of groups allocated for unmovable objects
will continiously grow and shrink. I'm assuming it will level off at
some size for long times (hours) under normal operations. There should
be some buffering of a few groups to be held back in reserve when it
shrinks to prevent the scenario that the size is just at a group
boundary and always grows/shrinks by 1 group.

>> The cost of it
>> should be freeing some pages (or finding free ones in a movable group)
>> and then memcpy.
>
> Freeing pages is not cheap. Copying pages is cheaper but not cheap.

To copy you need a free page as destination. Thats all I
ment. Hopefully there will always be a free one and the actual freeing
is done asynchronously from the copying.

>> So if
>> you evict movable objects from mixed group when needed all the
>> pagetable pages would end up in the same mixed group slowly taking it
>> over completly. No fragmentation at all. See how essential that
>> feature is. :)
>> 
>
> To move pages, there must be enough blocks free. That is where
> min_free_kbytes had to come in. If you cared only about keeping 64KB
> chunks free, it makes sense but it didn't in the context of hugepages.

I'm more concerned with keeping the little unmovable things out of the
way. Those are the things that will fragment the memory and prevent
any huge pages to be available even with moving other stuff out of the
way.

It would also already be a big plus to have 64k continious chunks for
many operations. Guaranty that the filesystem and block layers can
always get such a page (by means of copying pages out of the way when
needed) and do even larger pages speculative.

But as you say that is where min_free_kbytes comes in. To have the
chance of a 2MB continious free chunk you need to have much more
reserved free. Something I would certainly do on a 16GB ram
server. Note that the buddy system will be better at having large free
chunks if user space allocates and frees large chunks as well. It is
much easier to make an 128K chunk out of 64K chunks than out of 4K
chunks. Much more probable to get 2 64k chunks adjacent than 32 4K
chunks in series.

>> > These type of pictures feel somewhat familiar
>> > (http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg).
>> 
>> Those look a lot better and look like they are actually real kernel
>> data. How did you make them and can one create them in real-time (say
>> once a second or so)?
>> 
>
> It's from a real kernel. When I was measuring this stuff, I took a
> sample every 2 seconds.

Can you tell me how? I would like to do the same.

>> There seem to be an awfull lot of pinned pages inbetween the movable.
>
> It wasn't grouping by mobility at the time.

That might explain at lot. I was thinking that was with grouping. But
without grouping such a rather random distribution of unmovable
objects doesn't sound uncommon,.

>> I would verry much like to see the same data with evicting of movable
>> pages out of mixed groups. I see not a single movable group while with
>> strict eviction there could be at most one mixed group per order.
>> 
>
> With strict eviction, there would be no mixed blocks period.

I ment on demand eviction. Not evicting the whole group just because
we need 4k of it. Even looser would be to allow say 16 mixed groups
before moving pages out of the way when needed for an alloc. Best to
make it a proc entry and then change the value once a day and see how
it behaves. :)

MfG
        Goswin

