Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZA2WUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZA2WUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbZA2WUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:20:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:60762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759713AbZA2WUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:20:35 -0500
Message-ID: <49822B6A.80603@kernel.org>
Date: Thu, 29 Jan 2009 14:19:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: don't treat bigsmp as no standard.
References: <49822B1D.9070708@kernel.org>
In-Reply-To: <49822B1D.9070708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: auto switch if bigsmp is build it

just like 64 bit switch from logic flat to physflat mode automatically

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig            |   15 +++++++--------
 arch/x86/kernel/acpi/boot.c |    2 +-
 arch/x86/kernel/mpparse.c   |    4 ++--
 arch/x86/kernel/setup.c     |    2 +-
 arch/x86/kernel/smpboot.c   |    2 +-
 5 files changed, 12 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -265,6 +265,12 @@ config X86_MPPARSE
 config X86_PC
 	def_bool y
 
+config X86_BIGSMP
+	bool "Support for big SMP systems with more than 8 CPUs"
+	depends on X86_32 && SMP
+	help
+	  This option is needed for the systems that have more than 8 CPUs
+
 config X86_NON_STANDARD
 	bool "Support for non-standard x86 platforms"
 	help
@@ -341,13 +347,6 @@ config X86_32_NON_STANDARD
 	  if you select them all, kernel will probe it one by one. and will
 	  fallback to default.
 
-config X86_BIGSMP
-	bool "Support for big SMP systems with more than 8 CPUs"
-	depends on X86_32_NON_STANDARD
-	help
-	  This option is needed for the systems that have more than 8 CPUs
-	  and if the system is not of any sub-arch type above.
-
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
 	depends on X86_32_NON_STANDARD
@@ -369,7 +368,7 @@ config X86_SUMMIT
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
-	depends on X86_32_NON_STANDARD
+	depends on X86_32_NON_STANDARD && X86_BIGSMP
 	help
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1318,7 +1318,7 @@ static void __init acpi_process_madt(voi
 		if (!error) {
 			acpi_lapic = 1;
 
-#ifdef CONFIG_X86_32_NON_STANDARD
+#ifdef CONFIG_X86_BIGSMP
 			generic_bigsmp_probe();
 #endif
 			/*
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -372,8 +372,8 @@ static int __init smp_read_mpc(struct mp
 			(*x86_quirks->mpc_record)++;
 	}
 
-#ifdef CONFIG_X86_32_NON_STANDARD
-       generic_bigsmp_probe();
+#ifdef CONFIG_X86_BIGSMP
+	generic_bigsmp_probe();
 #endif
 
 	if (apic->setup_apic_routing)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -936,7 +936,7 @@ void __init setup_arch(char **cmdline_p)
 	map_vsyscall();
 #endif
 
-#ifdef CONFIG_X86_32_NON_STANDARD
+#if defined(CONFIG_X86_32_NON_STANDARD) || defined(CONFIG_X86_BIGSMP)
 	generic_apic_probe();
 #endif
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1007,7 +1007,7 @@ static int __init smp_sanity_check(unsig
 
 		printk(KERN_WARNING
 		       "More than 8 CPUs detected - skipping them.\n"
-		       "Use CONFIG_X86_32_NON_STANDARD and CONFIG_X86_BIGSMP.\n");
+		       "Use CONFIG_X86_BIGSMP.\n");
 
 		nr = 0;
 		for_each_present_cpu(cpu) {
