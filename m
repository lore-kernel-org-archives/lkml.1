Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZJTXLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZJTXLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZJTXLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:11:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44544 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZJTXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:11:48 -0400
Date: Tue, 20 Oct 2009 16:11:49 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: crane.cai@amd.com, lenb@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH] i2c-scmi: Quirk to work on IBM machines with broken BIOSes
Message-ID: <20091020231149.GM26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some old IBM workstations and desktop computers, the BIOS presents in the
DSDT an SMBus object that is missing the HID identifier that the i2c-scmi
driver looks for.  It also omits the leading "_" in the method names (it should
be _SBR, not SBR_).  Modify the ACPI device scan code to insert the missing HID
if it finds an IBM system with such an object, and modify the i2c-scmi driver
to handle the odd method names.

Affected machines: IntelliStation Z20/Z30.  Note that the i2c-i801 driver no
longer works on these machines because of ACPI resource conflicts.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/acpi/scan.c           |   38 ++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-scmi.c |   49 ++++++++++++++++++++++++++++++++---------
 include/acpi/acpi_drivers.h   |    1 +
 3 files changed, 77 insertions(+), 11 deletions(-)


diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 14a7481..58cb324 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -8,6 +8,7 @@
 #include <linux/acpi.h>
 #include <linux/signal.h>
 #include <linux/kthread.h>
+#include <linux/dmi.h>
 
 #include <acpi/acpi_drivers.h>
 
@@ -1014,6 +1015,41 @@ static void acpi_add_id(struct acpi_device *device, const char *dev_id)
 	list_add_tail(&id->list, &device->pnp.ids);
 }
 
+/*
+ * Old IBM workstations have a DSDT bug wherein the SMBus object
+ * lacks the SMBUS01 HID and the methods do not have the necessary "_"
+ * prefix.  Work around this.
+ */
+static int probe_ibm_smbus_device(struct acpi_device *device)
+{
+	acpi_handle h_dummy;
+	struct acpi_buffer path = {ACPI_ALLOCATE_BUFFER, NULL};
+	int result;
+
+	if (!dmi_name_in_vendors("IBM"))
+		return -ENODEV;
+
+	/* Look for SMBS object */
+	result = acpi_get_name(device->handle, ACPI_SINGLE_NAME, &path);
+	if (result)
+		return result;
+
+	if (strcmp("SMBS", path.pointer)) {
+		result = -ENODEV;
+		goto out;
+	}
+
+	/* Does it have the necessary (but misnamed) methods? */
+	result = -ENODEV;
+	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "SBI", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(device->handle, "SBR", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(device->handle, "SBW", &h_dummy)))
+		result = 0;
+out:
+	kfree(path.pointer);
+	return result;
+}
+
 static void acpi_device_set_id(struct acpi_device *device)
 {
 	acpi_status status;
@@ -1064,6 +1100,8 @@ static void acpi_device_set_id(struct acpi_device *device)
 			acpi_add_id(device, ACPI_BAY_HID);
 		else if (ACPI_SUCCESS(acpi_dock_match(device)))
 			acpi_add_id(device, ACPI_DOCK_HID);
+		else if (!probe_ibm_smbus_device(device))
+			acpi_add_id(device, ACPI_SMBUS_HID);
 
 		break;
 	case ACPI_BUS_TYPE_POWER:
diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
index b4a55d4..f0ad03d 100644
--- a/drivers/i2c/busses/i2c-scmi.c
+++ b/drivers/i2c/busses/i2c-scmi.c
@@ -33,6 +33,7 @@ struct acpi_smbus_cmi {
 	u8 cap_info:1;
 	u8 cap_read:1;
 	u8 cap_write:1;
+	struct smbus_methods_t methods;
 };
 
 static const struct smbus_methods_t smbus_methods = {
@@ -41,8 +42,15 @@ static const struct smbus_methods_t smbus_methods = {
 	.mt_sbw  = "_SBW",
 };
 
+/* Some IBM BIOSes omit the leading underscore */
+static const struct smbus_methods_t ibm_smbus_methods = {
+	.mt_info = "SBI_",
+	.mt_sbr  = "SBR_",
+	.mt_sbw  = "SBW_",
+};
+
 static const struct acpi_device_id acpi_smbus_cmi_ids[] = {
-	{"SMBUS01", 0},
+	{ACPI_SMBUS_HID, 0},
 	{"", 0}
 };
 
@@ -150,11 +158,11 @@ acpi_smbus_cmi_access(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 
 	if (read_write == I2C_SMBUS_READ) {
 		protocol |= ACPI_SMBUS_PRTCL_READ;
-		method = smbus_methods.mt_sbr;
+		method = smbus_cmi->methods.mt_sbr;
 		input.count = 3;
 	} else {
 		protocol |= ACPI_SMBUS_PRTCL_WRITE;
-		method = smbus_methods.mt_sbw;
+		method = smbus_cmi->methods.mt_sbw;
 		input.count = 5;
 	}
 
@@ -283,20 +291,21 @@ static const struct i2c_algorithm acpi_smbus_cmi_algorithm = {
 };
 
 
-static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
-				  const char *name)
+static int acpi_smbus_cmi_probe_cap(struct acpi_smbus_cmi *smbus_cmi,
+				    const char *name,
+				    const struct smbus_methods_t *methods)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_status status;
 
-	if (!strcmp(name, smbus_methods.mt_info)) {
+	if (!strcmp(name, methods->mt_info)) {
 		status = acpi_evaluate_object(smbus_cmi->handle,
-					smbus_methods.mt_info,
+					methods->mt_info,
 					NULL, &buffer);
 		if (ACPI_FAILURE(status)) {
 			ACPI_ERROR((AE_INFO, "Evaluating %s: %i",
-				   smbus_methods.mt_info, status));
+				   methods->mt_info, status));
 			return -EIO;
 		}
 
@@ -319,17 +328,35 @@ static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
 
 		kfree(buffer.pointer);
 		smbus_cmi->cap_info = 1;
-	} else if (!strcmp(name, smbus_methods.mt_sbr))
+		smbus_cmi->methods.mt_info = methods->mt_info;
+	} else if (!strcmp(name, methods->mt_sbr)) {
 		smbus_cmi->cap_read = 1;
-	else if (!strcmp(name, smbus_methods.mt_sbw))
+		smbus_cmi->methods.mt_sbr = methods->mt_sbr;
+	} else if (!strcmp(name, methods->mt_sbw)) {
 		smbus_cmi->cap_write = 1;
-	else
+		smbus_cmi->methods.mt_sbw = methods->mt_sbw;
+	} else {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unsupported CMI method: %s\n",
 				 name));
+		return -ENODEV;
+	}
 
 	return 0;
 }
 
+static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
+				  const char *name)
+{
+	int res;
+
+	res = acpi_smbus_cmi_probe_cap(smbus_cmi, name, &smbus_methods);
+	if (!res)
+		return 0;
+
+	res = acpi_smbus_cmi_probe_cap(smbus_cmi, name, &ibm_smbus_methods);
+	return res;
+}
+
 static acpi_status acpi_smbus_cmi_query_methods(acpi_handle handle, u32 level,
 			void *context, void **return_value)
 {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f4906f6..c724a08 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -65,6 +65,7 @@
 #define ACPI_VIDEO_HID			"LNXVIDEO"
 #define ACPI_BAY_HID			"LNXIOBAY"
 #define ACPI_DOCK_HID			"LNXDOCK"
+#define ACPI_SMBUS_HID			"SMBUS01"
 
 /*
  * For fixed hardware buttons, we fabricate acpi_devices with HID
