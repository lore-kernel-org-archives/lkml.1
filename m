Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXKHR2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXKHR2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbXKHR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:28:45 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761047AbXKHR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:28:44 -0500
Subject: [PATCH (2.6.25) 1/2] hibernation: clean up Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071108092149.e27c5ba3.akpm@linux-foundation.org>
References: <20071107135758.100171000@sipsolutions.net>
	 <200711072317.48023.rjw@sisk.pl> <1194533053.6294.42.camel@johannes.berg>
	 <20071108092149.e27c5ba3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 18:30:03 +0100
Message-Id: <1194543003.4793.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the hibernation Kconfig and removes the need to
declare centrally which architectures support hibernation. All
architectures that currently support hibernation are modified
accordingly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linuxppc-dev@ozlabs.org
Cc: linux-pm@lists.linux-foundation.org
---
 arch/i386/Kconfig    |    4 ++++
 arch/powerpc/Kconfig |   14 ++++++++++++--
 arch/x86_64/Kconfig  |    3 +++
 kernel/power/Kconfig |   18 +++---------------
 4 files changed, 22 insertions(+), 17 deletions(-)

--- everything.orig/arch/powerpc/Kconfig	2007-11-08 16:47:42.231537111 +0100
+++ everything/arch/powerpc/Kconfig	2007-11-08 17:17:04.151557021 +0100
@@ -140,9 +140,19 @@ config DEFAULT_UIMAGE
 	  Used to allow a board to specify it wants a uImage built by default
 	default n
 
-config PPC64_SWSUSP
+config HIBERNATE_32
 	bool
-	depends on PPC64 && (BROKEN || (PPC_PMAC64 && EXPERIMENTAL))
+	depends on (PPC_PMAC && !SMP) || BROKEN
+	default y
+
+config HIBERNATE_64
+	bool
+	depends on BROKEN || (PPC_PMAC64 && EXPERIMENTAL)
+	default y
+
+config ARCH_HIBERNATION_POSSIBLE
+	bool
+	depends on (PPC64 && HIBERNATE_64) || (PPC32 && HIBERNATE_32)
 	default y
 
 config PPC_DCR_NATIVE
--- everything.orig/kernel/power/Kconfig	2007-11-08 16:47:42.411527399 +0100
+++ everything/kernel/power/Kconfig	2007-11-08 17:17:04.151557021 +0100
@@ -63,7 +63,8 @@ config PM_TRACE
 
 config PM_SLEEP_SMP
 	bool
-	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
+	depends on SMP
+	depends on SUSPEND_SMP_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
@@ -97,22 +98,9 @@ config SUSPEND
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (i.e. the ACPI S3 state).
 
-config HIBERNATION_UP_POSSIBLE
-	bool
-	depends on X86 || PPC64_SWSUSP || PPC32
-	depends on !SMP
-	default y
-
-config HIBERNATION_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || PPC64_SWSUSP
-	depends on SMP
-	default y
-
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
-	depends on PM && SWAP
-	depends on HIBERNATION_UP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
+	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
--- everything.orig/arch/i386/Kconfig	2007-11-08 16:47:42.301538141 +0100
+++ everything/arch/i386/Kconfig	2007-11-08 17:17:04.161529298 +0100
@@ -1319,3 +1319,7 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	bool
 	default y
+
+config ARCH_HIBERNATION_POSSIBLE
+	def_bool y
+	depends on !SMP || !X86_VOYAGER
--- everything.orig/arch/x86_64/Kconfig	2007-11-08 16:47:42.371532987 +0100
+++ everything/arch/x86_64/Kconfig	2007-11-08 17:17:04.161529298 +0100
@@ -716,6 +716,9 @@ menu "Power management options"
 
 source kernel/power/Kconfig
 
+config ARCH_HIBERNATION_POSSIBLE
+	def_bool y
+
 config ARCH_HIBERNATION_HEADER
 	bool
 	depends on HIBERNATION


