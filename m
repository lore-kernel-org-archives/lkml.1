Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZG0DGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZG0DGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 23:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZG0DGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 23:06:21 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:30403
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755557AbZG0DGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 23:06:20 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN4015L655Nc8kzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNF79T-04-1JS-01
Date: Mon, 27 Jul 2009 11:05:59 +0800
From: "Cai, Crane" <crane.cai@amd.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Crane Cai <crane.cai@amd.com>
Subject: Re: [PATCH] ACPI: add driver for SMBus Control Method Interface
Message-ID: <20090727030559.GA23792@crane-desktop>
Mail-Followup-To: "Cai, Crane" <crane.cai@amd.com>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090715060219.GA30514@crane-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090715060219.GA30514@crane-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 Jul 2009 03:06:01.0094 (UTC) FILETIME=[2BB14A60:01CA0E67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could some one tell me whether this patch can be applied?

Thanks,
- Crane

On Wed, Jul 15, 2009 at 02:02:19PM +0800, Crane Cai wrote:
> This driver supports the SMBus Control Method Interface. It needs BIOS declare
> ACPI control methods via SMBus Control Method Interface Spec.
> 
> Please apply
> 
> Signed-off-by: Crane Cai <crane.cai@amd.com>
> ---
>  drivers/acpi/Kconfig   |   11 ++
>  drivers/acpi/Makefile  |    1 +
>  drivers/acpi/cmi_i2c.c |  391 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 403 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/acpi/cmi_i2c.c
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 7ec7d88..ce7cf38 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -333,4 +333,15 @@ config ACPI_SBS
>  	  To compile this driver as a module, choose M here:
>  	  the modules will be called sbs and sbshc.
>  
> +config ACPI_I2C
> +	tristate "SMBus Control Method Interface"
> +	depends on X86
> +	help
> +	  This driver supports the SMBus Control Method Interface. It needs
> +	  BIOS declare ACPI control methods via SMBus Control Method Interface
> +	  Spec.
> +
> +	  To compile this driver as a module, choose M here:
> +	  the modules will be called sbs and sbshc.
> +
>  endif	# ACPI
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 03a985b..a76c351 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -56,6 +56,7 @@ obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
>  obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
>  obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
>  obj-$(CONFIG_ACPI_SBS)		+= sbs.o
> +obj-$(CONFIG_ACPI_I2C)		+= cmi_i2c.o
>  
>  # processor has its own "processor." module_param namespace
>  processor-y			:= processor_core.o processor_throttling.o
> diff --git a/drivers/acpi/cmi_i2c.c b/drivers/acpi/cmi_i2c.c
> new file mode 100644
> index 0000000..69f3202
> --- /dev/null
> +++ b/drivers/acpi/cmi_i2c.c
> @@ -0,0 +1,391 @@
> +/*
> + * SMBus driver for ACPI SMBus CMI
> + *
> + * Copyright (C) 2009 Crane Cai <crane.cai@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/stddef.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +
> +#define ACPI_SMB_HC_COMPONENT	0x00080000
> +#define ACPI_SMB_HC_CLASS	"smbus"
> +#define ACPI_SMB_HC_DEVICE_NAME	"smbus cmi"
> +#define SMB_HC_DEVICE_NAME	"SMBus CMI adapter"
> +
> +#define _COMPONENT		ACPI_SMB_HC_COMPONENT
> +
> +ACPI_MODULE_NAME("smbus_cmi");
> +
> +struct smbus_methods {
> +	char *mt_info;
> +	char *mt_sbr;
> +	char *mt_sbw;
> +};
> +
> +struct acpi_smbus_cmi {
> +	acpi_handle handle;
> +	struct i2c_adapter adapter;
> +	struct smbus_methods *methods;
> +};
> +
> +static const struct smbus_methods smb_mtds = {
> +	.mt_info = "_SBI",
> +	.mt_sbr = "_SBR",
> +	.mt_sbw = "_SBW",
> +};
> +
> +static const struct acpi_device_id i2c_device_ids[] = {
> +	{"SMBUS01", 0},
> +	{"", 0},
> +};
> +
> +static int acpi_smb_cmi_add(struct acpi_device *device);
> +static int acpi_smb_cmi_remove(struct acpi_device *device, int type);
> +
> +static struct acpi_driver acpi_smb_cmi_driver = {
> +	.name = ACPI_SMB_HC_DEVICE_NAME,
> +	.class = ACPI_SMB_HC_CLASS,
> +	.ids = i2c_device_ids,
> +	.ops = {
> +		.add = acpi_smb_cmi_add,
> +		.remove = acpi_smb_cmi_remove,
> +		},
> +};
> +
> +#define ACPI_SMB_STATUS_OK		0x00
> +#define ACPI_SMB_STATUS_FAIL		0x07
> +#define ACPI_SMB_STATUS_DNAK		0x10
> +#define ACPI_SMB_STATUS_DERR		0x11
> +#define ACPI_SMB_STATUS_CMD_DENY	0x12
> +#define ACPI_SMB_STATUS_UNKNOWN		0x13
> +#define ACPI_SMB_STATUS_ACC_DENY	0x17
> +#define ACPI_SMB_STATUS_TIMEOUT		0x18
> +#define ACPI_SMB_STATUS_NOTSUP		0x19
> +#define ACPI_SMB_STATUS_BUSY		0x1A
> +#define ACPI_SMB_STATUS_PEC		0x1F
> +
> +#define ACPI_SMB_PRTCL_WRITE			0x0
> +#define ACPI_SMB_PRTCL_READ			0x01
> +#define ACPI_SMB_PRTCL_QUICK			0x02
> +#define ACPI_SMB_PRTCL_BYTE			0x04
> +#define ACPI_SMB_PRTCL_BYTE_DATA		0x06
> +#define ACPI_SMB_PRTCL_WORD_DATA		0x08
> +#define ACPI_SMB_PRTCL_BLOCK_DATA		0x0a
> +#define ACPI_SMB_PRTCL_PROC_CALL		0x0c
> +#define ACPI_SMB_PRTCL_BLOCK_PROC_CALL		0x0d
> +#define ACPI_SMB_PRTCL_PEC			0x80
> +
> +
> +static int
> +acpi_smb_cmi_access(struct i2c_adapter *adap, u16 addr, unsigned short flags,
> +		   char read_write, u8 command, int size,
> +		   union i2c_smbus_data *data)
> +{
> +	int result = 0;
> +	struct acpi_smbus_cmi *smbus_cmi = adap->algo_data;
> +	unsigned char protocol, len = 0;
> +	acpi_status status = 0;
> +	struct acpi_object_list input;
> +	union acpi_object mt_params[5];
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj;
> +	union acpi_object *pkg;
> +	char *mthd;
> +
> +	switch (size) {
> +	case I2C_SMBUS_QUICK:
> +		protocol = ACPI_SMB_PRTCL_QUICK;
> +		command = 0;
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			mt_params[3].type = ACPI_TYPE_INTEGER;
> +			mt_params[3].integer.value = 0;
> +			mt_params[4].type = ACPI_TYPE_INTEGER;
> +			mt_params[4].integer.value = 0;
> +		}
> +		break;
> +
> +	case I2C_SMBUS_BYTE:
> +		protocol = ACPI_SMB_PRTCL_BYTE;
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			mt_params[3].type = ACPI_TYPE_INTEGER;
> +			mt_params[3].integer.value = 0;
> +			mt_params[4].type = ACPI_TYPE_INTEGER;
> +			mt_params[4].integer.value = 0;
> +		} else {
> +			command = 0;
> +		}
> +		break;
> +
> +	case I2C_SMBUS_BYTE_DATA:
> +		protocol = ACPI_SMB_PRTCL_BYTE_DATA;
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			mt_params[3].type = ACPI_TYPE_INTEGER;
> +			mt_params[3].integer.value = 1;
> +			mt_params[4].type = ACPI_TYPE_INTEGER;
> +			mt_params[4].integer.value = data->byte;
> +		}
> +		break;
> +
> +	case I2C_SMBUS_WORD_DATA:
> +		protocol = ACPI_SMB_PRTCL_WORD_DATA;
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			mt_params[3].type = ACPI_TYPE_INTEGER;
> +			mt_params[3].integer.value = 2;
> +			mt_params[4].type = ACPI_TYPE_INTEGER;
> +			mt_params[4].integer.value = data->word;
> +		}
> +		break;
> +
> +	case I2C_SMBUS_BLOCK_DATA:
> +		protocol = ACPI_SMB_PRTCL_BLOCK_DATA;
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			len = data->block[0];
> +			if (len == 0 || len > I2C_SMBUS_BLOCK_MAX)
> +				return -EINVAL;
> +			mt_params[3].type = ACPI_TYPE_INTEGER;
> +			mt_params[3].integer.value = len;
> +			mt_params[4].type = ACPI_TYPE_BUFFER;
> +			mt_params[4].buffer.pointer = data->block + 1;
> +		}
> +		break;
> +
> +	default:
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus CMI adapter: "
> +				  "Unsupported transaction %d\n", size));
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (read_write == I2C_SMBUS_READ) {
> +		protocol |= ACPI_SMB_PRTCL_READ;
> +		mthd = smbus_cmi->methods->mt_sbr;
> +		input.count = 3;
> +	} else {
> +		protocol |= ACPI_SMB_PRTCL_WRITE;
> +		mthd = smbus_cmi->methods->mt_sbw;
> +		input.count = 5;
> +	}
> +
> +	input.pointer = mt_params;
> +	mt_params[0].type = ACPI_TYPE_INTEGER;
> +	mt_params[0].integer.value = protocol;
> +	mt_params[1].type = ACPI_TYPE_INTEGER;
> +	mt_params[1].integer.value = addr;
> +	mt_params[2].type = ACPI_TYPE_INTEGER;
> +	mt_params[2].integer.value = command;
> +
> +	status = acpi_evaluate_object(smbus_cmi->handle, mthd, &input, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "Error evaluate %s\n", mthd));
> +		return -EIO;
> +	}
> +
> +	pkg = buffer.pointer;
> +	if (pkg && pkg->type == ACPI_TYPE_PACKAGE)
> +		obj = pkg->package.elements;
> +	else {
> +		result = -EIO;
> +		goto out;
> +	}
> +	if (obj == NULL || obj->type != ACPI_TYPE_INTEGER) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus status object type \
> +						error\n"));
> +		result = -EIO;
> +		goto out;
> +	}
> +
> +	result = obj->integer.value;
> +	switch (result) {
> +	case ACPI_SMB_STATUS_OK:
> +		break;
> +	case ACPI_SMB_STATUS_BUSY:
> +		result = -EBUSY;
> +		goto out;
> +	case ACPI_SMB_STATUS_TIMEOUT:
> +		result = -ETIMEDOUT;
> +		goto out;
> +	case ACPI_SMB_STATUS_DNAK:
> +		result = -ENXIO;
> +		goto out;
> +	default:
> +		result = -EIO;
> +		goto out;
> +	}
> +
> +	if (read_write == I2C_SMBUS_WRITE)
> +		goto out;
> +
> +	obj = pkg->package.elements + 1;
> +	if (obj == NULL || obj->type != ACPI_TYPE_INTEGER) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus return package object \
> +						type error\n"));
> +		result = -EIO;
> +		goto out;
> +	}
> +
> +	len = obj->integer.value;
> +	obj = pkg->package.elements + 2;
> +	switch (size) {
> +	case I2C_SMBUS_BYTE:
> +	case I2C_SMBUS_BYTE_DATA:
> +	case I2C_SMBUS_WORD_DATA:
> +		if (obj == NULL || obj->type != ACPI_TYPE_INTEGER) {
> +			ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus return package \
> +						object type error\n"));
> +			result = -EIO;
> +			goto out;
> +		}
> +		if (len == 2)
> +			data->word = obj->integer.value & 0xffff;
> +		else
> +			data->byte = obj->integer.value & 0xff;
> +		break;
> +	case I2C_SMBUS_BLOCK_DATA:
> +		if (obj == NULL || obj->type != ACPI_TYPE_BUFFER) {
> +			ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus return package \
> +						object type error\n"));
> +			result = -EIO;
> +			goto out;
> +		}
> +		data->block[0] = len;
> +		if (data->block[0] == 0 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
> +			return -EPROTO;
> +		memcpy(data->block + 1, obj->buffer.pointer, len);
> +		break;
> +	}
> +
> +out:
> +	kfree(buffer.pointer);
> +	return result;
> +}
> +
> +static u32 acpi_smb_cmi_func(struct i2c_adapter *adapter)
> +{
> +
> +	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
> +		I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
> +		I2C_FUNC_SMBUS_BLOCK_DATA;
> +}
> +
> +static const struct i2c_algorithm acpi_smbus_cmi_algorithm = {
> +	.smbus_xfer = acpi_smb_cmi_access,
> +	.functionality = acpi_smb_cmi_func,
> +};
> +
> +static int acpi_smb_cmi_add(struct acpi_device *device)
> +{
> +	int status;
> +	struct acpi_smbus_cmi *smb_cmi;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	smb_cmi = kzalloc(sizeof(struct acpi_smbus_cmi), GFP_KERNEL);
> +	if (!smb_cmi)
> +		return -ENOMEM;
> +
> +	smb_cmi->handle = device->handle;
> +	strcpy(acpi_device_name(device), ACPI_SMB_HC_DEVICE_NAME);
> +	strcpy(acpi_device_class(device), ACPI_SMB_HC_CLASS);
> +	device->driver_data = smb_cmi;
> +	smb_cmi->methods = (struct smbus_methods *)(&smb_mtds);
> +
> +	status = acpi_evaluate_object(smb_cmi->handle,
> +					smb_cmi->methods->mt_info,
> +					NULL, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "Error obtaining _SBI\n"));
> +		goto err;
> +	}
> +
> +	obj = buffer.pointer;
> +	if (obj && obj->type == ACPI_TYPE_PACKAGE)
> +		obj = obj->package.elements;
> +	else {
> +		kfree(buffer.pointer);
> +		goto err;
> +	}
> +
> +	if (obj->type != ACPI_TYPE_INTEGER) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus CMI Version object type \
> +								error\n"));
> +	} else
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN, "SMBus CMI Version %0x\n",
> +					(int)obj->integer.value));
> +	kfree(buffer.pointer);
> +
> +	snprintf(smb_cmi->adapter.name, sizeof(smb_cmi->adapter.name),
> +		"SMBus CMI adapter");
> +	smb_cmi->adapter.owner = THIS_MODULE;
> +	smb_cmi->adapter.algo = &acpi_smbus_cmi_algorithm;
> +	smb_cmi->adapter.algo_data = smb_cmi;
> +	smb_cmi->adapter.class	= I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +	smb_cmi->adapter.dev.parent = &device->dev;
> +
> +	if (i2c_add_adapter(&smb_cmi->adapter)) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_WARN,
> +			  "SMBus CMI adapter: Failed to register adapter\n"));
> +		kfree(smb_cmi);
> +		return -EIO;
> +	}
> +
> +	printk(KERN_INFO PREFIX "%s [%s]\n",
> +	       acpi_device_name(device), acpi_device_bid(device));
> +
> +	return AE_OK;
> +
> +err:
> +	kfree(smb_cmi);
> +	device->driver_data = NULL;
> +	return -EIO;
> +}
> +
> +static int acpi_smb_cmi_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_smbus_cmi *smbus_cmi;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	smbus_cmi = acpi_driver_data(device);
> +
> +	i2c_del_adapter(&smbus_cmi->adapter);
> +	kfree(smbus_cmi);
> +
> +	return AE_OK;
> +}
> +
> +static int __init acpi_smb_cmi_init(void)
> +{
> +	int result;
> +
> +	result = acpi_bus_register_driver(&acpi_smb_cmi_driver);
> +	if (result < 0)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static void __exit acpi_smb_cmi_exit(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_smb_cmi_driver);
> +}
> +
> +module_init(acpi_smb_cmi_init);
> +module_exit(acpi_smb_cmi_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Crane Cai");
> +MODULE_DESCRIPTION("ACPI SMBus CMI driver");
> -- 
> 1.6.0.4

