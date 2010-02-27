Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968264Ab0B0NAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:00:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:47792 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968214Ab0B0NAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:00:14 -0500
Date: Sat, 27 Feb 2010 12:57:34 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, ebiederm@xmission.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, ebiederm@xmission.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, trenn@suse.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B882182.4030205@kernel.org>
References: <4B882182.4030205@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
Message-ID: <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
Git-Commit-ID: 519d637a93116ffbcd50e9e3f2591f41584f372c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:57:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  519d637a93116ffbcd50e9e3f2591f41584f372c
Gitweb:     http://git.kernel.org/tip/519d637a93116ffbcd50e9e3f2591f41584f372c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 26 Feb 2010 11:31:14 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Feb 2010 12:54:17 +0100

x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()

Iranna D Ankad found (and bisected) that IBM x3950 will have
boot problems after:

 |
 | commit b9c61b70075c87a8612624736faf4a2de5b1ed30
 |
 |    x86/pci: update pirq_enable_irq() to setup io apic routing
 |

As explained in the previous patch ("x86: Fix out of order gsi - have
the right boot_ioapic_idx"), try to remap those gsis, we need to
seperate boot_ioapic_id detection out of enable_IO_APIC and call
them early.

This patch adds remap_ioapic_gsi() and fixes the regression.

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: len.brown@intel.com
Cc: <stable@kernel.org> # .33.x
LKML-Reference: <4B882182.4030205@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    2 +-
 arch/x86/include/asm/mpspec.h  |    2 +
 arch/x86/kernel/acpi/boot.c    |   63 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++-----
 drivers/pnp/pnpacpi/rsparser.c |    8 +++++
 5 files changed, 80 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b16c075..98458c7 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -161,7 +161,7 @@ extern int io_apic_get_redir_entries(int ioapic);
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
-void setup_IO_APIC_irq_extra(u32 gsi);
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *irq);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index d8bf23a..3642461 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -105,6 +105,8 @@ extern void mp_config_acpi_legacy_irqs(void);
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
+int remap_ioapic_gsi_to_irq(int ioapic, u32 gsi);
+int remap_ioapic_irq_to_gsi(int irq);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_find_ioapic(int gsi);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 5c96b75..70c4057 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -310,7 +310,8 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init
+acpi_sci_ioapic_setup(u8 bus_irq, u32 gsi, u16 polarity, u16 trigger)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -330,7 +331,7 @@ static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
 	 * If GSI is < 16, this will update its flags,
 	 * else it will create a new mp_irqs[] entry.
 	 */
-	mp_override_legacy_irq(gsi, polarity, trigger, gsi);
+	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
 	 * stash over-ride to indicate we've been here
@@ -354,7 +355,8 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 	acpi_table_print_madt_entry(header);
 
 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
-		acpi_sci_ioapic_setup(intsrc->global_irq,
+		acpi_sci_ioapic_setup(intsrc->source_irq,
+				      intsrc->global_irq,
 				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
 				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
 		return 0;
@@ -449,7 +451,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
+		setup_IO_APIC_irq_extra(gsi, irq);
 #endif
 
 	return 0;
@@ -1029,11 +1031,54 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
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
@@ -1054,12 +1099,13 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
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
@@ -1068,9 +1114,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, irq, &irq_attr);
 
-	return gsi;
+	return irq;
 }
 
 /*
@@ -1128,7 +1174,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * pretend we got one so we can set the SCI flags.
 	 */
 	if (!acpi_sci_override_gsi)
-		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
+		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt,
+					 acpi_gbl_FADT.sci_interrupt, 0, 0);
 
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53533a0..13c7975 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1029,13 +1029,18 @@ static int pin_2_irq(int idx, int apic, int pin)
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
@@ -1538,7 +1543,7 @@ static void __init setup_IO_APIC_irqs(int apic_id)
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
-void setup_IO_APIC_irq_extra(u32 gsi)
+void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
 {
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
@@ -1558,6 +1563,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
+	*pirq = irq;
 #ifdef CONFIG_SPARSE_IRQ
 	desc = irq_to_desc(irq);
 	if (desc)
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 5702b2c..a596888 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -123,6 +123,14 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
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
