Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZCKWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZCKWhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZCKWh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:37:28 -0400
Received: from ozlabs.org ([203.10.76.45]:40617 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZCKWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:37:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] acpi: simplify module_param namespace
Date: Thu, 12 Mar 2009 09:07:19 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: "yakui_zhao" <yakui.zhao@intel.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903071328.28113.rusty@rustcorp.com.au> <200903110927.12792.rusty@rustcorp.com.au> <20090311145124.696b2448.sfr@canb.auug.org.au>
In-Reply-To: <20090311145124.696b2448.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120907.20055.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009 14:21:24 Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Wed, 11 Mar 2009 09:27:12 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > This version is bigger, but simpler, and doesn't change link order.  It just
> > moves everything into the acpi module.
> 
> So we end up with one big acpi.ko module instead of separate modules
> (like battery.ko, dock.ko) some of which we may not have needed to
> load?  Just clarifying.

Oops.  Good point.

The built-in only parts of ACPI should all be one "module".  The rest should
still be separate modules.

Third time for sure!

Subject: acpi: simplify module_param namespace

Impact: cleanup

Rather than overriding MODULE_PARAM_PREFIX, build via acpi.o so
KBUILD_MODNAME is set to "acpi".

This is the logical way to do it, even though acpi cannot be a module
due to these config options being bool.  Those parts of ACPI which can
be modular are not built into the acpi "module".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/acpi/Makefile |   68 ++++++++++++++++++++++++++------------------------
 drivers/acpi/debug.c  |    5 ---
 drivers/acpi/power.c  |    4 --
 drivers/acpi/system.c |    4 --
 4 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -14,48 +14,52 @@ obj-$(CONFIG_X86)		+= blacklist.o
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
+acpi-y				+= bus.o glue.o
+acpi-y				+= scan.o
+# Keep EC driver first. Initialization of others depend on it.
+acpi-y				+= ec.o
+acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
+acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+acpi-y				+= power.o
+acpi-y				+= system.o event.o
+acpi-$(CONFIG_ACPI_DEBUG)	+= debug.o
+acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
+acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
+ifdef CONFIG_ACPI_VIDEO
+acpi-y				+= video_detect.o
+endif
+
+# These are (potentially) separate modules
+obj-$(CONFIG_ACPI_AC) 		+= ac.o
+obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
+obj-$(CONFIG_ACPI_BUTTON)	+= button.o
+obj-$(CONFIG_ACPI_FAN)		+= fan.o
+obj-$(CONFIG_ACPI_VIDEO)	+= video.o
+obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
+obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
+obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
+obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
+obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
+obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
+obj-$(CONFIG_ACPI_SBS)		+= sbs.o
+
 processor-objs	+= processor_core.o processor_throttling.o \
 				processor_idle.o processor_thermal.o
 ifdef CONFIG_CPU_FREQ
 processor-objs	+= processor_perflib.o
 endif
-
-obj-y				+= bus.o glue.o
-obj-y				+= scan.o
-# Keep EC driver first. Initialization of others depend on it.
-obj-y				+= ec.o
-obj-$(CONFIG_ACPI_AC) 		+= ac.o
-obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
-obj-$(CONFIG_ACPI_BUTTON)	+= button.o
-obj-$(CONFIG_ACPI_FAN)		+= fan.o
-obj-$(CONFIG_ACPI_DOCK)		+= dock.o
-obj-$(CONFIG_ACPI_VIDEO)	+= video.o
-ifdef CONFIG_ACPI_VIDEO
-obj-y				+= video_detect.o
-endif
-
-obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
-obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
-obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
-obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
-obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-y				+= power.o
-obj-y				+= system.o event.o
-obj-$(CONFIG_ACPI_DEBUG)	+= debug.o
-obj-$(CONFIG_ACPI_NUMA)		+= numa.o
-obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
-obj-$(CONFIG_ACPI_PROCFS_POWER)	+= cm_sbs.o
-obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
-obj-$(CONFIG_ACPI_SBS)		+= sbs.o
diff --git a/drivers/acpi/debug.c b/drivers/acpi/debug.c
--- a/drivers/acpi/debug.c
+++ b/drivers/acpi/debug.c
@@ -12,11 +12,6 @@
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("debug");
-
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "acpi."
 
 struct acpi_dlayer {
 	const char *name;
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
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


