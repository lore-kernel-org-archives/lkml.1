Return-Path: <linux-kernel-owner+w=401wt.eu-S1764090AbXGPUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764090AbXGPUt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762560AbXGPUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:49:39 -0400
Received: from mail.sierrawireless.com ([204.50.29.40]:51922 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762188AbXGPUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:49:38 -0400
Message-ID: <469BD9D7.6070504@sierrawireless.com>
Date: Mon, 16 Jul 2007 13:49:27 -0700
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
CC: linux-kernel@vger.kernel.org, torvalds@osdl.org, linux@sierrawireless.com
Subject: [PATCH 01/02] USB: sierra: Add TRU-Install (c) Support [ATTEMPT 5]
References: <4696C9EF.9050406@sierrawireless.com>
In-Reply-To: <4696C9EF.9050406@sierrawireless.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2007 20:49:35.0183 (UTC) FILETIME=[D15805F0:01C7C7EA]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-5.0.1021-15296.001
X-TM-AS-Result: No--10.141600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch adds compatibility with Sierra Wireless' new TRU-Install feature. Future devices that use this feature will not work unless this patch has been applied.

This recent attempt fixes the return of the probe function so that the device does not bind when in "install mode."

This patch was tested on the 2.6.22-git6 driver.

There were previous submissions for similar support (6/6/2007 & 6/5/2007 & 7/11/2007 & 7/12/2007) they were however rejected so please disregard those.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>

--- 

diff -uprN a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c	2007-07-10 16:53:07.000000000 -0700
+++ b/drivers/usb/serial/sierra.c	2007-07-16 10:35:59.000000000 -0700
@@ -1,7 +1,7 @@
 /*
   USB Driver for Sierra Wireless
 
-  Copyright (C) 2006  Kevin Lloyd <linux@sierrawireless.com>
+  Copyright (C) 2007  Kevin Lloyd <linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
   Sierra Wireless. Use at your own risk.
@@ -12,10 +12,9 @@
 
   Portions based on the option driver by Matthias Urlichs <smurf@smurf.noris.de>
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
-
 */
 
-#define DRIVER_VERSION "v.1.0.6"
+#define DRIVER_VERSION "v.1.2.4b"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
@@ -28,6 +27,71 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#define SWIMS_USB_REQUEST_SetMode	0x0B
+#define SWIMS_USB_REQUEST_TYPE_SetMode	0x40
+#define SWIMS_USB_INDEX_SetMode		0x0000
+#define SWIMS_SET_MODE_Modem		0x0001
+
+/* per port private data */
+#define N_IN_URB	4
+#define N_OUT_URB	4
+#define IN_BUFLEN	4096
+
+static int debug;
+
+enum devicetype {
+	DEVICE_3_PORT =		0,
+	DEVICE_1_PORT =		1,
+	DEVICE_INSTALLER =	2,
+};
+
+int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
+{
+	int result;
+	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
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
+int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
+{
+	int result;
+	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
+			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
+			eSocMode,			/* __u16 value       */
+			SWIMS_USB_INDEX_SetMode,	/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
+	return result;
+}
+
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+{
+	int result;	
+	struct usb_device *udev;
+
+	udev = usb_get_dev(interface_to_usbdev(iface));
+
+	/* Check if in installer mode */
+	if (id->driver_info == DEVICE_INSTALLER){
+		dev_dbg(&udev->dev, "%s", "FOUND DEVICE(SW)\n");
+		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
+		/*We do not want to bind to the device when in installer mode*/
+		return -EIO;
+	}
+
+	return usb_serial_probe(iface, id);	
+}
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
@@ -43,8 +107,10 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
 
-	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
-	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
+	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
+	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+
+	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},	
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -56,6 +122,7 @@ static struct usb_device_id id_table_1po
 };
 
 static struct usb_device_id id_table_3port [] = {
+	/* CDMA Devices */
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
@@ -63,6 +130,8 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
+
+	/* GSM/UMTS Devices */
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
@@ -73,20 +142,13 @@ static struct usb_device_id id_table_3po
 
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
-	.probe      = usb_serial_probe,
+	.probe      = sierra_probe,
 	.disconnect = usb_serial_disconnect,
 	.id_table   = id_table,
 	.no_dynamic_id = 	1,
 };
 
 
-static int debug;
-
-/* per port private data */
-#define N_IN_URB	4
-#define N_OUT_URB	4
-#define IN_BUFLEN	4096
-
 struct sierra_port_private {
 	spinlock_t lock;	/* lock the structure */
 	int outstanding_urbs;	/* number of out urbs in flight */
@@ -421,8 +483,7 @@ static int sierra_open(struct usb_serial
 	int i;
 	struct urb *urb;
 	int result;
-	__u16 set_mode_dzero = 0x0000;
-
+	
 	portdata = usb_get_serial_port_data(port);
 
 	dbg("%s", __FUNCTION__);
@@ -457,12 +518,6 @@ static int sierra_open(struct usb_serial
 
 	port->tty->low_latency = 1;
 
-	/* set mode to D0 */
-	result = usb_control_msg(serial->dev,
-				 usb_rcvctrlpipe(serial->dev, 0),
-				 0x00, 0x40, set_mode_dzero, 0, NULL,
-				 0, USB_CTRL_SET_TIMEOUT);
-
 	sierra_send_setup(port);
 
 	/* start up the interrupt endpoint if we have one */
@@ -510,6 +565,9 @@ static int sierra_startup(struct usb_ser
 
 	dbg("%s", __FUNCTION__);
 
+	/*Set Device mode to D0 */
+	sierra_set_power_state(serial->dev, 0x0000);
+
 	/* Now setup per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
diff -uprN a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h	2007-07-10 16:57:52.000000000 -0700
+++ b/drivers/usb/storage/unusual_devs.h	2007-07-10 16:40:41.000000000 -0700
@@ -1384,6 +1384,17 @@ UNUSUAL_DEV(  0x1019, 0x0c55, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_ucr61s2b_init,
 		0 ),
 
+/* Reported by Kevin Lloyd <linux@sierrawireless.com>
+ * Entry is needed for the initializer function override, 
+ * which instructs the device to load as a modem
+ * device.
+ */
+UNUSUAL_DEV(  0x1199, 0x0fff, 0x0000, 0x9999,
+		"Sierra Wireless",
+		"USB MMC Storage",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, 
+		US_FL_IGNORE_DEVICE),
+
 /* Reported by Jaco Kroon <jaco@kroon.co.za>
  * The usb-storage module found on the Digitech GNX4 (and supposedly other
  * devices) misbehaves and causes a bunch of invalid I/O errors.


