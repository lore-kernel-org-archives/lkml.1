Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYKFMOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYKFMOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYKFMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:14:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52983 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753326AbYKFMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:14:14 -0500
Date: Thu, 6 Nov 2008 13:14:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, burman.yan@gmail.com,
       rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Kay Sievers <kasievers@suse.de>,
       hmh@hmh.eng.br
Subject: Re: leds-hp-disk vs lis3lv02d
Message-ID: <20081106121405.GA1601@ucw.cz>
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <4902F817.4050108@tremplin-utc.net> <20081026174023.GA1847@ucw.cz> <200810271345.04961.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810271345.04961.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I think I talked too fast: it seems impossible to have both drivers
> > > (leds-hp-disk and lis3lv02d) working at the same time. Only the first
> > > driver loaded is used.
> > >
> > > After a little look at it, I think it comes from the fact that both
> > > drivers are assigned to the same MODALIAS (HPQ0004). The ACPI PNP
> > > (through the generic bus infrastructure) only declare the device to one
> > > of the drivers supporting it, not all of them.
> >
> > I can reproduce it here and it obviously needs fixing.
> These are the first ACPI drivers who register for the same ACPI Hardware ID.
> 
> > OTOH  it should 
> > not block merge; both drivers still work and are useful.
> But for long-term the HPQ0004 specific things in the lids3v driver should get 
> merged with your HP leds driver also registering for HPQ0004 and the lids3v 
> specific things should get a separate driver which HPQ0004 driver makes use 
> of?
> So in the end also for the HPQ0004 device only one driver should register for?

Yep... and this is the step in that direction. Relative to my previous
patch...

Later led stuff will get merged to hp_accel.c...

(Not for andrew, yet. I'd like basic support to get merged, first)
diff -ur clean-mm/drivers/hwmon/hp_accel.c linux-mm/drivers/hwmon/hp_accel.c
--- clean-mm/drivers/hwmon/hp_accel.c	2008-11-06 09:18:16.000000000 +0100
+++ linux-mm/drivers/hwmon/hp_accel.c	2008-11-06 12:26:03.000000000 +0100
@@ -163,6 +163,9 @@
 		return -EINVAL;
 
 	adev.device = device;
+	adev.init = lis3lv02d_acpi_init;
+	adev.read = lis3lv02d_acpi_read;
+	adev.write = lis3lv02d_acpi_write;
 	strcpy(acpi_device_name(device), DRIVER_NAME);
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
 	device->driver_data = &adev;
@@ -259,3 +262,5 @@
 
 module_init(lis3lv02d_init_module);
 module_exit(lis3lv02d_exit_module);
+
+
diff -ur clean-mm/drivers/hwmon/lis3lv02d.c linux-mm/drivers/hwmon/lis3lv02d.c
--- clean-mm/drivers/hwmon/lis3lv02d.c	2008-11-06 09:18:16.000000000 +0100
+++ linux-mm/drivers/hwmon/lis3lv02d.c	2008-11-06 12:27:27.000000000 +0100
@@ -68,8 +68,8 @@
 {
 	u8 lo, hi;
 
-	lis3lv02d_acpi_read(handle, reg, &lo);
-	lis3lv02d_acpi_read(handle, reg + 1, &hi);
+	adev.read(handle, reg, &lo);
+	adev.read(handle, reg + 1, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -115,7 +115,7 @@
 {
 	adev.is_on = 0;
 	/* disable X,Y,Z axis and power down */
-	lis3lv02d_acpi_write(handle, CTRL_REG1, 0x00);
+	adev.write(handle, CTRL_REG1, 0x00);
 }
 
 void lis3lv02d_poweron(acpi_handle handle)
@@ -123,16 +123,16 @@
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
 
 
@@ -314,7 +314,7 @@
 	int val;
 
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -356,3 +356,12 @@
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
diff -ur clean-mm/drivers/hwmon/lis3lv02d.h linux-mm/drivers/hwmon/lis3lv02d.h
--- clean-mm/drivers/hwmon/lis3lv02d.h	2008-11-06 09:18:16.000000000 +0100
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
