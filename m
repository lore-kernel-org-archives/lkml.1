Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXDZExG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXDZExG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbXDZExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:53:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47676 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXDZEwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:52:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
Date: Wed, 25 Apr 2007 22:51:21 -0600
In-Reply-To: <20070424222105.883597089@sgi.com> (clameter@sgi.com's message of
	"Tue, 24 Apr 2007 15:21:05 -0700")
Message-ID: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com writes:

> V2->V3
> - More restructuring
> - It actually works!
> - Add XFS support
> - Fix up UP support
> - Work out the direct I/O issues
> - Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
>   back to constants. Disabled for 32bit and HIGHMEM configurations.
>   This also allows a gradual migration to the new page cache
>   inline functions. LARGE_BLOCKSIZE capabilities can be
>   added gradually and if there is a problem then we can disable
>   a subsystem.
>
> V1->V2
> - Some ext2 support
> - Some block layer, fs layer support etc.
> - Better page cache macros
> - Use macros to clean up code.
>
> This patchset modifies the Linux kernel so that larger block sizes than
> page size can be supported. Larger block sizes are handled by using
> compound pages of an arbitrary order for the page cache instead of
> single pages with order 0.

Huh?

You seem to be mixing two very different concepts.

The page cache has no problems supporting things with a block
size larger then page size.  Now the block device layer may not
have the code to do the scatter gather into small pages and it
may not handle buffer heads whose data is split between multiple
pages. 

But this is not a page cache issue.

And generally larger physical pages are a mistake to use.
Especially as it looks from some of the later comment you don't
date test on 32bit because the memory fragments faster.

Is it common for hardware that supports large block sizes to not
support splitting those blocks apart during DMA?  Unless it is common
the whole premise of this patchset seems broken.

I suspect what needs to be fixed is the page cache block device
interface so that we have helper functions that know how to stuff
a single block into several pages.

That would make the choice of using larger order pages (essentially
increasing PAGE_SIZE) something that can be investigated in parallel.

Right now I don't even want to think about trying to use a swap device
with a large block size when we are low on memory.

>
> Rationales:
>
> 1. We have problems supporting devices with a higher blocksize than
>    page size. This is for example important to support CD and DVDs that
>    can only read and write 32k or 64k blocks. We currently have a shim
>    layer in there to deal with this situation which limits the speed
>    of I/O. The developers are currently looking for ways to completely
>    bypass the page cache because of this deficiency.

block device /page cache interface issue.

> 2. 32/64k blocksize is also used in flash devices. Same issues.

flash devices are not block devices so I strongly doubt it is
the same issue.

> 3. Future harddisks will support bigger block sizes that Linux cannot
>    support since we are limited to PAGE_SIZE. Ok the on board cache
>    may buffer this for us but what is the point of handling smaller
>    page sizes than what the drive supports?

No fragmenting memory and keeping the system running. 

> 4. Reduce fsck times. Larger block sizes mean faster file system checking.

Fewer seeks and less meta-data means faster fsck times.  Larger block
sizes get us there only tangentially.  

> 5. Performance. If we look at IA64 vs. x86_64 then it seems that the
>    faster interrupt handling on x86_64 compensate for the speed loss due to
>    a smaller page size (4k vs 16k on IA64). Supporting larger block sizes
>    sizes on all allows a significant reduction in I/O overhead and increases
>    the size of I/O that can be performed by hardware in a single request
>    since the number of scatter gather entries are typically limited for
>    one request. This is going to become increasingly important to support
>    the ever growing memory sizes since we may have to handle excessively
>    large amounts of 4k requests for data sizes that may become common
>    soon. For example to write a 1 terabyte file the kernel would have to
>    handle 256 million 4k chunks.

This assumes you get the option of large files and batching things as
the systems scale.  At SGI maybe that is true.  However in general
you gets lots of small requests as systems scale up.

For example I have gigabytes of kernel trees.  How are larger requests
going to speed of my reading and writing of those?  And yes even with
8G of ram I have enough kernel trees that they fall out of memory.
So cache is not the only answer.

> 6. Cross arch compatibility: It is currently not possible to mount
>    an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
>    With this patch this becoems possible.

Again this is a problem with the page cache block device interface not
a page cache problem.

I think supporting larger block sizes is a nice goal.  However unless
we are bumping up against hardware limitations let's see how far
we can go with batching and fixing the block layer/page cache interface
instead of assuming that larger page sizes are the answer.

Eric
