Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZB0Kxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZB0Kxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZB0Kxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:53:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47124 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZB0Kxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:53:37 -0500
Date: Fri, 27 Feb 2009 11:54:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>, Quoc.Pham@hp.com
Subject: hp_accel: adev is poor name of exported symbol
Message-ID: <20090227105433.GA26863@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Andrew noted, adev is pretty poor name for symbol being
exported. Rename it to lis3.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 29c83b5..20e37fd 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -140,7 +140,7 @@ acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
 
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
-	adev.ac = *((struct axis_conversion *)dmi->driver_data);
+	lis3_dev.ac = *((struct axis_conversion *)dmi->driver_data);
 	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
 
 	return 1;
@@ -214,7 +215,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 
 static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
 {
-	acpi_handle handle = adev.device->handle;
+	acpi_handle handle = lis3_dev.device->handle;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
@@ -254,7 +255,7 @@ static void lis3lv02d_enum_resources(struct acpi_device *device)
 	acpi_status status;
 
 	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-					lis3lv02d_get_resource, &adev.irq);
+					lis3lv02d_get_resource, &lis3_dev.irq);
 	if (ACPI_FAILURE(status))
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
@@ -263,8 +264,8 @@ static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
 
-	adev.read(handle, reg - 1, &lo);
-	adev.read(handle, reg, &hi);
+	lis3_dev.read(handle, reg - 1, &lo);
+	lis3_dev.read(handle, reg, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -272,7 +273,7 @@ static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
 {
 	s8 lo;
-	adev.read(handle, reg, &lo);
+	lis3_dev.read(handle, reg, &lo);
 	return lo;
 }
 
@@ -283,29 +284,29 @@ static int lis3lv02d_add(struct acpi_device *device)
 	if (!device)
 		return -EINVAL;
 
-	adev.device = device;
-	adev.init = lis3lv02d_acpi_init;
-	adev.read = lis3lv02d_acpi_read;
-	adev.write = lis3lv02d_acpi_write;
+	lis3_dev.device = device;
+	lis3_dev.init = lis3lv02d_acpi_init;
+	lis3_dev.read = lis3lv02d_acpi_read;
+	lis3_dev.write = lis3lv02d_acpi_write;
 	strcpy(acpi_device_name(device), DRIVER_NAME);
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	device->driver_data = &adev;
+	device->driver_data = &lis3_dev;
 
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &adev.whoami);
-	switch (adev.whoami) {
+	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &lis3_dev.whoami);
+	switch (lis3_dev.whoami) {
 	case LIS_DOUBLE_ID:
 		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
-		adev.read_data = lis3lv02d_read_16;
-		adev.mdps_max_val = 2048;
+		lis3_dev.read_data = lis3lv02d_read_16;
+		lis3_dev.mdps_max_val = 2048;
 		break;
 	case LIS_SINGLE_ID:
 		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
-		adev.read_data = lis3lv02d_read_8;
-		adev.mdps_max_val = 128;
+		lis3_dev.read_data = lis3lv02d_read_8;
+		lis3_dev.mdps_max_val = 128;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
-			": unknown sensor type 0x%X\n", adev.whoami);
+			": unknown sensor type 0x%X\n", lis3_dev.whoami);
 		return -EINVAL;
 	}
 
@@ -313,7 +314,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
 		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
 				 "using default axes configuration\n");
-		adev.ac = lis3lv02d_axis_normal;
+		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
 
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
@@ -322,9 +323,9 @@ static int lis3lv02d_add(struct acpi_device *device)
 		return ret;
 
 	/* obtain IRQ number of our device from ACPI */
-	lis3lv02d_enum_resources(adev.device);
+	lis3lv02d_enum_resources(lis3_dev.device);
 
-	ret = lis3lv02d_init_device(&adev);
+	ret = lis3lv02d_init_device(&lis3_dev);
 	if (ret) {
 		flush_work(&hpled_led.work);
 		led_classdev_unregister(&hpled_led.led_classdev);
@@ -360,12 +361,12 @@ static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
 static int lis3lv02d_resume(struct acpi_device *device)
 {
 	/* put back the device in the right state (ACPI might turn it on) */
-	mutex_lock(&adev.lock);
-	if (adev.usage > 0)
+	mutex_lock(&lis3_dev.lock);
+	if (lis3_dev.usage > 0)
 		lis3lv02d_poweron(device->handle);
 	else
 		lis3lv02d_poweroff(device->handle);
-	mutex_unlock(&adev.lock);
+	mutex_unlock(&lis3_dev.lock);
 	return 0;
 }
 #else
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 8bb2158..4888ac5 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -53,14 +53,24 @@
  * joystick.
  */
 
-struct acpi_lis3lv02d adev = {
-	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
+struct acpi_lis3lv02d lis3_dev = {
+	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
 
-EXPORT_SYMBOL_GPL(adev);
+EXPORT_SYMBOL_GPL(lis3_dev);
 
 static int lis3lv02d_add_fs(struct acpi_device *device);
 
+static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
+{
+	u8 lo, hi;
+
+	lis3_dev.read(handle, reg, &lo);
+	lis3_dev.read(handle, reg + 1, &hi);
+	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
+	return (s16)((hi << 8) | lo);
+}
+
 /**
  * lis3lv02d_get_axis - For the given axis, give the value converted
  * @axis:      1,2,3 - can also be negative
@@ -89,25 +99,25 @@ static void lis3lv02d_get_xyz(acpi_handle handle, int *x, int *y, int *z)
 {
 	int position[3];
 
-	position[0] = adev.read_data(handle, OUTX);
-	position[1] = adev.read_data(handle, OUTY);
-	position[2] = adev.read_data(handle, OUTZ);
+	position[0] = lis3_dev.read_data(handle, OUTX);
+	position[1] = lis3_dev.read_data(handle, OUTY);
+	position[2] = lis3_dev.read_data(handle, OUTZ);
 
-	*x = lis3lv02d_get_axis(adev.ac.x, position);
-	*y = lis3lv02d_get_axis(adev.ac.y, position);
-	*z = lis3lv02d_get_axis(adev.ac.z, position);
+	*x = lis3lv02d_get_axis(lis3_dev.ac.x, position);
+	*y = lis3lv02d_get_axis(lis3_dev.ac.y, position);
+	*z = lis3lv02d_get_axis(lis3_dev.ac.z, position);
 }
 
 void lis3lv02d_poweroff(acpi_handle handle)
 {
-	adev.is_on = 0;
+	lis3_dev.is_on = 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
 void lis3lv02d_poweron(acpi_handle handle)
 {
-	adev.is_on = 1;
-	adev.init(handle);
+	lis3_dev.is_on = 1;
+	lis3_dev.init(handle);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
@@ -147,10 +157,10 @@ static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 	 * the lid is closed. This leads to interrupts as soon as a little move
 	 * is done.
 	 */
-	atomic_inc(&adev.count);
+	atomic_inc(&lis3_dev.count);
 
-	wake_up_interruptible(&adev.misc_wait);
-	kill_fasync(&adev.async_queue, SIGIO, POLL_IN);
+	wake_up_interruptible(&lis3_dev.misc_wait);
+	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
 	return IRQ_HANDLED;
 }
 
@@ -158,10 +168,10 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	if (test_and_set_bit(0, &adev.misc_opened))
+	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
-	atomic_set(&adev.count, 0);
+	atomic_set(&lis3_dev.count, 0);
 
 	/*
 	 * The sensor can generate interrupts for free-fall and direction
@@ -174,25 +184,25 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 	 * io-apic is not configurable (and generates a warning) but I keep it
 	 * in case of support for other hardware.
 	 */
-	ret = request_irq(adev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
-			  DRIVER_NAME, &adev);
+	ret = request_irq(lis3_dev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
+			  DRIVER_NAME, &lis3_dev);
 
 	if (ret) {
-		clear_bit(0, &adev.misc_opened);
-		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq);
+		clear_bit(0, &lis3_dev.misc_opened);
+		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", lis3_dev.irq);
 		return -EBUSY;
 	}
-	lis3lv02d_increase_use(&adev);
-	printk("lis3: registered interrupt %d\n", adev.irq);
+	lis3lv02d_increase_use(&lis3_dev);
+	printk("lis3: registered interrupt %d\n", lis3_dev.irq);
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
-	fasync_helper(-1, file, 0, &adev.async_queue);
-	lis3lv02d_decrease_use(&adev);
-	free_irq(adev.irq, &adev);
-	clear_bit(0, &adev.misc_opened); /* release the device */
+	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
+	lis3lv02d_decrease_use(&lis3_dev);
+	free_irq(lis3_dev.irq, &lis3_dev);
+	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
 	return 0;
 }
 
@@ -207,10 +217,10 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 	if (count < 1)
 		return -EINVAL;
 
-	add_wait_queue(&adev.misc_wait, &wait);
+	add_wait_queue(&lis3_dev.misc_wait, &wait);
 	while (true) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		data = atomic_xchg(&adev.count, 0);
+		data = atomic_xchg(&lis3_dev.count, 0);
 		if (data)
 			break;
 
@@ -240,22 +250,22 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 
 out:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&adev.misc_wait, &wait);
+	remove_wait_queue(&lis3_dev.misc_wait, &wait);
 
 	return retval;
 }
 
 static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &adev.misc_wait, wait);
-	if (atomic_read(&adev.count))
+	poll_wait(file, &lis3_dev.misc_wait, wait);
+	if (atomic_read(&lis3_dev.count))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
 static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
 {
-	return fasync_helper(fd, file, on, &adev.async_queue);
+	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
 }
 
 static const struct file_operations lis3lv02d_misc_fops = {
@@ -283,12 +293,12 @@ static int lis3lv02d_joystick_kthread(void *data)
 	int x, y, z;
 
 	while (!kthread_should_stop()) {
-		lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
-		input_report_abs(adev.idev, ABS_X, x - adev.xcalib);
-		input_report_abs(adev.idev, ABS_Y, y - adev.ycalib);
-		input_report_abs(adev.idev, ABS_Z, z - adev.zcalib);
+		lis3lv02d_get_xyz(lis3_dev.device->handle, &x, &y, &z);
+		input_report_abs(lis3_dev.idev, ABS_X, x - lis3_dev.xcalib);
+		input_report_abs(lis3_dev.idev, ABS_Y, y - lis3_dev.ycalib);
+		input_report_abs(lis3_dev.idev, ABS_Z, z - lis3_dev.zcalib);
 
-		input_sync(adev.idev);
+		input_sync(lis3_dev.idev);
 
 		try_to_freeze();
 		msleep_interruptible(MDPS_POLL_INTERVAL);
@@ -299,11 +309,11 @@ static int lis3lv02d_joystick_kthread(void *data)
 
 static int lis3lv02d_joystick_open(struct input_dev *input)
 {
-	lis3lv02d_increase_use(&adev);
-	adev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
-	if (IS_ERR(adev.kthread)) {
-		lis3lv02d_decrease_use(&adev);
-		return PTR_ERR(adev.kthread);
+	lis3lv02d_increase_use(&lis3_dev);
+	lis3_dev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
+	if (IS_ERR(lis3_dev.kthread)) {
+		lis3lv02d_decrease_use(&lis3_dev);
+		return PTR_ERR(lis3_dev.kthread);
 	}
 
 	return 0;
@@ -311,45 +321,45 @@ static int lis3lv02d_joystick_open(struct input_dev *input)
 
 static void lis3lv02d_joystick_close(struct input_dev *input)
 {
-	kthread_stop(adev.kthread);
-	lis3lv02d_decrease_use(&adev);
+	kthread_stop(lis3_dev.kthread);
+	lis3lv02d_decrease_use(&lis3_dev);
 }
 
 static inline void lis3lv02d_calibrate_joystick(void)
 {
-	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
+	lis3lv02d_get_xyz(lis3_dev.device->handle, &lis3_dev.xcalib, &lis3_dev.ycalib, &lis3_dev.zcalib);
 }
 
 int lis3lv02d_joystick_enable(void)
 {
 	int err;
 
-	if (adev.idev)
+	if (lis3_dev.idev)
 		return -EINVAL;
 
-	adev.idev = input_allocate_device();
-	if (!adev.idev)
+	lis3_dev.idev = input_allocate_device();
+	if (!lis3_dev.idev)
 		return -ENOMEM;
 
 	lis3lv02d_calibrate_joystick();
 
-	adev.idev->name       = "ST LIS3LV02DL Accelerometer";
-	adev.idev->phys       = DRIVER_NAME "/input0";
-	adev.idev->id.bustype = BUS_HOST;
-	adev.idev->id.vendor  = 0;
-	adev.idev->dev.parent = &adev.pdev->dev;
-	adev.idev->open       = lis3lv02d_joystick_open;
-	adev.idev->close      = lis3lv02d_joystick_close;
+	lis3_dev.idev->name       = "ST LIS3LV02DL Accelerometer";
+	lis3_dev.idev->phys       = DRIVER_NAME "/input0";
+	lis3_dev.idev->id.bustype = BUS_HOST;
+	lis3_dev.idev->id.vendor  = 0;
+	lis3_dev.idev->dev.parent = &lis3_dev.pdev->dev;
+	lis3_dev.idev->open       = lis3lv02d_joystick_open;
+	lis3_dev.idev->close      = lis3lv02d_joystick_close;
 
-	set_bit(EV_ABS, adev.idev->evbit);
-	input_set_abs_params(adev.idev, ABS_X, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
-	input_set_abs_params(adev.idev, ABS_Y, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
-	input_set_abs_params(adev.idev, ABS_Z, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);
+	set_bit(EV_ABS, lis3_dev.idev->evbit);
+	input_set_abs_params(lis3_dev.idev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(lis3_dev.idev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(lis3_dev.idev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
 
-	err = input_register_device(adev.idev);
+	err = input_register_device(lis3_dev.idev);
 	if (err) {
-		input_free_device(adev.idev);
-		adev.idev = NULL;
+		input_free_device(lis3_dev.idev);
+		lis3_dev.idev = NULL;
 	}
 
 	return err;
@@ -358,12 +368,12 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
 void lis3lv02d_joystick_disable(void)
 {
-	if (!adev.idev)
+	if (!lis3_dev.idev)
 		return;
 
 	misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_device(adev.idev);
-	adev.idev = NULL;
+	input_unregister_device(lis3_dev.idev);
+	lis3_dev.idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
@@ -404,25 +414,25 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
 {
 	int x, y, z;
 
-	lis3lv02d_increase_use(&adev);
-	lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
-	lis3lv02d_decrease_use(&adev);
+	lis3lv02d_increase_use(&lis3_dev);
+	lis3lv02d_get_xyz(lis3_dev.device->handle, &x, &y, &z);
+	lis3lv02d_decrease_use(&lis3_dev);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
 
 static ssize_t lis3lv02d_calibrate_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "(%d,%d,%d)\n", adev.xcalib, adev.ycalib, adev.zcalib);
+	return sprintf(buf, "(%d,%d,%d)\n", lis3_dev.xcalib, lis3_dev.ycalib, lis3_dev.zcalib);
 }
 
 static ssize_t lis3lv02d_calibrate_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	lis3lv02d_increase_use(&adev);
+	lis3lv02d_increase_use(&lis3_dev);
 	lis3lv02d_calibrate_joystick();
-	lis3lv02d_decrease_use(&adev);
+	lis3lv02d_decrease_use(&lis3_dev);
 	return count;
 }
 
@@ -434,9 +444,9 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
 	u8 ctrl;
 	int val;
 
-	lis3lv02d_increase_use(&adev);
-	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
-	lis3lv02d_decrease_use(&adev);
+	lis3lv02d_increase_use(&lis3_dev);
+	lis3_dev.read(lis3_dev.device->handle, CTRL_REG1, &ctrl);
+	lis3lv02d_decrease_use(&lis3_dev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
 }
@@ -460,17 +470,17 @@ static struct attribute_group lis3lv02d_attribute_group = {
 
 static int lis3lv02d_add_fs(struct acpi_device *device)
 {
-	adev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
-	if (IS_ERR(adev.pdev))
-		return PTR_ERR(adev.pdev);
+	lis3_dev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
+	if (IS_ERR(lis3_dev.pdev))
+		return PTR_ERR(lis3_dev.pdev);
 
-	return sysfs_create_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
+	return sysfs_create_group(&lis3_dev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 }
 
 int lis3lv02d_remove_fs(void)
 {
-	sysfs_remove_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
-	platform_device_unregister(adev.pdev);
+	sysfs_remove_group(&lis3_dev.pdev->dev.kobj, &lis3lv02d_attribute_group);
+	platform_device_unregister(lis3_dev.pdev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 75972bf..017fb2b 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -194,4 +194,4 @@ void lis3lv02d_poweroff(acpi_handle handle);
 void lis3lv02d_poweron(acpi_handle handle);
 int lis3lv02d_remove_fs(void);
 
-extern struct acpi_lis3lv02d adev;
+extern struct acpi_lis3lv02d lis3_dev;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
