Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZHUVgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZHUVgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZHUVgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:36:49 -0400
Received: from www.tglx.de ([62.245.132.106]:51636 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbZHUVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:58 -0400
Message-Id: <20090821205602.416680466@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 12/32] x86: Move get/find_smp_config to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-get-find-smp-config-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the quirk machinery by a platform setup function which
defaults to the standard implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mpspec.h    |   30 ++++++++++++++++++++++++------
 arch/x86/include/asm/platform.h  |    4 ++++
 arch/x86/include/asm/setup.h     |    2 --
 arch/x86/kernel/apic/numaq_32.c  |    2 --
 arch/x86/kernel/mpparse.c        |   33 ++-------------------------------
 arch/x86/kernel/platform_setup.c |    2 ++
 arch/x86/kernel/setup.c          |    2 --
 arch/x86/kernel/visws_quirks.c   |   14 ++++----------
 8 files changed, 36 insertions(+), 53 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 
 #include <asm/mpspec_def.h>
+#include <asm/platform.h>
 
 extern int apic_version[MAX_APICS];
 extern int pic_mode;
@@ -41,9 +42,6 @@ extern int quad_local_to_mp_bus_id [NR_C
 
 #endif /* CONFIG_X86_64 */
 
-extern void early_find_smp_config(void);
-extern void early_get_smp_config(void);
-
 #if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -56,10 +54,27 @@ extern int smp_found_config;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
-extern void get_smp_config(void);
+static inline void get_smp_config(void)
+{
+	platform_setup.mpparse.get_smp_config(0);
+}
+
+static inline void early_get_smp_config(void)
+{
+	platform_setup.mpparse.get_smp_config(1);
+}
+
+static inline void find_smp_config(void)
+{
+	platform_setup.mpparse.find_smp_config(1);
+}
+
+static inline void early_find_smp_config(void)
+{
+	platform_setup.mpparse.find_smp_config(0);
+}
 
 #ifdef CONFIG_X86_MPPARSE
-extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
 extern int enable_update_mptable;
 extern int default_mpc_apic_id(struct mpc_cpu *m);
@@ -69,13 +84,16 @@ extern void default_mpc_oem_bus_info(str
 # else
 #  define default_mpc_oem_bus_info NULL
 # endif
+extern void default_find_smp_config(unsigned int reserve);
+extern void default_get_smp_config(unsigned int early);
 #else
-static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
 #define enable_update_mptable 0
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
 #define default_mpc_oem_bus_info NULL
+#define default_find_smp_config platform_setup_uint_noop
+#define default_get_smp_config platform_setup_uint_noop
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -20,6 +20,8 @@ struct platform_setup_quirks {
  * @smp_read_mpc_oem:		platform specific oem mpc table setup
  * @mpc_oem_pci_bus:		platform specific pci bus setup (default NULL)
  * @mpc_oem_bus_info:		platform specific mpc bus info
+ * @find_smp_config:		find the smp configuration
+ * @get_smp_config:		get the smp configuration
  */
 struct platform_setup_mpparse {
 	void (*setup_ioapic_ids)(void);
@@ -27,6 +29,8 @@ struct platform_setup_mpparse {
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
+	void (*find_smp_config)(unsigned int reserve);
+	void (*get_smp_config)(unsigned int early);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -19,8 +19,6 @@ struct x86_quirks {
 	int (*arch_pre_intr_init)(void);
 	int (*arch_intr_init)(void);
 	int (*arch_trap_init)(void);
-	int (*mach_get_smp_config)(unsigned int early);
-	int (*mach_find_smp_config)(unsigned int reserve);
 };
 
 extern void x86_quirk_intr_init(void);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -268,8 +268,6 @@ static struct x86_quirks numaq_x86_quirk
 	.arch_pre_intr_init		= NULL,
 	.arch_intr_init			= NULL,
 	.arch_trap_init			= NULL,
-	.mach_get_smp_config		= NULL,
-	.mach_find_smp_config		= NULL,
 };
 
 static __init void early_check_numaq(void)
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -610,7 +610,7 @@ static int __init check_physptr(struct m
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
-static void __init __get_smp_config(unsigned int early)
+void __init default_get_smp_config(unsigned int early)
 {
 	struct mpf_intel *mpf = mpf_found;
 
@@ -627,11 +627,6 @@ static void __init __get_smp_config(unsi
 	if (acpi_lapic && acpi_ioapic)
 		return;
 
-	if (x86_quirks->mach_get_smp_config) {
-		if (x86_quirks->mach_get_smp_config(early))
-			return;
-	}
-
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
@@ -672,16 +667,6 @@ static void __init __get_smp_config(unsi
 	 */
 }
 
-void __init early_get_smp_config(void)
-{
-	__get_smp_config(1);
-}
-
-void __init get_smp_config(void)
-{
-	__get_smp_config(0);
-}
-
 static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
@@ -747,14 +732,10 @@ static int __init smp_scan_config(unsign
 	return 0;
 }
 
-static void __init __find_smp_config(unsigned int reserve)
+void __init default_find_smp_config(unsigned int reserve)
 {
 	unsigned int address;
 
-	if (x86_quirks->mach_find_smp_config) {
-		if (x86_quirks->mach_find_smp_config(reserve))
-			return;
-	}
 	/*
 	 * FIXME: Linux assumes you have 640K of base ram..
 	 * this continues the error...
@@ -789,16 +770,6 @@ static void __init __find_smp_config(uns
 		smp_scan_config(address, 0x400, reserve);
 }
 
-void __init early_find_smp_config(void)
-{
-	__find_smp_config(0);
-}
-
-void __init find_smp_config(void)
-{
-	__find_smp_config(1);
-}
-
 #ifdef CONFIG_X86_IO_APIC
 static u8 __initdata irq_used[MAX_IRQ_SOURCES];
 
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -31,6 +31,8 @@ struct __initdata platform_setup_ops pla
 		.mpc_apic_id = default_mpc_apic_id,
 		.smp_read_mpc_oem = default_smp_read_mpc_oem,
 		.mpc_oem_bus_info = default_mpc_oem_bus_info,
+		.find_smp_config = default_find_smp_config,
+		.get_smp_config = default_get_smp_config,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -981,13 +981,11 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
-#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
 		get_smp_config();
-#endif
 
 	prefill_possible_map();
 
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -156,12 +156,8 @@ static void visws_machine_power_off(void
 	outl(PIIX_SPECIAL_STOP, 0xCFC);
 }
 
-static int __init visws_get_smp_config(unsigned int early)
+static void __init visws_get_smp_config(unsigned int early)
 {
-	/*
-	 * Prevent MP-table parsing by the generic code:
-	 */
-	return 1;
 }
 
 /*
@@ -208,7 +204,7 @@ static void __init MP_processor_info(str
 	apic_version[m->apicid] = ver;
 }
 
-static int __init visws_find_smp_config(unsigned int reserve)
+static void __init visws_find_smp_config(unsigned int reserve)
 {
 	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
@@ -230,8 +226,6 @@ static int __init visws_find_smp_config(
 		MP_processor_info(mp++);
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-
-	return 1;
 }
 
 static int visws_trap_init(void);
@@ -241,8 +235,6 @@ static struct x86_quirks visws_x86_quirk
 	.arch_pre_intr_init	= visws_pre_intr_init,
 	.arch_intr_init		= NULL,
 	.arch_trap_init		= visws_trap_init,
-	.mach_get_smp_config	= visws_get_smp_config,
-	.mach_find_smp_config	= visws_find_smp_config,
 };
 
 void __init visws_early_detect(void)
@@ -263,6 +255,8 @@ void __init visws_early_detect(void)
 	x86_quirks = &visws_x86_quirks;
 
 	platform_setup.resources.memory_setup = visws_memory_setup;
+	platform_setup.mpparse.get_smp_config = visws_get_smp_config;
+	platform_setup.mpparse.find_smp_config = visws_find_smp_config;
 
 	/*
 	 * Install reboot quirks:


