Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZELSDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZELSDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZELSDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZELSDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:03:32 -0400
Message-ID: <4A09B9AA.2080501@kernel.org>
Date: Tue, 12 May 2009 11:02:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce io_apic_irq_attr -v2
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org> <20090511082834.GD5636@elte.hu> <4A087F35.2000903@kernel.org> <20090511213755.GB21232@elte.hu> <4A08ACD3.2070401@kernel.org> <20090512103236.GC11714@elte.hu>
In-Reply-To: <20090512103236.GC11714@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: introduce io_apic_irq_attr -v3

according to Ingo, some io_apic related function get too more parameter
So reduce related funcs to get less param by passing io_apic_irq pointer

v2: io_apic_irq ==> irq_attr
    triggering ==> trigger
v3: add set_io_apic_irq_attr

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hw_irq.h     |   21 ++++++++++++++++--
 arch/x86/include/asm/io_apic.h    |    5 ++--
 arch/x86/kernel/acpi/boot.c       |   22 ++++++++++---------
 arch/x86/kernel/apic/io_apic.c    |   43 ++++++++++++++++++++++----------------
 arch/x86/pci/irq.c                |   16 ++++----------
 drivers/pci/hotplug/ibmphp_core.c |    6 +----
 6 files changed, 66 insertions(+), 47 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -66,9 +66,26 @@ extern unsigned long io_apic_irqs;
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
+
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic     = ioapic;
+	irq_attr->ioapic_pin = ioapic_pin;
+	irq_attr->trigger    = trigger;
+	irq_attr->polarity   = polarity;
+}
+
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
-					int *ioapic, int *ioapic_pin,
-					int *trigger, int *polarity);
+					struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -156,8 +156,9 @@ extern int io_apic_get_version(int ioapi
 extern int io_apic_get_redir_entries(int ioapic);
 #endif /* CONFIG_ACPI */
 
-extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
-				  int irq, int edge_level, int active_high_low);
+struct io_apic_irq_attr;
+extern int io_apic_set_pci_routing(struct device *dev, int irq,
+		 struct io_apic_irq_attr *irq_attr);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -523,7 +523,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned in
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
@@ -533,14 +533,14 @@ int acpi_register_gsi(struct device *dev
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
 	 */
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
-		if (triggering == ACPI_LEVEL_SENSITIVE)
+		if (trigger == ACPI_LEVEL_SENSITIVE)
 			eisa_set_level_irq(gsi);
 	}
 #endif
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
-		plat_gsi = mp_register_gsi(dev, gsi, triggering, polarity);
+		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
 	acpi_gsi_to_irq(plat_gsi, &irq);
@@ -1156,7 +1156,7 @@ void __init mp_config_acpi_legacy_irqs(v
 	}
 }
 
-static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 			int polarity)
 {
 #ifdef CONFIG_X86_MPPARSE
@@ -1181,7 +1181,7 @@ static int mp_config_acpi_gsi(struct dev
 	/* print the entry should happen on mptable identically */
 	mp_irq.type = MP_INTSRC;
 	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
@@ -1194,10 +1194,11 @@ static int mp_config_acpi_gsi(struct dev
 	return 0;
 }
 
-int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
+int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
+	struct io_apic_irq_attr irq_attr;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1225,11 +1226,12 @@ int mp_register_gsi(struct device *dev,
 		       ioapic_pin);
 		return gsi;
 	}
-	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
+	mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
-	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
-				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
-				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
+			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
+			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	io_apic_set_pci_routing(dev, gsi, &irq_attr);
 
 	return gsi;
 }
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1097,8 +1097,7 @@ static int pin_2_irq(int idx, int apic,
  * Not an __init, possibly needed by modules
  */
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				int *ioapic, int *ioapic_pin,
-				int *trigger, int *polarity)
+				struct io_apic_irq_attr *irq_attr)
 {
 	int apic, i, best_guess = -1;
 
@@ -1128,10 +1127,10 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 				continue;
 
 			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				*ioapic = apic;
-				*ioapic_pin = mp_irqs[i].dstirq;
-				*trigger = irq_trigger(i);
-				*polarity = irq_polarity(i);
+				set_io_apic_irq_attr(irq_attr, apic,
+						     mp_irqs[i].dstirq,
+						     irq_trigger(i),
+						     irq_polarity(i));
 				return irq;
 			}
 			/*
@@ -1139,10 +1138,10 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 			 * best-guess fuzzy result for broken mptables.
 			 */
 			if (best_guess < 0) {
-				*ioapic = apic;
-				*ioapic_pin = mp_irqs[i].dstirq;
-				*trigger = irq_trigger(i);
-				*polarity = irq_polarity(i);
+				set_io_apic_irq_attr(irq_attr, apic,
+						     mp_irqs[i].dstirq,
+						     irq_trigger(i),
+						     irq_polarity(i));
 				best_guess = irq;
 			}
 		}
@@ -3866,13 +3865,16 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
-static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
+static int __io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *irq_attr)
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int node;
+	int ioapic, pin;
+	int trigger, polarity;
 
+	ioapic = irq_attr->ioapic;
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
@@ -3890,6 +3892,10 @@ static int __io_apic_set_pci_routing(str
 		return 0;
 	}
 
+	pin = irq_attr->ioapic_pin;
+	trigger = irq_attr->trigger;
+	polarity = irq_attr->polarity;
+
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
@@ -3898,20 +3904,22 @@ static int __io_apic_set_pci_routing(str
 		add_pin_to_irq_node(cfg, node, ioapic, pin);
 	}
 
-	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, trigger, polarity);
 
 	return 0;
 }
 
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
+int io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *irq_attr)
 {
-
+	int ioapic, pin;
 	/*
 	 * Avoid pin reprogramming.  PRTs typically include entries
 	 * with redundant pin->gsi mappings (but unique PCI devices);
 	 * we only program the IOAPIC on the first.
 	 */
+	ioapic = irq_attr->ioapic;
+	pin = irq_attr->ioapic_pin;
 	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mp_ioapics[ioapic].apicid, pin);
@@ -3919,8 +3927,7 @@ int io_apic_set_pci_routing(struct devic
 	}
 	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
 
-	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
-					 triggering, polarity);
+	return __io_apic_set_pci_routing(dev, irq, irq_attr);
 }
 
 /* --------------------------------------------------------------------------
Index: linux-2.6/arch/x86/pci/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/irq.c
+++ linux-2.6/arch/x86/pci/irq.c
@@ -1200,14 +1200,11 @@ static int pirq_enable_irq(struct pci_de
 #ifdef CONFIG_X86_IO_APIC
 			struct pci_dev *temp_dev;
 			int irq;
-			int ioapic = -1, ioapic_pin = -1;
-			int triggering, polarity;
+			struct io_apic_irq_attr irq_attr;
 
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
 						PCI_SLOT(dev->devfn),
-						pin - 1,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
+						pin - 1, &irq_attr);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1221,9 +1218,7 @@ static int pirq_enable_irq(struct pci_de
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn),
-						pin - 1,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
+						pin - 1, &irq_attr);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
@@ -1233,9 +1228,8 @@ static int pirq_enable_irq(struct pci_de
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				io_apic_set_pci_routing(&dev->dev, ioapic,
-							ioapic_pin, irq,
-							triggering, polarity);
+				io_apic_set_pci_routing(&dev->dev, irq,
+							 &irq_attr);
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
Index: linux-2.6/drivers/pci/hotplug/ibmphp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/ibmphp_core.c
+++ linux-2.6/drivers/pci/hotplug/ibmphp_core.c
@@ -155,15 +155,13 @@ int ibmphp_init_devno(struct slot **cur_
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot &&
 		    (*cur_slot)->bus == rtable->slots[loop].bus) {
-			int ioapic = -1, ioapic_pin = -1;
-			int triggering, polarity;
+			struct io_apic_irq_attr irq_attr;
 
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
 						(int) (*cur_slot)->device, i,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
+						&irq_attr);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
 					(*cur_slot)->irq[0]);
