Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYFDTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYFDTY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYFDTYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:24:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:5568 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbYFDTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:24:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.388
Message-ID: <4846EBF5.2030406@tremplin-utc.net>
Date: Wed, 04 Jun 2008 21:24:37 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
 ACPI	driver -- please review!
References: <1212235533.3815.5.camel@localhost>
In-Reply-To: <1212235533.3815.5.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
We haven't received any review for this driver since last week's post by
Yan :-( That's why I'm adding explicitly as receivers of this email all
the people who have reviewed the first two previous takes. Apologies for
the possible multiple receptions.

It would be _really really kind_ if some of you could take some time and
comment (or simply ACK ;-) ) this code. It adds support for hardware
which can be found in mostly every HP Compaq laptop less than three
years old. It's quite worthy.

Mark, as maintainer of the hwmon tree, would accept this driver? Let us
know if there are things we need to change.

Thanks,
Eric

31-05-08 14:05, Yan Burman wrote/a écrit:
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
> Signed-off-by: Yan Burman <burman.yan@gmail.com>
> Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
> 
> 
> diff -Nrubp linux-2.6.25.4_orig/Documentation/hwmon/mdps linux-2.6.25.4/Documentation/hwmon/mdps
> --- linux-2.6.25.4_orig/Documentation/hwmon/mdps	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.25.4/Documentation/hwmon/mdps	2008-05-28 11:15:33.000000000 +0300
> @@ -0,0 +1,96 @@
> +Kernel driver mdps
> +==================
> +
> +Supported chips:
> +
> +  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
> +
> +Author:
> +        Yan Burman <burman.yan@gmail.com>
> +	Eric Piel <eric.piel@tremplin-utc.net>
> +
> +
> +Description
> +-----------
> +
> +This driver provides support for the accelerometer found in various HP laptops
> +sporting the feature officially called "HP Mobile Data Protection System 3D" or 
> +"HP 3D DriveGuard". HP nc6420, nc2510, nw9440 and nx9420 are supported right now, but
> +it should work on other models as well. The accelerometer data is readable via
> +/sys/devices/platform/mdps.
> +
> +Sysfs attributes under /sys/devices/platform/mdps/:
> +position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> +calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> +            write: forces the base to be recalibrated.
> +rate - reports the sampling rate of the accelerometer device in HZ
> +state - read: the current power state of the accelerometer device
> +        write: "0" or "1" to power on/off the device
> +
> +Load time parameters:
> +bool power_off - whether to power off the device on module load (default 0)
> +
> +This driver also provides an absolute input class device, allowing
> +the laptop to act as a pinball machine-esque joystick.
> +
> +Another feature of the driver is misc device called accel that acts
> +similar to /dev/rtc and reacts on free-fall interrupts received from
> +the device. It supports blocking operations, poll/select and fasync
> +operation modes. You must read 4 bytes from the device.
> +The result is number of free-fall interrupts since the last successful read.
> +
> +
> +Axes orientation
> +----------------
> +
> +For better compatibility between the various laptops. The values reported by
> +the accelerometer are converted into a "standard" organisation of the axes
> +(aka "can play neverball out of the box"):
> + * When the laptop is horizontal the position reported is about 0 for X and Y
> +and a positive value for Z
> + * If the left side is elevated, X increases (becomes positive)
> + * If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
> + * If the laptop is put upside-down, Z becomes negative
> +
> +If your laptop model is not recognized (cf "dmesg"), you can send an email to the
> +authors to add it to the database.  When reporting a new laptop, please include
> +the output of "dmidecode" plus the value of /sys/devices/platform/mdps/position
> +in these four cases.
> +
> +
> +Example userspace code for reading the accel device
> +---------------------------------------------------
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <string.h>
> +#include <stdint.h>
> +
> +int main(int argc, char* argv[])
> +{
> +	int fd, ret;
> +	uint32_t count;
> +
> +	fd = open("/dev/accel", O_RDONLY);
> +	if (fd < 0) {
> +		perror("open");
> +		return EXIT_FAILURE;
> +	}
> +
> +	for (;;) {
> +		ret = read(fd, &count, sizeof(count));
> +		if (ret != sizeof(count)) {
> +			perror("read");
> +			break;
> +		}
> +
> +		printf("Got %d free-fall interrupts\n", count);
> +	}
> +
> +	close(fd);
> +	return EXIT_SUCCESS;
> +}
> diff -Nrubp linux-2.6.25.4_orig/drivers/hwmon/Kconfig linux-2.6.25.4/drivers/hwmon/Kconfig
> --- linux-2.6.25.4_orig/drivers/hwmon/Kconfig	2008-05-28 11:09:04.000000000 +0300
> +++ linux-2.6.25.4/drivers/hwmon/Kconfig	2008-05-28 11:19:01.000000000 +0300
> @@ -760,6 +760,26 @@ config SENSORS_HDAPS
>  	  Say Y here if you have an applicable laptop and want to experience
>  	  the awesome power of hdaps.
>  
> +config SENSORS_MDPS
> +	tristate "HP Mobile Data Protection System 3D (mdps)"
> +	depends on ACPI && INPUT && X86
> +	default n
> +	help
> +	  This driver provides support for the HP Mobile Data Protection
> +	  System 3D (mdps), which is an accelerometer. HP nc6420, nw9440, nx9420 and
> +	  nc2510 are supported right now, but it may work on other models as well.
> +	  The accelerometer data is readable via /sys/devices/platform/mdps.
> +
> +	  This driver also provides an absolute input class device, allowing
> +	  the laptop to act as a pinball machine-esque joystick.
> +
> +	  Another feature of the driver is misc device called accel that acts
> +	  similar to /dev/rtc and reacts on free-fall interrupts received from
> +	  the device.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called mdps.
> +
>  config SENSORS_APPLESMC
>  	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
>  	depends on INPUT && X86
> diff -Nrubp linux-2.6.25.4_orig/drivers/hwmon/Makefile linux-2.6.25.4/drivers/hwmon/Makefile
> --- linux-2.6.25.4_orig/drivers/hwmon/Makefile	2008-05-28 11:09:04.000000000 +0300
> +++ linux-2.6.25.4/drivers/hwmon/Makefile	2008-05-28 11:13:48.000000000 +0300
> @@ -40,6 +40,7 @@ obj-$(CONFIG_SENSORS_FSCPOS)	+= fscpos.o
>  obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
>  obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
>  obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
> +obj-$(CONFIG_SENSORS_MDPS)	+= mdps.o
>  obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
> diff -Nrubp linux-2.6.25.4_orig/drivers/hwmon/mdps.c linux-2.6.25.4/drivers/hwmon/mdps.c
> --- linux-2.6.25.4_orig/drivers/hwmon/mdps.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.25.4/drivers/hwmon/mdps.c	2008-05-28 11:15:38.000000000 +0300
> @@ -0,0 +1,783 @@
> +/*
> + *  mdps.c - HP Mobile Data Protection System 3D ACPI driver
> + *
> + *  Copyright (C) 2007-2008 Yan Burman
> + *  Copyright (C) 2008 Eric Piel
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +/*
> + * 30/12/2006
> + * Added support for NX9420 and hdaps compatibility mode.
> + * Thanks to Jonas Majauskas for testing this on NX9420
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/dmi.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/kthread.h>
> +#include <linux/delay.h>
> +#include <linux/miscdevice.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/freezer.h>
> +#include <linux/version.h>
> +#include <linux/uaccess.h>
> +
> +#include <acpi/acpi_drivers.h>
> +
> +#include <asm/atomic.h>
> +
> +#define VERSION "0.92"
> +
> +#define DRIVER_NAME     "mdps"
> +#define ACPI_MDPS_CLASS "accelerometer"
> +#define ACPI_MDPS_ID    "HPQ0004"
> +
> +/* The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ
> + * that seems to be connected via SPI */
> +
> +#define MDPS_WHO_AM_I        0x0F /*r      00111010 */
> +#define MDPS_OFFSET_X        0x16 /*rw              */
> +#define MDPS_OFFSET_Y        0x17 /*rw              */
> +#define MDPS_OFFSET_Z        0x18 /*rw              */
> +#define MDPS_GAIN_X          0x19 /*rw              */
> +#define MDPS_GAIN_Y          0x1A /*rw              */
> +#define MDPS_GAIN_Z          0x1B /*rw              */
> +#define MDPS_CTRL_REG1       0x20 /*rw     00000111 */
> +#define MDPS_CTRL_REG2       0x21 /*rw     00000000 */
> +#define MDPS_CTRL_REG3       0x22 /*rw     00001000 */
> +#define MDPS_HP_FILTER RESET 0x23 /*r               */
> +#define MDPS_STATUS_REG      0x27 /*rw     00000000 */
> +#define MDPS_OUTX_L          0x28 /*r               */
> +#define MDPS_OUTX_H          0x29 /*r               */
> +#define MDPS_OUTY_L          0x2A /*r               */
> +#define MDPS_OUTY_H          0x2B /*r               */
> +#define MDPS_OUTZ_L          0x2C /*r               */
> +#define MDPS_OUTZ_H          0x2D /*r               */
> +#define MDPS_FF_WU_CFG       0x30 /*rw     00000000 */
> +#define MDPS_FF_WU_SRC       0x31 /*rw     00000000 */
> +#define MDPS_FF_WU_ACK       0x32 /*r               */
> +#define MDPS_FF_WU_THS_L     0x34 /*rw     00000000 */
> +#define MDPS_FF_WU_THS_H     0x35 /*rw     00000000 */
> +#define MDPS_FF_WU_DURATION  0x36 /*rw     00000000 */
> +#define MDPS_DD_CFG          0x38 /*rw     00000000 */
> +#define MDPS_DD_SRC          0x39 /*rw     00000000 */
> +#define MDPS_DD_ACK          0x3A /*r               */
> +#define MDPS_DD_THSI_L       0x3C /*rw     00000000 */
> +#define MDPS_DD_THSI_H       0x3D /*rw     00000000 */
> +#define MDPS_DD_THSE_L       0x3E /*rw     00000000 */
> +#define MDPS_DD_THSE_H       0x3F /*rw     00000000 */
> +
> +#define MDPS_ID		0x3A   /* MDPS_WHO_AM_I */
> +#define MDPS_FS		(1<<7) /* MDPS_CTRL_REG2 : Full Scale selection */
> +#define MDPS_BDU	(1<<6) /* MDPS_CTRL_REG2 : Block Data Update */
> +
> +/* joystick device poll interval in milliseconds */
> +#define MDPS_POLL_INTERVAL 30
> +
> +/* Maximum value our axis may get for the input device */
> +#define MDPS_MAX_VAL 2048
> +
> +static unsigned int power_off;
> +module_param(power_off, bool, S_IRUGO);
> +MODULE_PARM_DESC(power_off, "Turn off device on module load");
> +
> +struct axis_conversion {
> +	s8	x;
> +	s8	y;
> +	s8	z;
> +};
> +
> +struct acpi_mdps {
> +	struct acpi_device	*device;   /* The ACPI device */
> +	u32			irq;       /* IRQ number */
> +	struct input_dev	*idev;     /* input device */
> +	struct task_struct	*kthread;  /* kthread for input */
> +	int			xcalib;    /* calibrated null value for x */
> +	int			ycalib;    /* calibrated null value for y */
> +	int			zcalib;    /* calibrated null value for z */
> +	int			is_on;     /* whether the device is on or off */
> +	struct platform_device	*pdev;     /* platform device */
> +	atomic_t		count;     /* interrupt count after last read */
> +	struct fasync_struct	*async_queue;
> +	atomic_t		available; /* whether the device is open */
> +	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
> +	/* conversion between hw axis and logical ones */
> +	struct axis_conversion	ac;
> +};
> +
> +static struct acpi_mdps mdps;
> +
> +static int mdps_remove_fs(void);
> +static int mdps_add_fs(struct acpi_device *device);
> +static void mdps_joystick_enable(void);
> +static void mdps_joystick_disable(void);
> +
> +static struct acpi_device_id mdps_device_ids[] = {
> +	{ACPI_MDPS_ID, 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, mdps_device_ids);
> +
> +/** Create a single value from 2 bytes received from the accelerometer
> + * @param hi the high byte
> + * @param lo the low byte
> + * @return the resulting value
> + */
> +static inline s16 mdps_glue_bytes(unsigned long hi, unsigned long lo)
> +{
> +	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
> +	return (s16)((hi << 8) | lo);
> +}
> +
> +/** ACPI ALRD method: read a register
> + * @param handle the handle of the device
> + * @param reg the register to read
> + * @param[out] ret result of the operation
> + * @return AE_OK on success
> + */
> +static acpi_status mdps_ALRD(acpi_handle handle, int reg,
> +				unsigned long *ret)
> +{
> +	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
> +	struct acpi_object_list args = { 1, &arg0 };
> +
> +	arg0.integer.value = reg;
> +
> +	return acpi_evaluate_integer(handle, "ALRD", &args, ret);
> +}
> +
> +/** ACPI _INI method: initialize the device.
> + * @param handle the handle of the device
> + * @return 0 on success
> + */
> +static inline acpi_status mdps__INI(acpi_handle handle)
> +{
> +	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
> +}
> +
> +/** ACPI ALWR method: write to a register
> + * @param handle the handle of the device
> + * @param reg the register to write to
> + * @param val the value to write
> + * @param[out] ret result of the operation
> + * @return AE_OK on success
> + */
> +static acpi_status mdps_ALWR(acpi_handle handle, int reg, int val,
> +				unsigned long *ret)
> +{
> +	union acpi_object in_obj[2];
> +	struct acpi_object_list args = { 2, in_obj };
> +
> +	in_obj[0].type          = ACPI_TYPE_INTEGER;
> +	in_obj[0].integer.value = reg;
> +	in_obj[1].type          = ACPI_TYPE_INTEGER;
> +	in_obj[1].integer.value = val;
> +
> +	return acpi_evaluate_integer(handle, "ALWR", &args, ret);
> +}
> +
> +static int mdps_read_axis(acpi_handle handle, int lo_const, int hi_const)
> +{
> +	unsigned long lo_val, hi_val;
> +	mdps_ALRD(handle, lo_const, &lo_val);
> +	mdps_ALRD(handle, hi_const, &hi_val);
> +	return mdps_glue_bytes(hi_val, lo_val);
> +}
> +
> +static inline int mdps_get_axis(s8 axis, int hw_values[3])
> +{
> +	if (axis > 0)
> +		return hw_values[axis - 1];
> +	else
> +		return -hw_values[-axis - 1];
> +}
> +
> +/** Get X, Y and Z axis values from the accelerometer
> + * @param handle the handle to the device
> + * @param[out] x where to store the X axis value
> + * @param[out] y where to store the Y axis value
> + * @param[out] z where to store the Z axis value
> + * @note 40Hz input device can eat up about 10% CPU at 800MHZ
> + */
> +static void mdps_get_xyz(acpi_handle handle, int *x, int *y, int *z)
> +{
> +	int position[3];
> +	position[0] = mdps_read_axis(handle, MDPS_OUTX_L, MDPS_OUTX_H);
> +	position[1] = mdps_read_axis(handle, MDPS_OUTY_L, MDPS_OUTY_H);
> +	position[2] = mdps_read_axis(handle, MDPS_OUTZ_L, MDPS_OUTZ_H);
> +
> +	*x = mdps_get_axis(mdps.ac.x, position);
> +	*y = mdps_get_axis(mdps.ac.y, position);
> +	*z = mdps_get_axis(mdps.ac.z, position);
> +}
> +
> +/** Kthread polling function
> + * @param data unused - here to conform to threadfn prototype
> + */
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
> +
> +static inline void mdps_poweroff(acpi_handle handle)
> +{
> +	unsigned long ret;
> +	mdps.is_on = 0;
> +	/* disable X,Y,Z axis and power down */
> +	mdps_ALWR(handle, MDPS_CTRL_REG1, 0x00, &ret);
> +}
> +
> +static inline void mdps_poweron(acpi_handle handle)
> +{
> +	unsigned long val, retw;
> +
> +	mdps.is_on = 1;
> +	mdps__INI(handle);
> +	/*
> +	 * Change to Block Data Update mode: LSB and MSB values are not updated
> +	 * until both have been read. So the value read will always be correct.
> +	 */
> +	mdps_ALRD(handle, MDPS_CTRL_REG2, &val);
> +	val |= MDPS_BDU;
> +	mdps_ALWR(handle, MDPS_CTRL_REG2, val, &retw);
> +}
> +
> +#ifdef CONFIG_PM
> +static int mdps_suspend(struct acpi_device *device, pm_message_t state)
> +{
> +	/* make sure the device is off when we suspend */
> +	mdps_poweroff(mdps.device->handle);
> +	return 0;
> +}
> +#endif
> +
> +static int mdps_resume(struct acpi_device *device)
> +{
> +	/* make sure the device went online */
> +	mdps_poweron(mdps.device->handle);
> +	return 0;
> +}
> +
> +static irqreturn_t mdps_irq(int irq, void *dev_id)
> +{
> +	atomic_inc(&mdps.count);
> +
> +	wake_up_interruptible(&mdps.misc_wait);
> +	kill_fasync(&mdps.async_queue, SIGIO, POLL_IN);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int mdps_misc_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	if (!atomic_dec_and_test(&mdps.available)) {
> +		atomic_inc(&mdps.available);
> +		return -EBUSY; /* already open */
> +	}
> +
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
> +
> +static int mdps_misc_release(struct inode *inode, struct file *file)
> +{
> +	fasync_helper(-1, file, 0, &mdps.async_queue);
> +	free_irq(mdps.irq, mdps_irq);
> +	atomic_inc(&mdps.available); /* release the device */
> +	return 0;
> +}
> +
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
> +static unsigned int mdps_misc_poll(struct file *file, poll_table *wait)
> +{
> +	poll_wait(file, &mdps.misc_wait, wait);
> +	if (atomic_read(&mdps.count))
> +		return POLLIN | POLLRDNORM;
> +	return 0;
> +}
> +
> +static int mdps_misc_fasync(int fd, struct file *file, int on)
> +{
> +	return fasync_helper(fd, file, on, &mdps.async_queue);
> +}
> +
> +static const struct file_operations mdps_misc_fops = {
> +	.owner   = THIS_MODULE,
> +	.llseek  = no_llseek,
> +	.read    = mdps_misc_read,
> +	.open    = mdps_misc_open,
> +	.release = mdps_misc_release,
> +	.poll    = mdps_misc_poll,
> +	.fasync  = mdps_misc_fasync,
> +};
> +
> +static struct miscdevice mdps_misc_device = {
> +	.minor   = MISC_DYNAMIC_MINOR,
> +	.name    = "accel",
> +	.fops    = &mdps_misc_fops,
> +};
> +
> +static acpi_status
> +mdps_get_resource(struct acpi_resource *resource, void *context)
> +{
> +	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
> +		struct acpi_resource_extended_irq *irq;
> +		u32 *device_irq = context;
> +
> +		irq = &resource->data.extended_irq;
> +		*device_irq = irq->interrupts[0];
> +	}
> +
> +	return AE_OK;
> +}
> +
> +static void mdps_enum_resources(struct acpi_device *device)
> +{
> +	acpi_status status;
> +
> +	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
> +					mdps_get_resource, &mdps.irq);
> +	if (ACPI_FAILURE(status))
> +		printk(KERN_DEBUG "mdps: Error getting resources\n");
> +}
> +
> +static int mdps_dmi_matched(const struct dmi_system_id *dmi)
> +{
> +	mdps.ac = *(struct axis_conversion *)dmi->driver_data;
> +	printk(KERN_INFO "mdps: hardware type %s found.\n", dmi->ident);
> +
> +	return 1;
> +}
> +
> +
> +/* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
> + * If the value is negative, the opposite of the hw value is used. */
> +static struct axis_conversion mdps_axis_normal = {1, 2, 3};
> +static struct axis_conversion mdps_axis_y_inverted = {1, -2, 3};
> +static struct axis_conversion mdps_axis_x_inverted = {-1, 2, 3};
> +
> +static struct dmi_system_id mdps_dmi_ids[] = {
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NC64x0",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nc64"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NX9420",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx9420"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NW9440",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nw9440"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NC2510",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510"),
> +		},
> +		.driver_data = &mdps_axis_y_inverted
> +	},
> +	{ NULL, }
> +/* Laptop models without axis info (yet):
> + * "NC84x0" "HP Compaq nc84"
> + * "NC651xx" "HP Compaq 651"
> + * "NC671xx" "HP Compaq 671"
> + * "NC6910" "HP Compaq 6910"
> + * HP Compaq 8510x Notebook PC / Mobile Workstation
> + * HP Compaq 8710x Notebook PC / Mobile Workstation
> + * "NC2400" "HP Compaq nc2400"
> + * "NX74x0" "HP Compaq nx74"
> + * "NX6325" "HP Compaq nx6325"
> + * "NC4400" "HP Compaq nc4400"
> + */
> +};
> +
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
> +
> +	ret = misc_register(&mdps_misc_device);
> +	if (ret)
> +		printk(KERN_ERR "mdps: misc_register failed\n");
> +
> +	return 0;
> +}
> +
> +static int mdps_remove(struct acpi_device *device, int type)
> +{
> +	if (!device)
> +		return -EINVAL;
> +
> +	if (mdps.irq)
> +		misc_deregister(&mdps_misc_device);
> +
> +	mdps_joystick_disable();
> +
> +	return mdps_remove_fs();
> +}
> +
> +static inline void mdps_calibrate_joystick(void)
> +{
> +	mdps_get_xyz(mdps.device->handle, &mdps.xcalib, &mdps.ycalib,
> +		&mdps.zcalib);
> +}
> +
> +static int mdps_joystick_open(struct input_dev *dev)
> +{
> +	mdps.kthread = kthread_run(mdps_input_kthread, NULL, "kmdps");
> +	if (IS_ERR(mdps.kthread))
> +		return PTR_ERR(mdps.kthread);
> +
> +	return 0;
> +}
> +
> +static void mdps_joystick_close(struct input_dev *dev)
> +{
> +	kthread_stop(mdps.kthread);
> +}
> +
> +static void mdps_joystick_enable(void)
> +{
> +	if (mdps.idev)
> +		return;
> +
> +	mdps.idev = input_allocate_device();
> +	if (!mdps.idev)
> +		return;
> +
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
> +
> +static void mdps_joystick_disable(void)
> +{
> +	if (!mdps.idev)
> +		return;
> +
> +	input_unregister_device(mdps.idev);
> +	mdps.idev = NULL;
> +}
> +
> +/* Sysfs stuff */
> +static ssize_t mdps_position_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int x, y, z;
> +	mdps_get_xyz(mdps.device->handle, &x, &y, &z);
> +
> +	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
> +}
> +
> +static ssize_t mdps_state_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n", (mdps.is_on ? "on" : "off"));
> +}
> +
> +static ssize_t mdps_calibrate_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "(%d,%d,%d)\n", mdps.xcalib, mdps.ycalib,
> +			mdps.zcalib);
> +}
> +
> +static ssize_t mdps_calibrate_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	mdps_calibrate_joystick();
> +	return count;
> +}
> +
> +static ssize_t mdps_rate_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	unsigned long ctrl;
> +	int rate = 0;
> +
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
> +
> +	mdps.is_on = state;
> +
> +	if (mdps.is_on)
> +		mdps_poweron(mdps.device->handle);
> +	else
> +		mdps_poweroff(mdps.device->handle);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(position, S_IRUGO, mdps_position_show, NULL);
> +static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, mdps_calibrate_show,
> +	mdps_calibrate_store);
> +static DEVICE_ATTR(rate, S_IRUGO, mdps_rate_show, NULL);
> +static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mdps_state_show, mdps_state_store);
> +
> +static struct attribute *mdps_attributes[] = {
> +	&dev_attr_position.attr,
> +	&dev_attr_calibrate.attr,
> +	&dev_attr_rate.attr,
> +	&dev_attr_state.attr,
> +	NULL
> +};
> +
> +static struct attribute_group mdps_attribute_group = {
> +	.attrs = mdps_attributes
> +};
> +
> +static int mdps_add_fs(struct acpi_device *device)
> +{
> +	mdps.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
> +	if (IS_ERR(mdps.pdev))
> +		return PTR_ERR(mdps.pdev);
> +
> +	return sysfs_create_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
> +}
> +
> +static int mdps_remove_fs(void)
> +{
> +	sysfs_remove_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
> +	platform_device_unregister(mdps.pdev);
> +	return 0;
> +}
> +
> +static struct acpi_driver mdps_driver = {
> +	.name  = DRIVER_NAME,
> +	.class = ACPI_MDPS_CLASS,
> +	.ids   = mdps_device_ids,
> +	.ops = {
> +		.add     = mdps_add,
> +		.remove  = mdps_remove,
> +#ifdef CONFIG_PM
> +		.suspend = mdps_suspend,
> +		.resume  = mdps_resume
> +#endif
> +	}
> +};
> +
> +static int __init mdps_init_module(void)
> +{
> +	int ret;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	ret = acpi_bus_register_driver(&mdps_driver);
> +	if (ret < 0)
> +		return ret;
> +
> +	printk(KERN_INFO "mdps version " VERSION " loaded.\n");
> +
> +	return 0;
> +}
> +
> +static void __exit mdps_exit_module(void)
> +{
> +	acpi_bus_unregister_driver(&mdps_driver);
> +}
> +
> +MODULE_DESCRIPTION("HP three-axis digital accelerometer ACPI driver");
> +MODULE_AUTHOR("Yan Burman (burman.yan@gmail.com)");
> +MODULE_VERSION(VERSION);
> +MODULE_LICENSE("GPL");
> +
> +module_init(mdps_init_module);
> +module_exit(mdps_exit_module);

