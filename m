Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0BPIpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:45:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54765 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0BPIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:45:41 -0500
Date: Tue, 16 Feb 2010 08:44:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100216084442.GA3212@n2100.arm.linux.org.uk>
References: <20100208065519.GE1290@ucw.cz> <1265622676.4020.19.camel@pc1117.cambridge.arm.com> <20100208105209.GA31671@atrey.karlin.mff.cuni.cz> <1265628483.4020.63.camel@pc1117.cambridge.arm.com> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 01:27:53PM +0530, Shilimkar, Santosh wrote:
> Continuing on the USB issue w.r.t cache coherency, the usb host
> code is violating the buffer ownership rules of streaming APIs from
> dma and non-dma transfers point if view.
> 
> We have a below temporary patch to get around the issue and probably it
> needs to be fixed in the right way in the stack because some controllers
> may not have PIO option even for control transfers. (e.g. Synopsis EHCI
> controller)

        if (usb_endpoint_xfer_control(&urb->ep->desc)
            && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
                if (hcd->self.uses_dma) {		<=================
                        urb->setup_dma = dma_map_single(
                                        hcd->self.controller,
                                        urb->setup_packet,
                                        sizeof(struct usb_ctrlrequest),
                                        DMA_TO_DEVICE);

struct usb_hcd *usb_create_hcd (const struct hc_driver *driver,
                struct device *dev, const char *bus_name)
{
...
        hcd->self.uses_dma = (dev->dma_mask != NULL);

Is it easier to make sure that PIO devices don't have dev->dma_mask set?
