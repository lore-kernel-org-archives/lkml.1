Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbYIDNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbYIDNAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbYIDM7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:59:55 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43578 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbYIDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:59:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/5] HID: remove hid-ff
Date: Thu,  4 Sep 2008 14:59:46 +0200
Message-Id: <1220533187-21848-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1220533187-21848-3-git-send-email-jirislaby@gmail.com>
References: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-2-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-3-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-ff.c now calls only pidff (generic driver), the special ones are now
in separate drivers. Invoke pidff on all non-special directly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/Kconfig    |   13 --------
 drivers/hid/usbhid/Makefile   |    3 --
 drivers/hid/usbhid/hid-core.c |    2 +-
 drivers/hid/usbhid/hid-ff.c   |   69 -----------------------------------------
 include/linux/hid.h           |    9 +-----
 5 files changed, 2 insertions(+), 94 deletions(-)
 delete mode 100644 drivers/hid/usbhid/hid-ff.c

diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 3cfc076..5d9aa95 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -24,21 +24,8 @@ config USB_HID
 comment "Input core support is needed for USB HID input layer or HIDBP support"
 	depends on USB_HID && INPUT=n
 
-config HID_FF
-	bool "Force feedback support (EXPERIMENTAL)"
-	depends on USB_HID && EXPERIMENTAL
-	help
-	  Say Y here is you want force feedback support for a few HID devices.
-	  See below for a list of supported devices.
-
-	  See <file:Documentation/input/ff.txt> for a description of the force
-	  feedback API.
-
-	  If unsure, say N.
-
 config HID_PID
 	bool "PID device support"
-	depends on HID_FF
 	help
 	  Say Y here if you have a PID-compliant device and wish to enable force
 	  feedback for it. Microsoft Sidewinder Force Feedback 2 is one of such
diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index 5c460fc..1329ecb 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -13,9 +13,6 @@ endif
 ifeq ($(CONFIG_HID_PID),y)
 	usbhid-objs	+= hid-pidff.o
 endif
-ifeq ($(CONFIG_HID_FF),y)
-	usbhid-objs	+= hid-ff.o
-endif
 
 obj-$(CONFIG_USB_HID)		+= usbhid.o
 obj-$(CONFIG_USB_KBD)		+= usbkbd.o
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5f32e30..d448e4d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -938,7 +938,7 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
 	hid->hid_output_raw_report = usbhid_output_raw_report;
-	hid->ff_init = hid_ff_init;
+	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
 	hid->hiddev_connect = hiddev_connect;
 	hid->hiddev_hid_event = hiddev_hid_event;
diff --git a/drivers/hid/usbhid/hid-ff.c b/drivers/hid/usbhid/hid-ff.c
deleted file mode 100644
index eca01a6..0000000
--- a/drivers/hid/usbhid/hid-ff.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- *  Force feedback support for hid devices.
- *  Not all hid devices use the same protocol. For example, some use PID,
- *  other use their own proprietary procotol.
- *
- *  Copyright (c) 2002-2004 Johann Deneux
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so by
- * e-mail - mail your message to <johann.deneux@it.uu.se>
- */
-
-#include <linux/input.h>
-
-#undef DEBUG
-#include <linux/usb.h>
-
-#include <linux/hid.h>
-#include "usbhid.h"
-
-/*
- * This table contains pointers to initializers. To add support for new
- * devices, you need to add the USB vendor and product ids here.
- */
-struct hid_ff_initializer {
-	u16 idVendor;
-	u16 idProduct;
-	int (*init)(struct hid_device*);
-};
-
-/*
- * We try pidff when no other driver is found because PID is the
- * standards compliant way of implementing force feedback in HID.
- * pidff_init() will quickly abort if the device doesn't appear to
- * be a PID device
- */
-static struct hid_ff_initializer inits[] = {
-	{ 0,	 0,	 hid_pidff_init}  /* Matches anything */
-};
-
-int hid_ff_init(struct hid_device* hid)
-{
-	struct hid_ff_initializer *init;
-	int vendor = le16_to_cpu(hid_to_usb_dev(hid)->descriptor.idVendor);
-	int product = le16_to_cpu(hid_to_usb_dev(hid)->descriptor.idProduct);
-
-	for (init = inits; init->idVendor; init++)
-		if (init->idVendor == vendor && init->idProduct == product)
-			break;
-
-	return init->init(hid);
-}
-EXPORT_SYMBOL_GPL(hid_ff_init);
-
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 6cf0357..eb1844c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -757,17 +757,10 @@ int usbhid_quirks_init(char **quirks_param);
 void usbhid_quirks_exit(void);
 void usbhid_set_leds(struct hid_device *hid);
 
-#ifdef CONFIG_HID_FF
-int hid_ff_init(struct hid_device *hid);
-
 #ifdef CONFIG_HID_PID
 int hid_pidff_init(struct hid_device *hid);
 #else
-static inline int hid_pidff_init(struct hid_device *hid) { return -ENODEV; }
-#endif
-
-#else
-#define hid_ff_init	NULL
+#define hid_pidff_init NULL
 #endif
 
 #ifdef CONFIG_HID_DEBUG
-- 
1.6.0

