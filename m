Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZDVTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZDVTNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZDVTNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:13:42 -0400
Received: from mail.tpi.com ([70.99.223.143]:2807 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZDVTNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:13:41 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 15:13:41 EDT
To: malattia@linux.it
Subject: [PATCH] Sony laptop: Some Sony Vaia laptops do not enable wwan power by default.
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20090422185351.AB41AF88CE@sepang.rtg.net>
Date: Wed, 22 Apr 2009 12:53:51 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mattia,

Does this patch makes sense for just the Vaio? I've had positive feedback from
the tester in the bug report.

rtg
-----------------
>From 083972abb1d5e84845927b3925f077953c207b82 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 21 Apr 2009 11:09:10 -0600
Subject: [PATCH] Sony laptop: Some Sony Vaio laptops do not enable wwan power by default.

Bug: https://bugs.launchpad.net/bugs/364678

Added quirk to enable wwan power based on DMI information already present in the module.
It appears that wwan is not powered up from a cold boot.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/misc/sony-laptop.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 7e73acc..eab7011 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -1248,10 +1248,13 @@ struct device_ctrl {
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
@@ -1260,6 +1263,7 @@ struct sony_pic_dev {
 	struct list_head	interrupts;
 	struct list_head	ioports;
 	struct mutex		lock;
+	struct sony_pic_quirk_entry *quirks;
 	u8			camera_power;
 	u8			bluetooth_power;
 	u8			wwan_power;
@@ -2685,6 +2689,12 @@ static int sony_pic_add(struct acpi_device *device)
 	if (result)
 		goto err_remove_pf;
 
+	if (spic_dev.quirks && spic_dev.quirks->set_wwan_power) {
+		/*
+		 * Power isn't enabled by default.
+		 */
+		sony_pic_set_wwanpower(1);
+	}
 	return 0;
 
 err_remove_pf:
@@ -2755,6 +2765,16 @@ static struct acpi_driver sony_pic_driver = {
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
@@ -2769,6 +2789,8 @@ static struct dmi_system_id __initdata sonypi_dmi_table[] = {
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

