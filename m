Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXENV7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXENV7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbXENV6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:58:43 -0400
Received: from mail.sierrawireless.com ([204.50.29.40]:59272 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbXENV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:58:42 -0400
X-Greylist: delayed 852 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 17:58:42 EDT
Message-ID: <4648D851.2030500@sierrawireless.com>
Date: Mon, 14 May 2007 14:44:49 -0700
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: gregkh@suse.de, mdharm-usb@one-eyed-alien.net
CC: linux-usb-users@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: [PATCH] usb-storage: Add support for unusual device by Sierra Wireless
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2007 21:45:44.0720 (UTC) FILETIME=[39B85100:01C79671]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-3.6.1039-15170.001
X-TM-AS-Result: No--10.804800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch is targeted for the 2.6.21.1 kernel source. It adds support
for Sierra Wireless devices with auto-install support to the 
unusual_devices list of the usb-mass storage driver. This requires 
changes to Kconfig, Makefile, usb.c, unusual_devs.h, and the addition 
of sierra_ms.h & sierra_ms.c.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
---
diff -uprN linux-2.6.21.1/drivers/usb/storage/Kconfig linux-2.6.21.1.swoc/drivers/usb/storage/Kconfig
--- linux-2.6.21.1/drivers/usb/storage/Kconfig	2007-04-27 14:49:26.000000000 -0700
+++ linux-2.6.21.1.swoc/drivers/usb/storage/Kconfig	2007-05-14 13:56:41.000000000 -0700
@@ -105,6 +105,13 @@ config USB_STORAGE_SDDR55
 	  Say Y here to include additional code to support the Sandisk SDDR-55
 	  SmartMedia reader in the USB Mass Storage driver.
 
+config USB_STORAGE_SIERRA
+	bool "Sierra Wireless Modem Support"
+	depends on USB_STORAGE
+	help
+	  Say Y here in order to support new Sierra Wireless devices with the
+          auto install feature.
+	  
 config USB_STORAGE_JUMPSHOT
 	bool "Lexar Jumpshot Compact Flash Reader (EXPERIMENTAL)"
 	depends on USB_STORAGE && EXPERIMENTAL
diff -uprN linux-2.6.21.1/drivers/usb/storage/Makefile linux-2.6.21.1.swoc/drivers/usb/storage/Makefile
--- linux-2.6.21.1/drivers/usb/storage/Makefile	2007-04-27 14:49:26.000000000 -0700
+++ linux-2.6.21.1.swoc/drivers/usb/storage/Makefile	2007-05-11 15:56:44.000000000 -0700
@@ -21,6 +21,7 @@ usb-storage-obj-$(CONFIG_USB_STORAGE_JUM
 usb-storage-obj-$(CONFIG_USB_STORAGE_ALAUDA)	+= alauda.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_ONETOUCH)	+= onetouch.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_KARMA)	+= karma.o
+usb-storage-obj-$(CONFIG_USB_STORAGE_SIERRA)	+= sierra_ms.o
 
 usb-storage-objs :=	scsiglue.o protocol.o transport.o usb.o \
 			initializers.o $(usb-storage-obj-y)
diff -uprN linux-2.6.21.1/drivers/usb/storage/sierra_ms.c linux-2.6.21.1.swoc/drivers/usb/storage/sierra_ms.c
--- linux-2.6.21.1/drivers/usb/storage/sierra_ms.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21.1.swoc/drivers/usb/storage/sierra_ms.c	2007-05-14 13:55:38.000000000 -0700
@@ -0,0 +1,82 @@
+/* Driver for Sierra Wireless devices with auto-install support
+ *
+ * First release
+ *
+ * Current development and maintenance by:
+ *   (C) 2007 Kevin Lloyd <linux@sierrawireless.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+#include "usb.h"
+#include "transport.h"
+#include "protocol.h"
+#include "scsiglue.h"
+#include "debug.h"
+#include "sierra_ms.h"
+
+
+int sierra_ms_init(struct us_data *us)
+{
+	int retval, retries;
+	signed long delay_t;
+	US_DEBUGP("sierra_ms: sierra_ms_init called\n");
+	
+	delay_t = 2;
+	retries = 3;
+	while (retries)
+	{
+		schedule_timeout_uninterruptible(delay_t*HZ);
+		retval = sierra_ms_change_mode(us, SWIMS_SET_MODE_Modem);
+		if (retval == -ETIMEDOUT || retval == -ETIME) {
+			US_DEBUGP("sierra_ms: Command timed out.\n");
+			retries--;
+		}
+		else if (retval < 0) {
+			/* something prevented us from registering this driver */
+			err("sierra_ms: Error sending change mode command (%d).\n", retval);
+			retries--;
+		}
+		else
+			retries=0;
+	}
+	return retval;
+}
+
+int sierra_ms_change_mode(struct us_data *us, SWIMS_SET_MODE_VALUE
+		eSocMode)
+{
+	int result;
+	unsigned char *blankArray;
+	blankArray = kmalloc(0, GFP_KERNEL);
+
+	US_DEBUGP("sierra_ms: attempting to change modes.\n");
+
+	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
+				SWIMS_USB_REQUEST_SetMode,
+				SWIMS_USB_REQUEST_TYPE_SetMode,
+				eSocMode,
+				SWIMS_USB_INDEX_SetMode,
+				blankArray,
+				0,
+				5*HZ);
+
+	return result;
+}
+
diff -uprN linux-2.6.21.1/drivers/usb/storage/sierra_ms.h linux-2.6.21.1.swoc/drivers/usb/storage/sierra_ms.h
--- linux-2.6.21.1/drivers/usb/storage/sierra_ms.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21.1.swoc/drivers/usb/storage/sierra_ms.h	2007-05-14 13:55:45.000000000 -0700
@@ -0,0 +1,41 @@
+/* Header File for Sierra Wireless auto-install driver
+ *
+ * First release
+ *
+ * Current development and maintenance by:
+ *   (c) 2000 In-System Design, Inc. (support@in-system.com)
+ *
+ * See sierra_ms.c for more information.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef _SIERRA_MS_H
+#define _SIERRA_MS_H
+
+#define USB_sierra_ms_VENDOR_ID		0x1199
+#define USB_sierra_ms_PRODUCT_ID	0x0fff
+
+#define SWIMS_USB_REQUEST_SetMode	0x0B
+#define SWIMS_USB_REQUEST_TYPE_SetMode	0x40
+#define SWIMS_USB_INDEX_SetMode		0x0000
+#define SWIMS_SET_MODE_Modem		0x0001
+
+typedef __u16  SWIMS_SET_MODE_VALUE;
+
+extern int sierra_ms_init(struct us_data *us);
+int sierra_ms_change_mode(struct us_data *us, SWIMS_SET_MODE_VALUE eSocMode);
+
+#endif
diff -uprN linux-2.6.21.1/drivers/usb/storage/unusual_devs.h linux-2.6.21.1.swoc/drivers/usb/storage/unusual_devs.h
--- linux-2.6.21.1/drivers/usb/storage/unusual_devs.h	2007-04-27 14:49:26.000000000 -0700
+++ linux-2.6.21.1.swoc/drivers/usb/storage/unusual_devs.h	2007-05-11 15:56:44.000000000 -0700
@@ -1361,6 +1361,17 @@ UNUSUAL_DEV(  0x1019, 0x0c55, 0x0000, 0x
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
+		US_SC_DEVICE, US_PR_DEVICE, sierra_ms_init, 
+		0),
+
 /* Reported by Jaco Kroon <jaco@kroon.co.za>
  * The usb-storage module found on the Digitech GNX4 (and supposedly other
  * devices) misbehaves and causes a bunch of invalid I/O errors.
diff -uprN linux-2.6.21.1/drivers/usb/storage/usb.c linux-2.6.21.1.swoc/drivers/usb/storage/usb.c
--- linux-2.6.21.1/drivers/usb/storage/usb.c	2007-04-27 14:49:26.000000000 -0700
+++ linux-2.6.21.1.swoc/drivers/usb/storage/usb.c	2007-05-11 15:56:44.000000000 -0700
@@ -101,6 +101,10 @@
 #ifdef CONFIG_USB_STORAGE_KARMA
 #include "karma.h"
 #endif
+#ifdef CONFIG_USB_STORAGE_SIERRA
+#include "sierra_ms.h"
+#endif
+
 
 /* Some informational data */
 MODULE_AUTHOR("Matthew Dharm <mdharm-usb@one-eyed-alien.net>");


