Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab0BQJLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:11:00 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46434 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934191Ab0BQJK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:10:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Wed, 17 Feb 2010 10:10:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       "Gadiyar, Anand" <gadiyar@ti.com>
References: <20100208065519.GE1290@ucw.cz> <201002161522.38467.oliver@neukum.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002171010.57464.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Februar 2010 09:55:08 schrieb Shilimkar, Santosh:
> > Your original patch however kills ehci, ohci and uhci on some architectures.
> 
> How about below approach? Controller driver can set 
> "uses_pio_for_control" if it can't do dma for control transfer.
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 80995ef..e3eae02 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1276,7 +1276,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
>  
>         if (usb_endpoint_xfer_control(&urb->ep->desc)
>             && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
> -               if (hcd->self.uses_dma) {
> +               if (hcd->self.uses_dma && !hcd->self.uses_pio_for_control) {

It is not elegant to describe exceptions. It would be better, if you split up
the flag into two flags, called uses_dma_for_ordinary_transfers and
uses_dma_for control_transfers. Doing so also makes sure you look at
all hcd drivers ;-)

And the tests become straightforward. And please add a detailed comment
to explain why this differentiation is needed on ARM.

	Regards
		Oliver
