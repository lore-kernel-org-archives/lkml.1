Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYJKGhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYJKGhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYJKGgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:36:53 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:50763 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYJKGgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:50 -0400
Date: Sat, 11 Oct 2008 02:35:25 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 05/85] ACPI: Add "acpi.power_nocheck=1" to disable power state
 check in power transition
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhao Yakui <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Andi Kleen <ak@linux.intel.com>
Message-id: <f2e969acd6d5981e6b1272810002558650d0736e.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

   Maybe the incorrect power state is returned on the bogus bios, which
is different with the real power state. For example: the bios returns D0
state and the real power state is D3. OS expects to set the device to D0
state. In  such case if OS uses the power state returned by the BIOS and
checks the device power state very strictly in power transition, the device
can't be transited to the correct power state.

   So the boot option of "acpi.power_nocheck=1" is added to avoid checking
the device power in the course of device power transition.

http://bugzilla.kernel.org/show_bug.cgi?id=8049
http://bugzilla.kernel.org/show_bug.cgi?id=11000

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    8 ++++++
 drivers/acpi/bus.c                  |   14 ++++++++++-
 drivers/acpi/power.c                |   42 +++++++++++++++++++++++++---------
 include/acpi/acpi_drivers.h         |    1 +
 4 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 44d1bd1..99cf83f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -251,6 +251,14 @@ and is between 256 and 4096 characters. It is defined in the file
  			Warning: Many of these options can produce a lot of
  			output and make your system unusable. Be very careful.
 
+ 	acpi.power_nocheck=	[HW,ACPI]
+ 			Format: 1/0 enable/disable the check of power state.
+ 			On some bogus BIOS the _PSC object/_STA object of
+ 			power resource can't return the correct device power
+ 			state. In such case it is unneccessary to check its
+ 			power state again in power transition.
+ 			1 : disable the power state check
+
 	acpi_pm_good	[X86-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ccae305..91bdeb3 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -223,7 +223,19 @@ int acpi_bus_set_power(acpi_handle handle, int state)
 	/*
 	 * Get device's current power state
 	 */
-	acpi_bus_get_power(device->handle, &device->power.state);
+	if (!acpi_power_nocheck) {
+		/*
+		 * Maybe the incorrect power state is returned on the bogus
+		 * bios, which is different with the real power state.
+		 * For example: the bios returns D0 state and the real power
+		 * state is D3. OS expects to set the device to D0 state. In
+		 * such case if OS uses the power state returned by the BIOS,
+		 * the device can't be transisted to the correct power state.
+		 * So if the acpi_power_nocheck is set, it is unnecessary to
+		 * get the power state by calling acpi_bus_get_power.
+		 */
+		acpi_bus_get_power(device->handle, &device->power.state);
+	}
 	if ((state == device->power.state) && !device->flags.force_power_state) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at D%d\n",
 				  state));
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index e7bab75..7ff7349 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -54,6 +54,14 @@ ACPI_MODULE_NAME("power");
 #define ACPI_POWER_RESOURCE_STATE_OFF	0x00
 #define ACPI_POWER_RESOURCE_STATE_ON	0x01
 #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "acpi."
+int acpi_power_nocheck;
+module_param_named(power_nocheck, acpi_power_nocheck, bool, 000);
+
 static int acpi_power_add(struct acpi_device *device);
 static int acpi_power_remove(struct acpi_device *device, int type);
 static int acpi_power_resume(struct acpi_device *device);
@@ -228,12 +236,18 @@ static int acpi_power_on(acpi_handle handle, struct acpi_device *dev)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	result = acpi_power_get_state(resource->device->handle, &state);
-	if (result)
-		return result;
-	if (state != ACPI_POWER_RESOURCE_STATE_ON)
-		return -ENOEXEC;
-
+	if (!acpi_power_nocheck) {
+		/*
+		 * If acpi_power_nocheck is set, it is unnecessary to check
+		 * the power state after power transition.
+		 */
+		result = acpi_power_get_state(resource->device->handle,
+				&state);
+		if (result)
+			return result;
+		if (state != ACPI_POWER_RESOURCE_STATE_ON)
+			return -ENOEXEC;
+	}
 	/* Update the power resource's _device_ power state */
 	resource->device->power.state = ACPI_STATE_D0;
 
@@ -279,11 +293,17 @@ static int acpi_power_off_device(acpi_handle handle, struct acpi_device *dev)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	result = acpi_power_get_state(handle, &state);
-	if (result)
-		return result;
-	if (state != ACPI_POWER_RESOURCE_STATE_OFF)
-		return -ENOEXEC;
+	if (!acpi_power_nocheck) {
+		/*
+		 * If acpi_power_nocheck is set, it is unnecessary to check
+		 * the power state after power transition.
+		 */
+		result = acpi_power_get_state(handle, &state);
+		if (result)
+			return result;
+		if (state != ACPI_POWER_RESOURCE_STATE_OFF)
+			return -ENOEXEC;
+	}
 
 	/* Update the power resource's _device_ power state */
 	resource->device->power.state = ACPI_STATE_D3;
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index e5f38e5..efbaa27 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -93,6 +93,7 @@ int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 int acpi_power_get_inferred_state(struct acpi_device *device);
 int acpi_power_transition(struct acpi_device *device, int state);
+extern int acpi_power_nocheck;
 #endif
 
 /* --------------------------------------------------------------------------
-- 
1.5.5.1

