Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbZHUVbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbZHUVbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZHUVbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:31 -0400
Received: from www.tglx.de ([62.245.132.106]:51513 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbZHUVb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:29 -0400
Message-Id: <20090821205602.153260938@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 07/32] x86: Move ioapic_ids_setup to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-ioapic-ids-setup-to-quirks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32bit and also the numaq code have special requirements on the
ioapic_id setup. Convert it to a platform_setup function and get rid
of the quirks and #ifdefs

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h   |    3 ++-
 arch/x86/include/asm/platform.h  |   10 +++++++++-
 arch/x86/include/asm/setup.h     |    1 -
 arch/x86/kernel/apic/io_apic.c   |   11 ++++-------
 arch/x86/kernel/apic/numaq_32.c  |    8 +-------
 arch/x86/kernel/head32.c         |    3 +++
 arch/x86/kernel/platform_setup.c |    4 ++++
 7 files changed, 23 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -177,12 +177,13 @@ extern int setup_ioapic_entry(int apic, 
 			      int polarity, int vector, int pin);
 extern void ioapic_write_entry(int apic, int pin,
 			       struct IO_APIC_route_entry e);
+extern void setup_ioapic_ids_from_mpc(void);
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
+#define setup_ioapic_ids_from_mpc platform_setup_noop
 static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
-
 static inline void probe_nr_irqs_gsi(void)	{ }
 #endif
 
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -4,13 +4,20 @@
 /**
  * struct platform_setup_quirks - platform specific quirks
  * @mpc_record:			platform specific mpc record accounting
- *
  */
 struct platform_setup_quirks {
 	void (*mpc_record)(unsigned int mode);
 };
 
 /**
+ * struct platform_setup_mpparse - platform specific mpparse ops
+ * @setup_ioapic_ids:		platform specific ioapic id override
+ */
+struct platform_setup_mpparse {
+	void (*setup_ioapic_ids)(void);
+};
+
+/**
  * struct platform_setup_resources - platform specific resource related ops
  * @probe_roms:			probe BIOS roms
  * @reserve_resources:		reserve the standard resources for the
@@ -32,6 +39,7 @@ struct platform_setup_resources {
  */
 struct platform_setup_ops {
 	struct platform_setup_resources resources;
+	struct platform_setup_mpparse mpparse;
 	struct platform_setup_quirks quirks;
 };
 
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -30,7 +30,6 @@ struct x86_quirks {
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
-	int (*setup_ioapic_ids)(void);
 };
 
 extern void x86_quirk_intr_init(void);
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2014,7 +2014,7 @@ void disable_IO_APIC(void)
  * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
  */
 
-static void __init setup_ioapic_ids_from_mpc(void)
+void __init setup_ioapic_ids_from_mpc(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
@@ -2023,9 +2023,8 @@ static void __init setup_ioapic_ids_from
 	unsigned char old_id;
 	unsigned long flags;
 
-	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
+	if (acpi_ioapic)
 		return;
-
 	/*
 	 * Don't check I/O APIC IDs for xAPIC systems.  They have
 	 * no meaning without the serial APIC bus.
@@ -3061,10 +3060,8 @@ void __init setup_IO_APIC(void)
 	/*
          * Set up IO-APIC IRQ routing.
          */
-#ifdef CONFIG_X86_32
-	if (!acpi_ioapic)
-		setup_ioapic_ids_from_mpc();
-#endif
+	platform_setup.mpparse.setup_ioapic_ids();
+
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -262,12 +262,6 @@ static void __init
 	}
 }
 
-static int __init numaq_setup_ioapic_ids(void)
-{
-	/* so can skip it */
-	return 1;
-}
-
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
@@ -280,7 +274,6 @@ static struct x86_quirks numaq_x86_quirk
 	.mpc_oem_bus_info		= mpc_oem_bus_info,
 	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
 	.smp_read_mpc_oem		= smp_read_mpc_oem,
-	.setup_ioapic_ids		= numaq_setup_ioapic_ids,
 };
 
 static __init void early_check_numaq(void)
@@ -299,6 +292,7 @@ static __init void early_check_numaq(voi
 	if (found_numaq) {
 		x86_quirks = &numaq_x86_quirks;
 		platform_setup.quirks.mpc_record = numaq_mpc_record;
+		platform_setup.mpparse.setup_ioapic_ids = platform_setup_noop;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -13,6 +13,8 @@
 #include <asm/e820.h>
 #include <asm/page.h>
 #include <asm/trampoline.h>
+#include <asm/apic.h>
+#include <asm/io_apic.h>
 
 void __init i386_start_kernel(void)
 {
@@ -32,6 +34,7 @@ void __init i386_start_kernel(void)
 	/* Initilize 32bit specific setup functions */
 	platform_setup.resources.probe_roms = probe_roms;
 	platform_setup.resources.reserve_resources = i386_reserve_resources;
+	platform_setup.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
 	platform_setup.resources.reserve_ebda_region();
 
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -25,6 +25,10 @@ struct __initdata platform_setup_ops pla
 		.memory_setup = default_machine_specific_memory_setup,
 	},
 
+	.mpparse = {
+		.setup_ioapic_ids = platform_setup_noop,
+	},
+
 	.quirks = {
 		.mpc_record = platform_setup_uint_noop,
 	},


