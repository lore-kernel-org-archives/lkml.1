Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbXHFWO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbXHFWO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbXHFWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:14:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58259 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760701AbXHFWOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:14:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated 2x)
Date: Tue, 7 Aug 2007 00:23:26 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>,
       Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708070023.27404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[The update is necessary because of the too restrictive conditions for suspend
on powerpc.]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
(1) not all architectures support suspend and (2) SMP hibernation is only
possible on X86 and PPC64 (if CONFIG_PPC64_SWSUSP is set).

Moreover, SMP suspend and hibernation are only possible if CONFIG_HOTPLUG is
set, because they select HOTPLUG_CPU that depends on it.  Also, since suspend
and hibernation don't depend on EXPERIMENTAL, arrange things so that CPU
hotplug can be selected if it is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/Kconfig      |    2 +-
 arch/i386/Kconfig     |    3 ++-
 arch/powerpc/Kconfig  |    3 ++-
 arch/x86_64/Kconfig   |    2 +-
 arch/x86_64/defconfig |    1 -
 include/linux/cpu.h   |    6 +++---
 kernel/cpu.c          |    4 ++--
 kernel/power/Kconfig  |   43 +++++++++++++++++++++++++++++++++----------
 8 files changed, 44 insertions(+), 20 deletions(-)

Index: linux-2.6.23-rc2/kernel/power/Kconfig
===================================================================
--- linux-2.6.23-rc2.orig/kernel/power/Kconfig
+++ linux-2.6.23-rc2/kernel/power/Kconfig
@@ -72,15 +72,10 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
-config SUSPEND_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
-	depends on SMP
-	default y
-
-config SUSPEND_SMP
+config PM_SLEEP_SMP
 	bool
-	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
+	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
+	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
 
@@ -89,20 +84,48 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
+config SUSPEND_UP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || PPC || ARM || BLACKFIN || MIPS \
+		   || SUPERH || FRV
+	depends on !SMP
+	default y
+
+config SUSPEND_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) \
+		   || (PPC && (PPC_PSERIES || PPC_PMAC)) || ARM
+	depends on SMP
+	depends on HOTPLUG
+	default y
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM
-	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (i.e. the ACPI S3 state).
 
+config HIBERNATION_UP_POSSIBLE
+	bool
+	depends on X86 || PPC64_SWSUSP || FRV || PPC32
+	depends on !SMP
+	default y
+
+config HIBERNATION_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || PPC64_SWSUSP
+	depends on SMP
+	depends on HOTPLUG
+	default y
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP
-	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
+	depends on HIBERNATION_UP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
Index: linux-2.6.23-rc2/kernel/cpu.c
===================================================================
--- linux-2.6.23-rc2.orig/kernel/cpu.c
+++ linux-2.6.23-rc2/kernel/cpu.c
@@ -273,7 +273,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	return err;
 }
 
-#ifdef CONFIG_SUSPEND_SMP
+#ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -334,4 +334,4 @@ void enable_nonboot_cpus(void)
 out:
 	mutex_unlock(&cpu_add_remove_lock);
 }
-#endif
+#endif /* CONFIG_PM_SLEEP_SMP */
Index: linux-2.6.23-rc2/include/linux/cpu.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/cpu.h
+++ linux-2.6.23-rc2/include/linux/cpu.h
@@ -128,16 +128,16 @@ static inline void cpuhotplug_mutex_unlo
 static inline int cpu_is_offline(int cpu) { return 0; }
 #endif		/* CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_SUSPEND_SMP
+#ifdef CONFIG_PM_SLEEP_SMP
 extern int suspend_cpu_hotplug;
 
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
-#else
+#else /* !CONFIG_PM_SLEEP_SMP */
 #define suspend_cpu_hotplug	0
 
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
-#endif
+#endif /* !CONFIG_PM_SLEEP_SMP */
 
 #endif /* _LINUX_CPU_H_ */
Index: linux-2.6.23-rc2/arch/x86_64/defconfig
===================================================================
--- linux-2.6.23-rc2.orig/arch/x86_64/defconfig
+++ linux-2.6.23-rc2/arch/x86_64/defconfig
@@ -201,7 +201,6 @@ CONFIG_PM=y
 # CONFIG_PM_DEBUG is not set
 CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
-CONFIG_SUSPEND_SMP=y
 
 #
 # ACPI (Advanced Configuration and Power Interface) Support
Index: linux-2.6.23-rc2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.23-rc2.orig/arch/x86_64/Kconfig
+++ linux-2.6.23-rc2/arch/x86_64/Kconfig
@@ -445,7 +445,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
Index: linux-2.6.23-rc2/arch/arm/Kconfig
===================================================================
--- linux-2.6.23-rc2.orig/arch/arm/Kconfig
+++ linux-2.6.23-rc2/arch/arm/Kconfig
@@ -594,7 +594,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
Index: linux-2.6.23-rc2/arch/i386/Kconfig
===================================================================
--- linux-2.6.23-rc2.orig/arch/i386/Kconfig
+++ linux-2.6.23-rc2/arch/i386/Kconfig
@@ -904,7 +904,8 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
Index: linux-2.6.23-rc2/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.23-rc2.orig/arch/powerpc/Kconfig
+++ linux-2.6.23-rc2/arch/powerpc/Kconfig
@@ -194,7 +194,8 @@ config IOMMU_VMERGE
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && (PPC_PSERIES || PPC_PMAC)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
