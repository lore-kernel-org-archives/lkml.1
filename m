Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYAQHr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYAQHr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYAQHqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:54938 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbYAQHqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:08 -0500
X-ExtLoop1: 1
Subject: [PATCH 6/10] ACPI: register ACPI Video LCD as generic thermal
	cooling device
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:22 +0800
Message-Id: <1200556282.2935.122.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Register ACPI video device as thermal cooling devices as they may be listed
in _TZD method and the backlight control can be used for throttling.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/video.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/video.c
===================================================================
--- linux-2.6.orig/drivers/acpi/video.c
+++ linux-2.6/drivers/acpi/video.c
@@ -34,6 +34,7 @@
 #include <linux/seq_file.h>
 #include <linux/input.h>
 #include <linux/backlight.h>
+#include <linux/thermal.h>
 #include <linux/video_output.h>
 #include <asm/uaccess.h>
 
@@ -179,6 +180,7 @@ struct acpi_video_device {
 	struct acpi_device *dev;
 	struct acpi_video_device_brightness *brightness;
 	struct backlight_device *backlight;
+	struct thermal_cooling_device *cdev;
 	struct output_device *output_dev;
 };
 
@@ -334,6 +336,54 @@ static struct output_properties acpi_out
 	.set_state = acpi_video_output_set,
 	.get_status = acpi_video_output_get,
 };
+
+
+/* thermal cooling device callbacks */
+static int video_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_video_device *video = acpi_driver_data(device);
+
+	return sprintf(buf, "%d\n", video->brightness->count - 3);
+}
+
+static int video_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_video_device *video = acpi_driver_data(device);
+	unsigned long level;
+	int state;
+
+	acpi_video_device_lcd_get_level_current(video, &level);
+	for (state = 2; state < video->brightness->count; state++)
+		if (level == video->brightness->levels[state])
+			return sprintf(buf, "%d\n",
+				       video->brightness->count - state - 1);
+
+	return -EINVAL;
+}
+
+static int
+video_set_cur_state(struct thermal_cooling_device *cdev, unsigned int state)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_video_device *video = acpi_driver_data(device);
+	int level;
+
+	if ( state >= video->brightness->count - 2)
+		return -EINVAL;
+
+	state = video->brightness->count - state;
+	level = video->brightness->levels[state -1];
+	return acpi_video_device_lcd_set_level(video, level);
+}
+
+static struct thermal_cooling_device_ops video_cooling_ops = {
+	.get_max_state = video_get_max_state,
+	.get_cur_state = video_get_cur_state,
+	.set_cur_state = video_set_cur_state,
+};
+
 /* --------------------------------------------------------------------------
                                Video Management
    -------------------------------------------------------------------------- */
@@ -653,6 +703,7 @@ static void acpi_video_device_find_cap(s
 
 	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
 		unsigned long tmp;
+		int result;
 		static int count = 0;
 		char *name;
 		name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
@@ -666,8 +717,25 @@ static void acpi_video_device_find_cap(s
 		device->backlight->props.max_brightness = max_level;
 		device->backlight->props.brightness = (int)tmp;
 		backlight_update_status(device->backlight);
-
 		kfree(name);
+
+		device->cdev = thermal_cooling_device_register("LCD",
+					device->dev, &video_cooling_ops);
+		if (device->cdev) {
+			printk(KERN_INFO PREFIX
+				"%s is registered as cooling_device%d\n",
+				device->dev->dev.bus_id, device->cdev->id);
+			result = sysfs_create_link(&device->dev->dev.kobj,
+					  &device->cdev->device.kobj,
+					  "thermal_cooling");
+			if (result)
+				printk(KERN_ERR PREFIX "Create sysfs link\n");
+			result = sysfs_create_link(&device->cdev->device.kobj,
+					  &device->dev->dev.kobj,
+					  "device");
+                        if (result)
+				printk(KERN_ERR PREFIX "Create sysfs link\n");
+		}
 	}
 	if (device->cap._DCS && device->cap._DSS){
 		static int count = 0;
@@ -1729,6 +1797,14 @@ static int acpi_video_bus_put_one_device
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
 	backlight_device_unregister(device->backlight);
+	if (device->cdev) {
+		sysfs_remove_link(&device->dev->dev.kobj,
+				  "thermal_cooling");
+		sysfs_remove_link(&device->cdev->device.kobj,
+				  "device");
+		thermal_cooling_device_unregister(device->cdev);
+		device->cdev = NULL;
+	}
 	video_output_unregister(device->output_dev);
 
 	return 0;


