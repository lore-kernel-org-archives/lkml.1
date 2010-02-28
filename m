Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968697Ab0B1Dbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 22:31:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:50111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968613Ab0B1Dbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 22:31:36 -0500
Message-ID: <4B89E255.5090903@kernel.org>
Date: Sat, 27 Feb 2010 19:26:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com
CC: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de, Len Brown <lenb@kernel.org>
Subject: [PATCH -v10] x86: fix out of order of gsi
References: <4B882182.4030205@kernel.org>	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>	<4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org> <4B89C30F.9060706@kernel.org>
In-Reply-To: <4B89C30F.9060706@kernel.org>
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
-v9: according to Eric, use fixed 16 for shifting instead of remap
-v10: still nee to touch rsparser.c

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: stable@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    2 
 arch/x86/include/asm/mpspec.h  |    3 +
 arch/x86/kernel/acpi/boot.c    |   28 ++++++----
 arch/x86/kernel/apic/io_apic.c |  112 ++++++++++++++++++++++++++++++-----------
 drivers/pnp/pnpacpi/rsparser.c |    8 ++
 5 files changed, 114 insertions(+), 39 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -158,7 +158,7 @@ extern int io_apic_get_redir_entries(int
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
@@ -96,6 +96,9 @@ static inline void early_reserve_e820_mp
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
@@ -945,6 +947,8 @@ void __init mp_override_legacy_irq(u8 bu
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -974,7 +978,7 @@ void __init mp_config_acpi_legacy_irqs(v
 	/*
 	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
 	 */
-	ioapic = mp_find_ioapic(0);
+	ioapic = mp_find_ioapic(irq_to_gsi(0));
 	if (ioapic < 0)
 		return;
 	dstapic = mp_ioapics[ioapic].apicid;
@@ -1057,6 +1061,7 @@ int mp_register_gsi(struct device *dev,
 {
 	int ioapic;
 	int ioapic_pin;
+	int irq;
 	struct io_apic_irq_attr irq_attr;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
@@ -1079,11 +1084,12 @@ int mp_register_gsi(struct device *dev,
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
@@ -1092,9 +1098,9 @@ int mp_register_gsi(struct device *dev,
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, irq, &irq_attr);
 
-	return gsi;
+	return irq;
 }
 
 /*
@@ -1151,8 +1157,10 @@ static int __init acpi_parse_madt_ioapic
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
@@ -1006,7 +1041,7 @@ static inline int irq_trigger(int idx)
 int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
-	int irq, i;
+	int irq;
 	int bus = mp_irqs[idx].srcbus;
 
 	/*
@@ -1018,18 +1053,28 @@ static int pin_2_irq(int idx, int apic,
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
@@ -1465,21 +1510,15 @@ static struct {
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id = 0, pin, idx, irq;
+	int pin, apic_id, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int node = cpu_to_node(boot_cpu_id);
 
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
+	apic_id = boot_ioapic_idx;
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
@@ -1535,7 +1574,7 @@ static void __init setup_IO_APIC_irqs(vo
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
-void setup_IO_APIC_irq_extra(u32 gsi)
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
 {
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
@@ -1555,6 +1594,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
+	*pirq = irq;
 #ifdef CONFIG_SPARSE_IRQ
 	desc = irq_to_desc(irq);
 	if (desc)
@@ -1998,6 +2038,27 @@ void __init enable_IO_APIC(void)
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
@@ -2991,7 +3052,7 @@ static inline void __init check_timer(vo
 				legacy_pic->chip->unmask(desc);
 			}
 			if (disable_timer_pin_1 > 0)
-				clear_IO_APIC_pin(0, pin1);
+				clear_IO_APIC_pin(apic1, pin1);
 			goto out;
 		}
 		if (intr_remapping_enabled)
@@ -3111,6 +3172,7 @@ void __init setup_IO_APIC(void)
 	x86_init.mpparse.setup_ioapic_ids();
 
 	sync_Arb_IDs();
+	probe_ioapic_i8259();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	if (legacy_pic->nr_legacy_irqs)
@@ -4061,20 +4123,14 @@ int acpi_get_override_irq(int bus_irq, i
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic = 0, irq, irq_entry;
+	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		ioapic = mp_find_ioapic(0);
-		if (ioapic < 0)
-			ioapic = 0;
-	}
-#endif
+	ioapic = boot_ioapic_idx;
 
 	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
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
