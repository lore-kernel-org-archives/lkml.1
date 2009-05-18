Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZERHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZERHk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZERHkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:48932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbZERHkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:40:11 -0400
Date: Mon, 18 May 2009 07:39:32 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A08ACD3.2070401@kernel.org>
References: <4A08ACD3.2070401@kernel.org>
Subject: [tip:irq/numa] x86, apic: introduce io_apic_irq_attr
Message-ID: <tip-e5198075c67a22ec9a09565b1ce88d3d3f5ba855@git.kernel.org>
Git-Commit-ID: e5198075c67a22ec9a09565b1ce88d3d3f5ba855
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5198075c67a22ec9a09565b1ce88d3d3f5ba855
Gitweb:     http://git.kernel.org/tip/e5198075c67a22ec9a09565b1ce88d3d3f5ba855
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:05:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 08:38:55 +0200

x86, apic: introduce io_apic_irq_attr

according to Ingo, io_apic irq-setup related functions have too many
parameters with a repetitive signature.

So reduce related funcs to get less params by passing a pointer
to a newly defined io_apic_irq_attr structure.

v2: io_apic_irq ==> irq_attr
    triggering ==> trigger

v3: add set_io_apic_irq_attr

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A08ACD3.2070401@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/hw_irq.h     |   21 ++++++++++++++++-
 arch/x86/include/asm/io_apic.h    |    5 ++-
 arch/x86/kernel/acpi/boot.c       |   22 ++++++++++--------
 arch/x86/kernel/apic/io_apic.c    |   43 +++++++++++++++++++++---------------
 arch/x86/pci/irq.c                |   16 ++++---------
 drivers/pci/hotplug/ibmphp_core.c |    6 +---
 6 files changed, 66 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 26a40ab..a7d14bb 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -63,9 +63,26 @@ extern unsigned long io_apic_irqs;
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
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 6fd99f9..daf866e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -156,8 +156,9 @@ extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
 #endif /* CONFIG_ACPI */
 
-extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
-				  int irq, int edge_level, int active_high_low);
+struct io_apic_irq_attr;
+extern int io_apic_set_pci_routing(struct device *dev, int irq,
+		 struct io_apic_irq_attr *irq_attr);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index dcfbc3a..4af63df 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -523,7 +523,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
@@ -533,14 +533,14 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
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
@@ -1156,7 +1156,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	}
 }
 
-static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 			int polarity)
 {
 #ifdef CONFIG_X86_MPPARSE
@@ -1181,7 +1181,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
 	/* print the entry should happen on mptable identically */
 	mp_irq.type = MP_INTSRC;
 	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
@@ -1194,10 +1194,11 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
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
@@ -1225,11 +1226,12 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 74d2b48..ce1ac74 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1096,8 +1096,7 @@ static int pin_2_irq(int idx, int apic, int pin)
  * Not an __init, possibly needed by modules
  */
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				int *ioapic, int *ioapic_pin,
-				int *trigger, int *polarity)
+				struct io_apic_irq_attr *irq_attr)
 {
 	int apic, i, best_guess = -1;
 
@@ -1127,10 +1126,10 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
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
@@ -1138,10 +1137,10 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
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
@@ -3865,13 +3864,16 @@ int __init arch_probe_nr_irqs(void)
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
@@ -3889,6 +3891,10 @@ static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, in
 		return 0;
 	}
 
+	pin = irq_attr->ioapic_pin;
+	trigger = irq_attr->trigger;
+	polarity = irq_attr->polarity;
+
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
@@ -3897,20 +3903,22 @@ static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, in
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
@@ -3918,8 +3926,7 @@ int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 	}
 	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
 
-	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
-					 triggering, polarity);
+	return __io_apic_set_pci_routing(dev, irq, irq_attr);
 }
 
 /* --------------------------------------------------------------------------
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 2f3e192..0696d50 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1200,14 +1200,11 @@ static int pirq_enable_irq(struct pci_dev *dev)
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
@@ -1221,9 +1218,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
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
@@ -1233,9 +1228,8 @@ static int pirq_enable_irq(struct pci_dev *dev)
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
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 79901a0..42e4260 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -155,15 +155,13 @@ int ibmphp_init_devno(struct slot **cur_slot)
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
