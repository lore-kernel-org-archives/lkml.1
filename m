Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab0BQI4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 03:56:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab0BQI4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 03:56:01 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Oliver Neukum <oliver@neukum.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       "Gadiyar, Anand" <gadiyar@ti.com>
Date: Wed, 17 Feb 2010 14:25:08 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: AcqvE4MzeiwSSWdcQPSZLgylUiXKwwAmu2EQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
 <201002161446.59920.oliver@neukum.org>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8038@dbde02.ent.ti.com>
 <201002161522.38467.oliver@neukum.org>
In-Reply-To: <201002161522.38467.oliver@neukum.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Oliver Neukum [mailto:oliver@neukum.org]
> Sent: Tuesday, February 16, 2010 7:53 PM
> To: Shilimkar, Santosh
> Cc: Russell King - ARM Linux; Catalin Marinas; Pavel Machek; Greg KH; Matthew Dharm; Sergei Shtylyov;
> Ming Lei; Sebastian Siewior; linux-usb@vger.kernel.org; linux-kernel; linux-arm-kernel; Mankad,
> Maulik Ojas
> Subject: Re: USB mass storage and ARM cache coherency
> 
> Am Dienstag, 16. Februar 2010 15:12:45 schrieb Shilimkar, Santosh:
> > > > > I am afraid for these controllers the controller driver must be responsible
> > > > > for all DMA and cache issues. Indicating the exact requirements to the
> > > > > upper layer would be a battle already lost.
> > > > > so the safe choice is not to set has_dma and the generic layer will leave
> > > > > the issue to the lower level.
> > > > This means don't use dma at all which will almost kill the performance.
> > >
> > > Why would you be unable to map a buffer in the hcd driver when you know
> > > that you'll use DMA?
> > Probably it can be. The USB stack has the dma maintenance code at common
> > place for all controllers and hence we were just trying to see if there is
> > way to handle that way.
> 
> This is true. If you can find a clean way to describe your requirements
> to the generic layer, that would be better. The problem is that we must
> not end up with a dozen flags.
> 
> Your original patch however kills ehci, ohci and uhci on some architectures.

How about below approach? Controller driver can set 
"uses_pio_for_control" if it can't do dma for control transfer.

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 80995ef..e3eae02 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1276,7 +1276,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 
 	if (usb_endpoint_xfer_control(&urb->ep->desc)
 	    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
-		if (hcd->self.uses_dma) {
+		if (hcd->self.uses_dma && !hcd->self.uses_pio_for_control) {
 			urb->setup_dma = dma_map_single(
 					hcd->self.controller,
 					urb->setup_packet,
@@ -1335,7 +1335,7 @@ static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 
 	if (usb_endpoint_xfer_control(&urb->ep->desc)
 	    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
-		if (hcd->self.uses_dma)
+		if (hcd->self.uses_dma && !hcd->self.uses_pio_for_control)
 			dma_unmap_single(hcd->self.controller, urb->setup_dma,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index d7ace1b..ba5b0a2 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -329,6 +329,9 @@ struct usb_bus {
 	int busnum;			/* Bus number (in order of reg) */
 	const char *bus_name;		/* stable id (PCI slot_name etc) */
 	u8 uses_dma;			/* Does the host controller use DMA? */
+	u8 uses_pio_for_control;	/* Does the host controller use PIO
+					 * for control tansfers? 
+					 */
 	u8 otg_port;			/* 0, or number of OTG/HNP port */
 	unsigned is_b_host:1;		/* true during some HNP roleswitches */
 	unsigned b_hnp_enable:1;	/* OTG: did A-Host enable HNP? */

Regards,
Santosh
