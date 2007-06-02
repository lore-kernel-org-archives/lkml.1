Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbXFBW2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbXFBW2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760991AbXFBW2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:28:41 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:22427 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbXFBW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=S8aNwOCuNOlZv8DXiDbFwSyQaLAcCz22SRUIS+3m6KQqyGbRhbC2M1eZt+3VAMu4wBxDmSVDaR+FFwG+k+vsLG7/+PiausejXXxmiOt/mQosLTq9FrP3b4aKHzHnOOzyaYUMSEueQl2L8CbNMgRMw8PwgzUjk/U7V/a9sQdmPOI=
Date: Sun, 3 Jun 2007 00:28:29 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
Message-ID: <20070602222829.GA11893@dreamland.darkstar.lan>
References: <20070513223329.GA29207@dreamland.darkstar.lan> <46520F36.4080006@assembler.cz> <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com> <46528B6F.3050701@assembler.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46528B6F.3050701@assembler.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Tue, May 22, 2007 at 08:19:27AM +0200, Rudolf Marek ha scritto: 
> Hi,
> 
> I have following readings:
> 
> w83627ehf-isa-0290
> Adapter: ISA adapter
> VCore:     +1.52 V  (min =  +0.00 V, max =  +1.74 V)
> in1:      +12.30 V  (min = +13.46 V, max = +13.04 V) ALARM
> AVCC:      +3.36 V  (min =  +4.08 V, max =  +3.95 V) ALARM
> 3VCC:      +3.36 V  (min =  +4.05 V, max =  +3.06 V) ALARM
> in4:       +2.04 V  (min =  +1.78 V, max =  +2.04 V)
> in5:       +1.60 V  (min =  +2.04 V, max =  +2.02 V) ALARM
> in6:       +5.12 V  (min =  +6.12 V, max =  +6.53 V) ALARM
> VSB:       +3.36 V  (min =  +4.08 V, max =  +4.08 V) ALARM
> VBAT:      +3.30 V  (min =  +4.08 V, max =  +3.04 V) ALARM
> in9:       +1.65 V  (min =  +0.98 V, max =  +2.04 V)
> Case Fan:    0 RPM  (min =    0 RPM, div = 8)
> CPU Fan:  1638 RPM  (min =    0 RPM, div = 4)
> Aux Fan:  1436 RPM  (min = 4272 RPM, div = 4) ALARM
> fan5:        0 RPM  (min =    0 RPM, div = 16)
> Sys Temp:    +28°C  (high =   -65°C, hyst =   -34°C)   ALARM
> CPU Temp:  +34.0°C  (high = +80.0°C, hyst = +75.0°C)
> AUX Temp:  +38.5°C  (high = +80.0°C, hyst = +75.0°C)
> 
> Fan4 is disabled in the chip. I think the board has 4 connectors. I dont 
> have time right now to check the manual.

Ok, it makes sense :)

Name (FBUF, Package (0x06)
{
    0x03,
    CPUF,
    CHAF,
    PWRF,
    CHPF,
    CH2F
})

Clearly the first number is not the number of available readings (though
it matches the count in the other DSDTs I've seen); don't know what it
is :|

The last field of the individual fan packages is far more interesting: 0
means disabled, anything else means enabled. In your DSDT "CHIPSET FAN
Speed" is marked as disabled and there's no AML code to read the
rotation.
This may be true also for the other packages (temp and voltage), but for
now I've modified only the fan code.

Here's another iteration of the driver, please give it a try:

/*
 * Copyright (C) 2007 Luca Tettamanti <kronos.it@gmail.com>
 * Distribute under GPLv2.
 */

#define DEBUG

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/hwmon.h>

#include <acpi/acpi.h>
#include <acpi/acnamesp.h>
#include <acpi/acpi_drivers.h>
#include <acpi/acpi_bus.h>


#define ATK_HID "ATK0110"
#define ATK_DRV "atk-hwmon"
#define ASOC "_SB.PCI0.SBRG.ASOC"

struct atk_data {
	struct class_device *class_dev;
	acpi_handle atk_handle;
	struct acpi_device *device;

	acpi_handle rtmp_handle;
	acpi_handle rvlt_handle;
	acpi_handle rfan_handle;
} atk_data;


typedef ssize_t (*sysfs_show_func)(struct device *dev,
			struct device_attribute *attr, char *buf);

typedef ssize_t (*sysfs_store_func)(struct device *dev,
			struct device_attribute *attr, const char *buf,
			size_t count);


static void atk_init_attribute(struct device_attribute *attr, char *name,
		mode_t mode, sysfs_show_func show, sysfs_store_func store)
{
	attr->attr.name = name;
	attr->attr.mode = mode;
	attr->show = show;
	attr->store = store;
}

#define ATTR_NAME_SIZE 16 /* Worst case is "tempN_input" */

struct atk_temp {
	struct device_attribute label_attr;
	struct device_attribute input_attr;
	struct device_attribute max_attr;
	struct device_attribute crit_attr;
	char label_attr_name[ATTR_NAME_SIZE];
	char input_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	char crit_attr_name[ATTR_NAME_SIZE];
	u64 id;
	acpi_handle handle;
	char *acpi_name;
};

struct atk_temp_list {
	int count;
	struct atk_temp temp[];
};

#define input_to_atk_temp(attr) \
	container_of(attr, struct atk_temp, input_attr)

static ssize_t atk_temp_input_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_temp *a = input_to_atk_temp(attr);
	unsigned long temp;
	struct acpi_object_list params;
	union acpi_object id;
	acpi_status status;
	ssize_t count;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = a->id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_integer(atk_data.rtmp_handle, NULL, &params, &temp);
	if (status != AE_OK) {
		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
				acpi_format_exception(status));
		return -EIO;
	}

	/* ACPI returns centidegree */
	count = sprintf(buf, "%lu\n", temp * 10);

	return count;
}

#define label_to_atk_temp(attr) \
	container_of(attr, struct atk_temp, label_attr)

static ssize_t atk_temp_label_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_temp *a = label_to_atk_temp(attr);

	return sprintf(buf, "%s\n", a->acpi_name);
}

enum atk_temp_pack_id {
	ATK_TEMP_PACK_MAX = 2,
	ATK_TEMP_PACK_CRIT = 3,
};

static int atk_temp_pack_read(acpi_handle handle, int pack_id,
		enum atk_temp_pack_id temp_id, unsigned long *temp)
{
	struct acpi_buffer ret;
	struct acpi_object_list params;
	union acpi_object id;
	union acpi_object *pack;
	union acpi_object *obj;
	acpi_status status;
	int err = 0;

	ret.length = ACPI_ALLOCATE_BUFFER;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = pack_id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_object_typed(handle, NULL, &params,
			&ret, ACPI_TYPE_PACKAGE);
	if (status != AE_OK) {
		dev_warn(&atk_data.device->dev, "%s: ACPI exception: %s\n",
				__func__, acpi_format_exception(status));
		return -EIO;
	}

	pack = ret.pointer;

	if (pack->package.count != 5) {
		dev_warn(&atk_data.device->dev, "%s: unexpected package size: %d\n",
				__func__, pack->package.count);
		err = -EIO;
		goto out;
	}

	obj = &pack->package.elements[temp_id];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_warn(&atk_data.device->dev, "%s: unexepected object type "
				"for element %d: %d\n", __func__, temp_id, obj->type);
		err = -EIO;
		goto out;
	}

	*temp = obj->integer.value;

out:
	ACPI_FREE(ret.pointer);

	return err;
}

#define max_to_atk_temp(attr) \
	container_of(attr, struct atk_temp, max_attr)

static ssize_t atk_temp_max_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_temp *a = max_to_atk_temp(attr);
	unsigned long temp;

	if (atk_temp_pack_read(a->handle, a->id, ATK_TEMP_PACK_MAX, &temp))
		return -EIO;

	return sprintf(buf, "%ld\n", temp * 10);
}

#define crit_to_atk_temp(attr) \
	container_of(attr, struct atk_temp, crit_attr)

static ssize_t atk_temp_crit_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_temp *a = crit_to_atk_temp(attr);
	unsigned long temp;

	if (atk_temp_pack_read(a->handle, a->id, ATK_TEMP_PACK_CRIT, &temp))
		return -EIO;

	return sprintf(buf, "%ld\n", temp * 10);
}

struct atk_voltage {
	struct device_attribute input_attr;
	struct device_attribute label_attr;
	struct device_attribute min_attr;
	struct device_attribute max_attr;
	char label_attr_name[ATTR_NAME_SIZE];
	char input_attr_name[ATTR_NAME_SIZE];
	char min_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	u64 id;
	acpi_handle handle;
	char const *acpi_name;
};

struct atk_voltage_list {
	int count;
	struct atk_voltage voltage[];
};

#define label_to_atk_voltage(attr) \
	container_of(attr, struct atk_voltage, label_attr)

static ssize_t atk_voltage_label_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_voltage *a = label_to_atk_voltage(attr);

	return sprintf(buf, "%s\n", a->acpi_name);
}

#define input_to_atk_voltage(attr) \
	container_of(attr, struct atk_voltage, input_attr)

static ssize_t atk_voltage_input_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_voltage *a = input_to_atk_voltage(attr);
	unsigned long voltage;
	struct acpi_object_list params;
	union acpi_object id;
	acpi_status status;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = a->id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_integer(atk_data.rvlt_handle, NULL, &params, &voltage);
	if (status != AE_OK) {
		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
				acpi_format_exception(status));
		return -EIO;
	}

	return sprintf(buf, "%lu\n", voltage);
}

enum atk_voltage_pack_id {
	ATK_VOLTAGE_PACK_MIN = 2,
	ATK_VOLTAGE_PACK_MAX = 3,
};

static int atk_voltage_pack_read(acpi_handle handle, int pack_id,
		enum atk_voltage_pack_id volt_id, unsigned long *voltage)
{
	struct acpi_buffer ret;
	struct acpi_object_list params;
	union acpi_object id;
	union acpi_object *pack;
	union acpi_object *obj;
	acpi_status status;
	int err = 0;

	ret.length = ACPI_ALLOCATE_BUFFER;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = pack_id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_object_typed(handle, NULL, &params,
			&ret, ACPI_TYPE_PACKAGE);
	if (status != AE_OK) {
		dev_warn(&atk_data.device->dev, "%s: ACPI exception %s\n", __func__,
				acpi_format_exception(status));
		return -EIO;
	}

	pack = ret.pointer;

	if (pack->package.count != 5) {
		dev_warn(&atk_data.device->dev, "%s: unexpected package size: %d\n",
				__func__, pack->package.count);
		err = -EIO;
		goto out;
	}

	obj = &pack->package.elements[volt_id];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_warn(&atk_data.device->dev, "%s: unexepected object type "
				"for element %d: %d\n", __func__, volt_id, obj->type);
		err = -EIO;
		goto out;
	}

	*voltage = obj->integer.value;

out:
	ACPI_FREE(ret.pointer);

	return err;
}

#define max_to_atk_voltage(attr) \
	container_of(attr, struct atk_voltage, max_attr)

static ssize_t atk_voltage_max_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_voltage *a = max_to_atk_voltage(attr);
	unsigned long volt;

	if (atk_voltage_pack_read(a->handle, a->id, ATK_VOLTAGE_PACK_MAX, &volt))
		return -EIO;

	return sprintf(buf, "%lu\n", volt);
}

#define min_to_atk_voltage(attr) \
	container_of(attr, struct atk_voltage, min_attr)

static ssize_t atk_voltage_min_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_voltage *a = min_to_atk_voltage(attr);
	unsigned long volt;

	if (atk_voltage_pack_read(a->handle, a->id, ATK_VOLTAGE_PACK_MIN, &volt))
		return -EIO;

	return sprintf(buf, "%lu\n", volt);
}

struct atk_fan {
	struct device_attribute input_attr;
	struct device_attribute label_attr;
	struct device_attribute min_attr;
	struct device_attribute max_attr;
	char input_attr_name[ATTR_NAME_SIZE];
	char label_attr_name[ATTR_NAME_SIZE];
	char min_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	u64 id;
	acpi_handle handle;
	char const *acpi_name;
};

struct atk_fan_list {
	int count;
	struct atk_fan fan[];
};

#define input_to_atk_fan(attr) \
	container_of(attr, struct atk_fan, input_attr)

static ssize_t atk_fan_input_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_fan *a = input_to_atk_fan(attr);
	unsigned long rotation;
	struct acpi_object_list params;
	union acpi_object id;
	acpi_status status;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = a->id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_integer(atk_data.rfan_handle, NULL, &params, &rotation);
	if (status != AE_OK) {
		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
				acpi_format_exception(status));
		return -EIO;
	}

	return sprintf(buf, "%lu\n", rotation);
}

#define label_to_atk_fan(attr) \
	container_of(attr, struct atk_fan, label_attr)

static ssize_t atk_fan_label_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_fan *a = label_to_atk_fan(attr);

	return sprintf(buf, "%s\n", a->acpi_name);
}

enum atk_fan_pack_id {
	ATK_FAN_PACK_MIN = 2,
	ATK_FAN_PACK_MAX = 3,
};


static int atk_fan_pack_read(acpi_handle handle, int pack_id,
		enum atk_fan_pack_id fan_id, unsigned long *rot)
{
	struct acpi_buffer ret;
	struct acpi_object_list params;
	union acpi_object id;
	union acpi_object *pack;
	union acpi_object *obj;
	acpi_status status;
	int err = 0;

	ret.length = ACPI_ALLOCATE_BUFFER;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = pack_id;

	params.count = 1;
	params.pointer = &id;

	status = acpi_evaluate_object_typed(handle, NULL, &params,
			&ret, ACPI_TYPE_PACKAGE);
	if (status != AE_OK) {
		dev_warn(&atk_data.device->dev, "%s: ACPI exception: %s\n",
				__func__, acpi_format_exception(status));
		return -EIO;
	}
	pack = ret.pointer;

	if (pack->package.count != 5) {
		dev_warn(&atk_data.device->dev, "%s: unexpected package size: %d\n",
				__func__, pack->package.count);
		err = -EIO;
		goto out;
	}

	obj = &pack->package.elements[fan_id];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_warn(&atk_data.device->dev, "%s: unexepected object type "
				"for element %d: %d\n", __func__, fan_id, obj->type);
		err = -EIO;
		goto out;
	}

	*rot = obj->integer.value;

out:
	ACPI_FREE(ret.pointer);

	return err;
}

#define min_to_atk_fan(attr) \
	container_of(attr, struct atk_fan, min_attr)

static ssize_t atk_fan_min_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_fan *a = min_to_atk_fan(attr);
	unsigned long rot;

	if (atk_fan_pack_read(a->handle, a->id, ATK_FAN_PACK_MIN, &rot))
		return -EIO;

	return sprintf(buf, "%ld\n", rot);
}

#define max_to_atk_fan(attr) \
	container_of(attr, struct atk_fan, max_attr)

static ssize_t atk_fan_max_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_fan *a = max_to_atk_fan(attr);
	unsigned long rot;

	if (atk_fan_pack_read(a->handle, a->id, ATK_FAN_PACK_MAX, &rot))
		return -EIO;

	return sprintf(buf, "%ld\n", rot);;
}

static ssize_t atk_name_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "atk0110-0\n");
}

static struct device_attribute atk_name_attr = __ATTR(name, 0444, atk_name_show, NULL);

struct atk_temp_list *temp_list;
struct atk_voltage_list *voltage_list;
struct atk_fan_list *fan_list;

static int atk_add(struct acpi_device *device);
static int atk_remove(struct acpi_device *device, int type);

static struct acpi_driver atk_driver = {
	.name	= ATK_HID,
	.class	= "hwmon",
	.ids	= ATK_HID,
	.ops	= {
		.add	= atk_add,
		.remove	= atk_remove,
	},
};

static int atk_create_files(struct device *dev)
{
	int i;
	int ret;

	/* Temperatures */
	for (i = 0; i < temp_list->count; i++) {
		ret = device_create_file(dev, &temp_list->temp[i].input_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &temp_list->temp[i].label_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &temp_list->temp[i].max_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &temp_list->temp[i].crit_attr);
		if (ret)
			return ret;
	}

	/* Voltages */
	for (i = 0; i < voltage_list->count; i++) {
		ret = device_create_file(dev, &voltage_list->voltage[i].input_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &voltage_list->voltage[i].label_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &voltage_list->voltage[i].min_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &voltage_list->voltage[i].max_attr);
		if (ret)
			return ret;
	}

	/* Fans */
	for (i = 0; i < fan_list->count; i++) {
		ret = device_create_file(dev, &fan_list->fan[i].input_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &fan_list->fan[i].label_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &fan_list->fan[i].min_attr);
		if (ret)
			return ret;
		ret = device_create_file(dev, &fan_list->fan[i].max_attr);
		if (ret)
			return ret;
	}

	ret = device_create_file(dev, &atk_name_attr);

	return ret;
}

static void atk_remove_files(struct device *dev)
{
	int i;

	/* Temperatures */
	if (temp_list) {
		for (i = 0; i < temp_list->count; i++) {
			device_remove_file(dev, &temp_list->temp[i].input_attr);
			device_remove_file(dev, &temp_list->temp[i].label_attr);
			kfree(temp_list->temp[i].acpi_name);
			device_remove_file(dev, &temp_list->temp[i].max_attr);
			device_remove_file(dev, &temp_list->temp[i].crit_attr);
		}
	}
	kfree(temp_list);
	temp_list = NULL;

	/* Voltages */
	if (voltage_list) {
		for (i = 0; i < voltage_list->count; i++) {
			device_remove_file(dev, &voltage_list->voltage[i].input_attr);
			device_remove_file(dev, &voltage_list->voltage[i].label_attr);
			kfree(voltage_list->voltage[i].acpi_name);
			device_remove_file(dev, &voltage_list->voltage[i].min_attr);
			device_remove_file(dev, &voltage_list->voltage[i].max_attr);
		}
	}
	kfree(voltage_list);
	voltage_list = NULL;

	/* Fans */
	if (fan_list) {
		for (i = 0; i < fan_list->count; i++) {
			device_remove_file(dev, &fan_list->fan[i].input_attr);
			device_remove_file(dev, &fan_list->fan[i].label_attr);
			kfree(fan_list->fan[i].acpi_name);
			device_remove_file(dev, &fan_list->fan[i].min_attr);
			device_remove_file(dev, &fan_list->fan[i].max_attr);
		}
	}
	kfree(fan_list);
	voltage_list = NULL;

	device_remove_file(dev, &atk_name_attr);
}

static int atk_enumerate_temp(struct acpi_buffer *temp_buf)
{
	struct atk_temp_list *tmp;
	union acpi_object *pack;
	union acpi_object *obj;
	struct device *dev = &atk_data.device->dev;
	int i, ret;

	/* Result must be a package */
	pack = temp_buf->pointer;

	if (pack->package.count < 1) {
		dev_dbg(dev, "%s: temp package is too small: %d\n", __func__,
				pack->package.count);
		return -EINVAL;
	}

	/* First field is the number of available readings */
	obj = &pack->package.elements[0];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_dbg(dev, "%s: temp package: invalid type for "
				"element 0: %d\n", __func__, obj->type);
		return -EINVAL;
	}

	/* Sanity check */
	if (pack->package.count != obj->integer.value + 1) {
		dev_dbg(dev, "%s: temperature count (%llu) differs "
				"from package count (%u)\n", __func__,
				obj->integer.value, pack->package.count);
		return -EINVAL;
	}

	tmp = kzalloc(sizeof(*tmp) + sizeof(*tmp->temp) * obj->integer.value, GFP_KERNEL);
	if (!tmp)
		return -ENOMEM;

	tmp->count = obj->integer.value;
	for (i = 0; i < pack->package.count - 1; i++) {
		struct acpi_buffer buf;
		union acpi_object *temp_pack;
		union acpi_object *name;
		union acpi_object *tmax;
		union acpi_object *tcrit;
		union acpi_object *acpi_id;
		acpi_status status;

		obj = &pack->package.elements[i + 1];

		/* obj is a handle to the temperature package */
		if (obj->type != ACPI_TYPE_ANY) {
			dev_warn(dev, "%s: invalid type for element %d: %d\n",
					__func__, i, obj->type);
			ret = -EINVAL;
			goto cleanup;
		}

		buf.length = ACPI_ALLOCATE_BUFFER;
		status = acpi_evaluate_object_typed(obj->reference.handle, NULL, NULL,
				&buf, ACPI_TYPE_PACKAGE);
		if (status != AE_OK) {
			dev_dbg(dev, "%s: ACPI exception on object %u: %s\n",
					__func__, i + 1, acpi_format_exception(status));
			ret = -EINVAL;
			goto cleanup;
		}

		/* Temperature package:
		 * byte buffer?
		 *   [3]: used by GITM/SITM to locate correct GITx/SITx,
		 *        method, same as the other package (GPID)
		 *   [2]: same as the other package, seems unused in
		 *        GITM/STIM
		 *   [1]: type?
		 *        1: cpu freq?
		 *        2: voltage
		 *        3: temperature
		 *        4: fan
		 *        7: Q-FAN (alarm?)
		 *        8: NOS
		 *   [0]: used by GITx/SITx for demux; selects the
		 *        value stored in ASB1 (PRM0)
		 * description
		 * max
		 * critical
		 * unknown
		 */
		temp_pack = buf.pointer;

		if (temp_pack->package.count != 5) {
			dev_dbg(dev, "%s: invalid package count "
					"for object %d: %u\n", __func__,
					i + 1, temp_pack->package.count);
			ACPI_FREE(buf.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		acpi_id = &temp_pack->package.elements[0];
		name = &temp_pack->package.elements[1];
		tmax = &temp_pack->package.elements[2];
		tcrit = &temp_pack->package.elements[3];

		if (acpi_id->type != ACPI_TYPE_INTEGER) {
			dev_dbg(dev, "%s: object %d, int expected (id), got: %d\n",
					__func__, i, acpi_id->type);
			ACPI_FREE(buf.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (name->type != ACPI_TYPE_STRING) {
			dev_dbg(dev, "%s: object %d, string expected, got %d\n",
					__func__, i, name->type);
			ACPI_FREE(buf.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (tmax->type != ACPI_TYPE_INTEGER) {
			dev_dbg(dev, "%s: object %d, int expected (tmax), got: %d\n",
					__func__, i, name->type);
			ACPI_FREE(buf.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (tcrit->type != ACPI_TYPE_INTEGER) {
			dev_dbg(dev, "%s: object %d, int expected (tcrit), got: %d\n",
					__func__, i, name->type);
			ACPI_FREE(buf.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		tmp->temp[i].id = acpi_id->integer.value;
		tmp->temp[i].handle = obj->reference.handle;

		snprintf(tmp->temp[i].input_attr_name, ATTR_NAME_SIZE, "temp%d_input", i);
		atk_init_attribute(&tmp->temp[i].input_attr, tmp->temp[i].input_attr_name,
				0444, atk_temp_input_show, NULL);

		tmp->temp[i].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);
		snprintf(tmp->temp[i].label_attr_name, ATTR_NAME_SIZE, "temp%d_label", i);
		atk_init_attribute(&tmp->temp[i].label_attr, tmp->temp[i].label_attr_name,
				0444, atk_temp_label_show, NULL);

		snprintf(tmp->temp[i].max_attr_name, ATTR_NAME_SIZE, "temp%d_max", i);
		atk_init_attribute(&tmp->temp[i].max_attr, tmp->temp[i].max_attr_name,
				0444, atk_temp_max_show, NULL);

		snprintf(tmp->temp[i].crit_attr_name, ATTR_NAME_SIZE, "temp%d_crit", i);
		atk_init_attribute(&tmp->temp[i].crit_attr, tmp->temp[i].crit_attr_name,
				0444, atk_temp_crit_show, NULL);

		dev_dbg(dev, "temp %d: %#llx %s [%llu-%llu]\n", i, tmp->temp[i].id,
				tmp->temp[i].acpi_name,
				tmax->integer.value, tcrit->integer.value);

		ACPI_FREE(buf.pointer);
	}

	temp_list = tmp;

	return 0;
cleanup:
	for (i = 0; i < tmp->count; i++)
		kfree(tmp->temp[i].acpi_name);
	kfree(tmp);

	return ret;
}

static int atk_enumerate_voltage(struct acpi_buffer *vlt_buf)
{
	struct device *dev = &atk_data.device->dev;
	union acpi_object *pack;
	union acpi_object *obj;
	struct atk_voltage_list *vlt;
	int ret, i;

	pack = vlt_buf->pointer;

	/* At least one element is expected */
	if (pack->package.count < 1) {
		dev_warn(dev, "%s: voltage pack is too small: %d\n", __func__,
				pack->package.count);
		return -EINVAL;
	}

	/* First field is the number of available readings */
	obj = &pack->package.elements[0];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_warn(dev, "%s: voltage pack: invalid type for element 0: %d\n",
				__func__, obj->type);
	}

	if (obj->integer.value + 1 != pack->package.count) {
		dev_warn(dev, "%s: invalid voltage count %llu (should be %d)\n", __func__,
			obj->integer.value, pack->package.count - 1);
		return -EINVAL;
	}

	vlt = kzalloc(sizeof(*vlt) + sizeof(*vlt->voltage) * obj->integer.value, GFP_KERNEL);
	if (!vlt)
		return -ENOMEM;

	vlt->count = obj->integer.value;
	for (i = 0; i < pack->package.count - 1; i++) {
		struct acpi_buffer buffer;
		union acpi_object *voltage_pack;
		union acpi_object *name;
		union acpi_object *vmax;
		union acpi_object *vmin;
		union acpi_object *acpi_id;
		acpi_status status;

		obj = &pack->package.elements[i + 1];

		/* handle to voltage package */
		if (obj->type != ACPI_TYPE_ANY) {
			dev_warn(dev, "%s: invalid type for element %d: %d\n",
					__func__, i, obj->type);
			ret = -EINVAL;
			goto cleanup;
		}

		buffer.length = ACPI_ALLOCATE_BUFFER;
		status = acpi_evaluate_object_typed(obj->reference.handle, NULL, NULL,
				&buffer, ACPI_TYPE_PACKAGE);
		if (status != AE_OK) {
			dev_warn(dev, "%s: ACPI exception while evaluating object %d: %s\n",
					__func__, i, acpi_format_exception(status));
			ret = -EINVAL;
			goto cleanup;
		}

		/* Package:
		 * id
		 * description
		 * min
		 * max
		 * One
		 */
		voltage_pack = buffer.pointer;

		if (voltage_pack->package.count != 5) {
			dev_warn(dev, "%s: invalid package for object %d: %d\n",
					__func__, i, voltage_pack->package.count);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		acpi_id = &voltage_pack->package.elements[0];
		name = &voltage_pack->package.elements[1];
		vmin = &voltage_pack->package.elements[2];
		vmax = &voltage_pack->package.elements[3];

		if (acpi_id->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (id), got: %d\n",
					__func__, i, acpi_id->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (name->type != ACPI_TYPE_STRING) {
			dev_warn(dev, "%s: object %d, string expected, got %d\n",
					__func__, i, name->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (vmax->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (vmax), got: %d\n",
					__func__, i, vmax->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (vmin->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (vmin), got: %d\n",
					__func__, i, vmin->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		vlt->voltage[i].id = acpi_id->integer.value;
		vlt->voltage[i].handle = obj->reference.handle;
		vlt->voltage[i].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);

		snprintf(vlt->voltage[i].input_attr_name, ATTR_NAME_SIZE, "in%d_input", i);
		atk_init_attribute(&vlt->voltage[i].input_attr,
				vlt->voltage[i].input_attr_name,
				0444, atk_voltage_input_show, NULL);

		snprintf(vlt->voltage[i].label_attr_name, ATTR_NAME_SIZE, "in%d_label", i);
		atk_init_attribute(&vlt->voltage[i].label_attr,
				vlt->voltage[i].label_attr_name,
				0444, atk_voltage_label_show, NULL);

		snprintf(vlt->voltage[i].max_attr_name, ATTR_NAME_SIZE, "in%d_max", i);
		atk_init_attribute(&vlt->voltage[i].max_attr,
				vlt->voltage[i].max_attr_name,
				0444, atk_voltage_max_show, NULL);

		snprintf(vlt->voltage[i].min_attr_name, ATTR_NAME_SIZE, "in%d_min", i);
		atk_init_attribute(&vlt->voltage[i].min_attr,
				vlt->voltage[i].min_attr_name,
				0444, atk_voltage_min_show, NULL);

		dev_dbg(dev, "voltage %d: %#llx %s [%llu-%llu]\n", i, vlt->voltage[i].id,
				vlt->voltage[i].acpi_name, vmin->integer.value,
				vmax->integer.value);
		ACPI_FREE(buffer.pointer);
	}

	voltage_list = vlt;

	return 0;

cleanup:
	for (i = 0; i < vlt->count; i++)
		kfree(vlt->voltage[i].acpi_name);
	kfree(vlt);

	return ret;
}

static int atk_enumerate_fan(struct acpi_buffer *fan_buf)
{
	struct device *dev = &atk_data.device->dev;
	union acpi_object *pack;
	union acpi_object *obj;
	struct atk_fan_list *fan;
	int ret, i;
	int count, next;

	pack = fan_buf->pointer;

	if (pack->package.count < 1) {
		dev_warn(dev, "%s: fan package is too small: %d\n",
				__func__, pack->package.count);
		return -EINVAL;
	}

	obj = &pack->package.elements[0];
	if (obj->type != ACPI_TYPE_INTEGER) {
		dev_warn(dev, "%s: fan package: invalid type for element 0: %d\n",
				__func__, obj->type);
		return -EINVAL;
	}

	/* Don't fail, it's not fatal */
	if (obj->integer.value + 1 != pack->package.count) {
		dev_dbg(dev, "%s: invalid fan count? %llu (should be %d)\n",
				__func__, obj->integer.value, pack->package.count - 1);
	}

	count = pack->package.count - 1;

	fan = kzalloc(sizeof(*fan) + sizeof(*fan->fan) * count, GFP_KERNEL);
	if (!fan)
		return -ENOMEM;

	fan->count = count;
	next = 0;
	for (i = 0; i < pack->package.count - 1; i++) {
		struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
		union acpi_object *fan_pack;
		union acpi_object *acpi_id;
		union acpi_object *name;
		union acpi_object *fmin;
		union acpi_object *fmax;
		union acpi_object *enable;
		acpi_status status;

		/* handle to fan package */
		obj = &pack->package.elements[i + 1];

		if (obj->type != ACPI_TYPE_ANY) {
			dev_warn(dev, "%s: invalid type type for element %d: %d\n",
					__func__, i + 1, obj->type);
			ret = -EINVAL;
			goto cleanup;
		}

		status = acpi_evaluate_object_typed(obj->reference.handle, NULL, NULL,
				&buffer, ACPI_TYPE_PACKAGE);
		if (status != AE_OK) {
			dev_warn(dev, "%s: ACPI exception while evaluating object %d: %s\n",
					__func__, i + 1, acpi_format_exception(status));
			ret = -EINVAL;
			goto cleanup;
		}

		/* Fan package:
		 * id (usual stuff)
		 * description
		 * min
		 * max
		 * enable bit (disabled = 0, enabled otherwise)
		 */
		fan_pack = buffer.pointer;

		if (fan_pack->package.count != 5) {
			dev_warn(dev, "%s: invalid package len for object %d: %d\n",
					__func__, i + 1, fan_pack->package.count);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		acpi_id = &fan_pack->package.elements[0];
		name = &fan_pack->package.elements[1];
		fmin = &fan_pack->package.elements[2];
		fmax = &fan_pack->package.elements[3];
		enable = &fan_pack->package.elements[4];

		if (acpi_id->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (id), got: %d\n",
					__func__, i, acpi_id->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (name->type != ACPI_TYPE_STRING) {
			dev_warn(dev, "%s: object %d, string expected, got %d\n",
					__func__, i + 1, name->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (fmin->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (fmin), got %d\n",
					__func__, i + 1, fmin->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (fmax->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (fmax), got %d\n",
					__func__, i + 1, fmax->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}
		if (enable->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (en), got %d\n",
					__func__, i + 1, enable->type);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		dev_dbg(dev, "fan %d: %#llx %s [%llu-%llu] %s\n", i, acpi_id->integer.value,
				name->string.pointer, fmin->integer.value,
				fmax->integer.value,
				enable->integer.value ? "enabled" : "disabled");

		if (!enable->integer.value) {
			fan->count--;
			continue;
		}

		fan->fan[next].id = acpi_id->integer.value;
		fan->fan[next].handle = obj->reference.handle;
		fan->fan[next].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);

		snprintf(fan->fan[next].input_attr_name, ATTR_NAME_SIZE, "fan%d_input", next);
		atk_init_attribute(&fan->fan[next].input_attr,
				fan->fan[next].input_attr_name,
				0444, atk_fan_input_show, NULL);

		snprintf(fan->fan[next].label_attr_name, ATTR_NAME_SIZE, "fan%d_label", next);
		atk_init_attribute(&fan->fan[next].label_attr,
				fan->fan[next].label_attr_name,
				0444, atk_fan_label_show, NULL);

		snprintf(fan->fan[next].min_attr_name, ATTR_NAME_SIZE, "fan%d_min", next);
		atk_init_attribute(&fan->fan[next].min_attr,
				fan->fan[next].min_attr_name,
				0444, atk_fan_min_show, NULL);

		snprintf(fan->fan[next].max_attr_name, ATTR_NAME_SIZE, "fan%d_max", next);
		atk_init_attribute(&fan->fan[next].max_attr,
				fan->fan[next].max_attr_name,
				0444, atk_fan_max_show, NULL);

		next++;
		ACPI_FREE(buffer.pointer);
	}

	fan_list = fan;

	return 0;
cleanup:
	for (i = 0; i < fan->count; i++)
		kfree(fan->fan[i].acpi_name);
	kfree(fan);

	return ret;
}

static int atk_add(struct acpi_device *device)
{
	acpi_status ret;
	int err, i;
	struct acpi_buffer buf;
	union acpi_object *obj;
	struct acpi_namespace_node *search_ns;
	struct acpi_namespace_node *ns;

	dev_dbg(&device->dev, "atk: adding...\n");

	atk_data.device = device;
	atk_data.atk_handle = device->handle;

	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object_typed(atk_data.atk_handle, "MBIF", NULL,
			&buf, ACPI_TYPE_PACKAGE);
	if (ret != AE_OK) {
		dev_dbg(&device->dev, "atk: method MBIF not found\n");
		return -ENODEV;
	}

	obj = buf.pointer;
	if (obj->package.count >= 2 && obj->package.elements[1].type == ACPI_TYPE_STRING) {
		dev_dbg(&device->dev, "board ID = %s\n",
				obj->package.elements[1].string.pointer);
	}
	ACPI_FREE(buf.pointer);

	/* Check for hwmon methods */
	search_ns = acpi_ns_map_handle_to_node(device->handle);
	if (!search_ns)
		return -ENODEV;

	/* RTMP: read temperature */
	ret = acpi_ns_get_node(search_ns, "RTMP", ACPI_NS_NO_UPSEARCH, &ns);
	if (ret != AE_OK) {
		dev_dbg(&device->dev, "method RTMP not found\n");
		return -ENODEV;
	}
	atk_data.rtmp_handle = acpi_ns_convert_entry_to_handle(ns);

	/* RVLT: read voltage */
	ret = acpi_ns_get_node(search_ns, "RVLT", ACPI_NS_NO_UPSEARCH, &ns);
	if (ret != AE_OK) {
		dev_dbg(&device->dev, "method RVLT not found\n");
		return -ENODEV;
	}
	atk_data.rvlt_handle = acpi_ns_convert_entry_to_handle(ns);

	/* RFAN: read fan status */
	ret = acpi_ns_get_node(search_ns, "RFAN", ACPI_NS_NO_UPSEARCH, &ns);
	if (ret != AE_OK) {
		dev_dbg(&device->dev, "method RFAN not found\n");
		return -ENODEV;
	}
	atk_data.rfan_handle = acpi_ns_convert_entry_to_handle(ns);

	/* Enumerate temp data - TSIF */
	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object_typed(atk_data.atk_handle, "TSIF", NULL,
			&buf, ACPI_TYPE_PACKAGE);
	if (ret != AE_OK) {
		dev_warn(&device->dev, "TSIF: ACPI exception: %s\n",
				acpi_format_exception(ret));
		return -ENODEV;
	}

	err = atk_enumerate_temp(&buf);
	ACPI_FREE(buf.pointer);
	if (err)
		return err;

	/* Enumerate voltage data - VSIF */
	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object_typed(atk_data.atk_handle, "VSIF", NULL,
			&buf, ACPI_TYPE_PACKAGE);
	if (ret != AE_OK) {
		dev_warn(&device->dev, "VSIF: ACPI exception: %s\n",
				acpi_format_exception(ret));

		err = -ENODEV;
		goto cleanup;
	}

	err = atk_enumerate_voltage(&buf);
	ACPI_FREE(buf.pointer);
	if (err)
		goto cleanup;

	/* Enumerate fan data - FSIF */
	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object_typed(atk_data.atk_handle, "FSIF", NULL,
			&buf, ACPI_TYPE_PACKAGE);
	if (ret != AE_OK) {
		dev_warn(&device->dev, "TSIF: ACPI exception: %s\n",
				acpi_format_exception(ret));

		err = -ENODEV;
		goto cleanup;
	}

	err = atk_enumerate_fan(&buf);
	ACPI_FREE(buf.pointer);
	if (err)
		goto cleanup;

	dev_dbg(&atk_data.device->dev, "registering hwmon device\n");
	atk_data.class_dev = hwmon_device_register(&atk_data.device->dev);
	if (IS_ERR(atk_data.class_dev)) {
		err = PTR_ERR(atk_data.class_dev);
		goto cleanup;
	}

	dev_dbg(&atk_data.device->dev, "populating sysfs directory\n");
	err = atk_create_files(&atk_data.device->dev);
	if (err)
		goto remove;

	acpi_driver_data(device) = &atk_data;

	return 0;
remove:
	atk_remove_files(&atk_data.device->dev);
	hwmon_device_unregister(atk_data.class_dev);

	return err;
cleanup:
	if (temp_list) {
		for (i = 0; i < temp_list->count; i++)
			kfree(temp_list->temp[i].acpi_name);
	}
	kfree(temp_list);

	if (voltage_list) {
		for (i = 0; i < voltage_list->count; i++)
			kfree(voltage_list->voltage[i].acpi_name);
	}
	kfree(voltage_list);

	if (fan_list) {
		for (i = 0; i < fan_list->count; i++)
			kfree(fan_list->fan[i].acpi_name);
	}
	kfree(fan_list);

	temp_list = NULL;
	voltage_list = NULL;
	fan_list = NULL;

	return err;
}

static int atk_remove(struct acpi_device *device, int type)
{
	dev_dbg(&device->dev, "removing...\n");

	acpi_driver_data(device) = NULL;

	hwmon_device_unregister(atk_data.class_dev);
	atk_remove_files(&atk_data.device->dev);

	return 0;
}

int atk_init(void)
{
	int ret;

	ret = acpi_bus_register_driver(&atk_driver);
	if (ret)
		pr_info("atk: acpi_bus_register_driver failed: %d\n", ret);

	return ret;
}

void atk_exit(void)
{
	acpi_bus_unregister_driver(&atk_driver);
}

module_init(atk_init);
module_exit(atk_exit);

MODULE_LICENSE("GPL");



Luca
-- 
"New processes are created by other processes, just like new
 humans. New humans are created by other humans, of course,
 not by processes." -- Unix System Administration Handbook
