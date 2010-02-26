Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888Ab0BZTdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:33:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:35558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824Ab0BZTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:32:56 -0500
Message-ID: <4B882182.4030205@kernel.org>
Date: Fri, 26 Feb 2010 11:31:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Iranna D Ankad <iranna.ankad@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v8 2/2] x86: fix out of order of gsi -- add remap_ioapic_gsi_to_irq
References: <201002221108.42847.trenn@suse.de> <4B826CA6.7060007@kernel.org> <201002221258.38506.trenn@suse.de> <4B839ACB.3000804@kernel.org> <4B842129.8020906@kernel.org>
In-Reply-To: <4B842129.8020906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found IBM x3950 will have problem after

|commit b9c61b70075c87a8612624736faf4a2de5b1ed30
|
|    x86/pci: update pirq_enable_irq() to setup io apic routing

The problem is that with the patch, the machine freezes when
console=ttyS0,... kernel serial parameter is passed.
It seem to freeze at DVD initialization and the whole problem seem
to be DVD/pata related, but somehow exposed through the serial
parameter.
Such apic problems can expose really weird behavior..

<6>ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
<6>IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
<6>ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
<6>IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
<6>ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
<6>IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)

it turns out that system have three io apic controller. but put boot ioapic
routing in second one. and that gsi_base is not 0. it is using bunch of INT_SRC_OVR...

recent changes
1. one set routing for first io apic controller
2. assume irq = gsi
will break theat system.

so try to remap those gsi, need to seperate boot_ioapic_id detection out of enable_IO_APIC
and call them early.
introduce boot_ioapic_id, and remap_ioapic_gsi...

-v2: shift gsi with delta instead of gsi_base of boot_ioapic_idx
-v3: double check with find_isa_irq_apic(0, mp_INT) to get right boot_ioapic_idx
-v4: nr_legacy_irqs
-v5: add print out for boot_ioapic_idx, and also make it could be applied for current
     kernel and previous kernel
-v6: add bus_irq, in acpi_sci_ioapic_setup, so can get overwride for sci right mapping...
-v7: looks like pnpacpi get irq instead of gsi, so need to revert them back...
-v8: seperate into two patches
     this one will use remap_ioapic_gsi_to_irq, so still can use gsi pin.
     otherwise assume irq == gsi, make overwrite entris in second ioapic will block
     the accessing to the entries in first ioapic

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: stable@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    2 -
 arch/x86/include/asm/mpspec.h  |    2 +
 arch/x86/kernel/acpi/boot.c    |   63 +++++++++++++++++++++++++++++++++++------
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++-----
 drivers/pnp/pnpacpi/rsparser.c |    8 +++++
 5 files changed, 80 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,7 @@ extern int io_apic_get_redir_entries(int
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
-void setup_IO_APIC_irq_extra(u32 gsi);
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *irq);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -105,6 +105,8 @@ extern void mp_config_acpi_legacy_irqs(v
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
+int remap_ioapic_gsi_to_irq(int ioapic, u32 gsi);
+int remap_ioapic_irq_to_gsi(int irq);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_find_ioapic(int gsi);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -311,7 +311,8 @@ acpi_parse_ioapic(struct acpi_subtable_h
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init
+acpi_sci_ioapic_setup(u8 bus_irq, u32 gsi, u16 polarity, u16 trigger)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -331,7 +332,7 @@ static void __init acpi_sci_ioapic_setup
 	 * If GSI is < 16, this will update its flags,
 	 * else it will create a new mp_irqs[] entry.
 	 */
-	mp_override_legacy_irq(gsi, polarity, trigger, gsi);
+	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
 	 * stash over-ride to indicate we've been here
@@ -355,7 +356,8 @@ acpi_parse_int_src_ovr(struct acpi_subta
 	acpi_table_print_madt_entry(header);
 
 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
-		acpi_sci_ioapic_setup(intsrc->global_irq,
+		acpi_sci_ioapic_setup(intsrc->source_irq,
+				      intsrc->global_irq,
 				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
 				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
 		return 0;
@@ -450,7 +452,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned in
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
+		setup_IO_APIC_irq_extra(gsi, irq);
 #endif
 
 	return 0;
@@ -1053,11 +1055,54 @@ static int mp_config_acpi_gsi(struct dev
 	return 0;
 }
 
+int remap_ioapic_gsi_to_irq(int ioapic, u32 gsi)
+{
+	int irq = gsi;
+	int base_boot = mp_gsi_routing[boot_ioapic_idx].gsi_base;
+	int base_x;
+
+	if (!base_boot)
+		return irq;
+
+	base_x = mp_gsi_routing[ioapic].gsi_base;
+	if (base_x < base_boot) {
+		int delta;
+		delta = mp_gsi_routing[boot_ioapic_idx].gsi_end + 1;
+		delta -= base_boot;
+		irq = gsi + delta;
+	} else if (base_x == base_boot)
+		irq = gsi - base_boot;
+
+	return irq;
+}
+
+int remap_ioapic_irq_to_gsi(int irq)
+{
+	int gsi = irq;
+	int base_boot = mp_gsi_routing[boot_ioapic_idx].gsi_base;
+	int end_boot;
+	int delta;
+
+	if (!base_boot)
+		return gsi;
+
+	end_boot = mp_gsi_routing[boot_ioapic_idx].gsi_end + 1;
+	delta = end_boot - base_boot;
+
+	if (irq < delta)
+		gsi = irq + base_boot;
+	else if (irq < end_boot)
+		gsi = irq + delta;
+
+	return gsi;
+}
+
 int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
+	u32 irq;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1078,12 +1123,13 @@ int mp_register_gsi(struct device *dev,
 	if (ioapic_renumber_irq)
 		gsi = ioapic_renumber_irq(ioapic, gsi);
 #endif
+	irq = remap_ioapic_gsi_to_irq(ioapic, gsi);
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
-		return gsi;
+		return irq;
 	}
 
 	if (enable_update_mptable)
@@ -1092,9 +1138,9 @@ int mp_register_gsi(struct device *dev,
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, irq, &irq_attr);
 
-	return gsi;
+	return irq;
 }
 
 /*
@@ -1152,7 +1198,8 @@ static int __init acpi_parse_madt_ioapic
 	 * pretend we got one so we can set the SCI flags.
 	 */
 	if (!acpi_sci_override_gsi)
-		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
+		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt,
+					 acpi_gbl_FADT.sci_interrupt, 0, 0);
 
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1023,13 +1023,18 @@ static int pin_2_irq(int idx, int apic,
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
-		/*
-		 * PCI IRQs are mapped in order
-		 */
-		i = irq = 0;
-		while (i < apic)
-			irq += nr_ioapic_registers[i++];
-		irq += pin;
+		if (!acpi_ioapic) {
+			/*
+			 * PCI IRQs are mapped in order
+			 */
+			i = irq = 0;
+			while (i < apic)
+				irq += nr_ioapic_registers[i++];
+			irq += pin;
+		} else {
+			irq = pin + mp_gsi_routing[apic].gsi_base;
+			irq = remap_ioapic_gsi_to_irq(apic, irq);
+		}
 		/*
                  * For MPS mode, so far only needed by ES7000 platform
                  */
@@ -1532,7 +1537,7 @@ static void __init setup_IO_APIC_irqs(in
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
-void setup_IO_APIC_irq_extra(u32 gsi)
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
 {
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
@@ -1552,6 +1557,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
+	*pirq = irq;
 #ifdef CONFIG_SPARSE_IRQ
 	desc = irq_to_desc(irq);
 	if (desc)
Index: linux-2.6/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6/drivers/pnp/pnpacpi/rsparser.c
@@ -123,6 +123,14 @@ static void pnpacpi_parse_allocated_irqr
 	}
 
 	flags = irq_flags(triggering, polarity, shareable);
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * looks like IBM x3950 is using irq instead of gsi etc...
+	 * convert it back at first
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		gsi = remap_ioapic_irq_to_gsi(gsi);
+#endif
 	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (irq >= 0)
 		pcibios_penalize_isa_irq(irq, 1);
