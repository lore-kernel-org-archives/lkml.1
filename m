Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbXEGG5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbXEGG5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXEGG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:57:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41489 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbXEGG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:57:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<20070427060921.GA77450368@melbourne.sgi.com>
	<20070427000403.6013d1fa.akpm@linux-foundation.org>
	<20070427080321.GG32602149@melbourne.sgi.com>
	<m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
	<20070507045835.GU32602149@melbourne.sgi.com>
Date: Mon, 07 May 2007 00:56:27 -0600
In-Reply-To: <20070507045835.GU32602149@melbourne.sgi.com> (David Chinner's
	message of "Mon, 7 May 2007 14:58:35 +1000")
Message-ID: <m13b29ktpg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> Both. To many things can happen asynchroonously to a page that it
> makes it just about impossible to predict all the potential race
> conditions that are involved. complexity arose from trying to fix
> the races that were uncovered without breaking everything else...

Ok.

>> Until we code review and implementation that does page aggregation for
>> linux we can't say how nasty it would be.
>
> We already have an implementation - I've pointed it out several times
> now: see fs/xfs/linux-2.6/xfs_buf.[ch].
>
> There are a lot of nasties in there....

Yes, and but it isn't a generic implementation in mm/filemap.c,
it is a compatibility layer.  It lives with the current deficiencies
instead of removes them.

>> >> You're addressing Christoph's straw man here.
>> >
>> > No, I'm speaking from years of experience working on a
>> > page/buffer/chunk cache capable of using both large pages and
>> > aggregating multiple pages. It has, at times, almost driven me
>> > insane and I don't want to go back there.
>> 
>> The suggestion seems to be to always aggregate pages (to handle
>> PAGE_SIZE < block size), and not to even worry about the fact
>> that it happens that the pages you are aggregating are physically
>> contiguous.  The memory allocator and the block layer can worry
>> about that.  It isn't something the page cache or filesystems
>> need to pay attention to.
>
> perfomrance problems in using discontigous pages 
Small scatter lists?

> and needing to vmap() them says otherwise....
Always?

Ugh.  I just realized looking at the xfs code that it doesn't
work in the presence of high memory, at least not with 4K pages.

>> I suspect the implementation in linux would be sufficiently different
>> that it would not be prone to the same problems.  Among other things
>> we are already do most things on a range of page addresses, so we
>> would seem to have most of the infrastructure already.
>
> Filesystems don't typically do this - they work on blocks and assume
> that a block can be directly referenced.

But that is how mm/filemap.c works.  The calls into the filesystem
can be per multi-page group as they are current per page.  The point
is that the existing in kernel abstraction  is already larger then a
page for doing the work.

>> Given that small block sizes give us better storage efficiency,
>> which means less disk bandwidth used, which means less time
>> to get the data off of a slow disk (especially if you can
>> put multiple files you want simultaneously in that same space).
>> I'm not convinced that large block sizes are a clear disk performance
>> advantage, so we should not neglect the small file sizes.
>
> Hmmm - we're not talking about using 64k block size filesystems to
> store lots of little files or using them on small, slow disks.
> We're looking at optimising for multi-petabyte filesystems with
> multi-terabyte sized files sustaining throughput of tens to hundreds
> of GB/s to/from hundreds to thousands of disk.
>
> I certinaly don't consider 64k block size filesystems as something
> suitable for desktop use - maybe PVRs would benefit, but this
> is not something you'd use for your kernel build environment on a
> single disk in a desktop system....

Yes.  You are talking about only fixing the kernel for your giant
64K block filesystems that are only interesting on peta-byte arrays.

I am pointing out that the other fixes that have been discussed.
Optimistic contiguous page allocation and a larger linux scatter
gather list.  Are interesting on much smaller filesystem and machine
sizes where small files are still interesting.  Making them generally
better improvements for linux.

If you only improve the giant peta-byte raid cases 99% of linux users
simply don't care, and so the code isn't very interesting.

Eric
