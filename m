Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZIVMzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZIVMzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbZIVMzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:55:12 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:46076 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbZIVMzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:55:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AB8C945.8050309@cam.ac.uk>
Date: Tue, 22 Sep 2009 13:55:33 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] [PATCH 2/2] ACPI: introduce ACPI ALS device driver
References: <1253590777.15763.22.camel@rzhang-dt>
In-Reply-To: <1253590777.15763.22.camel@rzhang-dt>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note I have no familiarity at all with the acpi side of things!
Other than a few queries, this looks fine to me.

Jonathan
> ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when
> the environment changes.
> 
> This patch introduces the ACPI ALS device driver.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/acpi/debug.txt |    1 
>  MAINTAINERS                  |    7 +
>  drivers/acpi/Kconfig         |    9 +
>  drivers/acpi/Makefile        |    1 
>  drivers/acpi/als.c           |  223 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/debug.c         |    1 
>  include/acpi/acpi_drivers.h  |    1 
>  7 files changed, 243 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/als.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/acpi/als.c
> @@ -0,0 +1,223 @@
> +/*
> + *  als.c - ACPI Ambient Light Sensor Driver
> + *
> + *  Copyright (C) 2009 Intel Corp
> + *  Copyright (C) 2009 Zhang Rui <rui.zhang@intel.com>
> + *
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/als_sys.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +
> +#define PREFIX "ACPI: "
> +
> +#define ACPI_ALS_CLASS			"als"
> +#define ACPI_ALS_DEVICE_NAME		"Ambient Light Sensor"
> +#define ACPI_ALS_NOTIFY_ILLUMINANCE	0x80
> +#define ACPI_ALS_NOTIFY_COLOR_TEMP	0x81
> +#define ACPI_ALS_NOTIFY_RESPONSE	0x82
> +
> +#define _COMPONENT		ACPI_ALS_COMPONENT
> +ACPI_MODULE_NAME("als");
> +
> +MODULE_AUTHOR("Zhang Rui");
> +MODULE_DESCRIPTION("ACPI Ambient Light Sensor Driver");
> +MODULE_LICENSE("GPL");
> +
> +static int acpi_als_add(struct acpi_device *device);
> +static int acpi_als_remove(struct acpi_device *device, int type);
> +static void acpi_als_notify(struct acpi_device *device, u32 event);
> +
> +static const struct acpi_device_id als_device_ids[] = {
> +	{"ACPI0008", 0},
> +	{"", 0},
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, als_device_ids);
> +
> +static struct acpi_driver acpi_als_driver = {
> +	.name = "als",
> +	.class = ACPI_ALS_CLASS,
> +	.ids = als_device_ids,
> +	.ops = {
> +		.add = acpi_als_add,
> +		.remove = acpi_als_remove,
> +		.notify = acpi_als_notify,
> +		},
> +};
> +
> +struct acpi_als {
> +	struct acpi_device *device;
> +	struct device *classdev;	/* pointer to als sysfs/class device */
> +	int illuminance;
> +};
> +
> +/* --------------------------------------------------------------------------
> +		Ambient Light Sensor device Management
> +   -------------------------------------------------------------------------- */
> +
> +/*
> + * acpi_als_get_illuminance - get the current ambient light illuminance
> + */
> +static int acpi_als_get_illuminance(struct acpi_als *als)
> +{
> +	acpi_status status;
> +	unsigned long long illuminance;
> +
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALI", NULL,
> +				  &illuminance);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_EXCEPTION((AE_INFO, status,
> +				"Error reading ALS illuminance"));
> +		return -ENOENT;
> +	}
> +	als->illuminance = illuminance;
> +	return 0;
> +}
> +
> +
> +/* --------------------------------------------------------------------------
> +				sysfs I/F
> +   -------------------------------------------------------------------------- */
> +static int
> +illuminance_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct acpi_device *device = to_acpi_device(dev->parent);
> +	struct acpi_als *als = acpi_driver_data(device);
> +	int result;
> +
> +	result = acpi_als_get_illuminance(als);
> +	if (result)
> +		return result;
> +
> +	if (als->illuminance < -1)
> +		return -EINVAL;
> +
> +	return sprintf(buf, "%d\n", als->illuminance);
> +}
> +
> +DEVICE_ATTR(illuminance, 0444, illuminance_show, NULL);
> +
> +/* --------------------------------------------------------------------------
> +				 Driver Model
> +   -------------------------------------------------------------------------- */
> +
> +static void acpi_als_notify(struct acpi_device *device, u32 event)
> +{
> +	struct acpi_als *als = acpi_driver_data(device);
> +
> +	if (!als)
> +		return;
> +
> +	switch (event) {
> +	case ACPI_ALS_NOTIFY_ILLUMINANCE:
> +		acpi_als_get_illuminance(als);
> +		break;
> +	case ACPI_ALS_NOTIFY_COLOR_TEMP:
> +		/*
> +		 *  TODO:
> +		 *  re-evalute the color temperature and chromaticity
> +		 */
> +		break;
> +	case ACPI_ALS_NOTIFY_RESPONSE:
> +		/*
> +		 * TODO:
> +		 * update the Ambient Light Illuminance to
> +		 * Display Luminance Adjustment Mappings
> +		 */
> +		break;
> +	default:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "Unsupported event [0x%x]\n", event));
> +	}
> +	acpi_bus_generate_proc_event(device, event, (u32) als->illuminance);
> +	acpi_bus_generate_netlink_event(device->pnp.device_class,
> +					dev_name(&device->dev), event,
> +					(u32) als->illuminance);
> +}
> +
> +static int acpi_als_add(struct acpi_device *device)
> +{
> +	int result;
Are there any plausible race conditions associated with doing the allocation this way?
This variable may need some protection. (I'm guessing acpi may prevent simultaneous
add calls?)
> +	static int als_id;
> +	char name[10];
> +	struct acpi_als *als;
> +
> +	if (unlikely(als_id >= 10)) {
> +		printk(KERN_WARNING PREFIX "Too many ALS device found\n");
> +		return -ENODEV;
> +	}
> +
> +	als = kzalloc(sizeof(struct acpi_als), GFP_KERNEL);
> +	if (!als)
> +		return -ENOMEM;
> +
> +	als->device = device;
> +	strcpy(acpi_device_name(device), ACPI_ALS_DEVICE_NAME);
> +	strcpy(acpi_device_class(device), ACPI_ALS_CLASS);
> +	device->driver_data = als;
> +
> +	result = acpi_als_get_illuminance(als);
> +	if (result)
> +		goto end;
> +
> +	sprintf(name, "acpi_als%d", als_id++);
> +	als->classdev = als_device_register(&device->dev, name);
> +	if (IS_ERR(als->classdev)) {
> +		result = PTR_ERR(als->classdev);
> +		goto end;
> +	}
> +
> +	result = device_create_file(als->classdev, &dev_attr_illuminance);
> +	if (result)
> +		als_device_unregister(als->classdev);
> +
> +end:
> +	if (result)
If it fails, do you want to decrement als_id (for consistency sake if nothing else)?
> +		kfree(als);
> +	return result;
> +}
> +
> +static int acpi_als_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_als *als = acpi_driver_data(device);
> +
> +	als_device_unregister(als->classdev);
> +	kfree(als);
> +	return 0;
> +}
> +
> +static int __init acpi_als_init(void)
> +{
> +	return acpi_bus_register_driver(&acpi_als_driver);
> +}
> +
> +static void __exit acpi_als_exit(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_als_driver);
> +}
> +
> +module_init(acpi_als_init);
> +module_exit(acpi_als_exit);
> Index: linux-2.6/drivers/acpi/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/Kconfig
> +++ linux-2.6/drivers/acpi/Kconfig
> @@ -333,4 +333,13 @@ config ACPI_SBS
>  	  To compile this driver as a module, choose M here:
>  	  the modules will be called sbs and sbshc.
>  
> +config ACPI_ALS
> +	tristate "Ambient Light Sensor driver"
> +	select ALS
> +	help
> +	  This driver supports the ACPI Ambient Light Sensor.
> +
> +	  To compile this driver as a module, choose M here:
> +	  the module will be called als.
> +
>  endif	# ACPI
> Index: linux-2.6/drivers/acpi/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/Makefile
> +++ linux-2.6/drivers/acpi/Makefile
> @@ -56,6 +56,7 @@ obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acp
>  obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
>  obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
>  obj-$(CONFIG_ACPI_SBS)		+= sbs.o
> +obj-$(CONFIG_ACPI_ALS)		+= als.o
>  
>  # processor has its own "processor." module_param namespace
>  processor-y			:= processor_core.o processor_throttling.o
> Index: linux-2.6/Documentation/acpi/debug.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/acpi/debug.txt
> +++ linux-2.6/Documentation/acpi/debug.txt
> @@ -63,6 +63,7 @@ shows the supported mask values, current
>      ACPI_MEMORY_DEVICE_COMPONENT    0x08000000
>      ACPI_VIDEO_COMPONENT            0x10000000
>      ACPI_PROCESSOR_COMPONENT        0x20000000
> +    ACPI_ALS_COMPONENT              0x40000000
>  
>  debug_level
>  -----------
> Index: linux-2.6/drivers/acpi/debug.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/debug.c
> +++ linux-2.6/drivers/acpi/debug.c
> @@ -53,6 +53,7 @@ static const struct acpi_dlayer acpi_deb
>  	ACPI_DEBUG_INIT(ACPI_MEMORY_DEVICE_COMPONENT),
>  	ACPI_DEBUG_INIT(ACPI_VIDEO_COMPONENT),
>  	ACPI_DEBUG_INIT(ACPI_PROCESSOR_COMPONENT),
> +	ACPI_DEBUG_INIT(ACPI_ALS_COMPONENT),
>  };
>  
>  static const struct acpi_dlevel acpi_debug_levels[] = {
> Index: linux-2.6/include/acpi/acpi_drivers.h
> ===================================================================
> --- linux-2.6.orig/include/acpi/acpi_drivers.h
> +++ linux-2.6/include/acpi/acpi_drivers.h
> @@ -49,6 +49,7 @@
>  #define ACPI_MEMORY_DEVICE_COMPONENT	0x08000000
>  #define ACPI_VIDEO_COMPONENT		0x10000000
>  #define ACPI_PROCESSOR_COMPONENT	0x20000000
> +#define ACPI_ALS_COMPONENT		0x40000000
>  
>  /*
>   * _HID definitions
> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS
> +++ linux-2.6/MAINTAINERS
> @@ -234,6 +234,13 @@ F:	drivers/acpi/
>  F:	drivers/pnp/pnpacpi/
>  F:	include/linux/acpi.h
>  
> +ACPI AMBIENT LIGHT SENSOR DRIVER
> +M:	Zhang Rui <rui.zhang@intel.com>
> +L:	linux-acpi@vger.kernel.org
> +W:	http://www.lesswatts.org/projects/acpi/
> +S:	Supported
> +F:	drivers/acpi/als.c
> +
>  ACPI BATTERY DRIVERS
>  M:	Alexey Starikovskiy <astarikovskiy@suse.de>
>  L:	linux-acpi@vger.kernel.org
> 
> 
> 

