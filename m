Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZKPOPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZKPOPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZKPOPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:15:05 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40879 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbZKPOPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:15:03 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: daniel.ritz@gmx.ch
Subject: [PATCH] NEXIO (or iNexio) support for usbtouchscreen
Date: Mon, 16 Nov 2009 15:14:59 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911161515.00907.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this adds support for NEXIO (or iNexio) USB touchscreens to usbtouchscreen
driver. Tested with NEX170MRT 17" LCD monitor with integrated touchscreen
(with xserver-xorg-input-evtouch 0.8.8-1):

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 54 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=02(comm.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1870 ProdID=0001 Rev= 1.00
S:  Manufacturer=iNexio
S:  Product=iNexio USB
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=00 Driver=(none)
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms

No datasheet is available, this was written by capturing some data with
SniffUSB in Windows:
http://www.rainbow-software.org/linux_files/nexio/

The device is a bit specific (read: broken) in at least 5 ways:
1. It's very slow to initialize (takes many seconds)
2. The driver must communicate with the device or it disconnects
   (that's why the irq URB is sent during init)
3. The endpoints are mixed up somehow, irq URB works on EP 0x82, the
   first interface with endpoint 0x83 is probably useless
4. It has weird limited multi-touch capability
5. It sends the X and Y range only in touch data, not during initialization


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c.orig	2009-09-10 00:13:59.000000000 +0200
+++ linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c	2009-11-16 14:37:15.000000000 +0100
@@ -13,6 +13,7 @@
  *  - IdealTEK URTC1000
  *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
+ *  - NEXIO/iNexio
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -71,6 +72,8 @@
 	int min_yc, max_yc;
 	int min_press, max_press;
 	int rept_size;
+	bool no_urb_in_open;
+	int endpoint, interval;
 
 	void (*process_pkt) (struct usbtouch_usb *usbtouch, unsigned char *pkt, int len);
 
@@ -92,7 +95,7 @@
 	dma_addr_t data_dma;
 	unsigned char *buffer;
 	int buf_len;
-	struct urb *irq;
+	struct urb *irq, *ack;
 	struct usb_device *udev;
 	struct input_dev *input;
 	struct usbtouch_device_info *type;
@@ -118,6 +121,7 @@
 	DEVTYPE_IDEALTEK,
 	DEVTYPE_GENERAL_TOUCH,
 	DEVTYPE_GOTOP,
+	DEVTYPE_NEXIO,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -191,6 +195,17 @@
 	{USB_DEVICE(0x08f2, 0x00f4), .driver_info = DEVTYPE_GOTOP},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	/* ignore the comm interface */
+	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x02, 0x02, 0x00),
+		.driver_info = DEVTYPE_IGNORE},
+	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x02, 0x02, 0x00),
+		.driver_info = DEVTYPE_IGNORE},
+	/* normal device IDs */
+	{USB_DEVICE(0x10f0, 0x2002), .driver_info = DEVTYPE_NEXIO},
+	{USB_DEVICE(0x1870, 0x0001), .driver_info = DEVTYPE_NEXIO},
+#endif
+
 	{}
 };
 
@@ -563,6 +578,167 @@
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
+static unsigned char nexio_ack[2] = { 0xaa, 0x02 };
+
+static int nexio_init(struct usbtouch_usb *usbtouch)
+{
+	struct usb_device *dev = usbtouch->udev;
+	int ret = -ENOMEM;
+	int actual_len;
+	unsigned char *buf;
+	unsigned char init[4] = { 0x82, 0x04, 0x0a, 0x0f };
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
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), init,
+			   sizeof(init), &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* read it back */
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			  NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
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
+			 usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
+			 nexio_ack, sizeof(nexio_ack), NULL, usbtouch);
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
@@ -702,6 +878,17 @@
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
 
 
@@ -852,8 +1039,9 @@
 
 	usbtouch->irq->dev = usbtouch->udev;
 
-	if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
-		return -EIO;
+	if (!usbtouch->type->no_urb_in_open)
+		if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
+			return -EIO;
 
 	return 0;
 }
@@ -960,10 +1148,12 @@
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
@@ -1009,6 +1199,7 @@
 	usb_kill_urb(usbtouch->irq);
 	input_unregister_device(usbtouch->input);
 	usb_free_urb(usbtouch->irq);
+	usb_free_urb(usbtouch->ack);
 	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
 	kfree(usbtouch);
 }


-- 
Ondrej Zary
