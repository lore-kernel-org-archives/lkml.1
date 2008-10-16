Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYJPR2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYJPR2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYJPRO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:58 -0400
Received: from kroah.org ([198.145.64.141]:47028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756475AbYJPRO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/46] platform: add new device registration helper
Date: Thu, 16 Oct 2008 10:10:38 -0700
Message-Id: <1224177047-11859-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Add a helper that registers simple platform_device w/o resources but with
parent and device data.

This is usefull to cleanup platform code from code that registers such
simple devices as leds-gpio, generic-bl, etc.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |   47 +++++++++++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    2 +
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e621dad..9e60f7c 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -391,6 +391,53 @@ error:
 }
 EXPORT_SYMBOL_GPL(platform_device_register_simple);
 
+/**
+ * platform_device_register_data
+ * @parent: parent device for the device we're adding
+ * @name: base name of the device we're adding
+ * @id: instance id
+ * @data: platform specific data for this platform device
+ * @size: size of platform specific data
+ *
+ * This function creates a simple platform device that requires minimal
+ * resource and memory management. Canned release function freeing memory
+ * allocated for the device allows drivers using such devices to be
+ * unloaded without waiting for the last reference to the device to be
+ * dropped.
+ */
+struct platform_device *platform_device_register_data(
+		struct device *parent,
+		const char *name, int id,
+		const void *data, size_t size)
+{
+	struct platform_device *pdev;
+	int retval;
+
+	pdev = platform_device_alloc(name, id);
+	if (!pdev) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	pdev->dev.parent = parent;
+
+	if (size) {
+		retval = platform_device_add_data(pdev, data, size);
+		if (retval)
+			goto error;
+	}
+
+	retval = platform_device_add(pdev);
+	if (retval)
+		goto error;
+
+	return pdev;
+
+error:
+	platform_device_put(pdev);
+	return ERR_PTR(retval);
+}
+
 static int platform_drv_probe(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 95ac21a..4b8cc6a 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -37,6 +37,8 @@ extern int platform_add_devices(struct platform_device **, int);
 
 extern struct platform_device *platform_device_register_simple(const char *, int id,
 					struct resource *, unsigned int);
+extern struct platform_device *platform_device_register_data(struct device *,
+		const char *, int, const void *, size_t);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
-- 
1.6.0.2

