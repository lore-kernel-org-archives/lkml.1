Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXIWGtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXIWGtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXIWGtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:49:16 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:45737 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXIWGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:49:15 -0400
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
	<87zlzm44o0.fsf@informatik.uni-tuebingen.de>
	<20070917085714.GA25706@skynet.ie>
Date: Sun, 23 Sep 2007 08:49:08 +0200
In-Reply-To: <20070917085714.GA25706@skynet.ie> (Mel Gorman's message of "Mon,
	17 Sep 2007 09:57:14 +0100")
Message-ID: <87k5qh7u6z.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mel@skynet.ie (Mel Gorman) writes:

> On (17/09/07 00:38), Goswin von Brederlow didst pronounce:
>> mel@skynet.ie (Mel Gorman) writes:
>> 
>> > On (15/09/07 02:31), Goswin von Brederlow didst pronounce:
>> >> Mel Gorman <mel@csn.ul.ie> writes:
>> >> Looking at my
>> >> little test program evicting movable objects from a mixed group should
>> >> not be that expensive as it doesn't happen often.
>> >
>> > It happens regularly if the size of the block you need to keep clean is
>> > lower than min_free_kbytes. In the case of hugepages, that was always
>> > the case.
>> 
>> That assumes that the number of groups allocated for unmovable objects
>> will continiously grow and shrink.
>
> They do grow and shrink. The number of pagetables in use changes for
> example.

By numbers of groups worth? And full groups get free, unmixed and
filled by movable objects?

>> I'm assuming it will level off at
>> some size for long times (hours) under normal operations.
>
> It doesn't unless you assume the system remains in a steady state for it's
> lifetime. Things like updatedb tend to throw a spanner into the works.

Moved to cron weekly here. And even normally it is only once a day. So
what if it starts moving some pages while updatedb runs. If it isn't
too braindead it will reclaim some dentries updated has created and
left for good. It should just cause the dentry cache to be smaller at
no cost. I'm not calling that normal operations. That is a once a day
special. What I don't want is to spend 1% of cpu time copying
pages. That would be unacceptable. Copying 1000 pages per updatedb run
would be trivial on the other hand.

>> There should
>> be some buffering of a few groups to be held back in reserve when it
>> shrinks to prevent the scenario that the size is just at a group
>> boundary and always grows/shrinks by 1 group.
>> 
>
> And what size should this group be that all workloads function?

1 is enough to prevent jittering. If you don't hold a group back and
you are exactly at a group boundary then alternatingly allocating and
freeing one page would result in a group allocation and freeing every
time. With one group in reserve you only get an group allocation or
freeing when a groupd worth of change has happened.

This assumes that changing the type and/or state of a group is
expensive. Takes time or locks or some such. Otherwise just let it
jitter.

>> >> So if
>> >> you evict movable objects from mixed group when needed all the
>> >> pagetable pages would end up in the same mixed group slowly taking it
>> >> over completly. No fragmentation at all. See how essential that
>> >> feature is. :)
>> >> 
>> >
>> > To move pages, there must be enough blocks free. That is where
>> > min_free_kbytes had to come in. If you cared only about keeping 64KB
>> > chunks free, it makes sense but it didn't in the context of hugepages.
>> 
>> I'm more concerned with keeping the little unmovable things out of the
>> way. Those are the things that will fragment the memory and prevent
>> any huge pages to be available even with moving other stuff out of the
>> way.
>
> That's fair, just not cheap

That is the price you pay. To allocate 2MB of ram you have to have 2MB
of free ram or make them free. There is no way around that. Moving
pages means that you can actually get those 2MB even if the price
is high and that you have more choice deciding what to throw away or
swap out. I would rather have a 2MB malloc take some time than have it
fail because the kernel doesn't feel like it.

>> Can you tell me how? I would like to do the same.
>> 
>
> They were generated using trace_allocmap kernel module in
> http://www.csn.ul.ie/~mel/projects/vmregress/vmregress-0.81-rc2.tar.gz
> in combination with frag-display in the same package.  However, in the
> current version against current -mm's, it'll identify some movable pages
> wrong. Specifically, it will appear to be mixing movable pages with slab
> pages and it doesn't identify SLUB pages properly at all (SLUB came after
> the last revision of this tool). I need to bring an annotation patch up to
> date before it can generate the images correctly.

Thanks. I will test that out and see what I get on a few lustre
servers and clients. That is probably quite a different workload from
what you test.

MfG
        Goswin
