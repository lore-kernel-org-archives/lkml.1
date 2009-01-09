Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZAIIbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZAIIbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZAIIbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:31:06 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:61641 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752355AbZAIIbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:31:05 -0500
Date: Fri, 09 Jan 2009 17:30:57 +0900 (JST)
Message-Id: <20090109.173057.25877173.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
 before DMA
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20901080920r1051775ey7dbb4fad37b2810@mail.gmail.com>
References: <20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
	<20090108093603.691c1200@hskinnemoen-d830>
	<e9c3a7c20901080920r1051775ey7dbb4fad37b2810@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 10:20:56 -0700, "Dan Williams" <dan.j.williams@intel.com> wrote:
> On Thu, Jan 8, 2009 at 1:36 AM, Haavard Skinnemoen
> > I think it does. The dmatest driver should definitely use
> > DMA_BIDIRECTIONAL on the destination buffer to ensure that the poison
> > values are written to RAM and not just written to cache and discarded.
> 
> True.
> 
> > Now, this probably means that the destination buffer must be _unmapped_
> > with DMA_BIDIRECTIONAL too, which is difficult to do with the current
> > asymmetrical API...
> 
> A map and unmap should work for the current platforms with dma
> drivers, but you are right I think this is a violation of the api.
> For correctness we would need the entire operation covered by
> DMA_BIDIRECTIONAL to support platforms that may implement a dma bounce
> buffer.  Or, we could change dmatest to not go through the dma-memcpy
> api, allowing dma_alloc to be used for the destination.

Do you mean something like this?

		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);

		dma_src = dma_map_single(dev->dev, src + src_off, len,
			 DMA_TO_DEVICE);
		dma_dest = dma_map_single(dev->dev, dest_buf, test_buf_size,
			DMA_BIDIRECTIONAL);
		tx = dev->device_prep_dma_memcpy(chan, dma_dest + dst_off,
				dma_src, len,
				DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP);
		if (!tx) {
			/* error */
		}
		tx->callback = NULL;
		cookie = tx->tx_submit(tx);
		...
		/* wait for completion */
		...
		dma_unmap_single(dev->dev, dma_dest, test_buf_size,
			DMA_BIDIRECTIONAL);

It will make dmatest more aggressive, for example, a option for
testing DMA_PREP_INTERRUPT handling of a lowlevel driver can be added
easily.

---
Atsushi Nemoto
