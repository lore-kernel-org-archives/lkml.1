Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZAPMRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZAPMRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbZAPMRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:17:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43663 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZAPMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:17:32 -0500
Date: Fri, 16 Jan 2009 13:19:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>, trenn@suse.de
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: hp accelerometer: add freefall detection
Message-ID: <20090116121940.GA30302@elf.ucw.cz>
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B0E5F.1020902@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks a lot for doing it! I'll test it this week. However, I think
> eventually the LED fix and the freefall infrastructure should be two
> different patches. Also, while adding the freefall support, you should
> add the info in the doc, as well as the little C program demonstrating
> its use.

Agreed :-).

---

This adds freefall handling to hp_accel driver. According to HP, it
should just work, without us having to set the chip up by hand.

hpfall.c is example .c program that parks the disk when accelerometer
detects free fall. It should work; for now, it uses fixed 20seconds
protection period.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
new file mode 100755
index 0000000..7d17764
--- /dev/null
+++ b/Documentation/hwmon/hpfall.c
@@ -0,0 +1,101 @@
+/* Disk protection for HP machines.
+ *
+ * Copyright 2008 Eric Piel
+ * Copyright 2009 Pavel Machek <pavel@suse.cz>
+ *
+ * GPLv2.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <string.h>
+#include <stdint.h>
+#include <errno.h>
+#include <signal.h>
+
+void write_int(char *path, int i)
+{
+	char buf[1024];
+	int fd = open(path, O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(1);
+	}
+	sprintf(buf, "%d", i);
+	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
+		perror("write");
+		exit(1);
+	}
+	close(fd);
+}
+
+void set_led(int on)
+{
+	write_int("/sys/class/leds/hp::hddprotect/brightness", on);
+}
+
+void protect(int seconds)
+{
+	write_int("/sys/block/sda/device/unload_heads", seconds*1000);
+}
+
+int on_ac(void)
+{
+//	/sys/class/power_supply/AC0/online
+}
+
+int lid_open(void)
+{
+//	/proc/acpi/button/lid/LID/state
+}
+
+void ignore_me(void)
+{
+	protect(0);
+	set_led(0);
+
+}
+
+int main(int argc, char* argv[])
+{
+       int fd, ret;
+
+       fd = open("/dev/freefall", O_RDONLY);
+       if (fd < 0) {
+               perror("open");
+               return EXIT_FAILURE;
+       }
+
+	signal(SIGALRM, ignore_me);
+
+       for (;;) {
+	       unsigned char count;
+
+               ret = read(fd, &count, sizeof(count));
+	       alarm(0);
+	       if ((ret == -1) && (errno == EINTR)) {
+		       /* Alarm expired, time to unpark the heads */
+		       continue;
+	       }
+
+               if (ret != sizeof(count)) {
+                       perror("read");
+                       break;
+               }
+
+	       protect(21);
+	       set_led(1);
+	       if (1 || on_ac() || lid_open()) {
+		       alarm(2);
+	       } else {
+		       alarm(20);
+	       }
+       }
+
+       close(fd);
+       return EXIT_SUCCESS;
+}
diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index 0fcfc4a..287f8c9 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
@@ -33,6 +33,14 @@ rate - reports the sampling rate of the 
 This driver also provides an absolute input class device, allowing
 the laptop to act as a pinball machine-esque joystick.
 
+Another feature of the driver is misc device called "freefall" that
+acts similar to /dev/rtc and reacts on free-fall interrupts received
+from the device. It supports blocking operations, poll/select and
+fasync operation modes. You must read 1 bytes from the device.  The
+result is number of free-fall interrupts since the last successful
+read (or 255 if number of interrupts would not fit).
+
+
 Axes orientation
 ----------------
 
diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 0370524..5474971 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -208,6 +208,30 @@ static struct delayed_led_classdev hpled
 	.set_brightness = hpled_set,
 };
 
+static acpi_status
+lis3lv02d_get_resource(struct acpi_resource *resource, void *context)
+{
+	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+		u32 *device_irq = context;
+
+		irq = &resource->data.extended_irq;
+		*device_irq = irq->interrupts[0];
+	}
+
+	return AE_OK;
+}
+
+static void lis3lv02d_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					lis3lv02d_get_resource, &adev.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
+}
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	u8 val;
@@ -242,6 +266,9 @@ static int lis3lv02d_add(struct acpi_dev
 	if (ret)
 		return ret;
 
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(adev.device);
+
 	ret = lis3lv02d_init_device(&adev);
 	if (ret) {
 		flush_work(&hpled_led.work);
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
@@ -268,6 +393,19 @@ int lis3lv02d_init_device(struct acpi_li
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
+	printk("lis3_init_device: irq %d\n", dev->irq);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/freefall\n");
+		goto out;
+	}
+
+	printk("lis3: registering device\n");
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
