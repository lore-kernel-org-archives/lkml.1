Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYL1RyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYL1RyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 12:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYL1Rxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 12:53:55 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57350 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYL1Rxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 12:53:54 -0500
Date: Mon, 29 Dec 2008 02:53:52 +0900 (JST)
Message-Id: <20081229.025352.01917409.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
 before DMA
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20081227111037.3bd13adc@hskinnemoen-d830>
References: <1230305468-18021-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20081227111037.3bd13adc@hskinnemoen-d830>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 11:10:37 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> Atsushi Nemoto wrote:
> > @@ -226,6 +227,12 @@ static int dmatest_func(void *data)
> >  
> >  		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
> >  		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
> > +		/* flush and invalidate caches for whole dstbuf */
> > +		dma_dest = dma_map_single(chan->device->dev,
> > +				thread->dstbuf,
> > +				test_buf_size, DMA_BIDIRECTIONAL);
> > +		dma_unmap_single(chan->device->dev, dma_dest,
> > +				test_buf_size, DMA_BIDIRECTIONAL);
> 
> You're supposed to unmap after the DMA operation is done, not before
> it's submitted.
> 
> In this case, the DMA engine framework will do the unmapping for you
> (probably using the wrong primitive, but they're really all the same in
> practice, right?) so you can just drop the unmap call.

Well, let me explain more.

On nono-coherent MIPS platforms, dma_map_single() for DMA_TO_DEVICE
writeback the cache, dma_map_single() for DMA_FROM_DEVICE invalidated
(without writeback) the cache.  dma_unmap_simgle() is a nop.

If dst_off was not cacheline aligned, dma_map_single(...,
DMA_FROM_DEVICE) in dma_async_memcpy_buf_to_buf() invalidate whole
cachelines including dst_off.  So, for example, the initialized data
at dst_off - 1 will be just discarded.  This result mismatch error of
course.  Same error can be happen at end of the real DMA area.

I added dma_map_single/dma_unmap_single to just flush all dstbuf to
main memory.

> Now, I suspect the dw_dmac driver maps the buffer when it's not
> supposed to, masking this kind of error...should probably get that
> fixed too.

I don't think so.  But I'm not sure dma_map_sg() case in
dwc_prep_slave_sg().

---
Atsushi Nemoto
