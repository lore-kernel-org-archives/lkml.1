Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbZKZMG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbZKZMG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbZKZMGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:06:25 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37110 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZKZMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:06:24 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rui.zhang@intel.com, jic23@cam.ac.uk, khali@linux-fr.org,
       alan@linux.intel.com, linux-acpi@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 2/2] als: add unique device-ids to the als device class
Date: Thu, 26 Nov 2009 14:06:26 +0200
Message-Id: <1259237186-5459-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259237081-4403-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259237081-4403-1-git-send-email-amit.kucheria@verdurent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other devices classes such as hwmon and input class handle assignment of
unique device-ids inside the core functions instead of pushing it out to
individual drivers. This reduces code duplication and resulting bugs.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>

---
 drivers/als/als_sys.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/als/als_sys.c b/drivers/als/als_sys.c
index e1d6395..aa15ad8 100644
--- a/drivers/als/als_sys.c
+++ b/drivers/als/als_sys.c
@@ -26,22 +26,55 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/kdev_t.h>
+#include <linux/idr.h>
 
 MODULE_AUTHOR("Zhang Rui <rui.zhang@intel.com>");
 MODULE_DESCRIPTION("Ambient Light Sensor sysfs/class support");
 MODULE_LICENSE("GPL");
 
+#define ALS_ID_PREFIX "als"
+#define ALS_ID_FORMAT ALS_ID_PREFIX "%d"
+
 static struct class *als_class;
 
+static DEFINE_IDR(als_idr);
+static DEFINE_SPINLOCK(idr_lock);
+
 /**
  * als_device_register - register a new Ambient Light Sensor class device
  * @parent:	the device to register.
  *
  * Returns the pointer to the new device
  */
-struct device *als_device_register(struct device *dev, char *name)
+struct device *als_device_register(struct device *dev)
 {
-	return device_create(als_class, dev, MKDEV(0, 0), NULL, name);
+	int id, err;
+	struct device *alsdev;
+
+again:
+	if (unlikely(idr_pre_get(&als_idr, GFP_KERNEL) == 0))
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&idr_lock);
+	err = idr_get_new(&als_idr, NULL, &id);
+	spin_unlock(&idr_lock);
+
+	if (unlikely(err == -EAGAIN))
+		goto again;
+	else if (unlikely(err))
+		return ERR_PTR(err);
+
+	id = id & MAX_ID_MASK;
+	alsdev = device_create(als_class, dev, MKDEV(0, 0), NULL,
+			ALS_ID_FORMAT, id);
+
+	if (IS_ERR(alsdev)) {
+		spin_lock(&idr_lock);
+		idr_remove(&als_idr, id);
+		spin_unlock(&idr_lock);
+	}
+
+	return alsdev;
 }
 EXPORT_SYMBOL(als_device_register);
 
@@ -51,7 +84,16 @@ EXPORT_SYMBOL(als_device_register);
  */
 void als_device_unregister(struct device *dev)
 {
-	device_unregister(dev);
+	int id;
+
+	if (likely(sscanf(dev_name(dev), ALS_ID_FORMAT, &id) == 1)) {
+		device_unregister(dev);
+		spin_lock(&idr_lock);
+		idr_remove(&als_idr, id);
+		spin_unlock(&idr_lock);
+	} else
+		dev_dbg(dev->parent,
+			"als_device_unregister() failed: bad class ID!\n");
 }
 EXPORT_SYMBOL(als_device_unregister);
 
-- 
1.6.3.3

