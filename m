Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZCHPNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZCHPNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZCHPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:13:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:61773 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCHPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F2ggElrTWngj1yTaJlzIj+kBohmR/RAIVMWhoIsjjDgszkbfAfS3azu91sGVRPyAHE
         pSYgJNym4+iV2FVi/3OusDMaS6sSmcXKCmOpEMaMDbrKpzBrms7maKulnob07KJKgRsN
         2/w3HtGJzUaSsnDzvL8l16QtodWShSf+j5lbs=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: move platform_data into platform_device
Date: Sun,  8 Mar 2009 23:13:32 +0800
Message-Id: <1236525212-4092-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch moves platform_data from struct device into
struct platform_device, based on the two ideas:

1,Now all platform_driver is registered by platform_driver_register,
which makes probe()/release()/... of platform_driver passed parameter
of platform_device *, so platform driver can get platform_data
from platform_device;

2,Other kind of devices do not need to use platform_data, we can
decrease size of device if moving it to platform_device.

Taking into consideration of thousands of files to be fixed and
they can't be finished in one night(maybe it will take a long time),
so we keep platform_data in device to allow two kind of cases
coexist until all platform devices pass its platfrom data from
platform_device->platform_data.

All patches to do this kind of conversion are welcome.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/platform.c         |    3 +++
 include/linux/device.h          |    9 +++++++--
 include/linux/platform_device.h |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ec993aa..c5ac81d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -217,6 +217,7 @@ int platform_device_add_data(struct platform_device *pdev, const void *data,
 	if (d) {
 		memcpy(d, data, size);
 		pdev->dev.platform_data = d;
+		pdev->platform_data = d;
 	}
 	return d ? 0 : -ENOMEM;
 }
@@ -246,6 +247,8 @@ int platform_device_add(struct platform_device *pdev)
 	else
 		dev_set_name(&pdev->dev, pdev->name);
 
+	pdev->platform_data = pdev->dev.platform_data;
+
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 663bb49..8647cde 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -384,8 +384,13 @@ struct device {
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
 	void		*driver_data;	/* data private to the driver */
-	void		*platform_data;	/* Platform specific data, device
-					   core doesn't touch it */
+
+	void		*platform_data;	/* We will remove platform_data
+					   field if all platform devices
+					   pass its platform specific data
+					   from platform_device->platform_data,
+					   other kind of devices should not
+					   use platform_data. */
 	struct dev_pm_info	power;
 
 #ifdef CONFIG_NUMA
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 76aef7b..76e470a 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -20,6 +20,7 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
+	void		*platform_data;
 
 	struct platform_device_id	*id_entry;
 };
-- 
1.6.0.GIT

