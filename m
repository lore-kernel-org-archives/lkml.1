Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0BITld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:41:33 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40018 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0BITdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 34/35] x86: make 32bit apic flat to physflat switch like 64bit
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill def_to_bigsmp
and move switch from default to bigsmp at default_setup_apic_routing...
so make default_setup_apic_routing more like 64 bit
also make the dmi relate code to be __init/__initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/apic.h      |    3 -
 arch/x86/include/asm/mpspec.h    |    1 -
 arch/x86/kernel/acpi/boot.c      |    3 -
 arch/x86/kernel/apic/apic.c      |   15 -------
 arch/x86/kernel/apic/bigsmp_32.c |   48 +----------------------
 arch/x86/kernel/apic/probe_32.c  |   80 ++++++++++++++++++++-----------------
 arch/x86/kernel/mpparse.c        |    4 --
 arch/x86/kernel/setup.c          |    2 -
 arch/x86/kernel/smpboot.c        |    2 +-
 9 files changed, 46 insertions(+), 112 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b4ac2cd..d544523 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -456,9 +456,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-extern void generic_bigsmp_probe(void);
-
-
 #ifdef CONFIG_X86_LOCAL_APIC
 
 #include <asm/smp.h>
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index d8bf23a..b4b295c 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -23,7 +23,6 @@ extern int pic_mode;
 
 #define MAX_IRQ_SOURCES		256
 
-extern unsigned int def_to_bigsmp;
 extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_NUMAQ
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6083bfa..3dfe6aa 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1192,9 +1192,6 @@ static void __init acpi_process_madt(void)
 		if (!error) {
 			acpi_lapic = 1;
 
-#ifdef CONFIG_X86_BIGSMP
-			generic_bigsmp_probe();
-#endif
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e97f18b..6e29b2a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1889,21 +1889,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
-#ifdef CONFIG_X86_32
-	if (num_processors > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-#endif
-
 #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index cb804c5..350d60e 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -7,7 +7,6 @@
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
 #include <linux/smp.h>
 
 #include <asm/apicdef.h>
@@ -73,13 +72,6 @@ static void bigsmp_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static void bigsmp_setup_apic_routing(void)
-{
-	printk(KERN_INFO
-		"Enabling APIC mode:  Physflat.  Using %d I/O APICs\n",
-		nr_ioapics);
-}
-
 static int bigsmp_apicid_to_node(int logical_apicid)
 {
 	return apicid_2_node[hard_smp_processor_id()];
@@ -154,52 +146,16 @@ static void bigsmp_send_IPI_all(int vector)
 	bigsmp_send_IPI_mask(cpu_online_mask, vector);
 }
 
-static int dmi_bigsmp; /* can be set by dmi scanners */
-
-static int hp_ht_bigsmp(const struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
-	dmi_bigsmp = 1;
-
-	return 0;
-}
-
-
-static const struct dmi_system_id bigsmp_dmi_table[] = {
-	{ hp_ht_bigsmp, "HP ProLiant DL760 G2",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
-			DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
-		}
-	},
-
-	{ hp_ht_bigsmp, "HP ProLiant DL740",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
-			DMI_MATCH(DMI_BIOS_VERSION, "P47-"),
-		}
-	},
-	{ } /* NULL entry stops DMI scanning */
-};
-
 static void bigsmp_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static int probe_bigsmp(void)
-{
-	if (def_to_bigsmp)
-		dmi_bigsmp = 1;
-	else
-		dmi_check_system(bigsmp_dmi_table);
-
-	return dmi_bigsmp;
-}
-
 struct apic apic_bigsmp = {
 
 	.name				= "bigsmp",
-	.probe				= probe_bigsmp,
+	.probe				= NULL,
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
@@ -217,7 +173,7 @@ struct apic apic_bigsmp = {
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
-	.setup_apic_routing		= bigsmp_setup_apic_routing,
+	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index d657558..b05e543 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -14,6 +14,8 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/dmi.h>
+
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
@@ -52,15 +54,6 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-static void local_default_setup_apic_routing(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	printk(KERN_INFO
-		"Enabling APIC mode:  Flat.  Using %d I/O APICs\n",
-		nr_ioapics);
-#endif
-}
-
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/*
@@ -76,16 +69,10 @@ static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
-/* should be called last. */
-static int probe_default(void)
-{
-	return 1;
-}
-
 struct apic apic_default = {
 
 	.name				= "default",
-	.probe				= probe_default,
+	.probe				= NULL,
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= default_apic_id_registered,
 
@@ -103,7 +90,7 @@ struct apic apic_default = {
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= local_default_setup_apic_routing,
+	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
@@ -192,24 +179,40 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
-void __init generic_bigsmp_probe(void)
+static int dmi_bigsmp __initdata; /* can be set by dmi scanners */
+
+static int __init hp_ht_bigsmp(const struct dmi_system_id *d)
 {
-#ifdef CONFIG_X86_BIGSMP
-	/*
-	 * This routine is used to switch to bigsmp mode when
-	 * - There is no apic= option specified by the user
-	 * - generic_apic_probe() has chosen apic_default as the sub_arch
-	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
-	 */
+	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
+	dmi_bigsmp = 1;
 
-	if (!cmdline_apic && apic == &apic_default) {
-		if (apic_bigsmp.probe()) {
-			apic = &apic_bigsmp;
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
+	return 0;
+}
+
+static struct dmi_system_id bigsmp_dmi_table[] __initdata = {
+	{ hp_ht_bigsmp, "HP ProLiant DL760 G2",
+		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
+			DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
 		}
-	}
+	},
+
+	{ hp_ht_bigsmp, "HP ProLiant DL740",
+		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
+			DMI_MATCH(DMI_BIOS_VERSION, "P47-"),
+		}
+	},
+	{ } /* NULL entry stops DMI scanning */
+};
+
+static inline const char *get_apic_name(struct apic *apic)
+{
+	if (apic == &apic_default)
+		return "flat";
+#ifdef CONFIG_X86_BIGSMP
+	if (apic == &apic_bigsmp);
+		return "physical flat";
 #endif
+	return apic->name;
 }
 
 void __init default_setup_apic_routing(void)
@@ -219,13 +222,19 @@ void __init default_setup_apic_routing(void)
 	 * make sure we go to bigsmp according to real nr_cpu_ids
 	 */
 	if (!cmdline_apic && apic == &apic_default) {
-		if (nr_cpu_ids > 8) {
+		dmi_check_system(bigsmp_dmi_table);
+		if (nr_cpu_ids > 8 || dmi_bigsmp) {
 			apic = &apic_bigsmp;
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
+			       get_apic_name(apic));
 		}
 	}
 #endif
+#ifdef CONFIG_X86_IO_APIC
+	printk(KERN_INFO
+		"Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+		get_apic_name(apic), nr_ioapics);
+#endif
 }
 
 void __init generic_apic_probe(void)
@@ -233,14 +242,11 @@ void __init generic_apic_probe(void)
 	if (!cmdline_apic) {
 		int i;
 		for (i = 0; apic_probe[i]; i++) {
-			if (apic_probe[i]->probe()) {
+			if (apic_probe[i]->probe && apic_probe[i]->probe()) {
 				apic = apic_probe[i];
 				break;
 			}
 		}
-		/* Not visible without early console */
-		if (!apic_probe[i])
-			panic("Didn't find an APIC driver");
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 40b54ce..0f885c6 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -359,10 +359,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		x86_init.mpparse.mpc_record(1);
 	}
 
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
 	if (apic->setup_apic_routing)
 		apic->setup_apic_routing();
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d49e168..17759b7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -184,8 +184,6 @@ static void set_mca_bus(int x)
 #endif
 }
 
-unsigned int def_to_bigsmp;
-
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
 unsigned int machine_submodel_id;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index da99eef..efdf81e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -950,7 +950,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	preempt_disable();
 
 #if !defined(CONFIG_X86_BIGSMP) && defined(CONFIG_X86_32)
-	if (def_to_bigsmp && nr_cpu_ids > 8) {
+	if (apic == &apic_default && nr_cpu_ids > 8) {
 		unsigned int cpu;
 		unsigned nr;
 
-- 
1.6.4.2

