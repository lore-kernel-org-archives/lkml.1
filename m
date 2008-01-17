Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYAQHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYAQHsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYAQHqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:29318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbYAQHqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:14 -0500
X-ExtLoop1: 1
Subject: [PATCH 4/10] ACPI: register ACPI Fan as generic thermal cooling
	device
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:24 +0800
Message-Id: <1200556284.2935.124.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Register ACPI Fan as thermal cooling device.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/fan.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/fan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/fan.c
+++ linux-2.6/drivers/acpi/fan.c
@@ -30,7 +30,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <asm/uaccess.h>
-
+#include <linux/thermal.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -64,9 +64,55 @@ static struct acpi_driver acpi_fan_drive
 		},
 };
 
+/* thermal cooling device callbacks */
+static int fan_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	/* ACPI fan device only support two states: ON/OFF */
+	return sprintf(buf, "1\n");
+}
+
+static int fan_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	struct acpi_device *device = cdev->devdata;
+	int state;
+	int result;
+
+	if (!device)
+		return -EINVAL;
+
+	result = acpi_bus_get_power(device->handle, &state);
+	if (result)
+		return result;
+
+	return sprintf(buf, "%s\n", state == ACPI_STATE_D3 ? "0" :
+			 (state == ACPI_STATE_D0 ? "1" : "unknown"));
+}
+
+static int
+fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned int state)
+{
+	struct acpi_device *device = cdev->devdata;
+	int result;
+
+	if (!device || (state != 0 && state != 1))
+		return -EINVAL;
+
+	result = acpi_bus_set_power(device->handle,
+				state ? ACPI_STATE_D0 : ACPI_STATE_D3);
+
+	return result;
+}
+
+static struct thermal_cooling_device_ops fan_cooling_ops = {
+	.get_max_state = fan_get_max_state,
+	.get_cur_state = fan_get_cur_state,
+	.set_cur_state = fan_set_cur_state,
+};
+
 /* --------------------------------------------------------------------------
                               FS Interface (/proc)
    -------------------------------------------------------------------------- */
+#ifdef CONFIG_ACPI_PROCFS
 
 static struct proc_dir_entry *acpi_fan_dir;
 
@@ -167,7 +213,17 @@ static int acpi_fan_remove_fs(struct acp
 
 	return 0;
 }
+#else
+static int acpi_fan_add_fs(struct acpi_device *device)
+{
+	return 0;
+}
 
+static int acpi_fan_remove_fs(struct acpi_device *device)
+{
+	return 0;
+}
+#endif
 /* --------------------------------------------------------------------------
                                  Driver Interface
    -------------------------------------------------------------------------- */
@@ -175,9 +231,8 @@ static int acpi_fan_remove_fs(struct acp
 static int acpi_fan_add(struct acpi_device *device)
 {
 	int result = 0;
-	struct acpi_fan *fan = NULL;
 	int state = 0;
-
+	struct thermal_cooling_device *cdev;
 
 	if (!device)
 		return -EINVAL;
@@ -191,6 +246,25 @@ static int acpi_fan_add(struct acpi_devi
 		goto end;
 	}
 
+	cdev = thermal_cooling_device_register("Fan", device,
+						&fan_cooling_ops);
+	if (cdev)
+		printk(KERN_INFO PREFIX
+			"%s is registered as cooling_device%d\n",
+			device->dev.bus_id, cdev->id);
+	else
+		goto end;
+	acpi_driver_data(device) = cdev;
+	result = sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
+					"thermal_cooling");
+	if (result)
+		return result;
+
+	result = sysfs_create_link(&cdev->device.kobj, &device->dev.kobj,
+                                       "device");
+        if (result)
+                return result;
+
 	result = acpi_fan_add_fs(device);
 	if (result)
 		goto end;
@@ -200,18 +274,20 @@ static int acpi_fan_add(struct acpi_devi
 	       !device->power.state ? "on" : "off");
 
       end:
-	if (result)
-		kfree(fan);
-
 	return result;
 }
 
 static int acpi_fan_remove(struct acpi_device *device, int type)
 {
-	if (!device || !acpi_driver_data(device))
+	struct thermal_cooling_device *cdev = acpi_driver_data(device);
+
+	if (!device || !cdev)
 		return -EINVAL;
 
 	acpi_fan_remove_fs(device);
+	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+	sysfs_remove_link(&cdev->device.kobj, "device");
+	thermal_cooling_device_unregister(cdev);
 
 	return 0;
 }


