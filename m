Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYL0KLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYL0KLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYL0KLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:11:05 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53774 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbYL0KLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:11:04 -0500
Date: Sat, 27 Dec 2008 11:10:37 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before
 DMA
Message-ID: <20081227111037.3bd13adc@hskinnemoen-d830>
In-Reply-To: <1230305468-18021-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1230305468-18021-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> @@ -226,6 +227,12 @@ static int dmatest_func(void *data)
>  
>  		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
>  		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
> +		/* flush and invalidate caches for whole dstbuf */
> +		dma_dest = dma_map_single(chan->device->dev,
> +				thread->dstbuf,
> +				test_buf_size, DMA_BIDIRECTIONAL);
> +		dma_unmap_single(chan->device->dev, dma_dest,
> +				test_buf_size, DMA_BIDIRECTIONAL);

You're supposed to unmap after the DMA operation is done, not before
it's submitted.

In this case, the DMA engine framework will do the unmapping for you
(probably using the wrong primitive, but they're really all the same in
practice, right?) so you can just drop the unmap call.

Now, I suspect the dw_dmac driver maps the buffer when it's not
supposed to, masking this kind of error...should probably get that
fixed too.

Haavard
