Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbZHDXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbZHDXao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZHDXan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:30:43 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24937 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117AbZHDXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:30:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/3] ACPI: introduce ACPI ALS driver
Date: Tue, 4 Aug 2009 17:30:40 -0600
User-Agent: KMail/1.9.10
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>
References: <1249290664.2670.252.camel@rzhang-dt>
In-Reply-To: <1249290664.2670.252.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041730.40850.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009 03:11:04 am Zhang Rui wrote:
> introduce ACPI ALS device driver.
> 
> ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when the
> environment changes.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/acpi/debug.txt |    1 
>  drivers/acpi/Kconfig         |    9 
>  drivers/acpi/Makefile        |    1 
>  drivers/acpi/als.c           |  407 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/debug.c         |    1 
>  include/acpi/acpi_drivers.h  |    1 
>  6 files changed, 420 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/als.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/acpi/als.c
> @@ -0,0 +1,407 @@
> +/*
> + *  als.c - ACPI Ambient Light Sensor Driver
> + *
> + *  Copyright (C) 2009 Zhang Rui <rui.zhang@intel.com>

At HP, code we write in the course of our employment is owned by HP.
If Intel is similar, Intel is the real copyright owner, not you (of
course, I have no knowledge about your specific situation).

> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or (at
> + *  your option) any later version.

HP lawyers don't like the fuzziness of the "any later version" clause
(and again, I have no knowledge about any Intel preference).

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
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
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
> +	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,

You shouldn't specify ACPI_DRIVER_ALL_NOTIFY_EVENTS unless you need
it, and I don't think you do, since you ignore all the system events
anyway.

> +	.ops = {
> +		.add = acpi_als_add,
> +		.resume = acpi_als_resume,
> +		.remove = acpi_als_remove,
> +		.notify = acpi_als_notify,
> +		},
> +};
> +
> +struct als_cap {
> +	u8 _ALI:1;
> +	u8 _ALC:1;
> +	u8 _ALT:1;
> +	u8 _ALR:1;
> +	u8 _ALP:1;
> +};
> +
> +struct als_mapping {
> +	int adjustment;
> +	int illuminance;
> +};
> +
> +struct acpi_als {
> +	struct acpi_device *device;
> +	struct als_cap cap;
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
> +	if (!als->cap._ALC)
> +		return -ENODEV;

Is there real benefit in keeping track of the als_cap structure?
What would be lost if you merely did this instead:

	status = acpi_evaluate_integer(als->device->handle, "_ALC", NULL,
				       &chromaticity);
	if (ACPI_FAILURE(status))
		return -ENODEV;

That is, I think it would *work* if we never cached the cap._ALC
value and just always attempted to evaluate _ALC.  If the BIOS doesn't
implement _ALS, the evaluation would always fail, of course, and
that's slightly more expensive than just checking the cached cap._ALC
bit.  But I don't think this is a performance path, and caching always
adds code complexity and the niggling worries about whether the cache
is correct.

> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALC", NULL,
> +				  &chromaticity);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALC not available\n"));
> +		als->cap._ALC = 0;
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
> +	if (!als->cap._ALT)
> +		return -ENODEV;
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALT", NULL,
> +				  &temperature);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALT not available\n"));
> +		als->cap._ALT = 0;
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
> +	acpi_status status = AE_OK;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *alr = NULL;

No need to initialize "status" or "alr" here.

> +	int i, j;
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
> +	if (!als->cap._ALP)
> +		return -ENODEV;
> +	status =
> +	    acpi_evaluate_integer(als->device->handle, "_ALP", NULL, &polling);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_ALP not available\n"));
> +		als->cap._ALP = 0;
> +		return -ENODEV;
> +	}
> +	als->polling = polling;
> +	return 0;
> +}
> +
> +static int acpi_als_find_cap(struct acpi_als *als)
> +{
> +	acpi_handle dummy;
> +
> +	memset(&als->cap, 0, sizeof(als->cap));
> +
> +	if (ACPI_SUCCESS(acpi_get_handle(als->device->handle, "_ALI", &dummy)))
> +		als->cap._ALI = 1;
> +	if (ACPI_SUCCESS(acpi_get_handle(als->device->handle, "_ALC", &dummy)))
> +		als->cap._ALC = 1;
> +	if (ACPI_SUCCESS(acpi_get_handle(als->device->handle, "_ALT", &dummy)))
> +		als->cap._ALT = 1;
> +	if (ACPI_SUCCESS(acpi_get_handle(als->device->handle, "_ALR", &dummy)))
> +		als->cap._ALR = 1;
> +	if (ACPI_SUCCESS(acpi_get_handle(als->device->handle, "_ALP", &dummy)))
> +		als->cap._ALP = 1;
> +
> +	if (!als->cap._ALI || !als->cap._ALR) {
> +		ACPI_EXCEPTION((AE_INFO, AE_NOT_FOUND,
> +				"Mandatory methods _ALI/_ALR not available"));
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
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

No need to check for a null pointer here.

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
> +		break;
> +	default:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "Unsupported event [0x%x]\n", event));
> +	}
> +	acpi_bus_generate_proc_event(device, event, (u32) als->illuminance);
> +	acpi_bus_generate_netlink_event(device->pnp.device_class,
> +					dev_name(&device->dev), event,
> +					(u32) als->illuminance);
> +	return;

No need for a "return;" statement here.

> +}
> +
> +static int acpi_als_add(struct acpi_device *device)
> +{
> +	int result = 0;
> +	struct acpi_als *als = NULL;

No need to initialize these.

> +
> +	if (!device)
> +		return -EINVAL;

No need to check for a null pointer.

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
> +	result = acpi_als_find_cap(als);
> +	if (result)
> +		goto end;
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
> +end:
> +	if (result)
> +		kfree(als);
> +	return result;
> +}
> +
> +static int acpi_als_resume(struct acpi_device *device)
> +{
> +	struct acpi_als *als;
> +
> +	if (!device || !acpi_driver_data(device))
> +		return -EINVAL;

You don't need these checks.

> +
> +	als = acpi_driver_data(device);

This can go on the same line as the "als" definition.

> +
> +	if (acpi_als_get_illuminance(als))
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Failed to re-evaluate"
> +				  " ALS illuminance during resume\n"));
> +	return 0;
> +}
> +
> +static int acpi_als_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_als *als;
> +
> +	if (!device || !acpi_driver_data(device))
> +		return -EINVAL;

See above.

> +
> +	als = acpi_driver_data(device);
> +	if (!als)
> +		return -EINVAL;

No need to check for a null pointer here.

> +
> +	if (als->mappings)
> +		kfree(als->mappings);
> +	kfree(als);
> +	return 0;
> +}
> +
> +static int __init acpi_als_init(void)
> +{
> +	int result;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;

No need to check "acpi_disabled" here.  acpi_bus_register_driver()
already does that for you.

> +
> +	result = acpi_bus_register_driver(&acpi_als_driver);
> +	if (result < 0)
> +		return -ENODEV;
> +	return 0;
> +}
> +
> +static void __exit acpi_als_exit(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_als_driver);
> +	return;
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
> +	depends on X86

There's nothing x86-specific here, though I grant you there
aren't going to be many ia64 boxes with ambient light sensors :-)

> +	help
> +	  This driver supports the ACPI Ambient Light Sensor.
> +
> +	  To compile this driver as a module, choose M here:
> +	  the modules will be called als.
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

Wow, thanks for updating this list, too!

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


