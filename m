Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZDVTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZDVTXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZDVTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:23:29 -0400
Received: from mail.tpi.com ([70.99.223.143]:2007 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZDVTX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:23:28 -0400
To: malattia@linux.it
Subject: [PATCH v2] Sony laptop: Sony Vaio laptops do not enable wwan power by default.
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20090422192327.22438F88CE@sepang.rtg.net>
Date: Wed, 22 Apr 2009 13:23:27 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mattia,

Ok, it would help if I sent a patch against the right kernel (2.6.30-rc3).

rtg
--------------------
>From f24d04392307d990fcc9a46721c8494effee58c9 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 21 Apr 2009 11:09:10 -0600
Subject: [PATCH v2] UBUNTU: Sony laptop: Sony Vaio laptops do not enable wwan power by default.

Bug: https://bugs.launchpad.net/bugs/364678

Added quirk to enable wwan power based on DMI information already present in the module.
It appears that Vaio's do not enable power to wwan from a cold boot.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/platform/x86/sony-laptop.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index d3c92d7..74ab174 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1440,10 +1440,13 @@ struct device_ctrl {
 	u16				evport_offset;
 	u8				has_camera;
 	u8				has_bluetooth;
-	u8				has_wwan;
 	struct sonypi_eventtypes	*event_types;
 };
 
+struct sony_pic_quirk_entry {
+	u8				set_wwan_power;
+};
+
 struct sony_pic_dev {
 	struct device_ctrl	*control;
 	struct acpi_device	*acpi_dev;
@@ -1452,6 +1455,7 @@ struct sony_pic_dev {
 	struct list_head	interrupts;
 	struct list_head	ioports;
 	struct mutex		lock;
+	struct sony_pic_quirk_entry *quirks;
 	u8			camera_power;
 	u8			bluetooth_power;
 	u8			wwan_power;
@@ -2885,6 +2889,12 @@ static int sony_pic_add(struct acpi_device *device)
 	if (result)
 		goto err_remove_pf;
 
+	if (spic_dev.quirks && spic_dev.quirks->set_wwan_power) {
+		/*
+		 * Power isn't enabled by default.
+		 */
+		__sony_pic_set_wwanpower(1);
+	}
 	return 0;
 
 err_remove_pf:
@@ -2955,6 +2965,16 @@ static struct acpi_driver sony_pic_driver = {
 		},
 };
 
+static struct sony_pic_quirk_entry sony_pic_vaio_vgn = {
+	.set_wwan_power = 1,
+};
+
+static int dmi_matched(const struct dmi_system_id *dmi)
+{
+	spic_dev.quirks = dmi->driver_data;
+	return 0;
+}
+
 static struct dmi_system_id __initdata sonypi_dmi_table[] = {
 	{
 		.ident = "Sony Vaio",
@@ -2969,6 +2989,8 @@ static struct dmi_system_id __initdata sonypi_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-"),
 		},
+		.callback = dmi_matched,
+		.driver_data = &sony_pic_vaio_vgn,
 	},
 	{ }
 };
-- 
1.5.6.3

