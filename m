Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZDSSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZDSSev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZDSSel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:34:41 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58097 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZDSSel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:34:41 -0400
Date: Mon, 20 Apr 2009 03:34:46 +0900 (JST)
Message-Id: <20090420.033446.65190767.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20904181305l5a7ea5dcy881b7faec8e447bf@mail.gmail.com>
References: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20904181305l5a7ea5dcy881b7faec8e447bf@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 13:05:15 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> Not quite "ackable" yet...

Thank you for review!

> > +#ifdef CONFIG_MACH_TX49XX
> > +#define TXX9_DMA_MAY_HAVE_64BIT_REGS
> > +#define TXX9_DMA_HAVE_CCR_LE
> > +#define TXX9_DMA_HAVE_SMPCHN
> > +#define TXX9_DMA_HAVE_IRQ_PER_CHAN
> > +#endif
> > +
> > +#ifdef TXX9_DMA_HAVE_SMPCHN
> > +#define TXX9_DMA_USE_SIMPLE_CHAIN
> > +#endif
> > +
> 
> There seems to be a lot of ifdef magic in the code based on these
> defines.  Can we move this magic and some of the pure definitions to
> drivers/dma/txx9dmac.h?  (See the "#ifdefs are ugly" section of
> Documentation/SubmittingPatches)

OK, I will try to clean them up.  But since I don't want to export
internal implementation details, some of the magics will be left in
txx9dmac.c, perhaps.

> > +static struct dma_async_tx_descriptor *
> > +txx9dmac_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> > +               size_t len, unsigned long flags)
> [..]
> > +               if (!first) {
> > +                       first = desc;
> > +               } else {
> > +                       desc_write_CHAR(dc, prev, desc->txd.phys);
> > +                       dma_sync_single_for_device(chan2parent(&dc->chan),
> > +                                       prev->txd.phys, ddev->descsize,
> > +                                       DMA_TO_DEVICE);
> > +                       list_add_tail(&desc->desc_node,
> > +                                       &first->txd.tx_list);
> > +               }
> 
> Is there a reason to keep f'irst' off of the tx_list?  It seems like
> you could simplify this logic and get rid of the scary looking
> list_splice followed by list_add in txx9dmac_desc_put.  It also seems
> odd that the descriptors on tx_list are not reachable from the
> dc->queue list after a submit... but maybe I am missing a subtle
> detail?

Well, I'm not sure what do you mean...

The completion callback handler of the first descriptor should be
called _after_ the completion of the _last_ child of the descriptor.
Also I use desc_node for both dc->queue, dc->active_list and
txd.tx_list.  So if I putted all children to dc->queue or
dc->active_list, txx9dmac_descriptor_complete() (or its caller) will
be more complex.

Or do you mean adding another list_head to maintain txd.tx_list?  Or
something another at all?

---
Atsushi Nemoto
