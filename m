Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYIDVdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYIDVdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYIDVc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:32:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:48389 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIDVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hgYuwWmYKM+BN9PpDoQnlSIMYMc+tkHNB9YxFmvYPJhuPgo+PljCzLs4NZ+VoY3vYx
         SHD5PN/n6UTK6aJQQv/X6zgWMtvkYnog91MtRTe6izOB54rnowqVjNPN4iRcxfezyEr7
         0FPKXFEaEi6jhlDu3bybV7gCpjh+1BZlmsI/0=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] platform: add new device registration helper
Date: Fri,  5 Sep 2008 01:30:16 +0400
Message-Id: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper that registers simple platform_device
w/o resources but with parent and device data.

This is usefull to cleanup platform code from code that
registers such simple devices as leds-gpio, generic-bl,
etc.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/base/platform.c         |   47 +++++++++++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    2 +
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3f94039..fcd9f97 100644
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
1.5.6.5

