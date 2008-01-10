Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbYAJT00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbYAJT00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYAJT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:26:14 -0500
Received: from mx1.sierrawireless.com ([208.81.121.7]:46569 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYAJT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:26:11 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 14:26:10 EST
Subject: [PATCH] usb-serial: Sierra driver - add devices and update dtr
From: Kevin Lloyd <klloyd@sierrawireless.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux@sierrawireless.com,
       linux-usb@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 11:11:04 -0800
Message-Id: <1199992265.9266.19.camel@linux-z60t>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 10 Jan 2008 19:10:55.0334 (UTC) FILETIME=[865E4060:01C853BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch is targeted for the 2.6.24-rc7 kernel.

The following improvements were made:
 - Added new product support: MC5725, AC 880 U, MP 3G (UMTS & CDMA)
 - Fixed control line issue where asserting DTR on ep5 would close ep2
 - Added support for calc_num_ports (will help support future composite devices)

This also covers the devices added by j@twu.net and agilmore@wirelessbeehive.com since their patches were not committed to the 2.6.23-rc7 kernel.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
---

--- /home/shared/kernels/linux-2.6.24-rc7-final/drivers/usb/serial/sierra.c.orig	2008-01-09 17:37:40.000000000 -0800
+++ /home/shared/kernels/linux-2.6.24-rc7-final/drivers/usb/serial/sierra.c	2008-01-10 11:08:57.000000000 -0800
@@ -1,7 +1,7 @@
 /*
   USB Driver for Sierra Wireless
 
-  Copyright (C) 2006, 2007  Kevin Lloyd <linux@sierrawireless.com>
+  Copyright (C) 2008  Kevin Lloyd <linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
   Sierra Wireless. Use at your own risk.
@@ -14,7 +14,7 @@
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
 */
 
-#define DRIVER_VERSION "v.1.2.5b"
+#define DRIVER_VERSION "v.1.2.7"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
@@ -26,10 +26,12 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/ch9.h>
 
+#define SWIMS_USB_REQUEST_SetPower	0x00
+#define SWIMS_USB_REQUEST_SetNmea	0x07
 #define SWIMS_USB_REQUEST_SetMode	0x0B
-#define SWIMS_USB_REQUEST_TYPE_SetMode	0x40
-#define SWIMS_USB_INDEX_SetMode		0x0000
+#define SWIMS_USB_REQUEST_TYPE_VSC_SET	0x40
 #define SWIMS_SET_MODE_Modem		0x0001
 
 /* per port private data */
@@ -38,6 +40,8 @@
 #define IN_BUFLEN	4096
 
 static int debug;
+static int nmea = 0;
+static int truinstall = 1;
 
 enum devicetype {
 	DEVICE_3_PORT =		0,
@@ -50,48 +54,90 @@ static int sierra_set_power_state(struct
 	int result;
 	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			0x00,			/* __u8 request      */
-			0x40,			/* __u8 request type */
-			swiState,		/* __u16 value       */
-			0,			/* __u16 index       */
-			NULL,			/* void *data        */
-			0,			/* __u16 size 	     */
-			USB_CTRL_SET_TIMEOUT);	/* int timeout 	     */
+			SWIMS_USB_REQUEST_SetPower,	/* __u8 request      */
+			SWIMS_USB_REQUEST_TYPE_VSC_SET,	/* __u8 request type */
+			swiState,			/* __u16 value       */
+			0,				/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout 	     */
 	return result;
 }
 
-static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
+static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSWocMode)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
-			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
-			eSocMode,			/* __u16 value       */
-			SWIMS_USB_INDEX_SetMode,	/* __u16 index       */
+			SWIMS_USB_REQUEST_TYPE_VSC_SET,	/* __u8 request type */
+			eSWocMode,			/* __u16 value       */
+			0x0000,				/* __u16 index       */
 			NULL,				/* void *data        */
 			0,				/* __u16 size 	     */
 			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
 	return result;
 }
 
-static int sierra_probe(struct usb_interface *iface,
-			const struct usb_device_id *id)
+int sierra_vsc_set_nmea(struct usb_device *udev, __u16 enable)
 {
 	int result;
+	dev_dbg(&udev->dev, "%s", "NMEA Enable sent");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetNmea,	/* __u8 request      */
+			SWIMS_USB_REQUEST_TYPE_VSC_SET,	/* __u8 request type */
+			enable,				/* __u16 value       */
+			0x0000,				/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
+	return result;
+}
+
+static int sierra_calc_num_ports(struct usb_serial *serial)
+{
+	int result;
+	int *num_ports = usb_get_serial_data(serial);
+
+	result = *num_ports;
+
+	if (result) {
+		kfree(num_ports);
+		usb_set_serial_data(serial, NULL);
+	}
+
+	return result;
+}
+
+static int sierra_probe(struct usb_serial *serial,
+	const struct usb_device_id *id)
+{
+	int result = 0;
 	struct usb_device *udev;
+	int *num_ports;
+	num_ports = kmalloc(sizeof(*num_ports), GFP_KERNEL);
 
-	udev = usb_get_dev(interface_to_usbdev(iface));
+	udev = serial->dev;
 
 	/* Check if in installer mode */
-	if (id->driver_info == DEVICE_INSTALLER) {
-		dev_dbg(&udev->dev, "%s", "FOUND DEVICE(SW)\n");
+	if (truinstall && id->driver_info == DEVICE_INSTALLER) {
+		dev_dbg(&udev->dev, "%s", "FOUND TRU-INSTALL DEVICE(SW)\n");
 		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
 		/*We do not want to bind to the device when in installer mode*/
 		return -EIO;
-	}
+	} else if (id->driver_info == DEVICE_1_PORT)
+		*num_ports = 1;
+	else if (serial->interface->cur_altsetting->desc.bInterfaceNumber == 0x99)
+		*num_ports = 0;
+	else
+		*num_ports = 3;
+	/*
+	 * save off our num_ports info so that we can use it in the
+	 * calc_num_ports callback
+	 */
+	usb_set_serial_data(serial, (void *)num_ports);
 
-	return usb_serial_probe(iface, id);
+	return result;
 }
 
 static struct usb_device_id id_table [] = {
@@ -100,9 +146,11 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
+	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -115,6 +163,11 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
+	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
+
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO */
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G - UMTS/HSPA */
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
@@ -124,45 +177,14 @@ static struct usb_device_id id_table [] 
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
-	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
-	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
-
-	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
-	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
-	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
-	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
-	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
-	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
-	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E */
-	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E */
-	{ }
-};
-
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
-	.probe      = sierra_probe,
+	.probe      = usb_serial_probe,
 	.disconnect = usb_serial_disconnect,
 	.id_table   = id_table,
 	.no_dynamic_id = 	1,
 };
 
-
 struct sierra_port_private {
 	spinlock_t lock;	/* lock the structure */
 	int outstanding_urbs;	/* number of out urbs in flight */
@@ -184,6 +206,7 @@ static int sierra_send_setup(struct usb_
 {
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
+	__u16 interface = 0;
 
 	dbg("%s", __FUNCTION__);
 
@@ -196,9 +219,18 @@ static int sierra_send_setup(struct usb_
 		if (portdata->rts_state)
 			val |= 0x02;
 
+		/* Determine which port is targeted */
+		if (port->bulk_out_endpointAddress == 2)
+			interface = 0;
+		else if (port->bulk_out_endpointAddress == 4)
+			interface = 1;
+		else if (port->bulk_out_endpointAddress == 5)
+			interface = 2;
+
 		return usb_control_msg(serial->dev,
 				usb_rcvctrlpipe(serial->dev, 0),
-				0x22,0x21,val,0,NULL,0,USB_CTRL_SET_TIMEOUT);
+				0x22, 0x21, val, interface,
+				NULL, 0, USB_CTRL_SET_TIMEOUT);
 	}
 
 	return 0;
@@ -582,6 +614,10 @@ static int sierra_startup(struct usb_ser
 	/*Set Device mode to D0 */
 	sierra_set_power_state(serial->dev, 0x0000);
 
+	/*Check NMEA and set */
+	if (nmea)
+		sierra_vsc_set_nmea(serial->dev, 1);
+
 	/* Now setup per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
@@ -642,47 +678,19 @@ static void sierra_shutdown(struct usb_s
 	}
 }
 
-static struct usb_serial_driver sierra_1port_device = {
+static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
 		.name =		"sierra1",
 	},
-	.description       = "Sierra USB modem (1 port)",
-	.id_table          = id_table_1port,
+	.description       = "Sierra USB modem",
+	.id_table          = id_table,
 	.usb_driver        = &sierra_driver,
 	.num_interrupt_in  = NUM_DONT_CARE,
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
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"sierra3",
-	},
-	.description       = "Sierra USB modem (3 port)",
-	.id_table          = id_table_3port,
-	.usb_driver        = &sierra_driver,
-	.num_interrupt_in  = NUM_DONT_CARE,
-	.num_bulk_in       = 3,
-	.num_bulk_out      = 3,
-	.num_ports         = 3,
+	.num_bulk_in       = NUM_DONT_CARE,
+	.num_bulk_out      = NUM_DONT_CARE,
+	.calc_num_ports	   = sierra_calc_num_ports,
+	.probe		   = sierra_probe,
 	.open              = sierra_open,
 	.close             = sierra_close,
 	.write             = sierra_write,
@@ -704,12 +712,9 @@ static struct usb_serial_driver sierra_3
 static int __init sierra_init(void)
 {
 	int retval;
-	retval = usb_serial_register(&sierra_1port_device);
-	if (retval)
-		goto failed_1port_device_register;
-	retval = usb_serial_register(&sierra_3port_device);
+	retval = usb_serial_register(&sierra_device);
 	if (retval)
-		goto failed_3port_device_register;
+		goto failed_device_register;
 
 
 	retval = usb_register(&sierra_driver);
@@ -721,18 +726,15 @@ static int __init sierra_init(void)
 	return 0;
 
 failed_driver_register:
-	usb_serial_deregister(&sierra_3port_device);
-failed_3port_device_register:
-	usb_serial_deregister(&sierra_1port_device);
-failed_1port_device_register:
+	usb_serial_deregister(&sierra_device);
+failed_device_register:
 	return retval;
 }
 
 static void __exit sierra_exit(void)
 {
 	usb_deregister (&sierra_driver);
-	usb_serial_deregister(&sierra_1port_device);
-	usb_serial_deregister(&sierra_3port_device);
+	usb_serial_deregister(&sierra_device);
 }
 
 module_init(sierra_init);
@@ -743,6 +745,12 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
+module_param(truinstall, bool, 0);
+MODULE_PARM_DESC(truinstall, "TRU-Install support");
+
+module_param(nmea, bool, 0);
+MODULE_PARM_DESC(nmea, "NMEA streaming");
+
 #ifdef CONFIG_USB_DEBUG
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug messages");
