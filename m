Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZGLGsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZGLGsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 02:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZGLGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 02:47:55 -0400
Received: from home.keithp.com ([63.227.221.253]:46010 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZGLGrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 02:47:55 -0400
From: keithp@keithp.com
To: rui.zhang@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       keithp@keithp.com
Subject: [PATCH 1/2] acpi: don't free non-existant backlight in acpi video module
Date: Sat, 11 Jul 2009 23:47:31 -0700
Message-Id: <1247381251-27031-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>

acpi_video_put_one_device was attempting to remove sysfs entries and
unregister a backlight device without first checking that said backlight
device structure had been created.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/acpi/video.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 8851315..60ea984 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -2004,8 +2004,11 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 	status = acpi_remove_notify_handler(device->dev->handle,
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
-	sysfs_remove_link(&device->backlight->dev.kobj, "device");
-	backlight_device_unregister(device->backlight);
+	if (device->backlight) {
+		sysfs_remove_link(&device->backlight->dev.kobj, "device");
+		backlight_device_unregister(device->backlight);
+		device->backlight = NULL;
+	}
 	if (device->cdev) {
 		sysfs_remove_link(&device->dev->dev.kobj,
 				  "thermal_cooling");
-- 
1.6.3.3

