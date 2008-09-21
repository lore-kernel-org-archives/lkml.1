Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYIUOaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYIUOaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYIUOaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:30:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:21563 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYIUOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xOcNnLxdHQFv+7RprEp1Tg1qYHx47nSLruiif+AHbtTmb8w1y0T8TpnEnXLFt9Qn9i
         IkwaBsAxaXXs8gJzhH6LPpR4TWdVQ3B8ZVpoxOHiytPY7K93AH1RNbSDx4a8U9RnizRe
         ysTolshob5mVGawOZlWehHEbeg58bmfxqRL7I=
Date: Sun, 21 Sep 2008 23:29:59 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH] acer-wmi: add error checks in module_init
Message-ID: <20080921142958.GC8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are sevaral bugs in module_init and module_exit for acer-wmi.

- No error handlings for platform_device_alloc() and platform_device_add()

- acer_platform_device is not freeed in module_exit

This patch fixes these bugs by using platform_device_register_simple()
and platform_device_unregister() respectively.

This patch also makes create_sysfs() take a argument struct
platform_device pointer so that it looks symmetrical to remove_sysfs().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
---
 drivers/misc/acer-wmi.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

Index: 2.6-git/drivers/misc/acer-wmi.c
===================================================================
--- 2.6-git.orig/drivers/misc/acer-wmi.c
+++ 2.6-git/drivers/misc/acer-wmi.c
@@ -1129,40 +1129,36 @@ static int remove_sysfs(struct platform_
 	return 0;
 }
 
-static int create_sysfs(void)
+static int create_sysfs(struct platform_device *device)
 {
 	int retval = -ENOMEM;
 
 	if (has_cap(ACER_CAP_WIRELESS)) {
-		retval = device_create_file(&acer_platform_device->dev,
-			&dev_attr_wireless);
+		retval = device_create_file(&device->dev, &dev_attr_wireless);
 		if (retval)
 			goto error_sysfs;
 	}
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
-		retval = device_create_file(&acer_platform_device->dev,
-			&dev_attr_bluetooth);
+		retval = device_create_file(&device->dev, &dev_attr_bluetooth);
 		if (retval)
 			goto error_sysfs;
 	}
 
 	if (has_cap(ACER_CAP_THREEG)) {
-		retval = device_create_file(&acer_platform_device->dev,
-			&dev_attr_threeg);
+		retval = device_create_file(&device->dev, &dev_attr_threeg);
 		if (retval)
 			goto error_sysfs;
 	}
 
-	retval = device_create_file(&acer_platform_device->dev,
-		&dev_attr_interface);
+	retval = device_create_file(&device->dev, &dev_attr_interface);
 	if (retval)
 		goto error_sysfs;
 
 	return 0;
 
 error_sysfs:
-		remove_sysfs(acer_platform_device);
+	remove_sysfs(device);
 	return retval;
 }
 
@@ -1242,22 +1238,27 @@ static int __init acer_wmi_init(void)
 
 	set_quirks();
 
-	if (platform_driver_register(&acer_platform_driver)) {
+	err = platform_driver_register(&acer_platform_driver);
+	if (err) {
 		printk(ACER_ERR "Unable to register platform driver.\n");
-		goto error_platform_register;
+		return err;
+	}
+	acer_platform_device = platform_device_register_simple("acer-wmi", -1,
+								NULL, 0);
+	if (IS_ERR(acer_platform_device)) {
+		err = PTR_ERR(acer_platform_device);
+		goto out1;
 	}
-	acer_platform_device = platform_device_alloc("acer-wmi", -1);
-	platform_device_add(acer_platform_device);
 
-	err = create_sysfs();
+	err = create_sysfs(acer_platform_device);
 	if (err)
-		return err;
+		goto out2;
 
 	if (wmi_has_guid(WMID_GUID2)) {
 		interface->debug.wmid_devices = get_wmid_devices();
 		err = create_debugfs();
 		if (err)
-			return err;
+			goto out3;
 	}
 
 	/* Override any initial settings with values from the commandline */
@@ -1265,19 +1266,24 @@ static int __init acer_wmi_init(void)
 
 	return 0;
 
-error_platform_register:
-	return -ENODEV;
+out3:
+	remove_sysfs(acer_platform_device);
+out2:
+	platform_device_unregister(acer_platform_device);
+out1:
+	platform_driver_unregister(&acer_platform_driver);
+
+	return err;
 }
 
 static void __exit acer_wmi_exit(void)
 {
 	remove_sysfs(acer_platform_device);
 	remove_debugfs();
-	platform_device_del(acer_platform_device);
+	platform_device_unregister(acer_platform_device);
 	platform_driver_unregister(&acer_platform_driver);
 
 	printk(ACER_INFO "Acer Laptop WMI Extras unloaded\n");
-	return;
 }
 
 module_init(acer_wmi_init);
