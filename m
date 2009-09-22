Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZIVMmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZIVMmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZIVMmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:42:03 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:41766 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbZIVMmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:42:01 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AB8C62F.5020605@cam.ac.uk>
Date: Tue, 22 Sep 2009 13:42:23 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: Re: [RFC] [PATCH 1/2] introduce ALS sysfs class
References: <1253590755.15763.21.camel@rzhang-dt>
In-Reply-To: <1253590755.15763.21.camel@rzhang-dt>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui wrote:
> Hi, Jonathan,
> 
> this is the refresh ALS sysfs class driver.
> I just introduced one sysfs attribute "illuminance", because
> I didn't catch the exact meaning of the others like "﻿infrared".
> So it would be great if you can generate an incremental patch
> to introduce the other optional attributes needed, and update
> the documentation as well. :)
Will do, though may just leave it out of first pass of drivers
(as it may be controversial and it would be nice to get something
in place before the arguments begin!)

All looks nice and clean. The only real question is whether
we want to standardize naming of devices under sysfs (like hwmon does)
or allow the individual drivers to do the naming?
I'm happy either way.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Thanks for all your work on this. I'm out of the lab until the weekend
so I'll get to porting the tsl drivers after that.

> 
> Subject: Introduce ALS sysfs class
> 
> ALS sysfs class device provides a standard sysfs interface
> for Ambient Light Sensor devices.
> 
> Only one sysfs I/F is introduced currently.
> /sys/class/als/xxx/illuminance:
> 	indicates the amount of light incident upon a specified surface area.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-class-als |    9 +++
>  MAINTAINERS                               |    6 ++
>  drivers/Kconfig                           |    2 
>  drivers/Makefile                          |    1 
>  drivers/als/Kconfig                       |   10 ++++
>  drivers/als/Makefile                      |    5 ++
>  drivers/als/als_sys.c                     |   74 ++++++++++++++++++++++++++++++
>  include/linux/als_sys.h                   |   35 ++++++++++++++
>  8 files changed, 142 insertions(+)
> 
> Index: linux-2.6/drivers/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/Kconfig
> +++ linux-2.6/drivers/Kconfig
> @@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
>  
>  source "drivers/hwmon/Kconfig"
>  
> +source "drivers/als/Kconfig"
> +
>  source "drivers/thermal/Kconfig"
>  
>  source "drivers/watchdog/Kconfig"
> Index: linux-2.6/drivers/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/Makefile
> +++ linux-2.6/drivers/Makefile
> @@ -76,6 +76,7 @@ obj-$(CONFIG_PPS)		+= pps/
>  obj-$(CONFIG_W1)		+= w1/
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/
> +obj-$(CONFIG_ALS)		+= als/
>  obj-$(CONFIG_THERMAL)		+= thermal/
>  obj-$(CONFIG_WATCHDOG)		+= watchdog/
>  obj-$(CONFIG_PHONE)		+= telephony/
> Index: linux-2.6/drivers/als/Kconfig
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/als/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Ambient Light Sensor sysfs device configuration
> +#
> +
> +menuconfig ALS
> +	tristate "Ambient Light Sensor sysfs device"
> +	help
> +	  This framework provides a generic sysfs I/F for Ambient Light
> +	  Sensor devices.
> +	  If you want this support, you should say Y or M here.
> Index: linux-2.6/drivers/als/Makefile
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/als/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for sensor chip drivers.
> +#
> +
> +obj-$(CONFIG_ALS)		+= als_sys.o
> Index: linux-2.6/drivers/als/als_sys.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/als/als_sys.c
> @@ -0,0 +1,74 @@
> +/*
> + *  als_sys.c - Ambient Light Sensor Sysfs support.
> + *
> + *  Copyright (C) 2009 Intel Corp
> + *  Copyright (C) 2009 Zhang Rui <rui.zhang@intel.com>
> + *
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/kdev_t.h>
> +
> +MODULE_AUTHOR("Zhang Rui <rui.zhang@intel.com>");
> +MODULE_DESCRIPTION("Ambient Light Sensor sysfs/class support");
> +MODULE_LICENSE("GPL");
> +
> +static struct class *als_class;
> +
> +/**
> + * als_device_register - register a new Ambient Light Sensor class device
> + * @parent:	the device to register.
> + *
> + * Returns the pointer to the new device
> + */
> +struct device *als_device_register(struct device *dev, char *name)
> +{
> +	return device_create(als_class, dev, MKDEV(0, 0), NULL, name);
> +}
> +EXPORT_SYMBOL(als_device_register);
> +
> +/**
> + * als_device_unregister - removes the registered ALS class device
> + * @dev:	the class device to destroy.
> + */
> +void als_device_unregister(struct device *dev)
> +{
> +	device_unregister(dev);
> +}
> +EXPORT_SYMBOL(als_device_unregister);
> +
> +static int __init als_init(void)
> +{
> +	als_class = class_create(THIS_MODULE, "als");
> +	if (IS_ERR(als_class)) {
> +		printk(KERN_ERR "als_sys.c: couldn't create sysfs class\n");
> +		return PTR_ERR(als_class);
> +	}
> +	return 0;
> +}
> +
> +static void __exit als_exit(void)
> +{
> +	class_destroy(als_class);
> +}
> +
> +subsys_initcall(als_init);
> +module_exit(als_exit);
> Index: linux-2.6/include/linux/als_sys.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/als_sys.h
> @@ -0,0 +1,35 @@
> +/*
> + *  als_sys.h
> + *
> + *  Copyright (C) 2009  Intel Corp
> + *  Copyright (C) 2009  Zhang Rui <rui.zhang@intel.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#ifndef __ALS_SYS_H__
> +#define __ALS_SYS_H__
> +
> +#include <linux/device.h>
> +
> +#define ALS_ILLUMINANCE_MIN 0
> +#define ALS_ILLUMINANCE_MAX -1
> +
> +struct device *als_device_register(struct device *dev, char *name);
> +void als_device_unregister(struct device *dev);
I guess these are simple enough that it doesn't really matter,
but some documentation might be nice.
> +
> +#endif /* __ALS_SYS_H__ */
> Index: linux-2.6/Documentation/ABI/testing/sysfs-class-als
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/ABI/testing/sysfs-class-als
> @@ -0,0 +1,9 @@
> +What:		/sys/class/als/.../illuminance
> +Date:		Sep. 2009
> +KernelVersion:	2.6.32
> +Contact:	Zhang Rui <rui.zhang@intel.com>
> +Description:	Current Ambient Light Illuminance reported by
> +		native ALS driver
> +		Unit: lux (lumens per square meter)
> +		RO
> +
> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS
> +++ linux-2.6/MAINTAINERS
> @@ -399,6 +399,12 @@ S:	Maintained for 2.4; PCI support for 2
>  L:	linux-alpha@vger.kernel.org
>  F:	arch/alpha/
>  
> +AMBIENT LIGHT SENSOR
> +M:	Zhang Rui <rui.zhang@intel.com>
> +S:	Supported
> +F:	include/linux/als_sys.h
> +F:	drivers/als/
> +
>  AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
>  M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
>  L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
> 
> 
> 

