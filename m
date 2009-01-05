Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZAEScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZAEScR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZAEScB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:32:01 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:40821 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZAEScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DzdUwOWZR3jFSMQeibsR53Vg2NhB7+YS85LiGYPFBuKDgCAAShakjzZ+rFjCE7A0SH
         h7XuHK5UbRFuhxsuRmGmBR84LrreRliXYd9geLweGzP4FoNcUNEy9092oitOet7nSZAa
         ZaySg3+bxr01TYRRdR4/tTiski6U4z5Nx5gks=
Message-ID: <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
Date: Mon, 5 Jan 2009 11:31:57 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before DMA
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, maciej.sosnowski@intel.com, ralf@linux-mips.org
In-Reply-To: <20081229.025352.01917409.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230305468-18021-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <20081227111037.3bd13adc@hskinnemoen-d830>
	 <20081229.025352.01917409.anemo@mba.ocn.ne.jp>
X-Google-Sender-Auth: 02a660bb9ad8d8c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 10:53 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Sat, 27 Dec 2008 11:10:37 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
>> Atsushi Nemoto wrote:
>> > @@ -226,6 +227,12 @@ static int dmatest_func(void *data)
>> >
>> >             dmatest_init_srcbuf(thread->srcbuf, src_off, len);
>> >             dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
>> > +           /* flush and invalidate caches for whole dstbuf */
>> > +           dma_dest = dma_map_single(chan->device->dev,
>> > +                           thread->dstbuf,
>> > +                           test_buf_size, DMA_BIDIRECTIONAL);
>> > +           dma_unmap_single(chan->device->dev, dma_dest,
>> > +                           test_buf_size, DMA_BIDIRECTIONAL);
>>
>> You're supposed to unmap after the DMA operation is done, not before
>> it's submitted.
>>
>> In this case, the DMA engine framework will do the unmapping for you
>> (probably using the wrong primitive, but they're really all the same in
>> practice, right?) so you can just drop the unmap call.
>
> Well, let me explain more.
>
> On nono-coherent MIPS platforms, dma_map_single() for DMA_TO_DEVICE
> writeback the cache, dma_map_single() for DMA_FROM_DEVICE invalidated
> (without writeback) the cache.  dma_unmap_simgle() is a nop.
>
> If dst_off was not cacheline aligned, dma_map_single(...,
> DMA_FROM_DEVICE) in dma_async_memcpy_buf_to_buf() invalidate whole
> cachelines including dst_off.  So, for example, the initialized data
> at dst_off - 1 will be just discarded.  This result mismatch error of
> course.  Same error can be happen at end of the real DMA area.
>
> I added dma_map_single/dma_unmap_single to just flush all dstbuf to
> main memory.
>

I am tempted to say this is a bug in the MIPS dma_map_single
implementation.  It is at least a difference in behavior from ARM
where partial cachelines are cleaned+invalidated in the
DMA_FROM_DEVICE case [1].

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mm/cache-xsc3l2.c#l82
