Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZAHIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZAHIg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZAHIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:36:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63538 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753487AbZAHIgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:36:18 -0500
Date: Thu, 8 Jan 2009 09:36:03 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before
 DMA
Message-ID: <20090108093603.691c1200@hskinnemoen-d830>
In-Reply-To: <20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
References: <20081227111037.3bd13adc@hskinnemoen-d830>
	<20081229.025352.01917409.anemo@mba.ocn.ne.jp>
	<e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
	<20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> I should argue another reason to do writeback/invalidate here in
> dmatest for non-coherent archs (not only for MIPS).
> 
> The dmatest compares dstbuf outside the real DMA region to detect
> illegal overwriting.  But on non-coherent archs, this comparison just
> validates contents of cache, not main memory.  So dmatest might not
> able to detect illegal overwriting.  Doing writeback/invalidate
> _whole_ dstbuf are before dma_async_memcpy_buf_to_buf() will make
> dmatest more strict.
> 
> This is why I used DMA_BIDIRECTIONAL for whole dstbuf area rather than
> DMA_TO_DEVICE for two cache lines on both edges of the real DMA area.
> 
> Doesn't this make sense?

I think it does. The dmatest driver should definitely use
DMA_BIDIRECTIONAL on the destination buffer to ensure that the poison
values are written to RAM and not just written to cache and discarded.

Now, this probably means that the destination buffer must be _unmapped_
with DMA_BIDIRECTIONAL too, which is difficult to do with the current
asymmetrical API...

In the general case, however, I think MIPS has a bug: I've seen drivers
DMA to/from tiny buffers stored inside another struct. This is legal
because the driver can guarantee that the other fields in the struct
aren't accessed in the mean time, but any fields sharing a cacheline
with the buffer must be written back before the lines are invalidated.

Haavard
