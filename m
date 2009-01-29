Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZA2VP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZA2VP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2VPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:15:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:51474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZA2VPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lZA4vJY+Gp4+Trd4OcXiUXdTANImbyZXCyX9J9osDmXjS7F+UGQQYEq8vmHABaonLv
         6wdyFi4qAe6nDFecZpvoEypuDPPzzeq11Q3D1lCx5TIiPVqwrV+S4gUYbjMBK1iyJzN2
         Q2vay0NoLcxuQ9h1+bMPObNW0D+Mml/UaH2Ms=
Date: Thu, 29 Jan 2009 22:15:10 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       khali@linux-fr.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090129211509.GA8931@dreamland.darkstar.lan>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com> <200901291729.24859.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901291729.24859.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, Jan 29, 2009 at 05:29:23PM +0100, Thomas Renninger ha scritto: 
> On Thursday 29 January 2009 16:16:38 Luca Tettamanti wrote:
> > On Thu, Jan 29, 2009 at 11:30 AM, Thomas Renninger <trenn@suse.de> wrote:
> > > On Sunday 25 January 2009 22:05:20 Luca Tettamanti wrote:
> > >> (This is an improved version of my earlier patch, I've reworked deviced
> > >> detection to simply check for the desired HID)
> > >>
> > >> The following patch adds "auto" option to "acpi_enforce_resource"; this
> > >> value is also the new default.
> > >> "auto" enforces strict resource checking - disallowing access by native
> > >> drivers to IO ports and memory regions claimed by ACPI firmware - when a
> > >> device with a known ACPI driver is found (currently only ASUS ATK0110 is
> > >> checked), and reverts to lax checking otherwise.
> > >>
> > >> The patch is mainly aimed to block native hwmon drivers from touching
> > >> monitoring chips that ACPI thinks it own.
> > >
> > > Having this in the core ACPI code is ugly.
> >
> > I think we all agree :-)
> >
> > > Either this should be more generic (instead of hardcoded "ATK0110"
> > > device, use a list to add further specific thermal ACPI drivers). Hmm,
> > > maybe it's only ASUS violating the spec?
> >
> > ASUS it's not actually violating any spec...
> They have to export the temperature through a thermal ACPI
> device, not through the ASUS specific ATK0110 device. This is
> what I mean whether there might be other vendor specific ACPI
> devices violating the spec (by providing temperature read
> functionality which should be done through the generic thermal
> ACPI device).

Ah, I see. As Hans stated the ATK device covers more than just
temperatures and it seems that Asus intends to keep it (the interface is
evolving and Windows utils use it). The pattern seems to be _TMP for
notebook (but not the rest of the hwmon stuff) and full hwmon (but not
_TMP) for desktop. Your M2V is actually an exception...

> > The EC does not
> > make any difference, since a native driver would speak directly to the
> > monitoring chip, effectively by-passing the EC.
> > Now, in principle "strict" is the correct behaviour for the resource
> > checking code, but it would break many working setups leaving the
> > users without any kind of hw monitoring. The "auto" hack is meant to
> > force the users to migrate to the ACPI driver...
> >
> > > Are there other known, model specific ACPI devices,
> > > accessing thermal IOs directly which could interfere with hwmon, then it
> > > might be worth it.
> >
> > Right now "auto" is ASUS-specific because *I* know that there any many
> > different native drivers that works on various boards (and I wrote the
> > the ACPI driver...);
> Hmm, grep -r ATK0110 drivers/platform/x86 in latest ACPI test tree is
> empty, can you give me a pointer to a recent version of your driver.

It's not upstream yet; the idea was to disable native drivers (with
"auto") and merge the driver at the same time; otherwise it might not be
safe to use it. I'm attaching the patch for reference.

> > At least eeepc and (some?) thinkpads have ACPI
> > hwmon capabilities but I don't know whether there are native drivers
> > available or not (but they could be "blacklisted"  preemptively like
> > ASUS ATK).
> I expect that ASUS only will interfere with specific hwmon driver(s)?
> So why don't you move the check into the hwmon driver and make it not
> load on these systems?
> It's still ugly, but IMO better than to pollute the ACPI core.

That would involve disabling just about everything... we don't wont to
touch sensors that are owned by the firmware, but ATM it's not possible
to enforce strict resource validation since it may break unrelated
stuff.

> Here some thermal DSDT parts of a recent ASUS machine:
> 
> The temperature exported through the generic thermal ACPI device:
> 
>     OperationRegion (IP, SystemIO, 0x022D, 0x02)
>     Field (IP, ByteAcc, NoLock, Preserve)
>     {
>         INDX,   8,
>         DAT0,   8
>     }
> 
>     Method (SBYT, 2, NotSerialized)
>     {
>         Store (Arg0, INDX)
>         Store (Arg1, DAT0)
>     }
> 
>     Method (GBYT, 1, NotSerialized)
>     {
>         Store (Arg0, INDX)
>         Store (DAT0, Local0)
>         Return (Local0)
>     }
> 
> Method (_TMP, 0, NotSerialized)
>     {
>     /* makes use of RTMP which uses GBYT and SBYT to actually read
>        the temp
>     */
>     }
> 
> There is another RTMP function in ATK0110 (do you use that?)

There are actually 2 interfaces: the older one is based on
TSIF/FSIF/VSIF for enumerating the available sensors (temp, fan,
voltage) and RTMP/RFAN/RVLT for reading; the newer one uses two giant
demux (GGRP and GITM) for enumerating and reading.
There's a lot of other stuff (bus and memory frequencies, fan control,
OC profiles) but it's not used by the driver implemented (yet).

> On the M2A-VM-HDMI machine where DSDT extracts from above are,
> running libsensors I get:
> 
> Driver `it87' (should be inserted):
>   Detects correctly:
>   * ISA bus, address 0x228
>     Chip `ITE IT8716F Super IO Sensors' (confidence: 9)
> 
> Driver `to-be-written' (should be inserted):
>   Detects correctly:
>   * Chip `AMD K10 thermal sensors' (confidence: 9)
> 
> If this is an ASUS only problem with very specific thermal
> sensors, better add the quirk at the specific sensor driver.
> 
> If this is something general, then maybe you can convince Len
> to add something to the ACPI core, but this should be more
> generic then.

The point is: resource validation should be strict since we have no idea
of what AML might be doing. But we also don't want to face hordes of
angry users, so the proposed "auto" trick enforces strict validation when
we have an alternative and falls back to lax otherwise.

Now, both eeepc and thinkpad platform drivers provide fan managent via
ACPI (and temperatures via standard thermal zones I suppose), so they
could use the same treatment.

> PS: I just realize that in ATK0110 the same thermal device
> (IO port 0x22D) is used as in the generic ACPI device (_TMP).
> So it looks like your asus thermal driver will not only interfere
> with the hwmon driver, but with the ACPI thermal driver itself.

Unless I'm mistaked method execution is serialized by the interpreter,
so they won't interfere with each other. If something else (maybe a SMI
handler?) can execute the same stuff they'd better use a mutex to
synchronize the execution (regardless of any additional driver).

(driver follows)
---
Asus boards have an ACPI interface for interacting with the hwmon (fan,
temperatures, voltages) subsystem; this driver exposes the relevant
information via the standard sysfs interface.

There are two different ACPI interfaces:
- an old one (based on RVLT/RFAN/RTMP)
- a new one (GGRP/GITM)
Both may be present but there a few cases (my board, sigh) where the
new interface is just an empty stub; the driver defaults to the old one
when both are present.
The old interface has received a considerable testing, but I'm still
awaiting confirmation from my tester that the new one is working as
expected (hence the debug code is still enabled).

Currently all the attributes are read-only, though a (partial) control
should be possible with a bit more work.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 drivers/acpi/acpica/nsxfeval.c |    3 
 drivers/hwmon/Kconfig          |   12 
 drivers/hwmon/Makefile         |    1 
 drivers/hwmon/asus_atk0110.c   | 1015 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h          |    2 
 5 files changed, 1029 insertions(+), 4 deletions(-)

Index: b/include/acpi/acpixf.h
===================================================================
--- a/include/acpi/acpixf.h	2009-01-17 18:38:24.518880624 +0100
+++ b/include/acpi/acpixf.h	2009-01-17 19:05:14.922881979 +0100
@@ -187,14 +187,12 @@
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
Index: b/drivers/hwmon/asus_atk0110.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/hwmon/asus_atk0110.c	2009-01-26 21:30:59.246505545 +0100
@@ -0,0 +1,1015 @@
+/*
+ * Copyright (C) 2007-2009 Luca Tettamanti <kronos.it@gmail.com>
+ *
+ * This file is released under the GPLv2
+ * See COPYING in the top level directory of the kernel tree.
+ */
+
+#define DEBUG
+
+#include <linux/kernel.h>
+#include <linux/hwmon.h>
+#include <linux/list.h>
+#include <linux/module.h>
+
+#include <acpi/acpi.h>
+#include <acpi/acpixf.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
+
+
+#define ATK_HID "ATK0110"
+#define ATK_DRV "atk-hwmon"
+
+/* Minimum time between readings, enforced in order to avoid
+ * hogging the CPU.
+ */
+#define CACHE_TIME		HZ
+
+#define BOARD_ID		"MBIF"
+#define METHOD_ENUMERATE	"GGRP"
+#define METHOD_READ		"GITM"
+#define METHOD_WRITE		"SITM"
+#define METHOD_OLD_READ_TMP	"RTMP"
+#define METHOD_OLD_READ_VLT	"RVLT"
+#define METHOD_OLD_READ_FAN	"RFAN"
+#define METHOD_OLD_ENUM_TMP	"TSIF"
+#define METHOD_OLD_ENUM_VLT	"VSIF"
+#define METHOD_OLD_ENUM_FAN	"FSIF"
+
+#define ATK_MUX_HWMON		0x00000006ULL
+
+#define ATK_CLASS_MASK		0xff000000ULL
+#define ATK_CLASS_FREQ_CTL	0x03000000ULL
+#define ATK_CLASS_FAN_CTL	0x04000000ULL
+#define ATK_CLASS_HWMON		0x06000000ULL
+
+#define ATK_TYPE_MASK		0x00ff0000ULL
+#define HWMON_TYPE_VOLT		0x00020000ULL
+#define HWMON_TYPE_TEMP		0x00030000ULL
+#define HWMON_TYPE_FAN		0x00040000ULL
+
+#define HWMON_SENSOR_ID_MASK	0x0000ffffULL
+
+enum atk_pack_member {
+	HWMON_PACK_FLAGS,
+	HWMON_PACK_NAME,
+	HWMON_PACK_LIMIT1,
+	HWMON_PACK_LIMIT2,
+	HWMON_PACK_ENABLE
+};
+
+/* New package format */
+#define _HWMON_NEW_PACK_SIZE	7
+#define _HWMON_NEW_PACK_FLAGS	0
+#define _HWMON_NEW_PACK_NAME	1
+#define _HWMON_NEW_PACK_UNK1	2
+#define _HWMON_NEW_PACK_UNK2	3
+#define _HWMON_NEW_PACK_LIMIT1	4
+#define _HWMON_NEW_PACK_LIMIT2	5
+#define _HWMON_NEW_PACK_ENABLE	6
+
+/* Old package format */
+#define _HWMON_OLD_PACK_SIZE	5
+#define _HWMON_OLD_PACK_FLAGS	0
+#define _HWMON_OLD_PACK_NAME	1
+#define _HWMON_OLD_PACK_LIMIT1	2
+#define _HWMON_OLD_PACK_LIMIT2	3
+#define _HWMON_OLD_PACK_ENABLE	4
+
+
+struct atk_data {
+	struct device *hwmon_dev;
+	acpi_handle atk_handle;
+	struct acpi_device *acpi_dev;
+
+	bool old_interface;
+
+	/* old interface */
+	acpi_handle rtmp_handle;
+	acpi_handle rvlt_handle;
+	acpi_handle rfan_handle;
+	/* new inteface */
+	acpi_handle enumerate_handle;
+	acpi_handle read_handle;
+
+	int voltage_count;
+	int temperature_count;
+	int fan_count;
+	struct list_head sensor_list;
+};
+
+
+typedef ssize_t (*sysfs_show_func)(struct device *dev,
+			struct device_attribute *attr, char *buf);
+
+static const struct acpi_device_id atk_ids[] = {
+	{ATK_HID, 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, atk_ids);
+
+#define ATTR_NAME_SIZE 16 /* Worst case is "tempN_input" */
+
+struct atk_sensor_data {
+	struct list_head list;
+	struct atk_data *data;
+	struct device_attribute label_attr;
+	struct device_attribute input_attr;
+	struct device_attribute limit1_attr;
+	struct device_attribute limit2_attr;
+	char label_attr_name[ATTR_NAME_SIZE];
+	char input_attr_name[ATTR_NAME_SIZE];
+	char limit1_attr_name[ATTR_NAME_SIZE];
+	char limit2_attr_name[ATTR_NAME_SIZE];
+	u64 id;
+	u64 type;
+	u64 limit1;
+	u64 limit2;
+	u64 cached_value;
+	unsigned long last_updated; /* in jiffies */
+	bool is_valid;
+	char const *acpi_name;
+};
+
+struct atk_acpi_buffer_u64 {
+	union acpi_object buf;
+	u64 value;
+};
+
+static int atk_add(struct acpi_device *device);
+static int atk_remove(struct acpi_device *device, int type);
+static void atk_print_sensor(struct atk_data *data, union acpi_object *obj);
+static int atk_read_value(struct atk_sensor_data *sensor, u64 *value);
+static void atk_free_sensors(struct atk_data *data);
+
+static struct acpi_driver atk_driver = {
+	.name	= ATK_HID,
+	.class	= "hwmon",
+	.ids	= atk_ids,
+	.ops	= {
+		.add	= atk_add,
+		.remove	= atk_remove,
+	},
+};
+
+#define input_to_atk_sensor(attr) \
+	container_of(attr, struct atk_sensor_data, input_attr)
+
+#define label_to_atk_sensor(attr) \
+	container_of(attr, struct atk_sensor_data, label_attr)
+
+#define limit1_to_atk_sensor(attr) \
+	container_of(attr, struct atk_sensor_data, limit1_attr)
+
+#define limit2_to_atk_sensor(attr) \
+	container_of(attr, struct atk_sensor_data, limit2_attr)
+
+static ssize_t atk_input_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct atk_sensor_data *s = input_to_atk_sensor(attr);
+	u64 value;
+	int err;
+
+	err = atk_read_value(s, &value);
+	if (err)
+		return err;
+
+	if (s->type == HWMON_TYPE_TEMP)
+		/* ACPI returns decidegree */
+		value *= 100;
+
+	return sprintf(buf, "%llu\n", value);
+}
+
+static ssize_t atk_label_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct atk_sensor_data *s = label_to_atk_sensor(attr);
+
+	return sprintf(buf, "%s\n", s->acpi_name);
+}
+
+static ssize_t atk_limit1_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct atk_sensor_data *s = limit1_to_atk_sensor(attr);
+	u64 value = s->limit1;
+
+	if (s->type == HWMON_TYPE_TEMP)
+		value *= 100;
+
+	return sprintf(buf, "%lld\n", value);
+}
+
+static ssize_t atk_limit2_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct atk_sensor_data *s = limit2_to_atk_sensor(attr);
+	u64 value = s->limit2;
+
+	if (s->type == HWMON_TYPE_TEMP)
+		value *= 100;
+
+	return sprintf(buf, "%lld\n", value);
+}
+
+static ssize_t atk_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "atk0110\n");
+}
+static struct device_attribute atk_name_attr = __ATTR(name, 0444, atk_name_show, NULL);
+
+static void atk_init_attribute(struct device_attribute *attr, char *name,
+		sysfs_show_func show)
+{
+	attr->attr.name = name;
+	attr->attr.mode = 0444;
+	attr->show = show;
+	attr->store = NULL;
+}
+
+
+static union acpi_object *atk_get_pack_member(struct atk_data *data,
+						union acpi_object *pack,
+						enum atk_pack_member m)
+{
+	bool old_if = data->old_interface;
+	int offset;
+
+	switch (m) {
+	case HWMON_PACK_FLAGS:
+		offset = old_if ? _HWMON_OLD_PACK_FLAGS : _HWMON_NEW_PACK_FLAGS;
+		break;
+	case HWMON_PACK_NAME:
+		offset = old_if ? _HWMON_OLD_PACK_NAME : _HWMON_NEW_PACK_NAME;
+		break;
+	case HWMON_PACK_LIMIT1:
+		offset = old_if ? _HWMON_OLD_PACK_LIMIT1 : _HWMON_NEW_PACK_LIMIT1;
+		break;
+	case HWMON_PACK_LIMIT2:
+		offset = old_if ? _HWMON_OLD_PACK_LIMIT2 : _HWMON_NEW_PACK_LIMIT2;
+		break;
+	case HWMON_PACK_ENABLE:
+		offset = old_if ? _HWMON_OLD_PACK_ENABLE : _HWMON_NEW_PACK_ENABLE;
+		break;
+	default:
+		return NULL;
+	}
+
+	return &pack->package.elements[offset];
+}
+
+
+/* New package format is:
+ * - flag (int)
+ *	class - used for de-muxing the request to the correct GITn
+ *	type (volt, temp, fan)
+ *	sensor id |
+ *	sensor id - used for de-muxing the request _inside_ the GITn
+ * - name (str)
+ * - unknown (int)
+ * - unknown (int)
+ * - limit1 (int)
+ * - limit2 (int)
+ * - enable (int)
+ *
+ * The old package has the same format but it's missing the two unknown fields.
+ */
+static int validate_hwmon_pack(struct atk_data *data, union acpi_object *obj)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *tmp;
+	bool old_if = data->old_interface;
+	int const expected_size = old_if ? _HWMON_OLD_PACK_SIZE : _HWMON_NEW_PACK_SIZE;
+
+	if (obj->type != ACPI_TYPE_PACKAGE) {
+		dev_warn(dev, "Invalid type: %d\n", obj->type);
+		return -EINVAL;
+	}
+
+	if (obj->package.count != expected_size) {
+		dev_warn(dev, "Invalid package size: %d, expected: %d\n",
+				obj->package.count, expected_size);
+		return -EINVAL;
+	}
+
+	tmp = atk_get_pack_member(data, obj, HWMON_PACK_FLAGS);
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (flag): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	tmp = atk_get_pack_member(data, obj, HWMON_PACK_NAME);
+	if (tmp->type != ACPI_TYPE_STRING) {
+		dev_warn(dev, "Invalid type (name): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	/* Don't check... we don't know what they're useful for anyway */
+#if 0
+	tmp = &obj->package.elements[HWMON_PACK_UNK1];
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (unk1): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	tmp = &obj->package.elements[HWMON_PACK_UNK2];
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (unk2): %d\n", tmp->type);
+		return -EINVAL;
+	}
+#endif
+
+	tmp = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT1);
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (limit1): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	tmp = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT2);
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (limit2): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	tmp = atk_get_pack_member(data, obj, HWMON_PACK_ENABLE);
+	if (tmp->type != ACPI_TYPE_INTEGER) {
+		dev_warn(dev, "Invalid type (enable): %d\n", tmp->type);
+		return -EINVAL;
+	}
+
+	atk_print_sensor(data, obj);
+
+	return 0;
+}
+
+static char const *atk_sensor_type(union acpi_object *flags)
+{
+	u64 type = flags->integer.value & ATK_TYPE_MASK;
+	char const *what;
+
+	switch (type) {
+	case HWMON_TYPE_VOLT:
+		what = "voltage";
+		break;
+	case HWMON_TYPE_TEMP:
+		what = "temperature";
+		break;
+	case HWMON_TYPE_FAN:
+		what = "fan";
+		break;
+	default:
+		what = "unknown";
+		break;
+	}
+
+	return what;
+}
+
+static void atk_print_sensor(struct atk_data *data, union acpi_object *obj)
+{
+#ifdef DEBUG
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *flags;
+	union acpi_object *name;
+	union acpi_object *limit1;
+	union acpi_object *limit2;
+	union acpi_object *enable;
+	char const *what;
+
+	flags = atk_get_pack_member(data, obj, HWMON_PACK_FLAGS);
+	name = atk_get_pack_member(data, obj, HWMON_PACK_NAME);
+	limit1 = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT1);
+	limit2 = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT2);
+	enable = atk_get_pack_member(data, obj, HWMON_PACK_ENABLE);
+
+	what = atk_sensor_type(flags);
+
+	dev_dbg(dev, "%s: %#llx %s [%llu-%llu] %s\n", what,
+			flags->integer.value,
+			name->string.pointer,
+			limit1->integer.value, limit2->integer.value,
+			enable->integer.value ? "enabled" : "disabled");
+#endif
+}
+
+static int atk_read_value_old(struct atk_sensor_data *sensor, u64 *value)
+{
+	struct atk_data *data = sensor->data;
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_object_list params;
+	union acpi_object id;
+	acpi_status status;
+	acpi_handle method;
+
+	switch (sensor->type) {
+	case HWMON_TYPE_VOLT:
+		method = data->rvlt_handle;
+		break;
+	case HWMON_TYPE_TEMP:
+		method = data->rtmp_handle;
+		break;
+	case HWMON_TYPE_FAN:
+		method = data->rfan_handle;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	id.type = ACPI_TYPE_INTEGER;
+	id.integer.value = sensor->id;
+
+	params.count = 1;
+	params.pointer = &id;
+
+	status = acpi_evaluate_integer(method, NULL, &params, value);
+	if (status != AE_OK) {
+		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
+				acpi_format_exception(status));
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
+{
+	struct atk_data *data = sensor->data;
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_object_list params;
+	struct acpi_buffer ret;
+	union acpi_object id;
+	struct atk_acpi_buffer_u64 tmp;
+	acpi_status status;
+	union acpi_object *o;
+	int i;
+
+	id.type = ACPI_TYPE_INTEGER;
+	id.integer.value = sensor->id;
+
+	params.count = 1;
+	params.pointer = &id;
+
+	tmp.buf.type = ACPI_TYPE_BUFFER;
+	tmp.buf.buffer.pointer = (u8 *)&tmp.value;
+	tmp.buf.buffer.length = sizeof(u64);
+	ret.length = sizeof(tmp);
+	ret.pointer = &tmp;
+
+	status = acpi_evaluate_object_typed(data->read_handle, NULL, &params,
+			&ret, ACPI_TYPE_BUFFER);
+	if (status != AE_OK) {
+		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
+				acpi_format_exception(status));
+		return -EIO;
+	}
+
+	o = ret.pointer;
+	dev_dbg(dev, "type = %d\n", o->type);
+	dev_dbg(dev, "size = %d\n", o->buffer.length);
+
+	for (i = 0; i < o->buffer.length; i++)
+		dev_dbg(dev, "  [%#x] %d\n", (u32)(o->buffer.pointer[i]),
+				(u32)(o->buffer.pointer[i]));
+
+	/* Return buffer format:
+	 * [0-3] "value" is valid flag
+	 * [4-7] value
+	 */
+	if (!(tmp.value & 0xffffffff)) {
+		/* The reading is not valid, possible causes:
+		 * - sensor failure
+		 * - enumeration was FUBAR (and we didn't notice)
+		 */
+		dev_info(dev, "Failure: %#llx\n", tmp.value);
+		return -EIO;
+	}
+
+	*value = (tmp.value & 0xffffffff00000000ULL) >> 32;
+
+	return 0;
+}
+
+static int atk_read_value(struct atk_sensor_data *sensor, u64 *value)
+{
+	int err;
+
+	if (!sensor->is_valid ||
+	    time_after(jiffies, sensor->last_updated + CACHE_TIME)) {
+		if (sensor->data->old_interface)
+			err = atk_read_value_old(sensor, value);
+		else
+			err = atk_read_value_new(sensor, value);
+
+		sensor->is_valid = true;
+		sensor->last_updated = jiffies;
+		sensor->cached_value = *value;
+	} else {
+		*value = sensor->cached_value;
+		err = 0;
+	}
+
+	return err;
+}
+
+static int atk_add_sensor(struct atk_data *data, union acpi_object *obj)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *flags;
+	union acpi_object *name;
+	union acpi_object *limit1;
+	union acpi_object *limit2;
+	union acpi_object *enable;
+	struct atk_sensor_data *sensor;
+	char const *base_name;
+	char const *limit1_name;
+	char const *limit2_name;
+	u64 type;
+	int err;
+	int *num;
+	int start;
+
+	if (obj->type != ACPI_TYPE_PACKAGE) {
+		/* wft is this? */
+		dev_warn(dev, "Unknown type for ACPI object: (%d)\n",
+				obj->type);
+		return -EINVAL;
+	}
+
+	err = validate_hwmon_pack(data, obj);
+	if (err)
+		return err;
+
+	/* Ok, we have a valid hwmon package */
+	type = atk_get_pack_member(data, obj, HWMON_PACK_FLAGS)->integer.value & ATK_TYPE_MASK;
+
+	switch (type) {
+	case HWMON_TYPE_VOLT:
+		base_name = "in";
+		limit1_name = "min";
+		limit2_name = "max";
+		num = &data->voltage_count;
+		start = 0;
+		break;
+	case HWMON_TYPE_TEMP:
+		base_name = "temp";
+		limit1_name = "max";
+		limit2_name = "crit";
+		num = &data->temperature_count;
+		start = 1;
+		break;
+	case HWMON_TYPE_FAN:
+		base_name = "fan";
+		limit1_name = "min";
+		limit2_name = "max";
+		num = &data->fan_count;
+		start = 1;
+		break;
+	default:
+		dev_warn(dev, "Unknown sensor type: %#llx\n", type);
+		return -EINVAL;
+	}
+
+	enable = atk_get_pack_member(data, obj, HWMON_PACK_ENABLE);
+	if (!enable->integer.value)
+		/* sensor is disabled */
+		return 0;
+
+	flags = atk_get_pack_member(data, obj, HWMON_PACK_FLAGS);
+	name = atk_get_pack_member(data, obj, HWMON_PACK_NAME);
+	limit1 = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT1);
+	limit2 = atk_get_pack_member(data, obj, HWMON_PACK_LIMIT2);
+
+	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	sensor->acpi_name = kstrdup(name->string.pointer, GFP_KERNEL);
+	if (!sensor->acpi_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&sensor->list);
+	sensor->type = type;
+	sensor->data = data;
+	sensor->id = flags->integer.value;
+	sensor->limit1 = limit1->integer.value;
+	sensor->limit2 = limit2->integer.value;
+
+	snprintf(sensor->input_attr_name, ATTR_NAME_SIZE,
+			"%s%d_input", base_name, start + *num);
+	atk_init_attribute(&sensor->input_attr,
+			sensor->input_attr_name,
+			atk_input_show);
+
+	snprintf(sensor->label_attr_name, ATTR_NAME_SIZE,
+			"%s%d_label", base_name, start + *num);
+	atk_init_attribute(&sensor->label_attr,
+			sensor->label_attr_name,
+			atk_label_show);
+
+	snprintf(sensor->limit1_attr_name, ATTR_NAME_SIZE,
+			"%s%d_%s", base_name, start + *num, limit1_name);
+	atk_init_attribute(&sensor->limit1_attr,
+			sensor->limit1_attr_name,
+			atk_limit1_show);
+
+	snprintf(sensor->limit2_attr_name, ATTR_NAME_SIZE,
+			"%s%d_%s", base_name, start + *num, limit2_name);
+	atk_init_attribute(&sensor->limit2_attr,
+			sensor->limit2_attr_name,
+			atk_limit2_show);
+
+	list_add(&sensor->list, &data->sensor_list);
+	(*num)++;
+
+	return 1;
+out:
+	kfree(sensor->acpi_name);
+	kfree(sensor);
+	return err;
+}
+
+static int atk_enumerate_old_hwmon(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_buffer buf;
+	union acpi_object *pack;
+	acpi_status status;
+	int i, ret;
+	int count = 0;
+
+	/* Voltages */
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	status = acpi_evaluate_object_typed(data->atk_handle,
+			METHOD_OLD_ENUM_VLT, NULL, &buf, ACPI_TYPE_PACKAGE);
+	if (status != AE_OK) {
+		dev_warn(dev, METHOD_OLD_ENUM_VLT ": ACPI exception: %s\n",
+				acpi_format_exception(status));
+
+		return -ENODEV;
+	}
+
+	pack = buf.pointer;
+	for (i = 1; i < pack->package.count; i++) {
+		union acpi_object *obj = &pack->package.elements[i];
+
+		ret = atk_add_sensor(data, obj);
+		if (ret > 0)
+			count++;
+	}
+	ACPI_FREE(buf.pointer);
+
+	/* Temperatures */
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	status = acpi_evaluate_object_typed(data->atk_handle, METHOD_OLD_ENUM_TMP, NULL,
+			&buf, ACPI_TYPE_PACKAGE);
+	if (status != AE_OK) {
+		dev_warn(dev, METHOD_OLD_ENUM_TMP ": ACPI exception: %s\n",
+				acpi_format_exception(status));
+
+		ret = -ENODEV;
+		goto cleanup;
+	}
+
+	pack = buf.pointer;
+	for (i = 1; i < pack->package.count; i++) {
+		union acpi_object *obj = &pack->package.elements[i];
+
+		ret = atk_add_sensor(data, obj);
+		if (ret > 0)
+			count++;
+	}
+	ACPI_FREE(buf.pointer);
+
+	/* Fans */
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	status = acpi_evaluate_object_typed(data->atk_handle, METHOD_OLD_ENUM_FAN, NULL,
+			&buf, ACPI_TYPE_PACKAGE);
+	if (status != AE_OK) {
+		dev_warn(dev, METHOD_OLD_ENUM_FAN ": ACPI exception: %s\n",
+				acpi_format_exception(status));
+
+		ret = -ENODEV;
+		goto cleanup;
+	}
+
+	pack = buf.pointer;
+	for (i = 1; i < pack->package.count; i++) {
+		union acpi_object *obj = &pack->package.elements[i];
+
+		ret = atk_add_sensor(data, obj);
+		if (ret > 0)
+			count++;
+	}
+	ACPI_FREE(buf.pointer);
+
+	return count;
+cleanup:
+	atk_free_sensors(data);
+	return ret;
+}
+
+static int atk_enumerate_new_hwmon(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_buffer buf;
+	acpi_status ret;
+	struct acpi_object_list params;
+	union acpi_object id;
+	union acpi_object *pack;
+	int err;
+	int i;
+
+	dev_dbg(dev, "Enumerating hwmon sensors\n");
+
+	id.type = ACPI_TYPE_INTEGER;
+	id.integer.value = ATK_MUX_HWMON;
+	params.count = 1;
+	params.pointer = &id;
+
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	ret = acpi_evaluate_object_typed(data->enumerate_handle, NULL, &params,
+			&buf, ACPI_TYPE_PACKAGE);
+	if (ret != AE_OK) {
+		dev_warn(dev, METHOD_ENUMERATE ": ACPI exception: %s\n",
+				acpi_format_exception(ret));
+		return -ENODEV;
+	}
+
+	/* Result must be a package */
+	pack = buf.pointer;
+
+	if (pack->package.count < 1) {
+		dev_dbg(dev, "%s: hwmon package is too small: %d\n", __func__,
+				pack->package.count);
+		err = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < pack->package.count; i++) {
+		union acpi_object *obj = &pack->package.elements[i];
+
+		atk_add_sensor(data, obj);
+	}
+
+	err = data->voltage_count + data->temperature_count + data->fan_count;
+
+out:
+	ACPI_FREE(buf.pointer);
+	return err;
+}
+
+static int atk_create_files(struct atk_data *data)
+{
+	struct atk_sensor_data *s;
+	int err;
+
+	list_for_each_entry(s, &data->sensor_list, list) {
+		err = device_create_file(data->hwmon_dev, &s->input_attr);
+		if (err)
+			return err;
+		err = device_create_file(data->hwmon_dev, &s->label_attr);
+		if (err)
+			return err;
+		err = device_create_file(data->hwmon_dev, &s->limit1_attr);
+		if (err)
+			return err;
+		err = device_create_file(data->hwmon_dev, &s->limit2_attr);
+		if (err)
+			return err;
+	}
+
+	err = device_create_file(data->hwmon_dev, &atk_name_attr);
+
+	return err;
+}
+
+static void atk_remove_files(struct atk_data *data)
+{
+	struct atk_sensor_data *s;
+
+	list_for_each_entry(s, &data->sensor_list, list) {
+		device_remove_file(data->hwmon_dev, &s->input_attr);
+		device_remove_file(data->hwmon_dev, &s->label_attr);
+		device_remove_file(data->hwmon_dev, &s->limit1_attr);
+		device_remove_file(data->hwmon_dev, &s->limit2_attr);
+	}
+	device_remove_file(data->hwmon_dev, &atk_name_attr);
+}
+
+static void atk_free_sensors(struct atk_data *data)
+{
+	struct list_head *head = &data->sensor_list;
+	struct atk_sensor_data *s, *tmp;
+
+	list_for_each_entry_safe(s, tmp, head, list) {
+		kfree(s->acpi_name);
+		kfree(s);
+	}
+}
+
+static int atk_register_hwmon(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	int err;
+
+	dev_dbg(dev, "registering hwmon device\n");
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
+
+	dev_dbg(dev, "populating sysfs directory\n");
+	err = atk_create_files(data);
+	if (err)
+		goto remove;
+
+	return 0;
+remove:
+	/* Cleanup the registered files */
+	atk_remove_files(data);
+	hwmon_device_unregister(data->hwmon_dev);
+	return err;
+}
+
+static int atk_check_old_if(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	acpi_handle ret;
+	acpi_status status;
+
+	/* RTMP: read temperature */
+	status = acpi_get_handle(data->atk_handle, METHOD_OLD_READ_TMP, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_OLD_READ_TMP " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->rtmp_handle = ret;
+
+	/* RVLT: read voltage */
+	status = acpi_get_handle(data->atk_handle, METHOD_OLD_READ_VLT, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_OLD_READ_VLT " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->rvlt_handle = ret;
+
+	/* RFAN: read fan status */
+	status = acpi_get_handle(data->atk_handle, METHOD_OLD_READ_FAN, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_OLD_READ_FAN " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->rfan_handle = ret;
+
+	return 0;
+}
+
+static int atk_check_new_if(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	acpi_handle ret;
+	acpi_status status;
+
+	/* Enumeration */
+	status = acpi_get_handle(data->atk_handle, METHOD_ENUMERATE, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_ENUMERATE " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->enumerate_handle = ret;
+
+	/* De-multiplexer (read) */
+	status = acpi_get_handle(data->atk_handle, METHOD_READ, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_READ " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->read_handle = ret;
+
+	return 0;
+}
+
+static int atk_add(struct acpi_device *device)
+{
+	acpi_status ret;
+	int err;
+	struct acpi_buffer buf;
+	union acpi_object *obj;
+	struct atk_data *data;
+
+	dev_dbg(&device->dev, "adding...\n");
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->acpi_dev = device;
+	data->atk_handle = device->handle;
+	INIT_LIST_HEAD(&data->sensor_list);
+
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	ret = acpi_evaluate_object_typed(data->atk_handle, BOARD_ID, NULL,
+			&buf, ACPI_TYPE_PACKAGE);
+	if (ret != AE_OK) {
+		dev_dbg(&device->dev, "atk: method MBIF not found\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	obj = buf.pointer;
+	if (obj->package.count >= 2 &&
+			obj->package.elements[1].type == ACPI_TYPE_STRING) {
+		dev_dbg(&device->dev, "board ID = %s\n",
+				obj->package.elements[1].string.pointer);
+	}
+	ACPI_FREE(buf.pointer);
+
+	/* Check for hwmon methods: first check "old" style methods; note that
+	 * both may be present: in this case we stick to the old interface;
+	 * analysis of multiple DSDTs indicates that when both interfaces
+	 * are present the new one (GGRP/GITM) is not functional.
+	 */
+	err = atk_check_old_if(data);
+	if (!err) {
+		dev_dbg(&device->dev, "Using old hwmon interface\n");
+		data->old_interface = true;
+	} else {
+		err = atk_check_new_if(data);
+		if (err)
+			goto out;
+
+		dev_dbg(&device->dev, "Using new hwmon interface\n");
+		data->old_interface = false;
+	}
+
+	if (data->old_interface)
+		err = atk_enumerate_old_hwmon(data);
+	else
+		err = atk_enumerate_new_hwmon(data);
+	if (err < 0)
+		goto out;
+	if (err == 0) {
+		dev_info(&device->dev, "No usable sensor detected, bailing out\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = atk_register_hwmon(data);
+	if (err)
+		goto cleanup;
+
+	device->driver_data = data;
+	return 0;
+cleanup:
+	atk_free_sensors(data);
+out:
+	kfree(data);
+	return err;
+}
+
+static int atk_remove(struct acpi_device *device, int type)
+{
+	struct atk_data *data = device->driver_data;
+	dev_dbg(&device->dev, "removing...\n");
+
+	device->driver_data = NULL;
+
+	atk_remove_files(data);
+	atk_free_sensors(data);
+	hwmon_device_unregister(data->hwmon_dev);
+
+	kfree(data);
+
+	return 0;
+}
+
+static int atk0110_init(void)
+{
+	int ret;
+
+	ret = acpi_bus_register_driver(&atk_driver);
+	if (ret)
+		pr_info("atk: acpi_bus_register_driver failed: %d\n", ret);
+
+	return ret;
+}
+
+static void atk0110_exit(void)
+{
+	acpi_bus_unregister_driver(&atk_driver);
+}
+
+module_init(atk0110_init);
+module_exit(atk0110_exit);
+
+MODULE_LICENSE("GPL");
Index: b/drivers/hwmon/Kconfig
===================================================================
--- a/drivers/hwmon/Kconfig	2009-01-17 18:38:22.662881222 +0100
+++ b/drivers/hwmon/Kconfig	2009-01-17 19:05:14.926881425 +0100
@@ -248,6 +248,18 @@
 	  This driver can also be built as a module.  If so, the module
 	  will be called asb100.
 
+config SENSORS_ATK0110
+	tristate "ASUS ATK0110 ACPI hwmon"
+	depends on X86 && ACPI && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the ACPI hardware
+	  monitoring interface found in many ASUS motherboards. This
+	  driver will provide readings of fans, voltages and temperatures
+	  through the system firmware.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called asus_atk0110.
+
 config SENSORS_ATXP1
 	tristate "Attansic ATXP1 VID controller"
 	depends on I2C && EXPERIMENTAL
Index: b/drivers/hwmon/Makefile
===================================================================
--- a/drivers/hwmon/Makefile	2009-01-17 18:38:22.662881222 +0100
+++ b/drivers/hwmon/Makefile	2009-01-17 19:05:14.926881425 +0100
@@ -32,6 +32,7 @@
 
 obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
 obj-$(CONFIG_SENSORS_AMS)	+= ams/
+obj-$(CONFIG_SENSORS_ATK0110)	+= asus_atk0110.o
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
Index: b/drivers/acpi/acpica/nsxfeval.c
===================================================================
--- a/drivers/acpi/acpica/nsxfeval.c	2009-01-17 19:08:20.034881950 +0100
+++ b/drivers/acpi/acpica/nsxfeval.c	2009-01-17 19:08:23.694882707 +0100
@@ -53,7 +53,6 @@
 /* Local prototypes */
 static void acpi_ns_resolve_references(struct acpi_evaluate_info *info);
 
-#ifdef ACPI_FUTURE_USAGE
 /*******************************************************************************
  *
  * FUNCTION:    acpi_evaluate_object_typed
@@ -147,7 +146,7 @@
 }
 
 ACPI_EXPORT_SYMBOL(acpi_evaluate_object_typed)
-#endif				/*  ACPI_FUTURE_USAGE  */
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_evaluate_object

Luca
-- 
Ligabue canta: "Tutti vogliono viaggiare in primaaaa..."
Io ci ho provato e dopo un chilometro ho fuso il motore e bruciato
la frizione...
