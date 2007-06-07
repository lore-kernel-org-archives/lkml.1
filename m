Return-Path: <linux-kernel-owner+w=401wt.eu-S966214AbXFGAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966214AbXFGAgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXFGAgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:36:12 -0400
Received: from mail.sierrawireless.com ([204.50.29.40]:43801 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965240AbXFGAgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:36:10 -0400
Message-ID: <466751DA.40506@sierrawireless.com>
Date: Wed, 06 Jun 2007 17:31:22 -0700
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: gregkh@suse.de
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, linux@sierrawireless.com
Subject: [PATCH 2.6.22-rc4] USB: add support for TRU-install (C) and new VID/PIDs
 to Sierra Wireless driver (ATTEMPT 2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2007 00:37:46.0760 (UTC) FILETIME=[11A2E080:01C7A89C]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-3.6.1039-15220.002
X-TM-AS-Result: No--8.776500-5.000000-3
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch is derived from the 2.6.22-rc4 kernel source and adds support for the
new TRU-install (C) feature (without this support new devices will not work), and
add new UMTS device VID/PIDs.

There was a previous submission on Tuesday June 5th, it was pointed out that it was
targeted for an outdated kernel, please use this one instead.

Thanks

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>

---

diff -uprN linux-2.6.22-rc4/drivers/usb/serial/sierra.c linux-2.6.22-rc4-swoc/drivers/usb/serial/sierra.c
--- linux-2.6.22-rc4/drivers/usb/serial/sierra.c	2007-06-06 10:53:20.000000000 -0700
+++ linux-2.6.22-rc4-swoc/drivers/usb/serial/sierra.c	2007-06-06 11:14:26.000000000 -0700
@@ -1,6 +1,8 @@
 /*
   USB Driver for Sierra Wireless
 
+  Targeted for 2.6.22 kernel
+
   Copyright (C) 2006  Kevin Lloyd <linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
@@ -15,9 +17,9 @@
 
 */
 
-#define DRIVER_VERSION "v.1.0.6"
+#define DRIVER_VERSION "v.1.2.3"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
-#define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
+#define DRIVER_DESC "USB Driver for Sierra Wireless modems"
 
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -28,66 +30,53 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#include "sierra.h"
+
+static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
+	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+	
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
-
-	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
-	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
+	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
+	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
+	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
+	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
+	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
+	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+
+	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
+	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+	
+	 
+	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},	
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
-static struct usb_device_id id_table_1port [] = {
-	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
-	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
-	{ }
-};
-
-static struct usb_device_id id_table_3port [] = {
-	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
-	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
-	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
-	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
-	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
-	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
-	{ }
-};
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id);
+int sierra_set_power_state(struct usb_device *udev, unsigned long swiState);
+int sierra_set_ms_mode(struct usb_device *udev, SWIMS_SET_MODE_VALUE eSocMode);
 
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
-	.probe      = usb_serial_probe,
+	.probe      = sierra_probe,
 	.disconnect = usb_serial_disconnect,
 	.id_table   = id_table,
 	.no_dynamic_id = 	1,
 };
 
-
-static int debug;
-
-/* per port private data */
-#define N_IN_URB	4
-#define N_OUT_URB	4
-#define IN_BUFLEN	4096
-#define OUT_BUFLEN	128
-
 struct sierra_port_private {
 	/* Input endpoints and buffer for this port */
 	struct urb *in_urbs[N_IN_URB];
@@ -399,8 +388,6 @@ static int sierra_open(struct usb_serial
 	struct usb_serial *serial = port->serial;
 	int i, err;
 	struct urb *urb;
-	int result;
-	__u16 set_mode_dzero = 0x0000;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -447,12 +434,6 @@ static int sierra_open(struct usb_serial
 
 	port->tty->low_latency = 1;
 
-	/* set mode to D0 */
-	result = usb_control_msg(serial->dev,
-				 usb_rcvctrlpipe(serial->dev, 0),
-				 0x00, 0x40, set_mode_dzero, 0, NULL,
-				 0, USB_CTRL_SET_TIMEOUT);
-
 	sierra_send_setup(port);
 
 	return (0);
@@ -623,47 +604,18 @@ static void sierra_shutdown(struct usb_s
 	}
 }
 
-static struct usb_serial_driver sierra_1port_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"sierra1",
-	},
-	.description       = "Sierra USB modem (1 port)",
-	.id_table          = id_table_1port,
-	.usb_driver        = &sierra_driver,
-	.num_interrupt_in  = NUM_DONT_CARE,
-	.num_bulk_in       = 1,
-	.num_bulk_out      = 1,
-	.num_ports         = 1,
-	.open              = sierra_open,
-	.close             = sierra_close,
-	.write             = sierra_write,
-	.write_room        = sierra_write_room,
-	.chars_in_buffer   = sierra_chars_in_buffer,
-	.throttle          = sierra_rx_throttle,
-	.unthrottle        = sierra_rx_unthrottle,
-	.ioctl             = sierra_ioctl,
-	.set_termios       = sierra_set_termios,
-	.break_ctl         = sierra_break_ctl,
-	.tiocmget          = sierra_tiocmget,
-	.tiocmset          = sierra_tiocmset,
-	.attach            = sierra_startup,
-	.shutdown          = sierra_shutdown,
-	.read_int_callback = sierra_instat_callback,
-};
-
-static struct usb_serial_driver sierra_3port_device = {
+static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
-		.name =		"sierra3",
+		.name =		"sierra",
 	},
-	.description       = "Sierra USB modem (3 port)",
-	.id_table          = id_table_3port,
+	.description       = "Sierra USB modem",
+	.id_table          = id_table,
 	.usb_driver        = &sierra_driver,
 	.num_interrupt_in  = NUM_DONT_CARE,
-	.num_bulk_in       = 3,
-	.num_bulk_out      = 3,
-	.num_ports         = 3,
+	.num_bulk_in       = DEF_NUM_PORTS,
+	.num_bulk_out      = DEF_NUM_PORTS,
+	.num_ports         = DEF_NUM_PORTS,
 	.open              = sierra_open,
 	.close             = sierra_close,
 	.write             = sierra_write,
@@ -685,35 +637,89 @@ static struct usb_serial_driver sierra_3
 static int __init sierra_init(void)
 {
 	int retval;
-	retval = usb_serial_register(&sierra_1port_device);
+	dbg ("%s", __FUNCTION__);
+
+	retval = usb_serial_register(&sierra_device);
 	if (retval)
-		goto failed_1port_device_register;
-	retval = usb_serial_register(&sierra_3port_device);
+		return retval;
+	retval = usb_register(&sierra_driver);
 	if (retval)
-		goto failed_3port_device_register;
+		usb_serial_deregister(&sierra_device);
+	return retval;
+}
+
+static void __exit sierra_exit(void)
+{
+	usb_deregister (&sierra_driver);
+	usb_serial_deregister(&sierra_device);
+}
 
 
-	retval = usb_register(&sierra_driver);
-	if (retval)
-		goto failed_driver_register;
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+{
+	int result;	
+	struct usb_device *udev;
 
-	info(DRIVER_DESC ": " DRIVER_VERSION);
+	udev = usb_get_dev(interface_to_usbdev(iface));
 
-	return 0;
+	/*Set Device mode to D0 */
+	sierra_set_power_state(udev, 0x0000);
 
-failed_driver_register:
-	usb_serial_deregister(&sierra_3port_device);
-failed_3port_device_register:
-	usb_serial_deregister(&sierra_1port_device);
-failed_1port_device_register:
-	return retval;
+	/* Check if in installer mode */
+	if (id->driver_info == DEVICE_INSTALLER)
+	{
+		dbg("SWIMS: FOUND DEVICE(SW)\n");
+		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
+		dbg("SWIMS: swich result: %d\n",result);
+		return result;
+	}
+	/* Check if composite deviec */
+	else if (id->driver_info == DEVICE_1_PORT)
+	{
+		dbg("SWI: MODEM (Comp) FOUND");
+		sierra_device.num_ports = 1;
+		sierra_device.num_bulk_in = 1;
+		sierra_device.num_bulk_out = 1;
+	}
+	else /* Device default */
+	{
+		dbg("SWI: MODEM FOUND");
+		sierra_device.num_ports = DEF_NUM_PORTS;
+		sierra_device.num_bulk_in = DEF_NUM_PORTS;
+		sierra_device.num_bulk_out = DEF_NUM_PORTS;
+	}
+
+	return usb_serial_probe(iface, id);
 }
 
-static void __exit sierra_exit(void)
+int sierra_set_power_state(struct usb_device *udev, unsigned long swiState)
 {
-	usb_deregister (&sierra_driver);
-	usb_serial_deregister(&sierra_1port_device);
-	usb_serial_deregister(&sierra_3port_device);
+	int result;
+	dbg("SWI: POWER STATE");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			0x00,			/* __u8 request      */
+			0x40,			/* __u8 request type */
+			swiState,		/* __u16 value       */
+			0,			/* __u16 index       */
+			NULL,			/* void *data        */
+			0,			/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);	/* int timeout 	     */
+	return result;
+}
+
+int sierra_set_ms_mode(struct usb_device *udev, SWIMS_SET_MODE_VALUE eSocMode)
+{
+	int result;
+	dbg("SWIMS: MS SWITCH");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
+			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
+			eSocMode,			/* __u16 value       */
+			SWIMS_USB_INDEX_SetMode,	/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
+	return result;
 }
 
 module_init(sierra_init);
diff -uprN linux-2.6.22-rc4/drivers/usb/serial/sierra.h linux-2.6.22-rc4-swoc/drivers/usb/serial/sierra.h
--- linux-2.6.22-rc4/drivers/usb/serial/sierra.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22-rc4-swoc/drivers/usb/serial/sierra.h	2007-06-06 11:13:57.000000000 -0700
@@ -0,0 +1,25 @@
+#ifndef _SIERRA_MS_H
+#define _SIERRA_MS_H
+
+#define SWIMS_USB_REQUEST_SetMode	0x0B
+#define SWIMS_USB_REQUEST_TYPE_SetMode	0x40
+#define SWIMS_USB_INDEX_SetMode		0x0000
+#define SWIMS_SET_MODE_Modem		0x0001
+
+typedef __u16  SWIMS_SET_MODE_VALUE;
+
+enum devicetype {
+ DEVICE_3_PORT = 0,
+ DEVICE_1_PORT = 1,
+ DEVICE_INSTALLER = 2,
+};
+
+/* per port private data */
+#define N_IN_URB	4
+#define N_OUT_URB	4
+#define IN_BUFLEN	4096
+#define OUT_BUFLEN	1024
+
+#define DEF_NUM_PORTS 3
+
+#endif


