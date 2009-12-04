Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZLDSLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZLDSLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZLDSLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:11:04 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54687 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbZLDSLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:11:02 -0500
Date: Fri, 4 Dec 2009 10:11:03 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: lenb@kernel.org, Crane Cai <crane.cai@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: [RESEND PATCH v2 1/2] ACPI: Quirk to make SMBus objects work on
	IBM machines with broken BIOSes
Message-ID: <20091204181103.GN10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091027183619.16b0b952@hyperion.delvare> <20091204170621.GA10356@tux1.beaverton.ibm.com> <200912041036.36686.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912041036.36686.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some old IBM workstations and desktop computers, the BIOS presents in the
DSDT an SMBus object that is missing the HID identifier that the i2c-scmi
driver looks for.  Modify the ACPI device scan code to insert the missing HID
if it finds an IBM system with such an object.  This patch requires Crane Cai's
update to i2c-scmi to work around incorrectly named methods within the SMBus
control object.

Affected machines: ThinkCenter M52, IntelliStation Z20/Z30.  Note that the
i2c-i801 driver no longer works on these machines because of ACPI resource
conflicts.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/acpi/scan.c         |   38 ++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |    2 ++
 2 files changed, 40 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 14a7481..5a24429 100644
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
+static int acpi_ibm_smbus_match(struct acpi_device *device)
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
+		else if (!acpi_ibm_smbus_match(device))
+			acpi_add_id(device, ACPI_SMBUS_IBM_HID);
 
 		break;
 	case ACPI_BUS_TYPE_POWER:
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f4906f6..83a2960 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -65,6 +65,8 @@
 #define ACPI_VIDEO_HID			"LNXVIDEO"
 #define ACPI_BAY_HID			"LNXIOBAY"
 #define ACPI_DOCK_HID			"LNXDOCK"
+/* Quirk for broken IBM BIOSes */
+#define ACPI_SMBUS_IBM_HID		"SMBUSIBM"
 
 /*
  * For fixed hardware buttons, we fabricate acpi_devices with HID
