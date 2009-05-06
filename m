Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZEFRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZEFRKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbZEFRKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbZEFRKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:10:23 -0400
Message-ID: <4A01C422.5070400@kernel.org>
Date: Wed, 06 May 2009 10:08:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 6/7] x86/acpi: move setup io apic routing out of ACPI macro
 scope
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we could set io apic routing when ACPI is not set

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    4 -
 arch/x86/kernel/apic/io_apic.c |  122 ++++++++++++++++++++---------------------
 2 files changed, 63 insertions(+), 63 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3840,6 +3840,67 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
+static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
+{
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int node;
+
+	if (!IO_APIC_IRQ(irq)) {
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
+			ioapic);
+		return -EINVAL;
+	}
+
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+		return 0;
+	}
+
+	/*
+	 * IRQs < 16 are already in the irq_2_pin[] map
+	 */
+	if (irq >= NR_IRQS_LEGACY) {
+		cfg = desc->chip_data;
+		add_pin_to_irq_node(cfg, node, ioapic, pin);
+	}
+
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
+
+	return 0;
+}
+
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
+int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
+{
+
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
+	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[ioapic].apicid, pin);
+		return 0;
+	}
+	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
+
+	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
+					 triggering, polarity);
+}
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
@@ -3934,67 +3995,6 @@ int __init io_apic_get_version(int ioapi
 }
 #endif
 
-static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
-{
-	struct irq_desc *desc;
-	struct irq_cfg *cfg;
-	int node;
-
-	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			ioapic);
-		return -EINVAL;
-	}
-
-	if (dev)
-		node = dev_to_node(dev);
-	else
-		node = cpu_to_node(boot_cpu_id);
-
-	desc = irq_to_desc_alloc_node(irq, node);
-	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc %d\n", irq);
-		return 0;
-	}
-
-	/*
-	 * IRQs < 16 are already in the irq_2_pin[] map
-	 */
-	if (irq >= NR_IRQS_LEGACY) {
-		cfg = desc->chip_data;
-		add_pin_to_irq_node(cfg, node, ioapic, pin);
-	}
-
-	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
-
-	return 0;
-}
-
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
-{
-
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[ioapic].apicid, pin);
-		return 0;
-	}
-	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
-
-	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
-					 triggering, polarity);
-}
-
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
 	int i;
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -154,10 +154,10 @@ extern int timer_through_8259;
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
-				  int irq, int edge_level, int active_high_low);
 #endif /* CONFIG_ACPI */
 
+extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
+				  int irq, int edge_level, int active_high_low);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
