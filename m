Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbXEMWdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbXEMWdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbXEMWdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:33:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:60818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbXEMWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=quZJYom7g2Qm8M06HrAxZtKJy0E6qE1WMpNR8MmYzVLi0fzFCP850DadS4VlvKN7c0oBWdgOdJdrSI+dpBMrewaR561one/YCBxgoTpVw1IDiRLZrilyy6bStBef6q++O7943ohRpZY3h+VJXjuTLR8Fm2NIBwUFWqnZ1WzezPc=
Date: Mon, 14 May 2007 00:33:30 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC] ACPI based hwmon driver for ASUS
Message-ID: <20070513223329.GA29207@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is the first attempt to write a hwmon driver for ASUS motherboards
that uses ACPI methods instead of directly touching the sensor chip.
If you haven't followed the discussion[1] we want to avoid concurrent
access to the monitoring hw by ACPI and native driver, since it may
cause a malfunction.

A brief description of the driver:
- I've extended the hwmon userspace interface with *_name attributes;
  since ACPI "knows" the wiring and provides a pretty description of
  the reading I thought it's worth exposing it.
- all the attributes are read only: for some of them (voltage,
  temperature) rw doesn't make sense; for FAN: it's not possible to
  directly control the PWM (the native driver can do that) via ACPI;
  ASUS provides "Q-FAN" which has 3 settings: "silent", "perfomance",
  "auto"; so far I've been unable to make it work. The write path is
  basically "write caller supplied magic number to a magic memory
  location"...
- various ASUS stuff: my motherboard also has other features like
  auto-overclock, PCI-E frequency readings, DRAM voltage and frequency,
  CPU clock / ratio (some of the writable at runtime). I've ignored them
  since I don't know how they work (magic numbers...)
- I exported a few ACPI functions: acpi_ns_map_handle_to_node,
  acpi_ns_convert_entry_to_handle and acpi_ns_get_node for inspecting
  ACPI methods and ensure that all the expected stuff is there;
  acpi_evaluate_object_typed since it's very handy to let it do the
  check on the returned data instead of open-coding it all over the
  driver. Patch against 2.6.21:

diff --git a/drivers/acpi/namespace/nsutils.c b/drivers/acpi/namespace/nsutils.c
index 90fd059..97e1139 100644
--- a/drivers/acpi/namespace/nsutils.c
+++ b/drivers/acpi/namespace/nsutils.c
@@ -700,6 +700,7 @@ struct acpi_namespace_node *acpi_ns_map_handle_to_node(acpi_handle handle)
 
 	return (ACPI_CAST_PTR(struct acpi_namespace_node, handle));
 }
+EXPORT_SYMBOL(acpi_ns_map_handle_to_node);
 
 /*******************************************************************************
  *
@@ -736,6 +737,7 @@ acpi_handle acpi_ns_convert_entry_to_handle(struct acpi_namespace_node *node)
 	return ((acpi_handle) Node);
 ------------------------------------------------------*/
 }
+EXPORT_SYMBOL(acpi_ns_convert_entry_to_handle);
 
 /*******************************************************************************
  *
@@ -875,6 +877,7 @@ acpi_ns_get_node(struct acpi_namespace_node *prefix_node,
 	ACPI_FREE(internal_path);
 	return_ACPI_STATUS(status);
 }
+EXPORT_SYMBOL(acpi_ns_get_node);
 
 /*******************************************************************************
  *
diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
index 8904d0f..1b81758 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -49,7 +49,6 @@
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfeval")
 
-#ifdef ACPI_FUTURE_USAGE
 /*******************************************************************************
  *
  * FUNCTION:    acpi_evaluate_object_typed
@@ -142,7 +141,6 @@ acpi_evaluate_object_typed(acpi_handle handle,
 }
 
 ACPI_EXPORT_SYMBOL(acpi_evaluate_object_typed)
-#endif				/*  ACPI_FUTURE_USAGE  */
 
 /*******************************************************************************
  *
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index e08f7df..85da346 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -164,14 +164,12 @@ acpi_evaluate_object(acpi_handle object,
 		     struct acpi_object_list *parameter_objects,
 		     struct acpi_buffer *return_object_buffer);
 
-#ifdef ACPI_FUTURE_USAGE
 acpi_status
 acpi_evaluate_object_typed(acpi_handle object,
 			   acpi_string pathname,
 			   struct acpi_object_list *external_params,
 			   struct acpi_buffer *return_buffer,
 			   acpi_object_type return_type);
-#endif
 
 acpi_status
 acpi_get_object_info(acpi_handle handle, struct acpi_buffer *return_buffer);


I've asked for help to local LUG: the driver has been tested by a couple
of people; unfortunately the board were all very similar (a P5B, a P5B
delux and my P5B-E). If you have a recent ASUS mainboard and the driver
doesn't work you can send me a dump of your DSDT.

Now the driver itself:

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
	struct device_attribute name_attr;
	struct device_attribute input_attr;
	struct device_attribute max_attr;
	struct device_attribute crit_attr;
	char name_attr_name[ATTR_NAME_SIZE];
	char input_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	char crit_attr_name[ATTR_NAME_SIZE];
	/* id is used for the ACPI ID of the temp */
	int id;
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

#define name_to_atk_temp(attr) \
	container_of(attr, struct atk_temp, name_attr)

static ssize_t atk_temp_name_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_temp *a = name_to_atk_temp(attr);

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
	struct device_attribute name_attr;
	struct device_attribute min_attr;
	struct device_attribute max_attr;
	char name_attr_name[ATTR_NAME_SIZE];
	char input_attr_name[ATTR_NAME_SIZE];
	char min_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	int id;
	acpi_handle handle;
	char const *acpi_name;
};

struct atk_voltage_list {
	int count;
	struct atk_voltage voltage[];
};

#define name_to_atk_voltage(attr) \
	container_of(attr, struct atk_voltage, name_attr)

static ssize_t atk_voltage_name_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_voltage *a = name_to_atk_voltage(attr);

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
	struct device_attribute name_attr;
	struct device_attribute min_attr;
	struct device_attribute max_attr;
	char input_attr_name[ATTR_NAME_SIZE];
	char name_attr_name[ATTR_NAME_SIZE];
	char min_attr_name[ATTR_NAME_SIZE];
	char max_attr_name[ATTR_NAME_SIZE];
	int id;
	unsigned long long unknown;
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

#define name_to_atk_fan(attr) \
	container_of(attr, struct atk_fan, name_attr)

static ssize_t atk_fan_name_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct atk_fan *a = name_to_atk_fan(attr);

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
		ret = device_create_file(dev, &temp_list->temp[i].name_attr);
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
		ret = device_create_file(dev, &voltage_list->voltage[i].name_attr);
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
		ret = device_create_file(dev, &fan_list->fan[i].name_attr);
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
			device_remove_file(dev, &temp_list->temp[i].name_attr);
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
			device_remove_file(dev, &voltage_list->voltage[i].name_attr);
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
			device_remove_file(dev, &fan_list->fan[i].name_attr);
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

		name = &temp_pack->package.elements[1];
		tmax = &temp_pack->package.elements[2];
		tcrit = &temp_pack->package.elements[3];

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

		tmp->temp[i].id = i;
		tmp->temp[i].handle = obj->reference.handle;

		snprintf(tmp->temp[i].input_attr_name, ATTR_NAME_SIZE, "temp%d_input", i);
		atk_init_attribute(&tmp->temp[i].input_attr, tmp->temp[i].input_attr_name,
				0444, atk_temp_input_show, NULL);

		tmp->temp[i].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);
		snprintf(tmp->temp[i].name_attr_name, ATTR_NAME_SIZE, "temp%d_name", i);
		atk_init_attribute(&tmp->temp[i].name_attr, tmp->temp[i].name_attr_name,
				0444, atk_temp_name_show, NULL);

		snprintf(tmp->temp[i].max_attr_name, ATTR_NAME_SIZE, "temp%d_max", i);
		atk_init_attribute(&tmp->temp[i].max_attr, tmp->temp[i].max_attr_name,
				0444, atk_temp_max_show, NULL);

		snprintf(tmp->temp[i].crit_attr_name, ATTR_NAME_SIZE, "temp%d_crit", i);
		atk_init_attribute(&tmp->temp[i].crit_attr, tmp->temp[i].crit_attr_name,
				0444, atk_temp_crit_show, NULL);

		dev_dbg(dev, "temp %u: %s [%llu-%llu]\n", tmp->temp[i].id,
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

		name = &voltage_pack->package.elements[1];
		vmin = &voltage_pack->package.elements[2];
		vmax = &voltage_pack->package.elements[3];

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

		vlt->voltage[i].id = i;
		vlt->voltage[i].handle = obj->reference.handle;
		vlt->voltage[i].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);

		snprintf(vlt->voltage[i].input_attr_name, ATTR_NAME_SIZE, "in%d_input", i);
		atk_init_attribute(&vlt->voltage[i].input_attr,
				vlt->voltage[i].input_attr_name,
				0444, atk_voltage_input_show, NULL);

		snprintf(vlt->voltage[i].name_attr_name, ATTR_NAME_SIZE, "in%d_name", i);
		atk_init_attribute(&vlt->voltage[i].name_attr,
				vlt->voltage[i].name_attr_name,
				0444, atk_voltage_name_show, NULL);

		snprintf(vlt->voltage[i].max_attr_name, ATTR_NAME_SIZE, "in%d_max", i);
		atk_init_attribute(&vlt->voltage[i].max_attr,
				vlt->voltage[i].max_attr_name,
				0444, atk_voltage_max_show, NULL);

		snprintf(vlt->voltage[i].min_attr_name, ATTR_NAME_SIZE, "in%d_min", i);
		atk_init_attribute(&vlt->voltage[i].min_attr,
				vlt->voltage[i].min_attr_name,
				0444, atk_voltage_min_show, NULL);

		dev_dbg(dev, "voltage %u: %s [%llu-%llu]\n", vlt->voltage[i].id,
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

	if (obj->integer.value + 1 != pack->package.count) {
		dev_warn(dev, "%s: invalid fan count %llu (should be %d)\n",
				__func__, obj->integer.value, pack->package.count - 1);
		return -EINVAL;
	}

	fan = kzalloc(sizeof(*fan) + sizeof(*fan->fan) * obj->integer.value, GFP_KERNEL);
	if (!fan)
		return -ENOMEM;

	fan->count = obj->integer.value;
	for (i = 0; i < pack->package.count - 1; i++) {
		struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
		union acpi_object *fan_pack;
		union acpi_object *unk;
		union acpi_object *name;
		union acpi_object *fmin;
		union acpi_object *fmax;
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
		 * unkwown
		 */
		fan_pack = buffer.pointer;

		if (fan_pack->package.count != 5) {
			dev_warn(dev, "%s: invalid package len for object %d: %d\n",
					__func__, i + 1, fan_pack->package.count);
			ACPI_FREE(buffer.pointer);
			ret = -EINVAL;
			goto cleanup;
		}

		unk = &fan_pack->package.elements[0];
		name = &fan_pack->package.elements[1];
		fmin = &fan_pack->package.elements[2];
		fmax = &fan_pack->package.elements[3];

		if (unk->type != ACPI_TYPE_INTEGER) {
			dev_warn(dev, "%s: object %d, int expected (unk), got %d\n",
					__func__, i + 1, unk->type);
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

		fan->fan[i].id = i;
		fan->fan[i].handle = obj->reference.handle;
		fan->fan[i].acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);
		fan->fan[i].unknown = unk->integer.value;

		snprintf(fan->fan[i].input_attr_name, ATTR_NAME_SIZE, "fan%d_input", i);
		atk_init_attribute(&fan->fan[i].input_attr,
				fan->fan[i].input_attr_name,
				0444, atk_fan_input_show, NULL);

		snprintf(fan->fan[i].name_attr_name, ATTR_NAME_SIZE, "fan%d_name", i);
		atk_init_attribute(&fan->fan[i].name_attr,
				fan->fan[i].name_attr_name,
				0444, atk_fan_name_show, NULL);

		snprintf(fan->fan[i].min_attr_name, ATTR_NAME_SIZE, "fan%d_min", i);
		atk_init_attribute(&fan->fan[i].min_attr,
				fan->fan[i].min_attr_name,
				0444, atk_fan_min_show, NULL);

		snprintf(fan->fan[i].max_attr_name, ATTR_NAME_SIZE, "fan%d_max", i);
		atk_init_attribute(&fan->fan[i].max_attr,
				fan->fan[i].max_attr_name,
				0444, atk_fan_max_show, NULL);

		dev_dbg(dev, "fan %d: %s [%llu-%llu]\n", fan->fan[i].id,
				fan->fan[i].acpi_name, fmin->integer.value,
				fmax->integer.value);
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
[1]
http://thread.gmane.org/gmane.linux.drivers.sensors/12454/focus=12486
and:
http://thread.gmane.org/gmane.linux.drivers.sensors/12454/focus=12486
-- 
It can't rain forever,
but you can die before seeing the sun again.
