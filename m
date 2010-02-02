Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0BBBRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:17:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:59095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0BBBR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:17:29 -0500
Message-ID: <4B677CFC.9080406@kernel.org>
Date: Mon, 01 Feb 2010 17:16:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: IRQ regression messes up xseries 330 SCI resulting in apic=off
 - bisected to commit b9c61b70075c87a861262473
References: <201002011559.07869.trenn@suse.de>
In-Reply-To: <201002011559.07869.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 06:59 AM, Thomas Renninger wrote:
> Hi,
> 
> booting a latest kernel on this machine results in:
> 
> PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
> PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
> ACPI: SCI (IRQ30) allocation failed
> ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
> ACPI: Unable to start the ACPI Interpreter
> 

please check

[PATCH] x86: fix sci on ioapic 1

Thomas Renninger <trenn@suse.de> reported on IBM x3330

booting a latest kernel on this machine results in:

PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
ACPI: SCI (IRQ30) allocation failed
ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
ACPI: Unable to start the ACPI Interpreter

Later all kind of devices fail...

and bisect it down to this commit:
commit b9c61b70075c87a8612624736faf4a2de5b1ed30

    x86/pci: update pirq_enable_irq() to setup io apic routing

it turns out we need to set irq routing for the sci on ioapic1 early.

Reported-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    2 +
 arch/x86/kernel/acpi/boot.c    |    6 ++++-
 arch/x86/kernel/apic/io_apic.c |   49 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -160,6 +160,7 @@ extern int io_apic_get_redir_entries(int
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
+void setup_IO_APIC_irq_extra(u32 gsi);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
@@ -197,6 +198,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
+static inline void setup_IO_APIC_irq_extra(u32 gsi) { }
 
 #endif
 
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -446,6 +446,9 @@ void __init acpi_pic_sci_set_trigger(uns
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi;
+
+	setup_IO_APIC_irq_extra(gsi);
+
 	return 0;
 }
 
@@ -473,7 +476,8 @@ int acpi_register_gsi(struct device *dev
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	acpi_gsi_to_irq(plat_gsi, &irq);
+	irq = plat_gsi;
+
 	return irq;
 }
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1541,6 +1541,55 @@ static void __init setup_IO_APIC_irqs(vo
 }
 
 /*
+ * for the gsit that is not in first ioapic
+ * but could not use acpi_register_gsi()
+ * like some special sci in IBM x3330
+ */
+void setup_IO_APIC_irq_extra(u32 gsi)
+{
+	int apic_id = 0, pin, idx, irq;
+	int node = cpu_to_node(boot_cpu_id);
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+
+        /*
+         * Convert 'gsi' to 'ioapic.pin'.
+         */
+        apic_id = mp_find_ioapic(gsi);
+        if (apic_id < 0)
+                return;
+
+        pin = mp_find_ioapic_pin(apic_id, gsi);
+	idx = find_irq_entry(apic_id, pin, mp_INT);
+	if (idx == -1)
+		return;
+
+	irq = pin_2_irq(idx, apic_id, pin);
+	desc = irq_to_desc(irq);
+	if (desc)
+		return;
+
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		return;
+	}
+
+	cfg = desc->chip_data;
+	add_pin_to_irq_node(cfg, node, apic_id, pin);
+
+	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[apic_id].apicid, pin);
+		return;
+	}
+	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+
+	setup_IO_APIC_irq(apic_id, pin, irq, desc,
+			irq_trigger(idx), irq_polarity(idx));
+}
+
+/*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
