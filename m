Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYIUJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYIUJ0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 05:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYIUJ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 05:26:13 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36707 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbYIUJ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 05:26:12 -0400
Date: Sun, 21 Sep 2008 11:26:05 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Timur Tabi" <timur@freescale.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080921112605.1e00b92b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <e9c3a7c20809201600s3862da7qaab4a917220778e9@mail.gmail.com>
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
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Sep 2008 09:25:55.0459 (UTC) FILETIME=[0C8C9D30:01C91BCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Williams" <dan.j.williams@intel.com> wrote:
> On Fri, Sep 19, 2008 at 7:34 AM, Timur Tabi <timur@freescale.com> wrote:
> > Haavard Skinnemoen wrote:
> >
> >> Yes, or maybe provide an interface for simply requesting a channel
> >> without having to register any callbacks.
> >
> > I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
> > but the drivers need to control the DMA hardware directly, so I can't use
> > dmaengine.  I would like to be able to just reserve the channels and program
> > them as I see fit.
> >
> 
> I think its a good idea especially since it would be best not to
> needlessly proliferate client implementations with competing channel
> allocation schemes.  However it would need to be more descriptive
> than:
> 
> struct dma_chan *dma_request_channel(dma_cap_mask_t request_mask);

Yes. It would definitely require a struct dma_slave too, unless we
create a separate function for that.

> Why:
> 1/  What if the requester initializes before a dmaengine device has
> been registered?  What if a device is never registered?

It should just return NULL if it cannot satisfy the request. That might
cause problems since the requesting module normally won't depend on the
dmaengine driver, but I think it's better than requiring drivers to
deal with channels that may come and go at any time. Those drivers will
inevitably be buggy.

> 2/ What about platform specific concerns where dma_cap_mask_t is not
> descriptive enough e.g. only one memcpy channel can address a certain
> bus?  Currently a client implementation can have some intelligence to
> return DMA_DUP for channels that do not have the platform capability.

Currently, clients requesting the DMA_SLAVE capability can specify
which particular DMA device they need. Would it make sense to allow
other clients to do that as well?

Also, struct dma_slave can be extended with
controller-/platform-specific fields. Maybe we need a similar mechanism
for passing platform-specific constraints when requesting "regular"
channels?

> At the very least clients should be allowed to set an 'exclusive' bit
> to prevent the channel from leaking elsewhere.

Agreed. Perhaps we should allow the DMA engine driver to set that flag
too, in case certain parameters make channels difficult to share on
certain controllers.

Haavard
