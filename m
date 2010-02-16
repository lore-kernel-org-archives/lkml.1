Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0BPIw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:52:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0BPIw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:52:26 -0500
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Date: Tue, 16 Feb 2010 14:21:48 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: Acqu5HVbXgqk2Cw4TXif9yrV+0s/xwAACUeA
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03215B07FF@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
 <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
 <20100208105209.GA31671@atrey.karlin.mff.cuni.cz>
 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
 <20100216084442.GA3212@n2100.arm.linux.org.uk>
In-Reply-To: <20100216084442.GA3212@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Feb 16, 2010 at 01:27:53PM +0530, Shilimkar, Santosh wrote:
> > Continuing on the USB issue w.r.t cache coherency, the usb host
> > code is violating the buffer ownership rules of streaming APIs from
> > dma and non-dma transfers point if view.
> > 
> > We have a below temporary patch to get around the issue and probably it
> > needs to be fixed in the right way in the stack because some controllers
> > may not have PIO option even for control transfers. (e.g. Synopsis EHCI
> > controller)
> 
>         if (usb_endpoint_xfer_control(&urb->ep->desc)
>             && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
>                 if (hcd->self.uses_dma) {		<=================
>                         urb->setup_dma = dma_map_single(
>                                         hcd->self.controller,
>                                         urb->setup_packet,
>                                         sizeof(struct usb_ctrlrequest),
>                                         DMA_TO_DEVICE);
> 
> struct usb_hcd *usb_create_hcd (const struct hc_driver *driver,
>                 struct device *dev, const char *bus_name)
> {
> ...
>         hcd->self.uses_dma = (dev->dma_mask != NULL);
> 
> Is it easier to make sure that PIO devices don't have dev->dma_mask set?

Not really. For instance, in the case of the DMA engine in the MUSB
controller in OMAP3, we can only use DMA with endpoints other than
EP0, and EP0 is what is used for control transfers.

It's not PIO for all the endpoints or DMA for all of them.

- Anand
