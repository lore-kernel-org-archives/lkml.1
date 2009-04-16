Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZDPBor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZDPBor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDPBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:44:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:49670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZDPBoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:44:37 -0400
Message-ID: <49E68D39.4010803@kernel.org>
Date: Wed, 15 Apr 2009 18:43:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] irq: make io_apic_set_pci_routing to take device
References: <49E68C41.4020801@kernel.org>
In-Reply-To: <49E68C41.4020801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: so use dev_to_node

and use node in irq_desc_all_node()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/ia64/kernel/acpi.c        |    5 +++--
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/include/asm/mpspec.h  |    4 +++-
 arch/x86/kernel/acpi/boot.c    |    8 ++++----
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++--
 drivers/acpi/pci_irq.c         |    5 +++--
 drivers/char/hpet.c            |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |    2 +-
 include/linux/acpi.h           |    2 +-
 9 files changed, 27 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -636,7 +636,7 @@ void __init acpi_numa_arch_fixup(void)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
 		return gsi;
@@ -678,7 +678,8 @@ static int __init acpi_parse_fadt(struct
 
 	fadt = (struct acpi_table_fadt *)fadt_header;
 
-	acpi_register_gsi(fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW);
+	acpi_register_gsi(NULL, fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE,
+				 ACPI_ACTIVE_LOW);
 	return 0;
 }
 
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -154,8 +154,8 @@ extern int timer_through_8259;
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
-				   int edge_level, int active_high_low);
+extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
+				  int irq, int edge_level, int active_high_low);
 #endif /* CONFIG_ACPI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -72,7 +72,9 @@ extern void mp_register_ioapic(int id, u
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
-extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+struct device;
+extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
+				 int active_high_low);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -522,7 +522,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned in
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
@@ -539,7 +539,7 @@ int acpi_register_gsi(u32 gsi, int trigg
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
-		plat_gsi = mp_register_gsi(gsi, triggering, polarity);
+		plat_gsi = mp_register_gsi(dev, gsi, triggering, polarity);
 	}
 #endif
 	acpi_gsi_to_irq(plat_gsi, &irq);
@@ -1158,7 +1158,7 @@ void __init mp_config_acpi_legacy_irqs(v
 	}
 }
 
-int mp_register_gsi(u32 gsi, int triggering, int polarity)
+int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
@@ -1253,7 +1253,7 @@ int mp_register_gsi(u32 gsi, int trigger
 		}
 	}
 #endif
-	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
+	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
 				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	return gsi;
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3851,11 +3851,12 @@ int __init io_apic_get_version(int ioapi
 }
 #endif
 
-int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
+int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node;
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3863,6 +3864,11 @@ int io_apic_set_pci_routing (int ioapic,
 		return -EINVAL;
 	}
 
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
Index: linux-2.6/drivers/acpi/pci_irq.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_irq.c
+++ linux-2.6/drivers/acpi/pci_irq.c
@@ -401,7 +401,8 @@ int acpi_pci_irq_enable(struct pci_dev *
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
-			acpi_register_gsi(dev->irq, ACPI_LEVEL_SENSITIVE,
+			acpi_register_gsi(&dev->dev, dev->irq,
+					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
 		} else {
@@ -410,7 +411,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 		}
 	}
 
-	rc = acpi_register_gsi(gsi, triggering, polarity);
+	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (rc < 0) {
 		dev_warn(&dev->dev, "PCI INT %c: failed to register GSI\n",
 			 pin_name(pin));
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -224,7 +224,7 @@ static void hpet_timer_set_irq(struct hp
 			break;
 		}
 
-		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+		gsi = acpi_register_gsi(NULL, irq, ACPI_LEVEL_SENSITIVE,
 					ACPI_ACTIVE_LOW);
 		if (gsi > 0)
 			break;
@@ -939,7 +939,7 @@ static acpi_status hpet_resources(struct
 		irqp = &res->data.extended_irq;
 
 		for (i = 0; i < irqp->interrupt_count; i++) {
-			irq = acpi_register_gsi(irqp->interrupts[i],
+			irq = acpi_register_gsi(NULL, irqp->interrupts[i],
 				      irqp->triggering, irqp->polarity);
 			if (irq < 0)
 				return AE_ERROR;
Index: linux-2.6/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6/drivers/pnp/pnpacpi/rsparser.c
@@ -123,7 +123,7 @@ static void pnpacpi_parse_allocated_irqr
 	}
 
 	flags = irq_flags(triggering, polarity, shareable);
-	irq = acpi_register_gsi(gsi, triggering, polarity);
+	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (irq >= 0)
 		pcibios_penalize_isa_irq(irq, 1);
 	else
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -118,7 +118,7 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
-int acpi_register_gsi (u32 gsi, int triggering, int polarity);
+int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
 #ifdef CONFIG_X86_IO_APIC
