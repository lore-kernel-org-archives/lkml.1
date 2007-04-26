Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXDZKL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXDZKL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDZKL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:11:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52877 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476AbXDZKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:11:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Chinner <dgc@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<46303A98.9000605@yahoo.com.au>
	<20070426063830.GE32602149@melbourne.sgi.com>
Date: Thu, 26 Apr 2007 04:10:32 -0600
In-Reply-To: <20070426063830.GE32602149@melbourne.sgi.com> (David Chinner's
	message of "Thu, 26 Apr 2007 16:38:30 +1000")
Message-ID: <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Thu, Apr 26, 2007 at 03:37:28PM +1000, Nick Piggin wrote:
>> I think starting with the assumption that we _want_ to use higher order
>> allocations, and then creating all this complexity around that is not a
>> good one, and if we start introducing things that _require_ significant
>> higher order allocations to function then it is a nasty thing for
>> robustness.
>
>>From my POV, we started with the problem of how to provide atomic
> access to a multi-page block in the page cache. For example, we want
> to lock the filesystem block and prevent any updates to it, so we
> need to lock all the pages in it. And then when we write them back,
> they all need to change state at the same time, and they all need to
> have their radix tree tags changed at the same time, the problem of
> mapping them to disk, getting writeback to do block aligned and
> sized writeback chunks, and so on.

Ok.  That is a reasonable problem and worth solving.

I suspect the easiest way to go is to have something in the code
that points all of the locking activities at the first page in the
block.  Like large pages do but they don't have to be physically
contiguous.

I think that would be even less code then what you are proposing.

> And then there's the problem that most hardware is limited to 128
> s/g entries and that means 128 non-contiguous pages in memory is the
> maximum I/O size we can issue to these devices. We have RAID arrays
> that go twice as fast if we can send them 1MB I/Os instead of 512k
> I/Os and that means we need contiguous pages to be handled to the
> devices....

Ok.  Now why are high end hardware manufacturers building crippled
hardware?  Or is there only an 8bit field in SCSI for describing
scatter gather entries?  Although I would think this would be
move of a controller ranter than a drive issue.

> All of these things require some aggregating structure to
> co-ordinate. In times gone by on other OSs, this has been done with
> a buffer cache, but Linux got rid of that long ago and we don't want
> to reintroduce one. We can't use buffer heads - they can only point
> to one page. So what do we do?

For I/O we have the BIO which can point to multiple pages just fine.

Buffer heads are irrelevant.  The question is how do we get to
the page cache from the BIO and from the BIO to the page cache.

> That's where compound pages are so nice - they solve all of these
> problems with only a very small amount of code perturbation and they
> don't change any algorithms or fundamental design of the OS at all.

The change the fundamental fragmentation avoidance algorithm of the
OS.  Use only one size of page.  That is a huge problem.

Yes we do relax that rule but only on things that we don't care
about much and don't mind failing.

> We don't have to rewrite filesystems to support this. We don't have
> to redesign the VM to support this. We don't have to do very much
> work to the block layer and drivers to make this work.

This changes the fundamental algorithm for avoiding fragmentation
problems in the VM.  Don't have multiple page sizes.

That rule is relaxed allowing us to use larger pages in special
cases but this is not a special case.  This is the common case.

That is a huge concern.

> FWIW, if you want 32 bit machines to support larger than 16TB
> devices, you need high order page indexing in the page cache....

Huh?  Only if you are doing raw device accesses.  We are limited
to 16TB files.

>> >That would make the choice of using larger order pages (essentially
>> >increasing PAGE_SIZE) something that can be investigated in parallel.
>> 
>> I agree that hardware inefficiencies should be handled by increasing
>> PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.
>
> And what do we do for arches that can't do multiple page sizes, only
> only have a limited and mostly useless set of page sizes to choose
> from?

You have HW_PAGE_SIZE != PAGE_SIZE.    That is you hide the fact from
the bulk of the kernel struct page manges 2 or more real hardware pages.
But you expose it to the handful of places that actually care.

Partly this is a path you are starting down in your patches, with
larger page cache support.


Eric
