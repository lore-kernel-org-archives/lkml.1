Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbYFPIz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbYFPIz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYFPIzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:55:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60972 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYFPIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:55:48 -0400
Date: Mon, 16 Jun 2008 09:55:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rui.zhang@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Clean up thermal API
Message-ID: <20080616085544.GA17813@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611100647.GA20013@srcf.ucam.org>
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

This incorporates both the previous patches and has the whitespace fixes

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 6cf10cb..490a998 100644
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
index 504385b..bd6072d 100644
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
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5e5dda3..d8d7596 100644
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
index 6098787..7aaa8e3 100644
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
+	ret = tz->ops->get_temp(tz, &temperature);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%ld\n", temperature);
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
+	return sprintf(buf, "%ld\n", temperature);
 }
 
 static DEVICE_ATTR(type, 0444, type_show, NULL);
@@ -236,8 +249,12 @@ thermal_cooling_device_max_state_show(struct device *dev,
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
@@ -245,8 +262,12 @@ thermal_cooling_device_cur_state_show(struct device *dev,
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
@@ -312,13 +333,20 @@ static DEVICE_ATTR(name, 0444, name_show, NULL);
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
@@ -330,8 +358,14 @@ temp_crit_show(struct device *dev, struct device_attribute *attr,
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
index 06d3e6e..5185781 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -36,17 +36,18 @@ struct thermal_zone_device_ops {
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
 
 struct thermal_cooling_device_ops {
-	int (*get_max_state) (struct thermal_cooling_device *, char *);
-	int (*get_cur_state) (struct thermal_cooling_device *, char *);
+	int (*get_max_state) (struct thermal_cooling_device *, unsigned int *);
+	int (*get_cur_state) (struct thermal_cooling_device *, unsigned int *);
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned int);
 };

-- 
Matthew Garrett | mjg59@srcf.ucam.org
