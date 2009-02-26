Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZBZEwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZBZEwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZBZEv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:51:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:45451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZBZEv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:51:57 -0500
Message-ID: <49A61FA9.5080706@kernel.org>
Date: Wed, 25 Feb 2009 20:50:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove update_apic from x86_quirks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

x86_quirks->update_apic() calling looks crazy. so try to remove it
1. every apic take wakeup_cpu member directly
2. seperate es7000_apic to es7000_apic_cluster
3. use uv_wakeup_cpu directly

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apic.h           |    7 +
 arch/x86/include/asm/setup.h          |    3 
 arch/x86/include/asm/uv/uv.h          |    3 
 arch/x86/kernel/apic/apic_flat_64.c   |    4 -
 arch/x86/kernel/apic/bigsmp_32.c      |    2 
 arch/x86/kernel/apic/es7000_32.c      |  127 ++++++++++++++++++++++++++--------
 arch/x86/kernel/apic/numaq_32.c       |   10 --
 arch/x86/kernel/apic/probe_32.c       |   16 ----
 arch/x86/kernel/apic/probe_64.c       |    3 
 arch/x86/kernel/apic/summit_32.c      |    2 
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |   11 +-
 arch/x86/kernel/setup.c               |   14 ---
 arch/x86/kernel/smpboot.c             |    8 --
 15 files changed, 121 insertions(+), 93 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -325,6 +325,9 @@ struct apic {
 };
 
 extern struct apic *apic;
+extern atomic_t init_deasserted;
+extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
+extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 
 static inline u32 apic_read(u32 reg)
 {
@@ -384,9 +387,7 @@ static inline unsigned default_get_apic_
 #define DEFAULT_TRAMPOLINE_PHYS_LOW		0x467
 #define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
 
-#ifdef CONFIG_X86_32
-extern void es7000_update_apic_to_cluster(void);
-#else
+#ifdef CONFIG_X86_64
 extern struct apic apic_flat;
 extern struct apic apic_physflat;
 extern struct apic apic_x2apic_cluster;
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -31,7 +31,6 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
-	int (*update_apic)(void);
 };
 
 extern void x86_quirk_pre_intr_init(void);
@@ -77,8 +76,6 @@ static inline void visws_early_detect(vo
 static inline int is_visws_box(void) { return 0; }
 #endif
 
-extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
-extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 extern struct x86_quirks *x86_quirks;
 extern unsigned long saved_video_mode;
 
Index: linux-2.6/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/uv/uv.h
+++ linux-2.6/arch/x86/include/asm/uv/uv.h
@@ -12,7 +12,6 @@ extern enum uv_system_type get_uv_system
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_system_init(void);
-extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long va,
@@ -24,8 +23,6 @@ static inline enum uv_system_type get_uv
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
-static inline int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
-{ return 1; }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long va, unsigned int cpu)
Index: linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
@@ -222,7 +222,7 @@ struct apic apic_flat =  {
 	.send_IPI_all			= flat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
@@ -373,7 +373,7 @@ struct apic apic_physflat =  {
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
Index: linux-2.6/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6/arch/x86/kernel/apic/bigsmp_32.c
@@ -256,7 +256,7 @@ struct apic apic_bigsmp = {
 	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
Index: linux-2.6/arch/x86/kernel/apic/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6/arch/x86/kernel/apic/es7000_32.c
@@ -163,17 +163,12 @@ static int wakeup_secondary_cpu_via_mip(
 	return 0;
 }
 
-static int __init es7000_update_apic(void)
+static int __init es7000_apic_is_cluster(void)
 {
-	apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
-
 	/* MPENTIUMIII */
 	if (boot_cpu_data.x86 == 6 &&
-	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11)) {
-		es7000_update_apic_to_cluster();
-		apic->wait_for_init_deassert = NULL;
-		apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
-	}
+	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11))
+		return 1;
 
 	return 0;
 }
@@ -192,8 +187,6 @@ static void __init setup_unisys(void)
 	else
 		es7000_plat = ES7000_CLASSIC;
 	ioapic_renumber_irq = es7000_rename_gsi;
-
-	x86_quirks->update_apic = es7000_update_apic;
 }
 
 /*
@@ -310,6 +303,8 @@ static int es7000_check_dsdt(void)
 	return 0;
 }
 
+static int __initdata es7000_acpi_ret;
+
 /* Hook from generic ACPI tables.c */
 static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -332,8 +327,19 @@ static int __init es7000_acpi_madt_oem_c
 		 */
 		unmap_unisys_acpi_oem_table(oem_addr);
 	}
-	return ret;
+
+	es7000_acpi_ret = ret;
+
+	return ret && !es7000_apic_is_cluster();
+}
+static int __init es7000_acpi_madt_oem_check_cluster(char *oem_id,
+						     char *oem_table_id)
+{
+	int ret = es7000_acpi_ret;
+
+	return ret && es7000_apic_is_cluster();
 }
+
 #else /* !CONFIG_ACPI: */
 static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -416,11 +422,8 @@ static void es7000_vector_allocation_dom
 
 static void es7000_wait_for_init_deassert(atomic_t *deassert)
 {
-#ifndef CONFIG_ES7000_CLUSTERED_APIC
 	while (!atomic_read(deassert))
 		cpu_relax();
-#endif
-	return;
 }
 
 static unsigned int es7000_get_apic_id(unsigned long x)
@@ -659,37 +662,103 @@ static int es7000_phys_pkg_id(int cpuid_
 	return cpuid_apic >> index_msb;
 }
 
-void __init es7000_update_apic_to_cluster(void)
-{
-	apic->target_cpus = target_cpus_cluster;
-	apic->irq_delivery_mode = dest_LowestPrio;
-	/* logical delivery broadcast to all procs: */
-	apic->irq_dest_mode = 1;
-
-	apic->init_apic_ldr = es7000_init_apic_ldr_cluster;
-
-	apic->cpu_mask_to_apicid = es7000_cpu_mask_to_apicid_cluster;
-}
-
 static int probe_es7000(void)
 {
 	/* probed later in mptable/ACPI hooks */
 	return 0;
 }
 
+static int __initdata es7000_mps_ret;
 static __init int
 es7000_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
+	int ret = 0;
+
 	if (mpc->oemptr) {
 		struct mpc_oemtable *oem_table =
 			(struct mpc_oemtable *)mpc->oemptr;
 
 		if (!strncmp(oem, "UNISYS", 6))
-			return parse_unisys_oem((char *)oem_table);
+			ret = parse_unisys_oem((char *)oem_table);
 	}
-	return 0;
+
+	es7000_mps_ret = ret;
+
+	return ret && !es7000_apic_is_cluster();
+}
+
+static __init int
+es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem, char *productid)
+{
+	int ret = es7000_mps_ret;
+
+	return ret && es7000_apic_is_cluster();
 }
 
+struct apic apic_es7000_cluster = {
+
+	.name				= "es7000",
+	.probe				= probe_es7000,
+	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check_cluster,
+	.apic_id_registered		= es7000_apic_id_registered,
+
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all procs: */
+	.irq_dest_mode			= 1,
+
+	.target_cpus			= target_cpus_cluster,
+	.disable_esr			= 1,
+	.dest_logical			= 0,
+	.check_apicid_used		= es7000_check_apicid_used,
+	.check_apicid_present		= es7000_check_apicid_present,
+
+	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.init_apic_ldr			= es7000_init_apic_ldr_cluster,
+
+	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
+	.setup_apic_routing		= es7000_setup_apic_routing,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= es7000_apicid_to_node,
+	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
+	.enable_apic_mode		= es7000_enable_apic_mode,
+	.phys_pkg_id			= es7000_phys_pkg_id,
+	.mps_oem_check			= es7000_mps_oem_check_cluster,
+
+	.get_apic_id			= es7000_get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= 0xFF << 24,
+
+	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid_cluster,
+	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= es7000_send_IPI_mask,
+	.send_IPI_mask_allbutself	= NULL,
+	.send_IPI_allbutself		= es7000_send_IPI_allbutself,
+	.send_IPI_all			= es7000_send_IPI_all,
+	.send_IPI_self			= default_send_IPI_self,
+
+	.wakeup_cpu			= wakeup_secondary_cpu_via_mip,
+
+	.trampoline_phys_low		= 0x467,
+	.trampoline_phys_high		= 0x469,
+
+	.wait_for_init_deassert		= NULL,
+
+	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
+	.smp_callin_clear_local_apic	= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+};
 
 struct apic apic_es7000 = {
 
@@ -737,7 +806,7 @@ struct apic apic_es7000 = {
 	.send_IPI_all			= es7000_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -256,13 +256,6 @@ static int __init numaq_setup_ioapic_ids
 	return 1;
 }
 
-static int __init numaq_update_apic(void)
-{
-	apic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
-
-	return 0;
-}
-
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
@@ -278,7 +271,6 @@ static struct x86_quirks numaq_x86_quirk
 	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
 	.smp_read_mpc_oem		= smp_read_mpc_oem,
 	.setup_ioapic_ids		= numaq_setup_ioapic_ids,
-	.update_apic			= numaq_update_apic,
 };
 
 static __init void early_check_numaq(void)
@@ -546,7 +538,7 @@ struct apic apic_numaq = {
 	.send_IPI_all			= numaq_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_nmi,
 	.trampoline_phys_low		= NUMAQ_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
 
Index: linux-2.6/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6/arch/x86/kernel/apic/probe_32.c
@@ -138,7 +138,7 @@ struct apic apic_default = {
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
@@ -159,6 +159,7 @@ extern struct apic apic_numaq;
 extern struct apic apic_summit;
 extern struct apic apic_bigsmp;
 extern struct apic apic_es7000;
+extern struct apic apic_es7000_cluster;
 extern struct apic apic_default;
 
 struct apic *apic = &apic_default;
@@ -176,6 +177,7 @@ static struct apic *apic_probe[] __initd
 #endif
 #ifdef CONFIG_X86_ES7000
 	&apic_es7000,
+	&apic_es7000_cluster,
 #endif
 	&apic_default,	/* must be last */
 	NULL,
@@ -197,9 +199,6 @@ static int __init parse_apic(char *arg)
 		}
 	}
 
-	if (x86_quirks->update_apic)
-		x86_quirks->update_apic();
-
 	/* Parsed again by __setup for debug/verbose */
 	return 0;
 }
@@ -218,8 +217,6 @@ void __init generic_bigsmp_probe(void)
 	if (!cmdline_apic && apic == &apic_default) {
 		if (apic_bigsmp.probe()) {
 			apic = &apic_bigsmp;
-			if (x86_quirks->update_apic)
-				x86_quirks->update_apic();
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
 			       apic->name);
 		}
@@ -240,9 +237,6 @@ void __init generic_apic_probe(void)
 		/* Not visible without early console */
 		if (!apic_probe[i])
 			panic("Didn't find an APIC driver");
-
-		if (x86_quirks->update_apic)
-			x86_quirks->update_apic();
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
 }
@@ -262,8 +256,6 @@ generic_mps_oem_check(struct mpc_table *
 
 		if (!cmdline_apic) {
 			apic = apic_probe[i];
-			if (x86_quirks->update_apic)
-				x86_quirks->update_apic();
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
@@ -284,8 +276,6 @@ int __init default_acpi_madt_oem_check(c
 
 		if (!cmdline_apic) {
 			apic = apic_probe[i];
-			if (x86_quirks->update_apic)
-				x86_quirks->update_apic();
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6/arch/x86/kernel/apic/probe_64.c
@@ -68,9 +68,6 @@ void __init default_setup_apic_routing(v
 			apic = &apic_physflat;
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
-
-	if (x86_quirks->update_apic)
-		x86_quirks->update_apic();
 }
 
 /* Same for both flat and physical. */
Index: linux-2.6/arch/x86/kernel/apic/summit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6/arch/x86/kernel/apic/summit_32.c
@@ -574,7 +574,7 @@ struct apic apic_summit = {
 	.send_IPI_all			= summit_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -224,7 +224,7 @@ struct apic apic_x2apic_cluster = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
@@ -213,7 +213,7 @@ struct apic apic_x2apic_phys = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
Index: linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -91,7 +91,7 @@ static void uv_vector_allocation_domain(
 	cpumask_set_cpu(cpu, retmask);
 }
 
-int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
+static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 	unsigned long val;
 	int pnode;
@@ -99,16 +99,19 @@ int uv_wakeup_secondary(int phys_apicid,
 	pnode = uv_apicid_to_pnode(phys_apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	    (((long)start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
+	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	    (((long)start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
+	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_STARTUP;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+
+	atomic_set(&init_deasserted, 1);
+
 	return 0;
 }
 
@@ -285,7 +288,7 @@ struct apic apic_x2apic_uv_x = {
 	.send_IPI_all			= uv_send_IPI_all,
 	.send_IPI_self			= uv_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
+	.wakeup_cpu			= uv_wakeup_secondary,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -600,19 +600,7 @@ static int __init setup_elfcorehdr(char
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
-static int __init default_update_apic(void)
-{
-#ifdef CONFIG_SMP
-	if (!apic->wakeup_cpu)
-		apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
-#endif
-
-	return 0;
-}
-
-static struct x86_quirks default_x86_quirks __initdata = {
-	.update_apic         = default_update_apic,
-};
+static struct x86_quirks default_x86_quirks __initdata;
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -112,7 +112,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
-static atomic_t init_deasserted;
+atomic_t init_deasserted;
 
 
 /* Set if we find a B stepping CPU */
@@ -614,12 +614,6 @@ wakeup_secondary_cpu_via_init(int phys_a
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
 
-	if (get_uv_system_type() == UV_NON_UNIQUE_APIC) {
-		send_status = uv_wakeup_secondary(phys_apicid, start_eip);
-		atomic_set(&init_deasserted, 1);
-		return send_status;
-	}
-
 	maxlvt = lapic_get_maxlvt();
 
 	/*
