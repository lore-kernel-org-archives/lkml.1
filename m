Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZGGOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZGGOzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZGGOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:55:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11465 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbZGGOzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G/n0mn1sOroosSpR4eNLqrPiRwRkJyg1a3gXt3sSlil2N5nx7oFF8w62q53N4CnnGo
         4ZCA9J6kZzgLvy3q8W9f52MP0F7KbU0SectzWGs3yx22m7kJIpUvslAS8RaevL+DQP9F
         5nRQBAlvH0coA3+rct3gQuXPXWHeDtJKnLzNM=
MIME-Version: 1.0
In-Reply-To: <200907071606.48933.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	 <20090707074821.GB6995@n2100.arm.linux.org.uk>
	 <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
	 <200907071606.48933.arnd@arndb.de>
Date: Tue, 7 Jul 2009 22:55:03 +0800
Message-ID: <d82e647a0907070755m150b8aa0x3ae8faf1c47587f9@mail.gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in 
	dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/7 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 07 July 2009, Ming Lei wrote:
>> > ARM has two (normal, and dma bounce), and in the long run we need to do
>>
>> OK, Can we use dma-mapping-common.h on ARM?
>
> It should work in principle. It may be a good idea to also move to
> the generic swiotlb instead of the traditional dma bounce at the
> same time.
>
> Note that dma-mapping-common.h is only needed if you want to support
> two or more different DMA implementations in a single kernel, which
> I'm not sure is needed for ARM.
>
>> > cache handling on unmap as well as map due to CPU speculative fetches.
>>
>> IMHO, it seems we can fix this problem now.
>>
>> For DMA_TO_DEVICE transfer, clean cache in dma map, but does nothing in
>> dma unmap;
>>
>> For  DMA_FROM_DEVICE, we may do nothing in dma map, but invaliate cache
>> in dma unmap.
>
> A number of other architectures do this already. You also need to
> have dma_sync_*_for_cpu and dma_sync_*_for_device, where the *_for_device
> operation needs to do the same flushing as dma_map_* and *_for_cpu
> does the same as dma_unmap_*.
>
> Note that actually you need to do writeback+invalidate in DMA_TO_DEVICE

IMHO,  writeback in dma map is enough for DMA_TO_DEVICE transfer.

> and at least an invalidate in DMA_FROM_DEVICE during dma_map_*.
> For the unmap, I don't think you ever need to invalidate the cache.

No,  as Russell said that CPU speculative fetches can make cache "dirty" after
dma map but before dma is over, then CPU may read inconsistent data
after DMA_FROM_DEVICE transfer is finished if does not invalidate
cache in
dma unmap.

> If you invalidate only at unmap time for DMA_FROM_DEVICE, a dirty
> cache line might be accidentally flushed to the buffer after
> the device has written to it.

It seems you are reasonable, and we do need to invalidate cache in both dma
map and dma unmap for DMA_FROM_DEVICE, don't we?

-- 
Lei Ming
