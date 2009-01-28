Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZA1Xwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZA1Xwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZA1XoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:37486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbZA1XoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:04 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 020/114] x86: clean up apic->apic_id_registered() methods
Date: Wed, 28 Jan 2009 23:41:26 +0000
Message-Id: <1233186180-29883-21-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

x86 subarchitectures each defined a "apic_id_registered()" method,
which could be an inline function depending on which subarch we build
for, and which was also the name of a genapic field.

Untangle this namespace spaghetti by giving each of the instances
a separate name.

Also remove wrapper macro obfuscation.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    4 ++--
 arch/x86/include/asm/es7000/apic.h            |    4 ++--
 arch/x86/include/asm/mach-default/mach_apic.h |    3 +--
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/apic.c                        |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index d8dd9f5..42c56df 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -4,9 +4,9 @@
 #define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
 #define esr_disable (1)
 
-static inline int apic_id_registered(void)
+static inline int bigsmp_apic_id_registered(void)
 {
-	return (1);
+	return 1;
 }
 
 static inline const cpumask_t *target_cpus(void)
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index c58b9cc..a1819b5 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -6,9 +6,9 @@
 #define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
 #define esr_disable (1)
 
-static inline int apic_id_registered(void)
+static inline int es7000_apic_id_registered(void)
 {
-	        return (1);
+	        return 1;
 }
 
 static inline const cpumask_t *target_cpus_cluster(void)
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 2448b92..6a454fa 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -25,7 +25,6 @@ static inline const struct cpumask *target_cpus(void)
 #define INT_DELIVERY_MODE (apic->int_delivery_mode)
 #define INT_DEST_MODE (apic->int_dest_mode)
 #define TARGET_CPUS	  (apic->target_cpus())
-#define apic_id_registered (apic->apic_id_registered)
 #define init_apic_ldr (apic->init_apic_ldr)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
@@ -57,7 +56,7 @@ static inline void init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline int apic_id_registered(void)
+static inline int default_apic_id_registered(void)
 {
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 59972d9..cc6e9d7 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -10,7 +10,6 @@
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (apic->apic_destination_logical)
 #define TARGET_CPUS	  (apic->target_cpus())
-#define apic_id_registered (apic->apic_id_registered)
 #define init_apic_ldr (apic->init_apic_ldr)
 #define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index bf37bc4..59b62b1 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -28,7 +28,7 @@ static inline unsigned long check_apicid_present(int bit)
 }
 #define apicid_cluster(apicid) (apicid & 0xF0)
 
-static inline int apic_id_registered(void)
+static inline int numaq_apic_id_registered(void)
 {
 	return 1;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 93d2c86..a36ef6e 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -74,7 +74,7 @@ static inline int multi_timer_check(int apic, int irq)
 	return 0;
 }
 
-static inline int apic_id_registered(void)
+static inline int summit_apic_id_registered(void)
 {
 	return 1;
 }
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index c6f1564..b6740de 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1171,7 +1171,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
-	if (!apic_id_registered())
+	if (!apic->apic_id_registered())
 		BUG();
 
 	/*
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 22c3608..17abf5c 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -62,7 +62,7 @@ struct genapic apic_bigsmp = {
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
 	.acpi_madt_oem_check		= NULL,
-	.apic_id_registered		= apic_id_registered,
+	.apic_id_registered		= bigsmp_apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
 	.int_dest_mode			= INT_DEST_MODE,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index cfec349..1f30559 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -29,7 +29,7 @@ struct genapic apic_default = {
 	.name				= "default",
 	.probe				= probe_default,
 	.acpi_madt_oem_check		= NULL,
-	.apic_id_registered		= apic_id_registered,
+	.apic_id_registered		= default_apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
 	.int_dest_mode			= INT_DEST_MODE,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 23fe6f1..d68ca0b 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -105,7 +105,7 @@ struct genapic apic_es7000 = {
 	.name				= "es7000",
 	.probe				= probe_es7000,
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
-	.apic_id_registered		= apic_id_registered,
+	.apic_id_registered		= es7000_apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
 	.int_dest_mode			= INT_DEST_MODE,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 9691b4e..b22a79b 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -49,7 +49,7 @@ struct genapic apic_numaq = {
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
 	.acpi_madt_oem_check		= NULL,
-	.apic_id_registered		= apic_id_registered,
+	.apic_id_registered		= numaq_apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
 	.int_dest_mode			= INT_DEST_MODE,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 0eea9fb..744fa1b 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -42,7 +42,7 @@ struct genapic apic_summit = {
 	.name				= "summit",
 	.probe				= probe_summit,
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
-	.apic_id_registered		= apic_id_registered,
+	.apic_id_registered		= summit_apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
 	.int_dest_mode			= INT_DEST_MODE,
-- 
1.6.0.2

