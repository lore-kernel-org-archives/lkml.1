Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbXHHWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbXHHWEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXHHWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:04:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbXHHWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:04:08 -0400
Date: Wed, 8 Aug 2007 15:03:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and
 CONFIG_HIBERNATION (updated 2x)
Message-Id: <20070808150307.378bf385.akpm@linux-foundation.org>
In-Reply-To: <200708070023.27404.rjw@sisk.pl>
References: <200708070023.27404.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 00:23:26 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
> 296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
> suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
> (1) not all architectures support suspend and (2) SMP hibernation is only
> possible on X86 and PPC64 (if CONFIG_PPC64_SWSUSP is set).
> 
> Moreover, SMP suspend and hibernation are only possible if CONFIG_HOTPLUG is
> set, because they select HOTPLUG_CPU that depends on it. __Also, since suspend
> and hibernation don't depend on EXPERIMENTAL, arrange things so that CPU
> hotplug can be selected if it is not set.

The version of this which I have (version eighty eight, afaict :),
reproduced below) breaks ia64 allmodconfig:

init/Kconfig:416:error: found recursive dependency: HOTPLUG -> SUSPEND_SMP_POSSIBLE -> PM_SLEEP_SMP -> HOTPLUG_CPU -> HOTPLUG
 -> PCCARD -> PCMCIA -> USB_ARCH_HAS_HCD -> MOUSE_APPLETOUCH -> USB -> USB_SISUS


From: Rafael J. Wysocki <rjw@sisk.pl>

Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
(1) not all architectures support suspend and (2) SMP hibernation is only
possible on X86 and PPC64 (if CONFIG_PPC64_SWSUSP is set).

Moreover, SMP suspend and hibernation are only possible if CONFIG_HOTPLUG is
set, because they select HOTPLUG_CPU that depends on it. _Also, since suspend
and hibernation don't depend on EXPERIMENTAL, arrange things so that CPU
hotplug can be selected if it is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Len Brown <lenb@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig      |    2 -
 arch/i386/Kconfig     |    3 +-
 arch/powerpc/Kconfig  |    3 +-
 arch/x86_64/Kconfig   |    2 -
 arch/x86_64/defconfig |    1 
 include/linux/cpu.h   |    6 ++---
 kernel/cpu.c          |    4 +--
 kernel/power/Kconfig  |   43 ++++++++++++++++++++++++++++++----------
 8 files changed, 44 insertions(+), 20 deletions(-)

diff -puN arch/arm/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x arch/arm/Kconfig
--- a/arch/arm/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/arch/arm/Kconfig
@@ -594,7 +594,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
diff -puN arch/i386/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x arch/i386/Kconfig
--- a/arch/i386/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/arch/i386/Kconfig
@@ -904,7 +904,8 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
diff -puN arch/powerpc/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/arch/powerpc/Kconfig
@@ -194,7 +194,8 @@ config IOMMU_VMERGE
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && (PPC_PSERIES || PPC_PMAC)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff -puN arch/x86_64/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/arch/x86_64/Kconfig
@@ -445,7 +445,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
diff -puN arch/x86_64/defconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x arch/x86_64/defconfig
--- a/arch/x86_64/defconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/arch/x86_64/defconfig
@@ -201,7 +201,6 @@ CONFIG_PM=y
 # CONFIG_PM_DEBUG is not set
 CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
-CONFIG_SUSPEND_SMP=y
 
 #
 # ACPI (Advanced Configuration and Power Interface) Support
diff -puN include/linux/cpu.h~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x include/linux/cpu.h
--- a/include/linux/cpu.h~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/include/linux/cpu.h
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
diff -puN kernel/cpu.c~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x kernel/cpu.c
--- a/kernel/cpu.c~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/kernel/cpu.c
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
diff -puN kernel/power/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x kernel/power/Kconfig
--- a/kernel/power/Kconfig~pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x
+++ a/kernel/power/Kconfig
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
_

