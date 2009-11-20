Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZKTJVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZKTJVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZKTJVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:21:47 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55719 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752426AbZKTJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:21:44 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v4] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Fri, 20 Nov 2009 10:21:43 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911191340.23769.linux@rainbow-software.org> <200911191756.04615.oliver@neukum.org>
In-Reply-To: <200911191756.04615.oliver@neukum.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 7247
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911201021.45410.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009, Oliver Neukum wrote:
> > +struct nexio_priv {
> > +	struct urb *ack;
> > +	char ack_buf[2];
> > +};
>
> No. Every buffer needs to have an exclusive cache line for DMA
> to work on the incoherent archotectures. Therefore you must allocate
> each buffer with its own kmalloc.

OK, thanks for your patience.

> > +struct nexio_touch_packet {
> > +	u8	flags;		/* 0xe1 = touch, 0xe1 = release */
> > +	__be16	data_len;	/* total bytes of touch data */
> > +	__be16	x_len;		/* bytes for X axis */
> > +	__be16	y_len;		/* bytes for Y axis */
> > +	u8	data[];
> > +} __attribute__ ((packed));
> > +
> > +static unsigned char nexio_ack_pkt[2] = { 0xaa, 0x02 };
> > +static unsigned char nexio_init_pkt[4] = { 0x82, 0x04, 0x0a, 0x0f };
> > +
> > +static int nexio_init(struct usbtouch_usb *usbtouch)
> > +{
> > +	struct usb_device *dev = usbtouch->udev;
> > +	struct nexio_priv *priv;
> > +	int ret = -ENOMEM;
> > +	int actual_len, i;
> > +	unsigned char *buf;
> > +	char *firmware_ver = NULL, *device_name = NULL;
> > +
> > +	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
> > +	if (!buf)
> > +		goto err_out;
> > +	/* two empty reads */
> > +	for (i = 0; i < 2; i++) {
> > +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
> > +				   buf, NEXIO_BUFSIZE, &actual_len,
> > +				   NEXIO_TIMEOUT);
> > +		if (ret < 0)
> > +			goto err_out;
> > +	}
> > +	/* send init command */
> > +	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
> > +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP),
> > +			   buf, sizeof(nexio_init_pkt), &actual_len,
> > +			   NEXIO_TIMEOUT);
> > +	if (ret < 0)
> > +		goto err_out;
> > +	/* read replies */
> > +	for (i = 0; i < 3; i++) {
> > +		memset(buf, 0, NEXIO_BUFSIZE);
> > +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
> > +				   buf, NEXIO_BUFSIZE, &actual_len,
> > +				   NEXIO_TIMEOUT);
> > +		if (ret < 0 || actual_len < 1 || buf[1] != actual_len)
> > +			continue;
> > +		switch (buf[0]) {
> > +			case 0x83:	/* firmware version */
> > +				firmware_ver = kstrdup(&buf[2], GFP_KERNEL);
> > +				break;
> > +			case 0x84:	/* device name */
> > +				device_name = kstrdup(&buf[2], GFP_KERNEL);
> > +				break;
> > +		}
> > +	}
> > +	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
> > +	       device_name, firmware_ver);
>
> How do you know device_name and firmware_ver are not NULL?

printk works fine with NULL, it prints <NULL>. Is it necessary to add more 
code only to make the output nice?

>
> > +	kfree(firmware_ver);
> > +	kfree(device_name);
> > +
> > +	/* prepare ACK URB */
> > +	usbtouch->priv = kmalloc(sizeof(struct nexio_priv), GFP_KERNEL);
> > +	if (!usbtouch->priv) {
> > +		ret = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	priv = usbtouch->priv;
> > +	memcpy(priv->ack_buf, nexio_ack_pkt, sizeof(nexio_ack_pkt));
> > +	priv->ack = usb_alloc_urb(0, GFP_KERNEL);
> > +	if (!priv->ack) {
>
> When would usbtouch->priv be freed in the error case?

See the new patch below.

> > +		dbg("%s - usb_alloc_urb failed: usbtouch->ack", __func__);
> > +		ret = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	usb_fill_bulk_urb(priv->ack, usbtouch->udev,
> > +			  usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
> > +			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
> > +			  usbtouch);
> > +	/* submit first IRQ URB */
> > +	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
>
> If this fails, when is priv->ack freed?

Looks like I'm constantly missing this. See the new patch below.

> > +err_out:
> > +	kfree(buf);
> > +	return ret;
> > +}
> > +
> > +static void nexio_exit(struct usbtouch_usb *usbtouch)
> > +{
> > +	struct nexio_priv *priv = usbtouch->priv;
> > +
> > +	usb_kill_urb(priv->ack);
> > +	usb_free_urb(priv->ack);
> > +	kfree(priv);
> > +}
> > +
> >
> >
> > @@ -862,7 +1073,8 @@ static void usbtouch_close(struct input_
> >  {
> >  	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
> >
> > -	usb_kill_urb(usbtouch->irq);
> > +	if (!usbtouch->type->no_urb_in_open)
> > +		usb_kill_urb(usbtouch->irq);
> >  }
> >
> >
> > @@ -960,10 +1172,12 @@ static int usbtouch_probe(struct usb_int
> >  		                     type->max_press, 0, 0);
> >
> >  	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
> > -			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
> > +			 usb_rcvintpipe(usbtouch->udev,
> > +					type->endpoint ? type->endpoint
> > +							: endpoint->bEndpointAddress),
> >  			 usbtouch->data, type->rept_size,
> > -			 usbtouch_irq, usbtouch, endpoint->bInterval);
> > -
> > +			 usbtouch_irq, usbtouch,
> > +			 type->interval ? type->interval : endpoint->bInterval);
> >  	usbtouch->irq->dev = usbtouch->udev;
> >  	usbtouch->irq->transfer_dma = usbtouch->data_dma;
> >  	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> > @@ -1006,6 +1220,8 @@ static void usbtouch_disconnect(struct u
> >
> >  	dbg("%s - usbtouch is initialized, cleaning up", __func__);
> >  	usb_set_intfdata(intf, NULL);
> > +	if (usbtouch->type->exit)
> > +		usbtouch->type->exit(usbtouch);
> >  	usb_kill_urb(usbtouch->irq);
>
> You've reversed the order. Order is important. If priv->irq
> can cause priv->ack to be submitted, it must be killed first.
> If priv->ack may submit priv->irq the reverse order is needed.
> I don't know which is correct, but only that order may be important.

Thanks, I see now. irq may submit ack, ack never submits anything. So the 
correct order is: "first kill irq, then ack".

> >  	input_unregister_device(usbtouch->input);
>
> What tells you that open() isn't called at this point reversing
> usb_kill_urb() you've already done?

Looks like a bug in the original usbtouchscreen code. There's no locking.
Will a spinlock in usbtouch_open() and usbtouch_disconnect() fix it? Or 
do you see more problems here?



--- linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c.orig	2009-09-10 00:13:59.000000000 +0200
+++ linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c	2009-11-20 09:32:39.000000000 +0100
@@ -13,6 +13,7 @@
  *  - IdealTEK URTC1000
  *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
+ *  - NEXIO/iNexio
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -71,6 +72,8 @@ struct usbtouch_device_info {
 	int min_yc, max_yc;
 	int min_press, max_press;
 	int rept_size;
+	bool no_urb_in_open;
+	int endpoint, interval;
 
 	void (*process_pkt) (struct usbtouch_usb *usbtouch, unsigned char *pkt, int len);
 
@@ -84,6 +87,7 @@ struct usbtouch_device_info {
 
 	int  (*read_data)   (struct usbtouch_usb *usbtouch, unsigned char *pkt);
 	int  (*init)        (struct usbtouch_usb *usbtouch);
+	void (*exit)	    (struct usbtouch_usb *usbtouch);
 };
 
 /* a usbtouch device */
@@ -98,6 +102,7 @@ struct usbtouch_usb {
 	struct usbtouch_device_info *type;
 	char name[128];
 	char phys[64];
+	void *priv;
 
 	int x, y;
 	int touch, press;
@@ -118,6 +123,7 @@ enum {
 	DEVTYPE_IDEALTEK,
 	DEVTYPE_GENERAL_TOUCH,
 	DEVTYPE_GOTOP,
+	DEVTYPE_NEXIO,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -191,6 +197,14 @@ static struct usb_device_id usbtouch_dev
 	{USB_DEVICE(0x08f2, 0x00f4), .driver_info = DEVTYPE_GOTOP},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	/* data interface only */
+	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x0a, 0x00, 0x00),
+		.driver_info = DEVTYPE_NEXIO},
+	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x0a, 0x00, 0x00),
+		.driver_info = DEVTYPE_NEXIO},
+#endif
+
 	{}
 };
 
@@ -563,6 +577,200 @@ static int gotop_read_data(struct usbtou
 }
 #endif
 
+/*****************************************************************************
+ * NEXIO Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+
+#define NEXIO_OUTPUT_EP	0x01
+#define NEXIO_INPUT_EP	0x82
+#define NEXIO_TIMEOUT	5000
+#define NEXIO_BUFSIZE	1024
+#define NEXIO_THRESHOLD	50
+
+struct nexio_priv {
+	struct urb *ack;
+	unsigned char *ack_buf;
+};
+
+struct nexio_touch_packet {
+	u8	flags;		/* 0xe1 = touch, 0xe1 = release */
+	__be16	data_len;	/* total bytes of touch data */
+	__be16	x_len;		/* bytes for X axis */
+	__be16	y_len;		/* bytes for Y axis */
+	u8	data[];
+} __attribute__ ((packed));
+
+static unsigned char nexio_ack_pkt[2] = { 0xaa, 0x02 };
+static unsigned char nexio_init_pkt[4] = { 0x82, 0x04, 0x0a, 0x0f };
+
+static int nexio_init(struct usbtouch_usb *usbtouch)
+{
+	struct usb_device *dev = usbtouch->udev;
+	struct nexio_priv *priv;
+	int ret = -ENOMEM;
+	int actual_len, i;
+	unsigned char *buf;
+	char *firmware_ver = NULL, *device_name = NULL;
+
+	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		goto out_buf;
+	/* two empty reads */
+	for (i = 0; i < 2; i++) {
+		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0)
+			goto out_buf;
+	}
+	/* send init command */
+	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP),
+			   buf, sizeof(nexio_init_pkt), &actual_len,
+			   NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto out_buf;
+	/* read replies */
+	for (i = 0; i < 3; i++) {
+		memset(buf, 0, NEXIO_BUFSIZE);
+		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0 || actual_len < 1 || buf[1] != actual_len)
+			continue;
+		switch (buf[0]) {
+			case 0x83:	/* firmware version */
+				firmware_ver = kstrdup(&buf[2], GFP_KERNEL);
+				break;
+			case 0x84:	/* device name */
+				device_name = kstrdup(&buf[2], GFP_KERNEL);
+				break;
+		}
+	}
+	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
+	       device_name, firmware_ver);
+	kfree(firmware_ver);
+	kfree(device_name);
+
+	/* prepare ACK URB */
+	ret = -ENOMEM;
+	usbtouch->priv = kmalloc(sizeof(struct nexio_priv), GFP_KERNEL);
+	if (!usbtouch->priv)
+		goto out_buf;
+	priv = usbtouch->priv;
+	priv->ack_buf = kmalloc(sizeof(nexio_ack_pkt), GFP_KERNEL);
+	if (!priv->ack_buf)
+		goto err_priv;
+	memcpy(priv->ack_buf, nexio_ack_pkt, sizeof(nexio_ack_pkt));
+	priv->ack = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->ack) {
+		dbg("%s - usb_alloc_urb failed: usbtouch->ack", __func__);
+		goto err_ack_buf;
+	}
+	usb_fill_bulk_urb(priv->ack, usbtouch->udev,
+			  usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
+			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
+			  usbtouch);
+	/* submit first IRQ URB */
+	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
+	if (ret < 0) {
+		usb_free_urb(priv->ack);
+		goto err_ack_buf;
+	}
+	goto out_buf;
+err_ack_buf:
+	kfree(priv->ack_buf);
+err_priv:
+	kfree(priv);
+out_buf:
+	kfree(buf);
+	return ret;
+}
+
+static void nexio_exit(struct usbtouch_usb *usbtouch)
+{
+	struct nexio_priv *priv = usbtouch->priv;
+
+	usb_kill_urb(priv->ack);
+	usb_free_urb(priv->ack);
+	kfree(priv);
+}
+
+static int nexio_read_data(struct usbtouch_usb *usbtouch, unsigned char *pkt)
+{
+	int x, y, begin_x, begin_y, end_x, end_y, w, h, ret;
+	struct nexio_touch_packet *packet = (void *) pkt;
+	struct nexio_priv *priv = usbtouch->priv;
+
+	/* got touch data? */
+	if ((pkt[0] & 0xe0) != 0xe0)
+		return 0;
+
+	/* send ACK */
+	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
+
+	if (!usbtouch->type->max_xc) {
+		usbtouch->type->max_xc = 2 * be16_to_cpu(packet->x_len);
+		input_set_abs_params(usbtouch->input, ABS_X, 0,
+				     2 * be16_to_cpu(packet->x_len), 0, 0);
+		usbtouch->type->max_yc = 2 * be16_to_cpu(packet->y_len);
+		input_set_abs_params(usbtouch->input, ABS_Y, 0,
+				     2 * be16_to_cpu(packet->y_len), 0, 0);
+	}
+	/* The device reports state of IR sensors on X and Y axes.
+	 * Each byte represents "darkness" percentage (0-100) of one element.
+	 * 17" touchscreen reports only 64 x 52 bytes so the resolution is low.
+	 * This also means that there's a limited multi-touch capability but
+	 * it's disabled (and untested) here as there's no X driver for that.
+	 */
+	begin_x = end_x = begin_y = end_y = -1;
+	for (x = 0; x < be16_to_cpu(packet->x_len); x++) {
+		if (begin_x == -1 && packet->data[x] > NEXIO_THRESHOLD) {
+			begin_x = x;
+			continue;
+		}
+		if (end_x == -1 && begin_x != -1 && packet->data[x] < NEXIO_THRESHOLD) {
+			end_x = x - 1;
+			for (y = be16_to_cpu(packet->x_len);
+			     y < be16_to_cpu(packet->data_len); y++) {
+				if (begin_y == -1 && packet->data[y] > NEXIO_THRESHOLD) {
+					begin_y = y - be16_to_cpu(packet->x_len);
+					continue;
+				}
+				if (end_y == -1 &&
+				    begin_y != -1 && packet->data[y] < NEXIO_THRESHOLD) {
+					end_y = y - 1 - be16_to_cpu(packet->x_len);
+					w = end_x - begin_x;
+					h = end_y - begin_y;
+					/* multi-touch */
+/*					input_report_abs(usbtouch->input,
+						    ABS_MT_TOUCH_MAJOR, max(w,h));
+					input_report_abs(usbtouch->input,
+						    ABS_MT_TOUCH_MINOR, min(x,h));
+					input_report_abs(usbtouch->input,
+						    ABS_MT_POSITION_X, 2*begin_x+w);
+					input_report_abs(usbtouch->input,
+						    ABS_MT_POSITION_Y, 2*begin_y+h);
+					input_report_abs(usbtouch->input,
+						    ABS_MT_ORIENTATION, w > h);
+					input_mt_sync(usbtouch->input);*/
+					/* single touch */
+					usbtouch->x = 2 * begin_x + w;
+					usbtouch->y = 2 * begin_y + h;
+					usbtouch->touch = packet->flags & 0x01;
+					begin_y = end_y = -1;
+					return 1;
+				}
+			}
+			begin_x = end_x = -1;
+		}
+
+	}
+	return 0;
+}
+#endif
+
 
 /*****************************************************************************
  * the different device descriptors
@@ -702,6 +910,18 @@ static struct usbtouch_device_info usbto
 		.read_data	= gotop_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	[DEVTYPE_NEXIO] = {
+		.rept_size	= 128,
+		.no_urb_in_open = 1,
+		.endpoint	= NEXIO_INPUT_EP,
+		.interval	= 0xff,
+		.read_data	= nexio_read_data,
+		.init		= nexio_init,
+		.exit		= nexio_exit,
+	},
+#endif
 };
 
 
@@ -852,8 +1072,9 @@ static int usbtouch_open(struct input_de
 
 	usbtouch->irq->dev = usbtouch->udev;
 
-	if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
-		return -EIO;
+	if (!usbtouch->type->no_urb_in_open)
+		if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
+			return -EIO;
 
 	return 0;
 }
@@ -862,7 +1083,8 @@ static void usbtouch_close(struct input_
 {
 	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
 
-	usb_kill_urb(usbtouch->irq);
+	if (!usbtouch->type->no_urb_in_open)
+		usb_kill_urb(usbtouch->irq);
 }
 
 
@@ -960,10 +1182,12 @@ static int usbtouch_probe(struct usb_int
 		                     type->max_press, 0, 0);
 
 	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
-			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
+			 usb_rcvintpipe(usbtouch->udev,
+					type->endpoint ? type->endpoint
+							: endpoint->bEndpointAddress),
 			 usbtouch->data, type->rept_size,
-			 usbtouch_irq, usbtouch, endpoint->bInterval);
-
+			 usbtouch_irq, usbtouch,
+			 type->interval ? type->interval : endpoint->bInterval);
 	usbtouch->irq->dev = usbtouch->udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;
 	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -1009,6 +1233,8 @@ static void usbtouch_disconnect(struct u
 	usb_kill_urb(usbtouch->irq);
 	input_unregister_device(usbtouch->input);
 	usb_free_urb(usbtouch->irq);
+	if (usbtouch->type->exit)
+		usbtouch->type->exit(usbtouch);
 	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
 	kfree(usbtouch);
 }



-- 
Ondrej Zary
