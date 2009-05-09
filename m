Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZEIDbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZEIDbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbZEID3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:29:13 -0400
Received: from kroah.org ([198.145.64.141]:41368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZEID3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:29:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Brownell <david-b@pacbell.net>,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 5/5] Revert driver core: move platform_data into platform_device
Date: Fri,  8 May 2009 20:25:59 -0700
Message-Id: <1241839559-9157-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032432.GA9000@kroah.com>
References: <20090509032432.GA9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 006f4571a15fae3a0575f2a0f9e9b63b3d1012f8:

	This patch moves platform_data from struct device into
	struct platform_device, based on the two ideas:

	1. Now all platform_driver is registered by platform_driver_register,
	   which makes probe()/release()/... of platform_driver passed parameter
	   of platform_device *, so platform driver can get platform_data from
	   platform_device;

	2. Other kind of devices do not need to use platform_data, we can
	   decrease size of device if moving it to platform_device.

	Taking into consideration of thousands of files to be fixed and they
	can't be finished in one night(maybe it will take a long time), so we
	keep platform_data in device to allow two kind of cases coexist until
	all platform devices pass its platfrom data from
	platform_device->platform_data.

	All patches to do this kind of conversion are welcome.

As we don't really want to do it, it was a bad idea.

Cc: David Brownell <david-b@pacbell.net>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    3 ---
 include/linux/device.h          |    9 ++-------
 include/linux/platform_device.h |    1 -
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index d1d0ee4..8b4708e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -217,7 +217,6 @@ int platform_device_add_data(struct platform_device *pdev, const void *data,
 	if (d) {
 		memcpy(d, data, size);
 		pdev->dev.platform_data = d;
-		pdev->platform_data = d;
 	}
 	return d ? 0 : -ENOMEM;
 }
@@ -247,8 +246,6 @@ int platform_device_add(struct platform_device *pdev)
 	else
 		dev_set_name(&pdev->dev, pdev->name);
 
-	pdev->platform_data = pdev->dev.platform_data;
-
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 6a69caa..5d5c197 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -384,13 +384,8 @@ struct device {
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
 	void		*driver_data;	/* data private to the driver */
-
-	void		*platform_data;	/* We will remove platform_data
-					   field if all platform devices
-					   pass its platform specific data
-					   from platform_device->platform_data,
-					   other kind of devices should not
-					   use platform_data. */
+	void		*platform_data;	/* Platform specific data, device
+					   core doesn't touch it */
 	struct dev_pm_info	power;
 
 #ifdef CONFIG_NUMA
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 72736fd..b67bb5d 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -20,7 +20,6 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
-	void		*platform_data;
 
 	struct platform_device_id	*id_entry;
 };
-- 
1.6.3

