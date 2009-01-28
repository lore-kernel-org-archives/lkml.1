Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZA2ADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZA2ADx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZA1XpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbZA1XpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:10 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 050/114] x86, apic: unify phys_pkg_id()
Date: Wed, 28 Jan 2009 23:41:56 +0000
Message-Id: <1233186180-29883-51-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- unify the call signature of 64-bit to that of 32-bit

 - clean up the types all around

 - clean up namespace contamination

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    2 +-
 arch/x86/include/asm/genapic.h                |    6 +-----
 arch/x86/include/asm/mach-default/mach_apic.h |    2 +-
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    5 +++--
 arch/x86/kernel/cpu/addon_cpuid_features.c    |   10 +---------
 arch/x86/kernel/cpu/common.c                  |   11 +----------
 arch/x86/kernel/genapic_flat_64.c             |    6 +++---
 arch/x86/kernel/genx2apic_cluster.c           |    4 ++--
 arch/x86/kernel/genx2apic_phys.c              |    4 ++--
 arch/x86/kernel/genx2apic_uv_x.c              |    4 ++--
 12 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index f49d440..b7cba5b 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -133,7 +133,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+static inline int phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 038c4f0..d2c6c20 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -221,7 +221,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 	return apicid;
 }
 
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+static inline int phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index f292fd0..14b19de 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -48,11 +48,7 @@ struct genapic {
 	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
 	void (*enable_apic_mode)(void);
-#ifdef CONFIG_X86_32
-	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
-#else
-	unsigned int (*phys_pkg_id)(int index_msb);
-#endif
+	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
 
 	/*
 	 * When one of the next two hooks returns 1 the genapic
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 3647c92..55797a3 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -65,7 +65,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+static inline int phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index dc93c30..bc2c8a4 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -113,7 +113,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 }
 
 /* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+static inline int phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 526d19e..64cd441 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -175,13 +175,14 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 	return apicid;
 }
 
-/* cpuid returns the value latched in the HW at reset, not the APIC ID
+/*
+ * cpuid returns the value latched in the HW at reset, not the APIC ID
  * register's value.  For any box whose BIOS changes APIC IDs, like
  * clustered APIC systems, we must use hard_smp_processor_id.
  *
  * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
  */
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+static inline int phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
 }
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 4e581fd..84f8e4a 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -116,7 +116,6 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 
 	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
 
-#ifdef CONFIG_X86_32
 	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
 						 & core_select_mask;
 	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
@@ -124,14 +123,7 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 	 * Reinit the apicid, now that we have extended initial_apicid.
 	 */
 	c->apicid = phys_pkg_id(c->initial_apicid, 0);
-#else
-	c->cpu_core_id = phys_pkg_id(ht_mask_width) & core_select_mask;
-	c->phys_proc_id = phys_pkg_id(core_plus_mask_width);
-	/*
-	 * Reinit the apicid, now that we have extended initial_apicid.
-	 */
-	c->apicid = phys_pkg_id(0);
-#endif
+
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 275e2cb..93c491c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -442,11 +442,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		}
 
 		index_msb = get_count_order(smp_num_siblings);
-#ifdef CONFIG_X86_64
-		c->phys_proc_id = phys_pkg_id(index_msb);
-#else
 		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
-#endif
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -454,13 +450,8 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 		core_bits = get_count_order(c->x86_max_cores);
 
-#ifdef CONFIG_X86_64
-		c->cpu_core_id = phys_pkg_id(index_msb) &
-					       ((1 << core_bits) - 1);
-#else
 		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
 					       ((1 << core_bits) - 1);
-#endif
 	}
 
 out:
@@ -742,7 +733,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_identify(c);
 
 #ifdef CONFIG_X86_64
-	c->apicid = phys_pkg_id(0);
+	c->apicid = phys_pkg_id(c->initial_apicid, 0);
 #endif
 
 	/*
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 78adf71..cc9e07b 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -169,7 +169,7 @@ static unsigned int flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return mask1 & mask2;
 }
 
-static unsigned int phys_pkg_id(int index_msb)
+static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
 }
@@ -202,7 +202,7 @@ struct genapic apic_flat =  {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
@@ -346,7 +346,7 @@ struct genapic apic_physflat =  {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 7062e24..18b6f14 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -157,7 +157,7 @@ static unsigned long set_apic_id(unsigned int id)
 	return x;
 }
 
-static unsigned int phys_pkg_id(int index_msb)
+static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
 {
 	return current_cpu_data.initial_apicid >> index_msb;
 }
@@ -204,7 +204,7 @@ struct genapic apic_x2apic_cluster = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 7177a11..2cb6f49 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -156,7 +156,7 @@ static unsigned long set_apic_id(unsigned int id)
 	return x;
 }
 
-static unsigned int phys_pkg_id(int index_msb)
+static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
 {
 	return current_cpu_data.initial_apicid >> index_msb;
 }
@@ -200,7 +200,7 @@ struct genapic apic_x2apic_phys = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index debd721..67e7658 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -226,7 +226,7 @@ static unsigned int uv_read_apic_id(void)
 	return get_apic_id(apic_read(APIC_ID));
 }
 
-static unsigned int phys_pkg_id(int index_msb)
+static int uv_phys_pkg_id(int initial_apicid, int index_msb)
 {
 	return uv_read_apic_id() >> index_msb;
 }
@@ -265,7 +265,7 @@ struct genapic apic_x2apic_uv_x = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= phys_pkg_id,
+	.phys_pkg_id			= uv_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
-- 
1.6.0.2

