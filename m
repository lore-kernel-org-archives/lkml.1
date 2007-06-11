Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXFKSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXFKSWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXFKSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:22:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48156 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXFKSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fEhFuX6vcLT7taS2ngniUQ2h/p5n299ALuZMGfmcaLBKPq/8TEMb2c+P3SoBvUm6qTlHu4PuSCvcjm6N6P+PofGhuIOojZVbgIYkPjtneFeOB6YZwNYxzHDrIVPVAOu4c+zoArk52bNy69/vELSrFanlbjvGOJgmKdi0ZjIx7zg=
Message-ID: <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
Date: Mon, 11 Jun 2007 20:22:07 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
	 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
	 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
	 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
	 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> Ok. Drop the patch and use this one instead. This one avoids the use
> of smaller slabs that cause the conflict. The first slab will be sized 32
> bytes instead of 8.

Thanks, I'll test it tomorrow.

> Note that I do not get why you would be aligning the objects to 32 bytes.
> Increasing the smallest cache size wastes a lot of memory. And it is
> usually advantageous if multiple related objects are in the same cacheline
> unless you have heavy SMP contention.

It's not about performance at all, it's about DMA buffers allocated
using kmalloc() getting corrupted. Imagine this:

1. A SPI protocol driver allocates a buffer using kmalloc()
2. SPI master driver receives a request and flushes all cachelines
touched by the buffer (using dma_map_single()) before handing it to
the DMA controller.
3. While the transfer is in progress, something else comes along and
reads something from a different buffer which happens to share a
cacheline with the buffer currently being used for DMA.
4. When the transfer is complete, the protocol driver will see stale
data because a part of the buffer was fetched by the dcache before the
received data was stored in RAM by the DMA controller.

Maybe there are other solutions to this problem, but the old SLAB
allocator did guarantee 32-byte alignment as long as SLAB debugging
was turned off, so setting ARCH_KMALLOC_MINALIGN seemed like the
easiest way to get back to the old, known-working behaviour.

It could be that I've underestimated the AVR32 AP cache though; I
think it can do partial writeback of cachelines, so it could be a
solution to writeback+invalidate the parts of the buffer that may have
shared cachelines from dma_unmap_*() and dma_sync_*_for_cpu(). It will
probably hit a few false positives since it might not always see the
whole buffer, but perhaps it's worth it.

Haavard
