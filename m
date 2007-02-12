Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXBLHje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXBLHje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXBLHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:39:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBLHic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [38/39] x86: fix laptop bootup hang in init_acpi()
Message-Id: <20070212073826.CC4AE13DD5@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

During kernel bootup, a new T60 laptop (CoreDuo, 32-bit) hangs about
10%-20% of the time in acpi_init():

 Calling initcall 0xc055ce1a: topology_init+0x0/0x2f()
 Calling initcall 0xc055d75e: mtrr_init_finialize+0x0/0x2c()
 Calling initcall 0xc05664f3: param_sysfs_init+0x0/0x175()
 Calling initcall 0xc014cb65: pm_sysrq_init+0x0/0x17()
 Calling initcall 0xc0569f99: init_bio+0x0/0xf4()
 Calling initcall 0xc056b865: genhd_device_init+0x0/0x50()
 Calling initcall 0xc056c4bd: fbmem_init+0x0/0x87()
 Calling initcall 0xc056dd74: acpi_init+0x0/0x1ee()

It's a hard hang that not even an NMI could punch through!  Frustratingly,
adding printks or function tracing to the ACPI code made the hangs go away
...

After some time an additional detail emerged: disabling the NMI watchdog
made these occasional hangs go away.

So i spent the better part of today trying to debug this and trying out
various theories when i finally found the likely reason for the hang: if
acpi_ns_initialize_devices() executes an _INI AML method and an NMI
happens to hit that AML execution in the wrong moment, the machine would
hang.  (my theory is that this must be some sort of chipset setup method
doing stores to chipset mmio registers?)

Unfortunately given the characteristics of the hang it was sheer
impossible to figure out which of the numerous AML methods is impacted
by this problem.

As a workaround i wrote an interface to disable chipset-based NMIs while
executing _INI sections - and indeed this fixed the hang.  I did a
boot-loop of 100 separate reboots and none hung - while without the patch
it would hang every 5-10 attempts.  Out of caution i did not touch the
nmi_watchdog=2 case (it's not related to the chipset anyway and didnt
hang).

I implemented this for both x86_64 and i686, tested the i686 laptop both
with nmi_watchdog=1 [which triggered the hangs] and nmi_watchdog=2, and
tested an Athlon64 box with the 64-bit kernel as well. Everything builds
and works with the patch applied.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/nmi.c          |   28 ++++++++++++++++++++++++++++
 arch/x86_64/kernel/nmi.c        |   27 +++++++++++++++++++++++++++
 drivers/acpi/namespace/nsinit.c |    9 +++++++++
 include/linux/nmi.h             |    9 ++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -383,6 +383,34 @@ void enable_timer_nmi_watchdog(void)
 	}
 }
 
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
+
 #ifdef CONFIG_PM
 
 static int nmi_pm_active; /* nmi_active before suspend */
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -368,6 +368,33 @@ void enable_timer_nmi_watchdog(void)
 	}
 }
 
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
 #ifdef CONFIG_PM
 
 static int nmi_pm_active; /* nmi_active before suspend */
Index: linux/drivers/acpi/namespace/nsinit.c
===================================================================
--- linux.orig/drivers/acpi/namespace/nsinit.c
+++ linux/drivers/acpi/namespace/nsinit.c
@@ -45,6 +45,7 @@
 #include <acpi/acnamesp.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
+#include <linux/nmi.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsinit")
@@ -534,7 +535,15 @@ acpi_ns_init_one_device(acpi_handle obj_
 	info->parameter_type = ACPI_PARAM_ARGS;
 	info->flags = ACPI_IGNORE_RETURN_VALUE;
 
+	/*
+	 * Some hardware relies on this being executed as atomically
+	 * as possible (without an NMI being received in the middle of
+	 * this) - so disable NMIs and initialize the device:
+	 */
+	acpi_nmi_disable();
 	status = acpi_ns_evaluate(info);
+	acpi_nmi_enable();
+
 	if (ACPI_SUCCESS(status)) {
 		walk_info->num_INI++;
 
Index: linux/include/linux/nmi.h
===================================================================
--- linux.orig/include/linux/nmi.h
+++ linux/include/linux/nmi.h
@@ -17,8 +17,15 @@
 #ifdef ARCH_HAS_NMI_WATCHDOG
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
+extern void acpi_nmi_disable(void);
+extern void acpi_nmi_enable(void);
 #else
-# define touch_nmi_watchdog() touch_softlockup_watchdog()
+static inline void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+static inline void acpi_nmi_disable(void) { }
+static inline void acpi_nmi_enable(void) { }
 #endif
 
 #ifndef trigger_all_cpu_backtrace
