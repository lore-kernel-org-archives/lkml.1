Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYBKKbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYBKKbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYBKKbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:31:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:21605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYBKKbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:31:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,332,1199692800"; 
   d="scan'208";a="337993434"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [Bug-fix]:2.6.25-rc0 Generic thermal management:ACPI [Patch 2/2]: buildfix for CONFIG_THERMAL=n
Date: Mon, 11 Feb 2008 16:00:45 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802A3A1BD@bgsmsx411.gar.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug-fix]:2.6.25-rc0 Generic thermal management:ACPI [Patch 2/2]: buildfix for CONFIG_THERMAL=n
Thread-Index: AchsmSkrxnPwD07LSnC66Zb/+OpOMQ==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Len Brown" <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 11 Feb 2008 10:31:12.0775 (UTC) FILETIME=[39555970:01C86C99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Sujith <sujith.thomas@intel.com>

Conditional dependency is being added for the generic thermal management
driver so that ACPI drivers can work without the presence of generic
thermal driver. Additional checks are added to fan,video,processor
and intel_menlow driver to have the right interpretation of
returned data.

Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/fan.c            |   31 +++++++++++++++++++------------
 drivers/acpi/processor_core.c |   32 +++++++++++++++++++-------------
 drivers/acpi/video.c          |    4 ++++
 drivers/misc/intel_menlow.c   |   12 ++++++++----
 include/linux/thermal.h       |   25 ++++++++++++++++++++-----
 5 files changed, 70 insertions(+), 34 deletions(-)

Index: linux-2.6.24-rc3/drivers/acpi/fan.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/acpi/fan.c
+++ linux-2.6.24-rc3/drivers/acpi/fan.c
@@ -248,22 +248,29 @@ static int acpi_fan_add(struct acpi_devi
 
 	cdev = thermal_cooling_device_register("Fan", device,
 						&fan_cooling_ops);
-	if (cdev)
+	if (IS_ERR(cdev)) {
+		result = PTR_ERR(cdev);
+		goto end;
+	}
+
+	if (cdev) {
 		printk(KERN_INFO PREFIX
 			"%s is registered as cooling_device%d\n",
 			device->dev.bus_id, cdev->id);
-	else
-		goto end;
-	acpi_driver_data(device) = cdev;
-	result = sysfs_create_link(&device->dev.kobj,
&cdev->device.kobj,
-					"thermal_cooling");
-	if (result)
-		return result;
 
-	result = sysfs_create_link(&cdev->device.kobj,
&device->dev.kobj,
-                                       "device");
-        if (result)
-                return result;
+		acpi_driver_data(device) = cdev;
+		result = sysfs_create_link(&device->dev.kobj,
+					   &cdev->device.kobj,
+					   "thermal_cooling");
+		if (result)
+			return result;
+
+		result = sysfs_create_link(&cdev->device.kobj,
+					   &device->dev.kobj,
+					   "device");
+		if (result)
+			return result;
+	}
 
 	result = acpi_fan_add_fs(device);
 	if (result)
Index: linux-2.6.24-rc3/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/acpi/processor_core.c
+++ linux-2.6.24-rc3/drivers/acpi/processor_core.c
@@ -670,21 +670,27 @@ static int __cpuinit acpi_processor_star
 
 	pr->cdev = thermal_cooling_device_register("Processor", device,
 						&processor_cooling_ops);
-	if (pr->cdev)
-		printk(KERN_INFO PREFIX
-			"%s is registered as cooling_device%d\n",
-			device->dev.bus_id, pr->cdev->id);
-	else
+	if (IS_ERR(pr->cdev)) {
+		result = PTR_ERR(pr->cdev);
 		goto end;
+	}
 
-	result = sysfs_create_link(&device->dev.kobj,
&pr->cdev->device.kobj,
-					"thermal_cooling");
-	if (result)
-		return result;
-	result = sysfs_create_link(&pr->cdev->device.kobj,
&device->dev.kobj,
-					"device");
-	if (result)
-		return result;
+	if (pr->cdev) {
+		printk(KERN_INFO PREFIX
+		       "%s is registered as cooling_device%d\n",
+		       device->dev.bus_id, pr->cdev->id);
+
+		result = sysfs_create_link(&device->dev.kobj,
+					   &pr->cdev->device.kobj,
+					   "thermal_cooling");
+		if (result)
+			return result;
+		result = sysfs_create_link(&pr->cdev->device.kobj,
+					   &device->dev.kobj,
+					   "device");
+		if (result)
+			return result;
+	}
 
 	if (pr->flags.throttling) {
 		printk(KERN_INFO PREFIX "%s [%s] (supports",
Index: linux-2.6.24-rc3/drivers/acpi/video.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/acpi/video.c
+++ linux-2.6.24-rc3/drivers/acpi/video.c
@@ -720,6 +720,10 @@ static void acpi_video_device_find_cap(s
 
 		device->cdev = thermal_cooling_device_register("LCD",
 					device->dev,
&video_cooling_ops);
+
+		if (IS_ERR(device->cdev))
+			return;
+
 		if (device->cdev) {
 			printk(KERN_INFO PREFIX
 				"%s is registered as
cooling_device%d\n",
Index: linux-2.6.24-rc3/drivers/misc/intel_menlow.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/misc/intel_menlow.c
+++ linux-2.6.24-rc3/drivers/misc/intel_menlow.c
@@ -172,10 +172,14 @@ static int intel_menlow_memory_add(struc
 
 	cdev = thermal_cooling_device_register("Memory controller",
device,
 					       &memory_cooling_ops);
-	acpi_driver_data(device) = cdev;
-	if (!cdev)
-		result = -ENODEV;
-	else {
+
+	if (IS_ERR(cdev)) {
+		result = PTR_ERR(cdev);
+		goto end;
+	}
+
+	if (cdev) {
+		acpi_driver_data(device) = cdev;
 		result =
 		    sysfs_create_link(&device->dev.kobj,
&cdev->device.kobj,
 				      "thermal_cooling");
Index: linux-2.6.24-rc3/include/linux/thermal.h
===================================================================
--- linux-2.6.24-rc3.orig/include/linux/thermal.h
+++ linux-2.6.24-rc3/include/linux/thermal.h
@@ -80,8 +80,9 @@ struct thermal_zone_device {
 	struct list_head node;
 };
 
-struct thermal_zone_device *thermal_zone_device_register(char *, int,
void *,
-					struct thermal_zone_device_ops
*);
+struct thermal_zone_device
+*thermal_zone_device_register(char *, int, void *,
+			      struct thermal_zone_device_ops *ops);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
 
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
@@ -89,8 +90,22 @@ int thermal_zone_bind_cooling_device(str
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *,
int,
 				       struct thermal_cooling_device *);
 
-struct thermal_cooling_device *thermal_cooling_device_register(char *,
void *,
-					struct
thermal_cooling_device_ops *);
+#ifdef	CONFIG_THERMAL
+struct thermal_cooling_device
+*thermal_cooling_device_register(char *, void *,
+				 struct thermal_cooling_device_ops
*ops);
 void thermal_cooling_device_unregister(struct thermal_cooling_device
*);
+#else
+static inline struct thermal_cooling_device
+*thermal_cooling_device_register(char *c, void *v,
+				 struct thermal_cooling_device_ops *t)
+{
+	return NULL;
+}
+static inline
+    void thermal_cooling_device_unregister(struct
thermal_cooling_device *t)
+{
+};
+#endif
 
-#endif				/* __THERMAL_H__ */
+#endif /* __THERMAL_H__ */
