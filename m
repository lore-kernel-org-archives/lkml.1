Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0BWSmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:42:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:55718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab0BWSmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:42:09 -0500
Message-ID: <4B842129.8020906@kernel.org>
Date: Tue, 23 Feb 2010 10:40:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Iranna D Ankad <iranna.ankad@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Other problem/regression with b9c61b70075c87a8612624736faf4a2de5b1ed30
References: <201002221108.42847.trenn@suse.de> <4B826CA6.7060007@kernel.org> <201002221258.38506.trenn@suse.de> <4B839ACB.3000804@kernel.org>
In-Reply-To: <4B839ACB.3000804@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 01:07 AM, Yinghai Lu wrote:
> Gary,
> 
> can you check this patch on your x3950?

Subject: [PATCH -v2] x86: fix out of order of gsi

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

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: stable@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    3 +-
 arch/x86/include/asm/mpspec.h  |    1 
 arch/x86/kernel/acpi/boot.c    |   30 +++++++++++++++++++---
 arch/x86/kernel/apic/io_apic.c |   55 ++++++++++++++++++++++++-----------------
 4 files changed, 62 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -113,6 +113,7 @@ struct IR_IO_APIC_route_entry {
  */
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
+extern int boot_ioapic_idx;
 
 #define MP_MAX_IOAPIC_PIN 127
 
@@ -160,7 +161,7 @@ extern int io_apic_get_redir_entries(int
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
@@ -105,6 +105,7 @@ extern void mp_config_acpi_legacy_irqs(v
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
+int remap_ioapic_gsi(int ioapic, u32 gsi);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_find_ioapic(int gsi);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -449,7 +449,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned in
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
+		setup_IO_APIC_irq_extra(gsi, irq);
 #endif
 
 	return 0;
@@ -1052,11 +1052,32 @@ static int mp_config_acpi_gsi(struct dev
 	return 0;
 }
 
+int remap_ioapic_gsi(int ioapic, u32 gsi)
+{
+	int base_boot = mp_gsi_routing[boot_ioapic_idx].gsi_base;
+	int base_x;
+
+	if (!base_boot)
+		return gsi;
+
+	base_x = mp_gsi_routing[ioapic].gsi_base;
+	if (base_x < base_boot) {
+		int delta;
+		delta = mp_gsi_routing[boot_ioapic_idx].gsi_end + 1;
+		delta -= base_boot;
+		gsi += delta;
+	} else if (base_x == base_boot)
+		gsi -= base_boot;
+
+	return gsi;
+}
+
 int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
+	u32 plat_gsi;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1077,12 +1098,13 @@ int mp_register_gsi(struct device *dev,
 	if (ioapic_renumber_irq)
 		gsi = ioapic_renumber_irq(ioapic, gsi);
 #endif
+	plat_gsi = remap_ioapic_gsi(ioapic, gsi);
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
-		return gsi;
+		return plat_gsi;
 	}
 
 	if (enable_update_mptable)
@@ -1091,9 +1113,9 @@ int mp_register_gsi(struct device *dev,
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, plat_gsi, &irq_attr);
 
-	return gsi;
+	return plat_gsi;
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -84,6 +84,7 @@ int nr_ioapic_registers[MAX_IO_APICS];
 /* I/O APIC entries */
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
+int boot_ioapic_idx;
 
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
@@ -1028,13 +1029,18 @@ static int pin_2_irq(int idx, int apic,
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
+			irq = remap_ioapic_gsi(apic, irq);
+		}
 		/*
                  * For MPS mode, so far only needed by ES7000 platform
                  */
@@ -1473,9 +1479,10 @@ static struct {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
-static void __init setup_IO_APIC_irqs(void)
+
+static void __init setup_IO_APIC_irqs(int apic_id)
 {
-	int apic_id = 0, pin, idx, irq;
+	int pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1483,14 +1490,6 @@ static void __init setup_IO_APIC_irqs(vo
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
-
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (idx == -1) {
@@ -1545,7 +1544,7 @@ static void __init setup_IO_APIC_irqs(vo
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
-void setup_IO_APIC_irq_extra(u32 gsi)
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
 {
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
@@ -1565,6 +1564,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
+	*pirq = irq;
 #ifdef CONFIG_SPARSE_IRQ
 	desc = irq_to_desc(irq);
 	if (desc)
@@ -1940,11 +1940,10 @@ __apicdebuginit(int) print_ICs(void)
 
 fs_initcall(print_ICs);
 
-
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
-void __init enable_IO_APIC(void)
+static void __init probe_ioapic_i8259(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -2001,7 +2000,12 @@ void __init enable_IO_APIC(void)
 	{
 		printk(KERN_WARNING "ExtINT in hardware and MP table differ\n");
 	}
+}
 
+void __init enable_IO_APIC(void)
+{
+	if (!nr_legacy_irqs)
+		return;
 	/*
 	 * Do not trust the IO-APIC being empty at bootup
 	 */
@@ -3126,7 +3130,6 @@ out:
 
 void __init setup_IO_APIC(void)
 {
-
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
@@ -3139,7 +3142,15 @@ void __init setup_IO_APIC(void)
 	x86_init.mpparse.setup_ioapic_ids();
 
 	sync_Arb_IDs();
-	setup_IO_APIC_irqs();
+	probe_ioapic_i8259();
+	boot_ioapic_idx = ioapic_i8259.apic;
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic && boot_ioapic_idx < 0)
+		boot_ioapic_idx = mp_find_ioapic(0);
+#endif
+	if (boot_ioapic_idx < 0)
+		boot_ioapic_idx = 0;
+	setup_IO_APIC_irqs(boot_ioapic_idx);
 	init_IO_APIC_traps();
 	if (nr_legacy_irqs)
 		check_timer();
