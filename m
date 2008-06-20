Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbYFTUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbYFTUlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762689AbYFTUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761223AbYFTUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 63/70] tty-usb-safe-serial: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:34 +0100
Message-ID: <20080620200632.1479.59097.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/safe_serial.c |  290 +++++++++++++++++++++-----------------
 1 files changed, 157 insertions(+), 133 deletions(-)


diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index f823e4d..def52d0 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -13,24 +13,25 @@
  *      Stuart Lynne <sl@lineo.com>, Tom Rushworth <tbr@lineo.com>
  */
 
-/* 
- * The encapsultaion is designed to overcome difficulties with some USB hardware.
+/*
+ * The encapsultaion is designed to overcome difficulties with some USB
+ * hardware.
  *
  * While the USB protocol has a CRC over the data while in transit, i.e. while
- * being carried over the bus, there is no end to end protection. If the hardware
- * has any problems getting the data into or out of the USB transmit and receive
- * FIFO's then data can be lost. 
+ * being carried over the bus, there is no end to end protection. If the
+ * hardware has any problems getting the data into or out of the USB transmit
+ * and receive FIFO's then data can be lost.
  *
- * This protocol adds a two byte trailer to each USB packet to specify the number
- * of bytes of valid data and a 10 bit CRC that will allow the receiver to verify
- * that the entire USB packet was received without error.
+ * This protocol adds a two byte trailer to each USB packet to specify the
+ * number of bytes of valid data and a 10 bit CRC that will allow the receiver
+ * to verify that the entire USB packet was received without error.
  *
- * Because in this case the sender and receiver are the class and function drivers
- * there is now end to end protection.
+ * Because in this case the sender and receiver are the class and function
+ * drivers there is now end to end protection.
  *
- * There is an additional option that can be used to force all transmitted packets
- * to be padded to the maximum packet size. This provides a work around for some
- * devices which have problems with small USB packets.
+ * There is an additional option that can be used to force all transmitted
+ * packets to be padded to the maximum packet size. This provides a work
+ * around for some devices which have problems with small USB packets.
  *
  * Assuming a packetsize of N:
  *
@@ -44,11 +45,12 @@
  *      | Data Length       | 10 bit CRC                                |
  *      + 7 . 6 . 5 . 4 . 3 . 2 . 1 . 0 | 7 . 6 . 5 . 4 . 3 . 2 . 1 . 0 +
  *
- * The 10 bit CRC is computed across the sent data, followed by the trailer with
- * the length set and the CRC set to zero. The CRC is then OR'd into the trailer.
+ * The 10 bit CRC is computed across the sent data, followed by the trailer
+ * with the length set and the CRC set to zero. The CRC is then OR'd into
+ * the trailer.
  *
- * When received a 10 bit CRC is computed over the entire frame including the trailer
- * and should be equal to zero.
+ * When received a 10 bit CRC is computed over the entire frame including
+ * the trailer and should be equal to zero.
  *
  * Two module parameters are used to control the encapsulation, if both are
  * turned of the module works as a simple serial device with NO
@@ -69,7 +71,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -86,12 +88,12 @@ static int padded = CONFIG_USB_SERIAL_SAFE_PADDED;
 #define DRIVER_AUTHOR "sl@lineo.com, tbr@lineo.com"
 #define DRIVER_DESC "USB Safe Encapsulated Serial"
 
-MODULE_AUTHOR (DRIVER_AUTHOR);
-MODULE_DESCRIPTION (DRIVER_DESC);
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
-static __u16 vendor;		// no default
-static __u16 product;		// no default
+static __u16 vendor;		/* no default */
+static __u16 product;		/* no default */
 module_param(vendor, ushort, 0);
 MODULE_PARM_DESC(vendor, "User specified USB idVendor (required)");
 module_param(product, ushort, 0);
@@ -122,30 +124,31 @@ MODULE_PARM_DESC(padded, "Pad to full wMaxPacketSize On/Off");
 #define LINEO_SAFESERIAL_CRC_PADDED             0x02
 
 
-#define MY_USB_DEVICE(vend,prod,dc,ic,isc) \
-        .match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_DEV_CLASS | \
-                USB_DEVICE_ID_MATCH_INT_CLASS | USB_DEVICE_ID_MATCH_INT_SUBCLASS, \
-        .idVendor = (vend), \
-        .idProduct = (prod),\
-        .bDeviceClass = (dc),\
-        .bInterfaceClass = (ic), \
-        .bInterfaceSubClass = (isc),
+#define MY_USB_DEVICE(vend, prod, dc, ic, isc) \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_DEV_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS, \
+	.idVendor = (vend), \
+	.idProduct = (prod),\
+	.bDeviceClass = (dc),\
+	.bInterfaceClass = (ic), \
+	.bInterfaceSubClass = (isc),
 
 static struct usb_device_id id_table[] = {
-	{MY_USB_DEVICE (0x49f, 0xffff, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Itsy
-	{MY_USB_DEVICE (0x3f0, 0x2101, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Calypso
-	{MY_USB_DEVICE (0x4dd, 0x8001, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Iris 
-	{MY_USB_DEVICE (0x4dd, 0x8002, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Collie 
-	{MY_USB_DEVICE (0x4dd, 0x8003, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Collie 
-	{MY_USB_DEVICE (0x4dd, 0x8004, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Collie 
-	{MY_USB_DEVICE (0x5f9, 0xffff, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	// Sharp tmp
-	// extra null entry for module 
-	// vendor/produc parameters
-	{MY_USB_DEVICE (0, 0, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},
-	{}			// terminating entry 
+	{MY_USB_DEVICE(0x49f, 0xffff, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Itsy */
+	{MY_USB_DEVICE(0x3f0, 0x2101, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Calypso */
+	{MY_USB_DEVICE(0x4dd, 0x8001, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Iris */
+	{MY_USB_DEVICE(0x4dd, 0x8002, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Collie */
+	{MY_USB_DEVICE(0x4dd, 0x8003, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Collie */
+	{MY_USB_DEVICE(0x4dd, 0x8004, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Collie */
+	{MY_USB_DEVICE(0x5f9, 0xffff, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},	/* Sharp tmp */
+	/* extra null entry for module vendor/produc parameters */
+	{MY_USB_DEVICE(0, 0, CDC_DEVICE_CLASS, LINEO_INTERFACE_CLASS, LINEO_INTERFACE_SUBCLASS_SAFESERIAL)},
+	{}			/* terminating entry  */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver safe_driver = {
 	.name =		"safe_serial",
@@ -156,29 +159,45 @@ static struct usb_driver safe_driver = {
 };
 
 static const __u16 crc10_table[256] = {
-	0x000, 0x233, 0x255, 0x066, 0x299, 0x0aa, 0x0cc, 0x2ff, 0x301, 0x132, 0x154, 0x367, 0x198, 0x3ab, 0x3cd, 0x1fe,
-	0x031, 0x202, 0x264, 0x057, 0x2a8, 0x09b, 0x0fd, 0x2ce, 0x330, 0x103, 0x165, 0x356, 0x1a9, 0x39a, 0x3fc, 0x1cf,
-	0x062, 0x251, 0x237, 0x004, 0x2fb, 0x0c8, 0x0ae, 0x29d, 0x363, 0x150, 0x136, 0x305, 0x1fa, 0x3c9, 0x3af, 0x19c,
-	0x053, 0x260, 0x206, 0x035, 0x2ca, 0x0f9, 0x09f, 0x2ac, 0x352, 0x161, 0x107, 0x334, 0x1cb, 0x3f8, 0x39e, 0x1ad,
-	0x0c4, 0x2f7, 0x291, 0x0a2, 0x25d, 0x06e, 0x008, 0x23b, 0x3c5, 0x1f6, 0x190, 0x3a3, 0x15c, 0x36f, 0x309, 0x13a,
-	0x0f5, 0x2c6, 0x2a0, 0x093, 0x26c, 0x05f, 0x039, 0x20a, 0x3f4, 0x1c7, 0x1a1, 0x392, 0x16d, 0x35e, 0x338, 0x10b,
-	0x0a6, 0x295, 0x2f3, 0x0c0, 0x23f, 0x00c, 0x06a, 0x259, 0x3a7, 0x194, 0x1f2, 0x3c1, 0x13e, 0x30d, 0x36b, 0x158,
-	0x097, 0x2a4, 0x2c2, 0x0f1, 0x20e, 0x03d, 0x05b, 0x268, 0x396, 0x1a5, 0x1c3, 0x3f0, 0x10f, 0x33c, 0x35a, 0x169,
-	0x188, 0x3bb, 0x3dd, 0x1ee, 0x311, 0x122, 0x144, 0x377, 0x289, 0x0ba, 0x0dc, 0x2ef, 0x010, 0x223, 0x245, 0x076,
-	0x1b9, 0x38a, 0x3ec, 0x1df, 0x320, 0x113, 0x175, 0x346, 0x2b8, 0x08b, 0x0ed, 0x2de, 0x021, 0x212, 0x274, 0x047,
-	0x1ea, 0x3d9, 0x3bf, 0x18c, 0x373, 0x140, 0x126, 0x315, 0x2eb, 0x0d8, 0x0be, 0x28d, 0x072, 0x241, 0x227, 0x014,
-	0x1db, 0x3e8, 0x38e, 0x1bd, 0x342, 0x171, 0x117, 0x324, 0x2da, 0x0e9, 0x08f, 0x2bc, 0x043, 0x270, 0x216, 0x025,
-	0x14c, 0x37f, 0x319, 0x12a, 0x3d5, 0x1e6, 0x180, 0x3b3, 0x24d, 0x07e, 0x018, 0x22b, 0x0d4, 0x2e7, 0x281, 0x0b2,
-	0x17d, 0x34e, 0x328, 0x11b, 0x3e4, 0x1d7, 0x1b1, 0x382, 0x27c, 0x04f, 0x029, 0x21a, 0x0e5, 0x2d6, 0x2b0, 0x083,
-	0x12e, 0x31d, 0x37b, 0x148, 0x3b7, 0x184, 0x1e2, 0x3d1, 0x22f, 0x01c, 0x07a, 0x249, 0x0b6, 0x285, 0x2e3, 0x0d0,
-	0x11f, 0x32c, 0x34a, 0x179, 0x386, 0x1b5, 0x1d3, 0x3e0, 0x21e, 0x02d, 0x04b, 0x278, 0x087, 0x2b4, 0x2d2, 0x0e1,
+	0x000, 0x233, 0x255, 0x066, 0x299, 0x0aa, 0x0cc, 0x2ff,
+	0x301, 0x132, 0x154, 0x367, 0x198, 0x3ab, 0x3cd, 0x1fe,
+	0x031, 0x202, 0x264, 0x057, 0x2a8, 0x09b, 0x0fd, 0x2ce,
+	0x330, 0x103, 0x165, 0x356, 0x1a9, 0x39a, 0x3fc, 0x1cf,
+	0x062, 0x251, 0x237, 0x004, 0x2fb, 0x0c8, 0x0ae, 0x29d,
+	0x363, 0x150, 0x136, 0x305, 0x1fa, 0x3c9, 0x3af, 0x19c,
+	0x053, 0x260, 0x206, 0x035, 0x2ca, 0x0f9, 0x09f, 0x2ac,
+	0x352, 0x161, 0x107, 0x334, 0x1cb, 0x3f8, 0x39e, 0x1ad,
+	0x0c4, 0x2f7, 0x291, 0x0a2, 0x25d, 0x06e, 0x008, 0x23b,
+	0x3c5, 0x1f6, 0x190, 0x3a3, 0x15c, 0x36f, 0x309, 0x13a,
+	0x0f5, 0x2c6, 0x2a0, 0x093, 0x26c, 0x05f, 0x039, 0x20a,
+	0x3f4, 0x1c7, 0x1a1, 0x392, 0x16d, 0x35e, 0x338, 0x10b,
+	0x0a6, 0x295, 0x2f3, 0x0c0, 0x23f, 0x00c, 0x06a, 0x259,
+	0x3a7, 0x194, 0x1f2, 0x3c1, 0x13e, 0x30d, 0x36b, 0x158,
+	0x097, 0x2a4, 0x2c2, 0x0f1, 0x20e, 0x03d, 0x05b, 0x268,
+	0x396, 0x1a5, 0x1c3, 0x3f0, 0x10f, 0x33c, 0x35a, 0x169,
+	0x188, 0x3bb, 0x3dd, 0x1ee, 0x311, 0x122, 0x144, 0x377,
+	0x289, 0x0ba, 0x0dc, 0x2ef, 0x010, 0x223, 0x245, 0x076,
+	0x1b9, 0x38a, 0x3ec, 0x1df, 0x320, 0x113, 0x175, 0x346,
+	0x2b8, 0x08b, 0x0ed, 0x2de, 0x021, 0x212, 0x274, 0x047,
+	0x1ea, 0x3d9, 0x3bf, 0x18c, 0x373, 0x140, 0x126, 0x315,
+	0x2eb, 0x0d8, 0x0be, 0x28d, 0x072, 0x241, 0x227, 0x014,
+	0x1db, 0x3e8, 0x38e, 0x1bd, 0x342, 0x171, 0x117, 0x324,
+	0x2da, 0x0e9, 0x08f, 0x2bc, 0x043, 0x270, 0x216, 0x025,
+	0x14c, 0x37f, 0x319, 0x12a, 0x3d5, 0x1e6, 0x180, 0x3b3,
+	0x24d, 0x07e, 0x018, 0x22b, 0x0d4, 0x2e7, 0x281, 0x0b2,
+	0x17d, 0x34e, 0x328, 0x11b, 0x3e4, 0x1d7, 0x1b1, 0x382,
+	0x27c, 0x04f, 0x029, 0x21a, 0x0e5, 0x2d6, 0x2b0, 0x083,
+	0x12e, 0x31d, 0x37b, 0x148, 0x3b7, 0x184, 0x1e2, 0x3d1,
+	0x22f, 0x01c, 0x07a, 0x249, 0x0b6, 0x285, 0x2e3, 0x0d0,
+	0x11f, 0x32c, 0x34a, 0x179, 0x386, 0x1b5, 0x1d3, 0x3e0,
+	0x21e, 0x02d, 0x04b, 0x278, 0x087, 0x2b4, 0x2d2, 0x0e1,
 };
 
-#define CRC10_INITFCS     0x000	// Initial FCS value
-#define CRC10_GOODFCS     0x000	// Good final FCS value
-#define CRC10_FCS(fcs, c) ( (((fcs) << 8) & 0x3ff) ^ crc10_table[((fcs) >> 2) & 0xff] ^ (c))
+#define CRC10_INITFCS     0x000	/* Initial FCS value */
+#define CRC10_GOODFCS     0x000	/* Good final FCS value */
+#define CRC10_FCS(fcs, c) ((((fcs) << 8) & 0x3ff) ^ crc10_table[((fcs) >> 2) & 0xff] ^ (c))
 
-/**     
+/**
  * fcs_compute10 - memcpy and calculate 10 bit CRC across buffer
  * @sp: pointer to buffer
  * @len: number of bytes
@@ -187,13 +206,13 @@ static const __u16 crc10_table[256] = {
  * Perform a memcpy and calculate fcs using ppp 10bit CRC algorithm. Return
  * new 10 bit FCS.
  */
-static __u16 __inline__ fcs_compute10 (unsigned char *sp, int len, __u16 fcs)
+static __u16 __inline__ fcs_compute10(unsigned char *sp, int len, __u16 fcs)
 {
-	for (; len-- > 0; fcs = CRC10_FCS (fcs, *sp++));
+	for (; len-- > 0; fcs = CRC10_FCS(fcs, *sp++));
 	return fcs;
 }
 
-static void safe_read_bulk_callback (struct urb *urb)
+static void safe_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
@@ -201,7 +220,7 @@ static void safe_read_bulk_callback (struct urb *urb)
 	int result;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	if (status) {
 		dbg("%s - nonzero read bulk status received: %d",
@@ -209,50 +228,55 @@ static void safe_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	dbg ("safe_read_bulk_callback length: %d", port->read_urb->actual_length);
+	dbg("safe_read_bulk_callback length: %d",
+					port->read_urb->actual_length);
 #ifdef ECHO_RCV
 	{
 		int i;
 		unsigned char *cp = port->read_urb->transfer_buffer;
 		for (i = 0; i < port->read_urb->actual_length; i++) {
-			if ((i % 32) == 0) {
-				printk ("\nru[%02x] ", i);
-			}
-			printk ("%02x ", *cp++);
+			if ((i % 32) == 0)
+				printk("\nru[%02x] ", i);
+			printk("%02x ", *cp++);
 		}
-		printk ("\n");
+		printk("\n");
 	}
 #endif
 	if (safe) {
 		__u16 fcs;
-		if (!(fcs = fcs_compute10 (data, length, CRC10_INITFCS))) {
+		fcs = fcs_compute10(data, length, CRC10_INITFCS);
+		if (!fcs) {
 			int actual_length = data[length - 2] >> 2;
 			if (actual_length <= (length - 2)) {
-				info ("%s - actual: %d", __func__, actual_length);
-				tty_insert_flip_string(port->port.tty, data, actual_length);
-				tty_flip_buffer_push (port->port.tty);
+				info("%s - actual: %d", __func__,
+							actual_length);
+				tty_insert_flip_string(port->port.tty,
+							data, actual_length);
+				tty_flip_buffer_push(port->port.tty);
 			} else {
-				err ("%s - inconsistent lengths %d:%d", __func__,
-				     actual_length, length);
+				err("%s - inconsistent lengths %d:%d",
+					__func__, actual_length, length);
 			}
 		} else {
-			err ("%s - bad CRC %x", __func__, fcs);
+			err("%s - bad CRC %x", __func__, fcs);
 		}
 	} else {
 		tty_insert_flip_string(port->port.tty, data, length);
-		tty_flip_buffer_push (port->port.tty);
+		tty_flip_buffer_push(port->port.tty);
 	}
 
 	/* Continue trying to always read  */
-	usb_fill_bulk_urb (urb, port->serial->dev,
-		       usb_rcvbulkpipe (port->serial->dev, port->bulk_in_endpointAddress),
-		       urb->transfer_buffer, urb->transfer_buffer_length,
-		       safe_read_bulk_callback, port);
-
-	if ((result = usb_submit_urb (urb, GFP_ATOMIC))) {
-		err ("%s - failed resubmitting read urb, error %d", __func__, result);
+	usb_fill_bulk_urb(urb, port->serial->dev,
+			usb_rcvbulkpipe(port->serial->dev,
+					port->bulk_in_endpointAddress),
+			urb->transfer_buffer, urb->transfer_buffer_length,
+			safe_read_bulk_callback, port);
+
+	result = usb_submit_urb(urb, GFP_ATOMIC);
+	if (result)
+		err("%s - failed resubmitting read urb, error %d",
+							__func__, result);
 		/* FIXME: Need a mechanism to retry later if this happens */
-	}
 }
 
 static int safe_write(struct tty_struct *tty, struct usb_serial_port *port,
@@ -263,23 +287,23 @@ static int safe_write(struct tty_struct *tty, struct usb_serial_port *port,
 	int i;
 	int packet_length;
 
-	dbg ("safe_write port: %p %d urb: %p count: %d", port, port->number, port->write_urb,
-	     count);
+	dbg("safe_write port: %p %d urb: %p count: %d",
+				port, port->number, port->write_urb, count);
 
 	if (!port->write_urb) {
-		dbg ("%s - write urb NULL", __func__);
+		dbg("%s - write urb NULL", __func__);
 		return 0;
 	}
 
-	dbg ("safe_write write_urb: %d transfer_buffer_length",
+	dbg("safe_write write_urb: %d transfer_buffer_length",
 	     port->write_urb->transfer_buffer_length);
 
 	if (!port->write_urb->transfer_buffer_length) {
-		dbg ("%s - write urb transfer_buffer_length zero", __func__);
+		dbg("%s - write urb transfer_buffer_length zero", __func__);
 		return 0;
 	}
 	if (count == 0) {
-		dbg ("%s - write request of 0 bytes", __func__);
+		dbg("%s - write request of 0 bytes", __func__);
 		return 0;
 	}
 	spin_lock_bh(&port->lock);
@@ -291,63 +315,64 @@ static int safe_write(struct tty_struct *tty, struct usb_serial_port *port,
 	port->write_urb_busy = 1;
 	spin_unlock_bh(&port->lock);
 
-	packet_length = port->bulk_out_size;	// get max packetsize
+	packet_length = port->bulk_out_size;	/* get max packetsize */
 
-	i = packet_length - (safe ? 2 : 0);	// get bytes to send
+	i = packet_length - (safe ? 2 : 0);	/* get bytes to send */
 	count = (count > i) ? i : count;
 
 
-	// get the data into the transfer buffer
+	/* get the data into the transfer buffer */
 	data = port->write_urb->transfer_buffer;
-	memset (data, '0', packet_length);
+	memset(data, '0', packet_length);
 
-	memcpy (data, buf, count);
+	memcpy(data, buf, count);
 
 	if (safe) {
 		__u16 fcs;
 
-		// pad if necessary
-		if (!padded) {
+		/* pad if necessary */
+		if (!padded)
 			packet_length = count + 2;
-		}
-		// set count
+		/* set count */
 		data[packet_length - 2] = count << 2;
 		data[packet_length - 1] = 0;
 
-		// compute fcs and insert into trailer
-		fcs = fcs_compute10 (data, packet_length, CRC10_INITFCS);
+		/* compute fcs and insert into trailer */
+		fcs = fcs_compute10(data, packet_length, CRC10_INITFCS);
 		data[packet_length - 2] |= fcs >> 8;
 		data[packet_length - 1] |= fcs & 0xff;
 
-		// set length to send
+		/* set length to send */
 		port->write_urb->transfer_buffer_length = packet_length;
 	} else {
 		port->write_urb->transfer_buffer_length = count;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, count, port->write_urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, count,
+					port->write_urb->transfer_buffer);
 #ifdef ECHO_TX
 	{
 		int i;
 		unsigned char *cp = port->write_urb->transfer_buffer;
 		for (i = 0; i < port->write_urb->transfer_buffer_length; i++) {
-			if ((i % 32) == 0) {
-				printk ("\nsu[%02x] ", i);
-			}
-			printk ("%02x ", *cp++);
+			if ((i % 32) == 0)
+				printk("\nsu[%02x] ", i);
+			printk("%02x ", *cp++);
 		}
-		printk ("\n");
+		printk("\n");
 	}
 #endif
 	port->write_urb->dev = port->serial->dev;
-	if ((result = usb_submit_urb (port->write_urb, GFP_KERNEL))) {
+	result = usb_submit_urb(port->write_urb, GFP_KERNEL);
+	if (result) {
 		port->write_urb_busy = 0;
-		err ("%s - failed submitting write urb, error %d", __func__, result);
+		err("%s - failed submitting write urb, error %d",
+							__func__, result);
 		return 0;
 	}
-	dbg ("%s urb: %p submitted", __func__, port->write_urb);
+	dbg("%s urb: %p submitted", __func__, port->write_urb);
 
-	return (count);
+	return count;
 }
 
 static int safe_write_room(struct tty_struct *tty)
@@ -356,21 +381,19 @@ static int safe_write_room(struct tty_struct *tty)
 	int room = 0;		/* Default: no room */
 	unsigned long flags;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (port->write_urb_busy)
 		room = port->bulk_out_size - (safe ? 2 : 0);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (room) {
-		dbg ("safe_write_room returns %d", room);
-	}
-
+	if (room)
+		dbg("safe_write_room returns %d", room);
 	return room;
 }
 
-static int safe_startup (struct usb_serial *serial)
+static int safe_startup(struct usb_serial *serial)
 {
 	switch (serial->interface->cur_altsetting->desc.bInterfaceProtocol) {
 	case LINEO_SAFESERIAL_CRC:
@@ -398,17 +421,18 @@ static struct usb_serial_driver safe_device = {
 	.attach =		safe_startup,
 };
 
-static int __init safe_init (void)
+static int __init safe_init(void)
 {
 	int i, retval;
 
-	info (DRIVER_VERSION " " DRIVER_AUTHOR);
-	info (DRIVER_DESC);
-	info ("vendor: %x product: %x safe: %d padded: %d\n", vendor, product, safe, padded);
+	info(DRIVER_VERSION " " DRIVER_AUTHOR);
+	info(DRIVER_DESC);
+	info("vendor: %x product: %x safe: %d padded: %d\n",
+					vendor, product, safe, padded);
 
-	// if we have vendor / product parameters patch them into id list
+	/* if we have vendor / product parameters patch them into id list */
 	if (vendor || product) {
-		info ("vendor: %x product: %x\n", vendor, product);
+		info("vendor: %x product: %x\n", vendor, product);
 
 		for (i = 0; i < ARRAY_SIZE(id_table); i++) {
 			if (!id_table[i].idVendor && !id_table[i].idProduct) {
@@ -433,11 +457,11 @@ failed_usb_serial_register:
 	return retval;
 }
 
-static void __exit safe_exit (void)
+static void __exit safe_exit(void)
 {
-	usb_deregister (&safe_driver);
-	usb_serial_deregister (&safe_device);
+	usb_deregister(&safe_driver);
+	usb_serial_deregister(&safe_device);
 }
 
-module_init (safe_init);
-module_exit (safe_exit);
+module_init(safe_init);
+module_exit(safe_exit);

