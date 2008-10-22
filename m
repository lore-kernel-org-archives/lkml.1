Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYJVK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYJVK13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYJVK1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:27:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38280 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYJVK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:27:14 -0400
Date: Wed, 22 Oct 2008 12:27:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-ID: <20081022102713.GA7843@atrey.karlin.mff.cuni.cz>
References: <48FA3368.1040605@tremplin-utc.net> <20081021083822.GG15782@atrey.karlin.mff.cuni.cz> <20081021114255.a7dabc2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114255.a7dabc2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 21 Oct 2008 10:38:22 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > Here is a submission for 2.6.28 of a driver for the ST LIS3LV02Dx
> > > accelerometer, a device found in various laptops (HP in particular) and
> > > embedded devices. It's the fourth iteration of what used to be called
> > > MDPS. I've now made the driver very simple, hoping to make it
> > > unobjectionable for acceptance :-)
> > 
> > Andrew, can you merge this one? It is simple enough, got some testing,
> > and can't really break anything...
> 
> It had a rather obvious and rather fatal bug.
> 
> What happened to that "given enough eyeballs" thing?

Ok, I guess you have better eyeballs. Yes, the locking was totaly
broken (and disabled by initing semaphore to 1 by default). Sorry
about that.

This strips some more code, turns semaphore into mutex, and should
solve more problems.

I killed the "power down on timer" thingie. I guess we can reintroduce
it when we get the basics right (and driver works just fine without
that... I did not detect unusual slowness).

									Pavel

--- linux/drivers/hwmon/lis3lv02d.c.ofic	2008-10-22 10:06:26.000000000 +0200
+++ linux/drivers/hwmon/lis3lv02d.c	2008-10-22 12:11:01.000000000 +0200
@@ -56,11 +56,6 @@
  * joystick.
  */
 
-/*
- * Automatic timeout to turn off the device in jiffies.
- * Don't do it too early as it's quite costly to turn it on.
- */
-#define MDPS_TIMEOUT msecs_to_jiffies(30 * 1000) /* 30 seconds */
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
@@ -75,13 +70,9 @@
 	u32			irq;       /* IRQ number */
 	struct input_dev	*idev;     /* input device */
 	struct task_struct	*kthread;  /* kthread for input */
-	struct timer_list	poff_timer; /* for automatic power off */
-	struct semaphore	poff_sem;  /* lock to handle on/off timer */
+	struct mutex		lock;	   /* lock to handle on/off timer */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
-	struct fasync_struct	*async_queue; /* queue for the misc device */
-	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
-	unsigned long		misc_opened; /* bit0: whether the device is open */
 	int			xcalib;    /* calibrated null value for x */
 	int			ycalib;    /* calibrated null value for y */
 	int			zcalib;    /* calibrated null value for z */
@@ -90,12 +81,8 @@
 	struct axis_conversion	ac;        /* hw -> logical axis */
 };
 
-static struct acpi_lis3lv02d adev = {
-	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
-	.poff_sem   = __SEMAPHORE_INITIALIZER(adev.poff_sem, 1),
-	.usage       = 0,
-	.misc_opened = 0,
-};
+static struct acpi_lis3lv02d adev;
+
 
 static int lis3lv02d_remove_fs(void);
 static int lis3lv02d_add_fs(struct acpi_device *device);
@@ -162,23 +149,6 @@
 	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
 }
 
-/*
- * Write a 16 bit word on a pair of registers
- * @handle the handle of the device
- * @reg the low register to write to
- * @val the value to write
- *
- * Returns AE_OK on success
- */
-static acpi_status lis3lv02d_write_16(acpi_handle handle, int reg, s16 val)
-{
-	acpi_status ret;
-	ret = lis3lv02d_acpi_write(handle, reg, val & 0xff);
-	if (ret != AE_OK)
-		return ret;
-	return lis3lv02d_acpi_write(handle, reg + 1, (val >> 8) & 0xff);
-}
-
 static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
@@ -246,17 +216,6 @@
 	lis3lv02d_acpi_read(handle, CTRL_REG2, &val);
 	val |= CTRL2_BDU | CTRL2_IEN;
 	lis3lv02d_acpi_write(handle, CTRL_REG2, val);
-	if (test_bit(0, &adev.misc_opened)) {
-		/* Threshold not too big (10) */
-		lis3lv02d_write_16(handle, FF_WU_THS_L, 10);
-		/* 2 samples in a row before activation */
-		lis3lv02d_acpi_write(handle, FF_WU_DURATION, 2);
-		/* detect every direction, don't wait for validation */
-		lis3lv02d_acpi_write(handle, FF_WU_CFG, FF_WU_CFG_AOI
-					| FF_WU_CFG_XLIE | FF_WU_CFG_XHIE
-					| FF_WU_CFG_YLIE | FF_WU_CFG_YHIE
-					| FF_WU_CFG_ZLIE | FF_WU_CFG_ZHIE);
-	}
 }
 
 #ifdef CONFIG_PM
@@ -266,7 +225,6 @@
 	lis3lv02d_poweroff(device->handle);
 	return 0;
 }
-#endif
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
@@ -274,6 +232,11 @@
 	printk(KERN_INFO DRIVER_NAME " Resuming device\n");
 	return 0;
 }
+#else
+#define lis3lv02d_suspend NULL
+#define lis3lv02d_resume NULL
+#endif
+
 
 /*
  * To be called before starting to use the device. It makes sure that the
@@ -282,14 +245,13 @@
  */
 static void lis3lv02d_increase_use(struct acpi_lis3lv02d *dev)
 {
-	down(&dev->poff_sem);
+	mutex_lock(&dev->lock);
 	dev->usage++;
 	if (dev->usage == 1) {
-		del_timer(&dev->poff_timer);
 		if (!dev->is_on)
 			lis3lv02d_poweron(dev->device->handle);
 	}
-	up(&dev->poff_sem);
+	mutex_unlock(&dev->lock);
 }
 
 /*
@@ -298,20 +260,11 @@
  */
 static void lis3lv02d_decrease_use(struct acpi_lis3lv02d *dev)
 {
-	up(&dev->poff_sem);
+	mutex_lock(&dev->lock);
 	dev->usage--;
 	if (dev->usage == 0)
-		mod_timer(&dev->poff_timer, jiffies + MDPS_TIMEOUT);
-	down(&dev->poff_sem);
-}
-
-static void lis3lv02d_poweroff_timeout(unsigned long data)
-{
-	struct acpi_lis3lv02d *dev = (void *)data;
-	up(&dev->poff_sem);
-	lis3lv02d_poweroff(dev->device->handle);
-	down(&dev->poff_sem);
-	printk(KERN_DEBUG DRIVER_NAME ": Turning off the device\n");
+		lis3lv02d_poweroff(dev->device->handle);
+	mutex_unlock(&dev->lock);
 }
 
 /**
@@ -435,9 +388,8 @@
  */
 static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 {
+	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev->device);
-	setup_timer(&dev->poff_timer, lis3lv02d_poweroff_timeout, (unsigned long)dev);
-	init_timer_deferrable(&dev->poff_timer);
 	lis3lv02d_increase_use(dev);
 
 	if (lis3lv02d_joystick_enable())
@@ -507,7 +459,7 @@
 	adev.device = device;
 	strcpy(acpi_device_name(device), DRIVER_NAME);
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	acpi_driver_data(device) = &adev;
+	device->driver_data = &adev;
 
 	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
 
@@ -533,7 +485,6 @@
 		return -EINVAL;
 
 	lis3lv02d_joystick_disable();
-	del_timer(&adev.poff_timer);
 	lis3lv02d_poweroff(device->handle);
 
 	return lis3lv02d_remove_fs();
@@ -623,10 +574,8 @@
 	.ops = {
 		.add     = lis3lv02d_add,
 		.remove  = lis3lv02d_remove,
-#ifdef CONFIG_PM
 		.suspend = lis3lv02d_suspend,
-		.resume  = lis3lv02d_resume
-#endif
+		.resume  = lis3lv02d_resume,
 	}
 };
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
