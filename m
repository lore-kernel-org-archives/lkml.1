Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZFZAQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZFZAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZFZAPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:15:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:21232 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbZFZAPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:15:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208,223";a="702624092"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 25 Jun 2009 17:15:20 -0700
Subject: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Topic: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Index: Acn18zETr5cKnVUsScuDSGPPRdJpOQ==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
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

>From 82d64ca4f963d2e205326534aff0c77d9bfa5858 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 12 Jun 2009 02:16:05 -0700
Subject: [PATCH] x86/apic: support moorestown interrupt subsystem

This patch uses platform flags to selectively enable apic related setup
code.

Since moorestown does not have legacy timer or PIC, the only system
timer irqs are routed via ioapic. Early timer ioapic enabling is also
added to allow boot time timing services.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/apic.h    |    1 +
 arch/x86/include/asm/io_apic.h |    4 +-
 arch/x86/kernel/apic/apic.c    |    3 +
 arch/x86/kernel/apic/io_apic.c |  107 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bb7d479..59e888a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -87,6 +87,7 @@ extern void xapic_wait_icr_idle(void);
 extern u32 safe_xapic_wait_icr_idle(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
+extern void __init pre_init_apic_IRQ(void);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
 {
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index daf866e..9b373db 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,11 +150,11 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-#ifdef CONFIG_ACPI
+#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-#endif /* CONFIG_ACPI */
+#endif /* CONFIG_ACPI || CONFIG_SFI */
 
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..c2b67d4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -49,6 +49,7 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/platform_feature.h>
 
 unsigned int num_processors;
 
@@ -1115,6 +1116,8 @@ void __init init_bsp_APIC(void)
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	/*
 	 * Set up the virtual wire mode.
 	 */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c84dc3d..b50e33f 100644
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
@@ -62,7 +63,8 @@
 #include <asm/hw_irq.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
-
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
@@ -130,6 +132,14 @@ struct irq_pin_list {
 	struct irq_pin_list *next;
 };
 
+/* Use static early entry before kzalloc is ready, for platforms need system
+ * timer IRQ0 setup in IOAPIC early.
+ */
+static struct irq_pin_list early_entry;
+static inline struct irq_pin_list *get_one_free_irq_2_pin_early(int node)
+{
+	return &early_entry;
+}
 static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 {
 	struct irq_pin_list *pin;
@@ -504,7 +514,11 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin
 
 	entry = cfg->irq_2_pin;
 	if (!entry) {
-		entry = get_one_free_irq_2_pin(node);
+		/* Setup APB timer 0 is prior to kzalloc() becomes ready */
+		if (platform_has(X86_PLATFORM_FEATURE_APBT) && (!pin)) {
+			entry = get_one_free_irq_2_pin_early(node);
+		} else
+			entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
 					apic, pin);
@@ -1450,6 +1464,12 @@ int setup_ioapic_entry(int apic_id, int irq,
 	return 0;
 }
 
+static inline int is_8259_legacy_irq(int irq)
+{
+	return (((irq < NR_IRQS_LEGACY)
+		&& platform_has(X86_PLATFORM_FEATURE_8259)));
+}
+
 static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
@@ -1483,7 +1503,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
-	if (irq < NR_IRQS_LEGACY)
+	if (is_8259_legacy_irq(irq))
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
@@ -1892,7 +1912,8 @@ __apicdebuginit(void) print_PIC(void)
 
 __apicdebuginit(int) print_all_ICs(void)
 {
-	print_PIC();
+	if (platform_has(X86_PLATFORM_FEATURE_8259))
+		print_PIC();
 
 	/* don't print out if apic is not there */
 	if (!cpu_has_apic || disable_apic)
@@ -1926,6 +1947,8 @@ void __init enable_IO_APIC(void)
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
@@ -1980,6 +2003,8 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	/*
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
@@ -2211,7 +2236,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < NR_IRQS_LEGACY) {
+	if (is_8259_legacy_irq(irq)) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2723,7 +2748,7 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < NR_IRQS_LEGACY)
+			if (is_8259_legacy_irq(irq))
 				make_8259A_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -2878,6 +2903,13 @@ static inline void __init check_timer(void)
 
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
@@ -3067,8 +3099,10 @@ void __init setup_IO_APIC(void)
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
-
-	io_apic_irqs = ~PIC_IRQS;
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		io_apic_irqs = ~0;
+	else
+		io_apic_irqs = ~PIC_IRQS;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	/*
@@ -3959,7 +3993,7 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
 
-#ifdef CONFIG_ACPI
+#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
 
 #ifdef CONFIG_X86_32
 int __init io_apic_get_unique_id(int ioapic, int apic_id)
@@ -4223,3 +4257,58 @@ static int __init ioapic_insert_resources(void)
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
+/* Enable IOAPIC early just for system timer */
+void __init pre_init_apic_IRQ(void)
+{
+	struct irq_cfg *cfg;
+	printk(KERN_INFO "Early APIC setup for system timer\n");
+#ifndef CONFIG_SMP
+	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+#endif
+	setup_local_APIC();
+	cfg = irq_cfg(0);
+	add_pin_to_irq_node(cfg, 0, 0, 0);
+	setup_timer_IRQ0_pin(0, 0, cfg->vector);
+}
+#ifdef CONFIG_APB_TIMER
+int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu)
+{
+	struct IO_APIC_route_entry entry;
+	struct irq_cfg *cfg;
+	int apic_id;
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

