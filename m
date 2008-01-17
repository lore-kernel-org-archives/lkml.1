Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYAQHro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYAQHro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYAQHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:43007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbYAQHqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:06 -0500
X-ExtLoop1: 1
Subject: [PATCH 7/10] ACPI: attach thermal zone info
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:21 +0800
Message-Id: <1200556281.2935.121.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Intel menlow driver needs to get the pointer of themal_zone_device
structure of an ACPI thermal zone.
Attach this to each ACPI thermal zone device object.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/bus.c      |   25 +++++++++++++++++++++++++
 drivers/acpi/thermal.c  |   11 +++++++++++
 include/acpi/acpi_bus.h |    2 ++
 3 files changed, 38 insertions(+)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -122,6 +122,31 @@ int acpi_bus_get_status(struct acpi_devi
 
 EXPORT_SYMBOL(acpi_bus_get_status);
 
+void acpi_bus_private_data_handler(acpi_handle handle,
+				   u32 function, void *context)
+{
+	return;
+}
+EXPORT_SYMBOL(acpi_bus_private_data_handler);
+
+int acpi_bus_get_private_data(acpi_handle handle, void **data)
+{
+	acpi_status status = AE_OK;
+
+	if (!*data)
+		return -EINVAL;
+
+	status = acpi_get_data(handle, acpi_bus_private_data_handler, data);
+	if (ACPI_FAILURE(status) || !*data) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
+				handle));
+		return -ENODEV;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_bus_get_private_data);
+
 /* --------------------------------------------------------------------------
                                  Power Management
    -------------------------------------------------------------------------- */
Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -1101,6 +1101,7 @@ static int acpi_thermal_register_thermal
 {
 	int trips = 0;
 	int result;
+	acpi_status status;
 	int i;
 
 	if (tz->trips.critical.flags.valid)
@@ -1129,6 +1130,15 @@ static int acpi_thermal_register_thermal
 	if (result)
 		return result;
 
+	status = acpi_attach_data(tz->device->handle,
+				  acpi_bus_private_data_handler,
+				  tz->thermal_zone);
+	if (ACPI_FAILURE(status)) {
+		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
+				"Error attaching device data\n"));
+		return -ENODEV;
+	}
+
 	tz->tz_enabled = 1;
 
 	printk(KERN_INFO PREFIX "%s is registered as thermal_zone%d\n",
@@ -1142,6 +1152,7 @@ static void acpi_thermal_unregister_ther
 	sysfs_remove_link(&tz->thermal_zone->device.kobj, "device");
 	thermal_zone_device_unregister(tz->thermal_zone);
 	tz->thermal_zone = NULL;
+	acpi_detach_data(tz->device->handle, acpi_bus_private_data_handler);
 }
 
 
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -320,6 +320,8 @@ struct acpi_bus_event {
 
 extern struct kset acpi_subsys;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
+void acpi_bus_private_data_handler(acpi_handle, u32, void *);
+int acpi_bus_get_private_data(acpi_handle, void **);
 /*
  * External Functions
  */


