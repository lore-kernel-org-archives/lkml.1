Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYAQRVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYAQRVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYAQRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:21:26 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:43013 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYAQRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:21:24 -0500
Date: Thu, 17 Jan 2008 09:20:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       sujith.thomas@intel.com
Subject: Re: [PATCH 9/10] introduce intel_menlow platform specific driver
Message-Id: <20080117092030.a9dfe528.randy.dunlap@oracle.com>
In-Reply-To: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 15:51:17 +0800 Zhang Rui wrote:

> From: Thomas Sujith <sujith.thomas@intel.com>
> 
> Intel menlow platform specific driver for thermal management.
> 
> Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/misc/Kconfig        |   10 
>  drivers/misc/Makefile       |    1 
>  drivers/misc/intel_menlow.c |  527 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 538 insertions(+)
> 
> Index: linux-2.6/drivers/misc/intel_menlow.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/misc/intel_menlow.c
> @@ -0,0 +1,527 @@
> +/*
> +*  intel_menlow.c - Intel menlow Driver for thermal management extension
> +*
> +*  Copyright (C) 2008 Intel Corp
> +*  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
> +*  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
> +* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +*
> +*  This driver creates the sys I/F for programming the sensors.
> +*  It also implements the driver for intel menlow memory controller (hardware
> +*  id is INT0002) which makes use of the platform specific ACPI methods
> +*  to get/set bandwidth.
> +*/
> +

> +static int
> +memory_get_int_max_bandwidth(struct thermal_cooling_device *cdev,
> +			     unsigned long *max_state)

Don't put 'static int' (return type etc.) on a line by itself.
That format is not wanted in Linux.   (many places here)

> +{
> +	struct acpi_device *device = cdev->devdata;
> +	acpi_handle handle = device->handle;
> +	unsigned long value;
> +	struct acpi_object_list arg_list;
> +	union acpi_object arg;
> +	acpi_status status = AE_OK;
> +
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = MEMORY_ARG_MAX_BANDWIDTH;
> +	status = acpi_evaluate_integer(handle, MEMORY_GET_BANDWIDTH,
> +				       &arg_list, &value);
> +	if (ACPI_FAILURE(status))
> +		return -EFAULT;
> +
> +	*max_state = value - 1;
> +	return 0;
> +}
> +
> +
> +/*
> + * Memory Device Management
> + */
> +static int intel_menlow_memory_add(struct acpi_device *device)
> +{
> +	int result = -ENODEV;
> +	acpi_status status = AE_OK;
> +	acpi_handle dummy;
> +	struct thermal_cooling_device *cdev;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	status = acpi_get_handle(device->handle, MEMORY_GET_BANDWIDTH, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto end;
> +
> +	status = acpi_get_handle(device->handle, MEMORY_SET_BANDWIDTH, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto end;
> +
> +	cdev = thermal_cooling_device_register("Memory controller", device,
> +					       &memory_cooling_ops);
> +	acpi_driver_data(device) = cdev;
> +	if (!cdev)
> +		result = -ENODEV;
> +	else {
> +		result =
> +		    sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
> +				      "thermal_cooling");
> +		if (result)
> +			goto end;
> +		result =
> +		    sysfs_create_link(&cdev->device.kobj, &device->dev.kobj,
> +				      "device");
> +		if (result)
> +			goto end;
> +	}
> +
> +      end:

Labels should begin in column 0 or 1.  Only.

> +	return result;
> +}
> +
> +
> +const static struct acpi_device_id intel_menlow_memory_ids[] = {
> +	{"INT0002", 0},
> +	{"", 0},

or just	{} for the terminating entry, right?

> +};

> +/*
> + * sensor_get_auxtrip
> + * -----------------
> + * get the current auxtrip value from sensor through proprietory ACPI methods
> + * name: Thermalzone name
> + * auxtype : AUX0/AUX1
> + * buf: syfs buffer
> + */

It would be Good to use kernel-doc format if someone is going to
add function documentation at all...  (ref. multiple places)

See Documentation/kernel-doc-nano-HOWTO.txt .

> +static int sensor_get_auxtrip(acpi_handle handle, int index, int *value)
> +{
> +	acpi_status status;
> +
> +	if ((index != 0 && index != 1) || !value)
> +		return -EINVAL;
> +
> +	status = acpi_evaluate_integer(handle, index ? GET_AUX1 : GET_AUX0,
> +				       NULL, (unsigned long *)value);
> +	if (ACPI_FAILURE(status))
> +		return -EIO;
> +
> +	return 0;
> +}
> +

> +static acpi_status
> +intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
> +			     void *context, void **rv)
> +{
> +	acpi_status status;
> +	acpi_handle dummy;
> +	struct thermal_zone_device *thermal;
> +	int result;
> +
> +	result = acpi_bus_get_private_data(handle, (void **)&thermal);
> +	if (result)
> +		return 0;
> +
> +	/* _TZ must have the AUX0/1 methods */
> +	status = acpi_get_handle(handle, GET_AUX0, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto not_found;
> +
> +	status = acpi_get_handle(handle, SET_AUX0, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto not_found;
> +
> +	result = intel_menlow_add_one_attribute("aux0", 0644,
> +						aux0_show, aux0_store,
> +						&thermal->device, handle);
> +	if (result)
> +		return AE_ERROR;
> +
> +	status = acpi_get_handle(handle, GET_AUX1, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto not_found;
> +
> +	status = acpi_get_handle(handle, SET_AUX1, &dummy);
> +	if (ACPI_FAILURE(status))
> +		goto not_found;
> +
> +	result = intel_menlow_add_one_attribute("aux1", 0644,
> +						aux1_show, aux1_store,
> +						&thermal->device, handle);
> +	if (result)
> +		return AE_ERROR;
> +
> +	/*
> +	 * create the "dabney_enabled" attribute which means the user app
> +	 * should be loaded or not
> +	 */
> +
> +	result = intel_menlow_add_one_attribute("bios_enabled", 0444,
> +						bios_enabled_show, NULL,
> +						&thermal->device, handle);
> +	if (result)
> +		return AE_ERROR;
> +
> +      not_found:

Don't indent labels so much.  It hides them.

> +	if (status == AE_NOT_FOUND)
> +		return AE_OK;
> +	else
> +		return status;
> +}

> Index: linux-2.6/drivers/misc/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/misc/Kconfig
> +++ linux-2.6/drivers/misc/Kconfig
> @@ -232,4 +232,14 @@ config ATMEL_SSC
>  
>  	  If unsure, say N.
>  
> +config INTEL_MENLOW
> +        tristate "Thermal Management driver for Intel menlow platform"
> +        depends on ACPI_THERMAL
> +	default n

Documentation/CodingStyle has info on Kconfig style.
Please read & use it and be more careful.

> +        ---help---
> +          ACPI thermal management enhancement driver on
> +	  Intel Menlow platform.
> +
> +          If you are not sure, say N here.
> +
>  endif # MISC_DEVICES


---
~Randy
