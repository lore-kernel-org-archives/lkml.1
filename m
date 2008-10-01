Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYJAMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYJAMEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYJAME2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:04:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45046 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYJAME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:04:27 -0400
Date: Wed, 1 Oct 2008 13:04:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rui.zhang@intel.com, pavel@suse.cz
Subject: [PATCH] thermal: Make it simpler to use the thermal layer inside the kernel
Message-ID: <20081001120420.GA29479@srcf.ucam.org>
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

The thermal layer passes temperatures and trip point types around as 
strings. This is fine for sysfs, but makes it hard to use them for other 
purposes in-kernel. Move the string conversion to the sysfs-specific 
code.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

This addresses Pavel's concerns about the use of longs, and also changes 
the trip point type to an enum in preparation for a followup patch.

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 2655bc1..5487a98 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -69,27 +69,30 @@ static struct acpi_driver acpi_fan_driver = {
 };
 
 /* thermal cooling device callbacks */
-static int fan_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+static int fan_get_max_state(struct thermal_cooling_device *cdev, unsigned int
+			     *state)
 {
 	/* ACPI fan device only support two states: ON/OFF */
-	return sprintf(buf, "1\n");
+	*state = 1;
+	return 0;
 }
 
-static int fan_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned int
+			     *state)
 {
 	struct acpi_device *device = cdev->devdata;
-	int state;
 	int result;
 
 	if (!device)
 		return -EINVAL;
 
-	result = acpi_bus_get_power(device->handle, &state);
+	result = acpi_bus_get_power(device->handle, state);
 	if (result)
 		return result;
 
-	return sprintf(buf, "%s\n", state == ACPI_STATE_D3 ? "0" :
-			 (state == ACPI_STATE_D0 ? "1" : "unknown"));
+	*state = (*state == ACPI_STATE_D3 ? 0 :
+		 (*state == ACPI_STATE_D0 ? 1 : -1));
+	return 0;
 }
 
 static int
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index ef34b18..4bc094c 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -374,7 +374,8 @@ static int acpi_processor_max_state(struct acpi_processor *pr)
 	return max_state;
 }
 static int
-processor_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+processor_get_max_state(struct thermal_cooling_device *cdev, unsigned int
+			*state)
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_processor *pr = acpi_driver_data(device);
@@ -382,24 +383,24 @@ processor_get_max_state(struct thermal_cooling_device *cdev, char *buf)
 	if (!device || !pr)
 		return -EINVAL;
 
-	return sprintf(buf, "%d\n", acpi_processor_max_state(pr));
+	*state = acpi_processor_max_state(pr);
+	return 0;
 }
 
 static int
-processor_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+processor_get_cur_state(struct thermal_cooling_device *cdev, unsigned int
+			*cur_state)
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_processor *pr = acpi_driver_data(device);
-	int cur_state;
 
 	if (!device || !pr)
 		return -EINVAL;
 
-	cur_state = cpufreq_get_cur_state(pr->id);
+	*cur_state = cpufreq_get_cur_state(pr->id);
 	if (pr->flags.throttling)
-		cur_state += pr->throttling.state;
-
-	return sprintf(buf, "%d\n", cur_state);
+		*cur_state += pr->throttling.state;
+	return 0;
 }
 
 static int
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9127036..754967f 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -934,7 +934,8 @@ static void acpi_thermal_check(void *data)
 /* sys I/F for generic thermal sysfs support */
 #define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
 
-static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
+static int thermal_get_temp(struct thermal_zone_device *thermal,
+			    int *temp)
 {
 	struct acpi_thermal *tz = thermal->devdata;
 	int result;
@@ -946,7 +947,8 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
 	if (result)
 		return result;
 
-	return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(tz->temperature));
+	*temp = KELVIN_TO_MILLICELSIUS(tz->temperature);
+	return 0;
 }
 
 static const char enabled[] = "kernel";
@@ -993,7 +995,7 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 }
 
 static int thermal_get_trip_type(struct thermal_zone_device *thermal,
-				 int trip, char *buf)
+				 int trip, enum thermal_trip_t *type)
 {
 	struct acpi_thermal *tz = thermal->devdata;
 	int i;
@@ -1002,27 +1004,35 @@ static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 		return -EINVAL;
 
 	if (tz->trips.critical.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "critical\n");
+		if (!trip) {
+			*type = THERMAL_TRIP_CRITICAL;
+			return 0;
+		}
 		trip--;
 	}
 
 	if (tz->trips.hot.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "hot\n");
+		if (!trip) {
+			*type = THERMAL_TRIP_HOT;
+			return 0;
+		}
 		trip--;
 	}
 
 	if (tz->trips.passive.flags.valid) {
-		if (!trip)
-			return sprintf(buf, "passive\n");
+		if (!trip) {
+			*type = THERMAL_TRIP_PASSIVE;
+			return 0;
+		}
 		trip--;
 	}
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
 		tz->trips.active[i].flags.valid; i++) {
-		if (!trip)
-			return sprintf(buf, "active%d\n", i);
+		if (!trip) {
+			*type = THERMAL_TRIP_ACTIVE;
+			return 0;
+		}
 		trip--;
 	}
 
@@ -1030,7 +1040,7 @@ static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 }
 
 static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
-				 int trip, char *buf)
+				 int trip, int *temp)
 {
 	struct acpi_thermal *tz = thermal->devdata;
 	int i;
@@ -1039,31 +1049,40 @@ static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
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
 
@@ -1071,7 +1090,7 @@ static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 }
 
 static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
-				unsigned long *temperature) {
+				int *temperature) {
 	struct acpi_thermal *tz = thermal->devdata;
 
 	if (tz->trips.critical.flags.valid) {
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index e8a51a1..bac2901 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -358,26 +358,30 @@ static struct output_properties acpi_output_properties = {
 
 
 /* thermal cooling device callbacks */
-static int video_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+static int video_get_max_state(struct thermal_cooling_device *cdev, unsigned
+			       int *state)
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_video_device *video = acpi_driver_data(device);
 
-	return sprintf(buf, "%d\n", video->brightness->count - 3);
+	*state = video->brightness->count - 3;
+	return 0;
 }
 
-static int video_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+static int video_get_cur_state(struct thermal_cooling_device *cdev, unsigned
+			       int *state)
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_video_device *video = acpi_driver_data(device);
 	unsigned long level;
-	int state;
+	int offset;
 
 	acpi_video_device_lcd_get_level_current(video, &level);
-	for (state = 2; state < video->brightness->count; state++)
-		if (level == video->brightness->levels[state])
-			return sprintf(buf, "%d\n",
-				       video->brightness->count - state - 1);
+	for (offset = 2; offset < video->brightness->count; offset++)
+		if (level == video->brightness->levels[offset]) {
+			*state = video->brightness->count - offset - 1;
+			return 0;
+		}
 
 	return -EINVAL;
 }
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index fe07462..8ca2f59 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -104,11 +104,18 @@ static ssize_t
 temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int temperature;
+	int ret;
 
 	if (!tz->ops->get_temp)
 		return -EPERM;
 
-	return tz->ops->get_temp(tz, buf);
+	ret = tz->ops->get_temp(tz, &temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", temperature);
 }
 
 static ssize_t
@@ -145,6 +152,8 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
 	int trip;
+	enum thermal_trip_t trip_type;
+	int ret;
 
 	if (!tz->ops->get_trip_type)
 		return -EPERM;
@@ -152,7 +161,28 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 	if (!sscanf(attr->attr.name, "trip_point_%d_type", &trip))
 		return -EINVAL;
 
-	return tz->ops->get_trip_type(tz, trip, buf);
+
+	ret = tz->ops->get_trip_type(tz, trip, &trip_type);
+	if (ret)
+		return ret;
+
+	switch (trip_type) {
+	case THERMAL_TRIP_CRITICAL:
+		return sprintf(buf, "critical\n");
+		break;
+	case THERMAL_TRIP_HOT:
+		return sprintf(buf, "hot\n");
+		break;
+	case THERMAL_TRIP_PASSIVE:
+		return sprintf(buf, "passive\n");
+		break;
+	case THERMAL_TRIP_ACTIVE:
+		return sprintf(buf, "active\n");
+		break;
+	default:
+		return sprintf(buf, "unknown\n");
+		break;
+	}
 }
 
 static ssize_t
@@ -160,7 +190,8 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip;
+	int trip, ret;
+	int temperature;
 
 	if (!tz->ops->get_trip_temp)
 		return -EPERM;
@@ -168,7 +199,12 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 	if (!sscanf(attr->attr.name, "trip_point_%d_temp", &trip))
 		return -EINVAL;
 
-	return tz->ops->get_trip_temp(tz, trip, buf);
+	ret = tz->ops->get_trip_temp(tz, trip, &temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", temperature);
 }
 
 static DEVICE_ATTR(type, 0444, type_show, NULL);
@@ -236,8 +272,12 @@ thermal_cooling_device_max_state_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	int state, ret;
 
-	return cdev->ops->get_max_state(cdev, buf);
+	ret = cdev->ops->get_max_state(cdev, &state);
+	if (ret)
+		return ret;
+	return sprintf(buf, "%d\n", state);
 }
 
 static ssize_t
@@ -245,8 +285,12 @@ thermal_cooling_device_cur_state_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	int state, ret;
 
-	return cdev->ops->get_cur_state(cdev, buf);
+	ret = cdev->ops->get_cur_state(cdev, &state);
+	if (ret)
+		return ret;
+	return sprintf(buf, "%d\n", state);
 }
 
 static ssize_t
@@ -312,13 +356,20 @@ static DEVICE_ATTR(name, 0444, name_show, NULL);
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
@@ -330,8 +381,14 @@ temp_crit_show(struct device *dev, struct device_attribute *attr,
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
index 917707e..9e3475a 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -28,6 +28,10 @@
 #include <linux/idr.h>
 #include <linux/device.h>
 
+enum thermal_trip_t { THERMAL_TRIP_CRITICAL, THERMAL_TRIP_HOT,
+		      THERMAL_TRIP_PASSIVE, THERMAL_TRIP_ACTIVE
+};
+
 struct thermal_zone_device;
 struct thermal_cooling_device;
 
@@ -36,17 +40,19 @@ struct thermal_zone_device_ops {
 		     struct thermal_cooling_device *);
 	int (*unbind) (struct thermal_zone_device *,
 		       struct thermal_cooling_device *);
-	int (*get_temp) (struct thermal_zone_device *, char *);
+	int (*get_temp) (struct thermal_zone_device *, int *);
 	int (*get_mode) (struct thermal_zone_device *, char *);
 	int (*set_mode) (struct thermal_zone_device *, const char *);
-	int (*get_trip_type) (struct thermal_zone_device *, int, char *);
-	int (*get_trip_temp) (struct thermal_zone_device *, int, char *);
-	int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
+	int (*get_trip_type) (struct thermal_zone_device *, int,
+			      enum thermal_trip_t *);
+	int (*get_trip_temp) (struct thermal_zone_device *, int,
+			      int *);
+	int (*get_crit_temp) (struct thermal_zone_device *, int *);
 };
 
 struct thermal_cooling_device_ops {
-	int (*get_max_state) (struct thermal_cooling_device *, char *);
-	int (*get_cur_state) (struct thermal_cooling_device *, char *);
+	int (*get_max_state) (struct thermal_cooling_device *, unsigned int *);
+	int (*get_cur_state) (struct thermal_cooling_device *, unsigned int *);
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned int);
 };
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
