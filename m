Return-Path: <linux-kernel-owner+w=401wt.eu-S1763541AbXIMRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763541AbXIMRSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXIMRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:17:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:14510 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbXIMRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VhueWTeKbloGZ1/zeWRSMZXfwQO59r9pDqDUTZ+vvkL96nIJcKF3k73cpzCUF+4MS/8TlmdCvQBMiNvrnrKsGwFxjyc2nPBTDvdpcIjf8s7LXRJjTtYl9CIUXmnKxtc1znXm63OUkMU2WutqNIpz+0hSLBLLhlOFgEhvt/luTgY=
Message-ID: <e9c3a7c20709131017m622f5f0dke9f6d7ab95adc9b0@mail.gmail.com>
Date: Thu, 13 Sep 2007 10:17:55 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Cc: paulus@samba.org, shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       "Zhu Ebony-r57400" <ebony.zhu@freescale.com>, timur@freescale.com
In-Reply-To: <46B96294322F7D458F9648B60E15112C85D620@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
	 <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
	 <46B96294322F7D458F9648B60E15112C85D620@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Dan,
>
> Does I have followed your new API? :-)
>
[..]
> > > +static struct dma_chan
> > *of_find_dma_chan_by_phandle(phandle phandle)
> > > +{
> > > +       struct device_node *np;
> > > +       struct dma_chan *chan;
> > > +       struct fsl_dma_device *fdev;
> > > +
> > > +       np = of_find_node_by_phandle(phandle);
> > > +       if (!np || !of_device_is_compatible(np->parent, "fsl,dma"))
> > > +               return NULL;
> > > +
> > > +       fdev =
> > dev_get_drvdata(&of_find_device_by_node(np->parent)->dev);
> > > +
> > > +       list_for_each_entry(chan, &fdev->common.channels,
> > device_node)
> > > +               if
> > (to_of_device(to_fsl_chan(chan)->chan_dev)->node == np)
> > > +                       return chan;
> > > +       return NULL;
> > > +}
> > > +EXPORT_SYMBOL(of_find_dma_chan_by_phandle);
> >
> > This routine implies that there is a piece of code somewhere that
> > wants to select which channels it can use.  A similar effect can be
> > achieved by registering a dma_client with the dmaengine interface
> > ('dma_async_client_register').  Then when the client code makes a call
> > to 'dma_async_client_chan_request' it receives a 'dma_event_callback'
> > for each channel in the system.  It will also be asynchronously
> > notified of channels entering and leaving the system.  The goal is to
> > share a common infrastructure for channel management.
> >
>
> It's speacial codes for our processors. Some device need the speacial DMA channel, such as must be DMA channel 0. So I add these codes. Or, is it possible to add a API for the special DMA channel getting?

Timur had mentioned that this is for device tree support, but your
comment makes me think that this is for client support.  This sounds
like a case where you can define a dma_client to find a specific
channel, something like:
http://marc.info/?l=linux-kernel&m=118417229619156&w=2

> > > +
> > > +static int __devinit of_fsl_dma_probe(struct of_device *dev,
> > > +                       const struct of_device_id *match)
> > > +{
> > > +       int err;
> > > +       unsigned int irq;
> > > +       struct fsl_dma_device *fdev;
> > > +
> > > +       fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
> > > +       if (!fdev) {
> > > +               dev_err(&dev->dev, "No enough memory for 'priv'\n");
> > > +               err = -ENOMEM;
> > > +               goto err;
> > > +       }
> > > +       fdev->dev = &dev->dev;
> > > +       INIT_LIST_HEAD(&fdev->common.channels);
> > > +
> > > +       /* get DMA controller register base */
> > > +       err = of_address_to_resource(dev->node, 0, &fdev->reg);
> > > +       if (err) {
> > > +               dev_err(&dev->dev, "Can't get %s property 'reg'\n",
> > > +                               dev->node->full_name);
> > > +               goto err;
> > > +       }
> > > +
> > > +       dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
> > > +                       "controller at 0x%08x...\n",
> > > +                       match->compatible, fdev->reg.start);
> > > +       fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
> > > +                                               -
> > fdev->reg.start + 1);
> > > +
> > > +       dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > > +       fdev->common.device_alloc_chan_resources =
> > fsl_dma_alloc_chan_resources;
> > > +       fdev->common.device_free_chan_resources =
> > fsl_dma_free_chan_resources;
> > > +       fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
> > > +       fdev->common.device_is_tx_complete = fsl_dma_is_complete;
> > > +       fdev->common.device_issue_pending =
> > fsl_dma_memcpy_issue_pending;
> > > +       fdev->common.device_dependency_added =
> > fsl_dma_dependency_added;
> > > +       fdev->common.dev = &dev->dev;
> > > +
> > If this driver adds:
> >
> > dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> > fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
> >
> > It will be able to take advantage of interrupt triggered callbacks in
> > async_tx.  Without these changes async_tx will poll for the completion
> > of each transaction.
> >
>
> The new API have lacking documents :) I'll make some study here.
>
Yes, I will address that...

> Thanks!
> - zw

Regards,
Dan
