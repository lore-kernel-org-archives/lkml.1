Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYJOK6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYJOK6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYJOK6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:58:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJOK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:58:06 -0400
Date: Wed, 15 Oct 2008 12:58:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: lm-sensors@lm-sensors.org, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Yan Burman <burman.yan@gmail.com>
Subject: Re: Accelerometer driver for HP laptops
Message-ID: <20081015105805.GD4247@atrey.karlin.mff.cuni.cz>
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net> <20081015072511.GA20607@atrey.karlin.mff.cuni.cz> <48F5A0C8.1080102@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F5A0C8.1080102@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I took a look at the driver, and it seems to work for me... I'd like
> > to get it to the mainline...
> > 
> >>>> Attached is our work-in-progress version of the driver for a fourth take
> >>>> on the LKML (it used to be mdps). It works really fine, with lots of
> >>>> "goodies" (like automatically convert the axes to fit to a standard,
> >>>> automatic power-off of the device when not in used) excepted the
> >>>> interrupt support for free-fall detection.
> > 
> > I wonder if mdps was really a better name? Driver is HP-specific
> > (because of the ACPI usage), not really chip specific... and lis3lv02d
> > looks like an alphabet soup to me...
> > 
> > Ok, it is a bit chip-specific, too...
> Yes, the point is that several people got interested in adding to the
> driver SPI and I?C support last time I submitted the driver. I did my
> best to concentrate the ACPI stuff only to some 3 or 4 small functions,
> so that it can be be easily done.

Yes, I seen that. Nice.

> I've got already a changelog ready. Give me a couple of days to clean
> things up and I'll send it to akpm myself :-)

Ok, I'd like to help with cleaning... let me know if I can help some more.

* whitelist hp2133

* the driver has different name now.

* remove /** from comments that are not linuxdoc compliant.

* remove /dev/accel. We can reintroduce it when it works

Signed-off-by: Pavel Machek <pavel@suse.cz>
									Pavel

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 3cdfb52..1d6ca17 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -1,5 +1,6 @@
 /*
- *  mdps.c - ST LIS3LV02DL accelerometer driver
+ *  lis3lv02d.c - ST LIS3LV02DL accelerometer driver used for HDD protection
+ *		  in HP notebooks
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
@@ -106,7 +107,7 @@ static struct acpi_device_id lis3lv02d_d
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
 
-/**
+/*
  * acpi_init - ACPI _INI method: initialize the device.
  * @handle the handle of the device
  *
@@ -161,7 +162,7 @@ static acpi_status lis3lv02d_acpi_write(
 	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
 }
 
-/**
+/*
  * Write a 16 bit word on a pair of registers
  * @handle the handle of the device
  * @reg the low register to write to
@@ -187,15 +188,8 @@ static s16 lis3lv02d_read_16(acpi_handle
 	return (s16)((hi << 8) | lo);
 }
 
-static void lis3lv02d_display_reg(int reg)
-{
-	u8 val;
-	lis3lv02d_acpi_read(adev.device->handle, reg, &val);
-	printk(DRIVER_NAME " reg %x : %.2x\n", reg, val);
-}
-
 /**
- * For the given axis, give the value converted
+ * lis3lv02d_get_axis For the given axis, give the value converted
  * @param axis 1,2,3 - can also be negative
  * @param hw_values raw values returned by the hardware
  *
@@ -277,12 +271,6 @@ #endif
 static int lis3lv02d_resume(struct acpi_device *device)
 {
 	/* make sure the device went online */
-	// TODO: check if the device could be automatically turned on by acpi
-	// If so, put the power_off timer back
-//	down(&adev.poff_sem);
-//	if (adev.usage > 0)
-//		lis3lv02d_poweron(device->handle);
-//	up(&adev.poff_sem);
 	printk(KERN_INFO DRIVER_NAME " Resuming device\n");
 	return 0;
 }
@@ -326,192 +314,6 @@ static void lis3lv02d_poweroff_timeout(u
 	printk(KERN_DEBUG DRIVER_NAME ": Turning off the device\n");
 }
 
-static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
-{
-	/*
-	 * Be careful: on some HP laptops the bios force DD when on battery and
-	 * the lid is closed. This leads to interrupts as soon as a little move
-	 * is done.
-	 */
-	atomic_inc(&adev.count);
-
-	wake_up_interruptible(&adev.misc_wait);
-	kill_fasync(&adev.async_queue, SIGIO, POLL_IN);
-
-//	//lis3lv02d_display_reg(STATUS_REG);
-//	lis3lv02d_display_reg(FF_WU_SRC);
-//	lis3lv02d_display_reg(DD_SRC);
-//	//lis3lv02d_display_reg(CTRL_REG1);
-//	//lis3lv02d_display_reg(CTRL_REG2);
-//	//lis3lv02d_display_reg(CTRL_REG3);
-//	lis3lv02d_display_reg(FF_WU_ACK);
-//	lis3lv02d_display_reg(FF_WU_CFG);
-//	lis3lv02d_display_reg(DD_CFG);
-//	//lis3lv02d_display_reg(FF_WU_THS_L);
-//	//lis3lv02d_display_reg(FF_WU_THS_H);
-//	//lis3lv02d_display_reg(FF_WU_DURATION);
-//	//lis3lv02d_acpi_write(adev.device->handle, FF_WU_SRC, 0);
-//	printk(KERN_DEBUG DRIVER_NAME ": irq received\n");
-
-	return IRQ_HANDLED;
-}
-
-static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
-{
-	int ret;
-
-	if (test_and_set_bit(0, &adev.misc_opened))
-		return -EBUSY; /* already open */
-
-	atomic_set(&adev.count, 0);
-
-	/*
-	 * The sensor can generate interrupts for free-fall and direction
-	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
-	 * the things simple and _fast_ we activate it only for free-fall, so
-	 * no need to read register (very slow with ACPI). For the same reason,
-	 * we forbid shared interrupts.
-	 *
-	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
-	 * io-apic is not configurable (and generates a warning) but I keep it
-	 * in case of support for other hardware.
-	 */
-	ret = request_irq(adev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
-			  DRIVER_NAME, &adev);
-	if (ret) {
-		clear_bit(0, &adev.misc_opened);
-		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq);
-		return -EBUSY;
-	}
-	lis3lv02d_increase_use(&adev);
-	// TODO: set up the registers correctly
-//	lis3lv02d_display_reg(STATUS_REG);
-//	lis3lv02d_display_reg(CTRL_REG1);
-//	lis3lv02d_display_reg(CTRL_REG2);
-//	lis3lv02d_display_reg(CTRL_REG3);
-	lis3lv02d_display_reg(FF_WU_CFG);
-//	lis3lv02d_display_reg(FF_WU_SRC);
-//	lis3lv02d_display_reg(FF_WU_THS_L);
-//	lis3lv02d_display_reg(FF_WU_THS_H);
-//	lis3lv02d_display_reg(FF_WU_DURATION);
-//	lis3lv02d_display_reg(DD_CFG);
-//	lis3lv02d_display_reg(DD_SRC);
-//	lis3lv02d_display_reg(DD_THSI_L);
-//	lis3lv02d_display_reg(DD_THSI_H);
-//	lis3lv02d_display_reg(DD_THSE_L);
-//	lis3lv02d_display_reg(DD_THSE_H);
-//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_SRC, 0);
-	/* Threshold not too big (10) */
-//	lis3lv02d_write_16(adev.device->handle, FF_WU_THS_L, 10);
-//	/* 2 samples in a row before activation */
-//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_DURATION, 2);
-//	/* detect every direction, don't wait for validation */
-	lis3lv02d_acpi_write(adev.device->handle, FF_WU_CFG, 0);
-//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_CFG, FF_WU_CFG_XLIE | FF_WU_CFG_XHIE
-//					| FF_WU_CFG_YLIE | FF_WU_CFG_YHIE
-//					| FF_WU_CFG_ZLIE | FF_WU_CFG_ZHIE);
-	// TODO after turning on, this generates one useless interrupt just after set up, it shouldn't be passed to userspace
-//	lis3lv02d_display_reg(STATUS_REG);
-//	lis3lv02d_display_reg(CTRL_REG1);
-//	lis3lv02d_display_reg(CTRL_REG2);
-//	lis3lv02d_display_reg(CTRL_REG3);
-	lis3lv02d_display_reg(FF_WU_CFG);
-//	lis3lv02d_display_reg(FF_WU_SRC);
-//	lis3lv02d_display_reg(FF_WU_THS_L);
-//	lis3lv02d_display_reg(FF_WU_THS_H);
-//	lis3lv02d_display_reg(FF_WU_DURATION);
-//	lis3lv02d_display_reg(DD_CFG);
-//	lis3lv02d_display_reg(DD_SRC);
-//	lis3lv02d_display_reg(DD_THSI_L);
-//	lis3lv02d_display_reg(DD_THSI_H);
-//	lis3lv02d_display_reg(DD_THSE_L);
-//	lis3lv02d_display_reg(DD_THSE_H);
-
-	return 0;
-}
-
-static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
-{
-	fasync_helper(-1, file, 0, &adev.async_queue);
-	lis3lv02d_acpi_write(adev.device->handle, FF_WU_CFG, 0);
-	lis3lv02d_decrease_use(&adev);
-	free_irq(adev.irq, &adev);
-	clear_bit(0, &adev.misc_opened); /* release the device */
-	return 0;
-}
-
-static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
-				size_t count, loff_t *pos)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	u32 data;
-	ssize_t retval = count;
-
-	if (count != sizeof(u32))
-		return -EINVAL;
-
-	add_wait_queue(&adev.misc_wait, &wait);
-	while (true) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		data = atomic_xchg(&adev.count, 0);
-		if (data)
-			break;
-
-		if (file->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
-			goto out;
-		}
-
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			goto out;
-		}
-
-		schedule();
-	}
-
-	/* make sure we are not going into copy_to_user() with
-	 * TASK_INTERRUPTIBLE state */
-	set_current_state(TASK_RUNNING);
-	if (copy_to_user(buf, &data, sizeof(data)))
-		retval = -EFAULT;
-
-out:
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&adev.misc_wait, &wait);
-
-	return retval;
-}
-
-static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
-{
-	poll_wait(file, &adev.misc_wait, wait);
-	if (atomic_read(&adev.count))
-		return POLLIN | POLLRDNORM;
-	return 0;
-}
-
-static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
-{
-	return fasync_helper(fd, file, on, &adev.async_queue);
-}
-
-static const struct file_operations lis3lv02d_misc_fops = {
-	.owner   = THIS_MODULE,
-	.llseek  = no_llseek,
-	.read    = lis3lv02d_misc_read,
-	.open    = lis3lv02d_misc_open,
-	.release = lis3lv02d_misc_release,
-	.poll    = lis3lv02d_misc_poll,
-	.fasync  = lis3lv02d_misc_fasync,
-};
-
-static struct miscdevice lis3lv02d_misc_device = {
-	.minor   = MISC_DYNAMIC_MINOR,
-	.name    = "accel",
-	.fops    = &lis3lv02d_misc_fops,
-};
-
 /**
  * lis3lv02d_joystick_kthread - Kthread polling function
  * @param data unused - here to conform to threadfn prototype
@@ -644,16 +446,6 @@ static int lis3lv02d_init_device(struct 
 	/* obtain IRQ number of our device from ACPI */
 	lis3lv02d_enum_resources(dev->device);
 
-	/* if we did not get an IRQ from ACPI - we have nothing more to do */
-	if (!dev->irq) {
-		printk(KERN_ERR DRIVER_NAME
-			": No IRQ in ACPI. Disabling /dev/accel\n");
-		goto out;
-	}
-
-	if (misc_register(&lis3lv02d_misc_device))
-		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
-out:
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
@@ -673,6 +465,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_x_inverted = {-2, 1, 3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -690,6 +483,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
+	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_swap_x_inverted ),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC651xx" "HP Compaq 651"
@@ -738,7 +532,6 @@ static int lis3lv02d_remove(struct acpi_
 	if (!device)
 		return -EINVAL;
 
-	misc_deregister(&lis3lv02d_misc_device);
 	lis3lv02d_joystick_disable();
 	del_timer(&adev.poff_timer);
 	lis3lv02d_poweroff(device->handle);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
