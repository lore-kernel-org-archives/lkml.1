Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZA1X4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZA1X4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZA1Xo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:37569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbZA1XoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:25 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 030/114] x86, apic: clean up / remove TARGET_CPUS
Date: Wed, 28 Jan 2009 23:41:36 +0000
Message-Id: <1233186180-29883-31-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

use apic->target_cpus() directly instead of the TARGET_CPUS wrapper.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/apic.h            |    4 ++--
 arch/x86/include/asm/mach-default/mach_apic.h |    2 --
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/io_apic.c                     |   22 +++++++++++-----------
 5 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 7e5c31a..53adda0 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -161,7 +161,7 @@ cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 		return 0xFF;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
@@ -194,7 +194,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return cpu_to_logical_apicid(0);
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index af1607d..77a9724 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -22,7 +22,6 @@ static inline const struct cpumask *default_target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define TARGET_CPUS	  (apic->target_cpus())
 #define init_apic_ldr (apic->init_apic_ldr)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
@@ -33,7 +32,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
-#define TARGET_CPUS (default_target_cpus())
 #define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
  * Set up the logical destination ID.
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 387a5d0..da2d778 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -7,7 +7,6 @@
 #define NO_BALANCE_IRQ (apic->no_balance_irq)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (apic->apic_destination_logical)
-#define TARGET_CPUS	  (apic->target_cpus())
 #define init_apic_ldr (apic->init_apic_ldr)
 #define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 7c1f915..cf5036f 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -148,7 +148,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return (int) 0xFF;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 301b657..7503285 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1559,10 +1559,10 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	cfg = desc->chip_data;
 
-	if (assign_irq_vector(irq, cfg, TARGET_CPUS))
+	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
-	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
+	dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1661,7 +1661,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 */
 	entry.dest_mode = apic->irq_dest_mode;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(apic->target_cpus());
 	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -2877,7 +2877,7 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, cfg, TARGET_CPUS);
+	assign_irq_vector(0, cfg, apic->target_cpus());
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3195,7 +3195,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 		if (cfg_new->vector != 0)
 			continue;
-		if (__assign_irq_vector(new, cfg_new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
 	}
@@ -3261,11 +3261,11 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
 	if (err)
 		return err;
 
-	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
+	dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3698,12 +3698,12 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
+		dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3987,7 +3987,7 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 /*
  * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
- * so mask in all cases should simply be TARGET_CPUS
+ * so mask in all cases should simply be apic->target_cpus()
  */
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
@@ -4028,7 +4028,7 @@ void __init setup_ioapic_dest(void)
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
 				mask = desc->affinity;
 			else
-				mask = TARGET_CPUS;
+				mask = apic->target_cpus();
 
 #ifdef CONFIG_INTR_REMAP
 			if (intr_remapping_enabled)
-- 
1.6.0.2

