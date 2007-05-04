Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXEDM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXEDM54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXEDM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:57:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51842 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbXEDM5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:57:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
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
	<20070427014849.41f383f7.akpm@linux-foundation.org>
Date: Fri, 04 May 2007 06:57:18 -0600
In-Reply-To: <20070427014849.41f383f7.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 27 Apr 2007 01:48:49 -0700")
Message-ID: <m1irb8u4pd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 27 Apr 2007 18:03:21 +1000 David Chinner <dgc@sgi.com> wrote:
>
>> > > > > You basically have to
>> > > > > jump through nasty, nasty hoops, to handle corner cases that are
> introduced
>> > > > > because the generic code can no longer reliably lock out access to a
>> > > > > filesystem block.
>> > > 
>> > > This way lies insanity.
>> > 
>> > You're addressing Christoph's straw man here.
>> 
>> No, I'm speaking from years of experience working on a
>> page/buffer/chunk cache capable of using both large pages and
>> aggregating multiple pages. It has, at times, almost driven me
>> insane and I don't want to go back there.
>
> We're talking about two separate things here - let us not conflate them.
>
> 1: The arguably-crippled HBA which wants bigger SG lists.
>
> 2: The late-breaking large-blocksizes-in-the-fs thing.

Well from other parts of the conversation there is a third issue.
  3: large-sectorsize-on-disk.

There are a handful of devices in the kernel that could benefit
and be cleaned up a great deal if they could assume they always
received data in their sg lists that were full sectors.  Nothing
needs to be physically contiguous to handle that case though.

If we support large sector sizes for raw block devices we would
still have an issue of what to do with filesystems that want
to live on them directly.

> None of this multiple-page-locking stuff we're discussing here is relevant
> to the HBA performance problem.  It's pretty simple (I think) for us to
> ensure that, for the great majority of the time, contiguous pages in a file
> are also physically contiguous.  Problem solved, HBA go nice and quick,
> move on.

I suspect we will still need Jens > 128 page linux scatter gather list
work to fully take advantage of this.

> Now, we have this the second and completely unrelated requirement:
> supporting fs-blocksize > PAGE_SIZE.  One way to address this is via the
> mangle-multiple-pages-into-one approach.  And it's obviously the best way
> to do it, if mangle-multiple-pages is already available.

Yep.

> But I don't know how important requirement 2 is.  XFS already has
> presumably-working private code to do it, and there is simplification and
> perhaps modest performance gain in the block allocator to be had here.
>
> And other filesystems (ie: ext4) _might_ use it.  But ext4 is extent-based,
> so perhaps it's not work churning the on-disk format to get a bit of a
> boost in the block allocator.
>
> So I _think_ what this boils down to is offering some simplifications in
> XFS, by adding complexications to core VFS and MM.  I dunno if that's a
> good deal.

Agreed.

When we are doing things optimistically and absolutely require large pages
this approach seems pretty sane.   When we start requiring large 64k
pages I get nervous.

> So...  tell us why you want feature 2?

A good question.

Eric
