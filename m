Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZDGAXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZDGAXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZDGAWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:22:51 -0400
Received: from carmd-sa01.sierrawireless.com ([208.81.121.45]:49776 "EHLO
	carmd-sa01.sierrawireless.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZDGAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:22:49 -0400
X-ASG-Debug-ID: 1239062783-5aa4000a0000-xx1T2L
X-Barracuda-URL: http://carmd-sa01.sierrawireless.com:80/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: epasheva@sierrawireless.com
X-ASG-Orig-Subj: [PATCH 002/003] USB: serial: sierra driver blacklisting
Subject: [PATCH 002/003] USB: serial: sierra driver blacklisting
From: Elina <epasheva@sierrawireless.com>
To: <gregkh@suse.de>
CC: <rfiler@sierrawireless.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Date: Mon, 6 Apr 2009 17:05:58 -0700
Message-ID: <1239062758.10120.37.camel@Linuxdev3>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: UNKNOWN[10.0.6.5]
X-Barracuda-Start-Time: 1239062783
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-Virus-Scanned: by CARMD-SA01 at sierrawireless.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 002/003] USB: serial: sierra driver blacklisting
From: Elina Pasheva <epasheva@sierrawireless.com>﻿

The series of 3 patches modify sierra usb serial driver with
blacklisting of specific non-serial interfaces, bug fixing and
performance improvements.
This is [PATCH 002/003]. This patch depends on [PATCH 001/003].
﻿The following is summary of changes we have made to sierra.c driver in
[PATCH 02/03] dealing with blacklisting:
﻿- Added blacklist for specific non-serial interfaces.
- Removed potential kernel oops from sierra_calc_num_ports() function.
Calling this function twice would likely have caused an oops because the
function releases allocated memory after the first call.
- Modified sierra_probe() function to reflect the changes in
sierra_calc_num_ports().
Signed-off-by: Elina Pasheva <epasheva@sierrawireless.com>
---

drivers/usb/serial/sierra.c |   83 ++++++++++++++++++++--------------
1 file changed, 51 insertions(+), 32 deletions(-)

--- a/drivers/usb/serial/sierra.c	2009-03-27 15:39:09.000000000 -0700
+++ b/drivers/usb/serial/sierra.c	2009-03-27 16:26:23.000000000 -0700
@@ -47,6 +47,12 @@
 static int debug;
 static int nmea;
 
+/* list of interface numbers - used for constructing interface blacklists */
+struct list {
+	const u32 listlen; /* number of interface numbers on list */
+	const u8  *list;   /* pointer to the array holding the numbers */
+};
+
 static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
@@ -79,18 +85,38 @@ static int sierra_vsc_set_nmea(struct us
 
 static int sierra_calc_num_ports(struct usb_serial *serial)
 {
-	int result;
-	int *num_ports = usb_get_serial_data(serial);
-	dev_dbg(&serial->dev->dev, "%s", __func__);
+	int num_ports = 0;
+	u8 ifnum, numendpoints;
 
-	result = *num_ports;
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
-	if (result) {
-		kfree(num_ports);
-		usb_set_serial_data(serial, NULL);
-	}
+	ifnum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
+	numendpoints = serial->interface->cur_altsetting->desc.bNumEndpoints;
 
-	return result;
+	/* Dummy interface present on some SKUs should be ignored */
+	if (ifnum == 0x99)
+		num_ports = 0;
+	else if (numendpoints <= 3)
+		num_ports = 1;
+	else
+		num_ports = (numendpoints-1)/2;
+	return num_ports;
+}
+
+static int is_blacklisted(const u8 ifnum, const struct list *blacklist)
+{
+	const u8  *list;
+	int i;
+
+	if (blacklist) {
+		list = blacklist->list;
+
+		for (i = 0; i < blacklist->listlen; i++) {
+			if (list[i] == ifnum)
+				return 1;
+		}
+	}
+	return 0;
 }
 
 static int sierra_calc_interface(struct usb_serial *serial)
@@ -119,23 +145,12 @@ static int sierra_probe(struct usb_seria
 {
 	int result = 0;
 	struct usb_device *udev;
-	int *num_ports;
 	u8 ifnum;
-	u8 numendpoints;
-
-	dev_dbg(&serial->dev->dev, "%s", __func__);
-
-	num_ports = kmalloc(sizeof(*num_ports), GFP_KERNEL);
-	if (!num_ports)
-		return -ENOMEM;
 
-	ifnum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
-	numendpoints = serial->interface->cur_altsetting->desc.bNumEndpoints;
 	udev = serial->dev;
 
 	/* Figure out the interface number from the serial structure */
 	ifnum = sierra_calc_interface(serial);
-
 	/*
 	 * If this interface supports more than 1 alternate
 	 * select the 2nd one
@@ -147,23 +162,24 @@ static int sierra_probe(struct usb_seria
 		usb_set_interface(udev, ifnum, 1);
 	}
 
-	/* Dummy interface present on some SKUs should be ignored */
-	if (ifnum == 0x99)
-		*num_ports = 0;
-	else if (numendpoints <= 3)
-		*num_ports = 1;
-	else
-		*num_ports = (numendpoints-1)/2;
+	/* ifnum could have changed - by calling usb_set_interface */
+	ifnum = sierra_calc_interface(serial);
 
-	/*
-	 * save off our num_ports info so that we can use it in the
-	 * calc_num_ports callback
-	 */
-	usb_set_serial_data(serial, (void *)num_ports);
+	if (is_blacklisted(ifnum, (struct list *)id->driver_info)) {
+		dev_dbg(&serial->dev->dev,
+			"Ignoring blacklisted interface #%d\n", ifnum);
+		return -ENODEV;
+	}
 
 	return result;
 }
 
+static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9 };
+static const struct list direct_ip_interface_blacklist = {
+	.listlen = ARRAY_SIZE(direct_ip_non_serial_ifaces),
+	.list = direct_ip_non_serial_ifaces,
+};
+
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
@@ -221,6 +237,9 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* Airprime/Sierra PC 5220 */
 
+	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
+		.driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, id_table);


