Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZALJ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZALJ1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZALJ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:27:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60114 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZALJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:27:34 -0500
Date: Mon, 12 Jan 2009 10:29:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       eric.piel@tremplin-utc.net
Subject: hp accelerometer: fix LED handling and add freefall detection
Message-ID: <20090112092839.GA2190@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lis3 chip can provide interrupt when it detects freefall; it is done
by hardware and is rather reliable. This adds (experimental) support
for it. 

LED on HP notebooks is connected through ACPI. That unfortunately
means that it needs to be delayed by using schedule_work() to avoid
calling ACPI interpretter in invalid context. This patch fixes that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index bd8497b..dd98b3e 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
- *  Copyright (C) 2008 Pavel Machek
+ *  Copyright (C) 2008-2009 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -44,6 +44,36 @@ #include "lis3lv02d.h"
 #define DRIVER_NAME     "lis3lv02d"
 #define ACPI_MDPS_CLASS "accelerometer"
 
+/* Delayed LEDs infrastructure ------------------------------------ */ 
+
+/* Special LED class that can defer work */
+struct delayed_led_classdev {
+	struct led_classdev led_classdev;
+	struct work_struct work;
+	enum led_brightness new_brightness;
+
+	unsigned int led;		/* For driver */
+	void (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
+};
+
+static inline void delayed_set_status_worker(struct work_struct *work)
+{
+	struct delayed_led_classdev *data =
+			container_of(work, struct delayed_led_classdev, work);
+
+	data->set_brightness(data, data->new_brightness);
+}
+
+static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
+			      enum led_brightness brightness)
+{
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
+	data->new_brightness = brightness;
+	schedule_work(&data->work);
+}
+
+/* HP-specific accelerometer driver ------------------------------------ */ 
 
 /* For automatic insertion of the module */
 static struct acpi_device_id lis3lv02d_device_ids[] = {
@@ -155,29 +185,52 @@ static struct dmi_system_id lis3lv02d_dm
  */
 };
 
-static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
 {
+	acpi_handle handle = adev.device->handle;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
 
 	in_obj[0].type          = ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value = reg;
+	in_obj[0].integer.value = !!value;
 
-	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+	acpi_evaluate_integer(handle, "ALED", &args, &ret);
 }
 
-static void hpled_set(struct led_classdev *led_cdev,
-			       enum led_brightness value)
+static struct delayed_led_classdev hpled_led = {
+	.led_classdev = {
+		.name			= "hp::hddprotect",
+		.default_trigger	= "none",
+		.brightness_set		= delayed_sysfs_set,
+		.flags                  = LED_CORE_SUSPENDRESUME,
+	},
+	.set_brightness = hpled_set,
+};
+
+static acpi_status
+lis3lv02d_get_resource(struct acpi_resource *resource, void *context)
 {
-	hpled_acpi_write(adev.device->handle, !!value);
+	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+		u32 *device_irq = context;
+
+		irq = &resource->data.extended_irq;
+		*device_irq = irq->interrupts[0];
+	}
+
+	return AE_OK;
 }
 
-static struct led_classdev hpled_led = {
-	.name			= "hp:red:hddprotection",
-	.default_trigger	= "heartbeat",
-	.brightness_set		= hpled_set,
-};
+static void lis3lv02d_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					lis3lv02d_get_resource, &adev.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
+}
 
 static int lis3lv02d_add(struct acpi_device *device)
 {
@@ -208,13 +261,20 @@ static int lis3lv02d_add(struct acpi_dev
 		adev.ac = lis3lv02d_axis_normal;
 	}
 
-	ret = led_classdev_register(NULL, &hpled_led);
+	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
+	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret)
 		return ret;
 
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(adev.device);
+
 	ret = lis3lv02d_init_device(&adev);
 	if (ret) {
-		led_classdev_unregister(&hpled_led);
+		while (work_pending(&hpled_led.work))
+			schedule();
+
+		led_classdev_unregister(&hpled_led.led_classdev);
 		return ret;
 	}
 
@@ -229,7 +289,9 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
 
-	led_classdev_unregister(&hpled_led);
+	while (work_pending(&hpled_led.work))
+		schedule();
+	led_classdev_unregister(&hpled_led.led_classdev);
 
 	return lis3lv02d_remove_fs();
 }
@@ -240,7 +302,6 @@ static int lis3lv02d_suspend(struct acpi
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(device->handle);
-	led_classdev_suspend(&hpled_led);
 	return 0;
 }
 
@@ -253,7 +314,6 @@ static int lis3lv02d_resume(struct acpi_
 	else
 		lis3lv02d_poweroff(device->handle);
 	mutex_unlock(&adev.lock);
-	led_classdev_resume(&hpled_led);
 	return 0;
 }
 #else
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 219d2d0..3afa3af 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
- *  Copyright (C) 2008 Pavel Machek
+ *  Copyright (C) 2008-2009 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -35,6 +35,7 @@ #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/miscdevice.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -55,7 +56,10 @@ #define MDPS_POLL_INTERVAL 50
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
-struct acpi_lis3lv02d adev;
+struct acpi_lis3lv02d adev = {
+	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
+};
+
 EXPORT_SYMBOL_GPL(adev);
 
 static int lis3lv02d_add_fs(struct acpi_device *device);
@@ -110,26 +114,13 @@ static void lis3lv02d_get_xyz(acpi_handl
 void lis3lv02d_poweroff(acpi_handle handle)
 {
 	adev.is_on = 0;
-	/* disable X,Y,Z axis and power down */
-	adev.write(handle, CTRL_REG1, 0x00);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
 void lis3lv02d_poweron(acpi_handle handle)
 {
-	u8 val;
-
 	adev.is_on = 1;
 	adev.init(handle);
-	adev.write(handle, FF_WU_CFG, 0);
-	/*
-	 * BDU: LSB and MSB values are not updated until both have been read.
-	 *      So the value read will always be correct.
-	 * IEN: Interrupt for free-fall and DD, not for data-ready.
-	 */
-	adev.read(handle, CTRL_REG2, &val);
-	val |= CTRL2_BDU | CTRL2_IEN;
-	adev.write(handle, CTRL_REG2, val);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
@@ -162,6 +153,140 @@ static void lis3lv02d_decrease_use(struc
 	mutex_unlock(&dev->lock);
 }
 
+static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+{
+	/*
+	 * Be careful: on some HP laptops the bios force DD when on battery and
+	 * the lid is closed. This leads to interrupts as soon as a little move
+	 * is done.
+	 */
+	atomic_inc(&adev.count);
+
+	wake_up_interruptible(&adev.misc_wait);
+	kill_fasync(&adev.async_queue, SIGIO, POLL_IN);
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if (test_and_set_bit(0, &adev.misc_opened))
+		return -EBUSY; /* already open */
+
+	atomic_set(&adev.count, 0);
+
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reason,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep it
+	 * in case of support for other hardware.
+	 */
+	ret = request_irq(adev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
+			  DRIVER_NAME, &adev);
+
+	if (ret) {
+		clear_bit(0, &adev.misc_opened);
+		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq);
+		return -EBUSY;
+	}
+	lis3lv02d_increase_use(&adev);
+	printk("lis3: registered interrupt %d\n", adev.irq);
+	return 0;
+}
+
+static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
+{
+	fasync_helper(-1, file, 0, &adev.async_queue);
+	lis3lv02d_decrease_use(&adev);
+	free_irq(adev.irq, &adev);
+	clear_bit(0, &adev.misc_opened); /* release the device */
+	return 0;
+}
+
+static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
+				size_t count, loff_t *pos)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	u32 data;
+	unsigned char byte_data;
+	ssize_t retval = 1;
+
+	if (count < 1)
+		return -EINVAL;
+
+	add_wait_queue(&adev.misc_wait, &wait);
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		data = atomic_xchg(&adev.count, 0);
+		if (data)
+			break;
+
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			retval = -ERESTARTSYS;
+			goto out;
+		}
+
+		schedule();
+	}
+
+	if (data < 255)
+		byte_data = data;
+	else
+		byte_data = 255;
+
+	/* make sure we are not going into copy_to_user() with
+	 * TASK_INTERRUPTIBLE state */
+	set_current_state(TASK_RUNNING);
+	if (copy_to_user(buf, &byte_data, sizeof(byte_data)))
+		retval = -EFAULT;
+
+out:
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&adev.misc_wait, &wait);
+
+	return retval;
+}
+
+static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &adev.misc_wait, wait);
+	if (atomic_read(&adev.count))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
+{
+	return fasync_helper(fd, file, on, &adev.async_queue);
+}
+
+static const struct file_operations lis3lv02d_misc_fops = {
+	.owner   = THIS_MODULE,
+	.llseek  = no_llseek,
+	.read    = lis3lv02d_misc_read,
+	.open    = lis3lv02d_misc_open,
+	.release = lis3lv02d_misc_release,
+	.poll    = lis3lv02d_misc_poll,
+	.fasync  = lis3lv02d_misc_fasync,
+};
+
+static struct miscdevice lis3lv02d_misc_device = {
+	.minor   = MISC_DYNAMIC_MINOR,
+	.name    = "freefall",
+	.fops    = &lis3lv02d_misc_fops,
+};
+
 /**
  * lis3lv02d_joystick_kthread - Kthread polling function
  * @data: unused - here to conform to threadfn prototype
@@ -203,7 +328,6 @@ static void lis3lv02d_joystick_close(str
 	lis3lv02d_decrease_use(&adev);
 }
 
-
 static inline void lis3lv02d_calibrate_joystick(void)
 {
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
@@ -250,6 +374,7 @@ void lis3lv02d_joystick_disable(void)
 	if (!adev.idev)
 		return;
 
+	misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(adev.idev);
 	adev.idev = NULL;
 }
@@ -268,6 +393,16 @@ int lis3lv02d_init_device(struct acpi_li
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/freefall\n");
+		goto out;
+	}
+
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
@@ -351,6 +489,6 @@ int lis3lv02d_remove_fs(void)
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
-MODULE_AUTHOR("Yan Burman and Eric Piel");
+MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 223f1c0..2e7597c 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -170,6 +170,11 @@ struct acpi_lis3lv02d {
 	unsigned char		is_on;     /* whether the device is on or off */
 	unsigned char		usage;     /* usage counter */
 	struct axis_conversion	ac;        /* hw -> logical axis */
+
+	u32			irq;       /* IRQ number */
+	struct fasync_struct	*async_queue; /* queue for the misc device */
+	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
+	unsigned long		misc_opened; /* bit0: whether the device is open */
 };
 
 int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
