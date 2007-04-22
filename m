Return-Path: <linux-kernel-owner+w=401wt.eu-S1161479AbXDVQyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161479AbXDVQyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161495AbXDVQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:54:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:14105 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469AbXDVQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IAMofBTBxU/VwTvmRfUBVTBwcfrxTMoeX6cQzZGF588qN3KN0nwK7sJEP5aQsgO+VVNAVU3vNv3I0j4WVEaXFBZReTiysvCcKMDqVvOT8VXNPa2q+BnwbcE+A5ha8BqHH5JDlYL2D0O1QXmajN7aFlTkn0DTImk6xLXmc5jFJ+8=
Date: Sun, 22 Apr 2007 18:55:03 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jean Delvare <khali@linux-fr.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070422165503.GA10081@dreamland.darkstar.lan>
References: <45D5EA88.7090300@redhat.com> <200704151857.03115.bjorn.helgaas@hp.com> <20070416211411.GA16150@dreamland.darkstar.lan> <200704161628.47707.bjorn.helgaas@hp.com> <68676e00704171650t604e30f4j3749b7c5a8ddc5c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00704171650t604e30f4j3749b7c5a8ddc5c5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wed, Apr 18, 2007 at 01:50:29AM +0200, Luca Tettamanti ha scritto: 
> >I'm sure you've seen these:
> >  http://lists.lm-sensors.org/pipermail/lm-sensors/2005-October/014050.html
> >  http://www.lm-sensors.org/wiki/AsusFormulaHacking
> 
> Actually I haven't, I've happily ignored ACPI until now ;-) My DSDT
> doesn't look too bad, I may give it a try...

It wasn't hard :) Temperature reading works fine. AML code is still a
bit obscure though: the reading are enumerated in two different
sections:

* TSIF, FSIF, VSIF: they have read/write methods, easy to understand (I'm
  using these right now)

* SITM/GITM and GGPR for enumeration: more settings are available and in
  part they overlap the others. The methods are very strange, for e.g.
  temperature GITM (which calls GIT6) returns a hard-coded magic value;
  other methods (e.g. CPU frequency, Q-FAN settings) write a random
  number somewhere in the system memory and return an obscure magic
  value... very cool :)


I'm posting the proof-of-concept driver. A few notes:
- only temperature reading is implemented: I just got my MS degree so
  I've been drun^Wbusy
- sysfs files are still RO
- coding style: yes, I know... will cleanup
- There's a gazillion of debugging printk's :)
- I've extended the hwmon sysfs interface, with a new "temp%d_name";
  ACPI knows how the sensor is wired
- You'll need the following patch (against current Linus' git):

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

Now the driver:

/* 
 * Copyright (C) 2007 Luca Tettamanti <kronos.it@gmail.com>
 * Distribute under GPLv2.
 */
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
} atk_data;


typedef ssize_t (*sysfs_show_func)(struct device *dev, struct device_attribute *attr, char *buf);
typedef ssize_t (*sysfs_store_func)(struct device *dev, struct device_attribute *attr,
			const char *buf, size_t count);


static void atk_init_attribute(struct device_attribute *attr, char *name, mode_t mode,
		sysfs_show_func show, sysfs_store_func store)
{
	attr->attr.name = name;
	attr->attr.mode = mode;
	attr->show = show;
	attr->store = store;
}

#define ATTR_NAME_SIZE 32

struct atk_temp_input {
	struct device_attribute dev_attr;
	/* id is used for the ACPI ID of the temp */
	int id;
	char attr_name[ATTR_NAME_SIZE];
};

struct atk_temp_input_list {
	int count;
	struct atk_temp_input temp_input[];
};

#define to_atk_temp_input(attr) \
	container_of(attr, struct atk_temp_input, dev_attr)

static ssize_t atk_temp_input_show(struct device *dev, struct device_attribute *attr, char *buf) {
	struct atk_temp_input *a = to_atk_temp_input(attr);
	union acpi_object temp;
	struct acpi_buffer ret;
	struct acpi_object_list params;
	union acpi_object id;
	acpi_status status;
	ssize_t count;

	id.type = ACPI_TYPE_INTEGER;
	id.integer.value = a->id;

	params.count = 1;
	params.pointer = &id;

	ret.length = sizeof(temp);
	ret.pointer = &temp;

	status = acpi_evaluate_object(atk_data.rtmp_handle, NULL, &params, &ret);
	if (status != AE_OK) {
		printk("acpi_evaluate_object: %s\n", acpi_format_exception(status));
		return -EIO;
	}

	if (temp.type != ACPI_TYPE_INTEGER) {
		printk("not an integer (%d)\n", temp.type);
		return -EIO;
	}

	/* ACPI returns centidegree */
	count = sprintf(buf, "%llu\n", temp.integer.value * 10);

	return count;
}

struct atk_temp_name {
	struct device_attribute dev_attr;
	char attr_name[ATTR_NAME_SIZE];
	char const *name;
};

struct atk_temp_name_list {
	int count;
	struct atk_temp_name temp_name[];
};

#define to_atk_temp_name(attr) \
	container_of(attr, struct atk_temp_name, dev_attr)

static ssize_t atk_temp_name_show(struct device *dev, struct device_attribute *attr, char *buf) {
	struct atk_temp_name *a = to_atk_temp_name(attr);

	return sprintf(buf, "%s\n", a->name);
}

enum atk_temp_pack_id {
	ATK_TEMP_PACK_MAX = 2,
	ATK_TEMP_PACK_CRIT = 3,
};

static int atk_temp_pack_read(acpi_handle handle, int pack_id, enum atk_temp_pack_id temp_id,
		unsigned long long *temp) {
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

	status = acpi_evaluate_object(handle, NULL, &params, &ret);
	if (status != AE_OK) {
		printk("atk_temp_pack_read: acpi_evaluate_object: %s\n",
				acpi_format_exception(status));
		return -EIO;
	}

	pack = ret.pointer;

	if (pack->type != ACPI_TYPE_PACKAGE) {
		printk("atk_temp_pack_read: ret object is not a package: %d\n",
			pack->type);

		err = -EIO;
		goto out;
	}
	if (pack->package.count != 5) {
		printk("atk_temp_pack_read: unexpected package size: %d\n",
				pack->package.count);
		err = -EIO;
		goto out;
	}

	obj = &pack->package.elements[temp_id];
	if (obj->type != ACPI_TYPE_INTEGER) {
		printk("atk_temp_pack_read: unexepected type %d\n",
				obj->type);
		err = -EIO;
		goto out;
	}

	*temp = obj->integer.value;
	
out:
	ACPI_FREE(ret.pointer);

	return err;
}

struct atk_temp_max {
	struct device_attribute dev_attr;
	int id;
	acpi_handle handle;
	char attr_name[ATTR_NAME_SIZE];
};

struct atk_temp_max_list {
	int count;
	struct atk_temp_max temp_max[];
};

#define to_atk_temp_max(attr) \
	container_of(attr, struct atk_temp_max, dev_attr)

static ssize_t atk_temp_max_show(struct device *dev, struct device_attribute *attr, char *buf) {
	struct atk_temp_max *a = to_atk_temp_max(attr);
	unsigned long long temp;

	if (atk_temp_pack_read(a->handle, a->id, ATK_TEMP_PACK_MAX, &temp))
		return -EIO;

	return sprintf(buf, "%lld\n", temp * 10);
}

struct atk_temp_crit {
	struct device_attribute dev_attr;
	int id;
	acpi_handle handle;
	char attr_name[ATTR_NAME_SIZE];
};

struct atk_temp_crit_list {
	int count;
	struct atk_temp_crit temp_crit[];
};

#define to_atk_temp_crit(attr) \
	container_of(attr, struct atk_temp_crit, dev_attr)

static ssize_t atk_temp_crit_show(struct device *dev, struct device_attribute *attr, char *buf) {
	struct atk_temp_crit *a = to_atk_temp_crit(attr);
	unsigned long long temp;

	if (atk_temp_pack_read(a->handle, a->id, ATK_TEMP_PACK_CRIT, &temp))
		return -EIO;

	return sprintf(buf, "%lld\n", temp * 10);
}

struct atk_temp_input_list *temp_input_list;
struct atk_temp_name_list *temp_name_list;
struct atk_temp_max_list *temp_max_list;
struct atk_temp_crit_list *temp_crit_list;

static int atk_found;

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

static int atk_create_files(struct device *dev) {
	int i;
	int ret;

	/* Temperatures */
	for (i = 0; i < temp_input_list->count; i++) {
		ret = device_create_file(dev, &temp_input_list->temp_input[i].dev_attr);
		if (ret)
			return ret;
	}
	for (i = 0; i < temp_name_list->count; i++) {
		ret = device_create_file(dev, &temp_name_list->temp_name[i].dev_attr);
		if (ret)
			return ret;
	}
	for (i = 0; i < temp_max_list->count; i++) {
		ret = device_create_file(dev, &temp_max_list->temp_max[i].dev_attr);
		if (ret)
			return ret;
	}
	for (i = 0; i < temp_crit_list->count; i++) {
		ret = device_create_file(dev, &temp_crit_list->temp_crit[i].dev_attr);
		if (ret)
			return ret;
	}

	return 0;
}

static void atk_remove_files(struct device *dev) {
	int i;

	/* Temperatures */
	if (temp_input_list) {
		for (i = 0; i < temp_input_list->count; i++)
			device_remove_file(dev, &temp_input_list->temp_input[i].dev_attr);
	}
	kfree(temp_input_list);

	if (temp_name_list) {
		for (i = 0; i < temp_name_list->count; i++) {
			device_remove_file(dev, &temp_name_list->temp_name[i].dev_attr);
			kfree(temp_name_list->temp_name[i].name);
		}
	}
	kfree(temp_name_list);

	if (temp_max_list) {
		for (i = 0; i < temp_max_list->count; i++)
			device_remove_file(dev, &temp_max_list->temp_max[i].dev_attr);
	}
	kfree(temp_max_list);

	if (temp_crit_list) {
		for (i = 0; i < temp_crit_list->count; i++)
			device_remove_file(dev, &temp_crit_list->temp_crit[i].dev_attr);
	}
	kfree(temp_max_list);
}

static int atk_enumerate_temp(struct acpi_buffer *buf) {
	union acpi_object *pack;
	union acpi_object *obj;
	struct atk_temp_input_list *inputs;
	struct atk_temp_name_list *names;
	struct atk_temp_max_list *max;
	struct atk_temp_crit_list *crit;
	int i, ret;

	/* Result must be a package */
	pack = buf->pointer;
	if (pack->type != ACPI_TYPE_PACKAGE) {
		printk("atk_enumerate_temp: not a package\n");
		return -EINVAL;
	}

	if (pack->package.count < 1) {
		printk("atk_enumerate_temp: count < 1\n");
		return -EINVAL;
	}

	/* First field is the number of available readings */
	obj = &pack->package.elements[0];
	if (obj->type != ACPI_TYPE_INTEGER) {
		printk("atk_enumerate_temp: element 0 is not an int (%u)\n", obj->type);
		return -EINVAL;
	}

	/* Sanity check */
	if (pack->package.count != obj->integer.value + 1) {
		printk("atk_enumerate_temp: temperature count (%llu) differs from package count (%u)\n",
				obj->integer.value, pack->package.count);
		return -EINVAL;
	}

	inputs = kzalloc(sizeof(struct atk_temp_input_list) + sizeof(*inputs->temp_input) * obj->integer.value, GFP_KERNEL);
	if (!inputs)
		return -ENOMEM;

	names = kzalloc(sizeof(struct atk_temp_name_list) + sizeof(*names->temp_name) * obj->integer.value, GFP_KERNEL);
	if (!names) {
		ret = -ENOMEM;
		goto cleanup4;
	}

	max = kzalloc(sizeof(*max) + sizeof(*max->temp_max) * obj->integer.value, GFP_KERNEL);
	if (!max) {
		ret = -ENOMEM;
		goto cleanup3;
	}

	crit = kzalloc(sizeof(*crit) + sizeof(*crit->temp_crit) * obj->integer.value, GFP_KERNEL);
	if (!crit) {
		ret = -ENOMEM;
		goto cleanup2;
	}

	inputs->count = names->count = max->count = crit->count = obj->integer.value;
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
			printk("atk_enumerate_temp: unexpected type: %d\n", obj->type);
			ret = -EINVAL;
			goto cleanup;
		}

		buf.length = ACPI_ALLOCATE_BUFFER;
		status = acpi_evaluate_object(obj->reference.handle, NULL, NULL, &buf);
		if (status != AE_OK) {
			printk("ACPI exception on object %u: %s\n", i + 1, acpi_format_exception(status));
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

		if (temp_pack->type != ACPI_TYPE_PACKAGE) {
			printk("atk_enumerate_temp: unexpected type for package %u: %d\n", i + 1, temp_pack->type);
			ret = -EINVAL;
			goto cleanup;
		}

		if (temp_pack->package.count != 5) {
			printk("Invalid package count: %u\n", temp_pack->package.count);
			ret = -EINVAL;
			goto cleanup;
		}

		name = &temp_pack->package.elements[1];
		tmax = &temp_pack->package.elements[2];
		tcrit = &temp_pack->package.elements[3];

		if (name->type != ACPI_TYPE_STRING) {
			printk("atk_enumerate_temp: object %d not a string (%d)\n",
					i, name->type);
			ret = -EINVAL;
			goto cleanup;
		}

		if (tmax->type != ACPI_TYPE_INTEGER) {
			printk("atk_enumerate_temp: object %d int expected (tmax), got: %d\n",
					i, tmax->type);
			ret = -EINVAL;
			goto cleanup;
		}
		if (tcrit->type != ACPI_TYPE_INTEGER) {
			printk("atk_enumerate_temp: object %d int expected (tmax), got: %d\n",
					i, tcrit->type);
			ret = -EINVAL;
			goto cleanup;
		}

		inputs->temp_input[i].id = i;
		snprintf(inputs->temp_input[i].attr_name, ATTR_NAME_SIZE, "temp%d_input", i);
		atk_init_attribute(&inputs->temp_input[i].dev_attr, inputs->temp_input[i].attr_name,
				0444, atk_temp_input_show, NULL);
		names->temp_name[i].name = kstrdup(name->string.pointer, GFP_KERNEL);
		
		snprintf(names->temp_name[i].attr_name, ATTR_NAME_SIZE, "temp%d_name", i);
		atk_init_attribute(&names->temp_name[i].dev_attr, names->temp_name[i].attr_name,
				0444, atk_temp_name_show, NULL);
		
		max->temp_max[i].handle = obj->reference.handle;
		snprintf(max->temp_max[i].attr_name, ATTR_NAME_SIZE, "temp%d_max", i);
		atk_init_attribute(&max->temp_max[i].dev_attr, max->temp_max[i].attr_name,
				0444, atk_temp_max_show, NULL);

		crit->temp_crit[i].handle = obj->reference.handle;
		snprintf(crit->temp_crit[i].attr_name, ATTR_NAME_SIZE, "temp%d_crit", i);
		atk_init_attribute(&crit->temp_crit[i].dev_attr, crit->temp_crit[i].attr_name,
				0444, atk_temp_crit_show, NULL);

		printk("temp %u: %s [%llu-%llu]\n", inputs->temp_input[i].id, names->temp_name[i].name,
				tmax->integer.value, tcrit->integer.value);

		ACPI_FREE(buf.pointer);
	}

	temp_name_list = names;
	temp_input_list = inputs;
	temp_max_list = max;
	temp_crit_list = crit;

	return 0;
cleanup:
	kfree(crit);
cleanup2:
	kfree(max);
cleanup3:
	for (i = 0; i < names->count; i++)
		kfree(names->temp_name[i].name);
	kfree(names);
cleanup4:
	kfree(inputs);

	return ret;
}

static int atk_add(struct acpi_device *device) {
	acpi_status ret;
	int err;
	struct acpi_buffer buf;
	union acpi_object *obj;
	struct acpi_namespace_node *search_ns;
	struct acpi_namespace_node *ns;

	printk("adding...\n");

	atk_data.device = device;
	atk_data.atk_handle = device->handle;
	acpi_driver_data(device) = &atk_data;

	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object(atk_data.atk_handle, "MBIF", NULL, &buf);
	if (ret != AE_OK)
		return -ENODEV;

	obj = buf.pointer;
	if (obj->type == ACPI_TYPE_PACKAGE) {
		printk("id: %s\n", obj->package.elements[1].string.pointer);
	}
	ACPI_FREE(buf.pointer);

	/* Check for hwmon methods */
	search_ns = acpi_ns_map_handle_to_node(device->handle);
	if (search_ns == NULL) {
		printk("NULL\n");
		return -ENODEV;
	}

	/* RTMP: read temperature */
	ret = acpi_ns_get_node(search_ns, "RTMP", ACPI_NS_NO_UPSEARCH, &ns);
	if (ret != AE_OK) {
		printk(KERN_INFO "atk: RTMP not found\n");
		return -ENODEV;
	}

	atk_data.rtmp_handle = acpi_ns_convert_entry_to_handle(ns);

	/* Enumerate temp data - TSIF */
	buf.length = ACPI_ALLOCATE_BUFFER;
	ret = acpi_evaluate_object(atk_data.atk_handle, "TSIF", NULL, &buf);
	if (ret != AE_OK) {
		printk("TSIF failed: %s\n", acpi_format_exception(ret));
		return -ENODEV;
	}

	err = atk_enumerate_temp(&buf);
	ACPI_FREE(buf.pointer);
	if (err)
		return err;

	atk_found = 1;

	return 0;
}

static int atk_remove(struct acpi_device *device, int type) {
	printk("remove %d\n", type);

	acpi_driver_data(device) = NULL;

	return AE_OK;
}

int atk_init(void) {
	int ret;

	ret = acpi_bus_register_driver(&atk_driver);
	printk("%d\n", ret);
	if (ret)
		return ret;

	if (!atk_data.atk_handle) {
		ret = -ENODEV;
		goto bus_unreg;
	}

	if (!atk_found) {
		printk("atk not found\n");
		ret = -ENODEV;
		goto bus_unreg;
	}

	atk_data.class_dev = hwmon_device_register(&atk_data.device->dev);
	if (IS_ERR(atk_data.class_dev)) {
		ret = PTR_ERR(atk_data.class_dev);
		goto bus_unreg;
	}
	
	ret = atk_create_files(&atk_data.device->dev);
	if (ret)
		goto remove_files;

	return ret;

remove_files:
	atk_remove_files(&atk_data.device->dev);
	hwmon_device_unregister(atk_data.class_dev);
bus_unreg:
	acpi_bus_unregister_driver(&atk_driver);

	return ret;
}

void atk_exit(void) {
	hwmon_device_unregister(atk_data.class_dev);

	atk_remove_files(&atk_data.device->dev);

	acpi_bus_unregister_driver(&atk_driver);


}

module_init(atk_init);
module_exit(atk_exit);

MODULE_LICENSE("GPL");



Luca
-- 
Dicono che  il cane sia  il miglior  amico dell'uomo. Secondo me  non e`
vero. Quanti dei vostri amici avete fatto castrare, recentemente?
