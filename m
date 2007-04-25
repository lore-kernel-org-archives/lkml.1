Return-Path: <linux-kernel-owner+w=401wt.eu-S2992750AbXDYN2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992750AbXDYN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992762AbXDYN2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:28:12 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:39741 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992750AbXDYN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:28:10 -0400
Date: Wed, 25 Apr 2007 14:28:07 +0100
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425132807.GI19942@skynet.ie>
References: <20070424222105.883597089@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070424222105.883597089@sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nuts. Didn't spot V3 before I started V2, ah well.

On (24/04/07 15:21), clameter@sgi.com didst pronounce:
> V2->V3
> - More restructuring
> - It actually works!
> - Add XFS support
> - Fix up UP support
> - Work out the direct I/O issues
> - Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
>   back to constants. Disabled for 32bit and HIGHMEM configurations.

HIGHMEM I can understand because I suppose the kmap() issue is still in
there, but why 32 bit? Is this temporary or do you expect to see it
fixed up later?

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
> 
> Rationales:
> 
> 1. We have problems supporting devices with a higher blocksize than
>    page size. This is for example important to support CD and DVDs that
>    can only read and write 32k or 64k blocks. We currently have a shim
>    layer in there to deal with this situation which limits the speed
>    of I/O. The developers are currently looking for ways to completely
>    bypass the page cache because of this deficiency.
> 
> 2. 32/64k blocksize is also used in flash devices. Same issues.
> 
> 3. Future harddisks will support bigger block sizes that Linux cannot
>    support since we are limited to PAGE_SIZE. Ok the on board cache
>    may buffer this for us but what is the point of handling smaller
>    page sizes than what the drive supports?
> 
> 4. Reduce fsck times. Larger block sizes mean faster file system checking.
> 
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
> 
> 6. Cross arch compatibility: It is currently not possible to mount
>    an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
>    With this patch this becoems possible.
> 
> The support here is currently only for buffered I/O. Modifications for
> three filesystems are included:
> 
> A. XFS
> B. Ext2
> C. ramfs
> 
> Unsupported
> - Mmapping blocks larger than page size
> 
> Issues:
> - There are numerous places where the kernel can no longer assume that the
>   page cache consists of PAGE_SIZE pages that have not been fixed yet.
> - Defrag warning: The patch set can fragment memory very fast.

I bet they do.

>   It is likely that Mel Gorman's anti-frag patches and some more
>   work by him on defragmentation may be needed if one wants to use
>   super sized pages.

Very likely.

>   If you run a 2.6.21 kernel with this patch and start a kernel compile
>   on a 4k volume with a concurrent copy operation to a 64k volume on
>   a system with only 1 Gig then you will go boom (ummm no ... OOM) fast.

On systems with larger amounts of memory, it'll go boom eventually. More
memory does not magically avoid fragmentation problems.

>   How well Mel's antifrag/defrag methods address this issue still has to
>   be seen.
> 

The grouping pages by mobility should hold up for ext2 and XFS because
their page cache pages are reclaimable/movable and will get grouped with
other pages that are reclaimable/movable. ramfs may be a problem if it was
heavily used but lets see how things pan out.

> Future:
> - Mmap support could be done in a way that makes the mmap page size
>   independent from the page cache order. It is okay to map a 4k section
>   of a larger page cache page via a pte. 4k mmap semantics can be completely
>   preserved even for larger page sizes.
> - Maybe people could perform benchmarks to see how much of a difference
>   there is between 4k size I/O and 64k? Andrew surely would like to know.
> - If there is a chance for inclusion then I will diff this against mm,
>   do a complete scan over the kernel to find all page cache == PAGE_SIZE
>   assumptions and then try to get it upstream for 2.6.23.
> 
> How to make this work:
> 
> 1. Apply this patchset to 2.6.21-rc7
> 2. Configure LARGE_BLOCKSIZE Support
> 3. compile kernel
> 
> --

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
