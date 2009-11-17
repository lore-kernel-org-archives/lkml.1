Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZKQPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZKQPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZKQPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:25:31 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:52682 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbZKQPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:25:30 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] NEXIO (or iNexio) support for usbtouchscreen
Date: Tue, 17 Nov 2009 16:25:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org>
In-Reply-To: <200911161515.00907.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911171625.34696.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 16. November 2009 15:14:59 schrieb Ondrej Zary:

Hi,

firstly can you please send patches with -up? It makes them more readable.
> ---

> @@ -92,7 +95,7 @@
>  	dma_addr_t data_dma;
>  	unsigned char *buffer;
>  	int buf_len;
> -	struct urb *irq;
> +	struct urb *irq, *ack;

Where is this urb handled in case of disconnection?

> +#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
> +	/* ignore the comm interface */
> +	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x02, 0x02, 0x00),
> +		.driver_info = DEVTYPE_IGNORE},
> +	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x02, 0x02, 0x00),
> +		.driver_info = DEVTYPE_IGNORE},
> +	/* normal device IDs */
> +	{USB_DEVICE(0x10f0, 0x2002), .driver_info = DEVTYPE_NEXIO},
> +	{USB_DEVICE(0x1870, 0x0001), .driver_info = DEVTYPE_NEXIO},

Why not go for the interfaces you want?

> +static unsigned char nexio_ack[2] = { 0xaa, 0x02 };
> +
> +static int nexio_init(struct usbtouch_usb *usbtouch)
> +{
> +	struct usb_device *dev = usbtouch->udev;
> +	int ret = -ENOMEM;
> +	int actual_len;
> +	unsigned char *buf;
> +	unsigned char init[4] = { 0x82, 0x04, 0x0a, 0x0f };
> +	char *firmware_ver;
> +
> +	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
> +	if (!buf)
> +		goto err_nobuf;
> +	/* two reads */
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	/* send init command */
> +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), init,
> +			   sizeof(init), &actual_len, NEXIO_TIMEOUT);

DMA on the kernel stack

	Regards
		Oliver


