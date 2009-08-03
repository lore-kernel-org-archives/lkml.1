Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZHCJLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZHCJLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZHCJLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:11:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:11711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZHCJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:11:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,313,1246863600"; 
   d="scan'208";a="713389199"
Subject: [PATCH 3/3 RFC] ACPI: introduce ACPI ALS sysfs I/F
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:11:26 +0800
Message-Id: <1249290686.2670.254.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce ACPI ALS sysfs I/F.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Kconfig |    1 
 drivers/acpi/als.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 49 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -336,6 +336,7 @@ config ACPI_SBS
 config ACPI_ALS
 	tristate "Ambient Light Sensor driver"
 	depends on X86
+	select ALS
 	help
 	  This driver supports the ACPI Ambient Light Sensor.
 
Index: linux-2.6/drivers/acpi/als.c
===================================================================
--- linux-2.6.orig/drivers/acpi/als.c
+++ linux-2.6/drivers/acpi/als.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/als_sys.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -75,11 +76,6 @@ struct als_cap {
 	u8 _ALP:1;
 };
 
-struct als_mapping {
-	int adjustment;
-	int illuminance;
-};
-
 struct acpi_als {
 	struct acpi_device *device;
 	struct als_cap cap;
@@ -87,6 +83,7 @@ struct acpi_als {
 	int chromaticity;
 	int temperature;
 	int polling;
+	struct als_device *als;
 	int count;
 	struct als_mapping *mappings;
 };
@@ -281,6 +278,35 @@ static int acpi_als_find_cap(struct acpi
 }
 
 /* --------------------------------------------------------------------------
+				ALS sysfs I/F
+   -------------------------------------------------------------------------- */
+static int get_illuminance(struct als_device *als_sys)
+{
+	struct acpi_als *als = als_sys->devdata;
+	int result;
+
+	result = acpi_als_get_illuminance(als);
+	if (!result)
+		als_sys->illuminance = als->illuminance;
+	return result;
+}
+
+static int get_mappings(struct als_device *als_sys)
+{
+	struct acpi_als *als = als_sys->devdata;
+
+	als_sys->count = als->count;
+	als_sys->mappings = als->mappings;
+
+	return 0;
+}
+
+struct als_device_ops acpi_als_ops = {
+	.get_illuminance = get_illuminance,
+	.get_mappings = get_mappings,
+};
+
+/* --------------------------------------------------------------------------
 				 Driver Model
    -------------------------------------------------------------------------- */
 
@@ -316,7 +342,9 @@ static void acpi_als_notify(struct acpi_
 static int acpi_als_add(struct acpi_device *device)
 {
 	int result = 0;
+	acpi_status status;
 	struct acpi_als *als = NULL;
+	struct acpi_buffer name = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	if (!device)
 		return -EINVAL;
@@ -346,6 +374,20 @@ static int acpi_als_add(struct acpi_devi
 	acpi_als_get_color_chromaticity(als);
 	acpi_als_get_polling(als);
 
+	status = acpi_get_name(als->device->handle, ACPI_FULL_PATHNAME, &name);
+	if (ACPI_FAILURE(status)) {
+		result = -ENODEV;
+		goto end;
+	}
+
+	als->als = als_device_register(&acpi_als_ops, name.pointer, als);
+	if (IS_ERR(als->als)) {
+		result = -ENODEV;
+		if (als->mappings)
+			kfree(als->mappings);
+	}
+
+	kfree(name.pointer);
 end:
 	if (result)
 		kfree(als);
@@ -378,6 +420,7 @@ static int acpi_als_remove(struct acpi_d
 	if (!als)
 		return -EINVAL;
 
+	als_device_unregister(als->als);
 	if (als->mappings)
 		kfree(als->mappings);
 	kfree(als);


