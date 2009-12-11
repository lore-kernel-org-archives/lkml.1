Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZLKUta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZLKUta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZLKUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:49:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52217 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753732AbZLKUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:49:24 -0500
Date: Fri, 11 Dec 2009 15:49:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912112042.02228.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912111542010.2777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, Ondrej Zary wrote:

> On Thursday 10 December 2009, Alan Stern wrote:
> > On Thu, 10 Dec 2009, Ondrej Zary wrote:
> > > Narrowed down the code to this 170-line module which reproduces my
> > > "rmmod usbtouchscreen" problem. Loading this module causes EHCI to fail.
> > > Looks like it fails after calling usb_kill_urb(). Can a buggy device
> > > cause this?
> >
> > I don't think so.  But I am getting an idea of what the problem might
> > be.  Try applying the patch below and see if it makes any difference
> > (make sure that CONFIG_USB_DEBUG is enabled).
> 
> Thank you very much for the patch. It seems to finally solve this long
> thread!

Great!

> I'm running 2.6.32 now (with usbtouchscreen copied from -next) so one hunk
> had to be applied manually. With patch applied and CONFIG_USB_DEBUG enabled,
> usbtouchscreen stopped working - the urb failed to submit. Return value of
> usb_submit_urb() was not checked (and it wasn't my code this time :) Adding
> a check revealed that the urb fails to submit with -EPIPE because of
> endpoint vs. pipe mismatch.
> 
> Fixing that (see the patch below) solved the rmmod problem!

> --- linux-2.6.32/drivers/input/touchscreen/usbtouchscreen.5	2009-12-11 12:50:35.000000000 +0100
> +++ linux-2.6.32/drivers/input/touchscreen/usbtouchscreen.c	2009-12-11 20:15:51.000000000 +0100
> @@ -1375,10 +1375,16 @@
>  		input_set_abs_params(input_dev, ABS_PRESSURE, type->min_press,
>  		                     type->max_press, 0, 0);
>  
> -	usb_fill_int_urb(usbtouch->irq, udev,
> +	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
> +		usb_fill_int_urb(usbtouch->irq, udev,
>  			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
>  			 usbtouch->data, type->rept_size,
>  			 usbtouch_irq, usbtouch, endpoint->bInterval);
> +	else
> +		usb_fill_bulk_urb(usbtouch->irq, udev,
> +			 usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
> +			 usbtouch->data, type->rept_size,
> +			 usbtouch_irq, usbtouch);
>  
>  	usbtouch->irq->dev = udev;
>  	usbtouch->irq->transfer_dma = usbtouch->data_dma;

Okay.  I'll submit my patch.  Since it's not a bug fix, it won't go 
into the current release or the stable trees, but it should appear in 
2.6.33.  You should submit your fix to the appropriate maintainer.

This was a tricky problem; I'm glad we finally found the underlying 
cause.

Alan Stern

