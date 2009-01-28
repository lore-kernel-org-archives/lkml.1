Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZA1X7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZA1X7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbZA1Xou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:52906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbZA1Xop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:45 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 040/114] x86, apic: clean up ->setup_apic_routing()
Date: Wed, 28 Jan 2009 23:41:46 +0000
Message-Id: <1233186180-29883-41-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

 - remove namespace clash on 64-bit

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    2 +-
 arch/x86/include/asm/genapic.h                |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h |    4 ++--
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/acpi/boot.c                   |    5 ++---
 arch/x86/kernel/apic.c                        |    2 +-
 arch/x86/kernel/genapic_64.c                  |    2 +-
 arch/x86/kernel/mpparse.c                     |    6 +++---
 arch/x86/kernel/smpboot.c                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 17 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 05116d5..321ea47 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -56,7 +56,7 @@ static inline void bigsmp_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline void setup_apic_routing(void)
+static inline void bigsmp_setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"Physflat", nr_ioapics);
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index db3e652..f118300 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -73,7 +73,7 @@ static inline void es7000_init_apic_ldr(void)
 }
 
 extern int apic_version [MAX_APICS];
-static inline void setup_apic_routing(void)
+static inline void es7000_setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 661898c..38b1202 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -107,7 +107,7 @@ extern void apic_send_IPI_self(int vector);
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
-extern void setup_apic_routing(void);
+extern void default_setup_apic_routing(void);
 #endif
 
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 7abdaae..d446774 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -25,7 +25,7 @@ static inline const struct cpumask *default_target_cpus(void)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
 #define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
-extern void setup_apic_routing(void);
+extern void default_setup_apic_routing(void);
 #else
 #define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
@@ -70,7 +70,7 @@ static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-static inline void setup_apic_routing(void)
+static inline void default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index c1c96e6..ddf3692 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define setup_apic_routing (apic->setup_apic_routing)
 #define multi_timer_check (apic->multi_timer_check)
 #define apicid_to_node (apic->apicid_to_node)
 #define cpu_to_logical_apicid (apic->cpu_to_logical_apicid) 
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index dc7499b..2feb7e7 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -33,7 +33,7 @@ static inline void numaq_init_apic_ldr(void)
 	/* Already done in NUMA-Q firmware */
 }
 
-static inline void setup_apic_routing(void)
+static inline void numaq_setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"NUMA-Q", nr_ioapics);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 4dafb58..7ec2696 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -74,7 +74,7 @@ static inline int summit_apic_id_registered(void)
 	return 1;
 }
 
-static inline void setup_apic_routing(void)
+static inline void summit_setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
 						nr_ioapics);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 314fe0d..5391631 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1360,9 +1360,8 @@ static void __init acpi_process_madt(void)
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
-#ifdef CONFIG_X86_32
-				setup_apic_routing();
-#endif
+				if (apic->setup_apic_routing)
+					apic->setup_apic_routing();
 			}
 		}
 		if (error == -EINVAL) {
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index b707793..fcbcc03 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1625,7 +1625,7 @@ int __init APIC_init_uniprocessor(void)
 	enable_IR_x2apic();
 #endif
 #ifdef CONFIG_X86_64
-	setup_apic_routing();
+	default_setup_apic_routing();
 #endif
 
 	verify_local_APIC();
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index 060945b..d57d213 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -44,7 +44,7 @@ static struct genapic *apic_probe[] __initdata = {
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
-void __init setup_apic_routing(void)
+void __init default_setup_apic_routing(void)
 {
 	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
 		if (!intr_remapping_enabled)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index fa6bb26..c8a534a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -390,9 +390,9 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
        generic_bigsmp_probe();
 #endif
 
-#ifdef CONFIG_X86_32
-	setup_apic_routing();
-#endif
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
+
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 45c096f..3791b4a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1128,7 +1128,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 #ifdef CONFIG_X86_64
 	enable_IR_x2apic();
-	setup_apic_routing();
+	default_setup_apic_routing();
 #endif
 
 	if (smp_sanity_check(max_cpus) < 0) {
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index f2a3418..ad3837a 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -78,7 +78,7 @@ struct genapic apic_bigsmp = {
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
-	.setup_apic_routing		= setup_apic_routing,
+	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index c403f3d..67f287f 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -59,7 +59,7 @@ struct genapic apic_default = {
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= setup_apic_routing,
+	.setup_apic_routing		= default_setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index ce09baf..f611729 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -120,7 +120,7 @@ struct genapic apic_es7000 = {
 	.init_apic_ldr			= es7000_init_apic_ldr,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
-	.setup_apic_routing		= setup_apic_routing,
+	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 5d98f18..8c137f4 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -65,7 +65,7 @@ struct genapic apic_numaq = {
 	.init_apic_ldr			= numaq_init_apic_ldr,
 
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
-	.setup_apic_routing		= setup_apic_routing,
+	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 6abdd53..0698566 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -58,7 +58,7 @@ struct genapic apic_summit = {
 	.init_apic_ldr			= summit_init_apic_ldr,
 
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
-	.setup_apic_routing		= setup_apic_routing,
+	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
-- 
1.6.0.2

