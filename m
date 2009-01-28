Return-Path: <linux-kernel-owner+w=401wt.eu-S1764448AbZA2AW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764448AbZA2AW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbZA1XrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:53372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbZA1Xq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 096/114] x86/Voyager: remove X86_FIND_SMP_CONFIG Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:42 +0000
Message-Id: <1233186180-29883-97-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager had this Kconfig quirk:

 config X86_FIND_SMP_CONFIG
	def_bool y
	depends on X86_MPPARSE || X86_VOYAGER

Which splits off the find_smp_config() callback into a build-time quirk.

Voyager should use the existing x86_quirks.mach_find_smp_config() callback
to introduce SMP-config quirks. NUMAQ-32 and VISWS already use this.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig              |    4 ----
 arch/x86/include/asm/mpspec.h |    4 +++-
 arch/x86/kernel/setup.c       |    3 +--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c0d79ab..df7cb8d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -254,10 +254,6 @@ config NUMA_MIGRATE_IRQ_DESC
 
 	  If you don't know what to do here, say N.
 
-config X86_FIND_SMP_CONFIG
-	def_bool y
-	depends on X86_MPPARSE || X86_VOYAGER
-
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 03fb0d3..d22f732 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -56,11 +56,13 @@ extern int smp_found_config;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
-extern void find_smp_config(void);
 extern void get_smp_config(void);
+
 #ifdef CONFIG_X86_MPPARSE
+extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
 #else
+static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 609e5af..6abce67 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -905,12 +905,11 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_reserve_bootmem();
 #endif
-#ifdef CONFIG_X86_FIND_SMP_CONFIG
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
 	find_smp_config();
-#endif
+
 	reserve_crashkernel();
 
 #ifdef CONFIG_X86_64
-- 
1.6.0.2

