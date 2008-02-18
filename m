Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbYBRVEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbYBRVEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761745AbYBRVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbYBRVDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:43 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/4] make cdev attribuition the last step
Date: Mon, 18 Feb 2008 17:56:50 -0300
Message-Id: <1203368213-30528-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses a temporary variable "cdev" instead of using
directly pr->cdev. Through it, we can tell later whether or not
this code was completed properly: by checking for pr->cdev != NULL
Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 drivers/acpi/processor_core.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 75ccf5d..9480203 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -622,7 +622,7 @@ static int __cpuinit acpi_processor_star
 	int result = 0;
 	acpi_status status = AE_OK;
 	struct acpi_processor *pr;
-
+	struct thermal_cooling_device *cdev;
 
 	pr = acpi_driver_data(device);
 
@@ -668,24 +668,26 @@ #endif
 
 	acpi_processor_power_init(pr, device);
 
-	pr->cdev = thermal_cooling_device_register("Processor", device,
+	cdev = thermal_cooling_device_register("Processor", device,
 						&processor_cooling_ops);
-	if (pr->cdev)
+	if (cdev)
 		printk(KERN_INFO PREFIX
 			"%s is registered as cooling_device%d\n",
-			device->dev.bus_id, pr->cdev->id);
+			device->dev.bus_id, cdev->id);
 	else
 		goto end;
 
-	result = sysfs_create_link(&device->dev.kobj, &pr->cdev->device.kobj,
+	result = sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
 					"thermal_cooling");
 	if (result)
 		return result;
-	result = sysfs_create_link(&pr->cdev->device.kobj, &device->dev.kobj,
+	result = sysfs_create_link(&cdev->device.kobj, &device->dev.kobj,
 					"device");
 	if (result)
 		return result;
 
+	pr->cdev = cdev;
+
 	if (pr->flags.throttling) {
 		printk(KERN_INFO PREFIX "%s [%s] (supports",
 		       acpi_device_name(device), acpi_device_bid(device));
-- 
1.4.2

