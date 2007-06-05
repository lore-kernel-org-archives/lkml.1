Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXFEVbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXFEVbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbXFEVbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:31:23 -0400
Received: from mx1.sierrawireless.com ([204.50.29.40]:11185 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbXFEVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:31:21 -0400
Message-ID: <4665D518.8020508@sierrawireless.com>
Date: Tue, 05 Jun 2007 14:26:48 -0700
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       torvalds@osdl.org
Subject: [PATCH 2.6.21.3] USB: add support for TRU-install and new VID/PIDs
 to Sierra Wireless driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2007 21:33:00.0381 (UTC) FILETIME=[1739F0D0:01C7A7B9]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-3.6.1039-15218.002
X-TM-AS-Result: No--4.668200-5.000000-3
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch is derived from the 2.6.21.3 kernel source and adds support for the new TRU-install
feature (without this support new devices will not work), and add new UMTS device VID/PIDs.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
---

diff -uprN linux-2.6.21.3.orig/drivers/usb/serial/sierra.c linux-2.6.21.3.swoc/drivers/usb/serial/sierra.c
--- linux-2.6.21.3.orig/drivers/usb/serial/sierra.c	2007-05-24 14:22:47.000000000 -0700
+++ linux-2.6.21.3.swoc/drivers/usb/serial/sierra.c	2007-06-05 13:29:49.000000000 -0700
@@ -15,9 +15,9 @@
 
 */
 
-#define DRIVER_VERSION "v.1.0.6"
+#define DRIVER_VERSION "v.1.2.2"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
-#define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
+#define DRIVER_DESC "USB Driver for Sierra Wireless modems"
 
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -28,64 +28,53 @@
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
@@ -116,6 +105,7 @@ static int sierra_send_setup(struct usb_
 
 	if (port->tty) {
 		int val = 0;
+
 		if (portdata->dtr_state)
 			val |= 0x01;
 		if (portdata->rts_state)
@@ -145,8 +135,7 @@ static void sierra_break_ctl(struct usb_
 	dbg("%s", __FUNCTION__);
 }
 
-static void sierra_set_termios(struct usb_serial_port *port,
-			struct ktermios *old_termios)
+static void sierra_set_termios(struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	dbg("%s", __FUNCTION__);
 
@@ -397,8 +386,6 @@ static int sierra_open(struct usb_serial
 	struct usb_serial *serial = port->serial;
 	int i, err;
 	struct urb *urb;
-	int result;
-	__u16 set_mode_dzero = 0x0000;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -445,12 +432,6 @@ static int sierra_open(struct usb_serial
 
 	port->tty->low_latency = 1;
 
-	/* set mode to D0 */
-	result = usb_control_msg(serial->dev,
-				 usb_rcvctrlpipe(serial->dev, 0),
-				 0x00, 0x40, set_mode_dzero, 0, NULL,
-				 0, USB_CTRL_SET_TIMEOUT);
-
 	sierra_send_setup(port);
 
 	return (0);
@@ -461,7 +442,6 @@ static inline void stop_urb(struct urb *
 	if (urb && urb->status == -EINPROGRESS)
 		usb_kill_urb(urb);
 }
-
 static void sierra_close(struct usb_serial_port *port, struct file *filp)
 {
 	int i;
@@ -583,17 +563,26 @@ static void sierra_shutdown(struct usb_s
 	/* Stop reading/writing urbs */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
+
 		for (j = 0; j < N_IN_URB; j++)
-			stop_urb(portdata->in_urbs[j]);
+			usb_unlink_urb(portdata->in_urbs[j]);
 		for (j = 0; j < N_OUT_URB; j++)
-			stop_urb(portdata->out_urbs[j]);
+			usb_unlink_urb(portdata->out_urbs[j]);
 	}
 
 	/* Now free them */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 
 		for (j = 0; j < N_IN_URB; j++) {
 			if (portdata->in_urbs[j]) {
@@ -612,51 +601,24 @@ static void sierra_shutdown(struct usb_s
 	/* Now free per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		kfree(usb_get_serial_port_data(port));
 	}
 }
 
-static struct usb_serial_driver sierra_1port_device = {
+static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
-		.name =		"sierra1",
+		.name =		"sierra",
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
+	.num_bulk_in       = DEF_NUM_PORTS,
+	.num_bulk_out      = DEF_NUM_PORTS,
+	.num_ports         = DEF_NUM_PORTS,
 	.open              = sierra_open,
 	.close             = sierra_close,
 	.write             = sierra_write,
@@ -678,35 +640,89 @@ static struct usb_serial_driver sierra_3
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
 
+static void __exit sierra_exit(void)
+{
+	usb_deregister (&sierra_driver);
+	usb_serial_deregister(&sierra_device);
+}
 
-	retval = usb_register(&sierra_driver);
-	if (retval)
-		goto failed_driver_register;
 
-	info(DRIVER_DESC ": " DRIVER_VERSION);
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+{
+	int result;	
+	struct usb_device *udev;
+
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
diff -uprN linux-2.6.21.3.orig/drivers/usb/serial/sierra.h linux-2.6.21.3.swoc/drivers/usb/serial/sierra.h
--- linux-2.6.21.3.orig/drivers/usb/serial/sierra.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21.3.swoc/drivers/usb/serial/sierra.h	2007-06-05 12:32:20.000000000 -0700
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


