Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZLCJJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZLCJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZLCJJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:09:55 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53642 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755386AbZLCJJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:09:53 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3 -next] usbtouchscreen: add NEXIO (or iNexio) support
Date: Thu, 3 Dec 2009 10:09:54 +0100
User-Agent: KMail/1.9.10
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
References: <200911301306.43364.zary@gsystems.sk> <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
In-Reply-To: <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912031009.56041.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for NEXIO (or iNexio) USB touchscreens to usbtouchscreen driver.
Tested with NEX170MRT 17" LCD monitor with integrated touchscreen
(with xserver-xorg-input-evtouch 0.8.8-1):

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 54 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=02(comm.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1870 ProdID=0001 Rev= 1.00
S:  Manufacturer=iNexio
S:  Product=iNexio USB
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=00 Driver=(none)
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms

No datasheet is available, this was written by capturing some data with
SniffUSB in Windows:
http://www.rainbow-software.org/linux_files/nexio/

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/usbtouchscreen.2	2009-12-03 09:26:03.000000000 +0100
+++ linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/usbtouchscreen.c	2009-12-03 09:36:41.000000000 +0100
@@ -15,6 +15,7 @@
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
  *  - JASTEC USB touch controller/DigiTech DTR-02U
  *  - Zytronic capacitive touchscreen
+ *  - NEXIO/iNexio
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -95,6 +96,7 @@ struct usbtouch_device_info {
 
 	int  (*read_data)   (struct usbtouch_usb *usbtouch, unsigned char *pkt);
 	int  (*init)        (struct usbtouch_usb *usbtouch);
+	void (*exit)	    (struct usbtouch_usb *usbtouch);
 };
 
 /* a usbtouch device */
@@ -109,6 +111,7 @@ struct usbtouch_usb {
 	struct usbtouch_device_info *type;
 	char name[128];
 	char phys[64];
+	void *priv;
 
 	int x, y;
 	int touch, press;
@@ -133,6 +136,7 @@ enum {
 	DEVTYPE_E2I,
 	DEVTYPE_ZYTRONIC,
 	DEVTYPE_TC5UH,
+	DEVTYPE_NEXIO,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -222,6 +226,14 @@ static struct usb_device_id usbtouch_dev
 	{USB_DEVICE(0x0664, 0x0309), .driver_info = DEVTYPE_TC5UH},
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
 
@@ -692,6 +704,211 @@ static int zytronic_read_data(struct usb
 #endif
 
 /*****************************************************************************
+ * NEXIO Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+
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
+	struct usb_device *dev = interface_to_usbdev(usbtouch->interface);
+	struct usb_host_interface *interface = usbtouch->interface->cur_altsetting;
+	struct nexio_priv *priv;
+	int ret = -ENOMEM;
+	int actual_len, i;
+	unsigned char *buf;
+	char *firmware_ver = NULL, *device_name = NULL;
+	int input_ep = 0, output_ep = 0;
+
+	/* find first input and output endpoint */
+	for (i = 0; i < interface->desc.bNumEndpoints; i++) {
+		if (!input_ep &&
+		    usb_endpoint_dir_in(&interface->endpoint[i].desc))
+			input_ep = interface->endpoint[i].desc.bEndpointAddress;
+		if (!output_ep &&
+		    usb_endpoint_dir_out(&interface->endpoint[i].desc))
+			output_ep = interface->endpoint[i].desc.bEndpointAddress;
+	}
+	if (!input_ep || !output_ep)
+		return -ENXIO;
+
+	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		goto out_buf;
+	/* two empty reads */
+	for (i = 0; i < 2; i++) {
+		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, input_ep),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0)
+			goto out_buf;
+	}
+	/* send init command */
+	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, output_ep),
+			   buf, sizeof(nexio_init_pkt), &actual_len,
+			   NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto out_buf;
+	/* read replies */
+	for (i = 0; i < 3; i++) {
+		memset(buf, 0, NEXIO_BUFSIZE);
+		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, input_ep),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0 || actual_len < 1 || buf[1] != actual_len)
+			continue;
+		switch (buf[0]) {
+			case 0x83:	/* firmware version */
+				if (!firmware_ver)
+					firmware_ver = kstrdup(&buf[2],
+							       GFP_KERNEL);
+				break;
+			case 0x84:	/* device name */
+				if (!device_name)
+					device_name = kstrdup(&buf[2],
+							      GFP_KERNEL);
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
+	usb_fill_bulk_urb(priv->ack, dev, usb_sndbulkpipe(dev, output_ep),
+			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
+			  usbtouch);
+	ret = 0;
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
+
+/*****************************************************************************
  * the different device descriptors
  */
 #ifdef MULTI_PACKET
@@ -875,6 +1092,16 @@ static struct usbtouch_device_info usbto
 		.read_data	= tc5uh_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	[DEVTYPE_NEXIO] = {
+		.rept_size	= 128,
+		.irq_always	= true,
+		.read_data	= nexio_read_data,
+		.init		= nexio_init,
+		.exit		= nexio_exit,
+	},
+#endif
 };
 
 
@@ -1196,6 +1423,8 @@ static void usbtouch_disconnect(struct u
 	/* this will stop IO via close */
 	input_unregister_device(usbtouch->input);
 	usb_free_urb(usbtouch->irq);
+	if (usbtouch->type->exit)
+		usbtouch->type->exit(usbtouch);
 	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
 	kfree(usbtouch);
 }
--- linux-2.6.32-rc8-next-20091202-orig/drivers/input/touchscreen/Kconfig	2009-12-02 23:52:15.000000000 +0100
+++ linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/Kconfig	2009-12-03 09:38:29.000000000 +0100
@@ -525,6 +525,11 @@ config TOUCHSCREEN_USB_ETT_TC5UH
 	bool "ET&T TC5UH touchscreen controler support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_NEXIO
+	default y
+	bool "NEXIO/iNexio device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO


-- 
Ondrej Zary
