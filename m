Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXEDNc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXEDNc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXEDNc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:32:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33868 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXEDNcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:32:25 -0400
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
Date: Fri, 04 May 2007 07:31:37 -0600
In-Reply-To: <20070427080321.GG32602149@melbourne.sgi.com> (David Chinner's
	message of "Fri, 27 Apr 2007 18:03:21 +1000")
Message-ID: <m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Fri, Apr 27, 2007 at 12:04:03AM -0700, Andrew Morton wrote:
>
> I've looked at all this but I'm trying to work out if anyone
> else has looked at the impact of doing this. I have direct experience
> with this form of block aggregation - this is pretty much what is
> done in irix - and it's full of nasty, ugly corner cases.
>
> I've got several year-old Irix bugs  assigned that are hit every so
> often where one page in the aggregated set has the wrong state, and
> it's simply not possible to either reproduce the problem or work out
> how it happened. The code has grown too complex and convoluted, and
> by the time the problem is noticed (either by hang, panic or bug
> check) the cause of it is long gone.
>
> I don't want to go back to having to deal with this sort of problem
> - I'd much prefer to have a design that does not make the same
> mistakes that lead to these sorts of problem.

So the practical question is.  Was it a high level design problem or
was it simply a choice of implementation issue.

Until we code review and implementation that does page aggregation for
linux we can't say how nasty it would be.

Of course what gets confusing is when you mention you refer to the
previous implementation as a buffer cache, because that isn't at all
what Linux had for a buffer cache.  The linux buffer cache was the
same as the current page cache except it was index by block number and
not by offset into a file.

>> 
>> You're addressing Christoph's straw man here.
>
> No, I'm speaking from years of experience working on a
> page/buffer/chunk cache capable of using both large pages and
> aggregating multiple pages. It has, at times, almost driven me
> insane and I don't want to go back there.

The suggestion seems to be to always aggregate pages (to handle
PAGE_SIZE < block size), and not to even worry about the fact
that it happens that the pages you are aggregating are physically
contiguous.  The memory allocator and the block layer can worry
about that.  It isn't something the page cache or filesystems
need to pay attention to.

I suspect the implementation in linux would be sufficiently different
that it would not be prone to the same problems.  Among other things
we are already do most things on a range of page addresses, so we
would seem to have most of the infrastructure already.

It looks like if we extend the current batching a little more
so it covers all of the interesting cases. (read)

Ensure the dirty bit on all pages in the group when we set it on
one page.

Add re-read when we dirty the group if we don't have it all present.

Round the range we operate on up so we cleanly hit the beginning
and end of the group size.

Only issue the mapping operations on the first page in the group.

Is about what we would have to do to handle multiple pages in one
block in the page cache.  There are clearly more details but as
a first approximation I don't see this being fundamentally more
complex then what we are currently doing.  Just taking into account a
few more details.



The whole physical continuity thing seems to come cleanly out of a
speculative page allocator, and that would seem to work and provide
improvements on smaller block sizes filesystems so it looks like
a larger general improvement.

Likewise Jens increase the linux scatter gather list size seems like 
a more general independent improvement.

So if we can also handle groups of pages that make up a single block
as a independent change we have all of the benefits of large block
sizes with most of them applying to small sector size filesystems
as well.

Given that small block sizes give us better storage efficiency,
which means less disk bandwidth used, which means less time
to get the data off of a slow disk (especially if you can
put multiple files you want simultaneously in that same space).
I'm not convinced that large block sizes are a clear disk performance
advantage, so we should not neglect the small file sizes.

Eric
