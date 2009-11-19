Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZKSQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZKSQ4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZKSQz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:55:59 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:57399 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZKSQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:55:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v3] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Thu, 19 Nov 2009 17:56:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911181625.46983.oliver@neukum.org> <200911191340.23769.linux@rainbow-software.org>
In-Reply-To: <200911191340.23769.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191756.04615.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +struct nexio_priv {
> +	struct urb *ack;
> +	char ack_buf[2];
> +};

No. Every buffer needs to have an exclusive cache line for DMA
to work on the incoherent archotectures. Therefore you must allocate
each buffer with its own kmalloc.

> +struct nexio_touch_packet {
> +	u8	flags;		/* 0xe1 = touch, 0xe1 = release */
> +	__be16	data_len;	/* total bytes of touch data */
> +	__be16	x_len;		/* bytes for X axis */
> +	__be16	y_len;		/* bytes for Y axis */
> +	u8	data[];
> +} __attribute__ ((packed));
> +
> +static unsigned char nexio_ack_pkt[2] = { 0xaa, 0x02 };
> +static unsigned char nexio_init_pkt[4] = { 0x82, 0x04, 0x0a, 0x0f };
> +
> +static int nexio_init(struct usbtouch_usb *usbtouch)
> +{
> +	struct usb_device *dev = usbtouch->udev;
> +	struct nexio_priv *priv;
> +	int ret = -ENOMEM;
> +	int actual_len, i;
> +	unsigned char *buf;
> +	char *firmware_ver = NULL, *device_name = NULL;
> +
> +	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
> +	if (!buf)
> +		goto err_out;
> +	/* two empty reads */
> +	for (i = 0; i < 2; i++) {
> +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
> +				   buf, NEXIO_BUFSIZE, &actual_len,
> +				   NEXIO_TIMEOUT);
> +		if (ret < 0)
> +			goto err_out;
> +	}
> +	/* send init command */
> +	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
> +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP),
> +			   buf, sizeof(nexio_init_pkt), &actual_len,
> +			   NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	/* read replies */
> +	for (i = 0; i < 3; i++) {
> +		memset(buf, 0, NEXIO_BUFSIZE);
> +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
> +				   buf, NEXIO_BUFSIZE, &actual_len,
> +				   NEXIO_TIMEOUT);
> +		if (ret < 0 || actual_len < 1 || buf[1] != actual_len)
> +			continue;
> +		switch (buf[0]) {
> +			case 0x83:	/* firmware version */
> +				firmware_ver = kstrdup(&buf[2], GFP_KERNEL);
> +				break;
> +			case 0x84:	/* device name */
> +				device_name = kstrdup(&buf[2], GFP_KERNEL);
> +				break;
> +		}
> +	}
> +	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
> +	       device_name, firmware_ver);

How do you know device_name and firmware_ver are not NULL?

> +	kfree(firmware_ver);
> +	kfree(device_name);
> +
> +	/* prepare ACK URB */
> +	usbtouch->priv = kmalloc(sizeof(struct nexio_priv), GFP_KERNEL);
> +	if (!usbtouch->priv) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +	priv = usbtouch->priv;
> +	memcpy(priv->ack_buf, nexio_ack_pkt, sizeof(nexio_ack_pkt));
> +	priv->ack = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!priv->ack) {

When would usbtouch->priv be freed in the error case?

> +		dbg("%s - usb_alloc_urb failed: usbtouch->ack", __func__);
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +	usb_fill_bulk_urb(priv->ack, usbtouch->udev,
> +			  usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
> +			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
> +			  usbtouch);
> +	/* submit first IRQ URB */
> +	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);

If this fails, when is priv->ack freed?

> +err_out:
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static void nexio_exit(struct usbtouch_usb *usbtouch)
> +{
> +	struct nexio_priv *priv = usbtouch->priv;
> +
> +	usb_kill_urb(priv->ack);
> +	usb_free_urb(priv->ack);
> +	kfree(priv);
> +}
> +
> 
> 
> @@ -862,7 +1073,8 @@ static void usbtouch_close(struct input_
>  {
>  	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
> 
> -	usb_kill_urb(usbtouch->irq);
> +	if (!usbtouch->type->no_urb_in_open)
> +		usb_kill_urb(usbtouch->irq);
>  }
> 
> 
> @@ -960,10 +1172,12 @@ static int usbtouch_probe(struct usb_int
>  		                     type->max_press, 0, 0);
> 
>  	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
> -			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
> +			 usb_rcvintpipe(usbtouch->udev,
> +					type->endpoint ? type->endpoint
> +							: endpoint->bEndpointAddress),
>  			 usbtouch->data, type->rept_size,
> -			 usbtouch_irq, usbtouch, endpoint->bInterval);
> -
> +			 usbtouch_irq, usbtouch,
> +			 type->interval ? type->interval : endpoint->bInterval);
>  	usbtouch->irq->dev = usbtouch->udev;
>  	usbtouch->irq->transfer_dma = usbtouch->data_dma;
>  	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> @@ -1006,6 +1220,8 @@ static void usbtouch_disconnect(struct u
> 
>  	dbg("%s - usbtouch is initialized, cleaning up", __func__);
>  	usb_set_intfdata(intf, NULL);
> +	if (usbtouch->type->exit)
> +		usbtouch->type->exit(usbtouch);
>  	usb_kill_urb(usbtouch->irq);

You've reversed the order. Order is important. If priv->irq
can cause priv->ack to be submitted, it must be killed first.
If priv->ack may submit priv->irq the reverse order is needed.
I don't know which is correct, but only that order may be important.

>  	input_unregister_device(usbtouch->input);

What tells you that open() isn't called at this point reversing
usb_kill_urb() you've already done?

>  	usb_free_urb(usbtouch->irq);
> 

	Regards
		Oliver
