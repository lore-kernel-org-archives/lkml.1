Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYKVMft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYKVMft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYKVMfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:35:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48030 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757704AbYKVMfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:35:38 -0500
Date: Sat, 22 Nov 2008 13:35:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: ?ric Piel <eric.piel@tremplin-utc.net>, pavel@suse.cz
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trenn@suse.de, rpurdie@rpsys.net, hmh@hmh.eng.br
Subject: Re: [PATCH 1/2] LIS3LV02D: separate the core from HP ACPI API
Message-ID: <20081122123526.GA1990@ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz> <20081121160022.86020953.akpm@linux-foundation.org> <49275194.6070604@tremplin-utc.net> <492757A8.6010509@tremplin-utc.net> <49275870.7050900@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49275870.7050900@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-22 01:55:12, ?ric Piel wrote:
> 
> The sensor can be accessed via various buses. In particular, SPI, I?C
> and, on HP laptops, via a specific ACPI API (the only one currently
> supported). Separate this latest platform from the core of the sensor
> driver to allow support for the other bus type. The second, and more
> direct goal is actually to be able to merge this part with the
> hp-disk-leds driver, which has the same ACPI PNP number.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

Oops, I sent wrong patch. This should fix the 'compile as module'
problems...

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff -ur ../l/READ-ONLY/linux/drivers/hwmon/hp_accel.c linux-mm/drivers/hwmon/hp_accel.c
--- ../l/READ-ONLY/linux/drivers/hwmon/hp_accel.c	2008-11-21 14:28:39.000000000 +0100
+++ linux-mm/drivers/hwmon/hp_accel.c	2008-11-10 09:11:40.000000000 +0100
@@ -189,6 +189,9 @@
 		return -EINVAL;
 
 	adev.device = device;
+	adev.init = lis3lv02d_acpi_init;
+	adev.read = lis3lv02d_acpi_read;
+	adev.write = lis3lv02d_acpi_write;
 	strcpy(acpi_device_name(device), DRIVER_NAME);
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
 	device->driver_data = &adev;
--- ../l/READ-ONLY/linux/drivers/hwmon/lis3lv02d.c	2008-11-21 14:28:33.000000000 +0100
+++ linux-mm/drivers/hwmon/lis3lv02d.c	2008-11-06 12:27:27.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/freezer.h>
+#include <linux/version.h>
 #include <linux/uaccess.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
@@ -67,8 +68,8 @@
 {
 	u8 lo, hi;
 
-	lis3lv02d_acpi_read(handle, reg, &lo);
-	lis3lv02d_acpi_read(handle, reg + 1, &hi);
+	adev.read(handle, reg, &lo);
+	adev.read(handle, reg + 1, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -114,7 +115,7 @@
 {
 	adev.is_on = 0;
 	/* disable X,Y,Z axis and power down */
-	lis3lv02d_acpi_write(handle, CTRL_REG1, 0x00);
+	adev.write(handle, CTRL_REG1, 0x00);
 }
 
 void lis3lv02d_poweron(acpi_handle handle)
@@ -122,16 +123,16 @@
 	u8 val;
 
 	adev.is_on = 1;
-	lis3lv02d_acpi_init(handle);
-	lis3lv02d_acpi_write(handle, FF_WU_CFG, 0);
+	adev.init(handle);
+	adev.write(handle, FF_WU_CFG, 0);
 	/*
 	 * BDU: LSB and MSB values are not updated until both have been read.
 	 *      So the value read will always be correct.
 	 * IEN: Interrupt for free-fall and DD, not for data-ready.
 	 */
-	lis3lv02d_acpi_read(handle, CTRL_REG2, &val);
+	adev.read(handle, CTRL_REG2, &val);
 	val |= CTRL2_BDU | CTRL2_IEN;
-	lis3lv02d_acpi_write(handle, CTRL_REG2, val);
+	adev.write(handle, CTRL_REG2, val);
 }
 
 
@@ -313,7 +314,7 @@
 	int val;
 
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -355,3 +356,12 @@
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
 MODULE_AUTHOR("Yan Burman and Eric Piel");
 MODULE_LICENSE("GPL");
+
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
+EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
+EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
+
+EXPORT_SYMBOL_GPL(adev);
Only in ../l/READ-ONLY/linux/drivers/hwmon/: lis3lv02d.c.orig
diff -ur ../l/READ-ONLY/linux/drivers/hwmon/lis3lv02d.h linux-mm/drivers/hwmon/lis3lv02d.h
--- ../l/READ-ONLY/linux/drivers/hwmon/lis3lv02d.h	2008-11-21 14:28:33.000000000 +0100
+++ linux-mm/drivers/hwmon/lis3lv02d.h	2008-11-06 12:24:05.000000000 +0100
@@ -148,8 +148,6 @@
 };
 
 acpi_status lis3lv02d_acpi_init(acpi_handle handle);
-acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret);
-acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val);
 
 struct axis_conversion {
 	s8	x;
@@ -159,6 +157,10 @@
 
 struct acpi_lis3lv02d {
 	struct acpi_device	*device;   /* The ACPI device */
+	acpi_status (* init) (acpi_handle handle);
+	acpi_status (* write) (acpi_handle handle, int reg, u8 val);
+	acpi_status (* read) (acpi_handle handle, int reg, u8 *ret);
+
 	struct input_dev	*idev;     /* input device */
 	struct task_struct	*kthread;  /* kthread for input */
 	struct mutex            lock;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
