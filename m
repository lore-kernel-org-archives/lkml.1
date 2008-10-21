Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYJUSm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYJUSm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJUSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:42:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807AbYJUSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:42:16 -0400
Date: Tue, 21 Oct 2008 11:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, burman.yan@gmail.com,
       pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-Id: <20081021114121.5144841c.akpm@linux-foundation.org>
In-Reply-To: <48FA3368.1040605@tremplin-utc.net>
References: <48FA3368.1040605@tremplin-utc.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 21:05:12 +0200
Eric Piel <eric.piel@tremplin-utc.net> wrote:

>
> ...
>
> LIS3LV02Dx Accelerometer driver
> 
> This adds a driver to the accelerometer sensor found in several HP laptops
> (under the commercial names of "HP Mobile Data Protection System 3D" and
> "HP 3D driveguard"). It tries to have more or less the same interfaces
> as the hdaps and other accelerometer drivers: in sysfs and as a
> joystick. 
> 
> This driver was first written by Yan Burman. Eric Piel has updated it
> and slimed it up (including the removal of an interface to access to the
> free-fall feature of the sensor because it is not reliable enough for
> now).  Several people have contributed to the database of the axes.
>
> ...
>
> +struct acpi_lis3lv02d {
> +	struct acpi_device	*device;   /* The ACPI device */
> +	struct input_dev	*idev;     /* input device */
> +	struct task_struct	*kthread;  /* kthread for input */
> +	struct timer_list	poff_timer; /* for automatic power off */
> +	struct semaphore	poff_sem;  /* lock to handle on/off timer */

OK, this can't be a mutex because it's upped from a timer handler
(which seems a bit odd, but I assume you know what you're doing ;))

> +	struct platform_device	*pdev;     /* platform device */
> +	atomic_t		count;     /* interrupt count after last read */
> +	int			xcalib;    /* calibrated null value for x */
> +	int			ycalib;    /* calibrated null value for y */
> +	int			zcalib;    /* calibrated null value for z */
> +	unsigned char		is_on;     /* whether the device is on or off */
> +	unsigned char		usage;     /* usage counter */
> +	struct axis_conversion	ac;        /* hw -> logical axis */
> +};
> +
> +static struct acpi_lis3lv02d adev = {
> +	.poff_sem   = __SEMAPHORE_INITIALIZER(adev.poff_sem, 1),
> +	.usage       = 0,

the .foo=0 isn't strictly needed.  It can be retained if you believe it
has documentary value.

> +};
> +
> +static int lis3lv02d_remove_fs(void);
> +static int lis3lv02d_add_fs(struct acpi_device *device);
> +
> +/* For automatic insertion of the module */
> +static struct acpi_device_id lis3lv02d_device_ids[] = {
> +	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
> +
> +/**
> + * acpi_init() - ACPI _INI method: initialize the device.

Should be "lis3lv02d_acpi_init"

> + * @handle: the handle of the device
> + *
> + * Returns AE_OK on success.
> + */
> +static inline acpi_status lis3lv02d_acpi_init(acpi_handle handle)
> +{
> +	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
> +}
> +
> +/**
> + * lis3lv02d_acpi_read() - ACPI ALRD method: read a register

All the kerneldoc comments include the () after the function name. 
That is unconventional and I do not know what effect it will have upon
kerneldoc processing and output.

> + * @handle: the handle of the device
> + * @reg:    the register to read
> + * @ret:    result of the operation
> + *
> + * Returns AE_OK on success.
> + */
> +static acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
> +{
> +	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
> +	struct acpi_object_list args = { 1, &arg0 };
> +	unsigned long lret;
> +	acpi_status status;
> +
> +	arg0.integer.value = reg;
> +
> +	status = acpi_evaluate_integer(handle, "ALRD", &args, &lret);
> +	*ret = lret;
> +	return status;
> +}
> +
>
> ...
>
> +static int lis3lv02d_resume(struct acpi_device *device)
> +{
> +	/* put back the device in the right state (ACPI might turn it on) */
> +	down(&adev.poff_sem);
> +	if (adev.usage > 0)
> +		lis3lv02d_poweron(device->handle);
> +	else
> +		lis3lv02d_poweroff(device->handle);
> +	up(&adev.poff_sem);
> +	return 0;
> +}

This function is unused if CONFIG_PM=n.

Please move this inside the ifdef then add

#else
#define lis3lv02d_suspend NULL
#define lis3lv02d_resume NULL
#endif

and remove the ifdefs in the lis3lv02d_driver definition.  Standard
stuff.


>
> ...
>
> +static void lis3lv02d_poweroff_timeout(unsigned long data)
> +{
> +	struct acpi_lis3lv02d *dev = (void *)data;
> +
> +	up(&dev->poff_sem);
> +	lis3lv02d_poweroff(dev->device->handle);
> +	down(&dev->poff_sem);

eek, no, we cannot down a semaphore from a timer handler!  It will lead
to might_sleep() warnings, scheduling-in-atomic warnings and kernel
deadlocks.

> +}
> +
>
> ...
>
> +static int lis3lv02d_remove(struct acpi_device *device, int type)
> +{
> +	if (!device)
> +		return -EINVAL;
> +
> +	lis3lv02d_joystick_disable();
> +	del_timer(&adev.poff_timer);

Should this be del_timer_sync()?

Bear in mind that the timer handler might be running on another CPU
after del_timer() returns...

> +	lis3lv02d_poweroff(device->handle);
> +
> +	return lis3lv02d_remove_fs();

so the above things can occur in parallel with the execution of the
timer handler.

>
> ...
>

