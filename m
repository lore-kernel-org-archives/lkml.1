Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZBKBEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZBKBEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZBKBE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:04:26 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41644 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbZBKBEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=byFa7EAmXozNmfOAUsZKyqdIz2b8pQOO/+5CmnRHPxIYcS0kZCaWIj1ZRLEEkp28iq
         aeIp8sqmA3F8duTNloH6/fN/0gHkwbCaC+0+04x/G5RTcSMDVLGCNXOsKWIY5uKhW3fn
         tXWynq9T5Zb4IAMoSlLa8QTkFKZqQ9SSiWYCc=
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?=C3=89ric=20Piel?= <Eric.Piel@tremplin-utc.net>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: [PATCHv6] lis3lv02d: support both one- and two-byte sensors
Date: Wed, 11 Feb 2009 02:04:19 +0100
Message-Id: <1234314259-17922-1-git-send-email-giuseppe.bilotta@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.173.g5e148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sensors responding with 0x3B to WHO_AM_I only have one data register per
direction, thus returning a signed byte from the position which is
occupied by the MSB in sensors responding with 0x3A.

Since multiple sensors share the reply to WHO_AM_I, we rename the
defines to better indicate what they identify (family of single and
double precision sensors).

We support both kind of sensors by checking for the sensor type on init
and defining appropriate data-access routines and sensor limits (for the
joystick) depending on what we find.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
---
Same as v5, with a couple of renames to have simpler and more meaningful
names. The #define's for the LISxxxxx families have been renamed
according to the actual functional distinction, and the struct member
holding the data read function has been renamed to read_data.

 drivers/hwmon/hp_accel.c  |   37 ++++++++++++++++++++++++++++++++-----
 drivers/hwmon/lis3lv02d.c |   25 ++++++-------------------
 drivers/hwmon/lis3lv02d.h |   16 +++++++++++++---
 3 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index d71e4bd..6b3fc4d 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -238,9 +238,25 @@ static void lis3lv02d_enum_resources(struct acpi_device *device)
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
 
+static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
+{
+	u8 lo, hi;
+
+	adev.read(handle, reg - 1, &lo);
+	adev.read(handle, reg, &hi);
+	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
+	return (s16)((hi << 8) | lo);
+}
+
+static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
+{
+	s8 lo;
+	adev.read(handle, reg, &lo);
+	return lo;
+}
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
-	u8 val;
 	int ret;
 
 	if (!device)
@@ -254,10 +270,21 @@ static int lis3lv02d_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
 	device->driver_data = &adev;
 
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
-	if ((val != LIS3LV02DL_ID) && (val != LIS302DL_ID)) {
-		printk(KERN_ERR DRIVER_NAME
-				": Accelerometer chip not LIS3LV02D{L,Q}\n");
+	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &adev.whoami);
+	switch (adev.whoami) {
+		case LIS_DOUBLE_ID:
+			printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
+			adev.read_data = lis3lv02d_read_16;
+			adev.mdps_max_val = 2048;
+			break;
+		case LIS_SINGLE_ID:
+			printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+			adev.read_data = lis3lv02d_read_8;
+			adev.mdps_max_val = 128;
+			break;
+		default:
+			printk(KERN_ERR DRIVER_NAME
+				": unknown sensor type 0x%X\n", adev.whoami);
 	}
 
 	/* If possible use a "standard" axes order */
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 3afa3af..8bb2158 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -53,9 +53,6 @@
  * joystick.
  */
 
-/* Maximum value our axis may get for the input device (signed 12 bits) */
-#define MDPS_MAX_VAL 2048
-
 struct acpi_lis3lv02d adev = {
 	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
 };
@@ -64,16 +61,6 @@ EXPORT_SYMBOL_GPL(adev);
 
 static int lis3lv02d_add_fs(struct acpi_device *device);
 
-static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
-{
-	u8 lo, hi;
-
-	adev.read(handle, reg, &lo);
-	adev.read(handle, reg + 1, &hi);
-	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
-	return (s16)((hi << 8) | lo);
-}
-
 /**
  * lis3lv02d_get_axis - For the given axis, give the value converted
  * @axis:      1,2,3 - can also be negative
@@ -102,9 +89,9 @@ static void lis3lv02d_get_xyz(acpi_handle handle, int *x, int *y, int *z)
 {
 	int position[3];
 
-	position[0] = lis3lv02d_read_16(handle, OUTX_L);
-	position[1] = lis3lv02d_read_16(handle, OUTY_L);
-	position[2] = lis3lv02d_read_16(handle, OUTZ_L);
+	position[0] = adev.read_data(handle, OUTX);
+	position[1] = adev.read_data(handle, OUTY);
+	position[2] = adev.read_data(handle, OUTZ);
 
 	*x = lis3lv02d_get_axis(adev.ac.x, position);
 	*y = lis3lv02d_get_axis(adev.ac.y, position);
@@ -355,9 +342,9 @@ int lis3lv02d_joystick_enable(void)
 	adev.idev->close      = lis3lv02d_joystick_close;
 
 	set_bit(EV_ABS, adev.idev->evbit);
-	input_set_abs_params(adev.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
-	input_set_abs_params(adev.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
-	input_set_abs_params(adev.idev, ABS_Z, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
+	input_set_abs_params(adev.idev, ABS_X, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Y, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Z, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
 
 	err = input_register_device(adev.idev);
 	if (err) {
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 2e7597c..75972bf 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -22,12 +22,15 @@
 /*
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
  * be connected via SPI. There exists also several similar chips (such as LIS302DL or
- * LIS3L02DQ) but not in the HP laptops and they have slightly different registers.
+ * LIS3L02DQ) and they have slightly different registers, but we can provide a
+ * common interface for all of them.
  * They can also be connected via I²C.
  */
 
-#define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
-#define LIS302DL_ID	0x3B /* Also the LIS202DL! */
+/* 2-byte registers */
+#define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
+/* 1-byte registers */
+#define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
 
 enum lis3lv02d_reg {
 	WHO_AM_I	= 0x0F,
@@ -44,10 +47,13 @@ enum lis3lv02d_reg {
 	STATUS_REG	= 0x27,
 	OUTX_L		= 0x28,
 	OUTX_H		= 0x29,
+	OUTX		= 0x29,
 	OUTY_L		= 0x2A,
 	OUTY_H		= 0x2B,
+	OUTY		= 0x2B,
 	OUTZ_L		= 0x2C,
 	OUTZ_H		= 0x2D,
+	OUTZ		= 0x2D,
 	FF_WU_CFG	= 0x30,
 	FF_WU_SRC	= 0x31,
 	FF_WU_ACK	= 0x32,
@@ -159,6 +165,10 @@ struct acpi_lis3lv02d {
 	acpi_status (*write) (acpi_handle handle, int reg, u8 val);
 	acpi_status (*read) (acpi_handle handle, int reg, u8 *ret);
 
+	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */
+	s16 (*read_data) (acpi_handle handle, int reg);
+	int			mdps_max_val;
+
 	struct input_dev	*idev;     /* input device */
 	struct task_struct	*kthread;  /* kthread for input */
 	struct mutex            lock;
-- 
1.6.2.rc0.173.g5e148

