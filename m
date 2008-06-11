Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbYFKQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbYFKQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYFKQ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:58:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39769 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYFKQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:58:11 -0400
Date: Wed, 11 Jun 2008 17:58:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rui.zhang@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] Implement thermal limiting in generic thermal class
Message-ID: <20080611165804.GB27437@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org> <20080611164226.GA27437@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611164226.GA27437@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of an explicitly defined passive cooling zone any 
machine unable to manage its thermal profile through active cooling will 
reach its critical shutdown temperature and power off, resulting in 
potential data loss. Add support to the generic thermal class for 
initiating passive cooling at a temperature defaulting to just below the 
critical temperature, with this value being overridable by the admin via 
sysfs.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

I've got bug reports from multiple users with a wide range of hardware 
that can't keep itself sufficiently cool under Linux. Whether this is 
bad hardware design, machines being used outside recommended thermal 
conditions or whatever, failing to do anything about this is resulting 
in data loss (one user is unable to even get through a Fedora install 
without his machine shutting down). There's no evidence that the low 
level of polling used by this patch (one temperature read per zone per 
10 seconds while the temperature is below the limit point) will 
interfere with any hardware. For all we know, this is how Windows 
implements it...

This sits on top of the previous two patches that clean up the internal 
thermal API.

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 70d68ce..5553b18 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -197,6 +197,10 @@ cdev[0-*]_trip_point		The trip point with which cdev[0-*] is associated in this
 				RO
 				Optional
 
+passive				If the thermal zone does not provide its own passive trip point, one
+				can be set here. Since there will be no hardware reporting in this
+				case, polling will be automatically enabled to support it.				
+
 ******************************
 * Cooling device  attributes *
 ******************************
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 02abaf0..1e4b77e 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -30,6 +30,7 @@
 #include <linux/idr.h>
 #include <linux/thermal.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
@@ -48,6 +49,9 @@ struct thermal_cooling_device_instance {
 	struct list_head node;
 };
 
+static struct timer_list poll_timer;
+static struct work_struct thermal_poll_queue;
+
 static DEFINE_IDR(thermal_tz_idr);
 static DEFINE_IDR(thermal_cdev_idr);
 static DEFINE_MUTEX(thermal_idr_lock);
@@ -115,7 +119,38 @@ temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 	if (ret)
 		return ret;
 
-	return sprintf(buf,"%ld\n",temperature);
+	return sprintf(buf, "%ld\n", temperature);
+}
+
+static ssize_t
+passive_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	return sprintf(buf, "%ld\n", tz->force_passive_temp);
+}
+
+static ssize_t
+passive_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	unsigned long temperature, critical_temp;
+	int ret = strict_strtoul(buf, 10, &temperature);
+
+	if (ret)
+		return ret;
+
+	ret = tz->ops->get_crit_temp(tz, &critical_temp);
+
+	if (ret)
+		return ret;
+
+	if (temperature > critical_temp)
+		return -EINVAL;
+
+	tz->force_passive_temp = temperature;
+
+	return count;
 }
 
 static ssize_t
@@ -187,6 +222,7 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
+static DEVICE_ATTR(passive, 0644, passive_show, passive_store);
 
 static struct device_attribute trip_point_attrs[] = {
 	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
@@ -486,6 +522,83 @@ thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 }
 #endif
 
+static void thermal_throttle_cpus(void)
+{
+	struct thermal_cooling_device *cdev;
+	list_for_each_entry(cdev, &thermal_cdev_list, node)
+		if (!strncmp(cdev->type, "Processor", 9))
+			cdev->throttle = 1;
+}
+
+static void thermal_poll(unsigned long data)
+{
+	schedule_work(&thermal_poll_queue);
+}
+
+static void thermal_update(struct work_struct *work)
+{
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+	unsigned long temp;
+	int sleep_time = 10, max_state, state, cpus_throttled = 0;
+
+	if (list_empty(&thermal_cdev_list))
+		goto out;
+
+	list_for_each_entry(cdev, &thermal_cdev_list, node)
+		cdev->throttle = 0;
+
+	if (list_empty(&thermal_tz_list))
+		goto out;
+
+	list_for_each_entry(tz, &thermal_tz_list, node) {
+		if (!tz->force_passive)
+			continue;
+
+		tz->ops->get_temp(tz, &temp);
+
+		/* If the temperature trend is downwards, reduce throttling
+		   in an attempt to end up at a steady state */
+		if (temp > tz->force_passive_temp) {
+			if (((temp - tz->prev_temp) +
+			     (temp - tz->force_passive_temp)) > 0) {
+				if (list_empty(&tz->cooling_devices) &&
+				    !cpus_throttled) {
+					thermal_throttle_cpus();
+					cpus_throttled = 1;
+				} else
+					list_for_each_entry(cdev, 
+							    &tz->cooling_devices,
+							    node)
+						cdev->throttle = 1;
+			}
+		}
+		tz->prev_temp = temp;
+
+		/* Increase polling interval near the cut-off temperature */
+		if (temp > tz->force_passive_temp - 5000)
+			sleep_time = 1;
+	}
+
+	list_for_each_entry(cdev, &thermal_cdev_list, node) {
+		if (!strncmp(cdev->type, "Fan", 3))
+			continue;
+		cdev->ops->get_cur_state(cdev, &state);
+		if (cdev->throttle) {
+			cdev->ops->get_max_state(cdev, &max_state);
+			if (++state < max_state)
+				cdev->ops->set_cur_state(cdev, state);
+		} else
+			if (state > 0) {
+				cdev->ops->set_cur_state(cdev, --state);
+				sleep_time = 1;
+			}
+	}
+out:
+	poll_timer.function = thermal_poll;
+	poll_timer.expires = round_jiffies(jiffies + sleep_time*HZ);
+	add_timer(&poll_timer);
+}
 
 /**
  * thermal_zone_bind_cooling_device - bind a cooling device to a thermal zone
@@ -775,6 +888,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	struct thermal_cooling_device *pos;
 	int result;
 	int count;
+	char trip_type[THERMAL_NAME_LENGTH];
 
 	if (strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
@@ -803,6 +917,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
 	tz->trips = trips;
+	tz->force_passive = 1;
 	sprintf(tz->device.bus_id, "thermal_zone%d", tz->id);
 	result = device_register(&tz->device);
 	if (result) {
@@ -811,6 +926,12 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 		return ERR_PTR(result);
 	}
 
+	for (count = 0; count < trips; count++) {
+		tz->ops->get_trip_type(tz, count, trip_type);
+		if (!strcmp(trip_type, "passive"))
+			tz->force_passive = 0;
+	}
+
 	/* sys I/F */
 	if (type) {
 		result = device_create_file(&tz->device, &dev_attr_type);
@@ -848,8 +969,26 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 		}
 	mutex_unlock(&thermal_list_lock);
 
-	if (!result)
+	if (!result) {
+		if (tz->force_passive) {
+			unsigned long crit_temp;
+			tz->ops->get_crit_temp(tz, &crit_temp);
+			tz->force_passive_temp = crit_temp-5000;
+
+			result = device_create_file(&tz->device,
+						    &dev_attr_passive);
+			if (result)
+				goto unregister;
+
+			if (!timer_pending(&poll_timer)) {
+				poll_timer.function = thermal_poll;
+				poll_timer.expires = round_jiffies(jiffies
+								   +(HZ*10));
+				add_timer(&poll_timer);
+			}
+		}
 		return tz;
+	}
 
       unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
@@ -910,6 +1049,9 @@ static int __init thermal_init(void)
 {
 	int result = 0;
 
+	init_timer(&poll_timer);
+	INIT_WORK(&thermal_poll_queue, thermal_update);
+
 	result = class_register(&thermal_class);
 	if (result) {
 		idr_destroy(&thermal_tz_idr);
@@ -922,6 +1064,7 @@ static int __init thermal_init(void)
 
 static void __exit thermal_exit(void)
 {
+	del_timer(&poll_timer);
 	class_unregister(&thermal_class);
 	idr_destroy(&thermal_tz_idr);
 	idr_destroy(&thermal_cdev_idr);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 5ddbd4f..d398cff 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -61,6 +61,7 @@ struct thermal_cooling_device {
 	void *devdata;
 	struct thermal_cooling_device_ops *ops;
 	struct list_head node;
+	bool throttle;
 };
 
 #define KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
@@ -102,6 +103,9 @@ struct thermal_zone_device {
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
 #endif
+	unsigned long force_passive_temp;
+	unsigned long prev_temp;
+	bool force_passive;
 };
 
 struct thermal_zone_device *thermal_zone_device_register(char *, int, void *,


-- 
Matthew Garrett | mjg59@srcf.ucam.org
