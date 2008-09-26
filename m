Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYIZBVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYIZBVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYIZBVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:21:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42558 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYIZBVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:21:18 -0400
Date: Thu, 25 Sep 2008 18:20:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       phil@hannent.co.uk, mwilder@cs.nmsu.edu
Subject: Re: [PATCH] Input: add mmio xi driver
Message-Id: <20080925182055.f12f5d0b.randy.dunlap@oracle.com>
In-Reply-To: <20080925232237.GA22938@suse.de>
References: <20080925232237.GA22938@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 16:22:37 -0700 Greg KH wrote:

> 
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This patch adds the Mimio Xi interactive whiteboard driver to the tree.
> 
> It was originally written by mwilder@cs.nmsu.edu, but cleaned up and
> forward ported by me to the latest kernel version.
> 
> 
> Cc: Phil Hannent <phil@hannent.co.uk>
> Cc: <mwilder@cs.nmsu.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/input/misc/Kconfig  |   11 
>  drivers/input/misc/Makefile |    1 
>  drivers/input/misc/mimio.c  |  913 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 925 insertions(+)
> 
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -164,6 +164,17 @@ config INPUT_POWERMATE
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called powermate.
>  
> +config INPUT_MIMIO
> +	tristate "Mimio Xi interactive whiteboard support"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB

Prefer not to select entire subsystems, but to depend on them.
However, lots of drivers in drivers/input/ select USB...  :(


> +	help
> +	  Say Y here if you want to use a Mimio Xi interactive
> +	  whiteboard device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called mimio.
> +
>  config INPUT_YEALINK
>  	tristate "Yealink usb-p1k voip phone"
>  	depends on EXPERIMENTAL

> --- /dev/null
> +++ b/drivers/input/misc/mimio.c
> @@ -0,0 +1,913 @@

> +static void mimio_irq_out(struct urb *urb)
> +{
> +	unsigned long flags;
> +	struct mimio *mimio;
> +
> +	mimio = urb->context;
> +
> +	if (urb->status)
> +		dev_dbg(&mimio->idev->dev, "urb-status: %d.\n", urb->status);
> +
> +	spin_lock_irqsave(&mimio->txlock, flags);
> +	mimio->txflags |= MIMIO_TXDONE;
> +	spin_unlock_irqrestore(&mimio->txlock, flags);
> +	wmb();

We want comments/explanation on all barriers or just "barrier();" ??

> +	wake_up(&mimio->waitq);
> +}

> +static int mimio_probe(struct usb_interface *ifc,
> +		       const struct usb_device_id *id)
> +{
> +	char path[64];
> +	int pipe, maxp;
> +	struct mimio *mimio;
> +	struct usb_device *udev;
> +	struct usb_host_interface *hostifc;
> +	struct input_dev *input_dev;
> +	int res = 0;
> +	int i;
> +
> +	udev = interface_to_usbdev(ifc);
> +
> +	mimio = kzalloc(sizeof(struct mimio), GFP_KERNEL);
> +	if (!mimio)
> +		return -ENOMEM;
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev) {
> +		mimio_dealloc(mimio);
> +		return -ENOMEM;
> +	}
> +
> +	mimio->uifc = ifc;
> +	mimio->udev = udev;
> +	mimio->pktbuf.p = mimio->pktbuf.buf;
> +	mimio->pktbuf.q = mimio->pktbuf.buf;
> +	/* init_input_dev(mimio->idev); */
> +	mimio->idev = input_dev;
> +	init_waitqueue_head(&mimio->waitq);
> +	spin_lock_init(&mimio->txlock);
> +	hostifc = ifc->cur_altsetting;
> +
> +	if (hostifc->desc.bNumEndpoints != 2) {
> +		dev_err(&udev->dev, "Unexpected endpoint count: %d.\n",
> +			hostifc->desc.bNumEndpoints);
> +		mimio_dealloc(mimio);
> +		return -ENODEV;
> +	}
> +
> +	mimio->in.desc = &(hostifc->endpoint[0].desc);
> +	mimio->out.desc = &(hostifc->endpoint[1].desc);
> +
> +	mimio->in.buf = usb_buffer_alloc(udev, MIMIO_MAXPAYLOAD, GFP_KERNEL,
> +					 &mimio->in.dma);
> +	mimio->out.buf = usb_buffer_alloc(udev, MIMIO_MAXPAYLOAD, GFP_KERNEL,
> +					  &mimio->out.dma);
> +
> +	if (mimio->in.buf == NULL || mimio->out.buf == NULL) {
> +		dev_err(&udev->dev, "usb_buffer_alloc failure.\n");
> +		mimio_dealloc(mimio);
> +		return -ENOMEM;
> +	}
> +
> +	mimio->in.urb = usb_alloc_urb(0, GFP_KERNEL);
> +	mimio->out.urb = usb_alloc_urb(0, GFP_KERNEL);
> +
> +	if (mimio->in.urb == NULL || mimio->out.urb == NULL) {
> +		dev_err(&udev->dev, "usb_alloc_urb failure.\n");
> +		mimio_dealloc(mimio);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Build the input urb.
> +	 */
> +	pipe = usb_rcvintpipe(udev, mimio->in.desc->bEndpointAddress);
> +	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
> +	if (maxp > MIMIO_MAXPAYLOAD)
> +		maxp = MIMIO_MAXPAYLOAD;
> +	usb_fill_int_urb(mimio->in.urb, udev, pipe, mimio->in.buf, maxp,
> +			 mimio_irq_in, mimio, mimio->in.desc->bInterval);
> +	mimio->in.urb->transfer_dma = mimio->in.dma;
> +	mimio->in.urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	/*
> +	 * Build the output urb.
> +	 */
> +	pipe = usb_sndintpipe(udev, mimio->out.desc->bEndpointAddress);
> +	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
> +	if (maxp > MIMIO_MAXPAYLOAD)
> +		maxp = MIMIO_MAXPAYLOAD;
> +	usb_fill_int_urb(mimio->out.urb, udev, pipe, mimio->out.buf, maxp,
> +			 mimio_irq_out, mimio, mimio->out.desc->bInterval);
> +	mimio->out.urb->transfer_dma = mimio->out.dma;
> +	mimio->out.urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	/*
> +	 * Build input device info
> +	 */
> +	usb_make_path(udev, path, 64);

s/64/sizeof(path)/

> +	snprintf(mimio->phys, MIMIO_MAXNAMELEN, "%s/input0", path);
> +	input_set_drvdata(input_dev, mimio);
> +	/* input_dev->dev = &ifc->dev; */
> +	input_dev->open = mimio_open;
> +	input_dev->close = mimio_close;
> +	input_dev->name = mimio_name;
> +	input_dev->phys = mimio->phys;
> +	input_dev->dev.parent = &ifc->dev;
> +
> +	input_dev->id.bustype = BUS_USB;
> +	input_dev->id.vendor = le16_to_cpu(udev->descriptor.idVendor);
> +	input_dev->id.product = le16_to_cpu(udev->descriptor.idProduct);
> +	input_dev->id.version = le16_to_cpu(udev->descriptor.bcdDevice);
> +
> +	input_dev->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS);
> +	for (i = BTN_TOOL_PEN; i <= LOCALBTN_TOOL_EXTRA2; ++i)
> +		set_bit(i, input_dev->keybit);
> +
> +	input_dev->keybit[BIT_WORD(BTN_MISC)] |= BIT_MASK(BTN_0) |
> +						 BIT_MASK(BTN_1) |
> +						 BIT_MASK(BTN_2) |
> +						 BIT_MASK(BTN_3) |
> +						 BIT_MASK(BTN_4) |
> +						 BIT_MASK(BTN_5);
> +	/*   input_dev->keybit[BTN_MOUSE] |= BIT(BTN_LEFT); */
> +	input_dev->absbit[0] |= BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
> +	input_set_abs_params(input_dev, ABS_X, 0, MIMIO_XRANGE_MAX, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, MIMIO_YRANGE_MAX, 0, 0);
> +	input_dev->absbit[BIT_WORD(ABS_MISC)] |= BIT_MASK(ABS_MISC);
> +
> +#if 0
> +	input_dev->absmin[ABS_X] = 0;
> +	input_dev->absmin[ABS_Y] = 0;
> +	input_dev->absmax[ABS_X] = 9600;
> +	input_dev->absmax[ABS_Y] = 4800;
> +	input_dev->absfuzz[ABS_X] = 0;
> +	input_dev->absfuzz[ABS_Y] = 0;
> +	input_dev->absflat[ABS_X] = 0;
> +	input_dev->absflat[ABS_Y] = 0;
> +#endif
> +
> +#if 0
> +	/* this will just reduce the precision */
> +	input_dev->absfuzz[ABS_X] = 8; /* experimental; may need to change */
> +	input_dev->absfuzz[ABS_Y] = 8; /* experimental; may need to change */
> +#endif
> +
> +	/*
> +	 * Register the input device.
> +	 */
> +	res = input_register_device(mimio->idev);
> +	if (res) {
> +		dev_err(&udev->dev, "input_register_device failure (%d)\n",
> +			res);
> +		mimio_dealloc(mimio);
> +		return -EIO;
> +	}
> +	dev_dbg(&mimio->idev->dev, "input: %s on %s (res = %d).\n",
> +		input_dev->name, input_dev->phys, res);
> +
> +	usb_set_intfdata(ifc, mimio);
> +	mimio->present = 1;
> +
> +	/*
> +	 * Submit the input urb to the usb subsystem.
> +	 */
> +	mimio->in.urb->dev = mimio->udev;
> +	res = usb_submit_urb(mimio->in.urb, GFP_KERNEL);
> +	if (res) {
> +		dev_err(&mimio->idev->dev, "usb_submit_urb failure (%d)\n",
> +			res);
> +		mimio_dealloc(mimio);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * Attempt to greet the mimio after giving
> +	 * it some post-init settling time.
> +	 *
> +	 * note: sometimes this sleep interval isn't
> +	 * long enough to permit the device to re-init
> +	 * after a hot-swap; maybe need to bump it up.
> +	 *
> +	 * As it is, this probably breaks module unloading support!
> +	 */
> +	msleep(1024);
> +
> +	res = mimio_greet(mimio);
> +	if (res == 0) {
> +		dev_dbg(&mimio->idev->dev, "Mimio greeted OK.\n");
> +		mimio->greeted = 1;
> +		mimio->rxhandler = mimio_rx_handler;
> +	} else {
> +		dev_dbg(&mimio->idev->dev, "Mimio greet Failure (%d)\n", res);
> +	}
> +
> +	return 0;
> +}

---
~Randy
