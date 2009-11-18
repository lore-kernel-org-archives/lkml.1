Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZKRMSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZKRMSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZKRMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:18:46 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:45507 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbZKRMSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:18:45 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v2] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Wed, 18 Nov 2009 13:18:43 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911171625.34696.oliver@neukum.org>
In-Reply-To: <200911171625.34696.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911181318.45208.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Oliver Neukum wrote:
> Am Montag, 16. November 2009 15:14:59 schrieb Ondrej Zary:
>
> Hi,
>
> firstly can you please send patches with -up? It makes them more readable.
>
> > ---
> >
> > @@ -92,7 +95,7 @@
> >  	dma_addr_t data_dma;
> >  	unsigned char *buffer;
> >  	int buf_len;
> > -	struct urb *irq;
> > +	struct urb *irq, *ack;
>
> Where is this urb handled in case of disconnection?

See the new patch below.

> > +#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
> > +	/* ignore the comm interface */
> > +	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x02, 0x02, 0x00),
> > +		.driver_info = DEVTYPE_IGNORE},
> > +	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x02, 0x02, 0x00),
> > +		.driver_info = DEVTYPE_IGNORE},
> > +	/* normal device IDs */
> > +	{USB_DEVICE(0x10f0, 0x2002), .driver_info = DEVTYPE_NEXIO},
> > +	{USB_DEVICE(0x1870, 0x0001), .driver_info = DEVTYPE_NEXIO},
>
> Why not go for the interfaces you want?

See the new patch below.

> > +static unsigned char nexio_ack[2] = { 0xaa, 0x02 };
> > +
> > +static int nexio_init(struct usbtouch_usb *usbtouch)
> > +{
> > +	struct usb_device *dev = usbtouch->udev;
> > +	int ret = -ENOMEM;
> > +	int actual_len;
> > +	unsigned char *buf;
> > +	unsigned char init[4] = { 0x82, 0x04, 0x0a, 0x0f };
> > +	char *firmware_ver;
> > +
> > +	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
> > +	if (!buf)
> > +		goto err_nobuf;
> > +	/* two reads */
> > +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> > +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> > +	if (ret < 0)
> > +		goto err_out;
> > +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> > +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> > +	if (ret < 0)
> > +		goto err_out;
> > +	/* send init command */
> > +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), init,
> > +			   sizeof(init), &actual_len, NEXIO_TIMEOUT);
>
> DMA on the kernel stack

I don't know any details about this - what's the correct way to do this?
I tried moving the init[] array outside the function but that didn't work at
all - compiled fine but device was not reporting the name firmware version.
I ended up with copying it to that kmalloced buf.

I'm worried about nexio_ack - that shouldn't work too then. Maybe it really
does not and the device does not care.

I also found another problem: when I disconnect the USB cable, kernel oopses:
BUG: unable to handle kernel NULL pointer dereference
IP: [<f7c794fa>] start_unlink_async+0x63/0xfc

Call Trace:
ehci_urb_dequeue+0x7c/0x11a [ehci_hcd]
unlink1+0xaa/0xc7 [usbcore]
usb_hcd_unlink_urb+0x57/0x84 [usbcore]
usb_kill_urb+0x40/0xbe [usbcore]
default_wake_function+0x0/0x2b
usb_start_wait_urb+0x6e/0xb0 [usbcore]
usb_control_msg+0x10a/0x136 [usbcore]
hub_port_status+0x77/0xf7 [usbcore]
hub_thread+0x56d/0xe14 [usbcore]
autoremove_wake_function+0x0/0x4f
hub_thread+0x0/0xe14 [usbcore]
kthread+0x7a/0x7f
kthread+0x0/0x7f

Are there any other problems with my code that can cause this oops?




--- linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c.orig	2009-09-10 00:13:59.000000000 +0200
+++ linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c	2009-11-18 12:32:19.000000000 +0100
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
 
@@ -92,7 +95,7 @@ struct usbtouch_usb {
 	dma_addr_t data_dma;
 	unsigned char *buffer;
 	int buf_len;
-	struct urb *irq;
+	struct urb *irq, *ack;
 	struct usb_device *udev;
 	struct input_dev *input;
 	struct usbtouch_device_info *type;
@@ -118,6 +121,7 @@ enum {
 	DEVTYPE_IDEALTEK,
 	DEVTYPE_GENERAL_TOUCH,
 	DEVTYPE_GOTOP,
+	DEVTYPE_NEXIO,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -191,6 +195,14 @@ static struct usb_device_id usbtouch_dev
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
 
@@ -563,6 +575,170 @@ static int gotop_read_data(struct usbtou
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
+	int ret = -ENOMEM;
+	int actual_len;
+	unsigned char *buf;
+	char *firmware_ver;
+
+	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		goto err_nobuf;
+	/* two reads */
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* send init command */
+	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP),
+			   buf, sizeof(nexio_init_pkt), &actual_len,
+			   NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* read it back */
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* read firmware version */
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	buf[buf[1]] = 0;	/* second byte is data(string) length */
+	firmware_ver = kstrdup(&buf[2], GFP_KERNEL);
+	/* read device name */
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0) {
+		kfree(firmware_ver);
+		goto err_out;
+	}
+	buf[buf[1]] = 0;
+	printk(KERN_INFO "Nexio device: %s, firmware version %s\n",
+	       &buf[2], firmware_ver);
+	kfree(firmware_ver);
+
+	/* prepare ACK URB */
+	usbtouch->ack = usb_alloc_urb(0, GFP_KERNEL);
+	if (!usbtouch->ack) {
+		dbg("%s - usb_alloc_urb failed: ack_urb", __func__);
+		return 0;
+	}
+	usb_fill_bulk_urb(usbtouch->ack, usbtouch->udev,
+			  usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
+			  nexio_ack_pkt, sizeof(nexio_ack_pkt), NULL,
+			  usbtouch);
+	/* submit first IRQ URB */
+	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
+err_out:
+	kfree(buf);
+err_nobuf:
+	return ret;
+}
+
+static int nexio_read_data(struct usbtouch_usb *usbtouch, unsigned char *pkt)
+{
+	int x, y, begin_x, begin_y, end_x, end_y, w, h, ret;
+	struct nexio_touch_packet *packet = (void *) pkt;
+
+	/* got touch data? */
+	if ((pkt[0] & 0xe0) != 0xe0)
+		return 0;
+
+	/* send ACK */
+	ret = usb_submit_urb(usbtouch->ack, GFP_KERNEL);
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
@@ -702,6 +878,17 @@ static struct usbtouch_device_info usbto
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
+	},
+#endif
 };
 
 
@@ -852,8 +1039,9 @@ static int usbtouch_open(struct input_de
 
 	usbtouch->irq->dev = usbtouch->udev;
 
-	if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
-		return -EIO;
+	if (!usbtouch->type->no_urb_in_open)
+		if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
+			return -EIO;
 
 	return 0;
 }
@@ -862,7 +1050,8 @@ static void usbtouch_close(struct input_
 {
 	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
 
-	usb_kill_urb(usbtouch->irq);
+	if (!usbtouch->type->no_urb_in_open)
+		usb_kill_urb(usbtouch->irq);
 }
 
 
@@ -960,10 +1149,12 @@ static int usbtouch_probe(struct usb_int
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
@@ -1007,8 +1198,10 @@ static void usbtouch_disconnect(struct u
 	dbg("%s - usbtouch is initialized, cleaning up", __func__);
 	usb_set_intfdata(intf, NULL);
 	usb_kill_urb(usbtouch->irq);
+	usb_kill_urb(usbtouch->ack);
 	input_unregister_device(usbtouch->input);
 	usb_free_urb(usbtouch->irq);
+	usb_free_urb(usbtouch->ack);
 	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
 	kfree(usbtouch);
 }


-- 
Ondrej Zary
