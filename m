Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXDZGiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXDZGiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXDZGiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:38:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35230 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932953AbXDZGiy (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:38:54 -0400
Date: Thu, 26 Apr 2007 16:38:30 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426063830.GE32602149@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46303A98.9000605@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 03:37:28PM +1000, Nick Piggin wrote:
> I think starting with the assumption that we _want_ to use higher order
> allocations, and then creating all this complexity around that is not a
> good one, and if we start introducing things that _require_ significant
> higher order allocations to function then it is a nasty thing for
> robustness.

>From my POV, we started with the problem of how to provide atomic
access to a multi-page block in the page cache. For example, we want
to lock the filesystem block and prevent any updates to it, so we
need to lock all the pages in it. And then when we write them back,
they all need to change state at the same time, and they all need to
have their radix tree tags changed at the same time, the problem of
mapping them to disk, getting writeback to do block aligned and
sized writeback chunks, and so on.

And then there's the problem that most hardware is limited to 128
s/g entries and that means 128 non-contiguous pages in memory is the
maximum I/O size we can issue to these devices. We have RAID arrays
that go twice as fast if we can send them 1MB I/Os instead of 512k
I/Os and that means we need contiguous pages to be handled to the
devices....

All of these things require some aggregating structure to
co-ordinate. In times gone by on other OSs, this has been done with
a buffer cache, but Linux got rid of that long ago and we don't want
to reintroduce one. We can't use buffer heads - they can only point
to one page. So what do we do?

That's where compound pages are so nice - they solve all of these
problems with only a very small amount of code perturbation and they
don't change any algorithms or fundamental design of the OS at all.

We don't have to rewrite filesystems to support this. We don't have
to redesign the VM to support this. We don't have to do very much
work to the block layer and drivers to make this work.

FWIW, if you want 32 bit machines to support larger than 16TB
devices, you need high order page indexing in the page cache....

> >Is it common for hardware that supports large block sizes to not
> >support splitting those blocks apart during DMA?  Unless it is common
> >the whole premise of this patchset seems broken.
> >
> >I suspect what needs to be fixed is the page cache block device
> >interface so that we have helper functions that know how to stuff
> >a single block into several pages.
> 
> I am working now and again on some code to do this, it is a big job but
> I think it is the right way to do it. But it would take a long time to
> get stable and supported by filesystems...

Compared to a method that requires almost no change to the
filesystems that want to support large block sizes?

> >That would make the choice of using larger order pages (essentially
> >increasing PAGE_SIZE) something that can be investigated in parallel.
> 
> I agree that hardware inefficiencies should be handled by increasing
> PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.

And what do we do for arches that can't do multiple page sizes, only
only have a limited and mostly useless set of page sizes to choose
from?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
