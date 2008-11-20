Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYKTKzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYKTKzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 05:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYKTKzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 05:55:33 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:1333 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYKTKzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 05:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u2B+eZfZsxH3dNh1qrw4qy1P9e9O8EDQBNoRMSDcYU39LHYK5O63aq+tYhjgdu+pI0
         qKCtvAtDmBzFZv3H1OEamXLzequp+KHQhoh4x9BEkJ2cZIMBavkKli30aiEp+itcSoSb
         bHlv/0DJc1j5k3EQg88SqQ2x2DorXUQGrAI1U=
Message-ID: <d8dd82df0811200255t1780a03ah8207077d4c94bcf2@mail.gmail.com>
Date: Thu, 20 Nov 2008 16:25:31 +0530
From: "Naval Saini" <navalnovel@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com
In-Reply-To: <20081120091923.GA2515@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com>
	 <200811191740.23638.nickpiggin@yahoo.com.au>
	 <20081119204315.GB17209@flint.arm.linux.org.uk>
	 <200811201759.01039.nickpiggin@yahoo.com.au>
	 <20081120091923.GA2515@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel/Nick:

Thanks for the replies - I would like to reply ASAP to the mails (out
of interest also) - but have been unable to for  some reasons. I donot
understand all that has been talked about in the discussions and would
spend more time before I reply to your suggestions.

We are working on arm 11 based embedded systems and were debugging an
issue with mkfs.xfs (uses O_DIRECT) utility. After quite a bit of
debugging, we found a pattern in addresses of user space buffers
allocated with memalign. For some address (of these buffers), the
format would result in corrupt disk. By applying this patch, I was
able to allocate memory that was page color aligned (as required by
arm technical ref. manual). We have observed the same problems in VIVT
caches (arm 9 processor) based. We also found that we could do away
with the problem by disabling cache.

Rest, the problem was observed not during O_DIRECT write (but at time
of read). When the same buffer was used and when user virtual address
(UVA) and kernal virtual address (KVA) did not meet alignment
requirements, the d_cache_invalidate operation (in consistent_sync
func in consistent.c) on KVA did not have the desired affect. When the
same memory was accessed from UVA (that should have been invalidated
along with KVA invalidation), it corrupted the buffer we had just
read. This in mkfs.xfs utility, corrupted the disk format. In lay man
terms, looked like KVA and UVA occupied seperate locations in cache,
when they were used one after the other (specifically KVA after UVA).

Hope this would be of immidiate help. I would comment on the strageies
proposed by nick in next mail.

Further as i have said, our kernel version in linux-2.6.18.5 ,
uclibc-0.9.28 , mkfs is irrelevant.

Thanks,
Naval


On 11/20/08, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Nov 20, 2008 at 05:59:00PM +1100, Nick Piggin wrote:
>  > Basically, an O_DIRECT write involves:
>  >
>  > - The program storing into some virtual address, then passing that virtual
>  >   address as the buffer to write(2).
>  >
>  > - The kernel will get_user_pages() to get the struct page * of that user
>  >   virtual address. At this point, get_user_pages does flush_dcache_page.
>  >   (Which should write back the user caches?)
>  >
>  > - Then the struct page is sent to the block layer (it won't tend to be
>  >   touched by the kernel via the kernel linear map, unless we have like an
>  >   "emulated" block device block device like 'brd').
>  >
>  > - Even if it is read via the kernel linear map, AFAIKS, we should be OK
>  >   due to the flush_dcache_page().
>
>
> That seems sane, and yes, flush_dcache_page() will write back and
>  invalidate dirty cache lines in both the kernel and user mappings.
>
>
>  > An O_DIRECT read involves:
>  >
>  > - Same first 2 steps as O_DIRECT write, including flush_dcache_page. So the
>  >   user mapping should not have any previously dirtied lines around.
>  >
>  > - The page is sent to the block layer, which stores into the page. Some
>  >   block devices like 'brd' will potentially store via the kernel linear map
>  >   here, and they probably don't do enough cache flushing. But a regular
>  >   block device should go via DMA, which AFAIK should be OK? (the user address
>  >   should remain invalidated because it would be a bug to read from the buffer
>  >   before the read has completed)
>
>
> This is where things get icky with lots of drivers - DMA is fine, but
>  many PIO based drivers don't handle the implications of writing to the
>  kernel page cache page when there may be CPU cache side effects.
>
>  If the cache is in read allocate mode, then in this case there shouldn't
>  be any dirty cache lines.  (That's not always the case though, esp. via
>  conventional IO.)  If the cache is in write allocate mode, PIO data will
>  sit in the kernel mapping and won't be visible to userspace.
>
>  That is a years-old bug, one that I've been unable to run tests for here
>  (because my platforms don't have the right combinations of CPUs supporting
>  write alloc and/or a problem block driver.)  I've even been accused of
>  being uncooperative over testing possible bug fixes by various people
>  (if I don't have hardware which can show the problem, how can I test
>  possible fixes?)  So I've given up with that issue - as far as I'm
>  concerned, it's a problem for others to sort out.
>
>  Do we know what hardware, which IO drivers are being used, and any
>  relevent configuration of the drivers?
>
