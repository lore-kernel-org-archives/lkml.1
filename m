Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXIIRx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXIIRx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 13:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXIIRxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 13:53:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:51162 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbXIIRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 13:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PiRd0kls82q1PgCWqF0umZWOqd2UbsLYCGaAKzcTMiXUhQgYQQGJZj7em499yvrSJapmcbAp9GoGocUatGFGT81mp+WXLg8qNPxCy6w8wS+Yj6uULhXsZ7Y0NZZLRfajcvf92hpNfMQCC4xcVzs4phI5gjtLCxUQvBcKH6solqs=
Message-ID: <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
Date: Sun, 9 Sep 2007 10:53:44 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Cc: paulus@samba.org, shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       "Ebony Zhu" <ebony.zhu@freescale.com>
In-Reply-To: <11891624582950-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
X-Google-Sender-Auth: 1a53e971a5541876
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/07, Zhang Wei <wei.zhang@freescale.com> wrote:
> The driver implements DMA engine API for Freescale MPC85xx DMA
> controller, which could be used for MEM<-->MEM, IO_ADDR<-->MEM
> and IO_ADDR<-->IO_ADDR data transfer.
> The driver supports the Basic mode of Freescale MPC85xx DMA controller.
> The MPC85xx processors supported include MPC8540/60, MPC8555, MPC8548,
> MPC8641 and so on.
> The support for MPC83xx(MPC8349, MPC8360) is experimental.
>
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> Signed-off-by: Ebony Zhu <ebony.zhu@freescale.com>
> ---
Greetings,

Please copy me on any updates to this driver, drivers/dma, or crypto/async_tx.

Below are a few review comments...

Regards,
Dan

> +/**
> + * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
> + *
> + * Return - The descriptor allocated. NULL for failed.
> + */
> +static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
> +                                       struct fsl_dma_chan *fsl_chan,
> +                                       gfp_t flags)
> +{
> +       dma_addr_t pdesc;
> +       struct fsl_desc_sw *desc_sw;
> +
> +       desc_sw = dma_pool_alloc(fsl_chan->desc_pool, flags, &pdesc);
> +       if (desc_sw) {
> +               memset(desc_sw, 0, sizeof(struct fsl_desc_sw));
> +               dma_async_tx_descriptor_init(&desc_sw->async_tx,
> +                                               &fsl_chan->common);
> +               desc_sw->async_tx.tx_set_src = fsl_dma_set_src;
> +               desc_sw->async_tx.tx_set_dest = fsl_dma_set_dest;
> +               desc_sw->async_tx.tx_submit = fsl_dma_tx_submit;
> +               INIT_LIST_HEAD(&desc_sw->async_tx.tx_list);
> +               desc_sw->async_tx.phys = pdesc;
> +       }
> +
> +       return desc_sw;
> +}

I suggest pre-allocating the descriptors:
1/ It alleviates the need to initialize these async_tx fields which never change
2/ The GFP_ATOMIC allocation can be removed.

iop-adma gets by with one PAGE_SIZE buffer (128 descriptors).

[..]
> +static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
> +{
> +       struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
> +       dma_addr_t stat;
> +
> +       stat = get_sr(fsl_chan);
> +       dev_dbg(fsl_chan->device->dev, "event: channel %d, stat = 0x%x\n",
> +                                               fsl_chan->id, stat);
> +       set_sr(fsl_chan, stat);         /* Clear the event register */
> +
> +       stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
> +       if (!stat)
> +               return IRQ_NONE;
> +
> +       /* If the link descriptor segment transfer finishes,
> +        * we will recycle the used descriptor.
> +        */
> +       if (stat & FSL_DMA_SR_EOSI) {
> +               dev_dbg(fsl_chan->device->dev, "event: End-of-segments INT\n");
> +               dev_dbg(fsl_chan->device->dev, "event: clndar 0x%016llx, "
> +                               "nlndar 0x%016llx\n", (u64)get_cdar(fsl_chan),
> +                               (u64)get_ndar(fsl_chan));
> +               stat &= ~FSL_DMA_SR_EOSI;
> +               fsl_chan_ld_cleanup(fsl_chan, 1);
> +       }
> +
> +       /* If it current transfer is the end-of-transfer,
> +        * we should clear the Channel Start bit for
> +        * prepare next transfer.
> +        */
> +       if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
> +               dev_dbg(fsl_chan->device->dev, "event: End-of-link INT\n");
> +               stat &= ~FSL_DMA_SR_EOLNI;
> +               fsl_chan_xfer_ld_queue(fsl_chan);
> +       }
> +
> +       if (stat)
> +               dev_dbg(fsl_chan->device->dev, "event: unhandled sr 0x%02x\n",
> +                                       stat);
> +
> +       dev_dbg(fsl_chan->device->dev, "event: Exit\n");
> +       tasklet_hi_schedule(&dma_tasklet);
> +       return IRQ_HANDLED;
> +}

This driver implements locking and callbacks inconsistently with how
it is done in ioatdma and iop-adma.  The big changes are that all
locks have been upgraded from 'spin_lock_bh' to 'spin_lock_irqsave',
and async_tx callbacks can happen in irq context.  I would like to
keep everything in bottom-half context to lessen the restrictions on
what async_tx clients can perform in their callback routines.  What
are the implications of moving 'fsl_chan_ld_cleanup' to the tasklet
and changing the 'tasklet_hi_schedule' to 'tasklet_schedule'?

[..]
> +static struct dma_chan *of_find_dma_chan_by_phandle(phandle phandle)
> +{
> +       struct device_node *np;
> +       struct dma_chan *chan;
> +       struct fsl_dma_device *fdev;
> +
> +       np = of_find_node_by_phandle(phandle);
> +       if (!np || !of_device_is_compatible(np->parent, "fsl,dma"))
> +               return NULL;
> +
> +       fdev = dev_get_drvdata(&of_find_device_by_node(np->parent)->dev);
> +
> +       list_for_each_entry(chan, &fdev->common.channels, device_node)
> +               if (to_of_device(to_fsl_chan(chan)->chan_dev)->node == np)
> +                       return chan;
> +       return NULL;
> +}
> +EXPORT_SYMBOL(of_find_dma_chan_by_phandle);

This routine implies that there is a piece of code somewhere that
wants to select which channels it can use.  A similar effect can be
achieved by registering a dma_client with the dmaengine interface
('dma_async_client_register').  Then when the client code makes a call
to 'dma_async_client_chan_request' it receives a 'dma_event_callback'
for each channel in the system.  It will also be asynchronously
notified of channels entering and leaving the system.  The goal is to
share a common infrastructure for channel management.

> +
> +static int __devinit of_fsl_dma_probe(struct of_device *dev,
> +                       const struct of_device_id *match)
> +{
> +       int err;
> +       unsigned int irq;
> +       struct fsl_dma_device *fdev;
> +
> +       fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
> +       if (!fdev) {
> +               dev_err(&dev->dev, "No enough memory for 'priv'\n");
> +               err = -ENOMEM;
> +               goto err;
> +       }
> +       fdev->dev = &dev->dev;
> +       INIT_LIST_HEAD(&fdev->common.channels);
> +
> +       /* get DMA controller register base */
> +       err = of_address_to_resource(dev->node, 0, &fdev->reg);
> +       if (err) {
> +               dev_err(&dev->dev, "Can't get %s property 'reg'\n",
> +                               dev->node->full_name);
> +               goto err;
> +       }
> +
> +       dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
> +                       "controller at 0x%08x...\n",
> +                       match->compatible, fdev->reg.start);
> +       fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
> +                                               - fdev->reg.start + 1);
> +
> +       dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> +       fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
> +       fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
> +       fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
> +       fdev->common.device_is_tx_complete = fsl_dma_is_complete;
> +       fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
> +       fdev->common.device_dependency_added = fsl_dma_dependency_added;
> +       fdev->common.dev = &dev->dev;
> +
If this driver adds:

dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;

It will be able to take advantage of interrupt triggered callbacks in
async_tx.  Without these changes async_tx will poll for the completion
of each transaction.

[..]
