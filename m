Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbXHTWzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbXHTWzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbXHTWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:60178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXHTWxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:53:04 -0400
Message-Id: <20070820225127.423095000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:16 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kay.sievers@vrfy.org
Subject: [patch 10/14] Convert from class_device to device for USB core
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=usb-core.patch

Convert from class_device to device for drivers/ide/usb/core.   Greg, not
sure if you're looking for a patch for this. Kay mentioned maybe it was to
be superceded by a diff mechanism.  Free free to drop if so.

---
 drivers/usb/core/hcd.c |   12 ++++++------
 include/linux/usb.h    |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -739,15 +739,15 @@ static int usb_register_bus(struct usb_b
 		return -E2BIG;
 	}
 
-	bus->class_dev = class_device_create(usb_host_class, NULL, MKDEV(0,0),
-					     bus->controller, "usb_host%d", busnum);
-	if (IS_ERR(bus->class_dev)) {
+	bus->dev = device_create(usb_host_class, bus->controller, MKDEV(0,0),
+				 "usb_host%d", busnum);
+	if (IS_ERR(bus->dev)) {
 		clear_bit(busnum, busmap.busmap);
 		mutex_unlock(&usb_bus_list_lock);
-		return PTR_ERR(bus->class_dev);
+		return PTR_ERR(bus->dev);
 	}
 
-	class_set_devdata(bus->class_dev, bus);
+	dev_set_drvdata(bus->dev, bus);
 
 	/* Add it to the local list of buses */
 	list_add (&bus->bus_list, &usb_bus_list);
@@ -784,7 +784,7 @@ static void usb_deregister_bus (struct u
 
 	clear_bit (bus->busnum, busmap.busmap);
 
-	class_device_unregister(bus->class_dev);
+	device_unregister(bus->dev);
 }
 
 /**
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -314,7 +314,7 @@ struct usb_bus {
 #ifdef CONFIG_USB_DEVICEFS
 	struct dentry *usbfs_dentry;	/* usbfs dentry entry for the bus */
 #endif
-	struct class_device *class_dev;	/* class device for this bus */
+	struct device *dev;		/* device for this bus */
 
 #if defined(CONFIG_USB_MON)
 	struct mon_bus *mon_bus;	/* non-null when associated */

-- 
