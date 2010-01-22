Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318Ab0AVXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0AVXAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196Ab0AVXAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:00:51 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:43690 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0AVXAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:00:50 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-acpi@vger.kernel.org
Cc: don@syst.com.br, len.brown@intel.com, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] classmate-laptop: use a single MODULE_DEVICE_TABLE to get correct aliases
Date: Fri, 22 Jan 2010 20:57:33 -0200
Message-Id: <1264201053-14161-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of a MODULE_DEVICE_TABLE for every acpi_driver ids table, we
create a table containing all ids to export to get a module alias for
each one.

This will fix automatic loading of the driver when one of the ACPI
devices is not present (like the accelerometer, which is not present in
some models).

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/platform/x86/classmate-laptop.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index ed90082..8cb20e4 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -34,6 +34,11 @@ struct cmpc_accel {
 #define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
 
 
+#define CMPC_ACCEL_HID		"ACCE0000"
+#define CMPC_TABLET_HID		"TBLT0000"
+#define CMPC_BL_HID		"IPML200"
+#define CMPC_KEYS_HID		"FnBT0000"
+
 /*
  * Generic input device code.
  */
@@ -282,10 +287,9 @@ static int cmpc_accel_remove(struct acpi_device *acpi, int type)
 }
 
 static const struct acpi_device_id cmpc_accel_device_ids[] = {
-	{"ACCE0000", 0},
+	{CMPC_ACCEL_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
 
 static struct acpi_driver cmpc_accel_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -366,10 +370,9 @@ static int cmpc_tablet_resume(struct acpi_device *acpi)
 }
 
 static const struct acpi_device_id cmpc_tablet_device_ids[] = {
-	{"TBLT0000", 0},
+	{CMPC_TABLET_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
 
 static struct acpi_driver cmpc_tablet_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -477,17 +480,16 @@ static int cmpc_bl_remove(struct acpi_device *acpi, int type)
 	return 0;
 }
 
-static const struct acpi_device_id cmpc_device_ids[] = {
-	{"IPML200", 0},
+static const struct acpi_device_id cmpc_bl_device_ids[] = {
+	{CMPC_BL_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
 
 static struct acpi_driver cmpc_bl_acpi_driver = {
 	.owner = THIS_MODULE,
 	.name = "cmpc",
 	.class = "cmpc",
-	.ids = cmpc_device_ids,
+	.ids = cmpc_bl_device_ids,
 	.ops = {
 		.add = cmpc_bl_add,
 		.remove = cmpc_bl_remove
@@ -540,10 +542,9 @@ static int cmpc_keys_remove(struct acpi_device *acpi, int type)
 }
 
 static const struct acpi_device_id cmpc_keys_device_ids[] = {
-	{"FnBT0000", 0},
+	{CMPC_KEYS_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
 
 static struct acpi_driver cmpc_keys_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -607,3 +608,13 @@ static void cmpc_exit(void)
 
 module_init(cmpc_init);
 module_exit(cmpc_exit);
+
+static const struct acpi_device_id cmpc_device_ids[] = {
+	{CMPC_ACCEL_HID, 0},
+	{CMPC_TABLET_HID, 0},
+	{CMPC_BL_HID, 0},
+	{CMPC_KEYS_HID, 0},
+	{"", 0}
+};
+
+MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
-- 
1.6.6

