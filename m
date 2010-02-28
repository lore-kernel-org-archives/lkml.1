Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031670Ab0B1JJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 04:09:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:42571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031633Ab0B1JJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 04:09:45 -0500
Message-ID: <4B8A3270.2000007@kernel.org>
Date: Sun, 28 Feb 2010 01:08:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       garyhade@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       trenn@suse.de
Subject: [PATCH -v12 2/2] x86: fix out of order of gsi - full
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org> <4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org> <4B89E751.1060903@kernel.org> <20100228080941.GD14205@elte.hu>
In-Reply-To: <20100228080941.GD14205@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Iranna D Ankad reported that IBM x3950 systems have boot problems
after this commit:

 |
 | commit b9c61b70075c87a8612624736faf4a2de5b1ed30
 |
 |    x86/pci: update pirq_enable_irq() to setup io apic routing
 |

    As explained in the previous patch ("x86: Fix out of order gsi - partial)
    try to remap those gsis

    This patch adds boot_ioapic_idx and gsi_to_irq/irq_to_gsi

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: len.brown@intel.com


---
 arch/x86/include/asm/io_apic.h |    2 
 arch/x86/include/asm/mpspec.h  |    3 +
 arch/x86/kernel/acpi/boot.c    |   28 +++++++----
 arch/x86/kernel/apic/io_apic.c |  104 +++++++++++++++++++++++++++++++++--------
 drivers/pnp/pnpacpi/rsparser.c |    8 +++
 5 files changed, 114 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -160,7 +160,7 @@ extern int io_apic_get_redir_entries(int
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
@@ -97,6 +97,9 @@ static inline void early_reserve_e820_mp
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
+extern unsigned int isa_irq_to_gsi[];
+int gsi_to_irq(unsigned int gsi);
+unsigned int irq_to_gsi(int irq);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -310,7 +310,8 @@ acpi_parse_ioapic(struct acpi_subtable_h
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init
+acpi_sci_ioapic_setup(u8 bus_irq, u32 gsi, u16 polarity, u16 trigger)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -330,7 +331,7 @@ static void __init acpi_sci_ioapic_setup
 	 * If GSI is < 16, this will update its flags,
 	 * else it will create a new mp_irqs[] entry.
 	 */
-	mp_override_legacy_irq(gsi, polarity, trigger, gsi);
+	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
 	 * stash over-ride to indicate we've been here
@@ -354,7 +355,8 @@ acpi_parse_int_src_ovr(struct acpi_subta
 	acpi_table_print_madt_entry(header);
 
 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
-		acpi_sci_ioapic_setup(intsrc->global_irq,
+		acpi_sci_ioapic_setup(intsrc->source_irq,
+				      intsrc->global_irq,
 				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
 				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
 		return 0;
@@ -449,7 +451,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned in
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
+		setup_IO_APIC_irq_extra(gsi, irq);
 #endif
 
 	return 0;
@@ -921,6 +923,8 @@ void __init mp_override_legacy_irq(u8 bu
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -950,7 +954,7 @@ void __init mp_config_acpi_legacy_irqs(v
 	/*
 	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
 	 */
-	ioapic = mp_find_ioapic(0);
+	ioapic = mp_find_ioapic(irq_to_gsi(0));
 	if (ioapic < 0)
 		return;
 	dstapic = mp_ioapics[ioapic].apicid;
@@ -1033,6 +1037,7 @@ int mp_register_gsi(struct device *dev,
 {
 	int ioapic;
 	int ioapic_pin;
+	int irq;
 	struct io_apic_irq_attr irq_attr;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
@@ -1055,11 +1060,12 @@ int mp_register_gsi(struct device *dev,
 		gsi = ioapic_renumber_irq(ioapic, gsi);
 #endif
 
+	irq = gsi_to_irq(gsi);
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
-		return gsi;
+		return irq;
 	}
 
 	if (enable_update_mptable)
@@ -1068,9 +1074,9 @@ int mp_register_gsi(struct device *dev,
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, irq, &irq_attr);
 
-	return gsi;
+	return irq;
 }
 
 /*
@@ -1127,8 +1133,10 @@ static int __init acpi_parse_madt_ioapic
 	 * If BIOS did not supply an INT_SRC_OVR for the SCI
 	 * pretend we got one so we can set the SCI flags.
 	 */
-	if (!acpi_sci_override_gsi)
-		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
+	if (!acpi_sci_override_gsi) {
+		int irq = gsi_to_irq(acpi_gbl_FADT.sci_interrupt);
+		acpi_sci_ioapic_setup(irq, acpi_gbl_FADT.sci_interrupt, 0, 0);
+	}
 
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -97,6 +97,41 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
+/* By default isa irqs are identity mapped to gsis */
+unsigned int isa_irq_to_gsi[NR_IRQS_LEGACY] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
+};
+
+static int boot_ioapic_idx;
+static int gsi_delta;
+int gsi_to_irq(unsigned int gsi)
+{
+	unsigned int irq = gsi;
+	unsigned int i;
+
+	irq += gsi_delta;
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		if (isa_irq_to_gsi[i] == gsi) {
+			irq = i;
+			break;
+		}
+	}
+
+	return irq;
+}
+
+unsigned int irq_to_gsi(int irq)
+{
+	unsigned int gsi;
+
+	if (irq < NR_IRQS_LEGACY)
+		gsi = isa_irq_to_gsi[irq];
+	else
+		gsi = irq - gsi_delta;
+
+	return gsi;
+}
+
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -1016,7 +1051,7 @@ static inline int irq_trigger(int idx)
 int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
-	int irq, i;
+	int irq;
 	int bus = mp_irqs[idx].srcbus;
 
 	/*
@@ -1028,18 +1063,28 @@ static int pin_2_irq(int idx, int apic,
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
+		unsigned int gsi;
+		if (!acpi_ioapic) {
+			int i;
+			/*
+			 * PCI IRQs are mapped in order
+			 */
+			i = gsi = 0;
+			while (i < apic)
+				gsi += nr_ioapic_registers[i++];
+			gsi += pin;
+		} else
+			gsi = pin + mp_gsi_routing[apic].gsi_base;
+
+#ifdef CONFIG_X86_32
 		/*
                  * For MPS mode, so far only needed by ES7000 platform
                  */
 		if (ioapic_renumber_irq)
-			irq = ioapic_renumber_irq(apic, irq);
+			gsi = ioapic_renumber_irq(apic, gsi);
+#endif
+
+		irq = gsi_to_irq(gsi);
 	}
 
 #ifdef CONFIG_X86_32
@@ -1475,15 +1520,16 @@ static struct {
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id, pin, idx, irq;
+	int pin, apic_id, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int node = cpu_to_node(boot_cpu_id);
 
+	apic_id = boot_ioapic_idx;
+
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (idx == -1) {
@@ -1505,9 +1551,6 @@ static void __init setup_IO_APIC_irqs(vo
 
 		irq = pin_2_irq(idx, apic_id, pin);
 
-		if ((apic_id > 0) && (irq > 16))
-			continue;
-
 		/*
 		 * Skip the timer IRQ if there's a quirk handler
 		 * installed and if it returns 1:
@@ -1541,7 +1584,7 @@ static void __init setup_IO_APIC_irqs(vo
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
-void setup_IO_APIC_irq_extra(u32 gsi)
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
 {
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
@@ -1561,6 +1604,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
+	*pirq = irq;
 #ifdef CONFIG_SPARSE_IRQ
 	desc = irq_to_desc(irq);
 	if (desc)
@@ -2004,6 +2048,27 @@ void __init enable_IO_APIC(void)
 	clear_IO_APIC();
 }
 
+static void __init probe_ioapic_i8259(void)
+{
+	/* probe boot ioapic idx */
+	boot_ioapic_idx = ioapic_i8259.apic;
+	if (boot_ioapic_idx < 0)
+		boot_ioapic_idx = find_isa_irq_apic(0, mp_INT);
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic && boot_ioapic_idx < 0)
+		boot_ioapic_idx = mp_find_ioapic(irq_to_gsi(0));
+#endif
+	if (boot_ioapic_idx < 0)
+		boot_ioapic_idx = 0;
+
+	if (mp_gsi_routing[boot_ioapic_idx].gsi_base) {
+		gsi_delta = NR_IRQS_LEGACY;
+		nr_irqs_gsi += NR_IRQS_LEGACY;
+	}
+
+	printk(KERN_INFO "boot_ioapic_idx: %d\n", boot_ioapic_idx);
+}
+
 /*
  * Not an __init, needed by the reboot code
  */
@@ -3015,7 +3080,7 @@ static inline void __init check_timer(vo
 				enable_8259A_irq(0);
 			}
 			if (disable_timer_pin_1 > 0)
-				clear_IO_APIC_pin(0, pin1);
+				clear_IO_APIC_pin(apic1, pin1);
 			goto out;
 		}
 		if (intr_remapping_enabled)
@@ -3135,6 +3200,7 @@ void __init setup_IO_APIC(void)
 	x86_init.mpparse.setup_ioapic_ids();
 
 	sync_Arb_IDs();
+	probe_ioapic_i8259();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	if (nr_legacy_irqs)
@@ -4108,16 +4174,14 @@ void __init setup_ioapic_dest(void)
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
+	ioapic = boot_ioapic_idx;
+
 	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
 		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > 16))
-			continue;
-
 		desc = irq_to_desc(irq);
 
 		/*
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
+		gsi = irq_to_gsi(gsi);
+#endif
 	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (irq >= 0)
 		pcibios_penalize_isa_irq(irq, 1);
