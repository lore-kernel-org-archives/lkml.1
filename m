Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbZA1Xxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbZA1Xxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZA1XoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:37508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406AbZA1XoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:11 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 022/114] x86, apic: remove IRQ_DEST_MODE / IRQ_DELIVERY_MODE
Date: Wed, 28 Jan 2009 23:41:28 +0000
Message-Id: <1233186180-29883-23-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the wrapper macros IRQ_DEST_MODE and IRQ_DELIVERY_MODE.

The typical 32-bit and the 64-bit build all dereference via the genapic,
so it's pointless to hide that indirection via these ugly macros.

Furthermore, it also obscures subarchitecture details.

So replace it with apic->irq_dest_mode / etc. accesses.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    4 +-
 arch/x86/include/asm/es7000/apic.h            |    4 +-
 arch/x86/include/asm/mach-default/mach_apic.h |    5 +--
 arch/x86/include/asm/mach-generic/mach_apic.h |    2 -
 arch/x86/include/asm/numaq/apic.h             |    4 +-
 arch/x86/include/asm/summit/apic.h            |    4 +-
 arch/x86/kernel/io_apic.c                     |   30 ++++++++++++------------
 arch/x86/mach-generic/bigsmp.c                |    4 +-
 arch/x86/mach-generic/default.c               |    4 +-
 arch/x86/mach-generic/es7000.c                |    4 +-
 arch/x86/mach-generic/numaq.c                 |    4 +-
 arch/x86/mach-generic/summit.c                |    4 +-
 12 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 8ff8bba..293551b 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -21,8 +21,8 @@ static inline const cpumask_t *target_cpus(void)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define IRQ_DELIVERY_MODE	(dest_Fixed)
-#define IRQ_DEST_MODE		(0)    /* phys delivery to target proc */
+#define BIGSMP_IRQ_DELIVERY_MODE (dest_Fixed)
+#define BIGSMP_IRQ_DEST_MODE	(0)    /* phys delivery to target proc */
 #define NO_BALANCE_IRQ		(0)
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 830e873..6900166 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -27,8 +27,8 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ_CLUSTER		(1)
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define IRQ_DELIVERY_MODE	(dest_Fixed)
-#define IRQ_DEST_MODE		(0)    /* phys delivery to target procs */
+#define ES7000_IRQ_DELIVERY_MODE (dest_Fixed)
+#define ES7000_IRQ_DEST_MODE	(0)    /* phys delivery to target procs */
 #define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index b536479..eafbf4f 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -22,7 +22,6 @@ static inline const struct cpumask *target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define IRQ_DELIVERY_MODE (apic->irq_delivery_mode)
 #define IRQ_DEST_MODE (apic->irq_dest_mode)
 #define TARGET_CPUS	  (apic->target_cpus())
 #define init_apic_ldr (apic->init_apic_ldr)
@@ -35,8 +34,8 @@ static inline const struct cpumask *target_cpus(void)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
-#define IRQ_DELIVERY_MODE dest_LowestPrio
-#define IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
+#define DEFAULT_IRQ_DELIVERY_MODE dest_LowestPrio
+#define DEFAULT_IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
 #define TARGET_CPUS (target_cpus())
 #define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 03492f2..387a5d0 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -5,8 +5,6 @@
 
 #define esr_disable (apic->ESR_DISABLE)
 #define NO_BALANCE_IRQ (apic->no_balance_irq)
-#define IRQ_DELIVERY_MODE (apic->irq_delivery_mode)
-#define IRQ_DEST_MODE (apic->irq_dest_mode)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (apic->apic_destination_logical)
 #define TARGET_CPUS	  (apic->target_cpus())
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index d885e35..7746035 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -15,8 +15,8 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ (1)
 #define esr_disable (1)
 
-#define IRQ_DELIVERY_MODE dest_LowestPrio
-#define IRQ_DEST_MODE 0     /* physical delivery on LOCAL quad */
+#define NUMAQ_IRQ_DELIVERY_MODE dest_LowestPrio
+#define NUMAQ_IRQ_DEST_MODE 0     /* physical delivery on LOCAL quad */
  
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 0b7d0d1..ea2abe9 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -24,8 +24,8 @@ static inline const cpumask_t *target_cpus(void)
 	return &cpumask_of_cpu(0);
 }
 
-#define IRQ_DELIVERY_MODE (dest_LowestPrio)
-#define IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
+#define SUMMIT_IRQ_DELIVERY_MODE (dest_LowestPrio)
+#define SUMMIT_IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 5f967b9..301b657 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1514,9 +1514,9 @@ static int setup_ioapic_entry(int apic_id, int irq,
 		memset(&irte, 0, sizeof(irte));
 
 		irte.present = 1;
-		irte.dst_mode = IRQ_DEST_MODE;
+		irte.dst_mode = apic->irq_dest_mode;
 		irte.trigger_mode = trigger;
-		irte.dlvry_mode = IRQ_DELIVERY_MODE;
+		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
 
@@ -1529,8 +1529,8 @@ static int setup_ioapic_entry(int apic_id, int irq,
 	} else
 #endif
 	{
-		entry->delivery_mode = IRQ_DELIVERY_MODE;
-		entry->dest_mode = IRQ_DEST_MODE;
+		entry->delivery_mode = apic->irq_delivery_mode;
+		entry->dest_mode = apic->irq_dest_mode;
 		entry->dest = destination;
 	}
 
@@ -1659,10 +1659,10 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
 	 */
-	entry.dest_mode = IRQ_DEST_MODE;
+	entry.dest_mode = apic->irq_dest_mode;
 	entry.mask = 1;					/* mask IRQ now */
 	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
-	entry.delivery_mode = IRQ_DELIVERY_MODE;
+	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
 	entry.trigger = 0;
 	entry.vector = vector;
@@ -3279,9 +3279,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		memset (&irte, 0, sizeof(irte));
 
 		irte.present = 1;
-		irte.dst_mode = IRQ_DEST_MODE;
+		irte.dst_mode = apic->irq_dest_mode;
 		irte.trigger_mode = 0; /* edge */
-		irte.dlvry_mode = IRQ_DELIVERY_MODE;
+		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
 
@@ -3299,10 +3299,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		msg->address_hi = MSI_ADDR_BASE_HI;
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
-			((IRQ_DEST_MODE == 0) ?
+			((apic->irq_dest_mode == 0) ?
 				MSI_ADDR_DEST_MODE_PHYSICAL:
 				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
+			((apic->irq_delivery_mode != dest_LowestPrio) ?
 				MSI_ADDR_REDIRECTION_CPU:
 				MSI_ADDR_REDIRECTION_LOWPRI) |
 			MSI_ADDR_DEST_ID(dest);
@@ -3310,7 +3310,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		msg->data =
 			MSI_DATA_TRIGGER_EDGE |
 			MSI_DATA_LEVEL_ASSERT |
-			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
+			((apic->irq_delivery_mode != dest_LowestPrio) ?
 				MSI_DATA_DELIVERY_FIXED:
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
@@ -3711,11 +3711,11 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 			HT_IRQ_LOW_BASE |
 			HT_IRQ_LOW_DEST_ID(dest) |
 			HT_IRQ_LOW_VECTOR(cfg->vector) |
-			((IRQ_DEST_MODE == 0) ?
+			((apic->irq_dest_mode == 0) ?
 				HT_IRQ_LOW_DM_PHYSICAL :
 				HT_IRQ_LOW_DM_LOGICAL) |
 			HT_IRQ_LOW_RQEOI_EDGE |
-			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
+			((apic->irq_delivery_mode != dest_LowestPrio) ?
 				HT_IRQ_LOW_MT_FIXED :
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
@@ -3763,8 +3763,8 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
 
 	entry->vector = cfg->vector;
-	entry->delivery_mode = IRQ_DELIVERY_MODE;
-	entry->dest_mode = IRQ_DEST_MODE;
+	entry->delivery_mode = apic->irq_delivery_mode;
+	entry->dest_mode = apic->irq_dest_mode;
 	entry->polarity = 0;
 	entry->trigger = 0;
 	entry->mask = 0;
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index c15c1aa..e8c1cec 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -64,8 +64,8 @@ struct genapic apic_bigsmp = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
-	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= IRQ_DEST_MODE,
+	.irq_delivery_mode		= BIGSMP_IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= BIGSMP_IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d32b175..0482106 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -31,8 +31,8 @@ struct genapic apic_default = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= default_apic_id_registered,
 
-	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= IRQ_DEST_MODE,
+	.irq_delivery_mode		= DEFAULT_IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= DEFAULT_IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 0665389..5d97408 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -107,8 +107,8 @@ struct genapic apic_es7000 = {
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
 	.apic_id_registered		= es7000_apic_id_registered,
 
-	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= IRQ_DEST_MODE,
+	.irq_delivery_mode		= ES7000_IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= ES7000_IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 4019571..77ac669 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -51,8 +51,8 @@ struct genapic apic_numaq = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= numaq_apic_id_registered,
 
-	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= IRQ_DEST_MODE,
+	.irq_delivery_mode		= NUMAQ_IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= NUMAQ_IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 946da7a..7b3f43c 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -44,8 +44,8 @@ struct genapic apic_summit = {
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
 	.apic_id_registered		= summit_apic_id_registered,
 
-	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= IRQ_DEST_MODE,
+	.irq_delivery_mode		= SUMMIT_IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= SUMMIT_IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

