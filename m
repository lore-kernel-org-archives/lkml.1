Return-Path: <linux-kernel-owner+w=401wt.eu-S1031448AbXDZSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031448AbXDZSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031450AbXDZSvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:51:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:55529 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031448AbXDZSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AY7TyrEsnb9XriJavSOVVaUUZHLjQ7xiSvPRQnEk6XW7OEbR+BfsO/7JVSMjQRaREq772lW8DASOIArCnGMu46A2fNMQHEJGOWhmOooVAoQAe7/i05mgKz80aoc56VyIo6Yox2nUPzqsv5lJxL5L+LdHgFCXWk/Db5E+LxS9Vx8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: clameter@sgi.com
Subject: Re: [00/17] Large Blocksize Support V3
Date: Thu, 26 Apr 2007 21:50:17 +0300
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>
References: <20070424222105.883597089@sgi.com>
In-Reply-To: <20070424222105.883597089@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262150.18748.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 01:21, clameter@sgi.com wrote:
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
>    sizes on all allows a significant reduction in I/O overhead and
> increases the size of I/O that can be performed by hardware in a single
> request since the number of scatter gather entries are typically limited
> for one request. This is going to become increasingly important to support
> the ever growing memory sizes since we may have to handle excessively large
> amounts of 4k requests for data sizes that may become common soon. For
> example to write a 1 terabyte file the kernel would have to handle 256
> million 4k chunks.
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
>   It is likely that Mel Gorman's anti-frag patches and some more
>   work by him on defragmentation may be needed if one wants to use
>   super sized pages.
>   If you run a 2.6.21 kernel with this patch and start a kernel compile
>   on a 4k volume with a concurrent copy operation to a 64k volume on
>   a system with only 1 Gig then you will go boom (ummm no ... OOM) fast.
>   How well Mel's antifrag/defrag methods address this issue still has to
>   be seen.
>
> Future:
> - Mmap support could be done in a way that makes the mmap page size
>   independent from the page cache order. It is okay to map a 4k section
>   of a larger page cache page via a pte. 4k mmap semantics can be
> completely preserved even for larger page sizes.
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

Hi,
	I really like the idea of block size > page size

I just want to suggest mine ideas about how to implement it (I can't do that 
since it is too compicated for me and I don't have time now)


I visualized this like that:

For size <= 4K , page still holds a 1 or more blocks.

For size > 4K:

A page holds a fraction of block, and its ->buffer_head also holds info about 
that fraction.

But that ->bh contains a ->next pointer (or a list_head) that combines 
all fractions of block in single one.



This will minimize changes in fs code.

Today fs blindly uses bh retured by block code.
A modifed filesystem will also read from linked ->next bhs to get all parts of 
block. 

For blocksizes <= 4k that ->next will be null indicating that that bh 
contatins whole block. 

Then inplementation of block address_space opertions should not change a lot 
too.

They will be just aware that that page can be linked with other pages of same 
block and do that right thing. 

For example:

->readpage will not only read _that_ page but also will read all sibling pages
->writepage will magicly write not only that page but siblings too.


buffer_head alredy has pointer to page so it is easy to get page from buffer 
head:

page -> private -> next -> page -> private ...

andf so on (sorry, but I did a study (for myself, trying to improve 
packet-writing) on that a half year ago, so I don't remember now much about 
that)


What about that ?


Best regards,
	Maxim Levitsky
