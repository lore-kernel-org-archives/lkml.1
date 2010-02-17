Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0BQUdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:33:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48871 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab0BQUdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:33:22 -0500
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Oliver Neukum <oliver@neukum.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Date: Thu, 18 Feb 2010 02:00:24 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: Acqv8vy8I3eMA2qDS32WjD6Fjj9dKAAHQxBB
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03216236D6@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com>,<Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org>
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

Alan Stern wrote:
> On Wed, 17 Feb 2010, Shilimkar, Santosh wrote:
> 
> > How about below approach? Controller driver can set
> > "uses_pio_for_control" if it can't do dma for control transfer.
> >
> > diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> > index 80995ef..e3eae02 100644
> > --- a/drivers/usb/core/hcd.c
> > +++ b/drivers/usb/core/hcd.c
> > @@ -1276,7 +1276,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
> >
> >       if (usb_endpoint_xfer_control(&urb->ep->desc)
> >           && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
> > -             if (hcd->self.uses_dma) {
> > +             if (hcd->self.uses_dma && !hcd->self.uses_pio_for_control) {
> >                       urb->setup_dma = dma_map_single(
> >                                       hcd->self.controller,
> >                                       urb->setup_packet,
> > @@ -1335,7 +1335,7 @@ static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
> >
> >       if (usb_endpoint_xfer_control(&urb->ep->desc)
> >           && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
> > -             if (hcd->self.uses_dma)
> > +             if (hcd->self.uses_dma && !hcd->self.uses_pio_for_control)
> >                       dma_unmap_single(hcd->self.controller, urb->setup_dma,
> >                                       sizeof(struct usb_ctrlrequest),
> >                                       DMA_TO_DEVICE);
> > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > index d7ace1b..ba5b0a2 100644
> > --- a/include/linux/usb.h
> > +++ b/include/linux/usb.h
> > @@ -329,6 +329,9 @@ struct usb_bus {
> >       int busnum;                     /* Bus number (in order of reg) */
> >       const char *bus_name;           /* stable id (PCI slot_name etc) */
> >       u8 uses_dma;                    /* Does the host controller use DMA? */
> > +     u8 uses_pio_for_control;        /* Does the host controller use PIO
> > +                                      * for control tansfers?
> > +                                      */
> >       u8 otg_port;                    /* 0, or number of OTG/HNP port */
> >       unsigned is_b_host:1;           /* true during some HNP roleswitches */
> >       unsigned b_hnp_enable:1;        /* OTG: did A-Host enable HNP? */
> 
> Why do you skip mapping the setup packet but not the data packet?
> 

I think that's oversight. For this controller, we need to skip mapping
all buffers used to do transfers on EP0, which is all control transfers.

Will fix in the next version of the patch.

- Anand
