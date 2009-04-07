Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZDGAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZDGAXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDGAWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:22:50 -0400
Received: from carmd-sa01.sierrawireless.com ([208.81.121.45]:49775 "EHLO
	carmd-sa01.sierrawireless.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbZDGAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:22:49 -0400
X-Greylist: delayed 987 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 20:22:49 EDT
X-ASG-Debug-ID: 1239062779-5aa3000a0000-xx1T2L
X-Barracuda-URL: http://carmd-sa01.sierrawireless.com:80/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: epasheva@sierrawireless.com
X-ASG-Orig-Subj: [PATCH 001/003] USB: serial: sierra driver performance improvements
Subject: [PATCH 001/003] USB: serial: sierra driver performance improvements
From: Elina <epasheva@sierrawireless.com>
To: <gregkh@suse.de>
CC: <rfiler@sierrawireless.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Date: Mon, 6 Apr 2009 17:05:54 -0700
Message-ID: <1239062754.10120.36.camel@Linuxdev3>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: UNKNOWN[10.0.6.5]
X-Barracuda-Start-Time: 1239062779
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-Virus-Scanned: by CARMD-SA01 at sierrawireless.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 001/003] USB: serial: sierra driver performance
improvements
From: Elina Pasheva <epasheva@sierrawireless.com>

The series of 3 patches modify sierra usb serial driver with
﻿performance improvements, blacklisting of specific non-serial 
interfaces and bug fixing. 
﻿The following is summary of changes we have made to sierra.c driver in
[PATCH 001/003] dealing with performance improvements:
﻿- Updated Copyright notice with new authors names
﻿- Version number set to 1.6.0
- Increased the number of input/output URBs for improved performance
(numbers based on an measurement study triggered by a user request).
﻿- Removed “no_dynamic_id=1” setting. Removing this setting will allow
customers to add support for new modems via a system call (i.e. adding
unrecognized PIDs) instead of having to download and build/install the
driver for the new modem
- Added sierra_suspend(), sierra_resume() functions
- Added a MAX_TRANSFER constant following Greg Kroah-Hartman's
recommended setting of PAGE_SIZE-512 for USB transfer buffers
Signed-off-by: Elina Pasheva <epasheva@sierrawireless.com>
---

 drivers/usb/serial/sierra.c |   84 +++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 27 deletions(-)

--- a/drivers/usb/serial/sierra.c	2009-03-25 11:05:45.000000000 -0700
+++ b/drivers/usb/serial/sierra.c	2009-03-27 15:39:09.000000000 -0700
@@ -1,7 +1,10 @@
 /*
   USB Driver for Sierra Wireless
 
-  Copyright (C) 2006, 2007, 2008  Kevin Lloyd <klloyd@sierrawireless.com>
+  Copyright (C) 2006, 2007, 2008  Kevin Lloyd <klloyd@sierrawireless.com>,
+
+  Copyright (C) 2008, 2009  Elina Pasheva, Matthew Safar, Rory Filer
+				<linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
   Sierra Wireless. Use at your own risk.
@@ -13,9 +16,10 @@
   Portions based on the option driver by Matthias Urlichs <smurf@smurf.noris.de>
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
 */
-
-#define DRIVER_VERSION "v.1.3.2"
-#define DRIVER_AUTHOR "Kevin Lloyd <klloyd@sierrawireless.com>"
+/* Uncomment to log function calls */
+/*#define DEBUG*/
+#define DRIVER_VERSION "v.1.6.0"
+#define DRIVER_AUTHOR "Kevin Lloyd, Elina Pasheva, Matthew Safar, Rory Filer"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
 #include <linux/kernel.h>
@@ -26,16 +30,20 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <linux/usb/ch9.h>
 
 #define SWIMS_USB_REQUEST_SetPower	0x00
 #define SWIMS_USB_REQUEST_SetNmea	0x07
 
 /* per port private data */
-#define N_IN_URB	4
-#define N_OUT_URB	4
+#define N_IN_URB	8
+#define N_OUT_URB	64
 #define IN_BUFLEN	4096
 
+#define MAX_TRANSFER		(PAGE_SIZE - 512)
+/* MAX_TRANSFER is chosen so that the VM is not stressed by
+   allocations > PAGE_SIZE and the number of packets in a page
+   is an integer 512 is the largest possible packet on EHCI */
+
 static int debug;
 static int nmea;
 
@@ -188,9 +196,11 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781 */
 	{ USB_DEVICE(0x1199, 0x683A) },	/* Sierra Wireless MC8785 */
 	{ USB_DEVICE(0x1199, 0x683B) },	/* Sierra Wireless MC8785 Composite */
-	{ USB_DEVICE(0x1199, 0x683C) },	/* Sierra Wireless MC8790 */
-	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8790 */
-	{ USB_DEVICE(0x1199, 0x683E) },	/* Sierra Wireless MC8790 */
+	/* Sierra Wireless MC8790, MC8791, MC8792 Composite */
+	{ USB_DEVICE(0x1199, 0x683C) },
+	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8791 Composite */
+	/* Sierra Wireless MC8790, MC8791, MC8792 */
+	{ USB_DEVICE(0x1199, 0x683E) },
 	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
@@ -215,12 +225,27 @@ static struct usb_device_id id_table [] 
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
+int sierra_suspend(struct usb_serial *serial, pm_message_t message)
+{
+	printk(KERN_ERR "################################%s\n", __func__);
+
+	return 0;
+}
+
+int sierra_resume(struct usb_serial *serial)
+{
+	printk(KERN_ERR "################################%s\n", __func__);
+
+	return 0;
+}
+
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
 	.probe      = usb_serial_probe,
 	.disconnect = usb_serial_disconnect,
+	.suspend =	usb_serial_suspend,
+	.resume =	usb_serial_resume,
 	.id_table   = id_table,
-	.no_dynamic_id = 	1,
 };
 
 struct sierra_port_private {
@@ -360,7 +385,12 @@ static int sierra_write(struct tty_struc
 	unsigned long flags;
 	unsigned char *buffer;
 	struct urb *urb;
-	int status;
+	size_t writesize = min((size_t)count, (size_t)MAX_TRANSFER);
+	int retval = 0;
+
+	/* verify that we actually have some data to write */
+	if (count == 0)
+		return 0;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -375,35 +405,34 @@ static int sierra_write(struct tty_struc
 	portdata->outstanding_urbs++;
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
-	buffer = kmalloc(count, GFP_ATOMIC);
+	buffer = kmalloc(writesize, GFP_ATOMIC);
 	if (!buffer) {
 		dev_err(&port->dev, "out of memory\n");
-		count = -ENOMEM;
+		retval = -ENOMEM;
 		goto error_no_buffer;
 	}
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		dev_err(&port->dev, "no more free urbs\n");
-		count = -ENOMEM;
+		retval = -ENOMEM;
 		goto error_no_urb;
 	}
 
-	memcpy(buffer, buf, count);
+	memcpy(buffer, buf, writesize);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, count, buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, writesize, buffer);
 
 	usb_fill_bulk_urb(urb, serial->dev,
 			  usb_sndbulkpipe(serial->dev,
 					  port->bulk_out_endpointAddress),
-			  buffer, count, sierra_outdat_callback, port);
+			  buffer, writesize, sierra_outdat_callback, port);
 
 	/* send it down the pipe */
-	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status) {
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (retval) {
 		dev_err(&port->dev, "%s - usb_submit_urb(write bulk) failed "
-			"with status = %d\n", __func__, status);
-		count = status;
+			"with status = %d\n", __func__, retval);
 		goto error;
 	}
 
@@ -411,7 +440,7 @@ static int sierra_write(struct tty_struc
 	 * really free it when it is finished with it */
 	usb_free_urb(urb);
 
-	return count;
+	return writesize;
 error:
 	usb_free_urb(urb);
 error_no_urb:
@@ -420,7 +449,7 @@ error_no_buffer:
 	spin_lock_irqsave(&portdata->lock, flags);
 	--portdata->outstanding_urbs;
 	spin_unlock_irqrestore(&portdata->lock, flags);
-	return count;
+	return retval;
 }
 
 static void sierra_indat_callback(struct urb *urb)
@@ -735,6 +764,8 @@ static struct usb_serial_driver sierra_d
 	.attach            = sierra_startup,
 	.shutdown          = sierra_shutdown,
 	.read_int_callback = sierra_instat_callback,
+	.suspend =	sierra_suspend,
+	.resume =	sierra_resume,
 };
 
 /* Functions used by new usb-serial code. */
@@ -750,9 +781,7 @@ static int __init sierra_init(void)
 	if (retval)
 		goto failed_driver_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
-
+	printk(KERN_ERR "################################%s\n", __func__);
 	return 0;
 
 failed_driver_register:
@@ -763,6 +792,7 @@ failed_device_register:
 
 static void __exit sierra_exit(void)
 {
+	printk(KERN_ERR "################################%s\n", __func__);
 	usb_deregister(&sierra_driver);
 	usb_serial_deregister(&sierra_device);
 }


