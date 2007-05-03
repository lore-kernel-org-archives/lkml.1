Return-Path: <linux-kernel-owner+w=401wt.eu-S1767331AbXECCzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767331AbXECCzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767341AbXECCzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:55:47 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:18227 "EHLO
	asav19.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767331AbXECCzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:55:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAM/rOEZKhRO4W2dsb2JhbACBZI4lHQ0GEA
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
Date: Wed, 2 May 2007 22:55:43 -0400
User-Agent: KMail/1.9.3
Cc: Jan Kratochvil <honza@jikos.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022255.44746.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 11:05, Jan Kratochvil wrote:
>  	  
> +config XPAD_FF
> +	default n

Please don't default to anything.

>  
> +#ifdef CONFIG_XPAD_FF
> +/**
> + * xpad_irq_out
> + */

Comments are welcome when they say something...

> +static void xpad_irq_out(struct urb *urb)
> +{
> +	int retval;
> +
> +	switch (urb->status) {
> +		case 0:
> +		/* success */
> +		break;
> +		case -ECONNRESET:
> +		case -ENOENT:
> +		case -ESHUTDOWN:
> +			/* this urb is terminated, clean up */
> +			dbg("%s - urb shutting down with status: %d",  __FUNCTION__, urb->status);
> +			return;
> +		default:
> +			dbg("%s - nonzero urb status received: %d",  __FUNCTION__, urb->status);
> +			goto exit;
> +	}
> +
> +exit:
> +	retval = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (retval)
> +		err("%s - usb_submit_urb failed with result %d",
> +		   __FUNCTION__, retval);
> +} 
> +
> +int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
> +{
> +	struct usb_xpad *xpad = dev->private;
> +	if (effect->type == FF_RUMBLE) {
> +		__u16 strong = effect->u.rumble.strong_magnitude;
> +		__u16 weak = effect->u.rumble.weak_magnitude;
> +		xpad->odata[0] = 0x00; 
> +		xpad->odata[1] = 0x08; 
> +		xpad->odata[2] = 0x00; 
> +		xpad->odata[3] = strong / 256;
> +		xpad->odata[4] = weak / 256; 
> +		xpad->odata[5] = 0x00;
> +		xpad->odata[6] = 0x00;
> +		xpad->odata[7] = 0x00;
> +		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
> +	}
> +
> +	return 0;
> +}
> +
> +static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad)
> +{
> +	if (xpad->flags & XPAD_FLAGS_XBOX360) {
> +		struct usb_endpoint_descriptor *ep_irq_out;
> +		int rv;
> +
> +		xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN, 
> +					       GFP_ATOMIC, &xpad->odata_dma );
> +		if (!xpad->idata)
> +			goto fail1;
> +
> +		xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!xpad->irq_out)
> +			goto fail2;
> +
> +
> +		ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
> +		usb_fill_int_urb(xpad->irq_out, xpad->udev,
> +				 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
> +				 xpad->odata, XPAD_PKT_LEN,
> +				 xpad_irq_out, xpad, ep_irq_out->bInterval);
> +		xpad->irq_out->transfer_dma = xpad->odata_dma;
> +		xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +		set_bit( FF_RUMBLE, xpad->dev->ffbit );
> +		rv = input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
> +

Error handling seems to be missing.

> +		return 0;
> +
> +fail2:		usb_buffer_free(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
> +fail1:		
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static void xpad_deinit_ff(struct usb_interface *intf, struct usb_xpad *xpad)
> +{
> +	if (xpad->flags & XPAD_FLAGS_XBOX360) {
> +		usb_kill_urb(xpad->irq_out);

You may want to do that in xpad_close().

> +		usb_free_urb(xpad->irq_out);
> +		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,
> +				xpad->odata, xpad->odata_dma);
> +	}
> +}
> +#endif
> +
>  static int xpad_open (struct input_dev *dev)
>  {
>  	struct usb_xpad *xpad = dev->private;
> @@ -432,6 +535,11 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
>  
>  	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
>  
> +#ifdef CONFIG_XPAD_FF
> +	if (xpad->flags & XPAD_FLAGS_XBOX360)
> +		input_dev->evbit[0] |= BIT(EV_FF);
> +#endif

Can this be moved into xpad_init_ff?

> +
>  	/* set up buttons */
>  	for (i = 0; xpad_btn[i] >= 0; i++)
>  		set_bit(xpad_btn[i], input_dev->keybit);
> @@ -449,6 +557,11 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
>  		for (i = 0; xpad_abs_pad[i] >= 0; i++)
>  		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);
>  
> +#ifdef CONFIG_XPAD_FF
> +	if (xpad_init_ff(intf, xpad))
> +		goto fail2;
> +#endif
> +

Normally we define dummy fucntions when corresponding config option is disabled
to avoid littering main code with #ifdefs.

>  	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
>  	usb_fill_int_urb(xpad->irq_in, udev,
>  			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
> @@ -476,6 +589,9 @@ static void xpad_disconnect(struct usb_interface *intf)
>  	usb_set_intfdata(intf, NULL);
>  	if (xpad) {
>  		usb_kill_urb(xpad->irq_in);

This is extra - we already did that in xpad_close.

> +#ifdef CONFIG_XPAD_FF
> +		xpad_deinit_ff(intf, xpad);
> +#endif
>  		input_unregister_device(xpad->dev);
>  		usb_free_urb(xpad->irq_in);
>  		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,

-- 
Dmitry
