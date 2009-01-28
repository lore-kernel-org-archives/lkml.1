Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZA1X5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZA1X5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZA1Xoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:37597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362AbZA1Xog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:36 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 037/114] x86, apic: clean up ->vector_allocation_domain()
Date: Wed, 28 Jan 2009 23:41:43 +0000
Message-Id: <1233186180-29883-38-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

 - move the default vector-allocation-domain to mach-generic

 - fix whitespace damage

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach-default/mach_apic.h |   13 -------------
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/kernel/io_apic.c                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    4 ++--
 arch/x86/mach-generic/default.c               |   16 +++++++++++++++-
 arch/x86/mach-generic/es7000.c                |    4 ++--
 arch/x86/mach-generic/numaq.c                 |    4 ++--
 arch/x86/mach-generic/summit.c                |    4 ++--
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 8adccf8..9c56542 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -23,7 +23,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define phys_pkg_id	(apic->phys_pkg_id)
-#define vector_allocation_domain    (apic->vector_allocation_domain)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
 #define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
@@ -89,18 +88,6 @@ static inline int apicid_to_node(int logical_apicid)
 #endif
 }
 
-static inline void vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-        /* Careful. Some cpus do not strictly honor the set of cpus
-         * specified in the interrupt destination when using lowest
-         * priority interrupt delivery mode.
-         *
-         * In particular there was a hyperthreading cpu observed to
-         * deliver interrupts to the wrong hyperthread when only one
-         * hyperthread was specified in the interrupt desitination.
-         */
-	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
-}
 #endif
 
 static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 4cb9e2b..e94881a 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -15,7 +15,6 @@
 #define check_phys_apicid_present (apic->check_phys_apicid_present)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
-#define vector_allocation_domain (apic->vector_allocation_domain)
 #define enable_apic_mode (apic->enable_apic_mode)
 #define phys_pkg_id (apic->phys_pkg_id)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 733ecf1..49899e0 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1316,7 +1316,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 		int new_cpu;
 		int vector, offset;
 
-		vector_allocation_domain(cpu, tmp_mask);
+		apic->vector_allocation_domain(cpu, tmp_mask);
 
 		vector = current_vector;
 		offset = current_offset;
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 6da251a..391cc99 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -42,7 +42,7 @@ static const struct dmi_system_id bigsmp_dmi_table[] = {
 	 { }
 };
 
-static void vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void bigsmp_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	cpus_clear(*retmask);
 	cpu_set(cpu, *retmask);
@@ -74,7 +74,7 @@ struct genapic apic_bigsmp = {
 	.check_apicid_used		= bigsmp_check_apicid_used,
 	.check_apicid_present		= bigsmp_check_apicid_present,
 
-	.vector_allocation_domain	= vector_allocation_domain,
+	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index e89e8c9..6adc3c6 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -18,6 +18,20 @@
 #include <asm/mach-default/mach_mpparse.h>
 #include <asm/mach-default/mach_wakecpu.h>
 
+static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	/*
+	 * Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
+}
+
 /* should be called last. */
 static int probe_default(void)
 {
@@ -41,7 +55,7 @@ struct genapic apic_default = {
 	.check_apicid_used		= default_check_apicid_used,
 	.check_apicid_present		= default_check_apicid_present,
 
-	.vector_allocation_domain	= vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 8e9eeec..bc1f21c 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -86,7 +86,7 @@ static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 #endif
 
-static void vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void es7000_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -116,7 +116,7 @@ struct genapic apic_es7000 = {
 	.check_apicid_used		= es7000_check_apicid_used,
 	.check_apicid_present		= es7000_check_apicid_present,
 
-	.vector_allocation_domain	= vector_allocation_domain,
+	.vector_allocation_domain	= es7000_vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index f909189..712882f 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -31,7 +31,7 @@ static int probe_numaq(void)
 	return found_numaq;
 }
 
-static void vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void numaq_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -61,7 +61,7 @@ struct genapic apic_numaq = {
 	.check_apicid_used		= numaq_check_apicid_used,
 	.check_apicid_present		= numaq_check_apicid_present,
 
-	.vector_allocation_domain	= vector_allocation_domain,
+	.vector_allocation_domain	= numaq_vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 99a9bea..1834887 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -24,7 +24,7 @@ static int probe_summit(void)
 	return 0;
 }
 
-static void vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -54,7 +54,7 @@ struct genapic apic_summit = {
 	.check_apicid_used		= summit_check_apicid_used,
 	.check_apicid_present		= summit_check_apicid_present,
 
-	.vector_allocation_domain	= vector_allocation_domain,
+	.vector_allocation_domain	= summit_vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
-- 
1.6.0.2

