Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbXIKKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbXIKKab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXIKKaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:30:22 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:46563 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbXIKKaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:30:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Tue, 11 Sep 2007 18:30:14 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C85D620@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Thread-Index: AcfzCmI2ZCTZf8r3R/+0HrOr64IE+wBUgLCg
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <paulus@samba.org>, <shannon.nelson@intel.com>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <galak@kernel.crashing.org>,
       "Zhu Ebony-r57400" <ebony.zhu@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan,

Does I have followed your new API? :-)

> > ---
> Greetings,
> 
> Please copy me on any updates to this driver, drivers/dma, or 
> crypto/async_tx.

Ok.

> 
> Below are a few review comments...
> 
> Regards,
> Dan
> 
> > +/**
> > + * fsl_dma_alloc_descriptor - Allocate descriptor from 
> channel's DMA pool.
> > + *
> > + * Return - The descriptor allocated. NULL for failed.
> > + */
> > +static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
> > +                                       struct fsl_dma_chan 
> *fsl_chan,
> > +                                       gfp_t flags)
> > +{
> > +       dma_addr_t pdesc;
> > +       struct fsl_desc_sw *desc_sw;
> > +
> > +       desc_sw = dma_pool_alloc(fsl_chan->desc_pool, 
> flags, &pdesc);
> > +       if (desc_sw) {
> > +               memset(desc_sw, 0, sizeof(struct fsl_desc_sw));
> > +               dma_async_tx_descriptor_init(&desc_sw->async_tx,
> > +                                               &fsl_chan->common);
> > +               desc_sw->async_tx.tx_set_src = fsl_dma_set_src;
> > +               desc_sw->async_tx.tx_set_dest = fsl_dma_set_dest;
> > +               desc_sw->async_tx.tx_submit = fsl_dma_tx_submit;
> > +               INIT_LIST_HEAD(&desc_sw->async_tx.tx_list);
> > +               desc_sw->async_tx.phys = pdesc;
> > +       }
> > +
> > +       return desc_sw;
> > +}
> 
> I suggest pre-allocating the descriptors:
> 1/ It alleviates the need to initialize these async_tx fields 
> which never change

The dma pool has already stored the descriptors in it's list,

> 2/ The GFP_ATOMIC allocation can be removed.
> 

Ok.

> iop-adma gets by with one PAGE_SIZE buffer (128 descriptors).
> 
> [..]
> > +static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
> > +{
> > +       struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
> > +       dma_addr_t stat;
> > +
> > +       stat = get_sr(fsl_chan);
> > +       dev_dbg(fsl_chan->device->dev, "event: channel %d, 
> stat = 0x%x\n",
> > +                                               fsl_chan->id, stat);
> > +       set_sr(fsl_chan, stat);         /* Clear the event 
> register */
> > +
> > +       stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
> > +       if (!stat)
> > +               return IRQ_NONE;
> > +
> > +       /* If the link descriptor segment transfer finishes,
> > +        * we will recycle the used descriptor.
> > +        */
> > +       if (stat & FSL_DMA_SR_EOSI) {
> > +               dev_dbg(fsl_chan->device->dev, "event: 
> End-of-segments INT\n");
> > +               dev_dbg(fsl_chan->device->dev, "event: 
> clndar 0x%016llx, "
> > +                               "nlndar 0x%016llx\n", 
> (u64)get_cdar(fsl_chan),
> > +                               (u64)get_ndar(fsl_chan));
> > +               stat &= ~FSL_DMA_SR_EOSI;
> > +               fsl_chan_ld_cleanup(fsl_chan, 1);
> > +       }
> > +
> > +       /* If it current transfer is the end-of-transfer,
> > +        * we should clear the Channel Start bit for
> > +        * prepare next transfer.
> > +        */
> > +       if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
> > +               dev_dbg(fsl_chan->device->dev, "event: 
> End-of-link INT\n");
> > +               stat &= ~FSL_DMA_SR_EOLNI;
> > +               fsl_chan_xfer_ld_queue(fsl_chan);
> > +       }
> > +
> > +       if (stat)
> > +               dev_dbg(fsl_chan->device->dev, "event: 
> unhandled sr 0x%02x\n",
> > +                                       stat);
> > +
> > +       dev_dbg(fsl_chan->device->dev, "event: Exit\n");
> > +       tasklet_hi_schedule(&dma_tasklet);
> > +       return IRQ_HANDLED;
> > +}
> 
> This driver implements locking and callbacks inconsistently with how
> it is done in ioatdma and iop-adma.  The big changes are that all
> locks have been upgraded from 'spin_lock_bh' to 'spin_lock_irqsave',
> and async_tx callbacks can happen in irq context.  I would like to
> keep everything in bottom-half context to lessen the restrictions on
> what async_tx clients can perform in their callback routines.  What
> are the implications of moving 'fsl_chan_ld_cleanup' to the tasklet
> and changing the 'tasklet_hi_schedule' to 'tasklet_schedule'?

A good suggestion :), I need some investigation here.

> 
> [..]
> > +static struct dma_chan 
> *of_find_dma_chan_by_phandle(phandle phandle)
> > +{
> > +       struct device_node *np;
> > +       struct dma_chan *chan;
> > +       struct fsl_dma_device *fdev;
> > +
> > +       np = of_find_node_by_phandle(phandle);
> > +       if (!np || !of_device_is_compatible(np->parent, "fsl,dma"))
> > +               return NULL;
> > +
> > +       fdev = 
> dev_get_drvdata(&of_find_device_by_node(np->parent)->dev);
> > +
> > +       list_for_each_entry(chan, &fdev->common.channels, 
> device_node)
> > +               if 
> (to_of_device(to_fsl_chan(chan)->chan_dev)->node == np)
> > +                       return chan;
> > +       return NULL;
> > +}
> > +EXPORT_SYMBOL(of_find_dma_chan_by_phandle);
> 
> This routine implies that there is a piece of code somewhere that
> wants to select which channels it can use.  A similar effect can be
> achieved by registering a dma_client with the dmaengine interface
> ('dma_async_client_register').  Then when the client code makes a call
> to 'dma_async_client_chan_request' it receives a 'dma_event_callback'
> for each channel in the system.  It will also be asynchronously
> notified of channels entering and leaving the system.  The goal is to
> share a common infrastructure for channel management.
> 

It's speacial codes for our processors. Some device need the speacial DMA channel, such as must be DMA channel 0. So I add these codes. Or, is it possible to add a API for the special DMA channel getting?

> > +
> > +static int __devinit of_fsl_dma_probe(struct of_device *dev,
> > +                       const struct of_device_id *match)
> > +{
> > +       int err;
> > +       unsigned int irq;
> > +       struct fsl_dma_device *fdev;
> > +
> > +       fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
> > +       if (!fdev) {
> > +               dev_err(&dev->dev, "No enough memory for 'priv'\n");
> > +               err = -ENOMEM;
> > +               goto err;
> > +       }
> > +       fdev->dev = &dev->dev;
> > +       INIT_LIST_HEAD(&fdev->common.channels);
> > +
> > +       /* get DMA controller register base */
> > +       err = of_address_to_resource(dev->node, 0, &fdev->reg);
> > +       if (err) {
> > +               dev_err(&dev->dev, "Can't get %s property 'reg'\n",
> > +                               dev->node->full_name);
> > +               goto err;
> > +       }
> > +
> > +       dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
> > +                       "controller at 0x%08x...\n",
> > +                       match->compatible, fdev->reg.start);
> > +       fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
> > +                                               - 
> fdev->reg.start + 1);
> > +
> > +       dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > +       fdev->common.device_alloc_chan_resources = 
> fsl_dma_alloc_chan_resources;
> > +       fdev->common.device_free_chan_resources = 
> fsl_dma_free_chan_resources;
> > +       fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
> > +       fdev->common.device_is_tx_complete = fsl_dma_is_complete;
> > +       fdev->common.device_issue_pending = 
> fsl_dma_memcpy_issue_pending;
> > +       fdev->common.device_dependency_added = 
> fsl_dma_dependency_added;
> > +       fdev->common.dev = &dev->dev;
> > +
> If this driver adds:
> 
> dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
> 
> It will be able to take advantage of interrupt triggered callbacks in
> async_tx.  Without these changes async_tx will poll for the completion
> of each transaction.
> 

The new API have lacking documents :) I'll make some study here.

Thanks!
- zw
