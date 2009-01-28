Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbZA2ADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbZA2ADi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZA1XpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:52994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907AbZA1XpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:08 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 051/114] x86, apic: refactor ->phys_pkg_id()
Date: Wed, 28 Jan 2009 23:41:57 +0000
Message-Id: <1233186180-29883-52-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the ->phys_pkg_id() methods:

 - namespace separation

 - macro wrapper removal

 - open-coded calls to the methods in the generic code

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h |    3 +--
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c    |    6 +++---
 arch/x86/kernel/cpu/common.c                  |    8 ++++----
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 13 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index b7cba5b..1230f5d 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -133,7 +133,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static inline int phys_pkg_id(int cpuid_apic, int index_msb)
+static inline int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index d2c6c20..f183dfb 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -221,7 +221,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 	return apicid;
 }
 
-static inline int phys_pkg_id(int cpuid_apic, int index_msb)
+static inline int es7000_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 55797a3..d060528 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -21,7 +21,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #include <asm/genapic.h>
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
-#define phys_pkg_id	(apic->phys_pkg_id)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
 #define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
@@ -65,7 +64,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
-static inline int phys_pkg_id(int cpuid_apic, int index_msb)
+static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 6fed521..1eeb5b6 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -5,7 +5,6 @@
 
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
-#define phys_pkg_id (apic->phys_pkg_id)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 
 extern void generic_bigsmp_probe(void);
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index bc2c8a4..765c4d5 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -113,7 +113,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 }
 
 /* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
-static inline int phys_pkg_id(int cpuid_apic, int index_msb)
+static inline int numaq_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 64cd441..fa6b3b4 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -182,7 +182,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
  *
  * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
  */
-static inline int phys_pkg_id(int cpuid_apic, int index_msb)
+static inline int summit_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
 }
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 84f8e4a..e8bb892 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -116,13 +116,13 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 
 	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
 
-	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
+	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
 						 & core_select_mask;
-	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
 	/*
 	 * Reinit the apicid, now that we have extended initial_apicid.
 	 */
-	c->apicid = phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
 
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 93c491c..055b9c3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -442,7 +442,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		}
 
 		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
+		c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -450,7 +450,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 		core_bits = get_count_order(c->x86_max_cores);
 
-		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
+		c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, index_msb) &
 					       ((1 << core_bits) - 1);
 	}
 
@@ -686,7 +686,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
-		c->apicid = phys_pkg_id(c->initial_apicid, 0);
+		c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
 # else
 		c->apicid = c->initial_apicid;
 # endif
@@ -733,7 +733,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_identify(c);
 
 #ifdef CONFIG_X86_64
-	c->apicid = phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
 #endif
 
 	/*
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index e151b47..d04b389 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -87,7 +87,7 @@ struct genapic apic_bigsmp = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= bigsmp_phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index ac6be19..5c9266f 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -68,7 +68,7 @@ struct genapic apic_default = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= default_phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 1185964..52787e3 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -122,7 +122,7 @@ struct genapic apic_es7000 = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
 	.enable_apic_mode		= es7000_enable_apic_mode,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= es7000_phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 8d3358d..6a1134e 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -87,7 +87,7 @@ struct genapic apic_numaq = {
 	.setup_portio_remap		= numaq_setup_portio_remap,
 	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= numaq_phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index cb83bcb..2d6843a 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -67,7 +67,7 @@ struct genapic apic_summit = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= summit_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= summit_phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
-- 
1.6.0.2

