Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZAHEnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZAHEnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZAHEno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:43:44 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:40261 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380AbZAHEnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:43:43 -0500
Date: Thu, 08 Jan 2009 13:43:36 +0900 (JST)
Message-Id: <20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, maciej.sosnowski@intel.com, ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
 before DMA
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
References: <20081227111037.3bd13adc@hskinnemoen-d830>
	<20081229.025352.01917409.anemo@mba.ocn.ne.jp>
	<e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 11:31:57 -0700, "Dan Williams" <dan.j.williams@intel.com> wrote:
> >> > @@ -226,6 +227,12 @@ static int dmatest_func(void *data)
> >> >
> >> >             dmatest_init_srcbuf(thread->srcbuf, src_off, len);
> >> >             dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
> >> > +           /* flush and invalidate caches for whole dstbuf */
> >> > +           dma_dest = dma_map_single(chan->device->dev,
> >> > +                           thread->dstbuf,
> >> > +                           test_buf_size, DMA_BIDIRECTIONAL);
> >> > +           dma_unmap_single(chan->device->dev, dma_dest,
> >> > +                           test_buf_size, DMA_BIDIRECTIONAL);
...
> > Well, let me explain more.
> >
> > On nono-coherent MIPS platforms, dma_map_single() for DMA_TO_DEVICE
> > writeback the cache, dma_map_single() for DMA_FROM_DEVICE invalidated
> > (without writeback) the cache.  dma_unmap_simgle() is a nop.
> >
> > If dst_off was not cacheline aligned, dma_map_single(...,
> > DMA_FROM_DEVICE) in dma_async_memcpy_buf_to_buf() invalidate whole
> > cachelines including dst_off.  So, for example, the initialized data
> > at dst_off - 1 will be just discarded.  This result mismatch error of
> > course.  Same error can be happen at end of the real DMA area.
> >
> > I added dma_map_single/dma_unmap_single to just flush all dstbuf to
> > main memory.
> 
> I am tempted to say this is a bug in the MIPS dma_map_single
> implementation.  It is at least a difference in behavior from ARM
> where partial cachelines are cleaned+invalidated in the
> DMA_FROM_DEVICE case [1].

I should argue another reason to do writeback/invalidate here in
dmatest for non-coherent archs (not only for MIPS).

The dmatest compares dstbuf outside the real DMA region to detect
illegal overwriting.  But on non-coherent archs, this comparison just
validates contents of cache, not main memory.  So dmatest might not
able to detect illegal overwriting.  Doing writeback/invalidate
_whole_ dstbuf are before dma_async_memcpy_buf_to_buf() will make
dmatest more strict.

This is why I used DMA_BIDIRECTIONAL for whole dstbuf area rather than
DMA_TO_DEVICE for two cache lines on both edges of the real DMA area.

Doesn't this make sense?

---
Atsushi Nemoto
