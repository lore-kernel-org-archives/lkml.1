Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbXLZCDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbXLZCDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 21:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXLZCDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 21:03:39 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:56256 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXLZCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 21:03:38 -0500
Date: Wed, 26 Dec 2007 02:03:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com
Message-ID: <20071226020325.GA21099@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Rationalise ACPI backlight implementation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs backlight class provides no mechanism for querying the 
acceptable brightness for a backlight. The ACPI spec states that values 
are only valid if they are reported as available by the firmware. Since 
we can't provide that information to userspace, instead collapse the 
range to the number of actual values that can be set.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

---

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 521645e..12b2adb 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -296,18 +296,26 @@ static int acpi_video_device_set_state(struct acpi_video_device *device, int sta
 static int acpi_video_get_brightness(struct backlight_device *bd)
 {
 	unsigned long cur_level;
+	int i;
 	struct acpi_video_device *vd =
 		(struct acpi_video_device *)bl_get_data(bd);
 	acpi_video_device_lcd_get_level_current(vd, &cur_level);
-	return (int) cur_level;
+	for (i=2; i<vd->brightness->count; i++) {
+		if (vd->brightness->levels[i] == cur_level)
+			/* The first two entries are special - see page 575
+			   of the ACPI spec 3.0 */
+			return i-2;
+	}
+	return 0;
 }
 
 static int acpi_video_set_brightness(struct backlight_device *bd)
 {
-	int request_level = bd->props.brightness;
+	int request_level = bd->props.brightness+2;
 	struct acpi_video_device *vd =
 		(struct acpi_video_device *)bl_get_data(bd);
-	acpi_video_device_lcd_set_level(vd, request_level);
+	acpi_video_device_lcd_set_level(vd, 
+					vd->brightness->levels[request_level]);
 	return 0;
 }
 
@@ -656,7 +664,6 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 	kfree(obj);
 
 	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
-		unsigned long tmp;
 		static int count = 0;
 		char *name;
 		name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
@@ -664,11 +671,10 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 			return;
 
 		sprintf(name, "acpi_video%d", count++);
-		acpi_video_device_lcd_get_level_current(device, &tmp);
 		device->backlight = backlight_device_register(name,
 			NULL, device, &acpi_backlight_ops);
-		device->backlight->props.max_brightness = max_level;
-		device->backlight->props.brightness = (int)tmp;
+		device->backlight->props.max_brightness = device->brightness->count-3;
+		device->backlight->props.brightness = acpi_video_get_brightness(device->backlight);
 		backlight_update_status(device->backlight);
 
 		kfree(name);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
