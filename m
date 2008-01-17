Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYAQHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYAQHsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYAQHqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:29318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbYAQHqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:17 -0500
X-ExtLoop1: 1
Subject: [PATCH 3/10] ACPI: ACPI thermal zone handle notification correctly
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:25 +0800
Message-Id: <1200556285.2935.125.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Change the ACPI thermal action upon notification 0x81 and 0x82.

According to the ACPI spec, we should:
re-evaluate _PSV and _ACx methods upon notification 0x81
re-evaluate _PSL and _ALx and _TZD upon notificaiton 0x82.
But the current code re-evaluates all the trip points for 0x81 while
only re-evaluates _TZD for 0x82.

Fix this violation of ACPI spec.

TODO: devices in _PSL, _ALx and _TZD may change after a notification 0x82.
      At this time, we need to re-bind the cooling devices with the thermal zone.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com> 
---
 drivers/acpi/thermal.c |  323 +++++++++++++++++++++++++++----------------------
 1 file changed, 183 insertions(+), 140 deletions(-)

Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -323,173 +323,221 @@ static int acpi_thermal_set_cooling_mode
 	return 0;
 }
 
-static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
+#define ACPI_TRIPS_CRITICAL	0x01
+#define ACPI_TRIPS_HOT		0x02
+#define ACPI_TRIPS_PASSIVE	0x04
+#define ACPI_TRIPS_ACTIVE	0x08
+#define ACPI_TRIPS_DEVICES	0x10
+
+#define ACPI_TRIPS_REFRESH_THRESHOLDS	(ACPI_TRIPS_PASSIVE | ACPI_TRIPS_ACTIVE)
+#define ACPI_TRIPS_REFRESH_DEVICES	ACPI_TRIPS_DEVICES
+
+#define ACPI_TRIPS_INIT      (ACPI_TRIPS_CRITICAL | ACPI_TRIPS_HOT |	\
+			      ACPI_TRIPS_PASSIVE | ACPI_TRIPS_ACTIVE |	\
+			      ACPI_TRIPS_DEVICES)
+
+/*
+ * This exception is thrown out in two cases:
+ * 1.An invalid trip point becomes invalid or a valid trip point becomes invalid
+ *   when re-evaluating the AML code.
+ * 2.TODO: Devices listed in _PSL, _ALx, _TZD may change.
+ *   We need to re-bind the cooling devices of a thermal zone when this occurs.
+ */
+#define ACPI_THERMAL_TRIPS_EXCEPTION(flags, str)	\
+do {	\
+	if (flags != ACPI_TRIPS_INIT)	\
+		ACPI_EXCEPTION((AE_INFO, AE_ERROR,	\
+		"ACPI thermal trip point %s changed\n"	\
+		"Please send acpidump to linux-acpi@vger.kernel.org\n", str)); \
+} while (0)
+
+static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 {
 	acpi_status status = AE_OK;
-	int i = 0;
-
-
-	if (!tz)
-		return -EINVAL;
+	struct acpi_handle_list devices;
+	int valid = 0;
+	int i;
 
 	/* Critical Shutdown (required) */
-
-	status = acpi_evaluate_integer(tz->device->handle, "_CRT", NULL,
-				       &tz->trips.critical.temperature);
-	if (ACPI_FAILURE(status)) {
-		tz->trips.critical.flags.valid = 0;
-		ACPI_EXCEPTION((AE_INFO, status, "No critical threshold"));
-		return -ENODEV;
-	} else {
-		tz->trips.critical.flags.valid = 1;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Found critical threshold [%lu]\n",
-				  tz->trips.critical.temperature));
-	}
-
-	if (tz->trips.critical.flags.valid == 1) {
-		if (crt == -1) {
+	if (flag & ACPI_TRIPS_CRITICAL) {
+		status = acpi_evaluate_integer(tz->device->handle,
+				"_CRT", NULL, &tz->trips.critical.temperature);
+		if (ACPI_FAILURE(status)) {
 			tz->trips.critical.flags.valid = 0;
-		} else if (crt > 0) {
-			unsigned long crt_k = CELSIUS_TO_KELVIN(crt);
-
-			/*
-			 * Allow override to lower critical threshold
-			 */
-			if (crt_k < tz->trips.critical.temperature)
-				tz->trips.critical.temperature = crt_k;
+			ACPI_EXCEPTION((AE_INFO, status,
+					"No critical threshold"));
+			return -ENODEV;
+		} else {
+			tz->trips.critical.flags.valid = 1;
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+					"Found critical threshold [%lu]\n",
+					tz->trips.critical.temperature));
+		}
+		if (tz->trips.critical.flags.valid == 1) {
+			if (crt == -1) {
+				tz->trips.critical.flags.valid = 0;
+			} else if (crt > 0) {
+				unsigned long crt_k = CELSIUS_TO_KELVIN(crt);
+				/*
+				 * Allow override to lower critical threshold
+				 */
+				if (crt_k < tz->trips.critical.temperature)
+					tz->trips.critical.temperature = crt_k;
+			}
 		}
 	}
 
 	/* Critical Sleep (optional) */
-
-	status =
-	    acpi_evaluate_integer(tz->device->handle, "_HOT", NULL,
-				  &tz->trips.hot.temperature);
-	if (ACPI_FAILURE(status)) {
-		tz->trips.hot.flags.valid = 0;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No hot threshold\n"));
-	} else {
-		tz->trips.hot.flags.valid = 1;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Found hot threshold [%lu]\n",
-				  tz->trips.hot.temperature));
-	}
-
-	/* Passive: Processors (optional) */
-
-	if (psv == -1) {
-		status = AE_SUPPORT;
-	} else if (psv > 0) {
-		tz->trips.passive.temperature = CELSIUS_TO_KELVIN(psv);
-		status = AE_OK;
-	} else {
+	if (flag & ACPI_TRIPS_HOT) {
 		status = acpi_evaluate_integer(tz->device->handle,
-			"_PSV", NULL, &tz->trips.passive.temperature);
+				"_HOT", NULL, &tz->trips.hot.temperature);
+		if (ACPI_FAILURE(status)) {
+			tz->trips.hot.flags.valid = 0;
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+					"No hot threshold\n"));
+		} else {
+			tz->trips.hot.flags.valid = 1;
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+					"Found hot threshold [%lu]\n",
+					tz->trips.critical.temperature));
+		}
 	}
 
-	if (ACPI_FAILURE(status)) {
-		tz->trips.passive.flags.valid = 0;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No passive threshold\n"));
-	} else {
-		tz->trips.passive.flags.valid = 1;
-
-		status =
-		    acpi_evaluate_integer(tz->device->handle, "_TC1", NULL,
-					  &tz->trips.passive.tc1);
-		if (ACPI_FAILURE(status))
-			tz->trips.passive.flags.valid = 0;
-
-		status =
-		    acpi_evaluate_integer(tz->device->handle, "_TC2", NULL,
-					  &tz->trips.passive.tc2);
-		if (ACPI_FAILURE(status))
-			tz->trips.passive.flags.valid = 0;
+	/* Passive (optional) */
+	if (flag & ACPI_TRIPS_PASSIVE) {
+		valid = tz->trips.passive.flags.valid;
+		if (psv == -1) {
+			status = AE_SUPPORT;
+		} else if (psv > 0) {
+			tz->trips.passive.temperature = CELSIUS_TO_KELVIN(psv);
+			status = AE_OK;
+		} else {
+			status = acpi_evaluate_integer(tz->device->handle,
+				"_PSV", NULL, &tz->trips.passive.temperature);
+		}
 
-		status =
-		    acpi_evaluate_integer(tz->device->handle, "_TSP", NULL,
-					  &tz->trips.passive.tsp);
 		if (ACPI_FAILURE(status))
 			tz->trips.passive.flags.valid = 0;
-
-		status =
-		    acpi_evaluate_reference(tz->device->handle, "_PSL", NULL,
-					    &tz->trips.passive.devices);
+		else {
+			tz->trips.passive.flags.valid = 1;
+			if (flag == ACPI_TRIPS_INIT) {
+				status = acpi_evaluate_integer(
+						tz->device->handle, "_TC1",
+						NULL, &tz->trips.passive.tc1);
+				if (ACPI_FAILURE(status))
+					tz->trips.passive.flags.valid = 0;
+				status = acpi_evaluate_integer(
+						tz->device->handle, "_TC2",
+						NULL, &tz->trips.passive.tc2);
+				if (ACPI_FAILURE(status))
+					tz->trips.passive.flags.valid = 0;
+				status = acpi_evaluate_integer(
+						tz->device->handle, "_TSP",
+						NULL, &tz->trips.passive.tsp);
+				if (ACPI_FAILURE(status))
+					tz->trips.passive.flags.valid = 0;
+			}
+		}
+	}
+	if ((flag & ACPI_TRIPS_DEVICES) && tz->trips.passive.flags.valid) {
+		memset(&devices, 0, sizeof(struct acpi_handle_list));
+		status = acpi_evaluate_reference(tz->device->handle, "_PSL",
+							NULL, &devices);
 		if (ACPI_FAILURE(status))
 			tz->trips.passive.flags.valid = 0;
-
-		if (!tz->trips.passive.flags.valid)
-			printk(KERN_WARNING PREFIX "Invalid passive threshold\n");
 		else
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "Found passive threshold [%lu]\n",
-					  tz->trips.passive.temperature));
-	}
+			tz->trips.passive.flags.valid = 1;
 
-	/* Active: Fans, etc. (optional) */
+		if (memcmp(&tz->trips.passive.devices, &devices,
+				sizeof(struct acpi_handle_list))) {
+			memcpy(&tz->trips.passive.devices, &devices,
+				sizeof(struct acpi_handle_list));
+			ACPI_THERMAL_TRIPS_EXCEPTION(flag, "device");
+		}
+	}
+	if ((flag & ACPI_TRIPS_PASSIVE) || (flag & ACPI_TRIPS_DEVICES)) {
+		if (valid != tz->trips.passive.flags.valid)
+				ACPI_THERMAL_TRIPS_EXCEPTION(flag, "state");
+	}
 
+	/* Active (optional) */
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
-
 		char name[5] = { '_', 'A', 'C', ('0' + i), '\0' };
+		valid = tz->trips.active[i].flags.valid;
 
 		if (act == -1)
-			break;	/* disable all active trip points */
-
-		status = acpi_evaluate_integer(tz->device->handle,
-			name, NULL, &tz->trips.active[i].temperature);
+			break; /* disable all active trip points */
 
-		if (ACPI_FAILURE(status)) {
-			if (i == 0)	/* no active trip points */
-				break;
-			if (act <= 0)	/* no override requested */
+		if (flag & ACPI_TRIPS_ACTIVE) {
+			status = acpi_evaluate_integer(tz->device->handle,
+				name, NULL, &tz->trips.active[i].temperature);
+			if (ACPI_FAILURE(status)) {
+				tz->trips.active[i].flags.valid = 0;
+				if (i == 0)
+					break;
+				if (act <= 0)
+					break;
+				if (i == 1)
+					tz->trips.active[0].temperature =
+						CELSIUS_TO_KELVIN(act);
+				else
+					/*
+					 * Don't allow override higher than
+					 * the next higher trip point
+					 */
+					tz->trips.active[i - 1].temperature =
+						(tz->trips.active[i - 2].temperature <
+						CELSIUS_TO_KELVIN(act) ?
+						tz->trips.active[i - 2].temperature :
+						CELSIUS_TO_KELVIN(act));
 				break;
-			if (i == 1) {	/* 1 trip point */
-				tz->trips.active[0].temperature =
-					CELSIUS_TO_KELVIN(act);
-			} else {	/* multiple trips */
-				/*
-				 * Don't allow override higher than
-				 * the next higher trip point
-				 */
-				tz->trips.active[i - 1].temperature =
-				    (tz->trips.active[i - 2].temperature <
-					CELSIUS_TO_KELVIN(act) ?
-					tz->trips.active[i - 2].temperature :
-					CELSIUS_TO_KELVIN(act));
-			}
-			break;
+			} else
+				tz->trips.active[i].flags.valid = 1;
 		}
 
 		name[2] = 'L';
-		status =
-		    acpi_evaluate_reference(tz->device->handle, name, NULL,
-					    &tz->trips.active[i].devices);
-		if (ACPI_SUCCESS(status)) {
-			tz->trips.active[i].flags.valid = 1;
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "Found active threshold [%d]:[%lu]\n",
-					  i, tz->trips.active[i].temperature));
-		} else
-			ACPI_EXCEPTION((AE_INFO, status,
-					"Invalid active threshold [%d]", i));
+		if ((flag & ACPI_TRIPS_DEVICES) && tz->trips.active[i].flags.valid ) {
+			memset(&devices, 0, sizeof(struct acpi_handle_list));
+			status = acpi_evaluate_reference(tz->device->handle,
+						name, NULL, &devices);
+			if (ACPI_FAILURE(status))
+				tz->trips.active[i].flags.valid = 0;
+			else
+				tz->trips.active[i].flags.valid = 1;
+
+			if (memcmp(&tz->trips.active[i].devices, &devices,
+					sizeof(struct acpi_handle_list))) {
+				memcpy(&tz->trips.active[i].devices, &devices,
+					sizeof(struct acpi_handle_list));
+				ACPI_THERMAL_TRIPS_EXCEPTION(flag, "device");
+			}
+		}
+		if ((flag & ACPI_TRIPS_ACTIVE) || (flag & ACPI_TRIPS_DEVICES))
+			if (valid != tz->trips.active[i].flags.valid)
+				ACPI_THERMAL_TRIPS_EXCEPTION(flag, "state");
+
+		if (!tz->trips.active[i].flags.valid)
+			break;
+	}
+
+	if (flag & ACPI_TRIPS_DEVICES) {
+		memset(&devices, 0, sizeof(struct acpi_handle_list));
+		status = acpi_evaluate_reference(tz->device->handle, "_TZD",
+						NULL, &devices);
+		if (memcmp(&tz->devices, &devices,
+				sizeof(struct acpi_handle_list))) {
+			memcpy(&tz->devices, &devices,
+				sizeof(struct acpi_handle_list));
+			ACPI_THERMAL_TRIPS_EXCEPTION(flag, "device");
+		}
 	}
 
 	return 0;
 }
 
-static int acpi_thermal_get_devices(struct acpi_thermal *tz)
+static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 {
-	acpi_status status = AE_OK;
-
-
-	if (!tz)
-		return -EINVAL;
-
-	status =
-	    acpi_evaluate_reference(tz->device->handle, "_TZD", NULL, &tz->devices);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	return 0;
+	return acpi_thermal_trips_update(tz, ACPI_TRIPS_INIT);
 }
 
 static int acpi_thermal_critical(struct acpi_thermal *tz)
@@ -1453,15 +1501,15 @@ static void acpi_thermal_notify(acpi_han
 		acpi_thermal_check(tz);
 		break;
 	case ACPI_THERMAL_NOTIFY_THRESHOLDS:
-		acpi_thermal_get_trip_points(tz);
+		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_THRESHOLDS);
 		acpi_thermal_check(tz);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  device->dev.bus_id, event, 0);
 		break;
 	case ACPI_THERMAL_NOTIFY_DEVICES:
-		if (tz->flags.devices)
-			acpi_thermal_get_devices(tz);
+		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_DEVICES);
+		acpi_thermal_check(tz);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  device->dev.bus_id, event, 0);
@@ -1504,11 +1552,6 @@ static int acpi_thermal_get_info(struct 
 	else
 		acpi_thermal_get_polling_frequency(tz);
 
-	/* Get devices in this thermal zone [_TZD] (optional) */
-	result = acpi_thermal_get_devices(tz);
-	if (!result)
-		tz->flags.devices = 1;
-
 	return 0;
 }
 


