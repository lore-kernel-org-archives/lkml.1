Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYIUOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYIUOfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYIUOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:35:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:23175 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYIUOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=StAPdBecwGVi7WHfkO226My5uMwRJ74v1l3bmj1N/+bcBggS/lGzRdni43iRLiCBrl
         q3nwgwprVIsL2wMvqUJ65NvbIy/Nwb5+OGTQXH+pT1T0JdAl3HP6foV8sTkzl7QH99yH
         U70QPhHH7tZmqRPtRK0WSUwBykHJEk7QXOg08=
Date: Sun, 21 Sep 2008 23:35:00 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH] tc1100-wmi: add error checks in module_init
Message-ID: <20080921143459.GD8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are sevaral bugs in module_init and module_exit for tc1100-wmi.

- No error handlings for platform_device_alloc() and platform_device_add()

- tc1100_device is not freeed in module_exit

This patch fixes these bugs by using platform_device_register_simple()
and platform_device_unregister() respectively.

This change needs to change the probe function to pass platform_device
to add_fs() and makes add_fs() use it rather than the variable tc1100_device.
Because tc1100_device is not initialized yet when probe function
is called. (tc1100_device is initialized as the return value from
platform_device_register_simple() but probe function is called in
platform_device_register_simple())

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
---
 drivers/misc/tc1100-wmi.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: 2.6-git/drivers/misc/tc1100-wmi.c
===================================================================
--- 2.6-git.orig/drivers/misc/tc1100-wmi.c
+++ 2.6-git/drivers/misc/tc1100-wmi.c
@@ -185,28 +185,28 @@ static DEVICE_ATTR(value, S_IWUGO | S_IR
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);
 show_set_bool(jogdial, TC1100_INSTANCE_JOGDIAL);
 
-static void remove_fs(void)
+static void remove_fs(struct platform_device *pdev)
 {
-	device_remove_file(&tc1100_device->dev, &dev_attr_wireless);
-	device_remove_file(&tc1100_device->dev, &dev_attr_jogdial);
+	device_remove_file(&pdev->dev, &dev_attr_wireless);
+	device_remove_file(&pdev->dev, &dev_attr_jogdial);
 }
 
-static int add_fs(void)
+static int add_fs(struct platform_device *pdev)
 {
 	int ret;
 
-	ret = device_create_file(&tc1100_device->dev, &dev_attr_wireless);
+	ret = device_create_file(&pdev->dev, &dev_attr_wireless);
 	if (ret)
 		goto add_sysfs_error;
 
-	ret = device_create_file(&tc1100_device->dev, &dev_attr_jogdial);
+	ret = device_create_file(&pdev->dev, &dev_attr_jogdial);
 	if (ret)
 		goto add_sysfs_error;
 
 	return ret;
 
 add_sysfs_error:
-	remove_fs();
+	remove_fs(pdev);
 	return ret;
 }
 
@@ -216,16 +216,12 @@ add_sysfs_error:
 
 static int tc1100_probe(struct platform_device *device)
 {
-	int result = 0;
-
-	result = add_fs();
-	return result;
+	return add_fs(device);
 }
 
-
 static int tc1100_remove(struct platform_device *device)
 {
-	remove_fs();
+	remove_fs(device);
 	return 0;
 }
 
@@ -261,7 +257,7 @@ static int tc1100_resume(struct platform
 
 static int __init tc1100_init(void)
 {
-	int result = 0;
+	int result;
 
 	if (!wmi_has_guid(GUID))
 		return -ENODEV;
@@ -270,17 +266,21 @@ static int __init tc1100_init(void)
 	if (result)
 		return result;
 
-	tc1100_device = platform_device_alloc("tc1100-wmi", -1);
-	platform_device_add(tc1100_device);
+	tc1100_device = platform_device_register_simple("tc1100-wmi", -1,
+							NULL, 0);
+	if (IS_ERR(tc1100_device)) {
+		platform_driver_unregister(&tc1100_driver);
+		return PTR_ERR(tc1100_device);
+	}
 
 	printk(TC1100_INFO "HP Compaq TC1100 Tablet WMI Extras loaded\n");
 
-	return result;
+	return 0;
 }
 
 static void __exit tc1100_exit(void)
 {
-	platform_device_del(tc1100_device);
+	platform_device_unregister(tc1100_device);
 	platform_driver_unregister(&tc1100_driver);
 
 	printk(TC1100_INFO "HP Compaq TC1100 Tablet WMI Extras unloaded\n");
