Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYAQHqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYAQHqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYAQHpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:45:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:52759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYAQHpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:45:49 -0500
X-ExtLoop1: 1
Subject: [PATCH 1/10] the generic thermal sysfs driver
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:08 +0800
Message-Id: <1200556268.2935.116.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

The Generic Thermal sysfs driver for thermal management.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 Documentation/thermal/sysfs-api.txt |  247 ++++++++++++
 drivers/Kconfig                     |    2 
 drivers/Makefile                    |    1 
 drivers/thermal/Kconfig             |   16 
 drivers/thermal/Makefile            |    6 
 drivers/thermal/thermal.c           |  714 ++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h             |   90 ++++
 7 files changed, 1076 insertions(+)

Index: linux-2.6/drivers/thermal/thermal.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/thermal/thermal.c
@@ -0,0 +1,714 @@
+/*
+ *  thermal.c - Generic Thermal Management Sysfs support.
+ *
+ *  Copyright (C) 2008 Intel Corp
+ *  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
+ *  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kdev_t.h>
+#include <linux/idr.h>
+#include <linux/thermal.h>
+#include <linux/spinlock.h>
+
+MODULE_AUTHOR("Zhang Rui")
+MODULE_DESCRIPTION("Generic thermal management sysfs support");
+MODULE_LICENSE("GPL");
+
+#define PREFIX "Thermal: "
+
+struct thermal_cooling_device_instance {
+	int id;
+	char name[THERMAL_NAME_LENGTH];
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+	int trip;
+	char attr_name[THERMAL_NAME_LENGTH];
+	struct device_attribute attr;
+	struct list_head node;
+};
+
+static DEFINE_IDR(thermal_tz_idr);
+static DEFINE_IDR(thermal_cdev_idr);
+static DEFINE_MUTEX(thermal_idr_lock);
+
+static LIST_HEAD(thermal_tz_list);
+static LIST_HEAD(thermal_cdev_list);
+static DEFINE_MUTEX(thermal_list_lock);
+
+static int get_idr(struct idr *idr, struct mutex *lock, int *id)
+{
+	int err;
+
+      again:
+	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	if (lock)
+		mutex_lock(lock);
+	err = idr_get_new(idr, NULL, id);
+	if (lock)
+		mutex_unlock(lock);
+	if (unlikely(err == -EAGAIN))
+		goto again;
+	else if (unlikely(err))
+		return err;
+
+	*id = *id & MAX_ID_MASK;
+	return 0;
+}
+
+static void release_idr(struct idr *idr, struct mutex *lock, int id)
+{
+	if (lock)
+		mutex_lock(lock);
+	idr_remove(idr, id);
+	if (lock)
+		mutex_unlock(lock);
+}
+
+/* sys I/F for thermal zone */
+
+#define to_thermal_zone(_dev) \
+	container_of(_dev, struct thermal_zone_device, device)
+
+static ssize_t
+type_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+
+	return sprintf(buf, "%s\n", tz->type);
+}
+
+static ssize_t
+temp_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+
+	if (!tz->ops->get_temp)
+		return -EPERM;
+
+	return tz->ops->get_temp(tz, buf);
+}
+
+static ssize_t
+mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+
+	if (!tz->ops->get_mode)
+		return -EPERM;
+
+	return tz->ops->get_mode(tz, buf);
+}
+
+static ssize_t
+mode_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int result;
+
+	if (!tz->ops->set_mode)
+		return -EPERM;
+
+	result = tz->ops->set_mode(tz, buf);
+	if (result)
+		return result;
+
+	return count;
+}
+
+static ssize_t
+trip_point_type_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int trip;
+
+	if (!tz->ops->get_trip_type)
+		return -EPERM;
+
+	if (!sscanf(attr->attr.name, "trip_point_%d_type", &trip))
+		return -EINVAL;
+
+	return tz->ops->get_trip_type(tz, trip, buf);
+}
+
+static ssize_t
+trip_point_temp_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int trip;
+
+	if (!tz->ops->get_trip_temp)
+		return -EPERM;
+
+	if (!sscanf(attr->attr.name, "trip_point_%d_temp", &trip))
+		return -EINVAL;
+
+	return tz->ops->get_trip_temp(tz, trip, buf);
+}
+
+static DEVICE_ATTR(type, 0444, type_show, NULL);
+static DEVICE_ATTR(temp, 0444, temp_show, NULL);
+static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
+
+static struct device_attribute trip_point_attrs[] = {
+	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_0_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_1_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_1_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_2_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_2_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_3_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_3_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_4_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_4_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_5_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_5_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_6_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_6_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_7_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_7_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_8_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_8_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_9_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_9_temp, 0444, trip_point_temp_show, NULL),
+};
+
+#define TRIP_POINT_ATTR_ADD(_dev, _index, result)     \
+do {    \
+	result = device_create_file(_dev,	\
+				&trip_point_attrs[_index * 2]);	\
+	if (result)	\
+		break;	\
+	result = device_create_file(_dev,	\
+			&trip_point_attrs[_index * 2 + 1]);	\
+} while (0)
+
+#define TRIP_POINT_ATTR_REMOVE(_dev, _index)	\
+do {	\
+	device_remove_file(_dev, &trip_point_attrs[_index * 2]);	\
+	device_remove_file(_dev, &trip_point_attrs[_index * 2 + 1]);	\
+} while (0)
+
+/* sys I/F for cooling device */
+#define to_cooling_device(_dev)	\
+	container_of(_dev, struct thermal_cooling_device, device)
+
+static ssize_t
+thermal_cooling_device_type_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+
+	return sprintf(buf, "%s\n", cdev->type);
+}
+
+static ssize_t
+thermal_cooling_device_max_state_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+
+	return cdev->ops->get_max_state(cdev, buf);
+}
+
+static ssize_t
+thermal_cooling_device_cur_state_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+
+	return cdev->ops->get_cur_state(cdev, buf);
+}
+
+static ssize_t
+thermal_cooling_device_cur_state_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	int state;
+	int result;
+
+	if (!sscanf(buf, "%d\n", &state))
+		return -EINVAL;
+
+	if (state < 0)
+		return -EINVAL;
+
+	result = cdev->ops->set_cur_state(cdev, state);
+	if (result)
+		return result;
+	return count;
+}
+
+static struct device_attribute dev_attr_cdev_type =
+		__ATTR(type, 0444, thermal_cooling_device_type_show, NULL);
+static DEVICE_ATTR(max_state, 0444,
+		   thermal_cooling_device_max_state_show, NULL);
+static DEVICE_ATTR(cur_state, 0644,
+		   thermal_cooling_device_cur_state_show,
+		   thermal_cooling_device_cur_state_store);
+
+static ssize_t
+thermal_cooling_device_trip_point_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device_instance *instance;
+
+	instance =
+	    container_of(attr, struct thermal_cooling_device_instance, attr);
+
+	if (instance->trip == THERMAL_TRIPS_NONE)
+		return sprintf(buf, "-1\n");
+	else
+		return sprintf(buf, "%d\n", instance->trip);
+}
+
+/* Device management */
+
+/**
+ * thermal_zone_bind_cooling_device - bind a cooling device to a thermal zone
+ * this function is usually called in the thermal zone device .bind callback.
+ * @tz:		thermal zone device
+ * @trip:	indicates which trip point the cooling devices is
+ *		associated with in this thermal zone.
+ * @cdev:	thermal cooling device
+ */
+int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
+				     int trip,
+				     struct thermal_cooling_device *cdev)
+{
+	struct thermal_cooling_device_instance *dev;
+	struct thermal_cooling_device_instance *pos;
+	int result;
+
+	if (trip >= tz->trips ||
+	    (trip < 0 && trip != THERMAL_TRIPS_NONE))
+		return -EINVAL;
+
+	if (!tz || !cdev)
+		return -EINVAL;
+
+	dev =
+	    kzalloc(sizeof(struct thermal_cooling_device_instance), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->tz = tz;
+	dev->cdev = cdev;
+	dev->trip = trip;
+	result = get_idr(&tz->idr, &tz->lock, &dev->id);
+	if (result)
+		goto free_mem;
+
+	sprintf(dev->name, "cdev%d", dev->id);
+	result =
+	    sysfs_create_link(&tz->device.kobj, &cdev->device.kobj, dev->name);
+	if (result)
+		goto release_idr;
+
+	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	dev->attr.attr.name = dev->attr_name;
+	dev->attr.attr.mode = 0444;
+	dev->attr.show = thermal_cooling_device_trip_point_show;
+	result = device_create_file(&tz->device, &dev->attr);
+	if (result)
+		goto remove_symbol_link;
+
+	mutex_lock(&tz->lock);
+	list_for_each_entry(pos, &tz->cooling_devices, node)
+	    if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
+		result = -EEXIST;
+		break;
+	}
+	if (!result)
+		list_add_tail(&dev->node, &tz->cooling_devices);
+	mutex_unlock(&tz->lock);
+
+	if (!result)
+		return 0;
+
+	device_remove_file(&tz->device, &dev->attr);
+      remove_symbol_link:
+	sysfs_remove_link(&tz->device.kobj, dev->name);
+      release_idr:
+	release_idr(&tz->idr, &tz->lock, dev->id);
+      free_mem:
+	kfree(dev);
+	return result;
+}
+EXPORT_SYMBOL(thermal_zone_bind_cooling_device);
+
+/**
+ * thermal_zone_unbind_cooling_device - unbind a cooling device from a thermal zone
+ * this function is usually called in the thermal zone device .unbind callback.
+ * @tz:		thermal zone device
+ * @trip:	indicates which trip point the cooling devices is
+ *		associated with in this thermal zone.
+ * @cdev:	thermal cooling device
+ */
+int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
+				       int trip,
+				       struct thermal_cooling_device *cdev)
+{
+	struct thermal_cooling_device_instance *pos, *next;
+
+	mutex_lock(&tz->lock);
+	list_for_each_entry_safe(pos, next, &tz->cooling_devices, node) {
+		if (pos->tz == tz && pos->trip == trip
+		    && pos->cdev == cdev) {
+			list_del(&pos->node);
+			mutex_unlock(&tz->lock);
+			goto unbind;
+		}
+	}
+	mutex_unlock(&tz->lock);
+
+	return -ENODEV;
+
+      unbind:
+	device_remove_file(&tz->device, &pos->attr);
+	sysfs_remove_link(&tz->device.kobj, pos->name);
+	release_idr(&tz->idr, &tz->lock, pos->id);
+	kfree(pos);
+	return 0;
+}
+EXPORT_SYMBOL(thermal_zone_unbind_cooling_device);
+
+static void thermal_release(struct device *dev)
+{
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+
+	if (!strncmp(dev->bus_id, "thermal_zone", sizeof "thermal_zone" - 1)) {
+		tz = to_thermal_zone(dev);
+		kfree(tz);
+	} else {
+		cdev = to_cooling_device(dev);
+		kfree(cdev);
+	}
+}
+
+static struct class thermal_class = {
+	.name = "thermal",
+	.dev_release = thermal_release,
+};
+
+/**
+ * thermal_cooling_device_register - register a new thermal cooling device
+ * @type:	the thermal cooling device type.
+ * @devdata:	device private data.
+ * @ops:		standard thermal cooling devices callbacks.
+ */
+struct thermal_cooling_device *thermal_cooling_device_register(char *type,
+		       void *devdata, struct thermal_cooling_device_ops *ops)
+{
+	struct thermal_cooling_device *cdev;
+	struct thermal_zone_device *pos;
+	int result;
+
+	if (strlen(type) >= THERMAL_NAME_LENGTH)
+		return NULL;
+
+	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
+		!ops->set_cur_state)
+		return NULL;
+
+	cdev = kzalloc(sizeof(struct thermal_cooling_device), GFP_KERNEL);
+	if (!cdev)
+		return NULL;
+
+	result = get_idr(&thermal_cdev_idr, &thermal_idr_lock, &cdev->id);
+	if (result) {
+		kfree(cdev);
+		return NULL;
+	}
+
+	strcpy(cdev->type, type);
+	cdev->ops = ops;
+	cdev->device.class = &thermal_class;
+	cdev->devdata = devdata;
+	sprintf(cdev->device.bus_id, "cooling_device%d", cdev->id);
+	result = device_register(&cdev->device);
+	if (result) {
+		release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
+		kfree(cdev);
+		return NULL;
+	}
+
+	/* sys I/F */
+	if (type) {
+		result = device_create_file(&cdev->device,
+					    &dev_attr_cdev_type);
+		if (result)
+			goto unregister;
+	}
+
+	result = device_create_file(&cdev->device, &dev_attr_max_state);
+	if (result)
+		goto unregister;
+
+	result = device_create_file(&cdev->device, &dev_attr_cur_state);
+	if (result)
+		goto unregister;
+
+	mutex_lock(&thermal_list_lock);
+	list_add(&cdev->node, &thermal_cdev_list);
+	list_for_each_entry(pos, &thermal_tz_list, node) {
+		if (!pos->ops->bind)
+			continue;
+		result = pos->ops->bind(pos, cdev);
+		if (result)
+			break;
+
+	}
+	mutex_unlock(&thermal_list_lock);
+
+	if (!result)
+		return cdev;
+
+      unregister:
+	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
+	device_unregister(&cdev->device);
+	return NULL;
+}
+EXPORT_SYMBOL(thermal_cooling_device_register);
+
+/**
+ * thermal_cooling_device_unregister - removes the registered thermal cooling device
+ *
+ * @cdev:	the thermal cooling device to remove.
+ *
+ * thermal_cooling_device_unregister() must be called when the device is no
+ * longer needed.
+ */
+void thermal_cooling_device_unregister(struct
+				       thermal_cooling_device
+				       *cdev)
+{
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *pos = NULL;
+
+	if (!cdev)
+		return;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(pos, &thermal_cdev_list, node)
+	    if (pos == cdev)
+		break;
+	if (pos != cdev) {
+		/* thermal cooling device not found */
+		mutex_unlock(&thermal_list_lock);
+		return;
+	}
+	list_del(&cdev->node);
+	list_for_each_entry(tz, &thermal_tz_list, node) {
+		if (!tz->ops->unbind)
+			continue;
+		tz->ops->unbind(tz, cdev);
+	}
+	mutex_unlock(&thermal_list_lock);
+	if (cdev->type[0])
+		device_remove_file(&cdev->device,
+				   &dev_attr_cdev_type);
+	device_remove_file(&cdev->device, &dev_attr_max_state);
+	device_remove_file(&cdev->device, &dev_attr_cur_state);
+
+	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
+	device_unregister(&cdev->device);
+	return;
+}
+EXPORT_SYMBOL(thermal_cooling_device_unregister);
+
+/**
+ * thermal_zone_device_register - register a new thermal zone device
+ * @type:	the thermal zone device type
+ * @trips:	the number of trip points the thermal zone support
+ * @devdata:	private device data
+ * @ops:	standard thermal zone device callbacks
+ *
+ * thermal_zone_device_unregister() must be called when the device is no
+ * longer needed.
+ */
+struct thermal_zone_device *thermal_zone_device_register(char *type,
+					int trips, void *devdata,
+					struct thermal_zone_device_ops *ops)
+{
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *pos;
+	int result;
+	int count;
+
+	if (strlen(type) >= THERMAL_NAME_LENGTH)
+		return NULL;
+
+	if (trips > THERMAL_MAX_TRIPS || trips < 0)
+		return NULL;
+
+	if (!ops || !ops->get_temp)
+		return NULL;
+
+	tz = kzalloc(sizeof(struct thermal_zone_device), GFP_KERNEL);
+	if (!tz)
+		return NULL;
+
+	INIT_LIST_HEAD(&tz->cooling_devices);
+	idr_init(&tz->idr);
+	mutex_init(&tz->lock);
+	result = get_idr(&thermal_tz_idr, &thermal_idr_lock, &tz->id);
+	if (result) {
+		kfree(tz);
+		return NULL;
+	}
+
+	strcpy(tz->type, type);
+	tz->ops = ops;
+	tz->device.class = &thermal_class;
+	tz->devdata = devdata;
+	tz->trips = trips;
+	sprintf(tz->device.bus_id, "thermal_zone%d", tz->id);
+	result = device_register(&tz->device);
+	if (result) {
+		release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
+		kfree(tz);
+		return NULL;
+	}
+
+	/* sys I/F */
+	if (type) {
+		result = device_create_file(&tz->device, &dev_attr_type);
+		if (result)
+			goto unregister;
+	}
+
+	result = device_create_file(&tz->device, &dev_attr_temp);
+	if (result)
+		goto unregister;
+
+	if (ops->get_mode) {
+		result = device_create_file(&tz->device, &dev_attr_mode);
+		if (result)
+			goto unregister;
+	}
+
+	for (count = 0; count < trips; count++) {
+		TRIP_POINT_ATTR_ADD(&tz->device, count, result);
+		if (result)
+			goto unregister;
+	}
+
+	mutex_lock(&thermal_list_lock);
+	list_add_tail(&tz->node, &thermal_tz_list);
+	if (ops->bind)
+		list_for_each_entry(pos, &thermal_cdev_list, node) {
+			result = ops->bind(tz, pos);
+			if (result)
+				break;
+		}
+	mutex_unlock(&thermal_list_lock);
+
+	if (!result)
+		return tz;
+
+      unregister:
+	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
+	device_unregister(&tz->device);
+	return NULL;
+}
+EXPORT_SYMBOL(thermal_zone_device_register);
+
+/**
+ * thermal_device_unregister - removes the registered thermal zone device
+ *
+ * @tz: the thermal zone device to remove
+ */
+void thermal_zone_device_unregister(struct thermal_zone_device *tz)
+{
+	struct thermal_cooling_device *cdev;
+	struct thermal_zone_device *pos = NULL;
+	int count;
+
+	if (!tz)
+		return;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(pos, &thermal_tz_list, node)
+	    if (pos == tz)
+		break;
+	if (pos != tz) {
+		/* thermal zone device not found */
+		mutex_unlock(&thermal_list_lock);
+		return;
+	}
+	list_del(&tz->node);
+	if (tz->ops->unbind)
+		list_for_each_entry(cdev, &thermal_cdev_list, node)
+		    tz->ops->unbind(tz, cdev);
+	mutex_unlock(&thermal_list_lock);
+
+	if (tz->type[0])
+		device_remove_file(&tz->device, &dev_attr_type);
+	device_remove_file(&tz->device, &dev_attr_temp);
+	if (tz->ops->get_mode)
+		device_remove_file(&tz->device, &dev_attr_mode);
+
+	for (count = 0; count < tz->trips; count++)
+		TRIP_POINT_ATTR_REMOVE(&tz->device, count);
+
+	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
+	idr_destroy(&tz->idr);
+	mutex_destroy(&tz->lock);
+	device_unregister(&tz->device);
+	return;
+}
+EXPORT_SYMBOL(thermal_zone_device_unregister);
+
+static int __init thermal_init(void)
+{
+	int result = 0;
+
+	result = class_register(&thermal_class);
+	if (result) {
+		idr_destroy(&thermal_tz_idr);
+		idr_destroy(&thermal_cdev_idr);
+		mutex_destroy(&thermal_idr_lock);
+		mutex_destroy(&thermal_list_lock);
+	}
+	return result;
+}
+
+static void __exit thermal_exit(void)
+{
+	class_unregister(&thermal_class);
+	idr_destroy(&thermal_tz_idr);
+	idr_destroy(&thermal_cdev_idr);
+	mutex_destroy(&thermal_idr_lock);
+	mutex_destroy(&thermal_list_lock);
+}
+
+subsys_initcall(thermal_init);
+module_exit(thermal_exit);
Index: linux-2.6/include/linux/thermal.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/thermal.h
@@ -0,0 +1,90 @@
+/*
+ *  thermal.h  ($Revision: 0 $)
+ *
+ *  Copyright (C) 2008  Intel Corp
+ *  Copyright (C) 2008  Zhang Rui <rui.zhang@intel.com>
+ *  Copyright (C) 2008  Sujith Thomas <sujith.thomas@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef __THERMAL_H__
+#define __THERMAL_H__
+
+#include <linux/idr.h>
+#include <linux/device.h>
+
+struct thermal_zone_device;
+struct thermal_cooling_device;
+
+struct thermal_zone_device_ops {
+	int (*bind) (struct thermal_zone_device *,
+		     struct thermal_cooling_device *);
+	int (*unbind) (struct thermal_zone_device *,
+		       struct thermal_cooling_device *);
+	int (*get_temp) (struct thermal_zone_device *, char *);
+	int (*get_mode) (struct thermal_zone_device *, char *);
+	int (*set_mode) (struct thermal_zone_device *, const char *);
+	int (*get_trip_type) (struct thermal_zone_device *, int, char *);
+	int (*get_trip_temp) (struct thermal_zone_device *, int, char *);
+};
+
+struct thermal_cooling_device_ops {
+	int (*get_max_state) (struct thermal_cooling_device *, char *);
+	int (*get_cur_state) (struct thermal_cooling_device *, char *);
+	int (*set_cur_state) (struct thermal_cooling_device *, unsigned int);
+};
+
+#define THERMAL_TRIPS_NONE -1
+#define THERMAL_MAX_TRIPS 10
+#define THERMAL_NAME_LENGTH 20
+struct thermal_cooling_device {
+	int id;
+	char type[THERMAL_NAME_LENGTH];
+	struct device device;
+	void *devdata;
+	struct thermal_cooling_device_ops *ops;
+	struct list_head node;
+};
+
+struct thermal_zone_device {
+	int id;
+	char type[THERMAL_NAME_LENGTH];
+	struct device device;
+	void *devdata;
+	int trips;
+	struct thermal_zone_device_ops *ops;
+	struct list_head cooling_devices;
+	struct idr idr;
+	struct mutex lock;	/* protect cooling devices list */
+	struct list_head node;
+};
+
+struct thermal_zone_device *thermal_zone_device_register(char *, int, void *,
+					struct thermal_zone_device_ops *);
+void thermal_zone_device_unregister(struct thermal_zone_device *);
+
+int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
+				     struct thermal_cooling_device *);
+int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
+				       struct thermal_cooling_device *);
+
+struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
+					struct thermal_cooling_device_ops *);
+void thermal_cooling_device_unregister(struct thermal_cooling_device *);
+
+#endif				/* __THERMAL_H__ */
Index: linux-2.6/drivers/Kconfig
===================================================================
--- linux-2.6.orig/drivers/Kconfig
+++ linux-2.6/drivers/Kconfig
@@ -58,6 +58,8 @@ source "drivers/power/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/thermal/Kconfig"
+
 source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
Index: linux-2.6/drivers/thermal/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6/drivers/thermal/Kconfig
@@ -0,0 +1,16 @@
+#
+# Generic thermal sysfs drivers configuration
+#
+
+menuconfig THERMAL
+	bool "Generic Thermal sysfs driver"
+	default y
+	help
+	  Generic Thermal Sysfs driver offers a generic mechanism for
+	  thermal management. Usually it's made up of one or more thermal
+	  zone and cooling device.
+	  each thermal zone contains its own temperature, trip points,
+	  cooling devices.
+	  All platforms with ACPI thermal support can use this driver.
+	  If you want this support, you should say Y here
+
Index: linux-2.6/drivers/thermal/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/drivers/thermal/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for sensor chip drivers.
+#
+
+obj-$(CONFIG_THERMAL)		+= thermal.o
+
Index: linux-2.6/drivers/Makefile
===================================================================
--- linux-2.6.orig/drivers/Makefile
+++ linux-2.6/drivers/Makefile
@@ -65,6 +65,7 @@ obj-y				+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_THERMAL)		+= thermal/
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
Index: linux-2.6/Documentation/thermal/sysfs-api.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/thermal/sysfs-api.txt
@@ -0,0 +1,247 @@
+Generic Thermal Sysfs driver How To
+=========================
+
+Written by Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>
+
+Updated: 2 January 2008
+
+Copyright (c)  2008 Intel Corporation
+
+
+0. Introduction
+
+The generic thermal sysfs provides a set of interfaces for thermal zone devices (sensors)
+and thermal cooling devices (fan, processor...) to register with the thermal management
+solution and to be a part of it.
+
+This how-to focusses on enabling new thermal zone and cooling devices to participate
+in thermal management.
+This solution is platform independent and any type of thermal zone devices and
+cooling devices should be able to make use of the infrastructure.
+
+The main task of the thermal sysfs driver is to expose thermal zone attributes as well
+as cooling device attributes to the user space.
+An intelligent thermal management application can make decisions based on inputs
+from thermal zone attributes (the current temperature and trip point temperature)
+and throttle appropriate devices.
+
+[0-*]	denotes any positive number starting from 0
+[1-*]	denotes any positive number starting from 1
+
+1. thermal sysfs driver interface functions
+
+1.1 thermal zone device interface
+1.1.1 struct thermal_zone_device *thermal_zone_device_register(char *name, int trips,
+				void *devdata, struct thermal_zone_device_ops *ops)
+
+	This interface function adds a new thermal zone device (sensor) to
+	/sys/class/thermal folder as thermal_zone[0-*].
+	It tries to bind all the thermal cooling devices registered at the same time.
+
+	name: the thermal zone name.
+	trips: the total number of trip points this thermal zone supports.
+	devdata: device private data
+	ops: thermal zone device callbacks.
+		.bind: bind the thermal zone device with a thermal cooling device.
+		.unbind: unbing the thermal zone device with a thermal cooling device.
+		.get_temp: get the current temperature of the thermal zone.
+		.get_mode: get the current mode (user/kernel) of the thermal zone.
+			   "kernel" means thermal management is done in kernel.
+			   "user" will prevent kernel thermal driver actions upon trip points
+			   so that user applications can take charge of thermal management.
+		.set_mode: set the mode (user/kernel) of the thermal zone.
+		.get_trip_type: get the type of certain trip point.
+		.get_trip_temp: get the temperature above which the certain trip point
+				will be fired.
+
+1.1.2 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
+
+	This interface function removes the thermal zone device.
+	It deletes the corresponding entry form /sys/class/thermal folder and unbind all
+	the thermal cooling devices it uses.
+
+1.2 thermal cooling device interface
+1.2.1 struct thermal_cooling_device *thermal_cooling_device_register(char *name,
+					void *devdata, struct thermal_cooling_device_ops *)
+
+	This interface function adds a new thermal cooling device (fan/processor/...) to
+	/sys/class/thermal/ folder as cooling_device[0-*].
+	It tries to bind itself to all the thermal zone devices register at the same time.
+	name: the cooling device name.
+	devdata: device private data.
+	ops: thermal cooling devices callbacks.
+		.get_max_state: get the Maximum throttle state of the cooling device.
+		.get_cur_state: get the Current throttle state of the cooling device.
+		.set_cur_state: set the Current throttle state of the cooling device.
+
+1.2.2 void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
+
+	This interface function remove the thermal cooling device.
+	It deletes the corresponding entry form /sys/class/thermal folder and unbind
+	itself from all	the thermal zone devices using it.
+
+1.3 interface for binding a thermal zone device with a thermal cooling device
+1.3.1 int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
+			int trip, struct thermal_cooling_device *cdev);
+
+	This interface function bind a thermal cooling device to the certain trip point
+	of a thermal zone device.
+	This function is usually called in the thermal zone device .bind callback.
+	tz: the thermal zone device
+	cdev: thermal cooling device
+	trip: indicates which trip point the cooling devices is associated with
+		 in this thermal zone.
+
+1.3.2 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
+				int trip, struct thermal_cooling_device *cdev);
+
+	This interface function unbind a thermal cooling device from the certain trip point
+	of a thermal zone device.
+	This function is usually called in the thermal zone device .unbind callback.
+	tz: the thermal zone device
+	cdev: thermal cooling device
+	trip: indicates which trip point the cooling devices is associated with
+		in this thermal zone.
+
+2. sysfs attributes structure
+
+RO	read only value
+RW	read/write value
+
+All thermal sysfs attributes will be represented under /sys/class/thermal
+/sys/class/thermal/
+
+Thermal zone device sys I/F, created once it's registered:
+|thermal_zone[0-*]:
+	|-----type:			Type of the thermal zone
+	|-----temp:			Current temperature
+	|-----mode:			Working mode of the thermal zone
+	|-----trip_point_[0-*]_temp:	Trip point temperature
+	|-----trip_point_[0-*]_type:	Trip point type
+
+Thermal cooling device sys I/F, created once it's registered:
+|cooling_device[0-*]:
+	|-----type :			Type of the cooling device(processor/fan/...)
+	|-----max_state:		Maximum cooling state of the cooling device
+	|-----cur_state:		Current cooling state of the cooling device
+
+
+These two dynamic attributes are created/removed in pairs.
+They represent the relationship between a thermal zone and its associated cooling device.
+They are created/removed for each
+thermal_zone_bind_cooling_device/thermal_zone_unbind_cooling_device successful exection.
+
+|thermal_zone[0-*]
+	|-----cdev[0-*]:		The [0-*]th cooling device in the current thermal zone
+	|-----cdev[0-*]_trip_point:	Trip point that cdev[0-*] is associated with
+
+
+***************************
+* Thermal zone attributes *
+***************************
+
+type				Strings which represent the thermal zone type.
+				This is given by thermal zone driver as part of registration.
+				Eg: "ACPI thermal zone" indicates it's a ACPI thermal device
+				RO
+				Optional
+
+temp				Current temperature as reported by thermal zone (sensor)
+				Unit: degree celsius
+				RO
+				Required
+
+mode				One of the predifned values in [kernel, user]
+				This file gives information about the algorithm
+				that is currently managing the thermal zone.
+				It can be either default kernel based algorithm
+				or user space application.
+				RW
+				Optional
+				kernel	= Thermal management in kernel thermal zone driver.
+				user	= Preventing kernel thermal zone driver actions upon
+					  trip points so that user application can take full
+					  charge of the thermal management.
+
+trip_point_[0-*]_temp		The temperature above which trip point will be fired
+				Unit: degree celsius
+				RO
+				Optional
+
+trip_point_[0-*]_type 		Strings which indicate the type of the trip point
+				Eg. it can be one of critical, hot, passive,
+				    active[0-*] for ACPI thermal zone.
+				RO
+				Optional
+
+cdev[0-*]			Sysfs link to the thermal cooling device node where the sys I/F
+				for cooling device throttling control represents.
+				RO
+				Optional
+
+cdev[0-*]_trip_point		The trip point with which cdev[0-*] is assocated in this thermal zone
+				-1 means the cooling device is not associated with any trip point.
+				RO
+				Optional
+
+******************************
+* Cooling device  attributes *
+******************************
+
+type				String which represents the type of device
+				eg: For generic ACPI: this should be "Fan",
+				"Processor" or "LCD"
+				eg. For memory controller device on intel_menlow platform:
+				this should be "Memory controller"
+				RO
+				Optional
+
+max_state			The maximum permissible cooling state of this cooling device.
+				RO
+				Required
+
+cur_state			The current cooling state of this cooling device.
+				the value can any integer numbers between 0 and max_state,
+				cur_state == 0 means no cooling
+				cur_state == max_state means the maximum cooling.
+				RW
+				Required
+
+3. A simple implementation
+
+ACPI thermal zone may support multiple trip points like critical/hot/passive/active.
+If an ACPI thermal zone supports critical, passive, active[0] and active[1] at the same time,
+it may register itself as a thermale_zone_device (thermal_zone1) with 4 trip points in all.
+It has one processor and one fan, which are both registered as thermal_cooling_device.
+If the processor is listed in _PSL method, and the fan is listed in _AL0 method,
+the sys I/F structure will be built like this:
+
+/sys/class/thermal:
+
+|thermal_zone1:
+	|-----type:			ACPI thermal zone
+	|-----temp:			37
+	|-----mode:			kernel
+	|-----trip_point_0_temp:	100
+	|-----trip_point_0_type:	critical
+	|-----trip_point_1_temp:	80
+	|-----trip_point_1_type:	passive
+	|-----trip_point_2_temp:	70
+	|-----trip_point_2_type:	active[0]
+	|-----trip_point_3_temp:	60
+	|-----trip_point_3_type:	active[1]
+	|-----cdev0:			--->/sys/class/thermal/cooling_device0
+	|-----cdev0_trip_point:		1	/* cdev0 can be used for passive */
+	|-----cdev1:			--->/sys/class/thermal/cooling_device3
+	|-----cdev1_trip_point:		2	/* cdev1 can be used for active[0]*/
+
+|cooling_device0:
+	|-----type:			Processor
+	|-----max_state:		8
+	|-----cur_state:		0
+
+|cooling_device3:
+	|-----type:			Fan
+	|-----max_state:		2
+	|-----cur_state:		0
+


