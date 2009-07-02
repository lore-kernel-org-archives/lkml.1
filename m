Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZGBBS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZGBBS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZGBBSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:18:21 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:36777 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZGBBSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UtgHSr2jWB1+T55PBJP278Xc8EEXr+WMigM16wqkU5Zh10fXB8iEuUQzH91CMcbWdG
         UtdpPd0fBeKJ4yH0yVP2Za5zGQRbtAq2NUEyvqLWA3cPUZh9s9BR0DUMuGQecLb6M8IA
         eisgzilKn5dF6nsJc9rt+kRT+KO4wx/N3NzX4=
MIME-Version: 1.0
In-Reply-To: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 1 Jul 2009 18:18:23 -0700
X-Google-Sender-Auth: e67f6bb88e9503cf
Message-ID: <e9c3a7c20907011818q6151b7e1gf6d89f52296362f2@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel AHB 
	DMA Controller
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 3:42 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.
>
> This first release covers only the memory-to-memory tranfer type. This is the
> only tranfer type supported by this chip.  On other products, it will be used
> also for peripheral DMA transfer (slave API support to come).
>
> I used dmatest client without problem in different configurations to test it.
>
> Full documentation for this controller can be found in the SAM9RL datasheet:
> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
[..]

A quick review comment:

> +/**
> + * atc_desc_get - get a unsused descriptor from free_list
> + * @atchan: channel we want a new descriptor for
> + */
> +static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
> +{
> +       struct at_desc *desc, *_desc;
> +       struct at_desc *ret = NULL;
> +       unsigned int i = 0;
> +       LIST_HEAD(tmp_list);
> +
> +       spin_lock_bh(&atchan->lock);
> +       list_for_each_entry_safe(desc, _desc, &atchan->free_list, desc_node) {
> +               i++;
> +               if (async_tx_test_ack(&desc->txd)) {
> +                       list_del(&desc->desc_node);
> +                       ret = desc;
> +                       break;
> +               }
> +               dev_dbg(chan2dev(&atchan->chan_common),
> +                               "desc %p not ACKed\n", desc);
> +       }
> +       spin_unlock_bh(&atchan->lock);
> +       dev_vdbg(chan2dev(&atchan->chan_common),
> +               "scanned %u descriptors on freelist\n", i);
> +
> +       /* no more descriptor available in initial pool : create some more */
> +       if (!ret) {
> +               for (i = 0; i < INIT_NR_DESCS_PER_CHANNEL; i++) {
> +                       desc = atc_alloc_descriptor(&atchan->chan_common,
> +                                                   GFP_KERNEL);

This cannot be GFP_KERNEL as ->prep_dma_memcpy may be called from an
atomic context.  Given that this should only be done in emergency
situations this allocation should probably happen one descriptor at a
time, if it must happen at all.  My recommendation is that if you find
that the driver runs out of descriptors on a regular basis increase
INIT_NR_DESCS_PER_CHANNEL  and only operate with the descriptors
allocated from atc_alloc_chan_resources().  As it stands this allows
the descriptor list to grow without bounds.

Regards,
Dan
