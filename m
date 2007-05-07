Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXEGE6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXEGE6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXEGE6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:58:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39525 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753925AbXEGE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:58:53 -0400
Date: Mon, 7 May 2007 14:58:35 +1000
From: David Chinner <dgc@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070507045835.GU32602149@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 07:31:37AM -0600, Eric W. Biederman wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > On Fri, Apr 27, 2007 at 12:04:03AM -0700, Andrew Morton wrote:
> > I've got several year-old Irix bugs  assigned that are hit every so
> > often where one page in the aggregated set has the wrong state, and
> > it's simply not possible to either reproduce the problem or work out
> > how it happened. The code has grown too complex and convoluted, and
> > by the time the problem is noticed (either by hang, panic or bug
> > check) the cause of it is long gone.
> >
> > I don't want to go back to having to deal with this sort of problem
> > - I'd much prefer to have a design that does not make the same
> > mistakes that lead to these sorts of problem.
> 
> So the practical question is.  Was it a high level design problem or
> was it simply a choice of implementation issue.

Both. To many things can happen asynchroonously to a page that it
makes it just about impossible to predict all the potential race
conditions that are involved. complexity arose from trying to fix
the races that were uncovered without breaking everything else...

> Until we code review and implementation that does page aggregation for
> linux we can't say how nasty it would be.

We already have an implementation - I've pointed it out several times
now: see fs/xfs/linux-2.6/xfs_buf.[ch].

There are a lot of nasties in there....

> >> You're addressing Christoph's straw man here.
> >
> > No, I'm speaking from years of experience working on a
> > page/buffer/chunk cache capable of using both large pages and
> > aggregating multiple pages. It has, at times, almost driven me
> > insane and I don't want to go back there.
> 
> The suggestion seems to be to always aggregate pages (to handle
> PAGE_SIZE < block size), and not to even worry about the fact
> that it happens that the pages you are aggregating are physically
> contiguous.  The memory allocator and the block layer can worry
> about that.  It isn't something the page cache or filesystems
> need to pay attention to.

perfomrance problems in using discontigous pages and needing to
vmap() them says otherwise....

> I suspect the implementation in linux would be sufficiently different
> that it would not be prone to the same problems.  Among other things
> we are already do most things on a range of page addresses, so we
> would seem to have most of the infrastructure already.

Filesystems don't typically do this - they work on blocks and assume
that a block can be directly referenced.

> Given that small block sizes give us better storage efficiency,
> which means less disk bandwidth used, which means less time
> to get the data off of a slow disk (especially if you can
> put multiple files you want simultaneously in that same space).
> I'm not convinced that large block sizes are a clear disk performance
> advantage, so we should not neglect the small file sizes.

Hmmm - we're not talking about using 64k block size filesystems to
store lots of little files or using them on small, slow disks.
We're looking at optimising for multi-petabyte filesystems with
multi-terabyte sized files sustaining throughput of tens to hundreds
of GB/s to/from hundreds to thousands of disk.

I certinaly don't consider 64k block size filesystems as something
suitable for desktop use - maybe PVRs would benefit, but this
is not something you'd use for your kernel build environment on a
single disk in a desktop system....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
