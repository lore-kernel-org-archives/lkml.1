Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZHFPKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZHFPKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZHFPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:10:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:41937 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbZHFPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:10:03 -0400
Subject: Re: [RFC PATCH V2 2/2] introduce ACPI ALS device driver
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Richard Purdie <rpurdie@rpsys.net>, Matthew Wilcox <matthew@wil.cx>,
       Len Brown <lenb@kernel.org>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
In-Reply-To: <1249547500.2670.500.camel@rzhang-dt>
References: <1249547500.2670.500.camel@rzhang-dt>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:09:21 -0600
Message-Id: <1249571361.457.21.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 16:31 +0800, Zhang Rui wrote:
> ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when the
> environment changes.
> 
> This patch introduces the ACPI ALS driver.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/acpi/debug.txt |    1 
>  drivers/acpi/Kconfig         |    9 
>  drivers/acpi/Makefile        |    1 
>  drivers/acpi/als.c           |  423 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/debug.c         |    1 
>  include/acpi/acpi_drivers.h  |    1 
>  6 files changed, 436 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/als.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/acpi/als.c
> @@ -0,0 +1,423 @@
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
> +static int acpi_als_resume(struct acpi_device *device);
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
> +		.resume = acpi_als_resume,
> +		.remove = acpi_als_remove,
> +		.notify = acpi_als_notify,
> +		},
> +};
> +
> +struct acpi_als {
> +	struct acpi_device *device;
> +	struct als_device *als_sys;
> +	int illuminance;
> +	int chromaticity;
> +	int temperature;
> +	int polling;
> +	int count;
> +	struct als_mapping *mappings;
> +};
> +
> +#define ALS_INVALID_VALUE_LOW		0
> +#define ALS_INVALID_VALUE_HIGH		-1
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
> +		als->illuminance = ALS_INVALID_VALUE_LOW;
> +		return -ENODEV;
> +	}
> +	als->illuminance = illuminance;
> +	return 0;
> +}
> +
> +/*
> + * acpi_als_get_color_chromaticity - get the ambient light color chromaticity
> + */
> +static int acpi_als_get_color_chromaticity(struct acpi_als *als)
> +{
> +	acpi_status status;
> +	unsigned long long chromaticity;
> +
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALC", NULL,
> +				  &chromaticity);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALC not available\n"));
> +		return -ENODEV;
> +	}
> +	als->chromaticity = chromaticity;
> +	return 0;
> +}
> +
> +/*
> + * acpi_als_get_color_temperature - get the ambient light color temperature
> + */
> +static int acpi_als_get_color_temperature(struct acpi_als *als)
> +{
> +	acpi_status status;
> +	unsigned long long temperature;
> +
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALT", NULL,
> +				  &temperature);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALT not available\n"));
> +		return -ENODEV;
> +	}
> +	als->temperature = temperature;
> +	return 0;
> +}
> +
> +/*
> + * acpi_als_get_mappings - get the ALS illuminance mappings
> + *
> + * Return a package of ALS illuminance to display adjustment mappings
> + * that can be used by OS to calibrate its ambient light policy
> + * for a given sensor configuration.
> + */
> +static int acpi_als_get_mappings(struct acpi_als *als)
> +{
> +	int result = 0;
> +	acpi_status status;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *alr;
> +	int i, j;
> +
> +	/* Free the old mappings */
> +	if (als->mappings) {
> +		kfree(als->mappings);
> +		als->mappings = NULL;
> +	}
> +
> +	status =
> +	    acpi_evaluate_object(als->device->handle, "_ALR", NULL, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_EXCEPTION((AE_INFO, status, "Error reading ALS mappings"));
> +		return -ENODEV;
> +	}
> +
> +	alr = buffer.pointer;
> +	if (!alr || (alr->type != ACPI_TYPE_PACKAGE)) {
> +		printk(KERN_ERR PREFIX "Invalid _ALR data\n");
> +		result = -EFAULT;
> +		goto end;
> +	}
> +
> +	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Found %d illuminance mappings\n",
> +			  alr->package.count));
> +
> +	als->count = alr->package.count;
> +
> +	if (!als->count)
> +		return 0;
> +
> +	als->mappings =
> +	    kmalloc(sizeof(struct als_mapping) * als->count, GFP_KERNEL);
> +	if (!als->mappings) {
> +		result = -ENOMEM;
> +		goto end;
> +	}
> +
> +	for (i = 0, j = 0; i < als->count; i++) {
> +		struct als_mapping *mapping = &(als->mappings[j]);
> +		union acpi_object *element = &(alr->package.elements[i]);
> +
> +		if (element->type != ACPI_TYPE_PACKAGE)
> +			continue;
> +
> +		if (element->package.count != 2)
> +			continue;
> +
> +		if (element->package.elements[0].type != ACPI_TYPE_INTEGER ||
> +		    element->package.elements[1].type != ACPI_TYPE_INTEGER)
> +			continue;
> +
> +		mapping->adjustment =
> +		    element->package.elements[0].integer.value;
> +		mapping->illuminance =
> +		    element->package.elements[1].integer.value;
> +		j++;
> +
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Mapping [%d]: "
> +				  "adjuestment [%d] illuminance[%d]\n",
> +				  i, mapping->adjustment,
> +				  mapping->illuminance));
> +	}
> +
> +end:
> +	kfree(buffer.pointer);
> +	return result;
> +}
> +
> +/*
> + * acpi_als_get_polling - get the current ambient light illuminance
> + */
> +static int acpi_als_get_polling(struct acpi_als *als)
> +{
> +	acpi_status status;
> +	unsigned long long polling;
> +
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALP", NULL, &polling);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALP not available\n"));
> +		return -ENODEV;
> +	}
> +
> +	als->polling = polling;
> +	return 0;
> +}
> +
> +/* --------------------------------------------------------------------------
> + *                                ALS sysfs I/F
> + *  -------------------------------------------------------------------------- */
> +
> +static int get_illuminance(struct als_device *als_sys, int *illuminance)
> +{
> +	struct acpi_als *als = als_sys->devdata;
> +	int result;
> +
> +	result = acpi_als_get_illuminance(als);
> +	if (!result)
> +		*illuminance = als->illuminance;
> +	return result;
> +}
> +
> +static int get_mapping_count(struct als_device *als_sys, int *count)
> +{
> +	struct acpi_als *als = als_sys->devdata;
> +	int result;
> +
> +	result = acpi_als_get_mappings(als);
> +	if (!result)
> +		*count = als->count;
> +
> +	return result;
> +}
> +
> +static int get_mapping_info(struct als_device *als_sys, int index,
> +			    int *illuminance, int *adjustment)
> +{
> +	struct acpi_als *als = als_sys->devdata;
> +	int result;
> +
> +	if (index < 0 || index >= als->count)
> +		return -EINVAL;
> +
> +	result = acpi_als_get_mappings(als);
> +	if (result)
> +		return result;
> +
> +	if (illuminance)
> +		*illuminance = als->mappings[index].illuminance;
> +	if (adjustment)
> +		*adjustment = als->mappings[index].adjustment;
> +
> +	return 0;
> +}
> +
> +struct als_device_ops acpi_als_ops = {
> +	.get_illuminance = get_illuminance,
> +	.get_mapping_count = get_mapping_count,
> +	.get_mapping_info = get_mapping_info,
> +};
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

You don't need this null pointer check.  The notify handler is only
installed if the .add() method completes successfully, which means
the device->driver_data pointer has been set.

> +
> +	switch (event) {
> +	case ACPI_ALS_NOTIFY_ILLUMINANCE:
> +		acpi_als_get_illuminance(als);
> +		break;
> +	case ACPI_ALS_NOTIFY_COLOR_TEMP:
> +		acpi_als_get_color_temperature(als);
> +		acpi_als_get_color_chromaticity(als);
> +		break;
> +	case ACPI_ALS_NOTIFY_RESPONSE:
> +		acpi_als_get_mappings(als);
> +		als_device_update_mappings(als->als_sys);
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
> +	struct acpi_als *als;
> +	acpi_status status;
> +	struct acpi_buffer name = { ACPI_ALLOCATE_BUFFER, NULL };
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
> +	result = acpi_als_get_mappings(als);
> +	if (result)
> +		goto end;
> +
> +	acpi_als_get_color_temperature(als);
> +	acpi_als_get_color_chromaticity(als);
> +	acpi_als_get_polling(als);
> +
> +	status = acpi_get_name(als->device->handle, ACPI_FULL_PATHNAME, &name);
> +	if (ACPI_FAILURE(status)) {
> +		result = -ENODEV;
> +		goto end;
> +	}
> +
> +	als->als_sys = als_device_register(&acpi_als_ops, name.pointer, als);

I don't think we should expose the ACPI pathname of the device here.
If we really need something in sysfs, I think some kind of link to the
underlying device would be better.

> +	if (IS_ERR(als->als_sys)) {
> +		result = -ENODEV;
> +		if (als->mappings)
> +			kfree(als->mappings);
> +	}
> +
> +	als_device_update_mappings(als->als_sys);
> +
> +	kfree(name.pointer);
> +
> +end:
> +	if (result)
> +		kfree(als);
> +	return result;
> +}
> +
> +static int acpi_als_resume(struct acpi_device *device)
> +{
> +	struct acpi_als *als = acpi_driver_data(device);
> +
> +	if (!als)
> +		return -ENODEV;

This null pointer check isn't needed.

> +
> +	if (acpi_als_get_illuminance(als))
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Failed to re-evaluate"
> +				  " ALS illuminance during resume\n"));
> +	return 0;
> +}
> +
> +static int acpi_als_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_als *als = acpi_driver_data(device);
> +
> +	if (!als)
> +		return -ENODEV;

Nor is this one.

> +
> +	als_device_unregister(als->als_sys);
> +	if (als->mappings)
> +		kfree(als->mappings);
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
> +	  the modules will be called als.

"the module", not "the modules".

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
> 
> 

