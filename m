Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbZDBVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbZDBVDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZDBVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:03:46 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:54107 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZDBVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:03:45 -0400
Date: Thu, 02 Apr 2009 17:03:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, yakui_zhao <yakui.zhao@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: simplify module_param namespace
In-reply-to: <200903120907.20055.rusty@rustcorp.com.au>
Message-id: <alpine.LFD.2.00.0904021659190.4660@localhost.localdomain>
References: <200903071328.28113.rusty@rustcorp.com.au>
 <200903110927.12792.rusty@rustcorp.com.au>
 <20090311145124.696b2448.sfr@canb.auug.org.au>
 <200903120907.20055.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: simplify module_param namespace
From: Rusty Russell <rusty@rustcorp.com.au>
    
Impact: cleanup
    
Rather than overriding MODULE_PARAM_PREFIX, build via acpi.o so
KBUILD_MODNAME is set to "acpi".

This is the logical way to do it, even though acpi cannot be a module
due to these config options being bool.  Those parts of ACPI which can
be modular are not built into the acpi "module".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Len Brown <len.brown@intel.com>
---
Rusty, thanks for the patch.
Here is the version i checked in, after merging on top of the acpi tree
(ec no longer depends on link order)

-Len

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 61675e2..e3ca48f 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -14,44 +14,48 @@ obj-$(CONFIG_X86)		+= blacklist.o
 #
 # ACPI Core Subsystem (Interpreter)
 #
-obj-y				+= osl.o utils.o reboot.o\
+obj-y				+= acpi.o \
 					acpica/
 
+# All the builtin files are in the "acpi." module_param namespace.
+acpi-y				+= osl.o utils.o reboot.o
+
 # sleep related files
-obj-y				+= wakeup.o
-obj-y				+= sleep.o
-obj-$(CONFIG_ACPI_SLEEP)	+= proc.o
+acpi-y				+= wakeup.o
+acpi-y				+= sleep.o
+acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 
 
 #
 # ACPI Bus and Device Drivers
 #
-processor-objs	+= processor_core.o processor_throttling.o \
-				processor_idle.o processor_thermal.o
-ifdef CONFIG_CPU_FREQ
-processor-objs	+= processor_perflib.o
+acpi-y				+= bus.o glue.o scan.o ec.o \
+					power.o system.o event.o
+acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
+acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+acpi-$(CONFIG_ACPI_DEBUG)	+= debug.o
+acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
+acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
+ifdef CONFIG_ACPI_VIDEO
+acpi-y				+= video_detect.o
 endif
 
-obj-y				+= bus.o glue.o scan.o ec.o \
-					power.o system.o event.o
+# These are (potentially) separate modules
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_BUTTON)	+= button.o
 obj-$(CONFIG_ACPI_FAN)		+= fan.o
-obj-$(CONFIG_ACPI_DOCK)		+= dock.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
-ifdef CONFIG_ACPI_VIDEO
-obj-y				+= video_detect.o
-endif
-
-obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
 obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-$(CONFIG_ACPI_DEBUG)	+= debug.o
-obj-$(CONFIG_ACPI_NUMA)		+= numa.o
-obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
-obj-$(CONFIG_ACPI_PROCFS_POWER)	+= cm_sbs.o
+obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
+
+processor-objs	+= processor_core.o processor_throttling.o \
+				processor_idle.o processor_thermal.o
+ifdef CONFIG_CPU_FREQ
+processor-objs	+= processor_perflib.o
+endif
diff --git a/drivers/acpi/debug.c b/drivers/acpi/debug.c
index 9cb189f..a8287be 100644
--- a/drivers/acpi/debug.c
+++ b/drivers/acpi/debug.c
@@ -13,11 +13,6 @@
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("debug");
 
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "acpi."
-
 struct acpi_dlayer {
 	const char *name;
 	unsigned long value;
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 11968ba..56665a6 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -54,10 +54,6 @@ ACPI_MODULE_NAME("power");
 #define ACPI_POWER_RESOURCE_STATE_ON	0x01
 #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
 
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "acpi."
 int acpi_power_nocheck;
 module_param_named(power_nocheck, acpi_power_nocheck, bool, 000);
 
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 44be75e..da51f05 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -33,10 +33,6 @@
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("system");
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "acpi."
 
 #define ACPI_SYSTEM_CLASS		"system"
 #define ACPI_SYSTEM_DEVICE_NAME		"System"
