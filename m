Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYAQHrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYAQHrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYAQHqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:43007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbYAQHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:00 -0500
X-ExtLoop1: 1
Subject: [PATCH 10/10] ACPI: thermal fixup
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:18 +0800
Message-Id: <1200556279.2935.119.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

The alias name may be used in _PSL, _ALx and _TZD,
so we bind the cooling device only if the acpi_device node matches.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/thermal.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -1015,7 +1015,9 @@ static int acpi_thermal_cooling_device_c
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_thermal *tz = thermal->devdata;
-	acpi_handle handle = device->handle;
+	struct acpi_device *dev;
+	acpi_status status;
+	acpi_handle handle;
 	int i;
 	int j;
 	int trip = -1;
@@ -1031,12 +1033,13 @@ static int acpi_thermal_cooling_device_c
 		trip++;
 		for (i = 0; i < tz->trips.passive.devices.count;
 		    i++) {
-			if (tz->trips.passive.devices.handles[i] !=
-				handle)
-				continue;
-			result = action(thermal, trip, cdev);
-			if (result)
-				goto failed;
+			handle = tz->trips.passive.devices.handles[i];
+			status = acpi_bus_get_device(handle, &dev);
+			if (ACPI_SUCCESS(status) && (dev == device)) {
+				result = action(thermal, trip, cdev);
+				if (result)
+					goto failed;
+			}
 		}
 	}
 
@@ -1047,21 +1050,24 @@ static int acpi_thermal_cooling_device_c
 		for (j = 0;
 		    j < tz->trips.active[i].devices.count;
 		    j++) {
-			if (tz->trips.active[i].devices.
-						handles[j] != handle)
-				continue;
-			result = action(thermal, trip, cdev);
-			if (result)
-				goto failed;
+			handle = tz->trips.active[i].devices.handles[j];
+			status = acpi_bus_get_device(handle, &dev);
+			if (ACPI_SUCCESS(status) && (dev == device)) {
+				result = action(thermal, trip, cdev);
+				if (result)
+					goto failed;
+			}
 		}
 	}
 
 	for (i = 0; i < tz->devices.count; i++) {
-		if (tz->devices.handles[i] != handle)
-			continue;
-		result = action(thermal, -1, cdev);
-		if (result)
-			goto failed;
+		handle = tz->devices.handles[i];
+		status = acpi_bus_get_device(handle, &dev);
+		if (ACPI_SUCCESS(status) && (dev == device)) {
+			result = action(thermal, -1, cdev);
+			if (result)
+				goto failed;
+		}
 	}
 
 failed:


