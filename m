Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZL3EL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZL3EL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 23:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZL3EL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 23:11:26 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:35158 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZL3ELZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 23:11:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=szH28QVXt0epm8g2WZQv72YG0/TCuNvRdGt3bwBb96h8YEZyB5TqakHHFcLxuKdHdM
         0wuqC0m1Ddd7ZSgfwOun1gckXilk20a2ONz1ouDc9s+SNkcpBycSH34B12ok0oAkQFjX
         imUMvTkLM0v6D7X0t8B5p4BlSSQPvWPlGYYsE=
Date: Tue, 29 Dec 2009 20:11:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Driver core: add platform_create_bundle() helper
Message-ID: <20091230041120.GA2186@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many legacy-style module create singleton platform devices themselves,
along with corresponding platform driver. Instead of replicating error
handling code in all such drivers, provide a helper that allocates and
registers a single platform device and a driver and binds them together.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Greg,

Please consider applying this patch, preferably to your 2.6.33 queue so
that I can start working on converting the users - there are a few of
them creating both the device and the driver and handling errors with
various degrees of success.

Thanks!


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
Dmitry
