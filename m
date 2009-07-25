Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZGYAgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZGYAgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 20:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZGYAgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 20:36:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35192 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZGYAgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 20:36:01 -0400
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] acpi_power_meter: hwmon driver for ACPI 4.0 power meters
To: "Darrick J. Wong" <djwong@us.ibm.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Date: Fri, 24 Jul 2009 17:43:35 -0700
Message-ID: <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com>
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver exposes ACPI 4.0 compliant power meters as hardware monitoring
devices.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 Documentation/hwmon/acpi_power_meter |   25 +
 drivers/acpi/Kconfig                 |   12 +
 drivers/acpi/Makefile                |    1 
 drivers/acpi/power_meter.c           |  776 ++++++++++++++++++++++++++++++++++
 4 files changed, 814 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/acpi_power_meter
 create mode 100644 drivers/acpi/power_meter.c


diff --git a/Documentation/hwmon/acpi_power_meter b/Documentation/hwmon/acpi_power_meter
new file mode 100644
index 0000000..0af2e9a
--- /dev/null
+++ b/Documentation/hwmon/acpi_power_meter
@@ -0,0 +1,25 @@
+Kernel driver power_meter
+=========================
+
+This driver talks to ACPI 4.0 power meters.
+
+Supported systems:
+  * Any recent system with ACPI 4.0.
+    Prefix: 'power_meter'
+    Datasheet: http://acpi.info/, section 10.4.
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements sensor reading support for the power meters exposed in
+the ACPI 4.0 spec (Chapter 10.4).  These devices have a simple set of
+features--a power meter that returns average power use over a configurable
+interval, an optional capping mechanism, and a couple of trip points.
+
+Special Features
+----------------
+
+The power[1-*]_is_battery knob indicates if the power supply is a battery.
+Both power[1-*]_average_{min,max} must be set before the trip points will work.
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7ec7d88..8ac801d 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -82,6 +82,18 @@ config ACPI_PROCFS_POWER
 
 	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
 
+config ACPI_POWER_METER
+	tristate "ACPI 4.0 power meter"
+	depends on HWMON
+	default m
+	help
+	  This driver exposes ACPI 4.0 power meters as hardware monitoring
+	  devices.  Say Y (or M) if you have an Intel or AMD computer with
+	  a power meter.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called power-meter.
+
 config ACPI_SYSFS_POWER
 	bool "Future power /sys interface"
 	select POWER_SUPPLY
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 03a985b..82cd49d 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
+obj-$(CONFIG_ACPI_POWER_METER)	+= power_meter.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_core.o processor_throttling.o
diff --git a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
new file mode 100644
index 0000000..9418bbd
--- /dev/null
+++ b/drivers/acpi/power_meter.c
@@ -0,0 +1,776 @@
+/*
+ * A hwmon driver for ACPI 4.0 power meters
+ * Copyright (C) 2009 IBM
+ *
+ * Author: Darrick J. Wong <djwong@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/kdev_t.h>
+#include <linux/sched.h>
+#include <linux/time.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
+
+#define ACPI_POWER_METER_NAME		"power_meter"
+ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
+#define ACPI_POWER_METER_DEVICE_NAME	"Power Meter"
+#define ACPI_POWER_METER_CLASS		"power_meter_resource"
+
+#define NUM_SENSORS			14
+
+#define POWER_METER_CAN_MEASURE	(1 << 0)
+#define POWER_METER_CAN_TRIP	(1 << 1)
+#define POWER_METER_CAN_CAP	(1 << 2)
+#define POWER_METER_CAN_NOTIFY	(1 << 3)
+#define POWER_METER_IS_BATTERY	(1 << 8)
+#define UNKNOWN_HYSTERESIS	0xFFFFFFFF
+
+#define METER_NOTIFY_CONFIG	0x80
+#define METER_NOTIFY_TRIP	0x81
+#define METER_NOTIFY_CAP	0x82
+#define METER_NOTIFY_CAPPING	0x83
+#define METER_NOTIFY_INTERVAL	0x84
+
+static struct acpi_device_id power_meter_ids[] = {
+	{"ACPI000D", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, power_meter_ids);
+
+struct acpi_power_meter_capabilities {
+	acpi_integer		flags;
+	acpi_integer		units;
+	acpi_integer		type;
+	acpi_integer		accuracy;
+	acpi_integer		sampling_time;
+	acpi_integer		min_avg_interval;
+	acpi_integer		max_avg_interval;
+	acpi_integer		hysteresis;
+	acpi_integer		configurable_cap;
+	acpi_integer		min_cap;
+	acpi_integer		max_cap;
+};
+
+struct acpi_power_meter_resource {
+	struct acpi_device	*acpi_dev;
+	acpi_bus_id		name;
+	struct mutex		lock;
+	struct device		*hwmon_dev;
+	struct acpi_power_meter_capabilities	caps;
+	acpi_integer		power;
+	acpi_integer		cap;
+	acpi_integer		avg_interval;
+	int			sensors_valid;
+	unsigned long		sensors_last_updated;
+	struct sensor_device_attribute	sensors[NUM_SENSORS];
+	int			num_sensors;
+	int			trip[2];
+};
+
+struct ro_sensor_template {
+	char *label;
+	ssize_t (*show)(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf);
+	int index;
+};
+
+struct rw_sensor_template {
+	char *label;
+	ssize_t (*show)(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf);
+	ssize_t (*set)(struct device *dev,
+		       struct device_attribute *devattr,
+		       const char *buf, size_t count);
+	int index;
+};
+
+/* Averaging interval */
+static int update_avg_interval(struct acpi_power_meter_resource *resource)
+{
+	unsigned long long data;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_GAI",
+				       NULL, &data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _GAI"));
+		return -ENODEV;
+	}
+
+	resource->avg_interval = data;
+	return 0;
+}
+
+static ssize_t show_avg_interval(struct device *dev,
+				 struct device_attribute *devattr,
+				 char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+
+	mutex_lock(&resource->lock);
+	update_avg_interval(resource);
+	mutex_unlock(&resource->lock);
+
+	return sprintf(buf, "%llu\n", resource->avg_interval);
+}
+
+static ssize_t set_avg_interval(struct device *dev,
+				struct device_attribute *devattr,
+				const char *buf, size_t count)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+	int res;
+	unsigned long temp;
+	unsigned long long data;
+	acpi_status status;
+
+	res = strict_strtoul(buf, 10, &temp);
+	if (res)
+		return res;
+
+	if (temp > resource->caps.max_avg_interval ||
+	    temp < resource->caps.min_avg_interval)
+		return -EINVAL;
+	arg0.integer.value = temp;
+
+	mutex_lock(&resource->lock);
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_PAI",
+				       &args, &data);
+	if (!ACPI_FAILURE(status))
+		resource->avg_interval = temp;
+	mutex_unlock(&resource->lock);
+
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PAI"));
+		return -EINVAL;
+	}
+
+	if (data)
+		return -EINVAL;
+
+	return count;
+}
+
+/* Cap functions */
+static int update_cap(struct acpi_power_meter_resource *resource)
+{
+	unsigned long long data;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_GHL",
+				       NULL, &data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _GHL"));
+		return -ENODEV;
+	}
+
+	resource->cap = data;
+	return 0;
+}
+
+static ssize_t show_cap(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+
+	mutex_lock(&resource->lock);
+	update_cap(resource);
+	mutex_unlock(&resource->lock);
+
+	return sprintf(buf, "%llu\n", resource->cap * 1000);
+}
+
+static ssize_t set_cap(struct device *dev, struct device_attribute *devattr,
+		       const char *buf, size_t count)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+	int res;
+	unsigned long temp;
+	unsigned long long data;
+	acpi_status status;
+
+	res = strict_strtoul(buf, 10, &temp);
+	if (res)
+		return res;
+
+	temp /= 1000;
+	if (temp > resource->caps.max_cap || temp < resource->caps.min_cap)
+		return -EINVAL;
+	arg0.integer.value = temp;
+
+	mutex_lock(&resource->lock);
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_SHL",
+				       &args, &data);
+	if (!ACPI_FAILURE(status))
+		resource->cap = temp;
+	mutex_unlock(&resource->lock);
+
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _SHL"));
+		return -EINVAL;
+	}
+
+	if (data)
+		return -EINVAL;
+
+	return count;
+}
+
+/* Power meter trip points */
+static int set_acpi_trip(struct acpi_power_meter_resource *resource)
+{
+	union acpi_object arg_objs[] = {
+		{ACPI_TYPE_INTEGER},
+		{ACPI_TYPE_INTEGER}
+	};
+	struct acpi_object_list args = { 2, arg_objs };
+	unsigned long long data;
+	acpi_status status;
+
+	/* Both trip levels must be set */
+	if (resource->trip[0] < 0 || resource->trip[1] < 0)
+		return 0;
+
+	/* This driver stores min, max; ACPI wants max, min. */
+	arg_objs[0].integer.value = resource->trip[1];
+	arg_objs[1].integer.value = resource->trip[0];
+
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_PTP",
+				       &args, &data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PTP"));
+		return -EINVAL;
+	}
+
+	return data;
+}
+
+static ssize_t set_trip(struct device *dev, struct device_attribute *devattr,
+			const char *buf, size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+	int res;
+	unsigned long temp;
+
+	res = strict_strtoul(buf, 10, &temp);
+	if (res)
+		return res;
+
+	temp /= 1000;
+	if (temp < 0)
+		return -EINVAL;
+
+	mutex_lock(&resource->lock);
+	resource->trip[attr->index - 7] = temp;
+	res = set_acpi_trip(resource);
+	mutex_unlock(&resource->lock);
+
+	if (res)
+		return res;
+
+	return count;
+}
+
+/* Power meter */
+static int update_meter(struct acpi_power_meter_resource *resource)
+{
+	unsigned long long data;
+	acpi_status status;
+	unsigned long local_jiffies = jiffies;
+
+	if (time_before(local_jiffies, resource->sensors_last_updated +
+			msecs_to_jiffies(resource->caps.sampling_time)) &&
+			resource->sensors_valid)
+		return 0;
+
+	status = acpi_evaluate_integer(resource->acpi_dev->handle, "_PMM",
+				       NULL, &data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PMM"));
+		return -ENODEV;
+	}
+
+	resource->power = data;
+	resource->sensors_valid = 1;
+	resource->sensors_last_updated = jiffies;
+	return 0;
+}
+
+static ssize_t show_power(struct device *dev,
+			  struct device_attribute *devattr,
+			  char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+
+	mutex_lock(&resource->lock);
+	update_meter(resource);
+	mutex_unlock(&resource->lock);
+
+	return sprintf(buf, "%llu\n", resource->power * 1000);
+}
+
+/* Miscellaneous */
+static ssize_t show_val(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+	acpi_integer val = 0;
+
+	switch (attr->index) {
+	case 0:
+		val = resource->caps.min_avg_interval;
+		break;
+	case 1:
+		val = resource->caps.max_avg_interval;
+		break;
+	case 2:
+		val = resource->caps.min_cap * 1000;
+		break;
+	case 3:
+		val = resource->caps.max_cap * 1000;
+		break;
+	case 4:
+		if (resource->caps.hysteresis == UNKNOWN_HYSTERESIS)
+			return sprintf(buf, "unknown\n");
+
+		val = resource->caps.hysteresis * 1000;
+		break;
+	case 5:
+		if (resource->caps.flags & POWER_METER_IS_BATTERY)
+			val = 1;
+		else
+			val = 0;
+		break;
+	case 6:
+		if (resource->power > resource->cap)
+			val = 1;
+		else
+			val = 0;
+		break;
+	case 7:
+	case 8:
+		if (resource->trip[attr->index - 7] < 0)
+			return sprintf(buf, "unknown\n");
+
+		val = resource->trip[attr->index - 7] * 1000;
+		break;
+	default:
+		BUG();
+	}
+
+	return sprintf(buf, "%llu\n", val);
+}
+
+static ssize_t show_accuracy(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_power_meter_resource *resource = acpi_dev->driver_data;
+	unsigned int acc = resource->caps.accuracy;
+
+	return sprintf(buf, "%u.%u%%\n", acc / 1000, acc % 1000);
+}
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *devattr,
+			 char *buf)
+{
+	return sprintf(buf, "%s\n", ACPI_POWER_METER_NAME);
+}
+
+/* Sensor descriptions.  If you add a sensor, update NUM_SENSORS above! */
+static struct ro_sensor_template meter_ro_attrs[] = {
+{"power1_average", show_power, 0},
+{"power1_accuracy", show_accuracy, 0},
+{"power1_average_interval_min", show_val, 0},
+{"power1_average_interval_max", show_val, 1},
+{"power1_is_battery", show_val, 5},
+{NULL, NULL, 0},
+};
+
+static struct rw_sensor_template meter_rw_attrs[] = {
+{"power1_average_interval", show_avg_interval, set_avg_interval, 0},
+{NULL, NULL, NULL, 0},
+};
+
+static struct ro_sensor_template misc_cap_attrs[] = {
+{"power1_cap_min", show_val, 2},
+{"power1_cap_max", show_val, 3},
+{"power1_cap_hyst", show_val, 4},
+{"power1_alarm", show_val, 6},
+{NULL, NULL, 0},
+};
+
+static struct ro_sensor_template ro_cap_attrs[] = {
+{"power1_cap", show_cap, 0},
+{NULL, NULL, 0},
+};
+
+static struct rw_sensor_template rw_cap_attrs[] = {
+{"power1_cap", show_cap, set_cap, 0},
+{NULL, NULL, NULL, 0},
+};
+
+static struct rw_sensor_template trip_attrs[] = {
+{"power1_average_min", show_val, set_trip, 7},
+{"power1_average_max", show_val, set_trip, 8},
+{NULL, NULL, NULL, 0},
+};
+
+static struct ro_sensor_template misc_attrs[] = {
+{"name", show_name, 0},
+{NULL, NULL, 0},
+};
+
+/* Registration and deregistration */
+static int register_ro_attrs(struct acpi_power_meter_resource *resource,
+			     struct ro_sensor_template *ro)
+{
+	struct device *dev = &resource->acpi_dev->dev;
+	struct sensor_device_attribute *sensors =
+		&resource->sensors[resource->num_sensors];
+	int res;
+
+	while (ro->label) {
+		sensors->dev_attr.attr.name = ro->label;
+		sensors->dev_attr.attr.mode = S_IRUGO;
+		sensors->dev_attr.show = ro->show;
+		sensors->index = ro->index;
+
+		res = device_create_file(dev, &sensors->dev_attr);
+		if (res) {
+			sensors->dev_attr.attr.name = NULL;
+			goto error;
+		}
+		sensors++;
+		resource->num_sensors++;
+		ro++;
+	}
+
+error:
+	return res;
+}
+
+static int register_rw_attrs(struct acpi_power_meter_resource *resource,
+			     struct rw_sensor_template *rw)
+{
+	struct device *dev = &resource->acpi_dev->dev;
+	struct sensor_device_attribute *sensors =
+		&resource->sensors[resource->num_sensors];
+	int res;
+
+	while (rw->label) {
+		sensors->dev_attr.attr.name = rw->label;
+		sensors->dev_attr.attr.mode = S_IRUGO | S_IWUSR;
+		sensors->dev_attr.show = rw->show;
+		sensors->dev_attr.store = rw->set;
+		sensors->index = rw->index;
+
+		res = device_create_file(dev, &sensors->dev_attr);
+		if (res) {
+			sensors->dev_attr.attr.name = NULL;
+			goto error;
+		}
+		sensors++;
+		resource->num_sensors++;
+		rw++;
+	}
+
+error:
+	return res;
+}
+
+static void remove_attrs(struct acpi_power_meter_resource *resource)
+{
+	int i;
+
+	for (i = 0; i < resource->num_sensors; i++) {
+		if (!resource->sensors[i].dev_attr.attr.name)
+			continue;
+		device_remove_file(&resource->acpi_dev->dev,
+				   &resource->sensors[i].dev_attr);
+	}
+
+	resource->num_sensors = 0;
+}
+
+static int setup_attrs(struct acpi_power_meter_resource *resource)
+{
+	int res = 0;
+
+	if (resource->caps.flags & POWER_METER_CAN_MEASURE) {
+		res = register_ro_attrs(resource, meter_ro_attrs);
+		if (res)
+			goto error;
+		res = register_rw_attrs(resource, meter_rw_attrs);
+		if (res)
+			goto error;
+	}
+
+	if (resource->caps.flags & POWER_METER_CAN_CAP) {
+		if (resource->caps.configurable_cap) {
+			res = register_rw_attrs(resource, rw_cap_attrs);
+			if (res)
+				goto error;
+		} else {
+			res = register_ro_attrs(resource, ro_cap_attrs);
+			if (res)
+				goto error;
+		}
+		res = register_ro_attrs(resource, misc_cap_attrs);
+		if (res)
+			goto error;
+	}
+
+	if (resource->caps.flags & POWER_METER_CAN_TRIP) {
+		res = register_rw_attrs(resource, trip_attrs);
+		if (res)
+			goto error;
+	}
+
+	res = register_ro_attrs(resource, misc_attrs);
+	if (res)
+		goto error;
+
+	return res;
+error:
+	remove_attrs(resource);
+	return res;
+}
+
+static int read_capabilities(struct acpi_power_meter_resource *resource)
+{
+	int res = 0;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer state = { 0, NULL };
+	struct acpi_buffer format = { sizeof("NNNNNNNNNNN"), "NNNNNNNNNNN" };
+	union acpi_object *pss;
+	acpi_status status;
+
+	status = acpi_evaluate_object(resource->acpi_dev->handle, "_PMC", NULL,
+				      &buffer);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PMC"));
+		return -ENODEV;
+	}
+
+	pss = buffer.pointer;
+	if (!pss ||
+	    pss->type != ACPI_TYPE_PACKAGE ||
+	    pss->package.count != 14) {
+		dev_err(&resource->acpi_dev->dev, PREFIX "Invalid _PMC data\n");
+		res = -EFAULT;
+		goto end;
+	}
+
+	state.length = sizeof(struct acpi_power_meter_capabilities);
+	state.pointer = &resource->caps;
+
+	status = acpi_extract_package(pss, &format, &state);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Invalid data"));
+		res = -EFAULT;
+		goto end;
+	}
+
+	if (resource->caps.units) {
+		dev_err(&resource->acpi_dev->dev, PREFIX "Unknown unit %llu.\n",
+			resource->caps.units);
+		res = -EINVAL;
+		goto end;
+	}
+
+	dev_info(&resource->acpi_dev->dev, "Found ACPI power meter.\n");
+end:
+	kfree(buffer.pointer);
+	return res;
+}
+
+/* Handle ACPI event notifications */
+static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
+{
+	struct acpi_power_meter_resource *resource;
+	int res;
+
+	if (!device || !acpi_driver_data(device))
+		return;
+
+	resource = acpi_driver_data(device);
+
+	mutex_lock(&resource->lock);
+	switch (event) {
+	case METER_NOTIFY_CONFIG:
+		res = read_capabilities(resource);
+		if (res)
+			break;
+
+		remove_attrs(resource);
+		setup_attrs(resource);
+		break;
+	case METER_NOTIFY_TRIP:
+		update_meter(resource);
+		break;
+	case METER_NOTIFY_CAP:
+		update_cap(resource);
+		break;
+	case METER_NOTIFY_INTERVAL:
+		update_avg_interval(resource);
+		break;
+	case METER_NOTIFY_CAPPING:
+		dev_info(&device->dev, "Capping in progress.\n");
+		break;
+	default:
+		BUG();
+	}
+	mutex_unlock(&resource->lock);
+}
+
+static int acpi_power_meter_add(struct acpi_device *device)
+{
+	int res;
+	struct acpi_power_meter_resource *resource;
+
+	if (!device)
+		return -EINVAL;
+
+	resource = kzalloc(sizeof(struct acpi_power_meter_resource),
+			   GFP_KERNEL);
+	if (!resource)
+		return -ENOMEM;
+
+	resource->sensors_valid = 0;
+	resource->acpi_dev = device;
+	mutex_init(&resource->lock);
+	strcpy(acpi_device_name(device), ACPI_POWER_METER_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);
+	device->driver_data = resource;
+
+	res = read_capabilities(resource);
+	if (res)
+		goto exit_free;
+
+	resource->trip[0] = resource->trip[1] = -1;
+
+	res = setup_attrs(resource);
+	if (res)
+		goto exit_free;
+
+	resource->hwmon_dev = hwmon_device_register(&device->dev);
+	if (IS_ERR(resource->hwmon_dev)) {
+		res = PTR_ERR(resource->hwmon_dev);
+		goto exit_remove;
+	}
+
+	res = 0;
+	goto exit;
+
+exit_remove:
+	remove_attrs(resource);
+exit_free:
+	kfree(resource);
+exit:
+	return res;
+}
+
+static int acpi_power_meter_remove(struct acpi_device *device, int type)
+{
+	struct acpi_power_meter_resource *resource;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	resource = acpi_driver_data(device);
+	hwmon_device_unregister(resource->hwmon_dev);
+
+	remove_attrs(resource);
+
+	kfree(resource);
+	return 0;
+}
+
+static int acpi_power_meter_resume(struct acpi_device *device)
+{
+	struct acpi_power_meter_resource *resource;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	resource = acpi_driver_data(device);
+	read_capabilities(resource);
+
+	return 0;
+}
+
+static struct acpi_driver acpi_power_meter_driver = {
+	.name = "power_meter",
+	.class = ACPI_POWER_METER_CLASS,
+	.ids = power_meter_ids,
+	.ops = {
+		.add = acpi_power_meter_add,
+		.remove = acpi_power_meter_remove,
+		.resume = acpi_power_meter_resume,
+		.notify = acpi_power_meter_notify,
+		},
+};
+
+/* Module init/exit routines */
+
+static int __init acpi_power_meter_init(void)
+{
+	int result;
+
+	result = acpi_bus_register_driver(&acpi_power_meter_driver);
+	if (result < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit acpi_power_meter_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_power_meter_driver);
+}
+
+MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("ACPI 4.0 power meter driver");
+MODULE_LICENSE("GPL");
+
+module_init(acpi_power_meter_init);
+module_exit(acpi_power_meter_exit);

