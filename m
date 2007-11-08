Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbXKHRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbXKHRa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760907AbXKHRaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:30:16 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:58147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbXKHRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:30:13 -0500
Subject: [PATCH (2.6.25) 2/2] suspend: clean up Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071108092149.e27c5ba3.akpm@linux-foundation.org>
References: <20071107135758.100171000@sipsolutions.net>
	 <200711072317.48023.rjw@sisk.pl> <1194533053.6294.42.camel@johannes.berg>
	 <20071108092149.e27c5ba3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 18:31:33 +0100
Message-Id: <1194543093.4793.22.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the suspend Kconfig and removes the need to
declare centrally which architectures support suspend. All
architectures that currently support suspend are modified
accordingly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Scott Wood <scottwood@freescale.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-pm@lists.linux-foundation.org
---
Acked-by fest. I hope I didn't forget anyone.

Architecture maintainers should evaluate whether their
ARCH_SUSPEND_POSSIBLE symbol should be set only under
stricter circumstances like I've done for powerpc.

Always setting it is not usually a problem, however, since the
infrastructure is only available for use after suspend_set_ops().

 arch/arm/Kconfig      |    3 +++
 arch/blackfin/Kconfig |    4 ++++
 arch/frv/Kconfig      |    5 +++++
 arch/i386/Kconfig     |    4 ++++
 arch/mips/Kconfig     |    4 ++++
 arch/powerpc/Kconfig  |    4 ++++
 arch/sh/Kconfig       |    4 ++++
 arch/x86_64/Kconfig   |    3 +++
 kernel/power/Kconfig  |   21 +++------------------
 9 files changed, 34 insertions(+), 18 deletions(-)

--- everything.orig/arch/i386/Kconfig	2007-11-08 17:17:04.161529298 +0100
+++ everything/arch/i386/Kconfig	2007-11-08 17:17:05.021529460 +0100
@@ -1323,3 +1323,7 @@ config KTIME_SCALAR
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !X86_VOYAGER
--- everything.orig/arch/x86_64/Kconfig	2007-11-08 17:17:04.161529298 +0100
+++ everything/arch/x86_64/Kconfig	2007-11-08 17:17:05.021529460 +0100
@@ -716,6 +716,9 @@ menu "Power management options"
 
 source kernel/power/Kconfig
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
--- everything.orig/kernel/power/Kconfig	2007-11-08 17:17:04.151557021 +0100
+++ everything/kernel/power/Kconfig	2007-11-08 17:17:05.031557021 +0100
@@ -64,7 +64,7 @@ config PM_TRACE
 config PM_SLEEP_SMP
 	bool
 	depends on SMP
-	depends on SUSPEND_SMP_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
+	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
@@ -74,29 +74,14 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
-config SUSPEND_UP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || PPC || ARM || BLACKFIN || MIPS \
-		   || SUPERH || FRV
-	depends on !SMP
-	default y
-
-config SUSPEND_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) \
-		   || (PPC && (PPC_PSERIES || PPC_PMAC)) || ARM
-	depends on SMP
-	default y
-
 config SUSPEND
 	bool "Suspend to RAM and standby"
-	depends on PM
-	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
+	depends on PM && ARCH_SUSPEND_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
 	  powered and thus its contents are preserved, such as the
-	  suspend-to-RAM state (i.e. the ACPI S3 state).
+	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
--- everything.orig/arch/blackfin/Kconfig	2007-11-08 16:47:41.381538792 +0100
+++ everything/arch/blackfin/Kconfig	2007-11-08 17:17:05.031557021 +0100
@@ -993,6 +993,10 @@ endmenu
 menu "Power management options"
 source "kernel/power/Kconfig"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 choice
 	prompt "Select PM Wakeup Event Source"
 	default PM_WAKEUP_GPIO_BY_SIC_IWR
--- everything.orig/arch/arm/Kconfig	2007-11-08 16:47:41.471536784 +0100
+++ everything/arch/arm/Kconfig	2007-11-08 17:17:05.031557021 +0100
@@ -977,6 +977,9 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
 endmenu
 
 source "net/Kconfig"
--- everything.orig/arch/mips/Kconfig	2007-11-08 16:47:41.581534723 +0100
+++ everything/arch/mips/Kconfig	2007-11-08 17:17:05.041533041 +0100
@@ -1999,6 +1999,10 @@ endmenu
 
 menu "Power management options"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source "kernel/power/Kconfig"
 
 endmenu
--- everything.orig/arch/sh/Kconfig	2007-11-08 16:47:41.641537653 +0100
+++ everything/arch/sh/Kconfig	2007-11-08 17:17:05.041533041 +0100
@@ -748,6 +748,10 @@ endmenu
 menu "Power management options (EXPERIMENTAL)"
 depends on EXPERIMENTAL && SYS_SUPPORTS_PM
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source kernel/power/Kconfig
 
 endmenu
--- everything.orig/arch/frv/Kconfig	2007-11-08 16:47:41.751533475 +0100
+++ everything/arch/frv/Kconfig	2007-11-08 17:17:05.041533041 +0100
@@ -357,6 +357,11 @@ source "drivers/pcmcia/Kconfig"
 #	  should probably wait a while.
 
 menu "Power management options"
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source kernel/power/Kconfig
 endmenu
 
--- everything.orig/arch/powerpc/Kconfig	2007-11-08 17:17:04.151557021 +0100
+++ everything/arch/powerpc/Kconfig	2007-11-08 17:17:05.041533041 +0100
@@ -155,6 +155,10 @@ config ARCH_HIBERNATION_POSSIBLE
 	depends on (PPC64 && HIBERNATE_64) || (PPC32 && HIBERNATE_32)
 	default y
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200
+
 config PPC_DCR_NATIVE
 	bool
 	default n


