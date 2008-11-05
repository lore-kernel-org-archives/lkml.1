Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYKEI4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYKEI4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYKEI4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:56:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:42475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYKEI4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,549,1220252400"; 
   d="scan'208";a="459469413"
Subject: [PATCH 2.6.28-rc3] ACPI: fix inconsistent acpi event format
	(resent)
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf8
Organization: Intel
Date: Thu, 06 Nov 2008 00:55:29 +0800
Message-Id: <1225904129.17794.68.camel@yangyi-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Subject: ACPI: fix inconsistent acpi event format
From: Yi Yang <yi.y.yang@intel.com>

Hi, Len

Please ignore last one and use this patch, this patch also fixes other acpi event format 
issues in another several acpi drivers.

Event format acpi generates for /proc/acpi/event is different from
that for generic netlink interface. Here are i got:

>From /proc/acpi/event, i got the following events when i suspend and
resume Acer's Aspire One:

battery BAT1 00000080 00000000
battery BAT1 00000081 00000000
ac_adapter ACAD 00000080 00000001
battery BAT1 00000080 00000000

But from generic netlink socket, i got the following events when i suspend
and resume Acer's Aspire One:

battery PNP0C0A:00 00000080 00000000
battery PNP0C0A:00 00000081 00000000
ac_adapter ACPI0003:00 00000080 00000001
battery PNP0C0A:00 00000080 00000000

Such inconsistent event format will make acpid or hald confused, this patch
fixes this issue, it makes acpid or hald see the same thing no matter they use
/proc/acpi/event or generic netlink interface.

After applying this patch, event format i got from /proc/acpi/event and generic
netlink interface is same, all of them are:

battery BAT1 00000080 00000000
battery BAT1 00000081 00000000
ac_adapter ACAD 00000080 00000001
battery BAT1 00000080 00000000

Please consider applying, thanks.

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 ac.c             |    2 +-
 battery.c        |    2 +-
 processor_core.c |    6 +++---
 thermal.c        |    8 ++++----
 wmi.c            |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index d72a1b6..9d8053b 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -242,7 +242,7 @@ static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 		acpi_ac_get_state(ac);
 		acpi_bus_generate_proc_event(device, event, (u32) ac->state);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event,
+						  device->pnp.bus_id, event,
 						  (u32) ac->state);
 #ifdef CONFIG_ACPI_SYSFS_POWER
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b2133e8..e52b336 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -782,7 +782,7 @@ static void acpi_battery_notify(acpi_handle handle, u32 event, void *data)
 	acpi_bus_generate_proc_event(device, event,
 				     acpi_battery_present(battery));
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
-					device->dev.bus_id, event,
+					device->pnp.bus_id, event,
 					acpi_battery_present(battery));
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	/* acpi_batter_update could remove power_supply object */
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 24a362f..8bc0bd5 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -761,20 +761,20 @@ static void acpi_processor_notify(acpi_handle handle, u32 event, void *data)
 		acpi_bus_generate_proc_event(device, event,
 					pr->performance_platform_limit);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event,
+						  device->pnp.bus_id, event,
 						  pr->performance_platform_limit);
 		break;
 	case ACPI_PROCESSOR_NOTIFY_POWER:
 		acpi_processor_cst_has_changed(pr);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event, 0);
+						  device->pnp.bus_id, event, 0);
 		break;
 	case ACPI_PROCESSOR_NOTIFY_THROTTLING:
 		acpi_processor_tstate_has_changed(pr);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event, 0);
+						  device->pnp.bus_id, event, 0);
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Unsupported event [0x%x]\n", event));
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index ad6cae9..d636d91 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -576,7 +576,7 @@ static int acpi_thermal_critical(struct acpi_thermal *tz)
 	acpi_bus_generate_proc_event(tz->device, ACPI_THERMAL_NOTIFY_CRITICAL,
 				tz->trips.critical.flags.enabled);
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
-					  tz->device->dev.bus_id,
+					  tz->device->pnp.bus_id,
 					  ACPI_THERMAL_NOTIFY_CRITICAL,
 					  tz->trips.critical.flags.enabled);
 
@@ -605,7 +605,7 @@ static int acpi_thermal_hot(struct acpi_thermal *tz)
 	acpi_bus_generate_proc_event(tz->device, ACPI_THERMAL_NOTIFY_HOT,
 				tz->trips.hot.flags.enabled);
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
-					  tz->device->dev.bus_id,
+					  tz->device->pnp.bus_id,
 					  ACPI_THERMAL_NOTIFY_HOT,
 					  tz->trips.hot.flags.enabled);
 
@@ -1592,14 +1592,14 @@ static void acpi_thermal_notify(acpi_handle handle, u32 event, void *data)
 		acpi_thermal_check(tz);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event, 0);
+						  device->pnp.bus_id, event, 0);
 		break;
 	case ACPI_THERMAL_NOTIFY_DEVICES:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_DEVICES);
 		acpi_thermal_check(tz);
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
-						  device->dev.bus_id, event, 0);
+						  device->pnp.bus_id, event, 0);
 		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index 47cd7ba..07f1ba0 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -660,7 +660,7 @@ static void acpi_wmi_notify(acpi_handle handle, u32 event, void *data)
 				wblock->handler(event, wblock->handler_data);
 
 			acpi_bus_generate_netlink_event(
-				device->pnp.device_class, device->dev.bus_id,
+				device->pnp.device_class, device->pnp.bus_id,
 				event, 0);
 			break;
 		}


