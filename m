Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYKRQPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYKRQPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYKRQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:14:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:38354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbYKRQOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:14:55 -0500
Message-ID: <4922E9D6.3020309@kernel.org>
Date: Tue, 18 Nov 2008 08:14:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use update_genapic to get rid of ES7000_CLUSTERED_APIC
 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org> <20081117232837.GA10308@elte.hu> <20081118074346.GA21875@elte.hu> <4922E99B.8090604@kernel.org>
In-Reply-To: <4922E99B.8090604@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

could autodetect those system that need cluster apic, and update genapic
accordingly.
also could remove wakeup.h for e7000, because it's default one is the same as
overall default mach_wakecpu.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig                      |    4 -
 arch/x86/include/asm/es7000/apic.h    |   76 +++++++++++++++++++++++-----------
 arch/x86/include/asm/es7000/wakecpu.h |   37 ----------------
 arch/x86/include/asm/genapic_32.h     |    1 
 arch/x86/kernel/es7000_32.c           |   17 +++++--
 arch/x86/mach-generic/es7000.c        |   14 +++++-
 6 files changed, 80 insertions(+), 69 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -459,10 +459,6 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_GENERICARCH
 
-config ES7000_CLUSTERED_APIC
-	def_bool y
-	depends on SMP && X86_ES7000 && MPENTIUMIII
-
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
Index: linux-2.6/arch/x86/include/asm/es7000/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/es7000/apic.h
+++ linux-2.6/arch/x86/include/asm/es7000/apic.h
@@ -9,28 +9,27 @@ static inline int apic_id_registered(voi
 	        return (1);
 }
 
-static inline cpumask_t target_cpus(void)
+static inline cpumask_t target_cpus_cluster(void)
 {
-#if defined CONFIG_ES7000_CLUSTERED_APIC
 	return CPU_MASK_ALL;
-#else
+}
+
+static inline cpumask_t target_cpus(void)
+{
 	return cpumask_of_cpu(smp_processor_id());
-#endif
 }
 
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-#define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
-#define INT_DELIVERY_MODE	(dest_LowestPrio)
-#define INT_DEST_MODE		(1)    /* logical delivery broadcast to all procs */
-#define NO_BALANCE_IRQ		(1)
-#else
+#define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
+#define INT_DELIVERY_MODE_CLUSTER	(dest_LowestPrio)
+#define INT_DEST_MODE_CLUSTER		(1) /* logical delivery broadcast to all procs */
+#define NO_BALANCE_IRQ_CLUSTER		(1)
+
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
 #define INT_DEST_MODE		(0)    /* phys delivery to target procs */
 #define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
-#endif
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
@@ -57,6 +56,16 @@ static inline unsigned long calculate_ld
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
+static inline void init_apic_ldr_cluster(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE_CLUSTER);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
 static inline void init_apic_ldr(void)
 {
 	unsigned long val;
@@ -67,10 +76,6 @@ static inline void init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-#ifndef CONFIG_X86_GENERICARCH
-extern void enable_apic_mode(void);
-#endif
-
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
@@ -141,7 +146,7 @@ static inline int check_phys_apicid_pres
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid_cluster(cpumask_t cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
@@ -151,11 +156,7 @@ static inline unsigned int cpu_mask_to_a
 	num_bits_set = cpus_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
-#if defined CONFIG_ES7000_CLUSTERED_APIC
 		return 0xFF;
-#else
-		return cpu_to_logical_apicid(0);
-#endif
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
@@ -168,11 +169,40 @@ static inline unsigned int cpu_mask_to_a
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n", __func__);
-#if defined CONFIG_ES7000_CLUSTERED_APIC
 				return 0xFF;
-#else
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int num_bits_set;
+	int cpus_found = 0;
+	int cpu;
+	int apicid;
+
+	num_bits_set = cpus_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == NR_CPUS)
+		return cpu_to_logical_apicid(0);
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	cpu = first_cpu(cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, cpumask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n", __func__);
 				return cpu_to_logical_apicid(0);
-#endif
 			}
 			apicid = new_apicid;
 			cpus_found++;
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -38,6 +38,7 @@
 #include <asm/io.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
+#include <asm/atomic.h>
 #include <asm/apicdef.h>
 #include <mach_mpparse.h>
 #include <asm/genapic.h>
@@ -163,7 +164,6 @@ es7000_rename_gsi(int ioapic, int gsi)
 	return gsi;
 }
 
-#ifdef CONFIG_ES7000_CLUSTERED_APIC
 static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
@@ -182,13 +182,24 @@ static int wakeup_secondary_cpu_via_mip(
 	return 0;
 }
 
+static void noop_wait_for_deassert(atomic_t *deassert_not_used)
+{
+}
+
 static int __init es7000_update_genapic(void)
 {
 	genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
 
+	/* MPENTIUMIII */
+	if (boot_cpu_data.x86 == 6 &&
+	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11)) {
+		es7000_update_genapic_to_cluster();
+		genapic->wait_for_init_deassert = noop_wait_for_deassert;
+		genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
+	}
+
 	return 0;
 }
-#endif
 
 void __init
 setup_unisys(void)
@@ -206,9 +217,7 @@ setup_unisys(void)
 		es7000_plat = ES7000_CLASSIC;
 	ioapic_renumber_irq = es7000_rename_gsi;
 
-#ifdef CONFIG_ES7000_CLUSTERED_APIC
 	x86_quirks->update_genapic = es7000_update_genapic;
-#endif
 }
 
 /*
Index: linux-2.6/arch/x86/mach-generic/es7000.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6/arch/x86/mach-generic/es7000.c
@@ -16,7 +16,19 @@
 #include <asm/es7000/apic.h>
 #include <asm/es7000/ipi.h>
 #include <asm/es7000/mpparse.h>
-#include <asm/es7000/wakecpu.h>
+#include <asm/mach-default/mach_wakecpu.h>
+
+void __init es7000_update_genapic_to_cluster(void)
+{
+	genapic->target_cpus = target_cpus_cluster;
+	genapic->int_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
+	genapic->int_dest_mode = INT_DEST_MODE_CLUSTER;
+	genapic->no_balance_irq = NO_BALANCE_IRQ_CLUSTER;
+
+	genapic->init_apic_ldr = init_apic_ldr_cluster;
+
+	genapic->cpu_mask_to_apicid = cpu_mask_to_apicid_cluster;
+}
 
 static int probe_es7000(void)
 {
Index: linux-2.6/arch/x86/include/asm/genapic_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_32.h
+++ linux-2.6/arch/x86/include/asm/genapic_32.h
@@ -131,6 +131,7 @@ struct genapic {
 }
 
 extern struct genapic *genapic;
+extern void es7000_update_genapic_to_cluster(void);
 
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 #define get_uv_system_type()		UV_NONE
Index: linux-2.6/arch/x86/include/asm/es7000/wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/es7000/wakecpu.h
+++ /dev/null
@@ -1,37 +0,0 @@
-#ifndef __ASM_ES7000_WAKECPU_H
-#define __ASM_ES7000_WAKECPU_H
-
-#define TRAMPOLINE_PHYS_LOW (0x467)
-#define TRAMPOLINE_PHYS_HIGH (0x469)
-
-static inline void wait_for_init_deassert(atomic_t *deassert)
-{
-#ifndef CONFIG_ES7000_CLUSTERED_APIC
-	while (!atomic_read(deassert))
-		cpu_relax();
-#endif
-	return;
-}
-
-/* Nothing to do for most platforms, since cleared by the INIT cycle */
-static inline void smp_callin_clear_local_apic(void)
-{
-}
-
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-extern void __inquire_remote_apic(int apicid);
-
-static inline void inquire_remote_apic(int apicid)
-{
-	if (apic_verbosity >= APIC_DEBUG)
-		__inquire_remote_apic(apicid);
-}
-
-#endif /* __ASM_MACH_WAKECPU_H */

