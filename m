Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYASOf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYASOf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbYASOfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:35:36 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:42084 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbYASOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:35:34 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 1/4] USB: OTG: Introduce new otg.c code
Date: Sat, 19 Jan 2008 16:37:22 +0200
Message-Id: <1200753446-9378-2-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
In-Reply-To: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates moves code from otg_whitelist.h to
otg.c in order to add support for configuring OTG
options during the runtime in following patches.

No functional changes, only clean-up whitespace on few
occasions.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/usb/core/Makefile        |    4 +
 drivers/usb/core/otg.c           |  120 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/otg_whitelist.h |  102 ++------------------------------
 3 files changed, 129 insertions(+), 97 deletions(-)
 create mode 100644 drivers/usb/core/otg.c

diff --git a/drivers/usb/core/Makefile b/drivers/usb/core/Makefile
index b607870..c2e51b6 100644
--- a/drivers/usb/core/Makefile
+++ b/drivers/usb/core/Makefile
@@ -6,6 +6,10 @@ usbcore-objs	:= usb.o hub.o hcd.o urb.o message.o driver.o \
 			config.o file.o buffer.o sysfs.o endpoint.o \
 			devio.o notify.o generic.o quirks.o
 
+ifeq ($(CONFIG_USB_OTG),y)
+	usbcore-objs	+= otg.o
+endif
+
 ifeq ($(CONFIG_PCI),y)
 	usbcore-objs	+= hcd-pci.o
 endif
diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
new file mode 100644
index 0000000..11967c0
--- /dev/null
+++ b/drivers/usb/core/otg.c
@@ -0,0 +1,120 @@
+/*
+ * drivers/usb/core/otg.c
+ *
+ * Copyright (C) 2004 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/byteorder/generic.h>
+#include <linux/gfp.h>
+#include <linux/usb.h>
+
+#include "otg_whitelist.h"
+
+#ifdef	CONFIG_USB_OTG_WHITELIST
+
+/*
+ * This OTG Whitelist is the OTG "Targeted Peripheral List".  It should
+ * mostly use of USB_DEVICE() or USB_DEVICE_VER() entries..
+ *
+ * YOU _SHOULD_ CHANGE THIS LIST TO MATCH YOUR PRODUCT AND ITS TESTING!
+ */
+
+static struct usb_device_id whitelist_table [] = {
+
+/* hubs are optional in OTG, but very handy ... */
+{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 0), },
+{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 1), },
+
+#ifdef	CONFIG_USB_PRINTER		/* ignoring nonstatic linkage! */
+/* FIXME actually, printers are NOT supposed to use device classes;
+ * they're supposed to use interface classes...
+ */
+{ USB_DEVICE_INFO(7, 1, 1) },
+{ USB_DEVICE_INFO(7, 1, 2) },
+{ USB_DEVICE_INFO(7, 1, 3) },
+#endif
+
+#ifdef	CONFIG_USB_NET_CDCETHER
+/* Linux-USB CDC Ethernet gadget */
+{ USB_DEVICE(0x0525, 0xa4a1), },
+/* Linux-USB CDC Ethernet + RNDIS gadget */
+{ USB_DEVICE(0x0525, 0xa4a2), },
+#endif
+
+#if	defined(CONFIG_USB_TEST) || defined(CONFIG_USB_TEST_MODULE)
+/* gadget zero, for testing */
+{ USB_DEVICE(0x0525, 0xa4a0), },
+#endif
+
+{ }	/* Terminating entry */
+};
+
+int is_targeted(struct usb_device *dev)
+{
+	struct usb_device_id	*id = whitelist_table;
+
+	/* possible in developer configs only! */
+	if (!dev->bus->otg_port)
+		return 1;
+
+	/* HNP test device is _never_ targeted (see OTG spec 6.6.6) */
+	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x1a0a &&
+	     le16_to_cpu(dev->descriptor.idProduct) == 0xbadd))
+		return 0;
+
+	/* NOTE: can't use usb_match_id() since interface caches
+	 * aren't set up yet. this is cut/paste from that code.
+	 */
+	for (id = whitelist_table; id->match_flags; id++) {
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_VENDOR) &&
+		    id->idVendor != le16_to_cpu(dev->descriptor.idVendor))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_PRODUCT) &&
+		    id->idProduct != le16_to_cpu(dev->descriptor.idProduct))
+			continue;
+
+		/* No need to test id->bcdDevice_lo != 0, since 0 is never
+		   greater than any unsigned number. */
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_LO) &&
+		    (id->bcdDevice_lo > le16_to_cpu(dev->descriptor.bcdDevice)))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_HI) &&
+		    (id->bcdDevice_hi < le16_to_cpu(dev->descriptor.bcdDevice)))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_CLASS) &&
+		    (id->bDeviceClass != dev->descriptor.bDeviceClass))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_SUBCLASS) &&
+		    (id->bDeviceSubClass!= dev->descriptor.bDeviceSubClass))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_PROTOCOL) &&
+		    (id->bDeviceProtocol != dev->descriptor.bDeviceProtocol))
+			continue;
+
+		return 1;
+	}
+
+	/* add other match criteria here ... */
+
+
+	/* OTG MESSAGE: report errors here, customize to match your product */
+	dev_err(&dev->dev, "device v%04x p%04x is not supported\n",
+		le16_to_cpu(dev->descriptor.idVendor),
+		le16_to_cpu(dev->descriptor.idProduct));
+
+	return 0;
+}
+
+#endif	/* CONFIG_USB_OTG_WHITELIST */
diff --git a/drivers/usb/core/otg_whitelist.h b/drivers/usb/core/otg_whitelist.h
index 7f31a49..d6b352e 100644
--- a/drivers/usb/core/otg_whitelist.h
+++ b/drivers/usb/core/otg_whitelist.h
@@ -9,104 +9,12 @@
  * (at your option) any later version.
  */
 
-/*
- * This OTG Whitelist is the OTG "Targeted Peripheral List".  It should
- * mostly use of USB_DEVICE() or USB_DEVICE_VER() entries..
- *
- * YOU _SHOULD_ CHANGE THIS LIST TO MATCH YOUR PRODUCT AND ITS TESTING!
- */ 
-
-static struct usb_device_id whitelist_table [] = {
-
-/* hubs are optional in OTG, but very handy ... */
-{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 0), },
-{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 1), },
-
-#ifdef	CONFIG_USB_PRINTER		/* ignoring nonstatic linkage! */
-/* FIXME actually, printers are NOT supposed to use device classes;
- * they're supposed to use interface classes...
- */
-{ USB_DEVICE_INFO(7, 1, 1) },
-{ USB_DEVICE_INFO(7, 1, 2) },
-{ USB_DEVICE_INFO(7, 1, 3) },
-#endif
-
-#ifdef	CONFIG_USB_NET_CDCETHER
-/* Linux-USB CDC Ethernet gadget */
-{ USB_DEVICE(0x0525, 0xa4a1), },
-/* Linux-USB CDC Ethernet + RNDIS gadget */
-{ USB_DEVICE(0x0525, 0xa4a2), },
-#endif
-
-#if	defined(CONFIG_USB_TEST) || defined(CONFIG_USB_TEST_MODULE)
-/* gadget zero, for testing */
-{ USB_DEVICE(0x0525, 0xa4a0), },
-#endif
-
-{ }	/* Terminating entry */
-};
-
-static int is_targeted(struct usb_device *dev)
-{
-	struct usb_device_id	*id = whitelist_table;
-
-	/* possible in developer configs only! */
-	if (!dev->bus->otg_port)
-		return 1;
-
-	/* HNP test device is _never_ targeted (see OTG spec 6.6.6) */
-	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x1a0a && 
-	     le16_to_cpu(dev->descriptor.idProduct) == 0xbadd))
-		return 0;
-
-	/* NOTE: can't use usb_match_id() since interface caches
-	 * aren't set up yet. this is cut/paste from that code.
-	 */
-	for (id = whitelist_table; id->match_flags; id++) {
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_VENDOR) &&
-		    id->idVendor != le16_to_cpu(dev->descriptor.idVendor))
-			continue;
-
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_PRODUCT) &&
-		    id->idProduct != le16_to_cpu(dev->descriptor.idProduct))
-			continue;
-
-		/* No need to test id->bcdDevice_lo != 0, since 0 is never
-		   greater than any unsigned number. */
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_LO) &&
-		    (id->bcdDevice_lo > le16_to_cpu(dev->descriptor.bcdDevice)))
-			continue;
-
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_HI) &&
-		    (id->bcdDevice_hi < le16_to_cpu(dev->descriptor.bcdDevice)))
-			continue;
-
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_CLASS) &&
-		    (id->bDeviceClass != dev->descriptor.bDeviceClass))
-			continue;
-
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_SUBCLASS) &&
-		    (id->bDeviceSubClass!= dev->descriptor.bDeviceSubClass))
-			continue;
-
-		if ((id->match_flags & USB_DEVICE_ID_MATCH_DEV_PROTOCOL) &&
-		    (id->bDeviceProtocol != dev->descriptor.bDeviceProtocol))
-			continue;
-
-		return 1;
-	}
-
-	/* add other match criteria here ... */
-
-
-	/* OTG MESSAGE: report errors here, customize to match your product */
-	dev_err(&dev->dev, "device v%04x p%04x is not supported\n",
-		le16_to_cpu(dev->descriptor.idVendor),
-		le16_to_cpu(dev->descriptor.idProduct));
 #ifdef	CONFIG_USB_OTG_WHITELIST
-	return 0;
+extern int is_targeted(struct usb_device *);
 #else
-	return 1;
-#endif
+static inline int is_targeted(struct usb_device *d)
+{
+	return 0;
 }
+#endif
 
-- 
1.5.4.rc3.24.gb53139

