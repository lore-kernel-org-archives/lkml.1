Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbZLDSNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbZLDSNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbZLDSND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:13:03 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41461 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbZLDSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:13:01 -0500
Date: Fri, 4 Dec 2009 10:13:00 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: lenb@kernel.org, Crane Cai <crane.cai@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: [RESEND PATCH v2 2/2] i2c-scmi: support IBM SMBus CMI devices
Message-ID: <20091204181300.GO10295@tux1.beaverton.ibm.com>
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

From: Crane Cai <crane.cai@amd.com>

*) add a new HID for IBM SMBus CMI devices
*) add methods for IBM SMBus CMI devices
*) hook different HID with different control methods set
*) minor tweaks as suggested by Jean Delvare

Slightly modified to use #define'd HID from Darrick's ACPI scan quirk patch.

Signed-off-by: Crane Cai <crane.cai@amd.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/i2c/busses/i2c-scmi.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)


diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
index b4a55d4..7860cbb 100644
--- a/drivers/i2c/busses/i2c-scmi.c
+++ b/drivers/i2c/busses/i2c-scmi.c
@@ -33,6 +33,7 @@ struct acpi_smbus_cmi {
 	u8 cap_info:1;
 	u8 cap_read:1;
 	u8 cap_write:1;
+	struct smbus_methods_t *methods;
 };
 
 static const struct smbus_methods_t smbus_methods = {
@@ -41,8 +42,16 @@ static const struct smbus_methods_t smbus_methods = {
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
+	{"SMBUS01", (kernel_ulong_t)&smbus_methods},
+	{ACPI_SMBUS_IBM_HID, (kernel_ulong_t)&ibm_smbus_methods},
 	{"", 0}
 };
 
@@ -150,11 +159,11 @@ acpi_smbus_cmi_access(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 
 	if (read_write == I2C_SMBUS_READ) {
 		protocol |= ACPI_SMBUS_PRTCL_READ;
-		method = smbus_methods.mt_sbr;
+		method = smbus_cmi->methods->mt_sbr;
 		input.count = 3;
 	} else {
 		protocol |= ACPI_SMBUS_PRTCL_WRITE;
-		method = smbus_methods.mt_sbw;
+		method = smbus_cmi->methods->mt_sbw;
 		input.count = 5;
 	}
 
@@ -290,13 +299,13 @@ static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
 	union acpi_object *obj;
 	acpi_status status;
 
-	if (!strcmp(name, smbus_methods.mt_info)) {
+	if (!strcmp(name, smbus_cmi->methods->mt_info)) {
 		status = acpi_evaluate_object(smbus_cmi->handle,
-					smbus_methods.mt_info,
+					smbus_cmi->methods->mt_info,
 					NULL, &buffer);
 		if (ACPI_FAILURE(status)) {
 			ACPI_ERROR((AE_INFO, "Evaluating %s: %i",
-				   smbus_methods.mt_info, status));
+				   smbus_cmi->methods->mt_info, status));
 			return -EIO;
 		}
 
@@ -319,9 +328,9 @@ static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
 
 		kfree(buffer.pointer);
 		smbus_cmi->cap_info = 1;
-	} else if (!strcmp(name, smbus_methods.mt_sbr))
+	} else if (!strcmp(name, smbus_cmi->methods->mt_sbr))
 		smbus_cmi->cap_read = 1;
-	else if (!strcmp(name, smbus_methods.mt_sbw))
+	else if (!strcmp(name, smbus_cmi->methods->mt_sbw))
 		smbus_cmi->cap_write = 1;
 	else
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unsupported CMI method: %s\n",
@@ -349,6 +358,7 @@ static acpi_status acpi_smbus_cmi_query_methods(acpi_handle handle, u32 level,
 static int acpi_smbus_cmi_add(struct acpi_device *device)
 {
 	struct acpi_smbus_cmi *smbus_cmi;
+	const struct acpi_device_id *id;
 
 	smbus_cmi = kzalloc(sizeof(struct acpi_smbus_cmi), GFP_KERNEL);
 	if (!smbus_cmi)
@@ -362,6 +372,11 @@ static int acpi_smbus_cmi_add(struct acpi_device *device)
 	smbus_cmi->cap_read = 0;
 	smbus_cmi->cap_write = 0;
 
+	for (id = acpi_smbus_cmi_ids; id->id[0]; id++)
+		if (!strcmp(id->id, acpi_device_hid(device)))
+			smbus_cmi->methods =
+				(struct smbus_methods_t *) id->driver_data;
+
 	acpi_walk_namespace(ACPI_TYPE_METHOD, smbus_cmi->handle, 1,
 			    acpi_smbus_cmi_query_methods, smbus_cmi, NULL);
 
