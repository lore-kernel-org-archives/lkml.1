Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0BBHwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:22 -0500
Received: from iksaif.net ([88.191.73.63]:50251 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab0BBHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 27/28] asus-laptop: use device_create_file() instead of platform_group
Date: Tue,  2 Feb 2010 08:39:10 +0100
Message-Id: <1265096351-15239-28-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-27-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-24-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-25-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-26-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-27-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is two reason to do that:
- we don't want a "gps" file if the model doesn't have a gps
- we don't want to use global variables anymore

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  166 ++++++++++++++++++------------------
 1 files changed, 84 insertions(+), 82 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index ae53026..d0d117b 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -918,6 +918,8 @@ static ssize_t show_disp(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
+	if (!display_get_handle)
+		return -ENODEV;
 	return sprintf(buf, "%d\n", read_display(asus));
 }
 
@@ -1191,77 +1193,113 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	asus_input_notify(asus, event);
 }
 
-#define ASUS_CREATE_DEVICE_ATTR(_name)					\
-	struct device_attribute dev_attr_##_name = {			\
-		.attr = {						\
-			.name = __stringify(_name),			\
-			.mode = 0 },					\
-		.show   = NULL,						\
-		.store  = NULL,						\
+static DEVICE_ATTR(infos, S_IRUGO, show_infos, NULL);
+static DEVICE_ATTR(wlan, S_IRUGO | S_IWUSR, show_wlan, store_wlan);
+static DEVICE_ATTR(bluetooth, S_IRUGO | S_IWUSR, show_bluetooth,
+		   store_bluetooth);
+static DEVICE_ATTR(display, S_IRUGO | S_IWUSR, show_disp, store_disp);
+static DEVICE_ATTR(ledd, S_IRUGO | S_IWUSR, show_ledd, store_ledd);
+static DEVICE_ATTR(ls_level, S_IRUGO | S_IWUSR, show_lslvl, store_lslvl);
+static DEVICE_ATTR(ls_switch, S_IRUGO | S_IWUSR, show_lssw, store_lssw);
+static DEVICE_ATTR(gps, S_IRUGO | S_IWUSR, show_gps, store_gps);
+
+static void asus_sysfs_exit(struct asus_laptop *asus)
+{
+	struct platform_device *device = asus->platform_device;
+
+	device_remove_file(&device->dev, &dev_attr_infos);
+	device_remove_file(&device->dev, &dev_attr_wlan);
+	device_remove_file(&device->dev, &dev_attr_bluetooth);
+	device_remove_file(&device->dev, &dev_attr_display);
+	device_remove_file(&device->dev, &dev_attr_ledd);
+	device_remove_file(&device->dev, &dev_attr_ls_switch);
+	device_remove_file(&device->dev, &dev_attr_ls_level);
+	device_remove_file(&device->dev, &dev_attr_gps);
+}
+
+static int asus_sysfs_init(struct asus_laptop *asus)
+{
+	struct platform_device *device = asus->platform_device;
+	int err;
+
+	err = device_create_file(&device->dev, &dev_attr_infos);
+	if (err)
+		return err;
+
+	if (!acpi_check_handle(asus->handle, METHOD_WLAN, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_wlan);
+		if (err)
+			return err;
 	}
 
-#define ASUS_SET_DEVICE_ATTR(_name, _mode, _show, _store)		\
-	do {								\
-		dev_attr_##_name.attr.mode = _mode;			\
-		dev_attr_##_name.show = _show;				\
-		dev_attr_##_name.store = _store;			\
-	} while(0)
-
-static ASUS_CREATE_DEVICE_ATTR(infos);
-static ASUS_CREATE_DEVICE_ATTR(wlan);
-static ASUS_CREATE_DEVICE_ATTR(bluetooth);
-static ASUS_CREATE_DEVICE_ATTR(display);
-static ASUS_CREATE_DEVICE_ATTR(ledd);
-static ASUS_CREATE_DEVICE_ATTR(ls_switch);
-static ASUS_CREATE_DEVICE_ATTR(ls_level);
-static ASUS_CREATE_DEVICE_ATTR(gps);
-
-static struct attribute *asuspf_attributes[] = {
-	&dev_attr_infos.attr,
-	&dev_attr_wlan.attr,
-	&dev_attr_bluetooth.attr,
-	&dev_attr_display.attr,
-	&dev_attr_ledd.attr,
-	&dev_attr_ls_switch.attr,
-	&dev_attr_ls_level.attr,
-	&dev_attr_gps.attr,
-	NULL
-};
+	if (!acpi_check_handle(asus->handle, METHOD_BLUETOOTH, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_bluetooth);
+		if (err)
+			return err;
+	}
 
-static struct attribute_group platform_attribute_group = {
-	.attrs = asuspf_attributes
-};
+	if (!acpi_check_handle(asus->handle, METHOD_SWITCH_DISPLAY, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_display);
+		if (err)
+			return err;
+	}
+
+	if (!acpi_check_handle(asus->handle, METHOD_LEDD, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_ledd);
+		if (err)
+			return err;
+	}
+
+	if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_ls_switch);
+		if (err)
+			return err;
+		err = device_create_file(&device->dev, &dev_attr_ls_level);
+		if (err)
+			return err;
+	}
+
+	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL)) {
+		err = device_create_file(&device->dev, &dev_attr_gps);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
 
 static int asus_platform_init(struct asus_laptop *asus)
 {
-	int result;
+	int err;
 
 	asus->platform_device = platform_device_alloc(ASUS_LAPTOP_FILE, -1);
 	if (!asus->platform_device)
 		return -ENOMEM;
 	platform_set_drvdata(asus->platform_device, asus);
 
-	result = platform_device_add(asus->platform_device);
-	if (result)
+	err = platform_device_add(asus->platform_device);
+	if (err)
 		goto fail_platform_device;
 
-	result = sysfs_create_group(&asus->platform_device->dev.kobj,
-				    &platform_attribute_group);
-	if (result)
+	err = asus_sysfs_init(asus);
+	if (err)
 		goto fail_sysfs;
 	return 0;
 
 fail_sysfs:
+	asus_sysfs_exit(asus);
 	platform_device_del(asus->platform_device);
 fail_platform_device:
 	platform_device_put(asus->platform_device);
-	return result;
+	return err;
 }
 
 static void asus_platform_exit(struct asus_laptop *asus)
 {
-	sysfs_remove_group(&asus->platform_device->dev.kobj,
-			   &platform_attribute_group);
+	asus_sysfs_exit(asus);
 	platform_device_unregister(asus->platform_device);
 }
 
@@ -1272,40 +1310,6 @@ static struct platform_driver platform_driver = {
 	}
 };
 
-static void asus_laptop_add_fs(struct asus_laptop *asus)
-{
-	ASUS_SET_DEVICE_ATTR(infos, 0444, show_infos, NULL);
-
-	if (!acpi_check_handle(asus->handle, METHOD_WLAN, NULL))
-		ASUS_SET_DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan);
-
-	if (!acpi_check_handle(asus->handle, METHOD_BLUETOOTH, NULL))
-		ASUS_SET_DEVICE_ATTR(bluetooth, 0644,
-				     show_bluetooth, store_bluetooth);
-
-	if (!acpi_check_handle(asus->handle, METHOD_SWITCH_DISPLAY, NULL)) {
-		if (display_get_handle)
-			ASUS_SET_DEVICE_ATTR(display, 0644, show_disp,
-					     store_disp);
-		else
-			ASUS_SET_DEVICE_ATTR(display, 0200, NULL, store_disp);
-	}
-
-	if (!acpi_check_handle(asus->handle, METHOD_LEDD, NULL))
-		ASUS_SET_DEVICE_ATTR(ledd, 0644, show_ledd, store_ledd);
-
-	if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
-		ASUS_SET_DEVICE_ATTR(ls_level, 0644, show_lslvl, store_lslvl);
-		ASUS_SET_DEVICE_ATTR(ls_switch, 0644, show_lssw, store_lssw);
-	}
-
-	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
-		ASUS_SET_DEVICE_ATTR(gps, 0644, show_gps, store_gps);
-}
-
 static int asus_handle_init(char *name, acpi_handle * handle,
 			    char **paths, int num_paths)
 {
@@ -1435,8 +1439,6 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	if (result)
 		return result;
 
-	asus_laptop_add_fs(asus);
-
 	/* WLED and BLED are on by default */
 	if (bluetooth_status >= 0)
 		asus_bluetooth_set(asus, !!bluetooth_status);
-- 
1.6.6.1

