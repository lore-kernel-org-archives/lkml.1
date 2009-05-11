Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZEKTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZEKTmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZEKTmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:42:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:53730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZEKTmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:42:00 -0400
Message-ID: <4A087F35.2000903@kernel.org>
Date: Mon, 11 May 2009 12:40:37 -0700
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
Subject: Re: [PATCH 5/7] x86/pci: add 4 more return param in	IO_APIC_get_PCI_irq_vector
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org> <20090511082834.GD5636@elte.hu>
In-Reply-To: <20090511082834.GD5636@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> That function has way too many parameters. Please introduce a helper 
> structure (struct io_apic_irq_attr) where the parameters can be 
> passed along in a clean and short fashion. We update them by 
> reference anyway.
> 
> I've applied the patch, but we need these cleanups too, the code has 
> become too ugly.
> 
please check

[PATCH] x86: introduce io_apic_irq_attr

according to Ingo, some io_apic related function get too more parameter
So reduce related funcs to get less param by passing io_apic_irq pointer

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hw_irq.h     |   11 ++++++++--
 arch/x86/include/asm/io_apic.h    |    5 ++--
 arch/x86/kernel/acpi/boot.c       |    9 +++++---
 arch/x86/kernel/apic/io_apic.c    |   41 ++++++++++++++++++++++----------------
 arch/x86/pci/irq.c                |   15 +++----------
 drivers/pci/hotplug/ibmphp_core.c |    7 +-----
 6 files changed, 48 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -63,9 +63,16 @@ extern unsigned long io_apic_irqs;
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
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
-					int *ioapic, int *ioapic_pin,
-					int *trigger, int *polarity);
+					struct io_apic_irq_attr *io_apic_irq);
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
+		 struct io_apic_irq_attr *io_apic_irq);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1198,6 +1198,7 @@ int mp_register_gsi(struct device *dev,
 {
 	int ioapic;
 	int ioapic_pin;
+	struct io_apic_irq_attr io_apic_irq;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1227,9 +1228,11 @@ int mp_register_gsi(struct device *dev,
 	}
 	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
 
-	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
-				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
-				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	io_apic_irq.ioapic = ioapic;
+	io_apic_irq.ioapic_pin = ioapic_pin;
+	io_apic_irq.trigger = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
+	io_apic_irq.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	io_apic_set_pci_routing(dev, gsi, &io_apic_irq);
 
 	return gsi;
 }
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1096,8 +1096,7 @@ static int pin_2_irq(int idx, int apic,
  * Not an __init, possibly needed by modules
  */
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				int *ioapic, int *ioapic_pin,
-				int *trigger, int *polarity)
+				struct io_apic_irq_attr *io_apic_irq)
 {
 	int apic, i, best_guess = -1;
 
@@ -1127,10 +1126,10 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 				continue;
 
 			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				*ioapic = apic;
-				*ioapic_pin = mp_irqs[i].dstirq;
-				*trigger = irq_trigger(i);
-				*polarity = irq_polarity(i);
+				io_apic_irq->ioapic = apic;
+				io_apic_irq->ioapic_pin = mp_irqs[i].dstirq;
+				io_apic_irq->trigger = irq_trigger(i);
+				io_apic_irq->polarity = irq_polarity(i);
 				return irq;
 			}
 			/*
@@ -1138,10 +1137,10 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 			 * best-guess fuzzy result for broken mptables.
 			 */
 			if (best_guess < 0) {
-				*ioapic = apic;
-				*ioapic_pin = mp_irqs[i].dstirq;
-				*trigger = irq_trigger(i);
-				*polarity = irq_polarity(i);
+				io_apic_irq->ioapic = apic;
+				io_apic_irq->ioapic_pin = mp_irqs[i].dstirq;
+				io_apic_irq->trigger = irq_trigger(i);
+				io_apic_irq->polarity = irq_polarity(i);
 				best_guess = irq;
 			}
 		}
@@ -3848,13 +3847,16 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
-static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
+static int __io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *io_apic_irq)
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int node;
+	int ioapic, pin;
+	int triggering, polarity;
 
+	ioapic = io_apic_irq->ioapic;
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
@@ -3872,6 +3874,10 @@ static int __io_apic_set_pci_routing(str
 		return 0;
 	}
 
+	pin = io_apic_irq->ioapic_pin;
+	triggering = io_apic_irq->trigger;
+	polarity = io_apic_irq->polarity;
+
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
@@ -3885,15 +3891,17 @@ static int __io_apic_set_pci_routing(str
 	return 0;
 }
 
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
+int io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *io_apic_irq)
 {
-
+	int ioapic, pin;
 	/*
 	 * Avoid pin reprogramming.  PRTs typically include entries
 	 * with redundant pin->gsi mappings (but unique PCI devices);
 	 * we only program the IOAPIC on the first.
 	 */
+	ioapic = io_apic_irq->ioapic;
+	pin = io_apic_irq->ioapic_pin;
 	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mp_ioapics[ioapic].apicid, pin);
@@ -3901,8 +3909,7 @@ int io_apic_set_pci_routing(struct devic
 	}
 	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
 
-	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
-					 triggering, polarity);
+	return __io_apic_set_pci_routing(dev, irq, io_apic_irq);
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
+			struct io_apic_irq_attr io_apic_irq;
 
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
 						PCI_SLOT(dev->devfn),
-						pin - 1,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
+						pin - 1, &io_apic_irq);
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
+						pin - 1, &io_apic_irq);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
@@ -1233,9 +1228,7 @@ static int pirq_enable_irq(struct pci_de
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				io_apic_set_pci_routing(&dev->dev, ioapic,
-							ioapic_pin, irq,
-							triggering, polarity);
+				io_apic_set_pci_routing(&dev->dev, irq, &io_apic_irq);
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
Index: linux-2.6/drivers/pci/hotplug/ibmphp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/ibmphp_core.c
+++ linux-2.6/drivers/pci/hotplug/ibmphp_core.c
@@ -155,15 +155,12 @@ int ibmphp_init_devno(struct slot **cur_
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot &&
 		    (*cur_slot)->bus == rtable->slots[loop].bus) {
-			int ioapic = -1, ioapic_pin = -1;
-			int triggering, polarity;
+			struct io_apic_irq_attr io_apic_irq;
 
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i.
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
+						(int) (*cur_slot)->device, i, &io_apic_irq);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
 					(*cur_slot)->irq[0]);

