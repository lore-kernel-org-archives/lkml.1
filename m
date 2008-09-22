Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbYIVHof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbYIVHof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYIVHo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:44:27 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42173 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYIVHo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:44:26 -0400
Date: Mon, 22 Sep 2008 09:44:11 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Timur Tabi <timur@freescale.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080922094411.46aadd82@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <Pine.LNX.4.64.0809212139040.7264@axis700.grange>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	<48D2664D.7040204@freescale.com>
	<20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
	<e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
	<20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
	<48D3B880.3070607@freescale.com>
	<e9c3a7c20809201600s3862da7qaab4a917220778e9@mail.gmail.com>
	<20080921112605.1e00b92b@hskinnemo-gx745.norway.atmel.com>
	<Pine.LNX.4.64.0809212139040.7264@axis700.grange>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Sep 2008 07:44:00.0946 (UTC) FILETIME=[FA6DB920:01C91C86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Sun, 21 Sep 2008, Haavard Skinnemoen wrote:
> 
> > > 2/ What about platform specific concerns where dma_cap_mask_t is not
> > > descriptive enough e.g. only one memcpy channel can address a certain
> > > bus?  Currently a client implementation can have some intelligence to
> > > return DMA_DUP for channels that do not have the platform capability.
> > 
> > Currently, clients requesting the DMA_SLAVE capability can specify
> > which particular DMA device they need. Would it make sense to allow
> > other clients to do that as well?
> 
> This is how it is documented in dmaengine.h:
> 
>  * @slave: data for preparing slave transfer. Must be non-NULL iff the
>  *  DMA_SLAVE capability is requested.
> 
> But, looking at dma_client_chan_alloc() it seems, any client requesting a 
> channel can provide a slave and link it to a specific dma_dev, regardless 
> what capabilities the client is requesting, or am I missing something? If 
> so, then yes, please, let's allow all do this. Wouldn't it be better to 
> move the .dma_dev member to dma_client?

Yes, that's basically what I'm suggesting.

> > Also, struct dma_slave can be extended with
> > controller-/platform-specific fields. Maybe we need a similar mechanism
> > for passing platform-specific constraints when requesting "regular"
> > channels?
> 
> As far as I understand, this extension can only be done by "wrapping" 
> dma_slave with driver-specific data:

Correct.

>  * If dma_dev is non-NULL, the client can not be bound to other DMA
>  * masters than the one corresponding to this device. The DMA master
>  * driver may use this to determine if there is controller-specific
>  * data wrapped around this struct. Drivers of platform code that sets
>  * the dma_dev field must therefore make sure to use an appropriate
>  * controller-specific dma slave structure wrapping this struct.
> 
> i.e., there is no "void *priv" or similar. So, the same "wrapping" can be 
> used with dma_client, even more conveniently so, if we move .dma_dev into 
> it.

Except that usually, struct dma_client is already embedded into a
client-specific struct. So you can't really extend it with
controller-specific data without tying the client to one specific DMA
engine at compile time.

Since struct dma_slave is accessed through a pointer, the client driver
can get a controller-specific struct through device.platform_data or
something similar.

We could probably solve this by adding a "void *controller_data" field
to struct dma_client though.

Haavard
