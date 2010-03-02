Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0CCAAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:00:21 -0500
Received: from kroah.org ([198.145.64.141]:38487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab0CBX3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/62] Driver core: add platform_create_bundle() helper
Date: Tue,  2 Mar 2010 15:28:02 -0800
Message-Id: <1267572541-410-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Many legacy-style module create singleton platform devices themselves,
along with corresponding platform driver. Instead of replicating error
handling code in all such drivers, provide a helper that allocates and
registers a single platform device and a driver and binds them together.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |   58 +++++++++++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    5 +++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 58efaf2..937d580 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -548,6 +548,64 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 }
 EXPORT_SYMBOL_GPL(platform_driver_probe);
 
+/**
+ * platform_create_bundle - register driver and create corresponding device
+ * @driver: platform driver structure
+ * @probe: the driver probe routine, probably from an __init section
+ * @res: set of resources that needs to be allocated for the device
+ * @n_res: number of resources
+ * @data: platform specific data for this platform device
+ * @size: size of platform specific data
+ *
+ * Use this in legacy-style modules that probe hardware directly and
+ * register a single platform device and corresponding platform driver.
+ */
+struct platform_device * __init_or_module platform_create_bundle(
+			struct platform_driver *driver,
+			int (*probe)(struct platform_device *),
+			struct resource *res, unsigned int n_res,
+			const void *data, size_t size)
+{
+	struct platform_device *pdev;
+	int error;
+
+	pdev = platform_device_alloc(driver->driver.name, -1);
+	if (!pdev) {
+		error = -ENOMEM;
+		goto err_out;
+	}
+
+	if (res) {
+		error = platform_device_add_resources(pdev, res, n_res);
+		if (error)
+			goto err_pdev_put;
+	}
+
+	if (data) {
+		error = platform_device_add_data(pdev, data, size);
+		if (error)
+			goto err_pdev_put;
+	}
+
+	error = platform_device_add(pdev);
+	if (error)
+		goto err_pdev_put;
+
+	error = platform_driver_probe(driver, probe);
+	if (error)
+		goto err_pdev_del;
+
+	return pdev;
+
+err_pdev_del:
+	platform_device_del(pdev);
+err_pdev_put:
+	platform_device_put(pdev);
+err_out:
+	return ERR_PTR(error);
+}
+EXPORT_SYMBOL_GPL(platform_create_bundle);
+
 /* modalias support enables more hands-off userspace setup:
  * (a) environment variable lets new-style hotplug events work once system is
  *     fully running:  "modprobe $MODALIAS"
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 71ff887..25e64b4 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -77,6 +77,11 @@ extern int platform_driver_probe(struct platform_driver *driver,
 #define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
 #define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
 
+extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
+					int (*probe)(struct platform_device *),
+					struct resource *res, unsigned int n_res,
+					const void *data, size_t size);
+
 /* early platform driver interface */
 struct early_platform_driver {
 	const char *class_str;
-- 
1.7.0.1

