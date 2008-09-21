Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYIUTu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYIUTu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYIUTuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:50:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:34618 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752162AbYIUTuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:50:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19hCFBmbAJhFGKPtmUo7ZYVFYfW0TekQSS9e0tMGP
	NPupL8Bf7KPTZt
Date: Sun, 21 Sep 2008 21:50:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: Dan Williams <dan.j.williams@intel.com>, Timur Tabi <timur@freescale.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
In-Reply-To: <20080921112605.1e00b92b@hskinnemo-gx745.norway.atmel.com>
Message-ID: <Pine.LNX.4.64.0809212139040.7264@axis700.grange>
References: <48D02589.8070601@freescale.com>
 <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
 <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
 <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
 <48D2664D.7040204@freescale.com> <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
 <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
 <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
 <48D3B880.3070607@freescale.com> <e9c3a7c20809201600s3862da7qaab4a917220778e9@mail.gmail.com>
 <20080921112605.1e00b92b@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008, Haavard Skinnemoen wrote:

> > 2/ What about platform specific concerns where dma_cap_mask_t is not
> > descriptive enough e.g. only one memcpy channel can address a certain
> > bus?  Currently a client implementation can have some intelligence to
> > return DMA_DUP for channels that do not have the platform capability.
> 
> Currently, clients requesting the DMA_SLAVE capability can specify
> which particular DMA device they need. Would it make sense to allow
> other clients to do that as well?

This is how it is documented in dmaengine.h:

 * @slave: data for preparing slave transfer. Must be non-NULL iff the
 *  DMA_SLAVE capability is requested.

But, looking at dma_client_chan_alloc() it seems, any client requesting a 
channel can provide a slave and link it to a specific dma_dev, regardless 
what capabilities the client is requesting, or am I missing something? If 
so, then yes, please, let's allow all do this. Wouldn't it be better to 
move the .dma_dev member to dma_client?

> Also, struct dma_slave can be extended with
> controller-/platform-specific fields. Maybe we need a similar mechanism
> for passing platform-specific constraints when requesting "regular"
> channels?

As far as I understand, this extension can only be done by "wrapping" 
dma_slave with driver-specific data:

 * If dma_dev is non-NULL, the client can not be bound to other DMA
 * masters than the one corresponding to this device. The DMA master
 * driver may use this to determine if there is controller-specific
 * data wrapped around this struct. Drivers of platform code that sets
 * the dma_dev field must therefore make sure to use an appropriate
 * controller-specific dma slave structure wrapping this struct.

i.e., there is no "void *priv" or similar. So, the same "wrapping" can be 
used with dma_client, even more conveniently so, if we move .dma_dev into 
it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
