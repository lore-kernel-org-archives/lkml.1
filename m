Return-Path: <linux-kernel-owner+w=401wt.eu-S937078AbXG1Hdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937078AbXG1Hdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXG1Hd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:33:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:60507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbXG1Hd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:33:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ACPI: restore CONFIG_ACPI_SLEEP
Date: Sat, 28 Jul 2007 03:33:16 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <200707280330.26991.lenb@kernel.org>
In-Reply-To: <200707280330.26991.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707280333.16264.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Restore the 2.6.22 CONFIG_ACPI_SLEEP build option,
with a few differences:
1. selects HOTPLUG_CPU rather than depends on HOTPLUG_CPU.
2. ACPI_SLEEP can be enabled on IA64

Disabling this option shrinks the kernel by 16KB.

Disabling this option on SMP allows the user to
deselect HOTPLUG_CPU and save an addition 18KB.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/i386/kernel/acpi/Makefile   |    2 +-
 arch/i386/kernel/setup.c         |    2 +-
 arch/x86_64/kernel/acpi/Makefile |    2 +-
 arch/x86_64/kernel/head.S        |    2 +-
 arch/x86_64/kernel/setup.c       |    2 +-
 drivers/acpi/Kconfig             |   17 +++++++++++++++++
 drivers/acpi/sleep/Makefile      |    4 ++--
 drivers/acpi/sleep/poweroff.c    |    2 ++
 drivers/acpi/sleep/proc.c        |    2 +-
 drivers/pci/pci-acpi.c           |    4 ++++
 drivers/pnp/pnpacpi/core.c       |    4 ++++
 include/acpi/acpi_drivers.h      |    4 ++++
 kernel/sysctl.c                  |    2 +-
 13 files changed, 40 insertions(+), 9 deletions(-)


diff --git a/arch/i386/kernel/acpi/Makefile b/arch/i386/kernel/acpi/Makefile
index 223f58f..7f7be01 100644
--- a/arch/i386/kernel/acpi/Makefile
+++ b/arch/i386/kernel/acpi/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_ACPI)		+= boot.o
 ifneq ($(CONFIG_PCI),)
 obj-$(CONFIG_X86_IO_APIC)	+= earlyquirk.o
 endif
-obj-$(CONFIG_ACPI)		+= sleep.o wakeup.o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 7fe5da3..d474cd6 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -422,7 +422,7 @@ void __init setup_bootmem_allocator(void)
 	 */
 	reserve_bootmem(PAGE_SIZE, PAGE_SIZE);
 #endif
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
 	 */
diff --git a/arch/x86_64/kernel/acpi/Makefile b/arch/x86_64/kernel/acpi/Makefile
index 17595d2..080b996 100644
--- a/arch/x86_64/kernel/acpi/Makefile
+++ b/arch/x86_64/kernel/acpi/Makefile
@@ -1,6 +1,6 @@
 obj-y			:= boot.o
 boot-y			:= ../../../i386/kernel/acpi/boot.o
-obj-y			+= sleep.o wakeup.o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y			+= processor.o
diff --git a/arch/x86_64/kernel/head.S b/arch/x86_64/kernel/head.S
index 3a16e41..e89abcd 100644
--- a/arch/x86_64/kernel/head.S
+++ b/arch/x86_64/kernel/head.S
@@ -120,7 +120,7 @@ ident_complete:
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_ACPI_SLEEP
 	addq	%rbp, wakeup_level4_pgt + 0(%rip)
 	addq	%rbp, wakeup_level4_pgt + (511*8)(%rip)
 #endif
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 0f400f3..af838f6 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -333,7 +333,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_bootmem_generic(SMP_TRAMPOLINE_BASE, 2*PAGE_SIZE);
 #endif
 
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_ACPI_SLEEP
        /*
         * Reserve low memory region for sleep support.
         */
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 22b401b..f38db44 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -42,6 +42,23 @@ menuconfig ACPI
 
 if ACPI
 
+config ACPI_SLEEP
+	bool "ACPI hooks for system sleep and wakeup"
+	select HOTPLUG_CPU if X86 && SMP
+	select SUSPEND_SMP if X86 && SMP
+	default X86
+	---help---
+	  Say Y to include ACPI hooks for system sleep and wakeup.
+	  This options is needed for suspend to RAM on ACPI-enabled
+	  machines, for it includes the wakup vector support,
+	  as well as wakeup-device support.
+
+	  System Hibernate to disk can function without this option,
+	  but wakeup devices may work better with it.
+
+	  Disabling ACPI_SLEEP saves about 16 KB, and allows
+	  disabling HOTPLUG_CPU, which saves an additional 18 KB.
+
 config ACPI_PROCFS
 	bool "Deprecated /proc/acpi files"
 	depends on PROC_FS
diff --git a/drivers/acpi/sleep/Makefile b/drivers/acpi/sleep/Makefile
index 01a993a..195a4f6 100644
--- a/drivers/acpi/sleep/Makefile
+++ b/drivers/acpi/sleep/Makefile
@@ -1,5 +1,5 @@
 obj-y					:= poweroff.o wakeup.o
-obj-y					+= main.o
-obj-$(CONFIG_X86)			+= proc.o
+obj-$(CONFIG_ACPI_SLEEP)		+= main.o
+obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
 EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/sleep/poweroff.c b/drivers/acpi/sleep/poweroff.c
index b3f68ef..39e40d5 100644
--- a/drivers/acpi/sleep/poweroff.c
+++ b/drivers/acpi/sleep/poweroff.c
@@ -18,6 +18,7 @@
 
 int acpi_sleep_prepare(u32 acpi_state)
 {
+#ifdef CONFIG_ACPI_SLEEP
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
 		if (!acpi_wakeup_address) {
@@ -30,6 +31,7 @@ int acpi_sleep_prepare(u32 acpi_state)
 	}
 	ACPI_FLUSH_CPU_CACHE();
 	acpi_enable_wakeup_device_prep(acpi_state);
+#endif
 	acpi_gpe_sleep_prepare(acpi_state);
 	acpi_enter_sleep_state_prep(acpi_state);
 	return 0;
diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index ed58e11..25b87ad 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -78,7 +78,7 @@ acpi_system_write_sleep(struct file *file,
 }
 #endif				/* CONFIG_ACPI_PROCFS */
 
-#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
+#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || !defined(CONFIG_X86)
 /* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
 #else
 #define	HAVE_ACPI_LEGACY_ALARM
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 67c63d1..5c6a5d0 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -220,6 +220,7 @@ acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
 }
 EXPORT_SYMBOL(pci_osc_control_set);
 
+#ifdef CONFIG_ACPI_SLEEP
 /*
  * _SxD returns the D-state with the highest power
  * (lowest D-state number) supported in the S-state "x".
@@ -267,6 +268,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev,
 	}
 	return PCI_POWER_ERROR;
 }
+#endif
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
@@ -340,7 +342,9 @@ static int __init acpi_pci_init(void)
 	ret = register_acpi_bus_type(&acpi_pci_bus);
 	if (ret)
 		return 0;
+#ifdef	CONFIG_ACPI_SLEEP
 	platform_pci_choose_state = acpi_pci_choose_state;
+#endif
 	platform_pci_set_power_state = acpi_pci_set_power_state;
 	return 0;
 }
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 6a2a3c2..616fc72 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -127,6 +127,7 @@ static int pnpacpi_disable_resources(struct pnp_dev *dev)
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
+#ifdef CONFIG_ACPI_SLEEP
 static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 {
 	return acpi_bus_set_power((acpi_handle) dev->data,
@@ -140,14 +141,17 @@ static int pnpacpi_resume(struct pnp_dev *dev)
 {
 	return acpi_bus_set_power((acpi_handle) dev->data, ACPI_STATE_D0);
 }
+#endif
 
 static struct pnp_protocol pnpacpi_protocol = {
 	.name	 = "Plug and Play ACPI",
 	.get	 = pnpacpi_get_resources,
 	.set	 = pnpacpi_set_resources,
 	.disable = pnpacpi_disable_resources,
+#ifdef CONFIG_ACPI_SLEEP
 	.suspend = pnpacpi_suspend,
 	.resume = pnpacpi_resume,
+#endif
 };
 
 static int __init pnpacpi_add_device(struct acpi_device *device)
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f85f77a..202acb9 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -147,6 +147,10 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
   -------------------------------------------------------------------------- */
+#ifdef CONFIG_ACPI_SLEEP
 extern int acpi_sleep_init(void);
+#else
+static inline int acpi_sleep_init(void) { return 0; }
+#endif
 
 #endif /*__ACPI_DRIVERS_H__*/
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index eb26f2b..79c891e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -689,7 +689,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86)
+#if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
 	{
 		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
