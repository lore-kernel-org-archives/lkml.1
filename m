Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZJFPgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZJFPgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932644AbZJFPgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:36:02 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59275 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbZJFPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:36:00 -0400
Date: Tue, 6 Oct 2009 08:25:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com
Subject: Re: [PATCH] Haptic class support (v2)
Message-Id: <20091006082514.a0424ec8.randy.dunlap@oracle.com>
In-Reply-To: <20091006074533.GA28889@july>
References: <20091006074533.GA28889@july>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACB63AF.00C2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 16:45:33 +0900 Kyungmin Park wrote:

> This patch includes two haptic devices, isa1000 and isa1200
> ISA1000 is gpio based haptic, but isa1200 is based on I2C
> Both are working on Samsung SoCs and tested.
> 
> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
> or
> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/Kconfig                     |    2
>  drivers/Makefile                    |    1
>  drivers/haptic/Kconfig              |   31 ++
>  drivers/haptic/Makefile             |    8
>  drivers/haptic/haptic-class.c       |  256 ++++++++++++++++++++++
>  drivers/haptic/haptic-samsung-pwm.c |  377 ++++++++++++++++++++++++++++++++
>  drivers/haptic/haptic.h             |   35 +++
>  drivers/haptic/isa1200.c            |  413 ++++++++++++++++++++++++++++++++++++
>  include/linux/haptic.h              |   85 +++++++
>  9 files changed, 1208 insertions(+)
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 48bbdbe..d44a601 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
>  
>  source "drivers/hwmon/Kconfig"
>  
> +source "drivers/haptic/Kconfig"
> +
>  source "drivers/thermal/Kconfig"
>  
>  source "drivers/watchdog/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 6ee53c7..16b8f67 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -77,6 +77,7 @@ obj-$(CONFIG_PPS)		+= pps/
>  obj-$(CONFIG_W1)		+= w1/
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/
> +obj-$(CONFIG_HAPTIC)		+= haptic/
>  obj-$(CONFIG_THERMAL)		+= thermal/
>  obj-$(CONFIG_WATCHDOG)		+= watchdog/
>  obj-$(CONFIG_PHONE)		+= telephony/
> diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
> new file mode 100644
> index 0000000..9acb02a
> --- /dev/null
> +++ b/drivers/haptic/Kconfig
> @@ -0,0 +1,31 @@
> +menuconfig HAPTIC
> +	bool "HAPTIC support"
> +	help
> +	  Say Y to enalbe haptic support. It enables the haptic and controlled

	           enable
The next sentence is incomplete.  Maybe it should be (but I don't know):

	                                  It enables haptic devices and controls

> +	  from both userspace and kernel

	                      and kernel.

> +
> +if HAPTIC
> +
> +config HAPTIC_CLASS
> +	tristate "Haptic Class Support"
> +	help
> +	  This option enables the haptic sysfs class in /sys/class/haptic.
> +
> +comment "Haptic drivers"
> +
> +config HAPTIC_SAMSUNG_PWM
> +	tristate "Haptic Support for SAMSUNG PWM-controlled motor (ISA1000)"
> +	depends on HAPTIC_CLASS && (ARCH_S3C64XX || ARCH_S5PC1XX)
> +	help
> +	  This options enables support for haptic connected to GPIO lines
> +	  controlled by a PWM timer on SAMSUNG CPUs.
> +
> +comment "Haptic chips"
> +
> +config HAPTIC_ISA1200
> +	tristate "Haptic Motor"
> +	depends on HAPTIC_CLASS && I2C
> +	help
> +	  The ISA1200 is a high performance enhanced haptic motor driver

end sentence with period ('.')


> +
> +endif	# HAPTIC

> diff --git a/drivers/haptic/haptic-class.c b/drivers/haptic/haptic-class.c
> new file mode 100644
> index 0000000..b93e8e0
> --- /dev/null
> +++ b/drivers/haptic/haptic-class.c
> @@ -0,0 +1,256 @@
> +/*
> + *  Haptic Class Core
> + *
> + *  Copyright (C) 2008 Samsung Electronics
> + *  Kyungmin Park <kyungmin.park@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +

> +/**
> + * haptic_classdev_unregister - unregisters a object of haptic_properties class.

s/haptic_properties/haptic_classdev/ ??

> + * @haptic_cdev: the haptic device to unregister
> + *
> + * Unregisters a previously registered via haptic_classdev_register object.
> + */
> +void haptic_classdev_unregister(struct haptic_classdev *haptic_cdev)
> +{
> +	class_remove_file(haptic_class, &class_attr_enable);
> +	class_remove_file(haptic_class, &class_attr_oneshot);
> +	class_remove_file(haptic_class, &class_attr_level);
> +	class_remove_file(haptic_class, &class_attr_level_max);
> +	class_remove_file(haptic_class, &class_attr_value);
> +
> +	device_unregister(haptic_cdev->dev);
> +
> +	down_write(&haptic_list_lock);
> +	list_del(&haptic_cdev->node);
> +	up_write(&haptic_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(haptic_classdev_unregister);

> diff --git a/drivers/haptic/haptic-samsung-pwm.c b/drivers/haptic/haptic-samsung-pwm.c
> new file mode 100644
> index 0000000..0fc1093
> --- /dev/null
> +++ b/drivers/haptic/haptic-samsung-pwm.c
> @@ -0,0 +1,377 @@
> +/*
> + *  drivers/haptic/haptic-samsung-pwm.c
> + *
> + *  Copyright (C) 2008 Samsung Electronics
> + *  Kyungmin Park <kyungmin.park@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +


> diff --git a/drivers/haptic/isa1200.c b/drivers/haptic/isa1200.c
> new file mode 100644
> index 0000000..19a3801
> --- /dev/null
> +++ b/drivers/haptic/isa1200.c
> @@ -0,0 +1,413 @@
> +/*
> + *  isa1200.c - Haptic Motor
> + *
> + *  Copyright (C) 2009 Samsung Electronics
> + *  Kyungmin Park <kyungmin.park@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +struct isa1200_chip {
> +	struct i2c_client *client;
> +	struct pwm_device *pwm;
> +	struct haptic_classdev cdev;
> +	struct work_struct work;
> +	struct timer_list timer;
> +
> +	unsigned int	len;		/* LDO enable */
> +	unsigned int	hen;		/* Haptic haptic enable */

Drop one "haptic" ?

> +
> +	int enable;
> +	int powered;
> +
> +	int level;
> +	int level_max;
> +
> +	int ldo_level;
> +};

---
~Randy
