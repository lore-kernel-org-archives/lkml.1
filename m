Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZDRUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZDRUF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZDRUFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:05:19 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:48379 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZDRUFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QRr2n/qEAc++HWHdlcIPexKTofH3/etDl9nB3xi79syey03kCoMihaOSTbEK2hGKTz
         mM5BKfFhIrjQO/JyUpTviPdzrFZE1If0Uwf1NErmjaJZDvTHzyZelzpWHznmUXqxKlbP
         hOT9Ql5rWObXkEF4pbEQxWFmiNFseNdhdat+w=
MIME-Version: 1.0
In-Reply-To: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Sat, 18 Apr 2009 13:05:15 -0700
X-Google-Sender-Auth: b4571e93e38307fd
Message-ID: <e9c3a7c20904181305l5a7ea5dcy881b7faec8e447bf@mail.gmail.com>
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 8:54 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> This patch adds support for the integrated DMAC of the TXx9 family.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

Not quite "ackable" yet...

> +#ifdef CONFIG_MACH_TX49XX
> +#define TXX9_DMA_MAY_HAVE_64BIT_REGS
> +#define TXX9_DMA_HAVE_CCR_LE
> +#define TXX9_DMA_HAVE_SMPCHN
> +#define TXX9_DMA_HAVE_IRQ_PER_CHAN
> +#endif
> +
> +#ifdef TXX9_DMA_HAVE_SMPCHN
> +#define TXX9_DMA_USE_SIMPLE_CHAIN
> +#endif
> +

There seems to be a lot of ifdef magic in the code based on these
defines.  Can we move this magic and some of the pure definitions to
drivers/dma/txx9dmac.h?  (See the "#ifdefs are ugly" section of
Documentation/SubmittingPatches)

> +static struct dma_async_tx_descriptor *
> +txx9dmac_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> +               size_t len, unsigned long flags)
[..]
> +               if (!first) {
> +                       first = desc;
> +               } else {
> +                       desc_write_CHAR(dc, prev, desc->txd.phys);
> +                       dma_sync_single_for_device(chan2parent(&dc->chan),
> +                                       prev->txd.phys, ddev->descsize,
> +                                       DMA_TO_DEVICE);
> +                       list_add_tail(&desc->desc_node,
> +                                       &first->txd.tx_list);
> +               }

Is there a reason to keep f'irst' off of the tx_list?  It seems like
you could simplify this logic and get rid of the scary looking
list_splice followed by list_add in txx9dmac_desc_put.  It also seems
odd that the descriptors on tx_list are not reachable from the
dc->queue list after a submit... but maybe I am missing a subtle
detail?

Regards,
Dan
