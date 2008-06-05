Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYFEFSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYFEFSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 01:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYFEFSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 01:18:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYFEFSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 01:18:18 -0400
Date: Wed, 4 Jun 2008 22:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yan Burman <burman.yan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver
Message-Id: <20080604221724.48d06805.akpm@linux-foundation.org>
In-Reply-To: <1212235533.3815.5.camel@localhost>
References: <1212235533.3815.5.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 15:05:33 +0300 Yan Burman <burman.yan@gmail.com> wrote:

> HP Mobile Data Protection System 4D ACPI driver. Similar to hdaps and applesmc in functionality.
> This driver provides 3 kinds of functionality:
> 1) Creates a misc device /dev/accel that acts similar to /dev/rtc and unblocks
> the process reading from it when the device detects free-fall interrupt
> 2) Functions as an input class device to provide similar functionality to
> hdaps, in order to be able to use the laptop as a joystick
> 3) Makes it possible to power the device off.
> 
> Changes from previous post:
> Clean up all checkpatch.pl warnings
> Remove hdaps "compatibility" that made the drive disguise itself as hdaps
> Always provide 3D sensor readings instead of selecting 2D or 3D operation
> Make the driver load automatically for supported hardware
> Identify laptop models based on DMI and adjust axis information accordingly
> 
> The previous version of the driver seems to be used by quite a few people it seems
> based on the feedback I'm getting by mail, so perhaps it can be considered for
> inclusion in the kernel.
> 

Patch looks reasonable, although my head's spinning a bit over the
what-subsystem-is-this issue.

> +	}
> +
> +	close(fd);
> +	return EXIT_SUCCESS;
> +}
>
> ...
>
> +#include <asm/atomic.h>
> +
> +#define VERSION "0.92"

Beware that the version becomes essentially meaningless once the code
is merged into mainline.  It cannot be used to identify the exact
source code which a user is running - this is done via the main kernel
version instead.

I'd suggest removal.

> +#define DRIVER_NAME     "mdps"
> +#define ACPI_MDPS_CLASS "accelerometer"
> +#define ACPI_MDPS_ID    "HPQ0004"
> +
>
> ...
>
> +/** Create a single value from 2 bytes received from the accelerometer
> + * @param hi the high byte
> + * @param lo the low byte
> + * @return the resulting value
> + */

All these comments you have sort-of look like kerneldoc only they aren't.

I suggest that either they be converted to kerneldoc or the /** and
@param annotations be removed.


> +static inline s16 mdps_glue_bytes(unsigned long hi, unsigned long lo)
> +{
> +	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
> +	return (s16)((hi << 8) | lo);
> +}
> +
>
> ...
>
> +static int mdps_input_kthread(void *data)
> +{
> +	int x, y, z;
> +
> +	while (!kthread_should_stop()) {
> +		mdps_get_xyz(mdps.device->handle, &x, &y, &z);
> +		input_report_abs(mdps.idev, ABS_X, x - mdps.xcalib);
> +		input_report_abs(mdps.idev, ABS_Y, y - mdps.ycalib);
> +		input_report_abs(mdps.idev, ABS_Z, z - mdps.zcalib);
> +
> +		input_sync(mdps.idev);
> +
> +		try_to_freeze();
> +		msleep_interruptible(MDPS_POLL_INTERVAL);
> +	}
> +
> +	return 0;
> +}

This wakes up every 30 milliseconds which will make powertop users unhappy.

Is this unavoidable?

>
> ...
>
> +static int mdps_misc_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	if (!atomic_dec_and_test(&mdps.available)) {
> +		atomic_inc(&mdps.available);
> +		return -EBUSY; /* already open */
> +	}

These games with mdps.available are awkward and the above looks racy.

It will work out better if it is converted to test_and_set_bit() and
friends.

> +	atomic_set(&mdps.count, 0);
> +
> +	/* Can't have shared interrupts here, since we have no way
> +	 * to determine in interrupt context
> +	 * if it was our device that caused the interrupt */
> +	ret = request_irq(mdps.irq, mdps_irq, 0, "mdps", mdps_irq);
> +	if (ret) {
> +		atomic_inc(&mdps.available);
> +		printk(KERN_ERR "mdps: IRQ%d allocation failed\n", mdps.irq);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
>
> ...
>
> +static ssize_t mdps_misc_read(struct file *file, char __user *buf,
> +				size_t count, loff_t *pos)
> +{
> +	DECLARE_WAITQUEUE(wait, current);
> +	u32 data;
> +	ssize_t retval = count;
> +
> +	if (count != sizeof(u32))
> +		return -EINVAL;
> +
> +	add_wait_queue(&mdps.misc_wait, &wait);
> +	for (; ; ) {

	for ( ; ; ) {

> +		set_current_state(TASK_INTERRUPTIBLE);
> +		data = atomic_xchg(&mdps.count, 0);
> +		if (data)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			retval = -EAGAIN;
> +			goto out;
> +		}
> +
> +		if (signal_pending(current)) {
> +			retval = -ERESTARTSYS;
> +			goto out;
> +		}
> +
> +		schedule();
> +	}
> +
> +	/* make sure we are not going into copy_to_user() with
> +	 * TASK_INTERRUPTIBLE state */
> +	set_current_state(TASK_RUNNING);
> +	if (copy_to_user(buf, &data, sizeof(data)))
> +		retval = -EFAULT;
> +
> +out:
> +	__set_current_state(TASK_RUNNING);
> +	remove_wait_queue(&mdps.misc_wait, &wait);
> +
> +	return retval;
> +}
> +
>
> ...
>
> +static int mdps_dmi_matched(const struct dmi_system_id *dmi)
> +{
> +	mdps.ac = *(struct axis_conversion *)dmi->driver_data;

Please remove the nasty-looking cast.  dmi_system_id.driver_data is
already void*, and the cast will suppress compiler warnings which might
be useful.

> +	printk(KERN_INFO "mdps: hardware type %s found.\n", dmi->ident);
> +
> +	return 1;
> +}
> +
>
> ...
>
> +static int mdps_add(struct acpi_device *device)
> +{
> +	unsigned long val;
> +	int ret;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	mdps.device = device;
> +	strcpy(acpi_device_name(device), DRIVER_NAME);
> +	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);

So.. we avoid overflow via dead reckoning.  hm.

> +	acpi_driver_data(device) = &mdps;
> +
> +	mdps_ALRD(device->handle, MDPS_WHO_AM_I, &val);
> +	if (val != MDPS_ID) {
> +		printk(KERN_ERR
> +			"mdps: Accelerometer chip not LIS3LV02D{L,Q}\n");
> +		return -ENODEV;
> +	}
> +
> +	/* This is just to make sure that the same physical move
> +	 * is reported identically */
> +	if (dmi_check_system(mdps_dmi_ids) == 0) {
> +		printk(KERN_INFO "mdps: laptop model unknown, "
> +				 "using default axes configuration\n");
> +		mdps.ac = mdps_axis_normal;
> +	}
> +
> +	mdps_add_fs(device);
> +	mdps_resume(device);
> +
> +	mdps_joystick_enable();
> +
> +	/* obtain IRQ number of our device from ACPI */
> +	mdps_enum_resources(device);
> +
> +	if (power_off) /* see if user wanted to power off the device on load */
> +		mdps_poweroff(mdps.device->handle);
> +
> +	/* if we did not get an IRQ from ACPI - we have nothing more to do */
> +	if (!mdps.irq) {
> +		printk(KERN_INFO
> +			"mdps: No IRQ in ACPI. Disabling /dev/accel\n");
> +		return 0;
> +	}
> +
> +	atomic_set(&mdps.available, 1); /* init the misc device open count */
> +	init_waitqueue_head(&mdps.misc_wait);

It is preferable to do this at compile-time, which can be done with
__WAIT_QUEUE_HEAD_INITIALIZER(), and a bit of pain.

> +	ret = misc_register(&mdps_misc_device);
> +	if (ret)
> +		printk(KERN_ERR "mdps: misc_register failed\n");
> +
> +	return 0;
> +}
>
> ...
>
> +static void mdps_joystick_enable(void)
> +{
> +	if (mdps.idev)
> +		return;
> +
> +	mdps.idev = input_allocate_device();
> +	if (!mdps.idev)
> +		return;

No error propagation or reporting here?

> +	mdps_calibrate_joystick();
> +
> +	mdps.idev->name       = "HP Mobile Data Protection System";
> +	mdps.idev->phys       = "mdps/input0";
> +	mdps.idev->id.bustype = BUS_HOST;
> +	mdps.idev->id.vendor  = 0;
> +	mdps.idev->dev.parent   = &mdps.pdev->dev;
> +
> +	set_bit(EV_ABS, mdps.idev->evbit);
> +
> +	input_set_abs_params(mdps.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +	input_set_abs_params(mdps.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +	input_set_abs_params(mdps.idev, ABS_Z, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +
> +	mdps.idev->open  = mdps_joystick_open;
> +	mdps.idev->close = mdps_joystick_close;
> +
> +	if (input_register_device(mdps.idev)) {
> +		input_free_device(mdps.idev);
> +		mdps.idev = NULL;
> +	}
> +}
>
> ...
>
> +/* Sysfs stuff */

Was it tested with CONFIG_SYSFS=n?

> +static ssize_t mdps_position_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int x, y, z;
> +	mdps_get_xyz(mdps.device->handle, &x, &y, &z);

We typically put a blank line between end-of-locals and start-of-code.

> +	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
> +}
> +
> +static ssize_t mdps_state_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n", (mdps.is_on ? "on" : "off"));

	strcpy(buf, mdps.is_on ? "on\n" : "off\n");

:)

> +}
>
> ...
>
> +static ssize_t mdps_rate_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	unsigned long ctrl;
> +	int rate = 0;

This is an unneeded initialisation to shut the compiler up.  Problems
are a) it takes a lot of staring for the reader to work out why this
initialisation is here and b) it generates extra code.

unintialized_var() sovles both those issues, although some don't like it.

> +	mdps_ALRD(mdps.device->handle, MDPS_CTRL_REG1, &ctrl);
> +
> +	/* get the sampling rate of the accelerometer in HZ */
> +	switch ((ctrl & 0x30) >> 4) {
> +	case 00:
> +		rate = 40;
> +		break;
> +
> +	case 01:
> +		rate = 160;
> +		break;
> +
> +	case 02:
> +		rate = 640;
> +		break;
> +
> +	case 03:
> +		rate = 2560;
> +		break;
> +	}
> +
> +	return sprintf(buf, "%d\n", rate);
> +}
> +
> +static ssize_t mdps_state_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	int state;
> +	if (sscanf(buf, "%d", &state) != 1 || (state != 1 && state != 0))
> +		return -EINVAL;

space-after-locals, please.

> +	mdps.is_on = state;
> +
> +	if (mdps.is_on)
> +		mdps_poweron(mdps.device->handle);
> +	else
> +		mdps_poweroff(mdps.device->handle);
> +
> +	return count;
> +}
>
> ...
>
> +static int mdps_add_fs(struct acpi_device *device)
> +{
> +	mdps.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
> +	if (IS_ERR(mdps.pdev))
> +		return PTR_ERR(mdps.pdev);

in lots of places.

> +	return sysfs_create_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
> +}
> +
>
> ...
>
