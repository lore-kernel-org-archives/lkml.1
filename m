Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYFKKHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYFKKHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYFKKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:06:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56950 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYFKKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:06:52 -0400
Date: Wed, 11 Jun 2008 11:06:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rui.zhang@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Clean up thermal API
Message-ID: <20080611100647.GA20013@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal layer passes temperatures around as strings. This is fine 
for sysfs, but makes it hard to use them for other purposes in-kernel. 
Change them to longs and do the string conversion in the sysfs-specific 
code.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 504385b..28b3782 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -886,7 +886,8 @@ static void acpi_thermal_check(void *data)
 /* sys I/F for generic thermal sysfs support */
 #define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
 
-static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
+static int thermal_get_temp(struct thermal_zone_device *thermal, 
+			    unsigned long *temp)
 {
 	struct acpi_thermal *tz = thermal->devdata;
 	int result;
@@ -898,7 +899,8 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
 	if (result)
 		return result;
 
-	return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(tz->temperature));
+	*temp = KELVIN_TO_MILLICELSIUS(tz->temperature);
+	return 0;
 }
 
 static const char enabled[] = "kernel";
@@ -982,7 +984,7 @@ static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 }
 
 static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
-				 int trip, char *buf)
+				 int trip, unsigned long *temp)
 {
 	struct acpi_thermal *tz = thermal->devdata;
 	int i;
@@ -991,31 +993,40 @@ static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 		return -EINVAL;
 
 	if (tz->trips.critical.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(
-				tz->trips.critical.temperature));
+		if (!trip) {
+			*temp = KELVIN_TO_MILLICELSIUS(
+				tz->trips.critical.temperature);
+			return 0;
+		}
+		
 		trip--;
 	}
 
 	if (tz->trips.hot.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(
-					tz->trips.hot.temperature));
+		if (!trip) {
+			*temp = KELVIN_TO_MILLICELSIUS(
+				tz->trips.hot.temperature);
+			return 0;
+		}
 		trip--;
 	}
 
 	if (tz->trips.passive.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(
-					tz->trips.passive.temperature));
+		if (!trip) {
+			*temp = KELVIN_TO_MILLICELSIUS(
+				tz->trips.passive.temperature);
+			return 0;
+		}
 		trip--;
 	}
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
 		tz->trips.active[i].flags.valid; i++) {
-		if (!trip)
-			return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(
-					tz->trips.active[i].temperature));
+		if (!trip) {
+			*temp = KELVIN_TO_MILLICELSIUS(
+				tz->trips.active[i].temperature);
+			return 0;
+		}
 		trip--;
 	}
 
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6098787..c537a5b 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -104,11 +104,18 @@ static ssize_t
 temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	long temperature;
+	int ret;
 
 	if (!tz->ops->get_temp)
 		return -EPERM;
 
-	return tz->ops->get_temp(tz, buf);
+	ret = tz->ops->get_temp(tz,&temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf,"%ld\n",temperature);
 }
 
 static ssize_t
@@ -160,7 +167,8 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip;
+	int trip, ret;
+	long temperature;
 
 	if (!tz->ops->get_trip_temp)
 		return -EPERM;
@@ -168,7 +176,12 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 	if (!sscanf(attr->attr.name, "trip_point_%d_temp", &trip))
 		return -EINVAL;
 
-	return tz->ops->get_trip_temp(tz, trip, buf);
+	ret = tz->ops->get_trip_temp(tz, trip, &temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf (buf, "%ld\n", temperature);
 }
 
 static DEVICE_ATTR(type, 0444, type_show, NULL);
@@ -312,13 +325,20 @@ static DEVICE_ATTR(name, 0444, name_show, NULL);
 static ssize_t
 temp_input_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
+	long temperature;
+	int ret;
 	struct thermal_hwmon_attr *hwmon_attr
 			= container_of(attr, struct thermal_hwmon_attr, attr);
 	struct thermal_zone_device *tz
 			= container_of(hwmon_attr, struct thermal_zone_device,
 				       temp_input);
 
-	return tz->ops->get_temp(tz, buf);
+	ret = tz->ops->get_temp(tz, &temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%ld\n", temperature);
 }
 
 static ssize_t
@@ -330,8 +350,14 @@ temp_crit_show(struct device *dev, struct device_attribute *attr,
 	struct thermal_zone_device *tz
 			= container_of(hwmon_attr, struct thermal_zone_device,
 				       temp_crit);
+	long temperature;
+	int ret;
+
+	ret = tz->ops->get_trip_temp(tz, 0, &temperature);
+	if (ret)
+		return ret;
 
-	return tz->ops->get_trip_temp(tz, 0, buf);
+	return sprintf(buf, "%ld\n", temperature);
 }
 
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 06d3e6e..63e6619 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -36,11 +36,12 @@ struct thermal_zone_device_ops {
 		     struct thermal_cooling_device *);
 	int (*unbind) (struct thermal_zone_device *,
 		       struct thermal_cooling_device *);
-	int (*get_temp) (struct thermal_zone_device *, char *);
+	int (*get_temp) (struct thermal_zone_device *, unsigned long *);
 	int (*get_mode) (struct thermal_zone_device *, char *);
 	int (*set_mode) (struct thermal_zone_device *, const char *);
 	int (*get_trip_type) (struct thermal_zone_device *, int, char *);
-	int (*get_trip_temp) (struct thermal_zone_device *, int, char *);
+	int (*get_trip_temp) (struct thermal_zone_device *, int, 
+			      unsigned long *);
 	int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
 };
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
