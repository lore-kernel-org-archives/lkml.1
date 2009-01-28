Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbZA1Xzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbZA1Xzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbZA1XoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZA1XoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:19 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 029/114] x86, apic: clean up target_cpus methods
Date: Wed, 28 Jan 2009 23:41:35 +0000
Message-Id: <1233186180-29883-30-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Clean up all the target_cpus() namespace overlap that exists
between bigsmp, es7000, mach-default, numaq and summit - by
separating the different functions into different names.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    4 ++--
 arch/x86/include/asm/mach-default/mach_apic.h |    4 ++--
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index dca2d5b..d6aeca3 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -9,7 +9,7 @@ static inline int bigsmp_apic_id_registered(void)
 	return 1;
 }
 
-static inline const cpumask_t *target_cpus(void)
+static inline const cpumask_t *bigsmp_target_cpus(void)
 {
 #ifdef CONFIG_SMP
 	return &cpu_online_map;
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 342416b..7e5c31a 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -16,7 +16,7 @@ static inline const cpumask_t *target_cpus_cluster(void)
 	return &CPU_MASK_ALL;
 }
 
-static inline const cpumask_t *target_cpus(void)
+static inline const cpumask_t *es7000_target_cpus(void)
 {
 	return &cpumask_of_cpu(smp_processor_id());
 }
@@ -83,7 +83,7 @@ static inline void setup_apic_routing(void)
 	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
 			"Physical Cluster" : "Logical Cluster",
-			nr_ioapics, cpus_addr(*target_cpus())[0]);
+			nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
 }
 
 static inline int multi_timer_check(int apic, int irq)
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index ce3bc48..af1607d 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -8,7 +8,7 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
 
-static inline const struct cpumask *target_cpus(void)
+static inline const struct cpumask *default_target_cpus(void)
 { 
 #ifdef CONFIG_SMP
 	return cpu_online_mask;
@@ -33,7 +33,7 @@ static inline const struct cpumask *target_cpus(void)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
-#define TARGET_CPUS (target_cpus())
+#define TARGET_CPUS (default_target_cpus())
 #define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
  * Set up the logical destination ID.
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index a9d8467..1111ff9 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -7,7 +7,7 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline const cpumask_t *target_cpus(void)
+static inline const cpumask_t *numaq_target_cpus(void)
 {
 	return &CPU_MASK_ALL;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 427d088..7c1f915 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -15,7 +15,7 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline const cpumask_t *target_cpus(void)
+static inline const cpumask_t *summit_target_cpus(void)
 {
 	/* CPU_MASK_ALL (0xff) has undefined behaviour with
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 06be776..d3cead2 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -68,7 +68,7 @@ struct genapic apic_bigsmp = {
 	/* phys delivery to target CPU: */
 	.irq_dest_mode			= 0,
 
-	.target_cpus			= target_cpus,
+	.target_cpus			= bigsmp_target_cpus,
 	.ESR_DISABLE			= esr_disable,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index fe97b01..a483e22 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -35,7 +35,7 @@ struct genapic apic_default = {
 	/* logical delivery broadcast to all CPUs: */
 	.irq_dest_mode			= 1,
 
-	.target_cpus			= target_cpus,
+	.target_cpus			= default_target_cpus,
 	.ESR_DISABLE			= esr_disable,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 269a97a..e31f0c3 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -111,7 +111,7 @@ struct genapic apic_es7000 = {
 	/* phys delivery to target CPUs: */
 	.irq_dest_mode			= 0,
 
-	.target_cpus			= target_cpus,
+	.target_cpus			= es7000_target_cpus,
 	.ESR_DISABLE			= esr_disable,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 6daddb6..4b84b59 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -55,7 +55,7 @@ struct genapic apic_numaq = {
 	/* physical delivery on LOCAL quad: */
 	.irq_dest_mode			= 0,
 
-	.target_cpus			= target_cpus,
+	.target_cpus			= numaq_target_cpus,
 	.ESR_DISABLE			= esr_disable,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 1b9164b..e6b956a 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -48,7 +48,7 @@ struct genapic apic_summit = {
 	/* logical delivery broadcast to all CPUs: */
 	.irq_dest_mode			= 1,
 
-	.target_cpus			= target_cpus,
+	.target_cpus			= summit_target_cpus,
 	.ESR_DISABLE			= esr_disable,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
-- 
1.6.0.2

