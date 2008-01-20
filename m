Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYATSqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYATSqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYATSp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:45:58 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:60764 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbYATSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:45:54 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH] USB: OTG: Start using new otg tpl.
Date: Sun, 20 Jan 2008 20:47:46 +0200
Message-Id: <1200854866-14074-2-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
In-Reply-To: <1200854866-14074-1-git-send-email-me@felipebalbi.com>
References: <1200854866-14074-1-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces otg_set_error and start using it when we
want to show otg_errors.

Based on previous patch from Tony Lindgren <tony@atomide.com>

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/usb/core/hub.c           |   21 ++++---
 drivers/usb/core/otg.c           |  127 ++++++++++++++++++++++++++++++++-----
 drivers/usb/core/otg_whitelist.h |   20 ------
 drivers/usb/core/sysfs.c         |  131 ++++++++++++++++++++++++++++++++++++++
 include/linux/usb/otg.h          |   19 ++++++
 5 files changed, 273 insertions(+), 45 deletions(-)
 delete mode 100644 drivers/usb/core/otg_whitelist.h

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b04d232..4737b38 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -23,6 +23,8 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 
+#include <linux/usb/otg.h>
+
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1220,11 +1222,6 @@ static inline void show_string(struct usb_device *udev, char *id, char *string)
 {}
 #endif
 
-
-#ifdef	CONFIG_USB_OTG
-#include "otg_whitelist.h"
-#endif
-
 /**
  * usb_configure_device_otg - FIXME (usbcore-internal)
  * @udev: newly addressed device (in ADDRESS state)
@@ -1234,6 +1231,7 @@ static inline void show_string(struct usb_device *udev, char *id, char *string)
 static int usb_configure_device_otg(struct usb_device *udev)
 {
 	int err = 0;
+	int tpl_enabled = 0;
 
 #ifdef	CONFIG_USB_OTG
 	/*
@@ -1252,6 +1250,7 @@ static int usb_configure_device_otg(struct usb_device *udev)
 					le16_to_cpu(udev->config[0].desc.wTotalLength),
 					USB_DT_OTG, (void **) &desc) == 0) {
 			if (desc->bmAttributes & USB_OTG_HNP) {
+				struct otg_transceiver	*xceiv = otg_get_transceiver();
 				unsigned		port1 = udev->portnum;
 
 				dev_info(&udev->dev,
@@ -1270,19 +1269,23 @@ static int usb_configure_device_otg(struct usb_device *udev)
 						: USB_DEVICE_A_ALT_HNP_SUPPORT,
 					0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 				if (err < 0) {
-					/* OTG MESSAGE: report errors here,
-					 * customize to match your product.
-					 */
+					otg_set_error(xceiv,
+						OTG_ERR_DEVICE_NOT_RESPONDING);
 					dev_info(&udev->dev,
 						"can't set HNP mode; %d\n",
 						err);
 					bus->b_hnp_enable = 0;
 				}
+				tpl_enabled = xceiv->tpl_enabled;
+				put_device(xceiv->dev);
 			}
 		}
 	}
 
-	if (!is_targeted(udev)) {
+	if (err == 0)
+		err = otg_targeted(udev);
+
+	if (err != OTG_ERR_DEVICE_SUPPORTED && tpl_enabled) {
 
 		/* Maybe it can talk to us, though we can't talk to it.
 		 * (Includes HNP test device.)
diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
index 531afa6..e9ece31 100644
--- a/drivers/usb/core/otg.c
+++ b/drivers/usb/core/otg.c
@@ -2,6 +2,7 @@
  * drivers/usb/core/otg.c
  *
  * Copyright (C) 2004 Texas Instruments
+ * Copyright (C) 2007-2008 Nokia Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -9,15 +10,10 @@
  * (at your option) any later version.
  */
 
-#include <linux/device.h>
-#include <linux/mod_devicetable.h>
-#include <linux/byteorder/generic.h>
-#include <linux/gfp.h>
+#include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
 
-#include "otg_whitelist.h"
-
 static struct otg_transceiver *xceiv;
 
 int otg_set_transceiver(struct otg_transceiver *x)
@@ -37,6 +33,22 @@ struct otg_transceiver *otg_get_transceiver(void)
 }
 EXPORT_SYMBOL(otg_get_transceiver);
 
+/* OTG MESSAGE: report errors here, customize to match your product */
+void otg_set_error(struct otg_transceiver *x, enum usb_otg_error errno)
+{
+	if (!x)
+		return;
+	if (!x->tpl_enabled)
+		x->last_error = OTG_ERR_DEVICE_SUPPORTED;
+	else
+		x->last_error = errno;
+
+	sysfs_notify(&x->host->root_hub->dev.kobj, NULL, "otg_last_error");
+}
+EXPORT_SYMBOL(otg_set_error);
+
+/*-------------------------------------------------------------------------*/
+
 #ifdef	CONFIG_USB_OTG_WHITELIST
 
 /*
@@ -46,7 +58,7 @@ EXPORT_SYMBOL(otg_get_transceiver);
  * YOU _SHOULD_ CHANGE THIS LIST TO MATCH YOUR PRODUCT AND ITS TESTING!
  */
 
-static struct usb_device_id whitelist_table [] = {
+static struct usb_device_id whitelist_table [] __initdata = {
 
 /* hubs are optional in OTG, but very handy ... */
 { USB_DEVICE_INFO(USB_CLASS_HUB, 0, 0), },
@@ -76,23 +88,74 @@ static struct usb_device_id whitelist_table [] = {
 { }	/* Terminating entry */
 };
 
-int is_targeted(struct usb_device *dev)
+struct otg_device {
+	struct list_head	list;
+	struct usb_device_id	id;
+};
+
+static struct list_head	tpl_devices;
+
+static void tpl_add_device(struct usb_device_id *id)
+{
+	struct otg_device	*otg;
+
+	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
+	if (!otg)
+		return;
+	INIT_LIST_HEAD(&otg->list);
+	memcpy(&otg->id, id, sizeof(struct usb_device_id));
+	list_add_tail(&otg->list, &tpl_devices);
+}
+
+static void tpl_add_devices(struct usb_device_id *whitelist_table)
+{
+	struct usb_device_id	*id;
+
+	for (id = whitelist_table; id->match_flags; id++)
+		tpl_add_device(id);
+}
+
+ssize_t otg_print_whitelist(char *buf)
+{
+	struct otg_device	*otg;
+	ssize_t			len = 0;
+
+	list_for_each_entry(otg, &tpl_devices, list)
+		len += sprintf(buf + len, "%04x:%04x\t%02x %02x %02x\n",
+				le16_to_cpu(otg->id.idVendor),
+				le16_to_cpu(otg->id.idProduct),
+				otg->id.bDeviceClass,
+				otg->id.bDeviceSubClass,
+				otg->id.bDeviceProtocol);
+	return len;
+}
+
+int otg_targeted(struct usb_device *dev)
 {
-	struct usb_device_id	*id = whitelist_table;
+	struct otg_device	*otg;
+
+	if (!xceiv || !xceiv->tpl_enabled)
+		return OTG_ERR_DEVICE_SUPPORTED;
 
 	/* possible in developer configs only! */
 	if (!dev->bus->otg_port)
-		return 1;
+		goto targeted;
 
 	/* HNP test device is _never_ targeted (see OTG spec 6.6.6) */
 	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x1a0a &&
 	     le16_to_cpu(dev->descriptor.idProduct) == 0xbadd))
-		return 0;
+		goto err;
+
+	/* roothub don't need to be tested here */
+	if (!dev->parent)
+		goto targeted;
 
 	/* NOTE: can't use usb_match_id() since interface caches
 	 * aren't set up yet. this is cut/paste from that code.
 	 */
-	for (id = whitelist_table; id->match_flags; id++) {
+	list_for_each_entry(otg, &tpl_devices, list) {
+		struct usb_device_id	*id = &otg->id;
+
 		if ((id->match_flags & USB_DEVICE_ID_MATCH_VENDOR) &&
 		    id->idVendor != le16_to_cpu(dev->descriptor.idVendor))
 			continue;
@@ -123,18 +186,50 @@ int is_targeted(struct usb_device *dev)
 		    (id->bDeviceProtocol != dev->descriptor.bDeviceProtocol))
 			continue;
 
-		return 1;
+		goto targeted;
 	}
 
 	/* add other match criteria here ... */
 
-
-	/* OTG MESSAGE: report errors here, customize to match your product */
-	dev_err(&dev->dev, "device v%04x p%04x is not supported\n",
+err:
+	dev_err(&dev->dev, "%s v%04x p%04x is not supported\n",
+		dev->descriptor.bDeviceClass & USB_CLASS_HUB ? "hub" : "device",
 		le16_to_cpu(dev->descriptor.idVendor),
 		le16_to_cpu(dev->descriptor.idProduct));
+	if (dev->descriptor.bDeviceClass & USB_CLASS_HUB)
+		otg_set_error(xceiv, OTG_ERR_HUB_NOT_SUPPORTED);
+	else
+		otg_set_error(xceiv, OTG_ERR_DEVICE_NOT_SUPPORTED);
+
+	return xceiv->last_error;
+
+targeted:
+	xceiv->last_error = OTG_ERR_DEVICE_SUPPORTED;
+	return xceiv->last_error;
+}
+
+static int __init tpl_init(void)
+{
+	INIT_LIST_HEAD(&tpl_devices);
+	tpl_add_devices(whitelist_table);
+	if (xceiv)
+		xceiv->tpl_enabled = 1;
 
 	return 0;
 }
 
+static void __exit tpl_exit(void)
+{
+	struct otg_device	*otg;
+
+	if (xceiv)
+		xceiv->tpl_enabled = 0;
+
+	list_for_each_entry(otg, &tpl_devices, list)
+		kfree(otg);
+}
+
+module_init(tpl_init);
+module_exit(tpl_exit);
+
 #endif	/* CONFIG_USB_OTG_WHITELIST */
diff --git a/drivers/usb/core/otg_whitelist.h b/drivers/usb/core/otg_whitelist.h
deleted file mode 100644
index d6b352e..0000000
--- a/drivers/usb/core/otg_whitelist.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * drivers/usb/core/otg_whitelist.h
- *
- * Copyright (C) 2004 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifdef	CONFIG_USB_OTG_WHITELIST
-extern int is_targeted(struct usb_device *);
-#else
-static inline int is_targeted(struct usb_device *d)
-{
-	return 0;
-}
-#endif
-
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 32bd130..9efc01a 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/usb.h>
+#include <linux/usb/otg.h>
 #include "usb.h"
 
 /* Active configuration fields */
@@ -91,6 +92,132 @@ usb_string_attr(product);
 usb_string_attr(manufacturer);
 usb_string_attr(serial);
 
+#ifdef CONFIG_USB_OTG
+
+static ssize_t
+otg_last_error_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct otg_transceiver	*xceiv = otg_get_transceiver();
+	char			*msg;
+	ssize_t			ret;
+
+	if (!xceiv)
+		return -ENODEV;
+
+	switch (xceiv->last_error) {
+	case OTG_ERR_DEVICE_SUPPORTED:
+		msg = "is supported";
+		break;
+	case OTG_ERR_DEVICE_NOT_SUPPORTED:
+		msg = "is not supported";
+		break;
+	case OTG_ERR_DEVICE_NOT_RESPONDING:
+		msg = "is not responding";
+		break;
+	default:
+		msg = "unknown error";
+	}
+
+	ret = sprintf(buf, "OTG%02d: Device %s\n", xceiv->last_error, msg);
+	put_device(xceiv->dev);
+
+	return ret;
+}
+static DEVICE_ATTR(otg_last_error, 0444, otg_last_error_show, NULL);
+
+#ifdef CONFIG_USB_OTG_WHITELIST
+
+static ssize_t
+otg_whitelist_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return otg_print_whitelist(buf);
+}
+static DEVICE_ATTR(otg_whitelist, 0644, otg_whitelist_show, NULL);
+
+static ssize_t
+otg_whitelist_status_store(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t n)
+{
+	struct otg_transceiver	*xceiv = otg_get_transceiver();
+	int			enable;
+
+	sscanf(buf, "%d", &enable);
+	if (!xceiv)
+		return 0;
+	if (enable)
+		xceiv->tpl_enabled = 1;
+	else
+		xceiv->tpl_enabled = 0;
+	put_device(xceiv->dev);
+
+	return n;
+}
+
+static ssize_t
+otg_whitelist_status_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct otg_transceiver	*xceiv = otg_get_transceiver();
+	int			ret;
+
+	if (!xceiv)
+		return -ENODEV;
+
+	if (xceiv->tpl_enabled)
+		ret = sprintf(buf, "enabled\n");
+	else
+		ret = sprintf(buf, "disabled\n");
+	put_device(xceiv->dev);
+
+	return ret;
+}
+static DEVICE_ATTR(otg_whitelist_status, 0644, otg_whitelist_status_show,
+			otg_whitelist_status_store);
+
+#endif	/* CONFIG_USB_OTG_WHITELIST */
+
+static struct attribute *otg_dev_attrs[] = {
+	&dev_attr_otg_last_error.attr,
+
+#ifdef	CONFIG_USB_OTG_WHITELIST
+	&dev_attr_otg_whitelist.attr,
+	&dev_attr_otg_whitelist_status.attr,
+#endif
+
+};
+
+static int add_otg_attributes(struct device *dev)
+{
+	struct usb_device	*udev = to_usb_device(dev);
+	struct usb_bus		*bus = udev->bus;
+	int			ret = 0, i;
+
+	if (is_usb_device(dev) && !udev->parent && bus->otg_port)
+		for (i = 0; i < ARRAY_SIZE(otg_dev_attrs); i++) {
+			ret = sysfs_create_file(&dev->kobj, otg_dev_attrs[i]);
+			if (ret != 0)
+				return ret;
+		}
+
+	return ret;
+}
+
+static void remove_otg_attributes(struct device *dev)
+{
+	struct usb_device	*udev = to_usb_device(dev);
+	struct usb_bus		*bus = udev->bus;
+	int			i;
+
+	if (is_usb_device(dev) && !udev->parent && bus->otg_port)
+		for (i = 0; i < ARRAY_SIZE(otg_dev_attrs); i++)
+			sysfs_remove_file(&dev->kobj, otg_dev_attrs[i]);
+}
+
+#else
+#define add_otg_attributes(x)		0
+#define remove_otg_attributes(x)	do {} while (0)
+#endif /* CONFIG_USB_OTG */
+
 static ssize_t
 show_speed(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -575,6 +702,9 @@ int usb_create_sysfs_dev_files(struct usb_device *udev)
 		if (retval)
 			goto error;
 	}
+	retval = add_otg_attributes(dev);
+	if (retval)
+		goto error;
 	retval = usb_create_ep_files(dev, &udev->ep0, udev);
 	if (retval)
 		goto error;
@@ -593,6 +723,7 @@ void usb_remove_sysfs_dev_files(struct usb_device *udev)
 	device_remove_file(dev, &dev_attr_product);
 	device_remove_file(dev, &dev_attr_serial);
 	remove_power_attributes(dev);
+	remove_otg_attributes(dev);
 	remove_persist_attributes(dev);
 	device_remove_bin_file(dev, &dev_bin_attr_descriptors);
 	sysfs_remove_group(&dev->kobj, &dev_attr_grp);
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 9897f7a..e748030 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -31,6 +31,13 @@ enum usb_otg_state {
 	OTG_STATE_A_VBUS_ERR,
 };
 
+enum usb_otg_error {
+	OTG_ERR_DEVICE_SUPPORTED,
+	OTG_ERR_DEVICE_NOT_SUPPORTED,
+	OTG_ERR_DEVICE_NOT_RESPONDING,
+	OTG_ERR_HUB_NOT_SUPPORTED,
+};
+
 /*
  * the otg driver needs to interact with both device side and host side
  * usb controllers.  it decides which controller is active at a given
@@ -42,7 +49,10 @@ struct otg_transceiver {
 	const char		*label;
 
 	u8			default_a;
+	unsigned		tpl_enabled:1;
+
 	enum usb_otg_state	state;
+	enum usb_otg_error	last_error;
 
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
@@ -89,6 +99,7 @@ otg_start_hnp(struct otg_transceiver *otg)
 	return otg->start_hnp(otg);
 }
 
+extern void otg_set_error(struct otg_transceiver *otg, enum usb_otg_error);
 
 /* for HCDs */
 static inline int
@@ -129,3 +140,11 @@ otg_start_srp(struct otg_transceiver *otg)
 
 /* for OTG controller drivers (and maybe other stuff) */
 extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
+
+#ifdef CONFIG_USB_OTG_WHITELIST
+struct usb_device;
+extern int otg_targeted(struct usb_device *dev);
+extern ssize_t otg_print_whitelist(char *buf);
+#else
+#define otg_targeted(x)		OTG_ERR_IS_TARGETED
+#endif
-- 
1.5.4.rc3.24.gb53139

