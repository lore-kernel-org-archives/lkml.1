Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYJASnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYJASnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYJASm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:42:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60396 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYJASm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:42:57 -0400
Date: Wed, 1 Oct 2008 19:42:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rui.zhang@intel.com, pavel@suse.cz
Subject: Re: [RFC] thermal: Move trip point handling code from ACPI to generic code
Message-ID: <20081001184251.GB3330@srcf.ucam.org>
References: <20081001120420.GA29479@srcf.ucam.org> <20081001121344.GB29479@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001121344.GB29479@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here's a slightly updated version. Couple of bugfixes, added support 
for the missing features. Would be nice if someone else could give this 
a go.

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 2e4e2a1..1302851 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -37,7 +37,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/proc_fs.h>
-#include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/kmod.h>
 #include <linux/seq_file.h>
@@ -191,7 +190,6 @@ struct acpi_thermal {
 	struct acpi_thermal_state state;
 	struct acpi_thermal_trips trips;
 	struct acpi_handle_list devices;
-	struct timer_list timer;
 	struct thermal_zone_device *thermal_zone;
 	int tz_enabled;
 	struct mutex lock;
@@ -292,6 +290,11 @@ static int acpi_thermal_set_polling(struct acpi_thermal *tz, int seconds)
 
 	tz->polling_frequency = seconds * 10;	/* Convert value to deci-seconds */
 
+	tz->thermal_zone->polling_delay = seconds * 1000;
+	
+	if (tz->tz_enabled)
+		thermal_zone_device_update(tz->thermal_zone);
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "Polling frequency set to %lu seconds\n",
 			  tz->polling_frequency/10));
@@ -549,386 +552,11 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 	return acpi_thermal_trips_update(tz, ACPI_TRIPS_INIT);
 }
 
-static int acpi_thermal_critical(struct acpi_thermal *tz)
-{
-	if (!tz || !tz->trips.critical.flags.valid)
-		return -EINVAL;
-
-	if (tz->temperature >= tz->trips.critical.temperature) {
-		printk(KERN_WARNING PREFIX "Critical trip point\n");
-		tz->trips.critical.flags.enabled = 1;
-	} else if (tz->trips.critical.flags.enabled)
-		tz->trips.critical.flags.enabled = 0;
-
-	acpi_bus_generate_proc_event(tz->device, ACPI_THERMAL_NOTIFY_CRITICAL,
-				tz->trips.critical.flags.enabled);
-	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
-					  tz->device->dev.bus_id,
-					  ACPI_THERMAL_NOTIFY_CRITICAL,
-					  tz->trips.critical.flags.enabled);
-
-	/* take no action if nocrt is set */
-	if(!nocrt) {
-		printk(KERN_EMERG
-			"Critical temperature reached (%ld C), shutting down.\n",
-			KELVIN_TO_CELSIUS(tz->temperature));
-		orderly_poweroff(true);
-	}
-
-	return 0;
-}
-
-static int acpi_thermal_hot(struct acpi_thermal *tz)
-{
-	if (!tz || !tz->trips.hot.flags.valid)
-		return -EINVAL;
-
-	if (tz->temperature >= tz->trips.hot.temperature) {
-		printk(KERN_WARNING PREFIX "Hot trip point\n");
-		tz->trips.hot.flags.enabled = 1;
-	} else if (tz->trips.hot.flags.enabled)
-		tz->trips.hot.flags.enabled = 0;
-
-	acpi_bus_generate_proc_event(tz->device, ACPI_THERMAL_NOTIFY_HOT,
-				tz->trips.hot.flags.enabled);
-	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
-					  tz->device->dev.bus_id,
-					  ACPI_THERMAL_NOTIFY_HOT,
-					  tz->trips.hot.flags.enabled);
-
-	/* TBD: Call user-mode "sleep(S4)" function if nocrt is cleared */
-
-	return 0;
-}
-
-static void acpi_thermal_passive(struct acpi_thermal *tz)
-{
-	int result = 1;
-	struct acpi_thermal_passive *passive = NULL;
-	int trend = 0;
-	int i = 0;
-
-
-	if (!tz || !tz->trips.passive.flags.valid)
-		return;
-
-	passive = &(tz->trips.passive);
-
-	/*
-	 * Above Trip?
-	 * -----------
-	 * Calculate the thermal trend (using the passive cooling equation)
-	 * and modify the performance limit for all passive cooling devices
-	 * accordingly.  Note that we assume symmetry.
-	 */
-	if (tz->temperature >= passive->temperature) {
-		trend =
-		    (passive->tc1 * (tz->temperature - tz->last_temperature)) +
-		    (passive->tc2 * (tz->temperature - passive->temperature));
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "trend[%d]=(tc1[%lu]*(tmp[%lu]-last[%lu]))+(tc2[%lu]*(tmp[%lu]-psv[%lu]))\n",
-				  trend, passive->tc1, tz->temperature,
-				  tz->last_temperature, passive->tc2,
-				  tz->temperature, passive->temperature));
-		passive->flags.enabled = 1;
-		/* Heating up? */
-		if (trend > 0)
-			for (i = 0; i < passive->devices.count; i++)
-				acpi_processor_set_thermal_limit(passive->
-								 devices.
-								 handles[i],
-								 ACPI_PROCESSOR_LIMIT_INCREMENT);
-		/* Cooling off? */
-		else if (trend < 0) {
-			for (i = 0; i < passive->devices.count; i++)
-				/*
-				 * assume that we are on highest
-				 * freq/lowest thrott and can leave
-				 * passive mode, even in error case
-				 */
-				if (!acpi_processor_set_thermal_limit
-				    (passive->devices.handles[i],
-				     ACPI_PROCESSOR_LIMIT_DECREMENT))
-					result = 0;
-			/*
-			 * Leave cooling mode, even if the temp might
-			 * higher than trip point This is because some
-			 * machines might have long thermal polling
-			 * frequencies (tsp) defined. We will fall back
-			 * into passive mode in next cycle (probably quicker)
-			 */
-			if (result) {
-				passive->flags.enabled = 0;
-				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-						  "Disabling passive cooling, still above threshold,"
-						  " but we are cooling down\n"));
-			}
-		}
-		return;
-	}
-
-	/*
-	 * Below Trip?
-	 * -----------
-	 * Implement passive cooling hysteresis to slowly increase performance
-	 * and avoid thrashing around the passive trip point.  Note that we
-	 * assume symmetry.
-	 */
-	if (!passive->flags.enabled)
-		return;
-	for (i = 0; i < passive->devices.count; i++)
-		if (!acpi_processor_set_thermal_limit
-		    (passive->devices.handles[i],
-		     ACPI_PROCESSOR_LIMIT_DECREMENT))
-			result = 0;
-	if (result) {
-		passive->flags.enabled = 0;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Disabling passive cooling (zone is cool)\n"));
-	}
-}
-
-static void acpi_thermal_active(struct acpi_thermal *tz)
-{
-	int result = 0;
-	struct acpi_thermal_active *active = NULL;
-	int i = 0;
-	int j = 0;
-	unsigned long maxtemp = 0;
-
-
-	if (!tz)
-		return;
-
-	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
-		active = &(tz->trips.active[i]);
-		if (!active || !active->flags.valid)
-			break;
-		if (tz->temperature >= active->temperature) {
-			/*
-			 * Above Threshold?
-			 * ----------------
-			 * If not already enabled, turn ON all cooling devices
-			 * associated with this active threshold.
-			 */
-			if (active->temperature > maxtemp)
-				tz->state.active_index = i;
-			maxtemp = active->temperature;
-			if (active->flags.enabled)
-				continue;
-			for (j = 0; j < active->devices.count; j++) {
-				result =
-				    acpi_bus_set_power(active->devices.
-						       handles[j],
-						       ACPI_STATE_D0);
-				if (result) {
-					printk(KERN_WARNING PREFIX
-						      "Unable to turn cooling device [%p] 'on'\n",
-						      active->devices.
-						      handles[j]);
-					continue;
-				}
-				active->flags.enabled = 1;
-				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-						  "Cooling device [%p] now 'on'\n",
-						  active->devices.handles[j]));
-			}
-			continue;
-		}
-		if (!active->flags.enabled)
-			continue;
-		/*
-		 * Below Threshold?
-		 * ----------------
-		 * Turn OFF all cooling devices associated with this
-		 * threshold.
-		 */
-		for (j = 0; j < active->devices.count; j++) {
-			result = acpi_bus_set_power(active->devices.handles[j],
-						    ACPI_STATE_D3);
-			if (result) {
-				printk(KERN_WARNING PREFIX
-					      "Unable to turn cooling device [%p] 'off'\n",
-					      active->devices.handles[j]);
-				continue;
-			}
-			active->flags.enabled = 0;
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "Cooling device [%p] now 'off'\n",
-					  active->devices.handles[j]));
-		}
-	}
-}
-
-static void acpi_thermal_check(void *context);
-
-static void acpi_thermal_run(unsigned long data)
-{
-	struct acpi_thermal *tz = (struct acpi_thermal *)data;
-	if (!tz->zombie)
-		acpi_os_execute(OSL_GPE_HANDLER, acpi_thermal_check, (void *)data);
-}
-
-static void acpi_thermal_active_off(void *data)
-{
-	int result = 0;
-	struct acpi_thermal *tz = data;
-	int i = 0;
-	int j = 0;
-	struct acpi_thermal_active *active = NULL;
-
-	if (!tz) {
-		printk(KERN_ERR PREFIX "Invalid (NULL) context\n");
-		return;
-	}
-
-	result = acpi_thermal_get_temperature(tz);
-	if (result)
-		return;
-
-	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
-		active = &(tz->trips.active[i]);
-		if (!active || !active->flags.valid)
-			break;
-		if (tz->temperature >= active->temperature) {
-			/*
-			 * If the thermal temperature is greater than the
-			 * active threshod, unnecessary to turn off the
-			 * the active cooling device.
-			 */
-			continue;
-		}
-		/*
-		 * Below Threshold?
-		 * ----------------
-		 * Turn OFF all cooling devices associated with this
-		 * threshold.
-		 */
-		for (j = 0; j < active->devices.count; j++)
-			result = acpi_bus_set_power(active->devices.handles[j],
-						    ACPI_STATE_D3);
-	}
-}
-
 static void acpi_thermal_check(void *data)
 {
-	int result = 0;
 	struct acpi_thermal *tz = data;
-	unsigned long sleep_time = 0;
-	unsigned long timeout_jiffies = 0;
-	int i = 0;
-	struct acpi_thermal_state state;
-
-
-	if (!tz) {
-		printk(KERN_ERR PREFIX "Invalid (NULL) context\n");
-		return;
-	}
-
-	/* Check if someone else is already running */
-	if (!mutex_trylock(&tz->lock))
-		return;
-
-	state = tz->state;
-
-	result = acpi_thermal_get_temperature(tz);
-	if (result)
-		goto unlock;
-
-	if (!tz->tz_enabled)
-		goto unlock;
-
-	memset(&tz->state, 0, sizeof(tz->state));
-
-	/*
-	 * Check Trip Points
-	 * -----------------
-	 * Compare the current temperature to the trip point values to see
-	 * if we've entered one of the thermal policy states.  Note that
-	 * this function determines when a state is entered, but the 
-	 * individual policy decides when it is exited (e.g. hysteresis).
-	 */
-	if (tz->trips.critical.flags.valid)
-		state.critical |=
-		    (tz->temperature >= tz->trips.critical.temperature);
-	if (tz->trips.hot.flags.valid)
-		state.hot |= (tz->temperature >= tz->trips.hot.temperature);
-	if (tz->trips.passive.flags.valid)
-		state.passive |=
-		    (tz->temperature >= tz->trips.passive.temperature);
-	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++)
-		if (tz->trips.active[i].flags.valid)
-			state.active |=
-			    (tz->temperature >=
-			     tz->trips.active[i].temperature);
-
-	/*
-	 * Invoke Policy
-	 * -------------
-	 * Separated from the above check to allow individual policy to 
-	 * determine when to exit a given state.
-	 */
-	if (state.critical)
-		acpi_thermal_critical(tz);
-	if (state.hot)
-		acpi_thermal_hot(tz);
-	if (state.passive)
-		acpi_thermal_passive(tz);
-	if (state.active)
-		acpi_thermal_active(tz);
 
-	/*
-	 * Calculate State
-	 * ---------------
-	 * Again, separated from the above two to allow independent policy
-	 * decisions.
-	 */
-	tz->state.critical = tz->trips.critical.flags.enabled;
-	tz->state.hot = tz->trips.hot.flags.enabled;
-	tz->state.passive = tz->trips.passive.flags.enabled;
-	tz->state.active = 0;
-	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++)
-		tz->state.active |= tz->trips.active[i].flags.enabled;
-
-	/*
-	 * Calculate Sleep Time
-	 * --------------------
-	 * If we're in the passive state, use _TSP's value.  Otherwise
-	 * use the default polling frequency (e.g. _TZP).  If no polling
-	 * frequency is specified then we'll wait forever (at least until
-	 * a thermal event occurs).  Note that _TSP and _TZD values are
-	 * given in 1/10th seconds (we must covert to milliseconds).
-	 */
-	if (tz->state.passive) {
-		sleep_time = tz->trips.passive.tsp * 100;
-		timeout_jiffies =  jiffies + (HZ * sleep_time) / 1000;
-	} else if (tz->polling_frequency > 0) {
-		sleep_time = tz->polling_frequency * 100;
-		timeout_jiffies =  round_jiffies(jiffies + (HZ * sleep_time) / 1000);
-	}
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "%s: temperature[%lu] sleep[%lu]\n",
-			  tz->name, tz->temperature, sleep_time));
-
-	/*
-	 * Schedule Next Poll
-	 * ------------------
-	 */
-	if (!sleep_time) {
-		if (timer_pending(&(tz->timer)))
-			del_timer(&(tz->timer));
-	} else {
-		if (timer_pending(&(tz->timer)))
-			mod_timer(&(tz->timer), timeout_jiffies);
-		else {
-			tz->timer.data = (unsigned long)tz;
-			tz->timer.function = acpi_thermal_run;
-			tz->timer.expires = timeout_jiffies;
-			add_timer(&(tz->timer));
-		}
-	}
-      unlock:
-	mutex_unlock(&tz->lock);
+	thermal_zone_device_update(tz->thermal_zone);
 }
 
 /* sys I/F for generic thermal sysfs support */
@@ -1098,6 +726,29 @@ static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 		return -EINVAL;
 }
 
+static int thermal_notify(struct thermal_zone_device *thermal, int trip,
+			   enum thermal_trip_t trip_type)
+{
+	u8 type = 0;
+	struct acpi_thermal *tz = thermal->devdata;
+
+	if (trip_type == THERMAL_TRIP_CRITICAL)
+		type = ACPI_THERMAL_NOTIFY_CRITICAL;
+	else if (trip_type == THERMAL_TRIP_HOT)
+		type = ACPI_THERMAL_NOTIFY_HOT;
+	else
+		return 0;
+
+	acpi_bus_generate_proc_event(tz->device, type, 1);
+	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
+					tz->device->dev.bus_id, type, 1);
+
+	if (trip_type == THERMAL_TRIP_CRITICAL && nocrt)
+		return 1;
+
+	return 0;
+}
+
 typedef int (*cb)(struct thermal_zone_device *, int,
 		  struct thermal_cooling_device *);
 static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
@@ -1190,6 +841,7 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.get_trip_type = thermal_get_trip_type,
 	.get_trip_temp = thermal_get_trip_temp,
 	.get_crit_temp = thermal_get_crit_temp,
+	.notify = thermal_notify,
 };
 
 static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
@@ -1210,8 +862,21 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
 			tz->trips.active[i].flags.valid; i++, trips++);
-	tz->thermal_zone = thermal_zone_device_register("acpitz",
-					trips, tz, &acpi_thermal_zone_ops);
+
+	if (tz->trips.passive.flags.valid)
+		tz->thermal_zone =
+			thermal_zone_device_register("acpitz", trips, tz,
+						     &acpi_thermal_zone_ops,
+						     tz->trips.passive.tc1,
+						     tz->trips.passive.tc2,
+						     tz->trips.passive.tsp*100,
+						     tz->polling_frequency*100);
+	else
+		tz->thermal_zone =
+			thermal_zone_device_register("acpitz", trips, tz,
+						     &acpi_thermal_zone_ops,
+						     0, 0, 0,
+						     tz->polling_frequency);
 	if (IS_ERR(tz->thermal_zone))
 		return -ENODEV;
 
@@ -1443,13 +1108,13 @@ static int acpi_thermal_polling_seq_show(struct seq_file *seq, void *offset)
 	if (!tz)
 		goto end;
 
-	if (!tz->polling_frequency) {
+	if (!tz->thermal_zone->polling_delay) {
 		seq_puts(seq, "<polling disabled>\n");
 		goto end;
 	}
 
-	seq_printf(seq, "polling frequency:       %lu seconds\n",
-		   (tz->polling_frequency / 10));
+	seq_printf(seq, "polling frequency:       %d seconds\n",
+		   (tz->thermal_zone->polling_delay / 1000));
 
       end:
 	return 0;
@@ -1679,12 +1344,6 @@ static int acpi_thermal_add(struct acpi_device *device)
 	if (result)
 		goto unregister_thermal_zone;
 
-	init_timer(&tz->timer);
-
-	acpi_thermal_active_off(tz);
-
-	acpi_thermal_check(tz);
-
 	status = acpi_install_notify_handler(device->handle,
 					     ACPI_DEVICE_NOTIFY,
 					     acpi_thermal_notify, tz);
@@ -1713,36 +1372,15 @@ static int acpi_thermal_remove(struct acpi_device *device, int type)
 	acpi_status status = AE_OK;
 	struct acpi_thermal *tz = NULL;
 
-
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
 	tz = acpi_driver_data(device);
 
-	/* avoid timer adding new defer task */
-	tz->zombie = 1;
-	/* wait for running timer (on other CPUs) finish */
-	del_timer_sync(&(tz->timer));
-	/* synchronize deferred task */
-	acpi_os_wait_events_complete(NULL);
-	/* deferred task may reinsert timer */
-	del_timer_sync(&(tz->timer));
-
 	status = acpi_remove_notify_handler(device->handle,
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_thermal_notify);
 
-	/* Terminate policy */
-	if (tz->trips.passive.flags.valid && tz->trips.passive.flags.enabled) {
-		tz->trips.passive.flags.enabled = 0;
-		acpi_thermal_passive(tz);
-	}
-	if (tz->trips.active[0].flags.valid
-	    && tz->trips.active[0].flags.enabled) {
-		tz->trips.active[0].flags.enabled = 0;
-		acpi_thermal_active(tz);
-	}
-
 	acpi_thermal_remove_fs(device);
 	acpi_thermal_unregister_thermal_zone(tz);
 	mutex_destroy(&tz->lock);
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index c1f7e65..a97c541 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -30,6 +30,7 @@
 #include <linux/idr.h>
 #include <linux/thermal.h>
 #include <linux/spinlock.h>
+#include <linux/reboot.h>
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
@@ -179,7 +180,6 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 	if (!sscanf(attr->attr.name, "trip_point_%d_type", &trip))
 		return -EINVAL;
 
-
 	ret = tz->ops->get_trip_type(tz, trip, &trip_type);
 	if (ret)
 		return ret;
@@ -527,6 +527,99 @@ thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 }
 #endif
 
+static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
+					    int delay)
+{
+	cancel_delayed_work_sync(&(tz->poll_queue));
+
+	if (!delay)
+		return;
+
+	if (delay > 1000)
+		schedule_delayed_work(&(tz->poll_queue),
+					round_jiffies(delay * HZ));
+	else
+		schedule_delayed_work(&(tz->poll_queue), delay * HZ);
+}
+
+static void thermal_zone_device_passive(struct thermal_zone_device *tz,
+					int temp, int trip_temp, int trip)
+{
+	int trend = 0;
+	struct thermal_cooling_device_instance *instance;
+	struct thermal_cooling_device *cdev;
+	int state, max_state;
+
+	if (tz->passive == false)
+		return;
+
+	/*
+	 * Above Trip?
+	 * -----------
+	 * Calculate the thermal trend (using the passive cooling equation)
+	 * and modify the performance limit for all passive cooling devices
+	 * accordingly.  Note that we assume symmetry.
+	 */
+	if (temp >= trip_temp) {
+		tz->passive = true;
+
+		trend = (tz->tc1 * (temp - tz->last_temperature)) +
+			(tz->tc2 * (temp - trip_temp));
+
+		/* Heating up? */
+		if (trend > 0) {
+			list_for_each_entry(instance, &tz->cooling_devices,
+					    node) {
+				if (instance->trip != trip)
+					continue;
+				cdev = instance->cdev;
+				cdev->ops->get_cur_state(cdev, &state);
+				cdev->ops->get_max_state(cdev, &max_state);
+				if (state++ < max_state)
+					cdev->ops->set_cur_state(cdev, state);
+			}
+		} else if (trend < 0) { /* Cooling off? */
+			list_for_each_entry(instance, &tz->cooling_devices,
+					    node) {
+				if (instance->trip != trip)
+					continue;
+				cdev = instance->cdev;
+				cdev->ops->get_cur_state(cdev, &state);
+				cdev->ops->get_max_state(cdev, &max_state);
+				if (state > 0)
+					cdev->ops->set_cur_state(cdev, --state);
+			}
+			return;
+		}
+	}
+
+	/*
+	 * Below Trip?
+	 * -----------
+	 * Implement passive cooling hysteresis to slowly increase performance
+	 * and avoid thrashing around the passive trip point.  Note that we
+	 * assume symmetry.
+	 */
+	list_for_each_entry(instance, &tz->cooling_devices, node) {
+		if (instance->trip != trip)
+			continue;
+		cdev = instance->cdev;
+		cdev->ops->get_cur_state(cdev, &state);
+		cdev->ops->get_max_state(cdev, &max_state);
+		if (state > 0)
+			cdev->ops->set_cur_state(cdev, --state);
+		if (state == 0)
+			tz->passive = false;
+	}
+}
+
+static void thermal_zone_device_check(struct work_struct *work)
+{
+	struct thermal_zone_device *tz = container_of(work, struct
+						      thermal_zone_device,
+						      poll_queue.work);
+	thermal_zone_device_update(tz);
+}
 
 /**
  * thermal_zone_bind_cooling_device - bind a cooling device to a thermal zone
@@ -797,20 +890,98 @@ void thermal_cooling_device_unregister(struct
 EXPORT_SYMBOL(thermal_cooling_device_unregister);
 
 /**
+ * thermal_zone_device_update - force an update of a thermal zone's state
+ * @ttz:	the thermal zone to update
+ */
+
+void thermal_zone_device_update(struct thermal_zone_device *tz)
+{
+	int temp, trip_temp, count, ret = 0;
+	enum thermal_trip_t trip_type;
+	struct thermal_cooling_device_instance *instance;
+	struct thermal_cooling_device *cdev;
+
+	mutex_lock(&tz->lock);
+	
+	tz->ops->get_temp(tz, &temp);
+
+	for (count = 0; count < tz->trips; count++) {
+		tz->ops->get_trip_type(tz, count, &trip_type);
+		tz->ops->get_trip_temp(tz, count, &trip_temp);
+
+		switch (trip_type) {
+		case THERMAL_TRIP_CRITICAL:
+			if (temp > trip_temp) {
+				if (tz->ops->notify)
+					ret = tz->ops->notify(tz, count,
+							      trip_type);
+				if (!ret) {
+					printk(KERN_EMERG
+					       "Critical temperature reached (%d C), shutting down.\n",
+					       temp/1000);
+					orderly_poweroff(true);
+				}
+			}
+			break;
+		case THERMAL_TRIP_HOT:
+			if (temp > trip_temp)
+				if (tz->ops->notify)
+					tz->ops->notify(tz, count, trip_type);
+			break;
+		case THERMAL_TRIP_ACTIVE:
+			list_for_each_entry(instance, &tz->cooling_devices,
+					    node) {
+				if (instance->trip != count)
+					continue;
+
+				cdev = instance->cdev;
+
+				if (temp > trip_temp)
+					cdev->ops->set_cur_state(cdev, 1);
+				else
+					cdev->ops->set_cur_state(cdev, 0);
+			}
+			break;
+		case THERMAL_TRIP_PASSIVE:
+			thermal_zone_device_passive(tz, temp, trip_temp, count);
+			break;
+		}
+	}
+	tz->last_temperature = temp;
+	if (tz->passive)
+		thermal_zone_device_set_polling(tz, tz->passive_delay);
+	else if (tz->polling_delay)
+		thermal_zone_device_set_polling(tz, tz->polling_delay);
+	mutex_unlock(&tz->lock);
+}
+EXPORT_SYMBOL(thermal_zone_device_update);
+
+/**
  * thermal_zone_device_register - register a new thermal zone device
  * @type:	the thermal zone device type
  * @trips:	the number of trip points the thermal zone support
  * @devdata:	private device data
  * @ops:	standard thermal zone device callbacks
+ * @tc1:	thermal coefficient 1 for passive calculations
+ * @tc2:	thermal coefficient 2 for passive calculations
+ * @passive_delay: number of milliseconds to wait between polls when
+ *		   performing passive cooling
+ * @polling_delay: number of milliseconds to wait between polls when checking
+ *		   whether trip points have been crossed (0 for interrupt
+ *		   driven systems)
  *
  * thermal_zone_device_unregister() must be called when the device is no
- * longer needed.
+ * longer needed. The passive cooling formula uses tc1 and tc2 as described in
+ * section 11.1.5.1 of the ACPI specification 3.0.
  */
 struct thermal_zone_device *thermal_zone_device_register(char *type,
 							 int trips,
 							 void *devdata, struct
 							 thermal_zone_device_ops
-							 *ops)
+							 *ops, int tc1, int
+							 tc2,
+							 int passive_delay,
+							 int polling_delay)
 {
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *pos;
@@ -844,6 +1015,11 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
 	tz->trips = trips;
+	tz->tc1 = tc1;
+	tz->tc2 = tc2;
+	tz->passive_delay = passive_delay;
+	tz->polling_delay = polling_delay;
+
 	sprintf(tz->device.bus_id, "thermal_zone%d", tz->id);
 	result = device_register(&tz->device);
 	if (result) {
@@ -889,6 +1065,10 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 		}
 	mutex_unlock(&thermal_list_lock);
 
+	INIT_DELAYED_WORK(&(tz->poll_queue), thermal_zone_device_check);
+
+	thermal_zone_device_update(tz);
+
 	if (!result)
 		return tz;
 
@@ -928,6 +1108,8 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 		    tz->ops->unbind(tz, cdev);
 	mutex_unlock(&thermal_list_lock);
 
+	thermal_zone_device_set_polling(tz, 0);
+
 	if (tz->type[0])
 		device_remove_file(&tz->device, &dev_attr_type);
 	device_remove_file(&tz->device, &dev_attr_temp);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 05e56d8..35baa11 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -50,6 +50,7 @@ struct thermal_zone_device_ops {
 	int (*get_trip_temp) (struct thermal_zone_device *, int,
 			      int *);
 	int (*get_crit_temp) (struct thermal_zone_device *, int *);
+	int (*notify) (struct thermal_zone_device *, int, enum thermal_trip_t);
 };
 
 struct thermal_cooling_device_ops {
@@ -96,11 +97,18 @@ struct thermal_zone_device {
 	struct device device;
 	void *devdata;
 	int trips;
+	int tc1;
+	int tc2;
+	int passive_delay;
+	int polling_delay;
+	int last_temperature;
+	bool passive;
 	struct thermal_zone_device_ops *ops;
 	struct list_head cooling_devices;
 	struct idr idr;
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
+	struct delayed_work poll_queue;
 #if defined(CONFIG_THERMAL_HWMON)
 	struct list_head hwmon_node;
 	struct thermal_hwmon_device *hwmon;
@@ -112,13 +120,16 @@ struct thermal_zone_device {
 struct thermal_zone_device *thermal_zone_device_register(char *, int, void *,
 							 struct
 							 thermal_zone_device_ops
-							 *);
+							 *, int tc1, int tc2,
+							 int passive_freq,
+							 int polling_freq);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
 
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
 				     struct thermal_cooling_device *);
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
 				       struct thermal_cooling_device *);
+void thermal_zone_device_update(struct thermal_zone_device *);
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 							       struct
 							       thermal_cooling_device_ops


-- 
Matthew Garrett | mjg59@srcf.ucam.org
