Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZGPKzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZGPKzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbZGPKzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:55:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:62744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbZGPKzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="475407427"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:55:40 -0700
Subject: [PATCH v2 10/10] x86/apic: Early setup IOAPIC for APB timer
Thread-Topic: [PATCH v2 10/10] x86/apic: Early setup IOAPIC for APB timer
Thread-Index: AcoGA/Whed7DKU+ySAGDu7PpTMTzoQ==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDFC@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ba824feed1fc5aa5029f6506b0d54145b949d48d Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 11:30:40 -0700
Subject: [PATCH] x86/apic: Early setup IOAPIC for APB timer

Intel Moorestown platform uses APB system timers which rely
on IOAPIC to deliver its interrupts. Early setup the APIC
system is necessary to allow timer interrupts.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/apic.h    |    1 +
 arch/x86/kernel/apic/io_apic.c |   68 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bb7d479..a74cb30 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -87,6 +87,7 @@ extern void xapic_wait_icr_idle(void);
 extern u32 safe_xapic_wait_icr_idle(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
+extern void pre_init_apic_IRQ(void);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 645c8eb..9bcbfa3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -36,6 +36,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
+#include <linux/sfi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -63,6 +64,7 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 #include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
@@ -2884,6 +2886,13 @@ static inline void __init check_timer(void)
 
 	local_irq_save(flags);
 
+	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+		if (timer_irq_works()) {
+			printk(KERN_INFO "APB timer works\n");
+			return;
+		} else
+			panic("Check APB timer failed\n");
+	}
 	/*
 	 * get/set the timer IRQ vector:
 	 */
@@ -4225,3 +4234,62 @@ static int __init ioapic_insert_resources(void)
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
+
+/* Enable IOAPIC early just for system timer */
+void __init pre_init_apic_IRQ(void)
+{
+	struct irq_cfg *cfg;
+
+	printk(KERN_INFO "Early APIC setup for system timer\n");
+#ifndef CONFIG_SMP
+	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+#endif
+	setup_local_APIC();
+	cfg = irq_cfg(0);
+	add_pin_to_irq_node(cfg, 0, 0, 0);
+	setup_timer_IRQ0_pin(0, 0, cfg->vector);
+}
+
+#ifdef CONFIG_APB_TIMER
+int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu)
+{
+	struct IO_APIC_route_entry entry;
+	struct irq_cfg *cfg;
+	int apic_id;
+
+	memset(&entry, 0, sizeof(entry));
+	cfg = irq_cfg(irq);
+	apic_id = mp_sfi_find_ioapic(irq);
+	if (apic_id == -1) {
+		printk(KERN_ERR "Failed to setup APB timer IRQ %d\n", irq);
+		return apic_id;
+	}
+	/*
+	 * We use logical delivery to get the timer IRQ
+	 * to the first CPU. RH must work or cleared in MSI address
+	 */
+	entry.dest_mode = apic->irq_dest_mode;
+	entry.mask = mask;
+	if (!apic->irq_dest_mode)
+		entry.dest = cpu;		/* physical apic id */
+	else
+		entry.dest = apic->cpu_to_logical_apicid(cpu);
+	entry.delivery_mode = apic->irq_delivery_mode;
+	entry.polarity = 0;
+	entry.trigger = trigger;
+	entry.vector = cfg->vector;
+
+	if (trigger == 0)
+		set_irq_chip_and_handler_name(irq, &ioapic_chip,
+			handle_edge_irq, "edge");
+	else
+		set_irq_chip_and_handler_name(irq, &ioapic_chip,
+			handle_fasteoi_irq, "fasteoi");
+	/*
+	 * Add it to the IO-APIC irq-routing table:
+	 * pin and irq are 1:1 mapped
+	 */
+	ioapic_write_entry(apic_id, irq, entry);
+	return 0;
+}
+#endif
-- 
1.5.6.5

