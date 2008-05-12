Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYELPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYELPZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbYELPYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:24:22 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:42091 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755538AbYELPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:24:19 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: complete move ACPI from mpparse.c
Date: Mon, 12 May 2008 19:24:41 +0400
Message-ID: <20080512152441.27570.68694.stgit@thinkpad>
In-Reply-To: <20080512152434.27570.7396.stgit@thinkpad>
References: <20080512152434.27570.7396.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/acpi/boot.c |  286 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/mpparse.c   |  299 -------------------------------------------
 2 files changed, 287 insertions(+), 298 deletions(-)


diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 06bfc49..394d742 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -844,6 +844,292 @@ static int __init acpi_parse_madt_lapic_entries(void)
 #endif				/* CONFIG_X86_LOCAL_APIC */
 
 #ifdef	CONFIG_X86_IO_APIC
+#define MP_ISA_BUS		0
+
+#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
+extern int es7000_plat;
+#endif
+
+static struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
+
+static int mp_find_ioapic(int gsi)
+{
+	int i = 0;
+
+	/* Find the IOAPIC that manages this GSI. */
+	for (i = 0; i < nr_ioapics; i++) {
+		if ((gsi >= mp_ioapic_routing[i].gsi_base)
+		    && (gsi <= mp_ioapic_routing[i].gsi_end))
+			return i;
+	}
+
+	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+	return -1;
+}
+
+static u8 __init uniq_ioapic_id(u8 id)
+{
+#ifdef CONFIG_X86_32
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return io_apic_get_unique_id(nr_ioapics, id);
+	else
+		return id;
+#else
+	int i;
+	DECLARE_BITMAP(used, 256);
+	bitmap_zero(used, 256);
+	for (i = 0; i < nr_ioapics; i++) {
+		struct mpc_config_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->mpc_apicid, used);
+	}
+	if (!test_bit(id, used))
+		return id;
+	return find_first_zero_bit(used, 256);
+#endif
+}
+
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+	int idx = 0;
+
+	if (bad_ioapic(address))
+		return;
+
+	idx = nr_ioapics;
+
+	mp_ioapics[idx].mpc_type = MP_IOAPIC;
+	mp_ioapics[idx].mpc_flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].mpc_apicaddr = address;
+
+	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	mp_ioapics[idx].mpc_apicid = uniq_ioapic_id(id);
+#ifdef CONFIG_X86_32
+	mp_ioapics[idx].mpc_apicver = io_apic_get_version(idx);
+#else
+	mp_ioapics[idx].mpc_apicver = 0;
+#endif
+	/*
+	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
+	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
+	 */
+	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mpc_apicid;
+	mp_ioapic_routing[idx].gsi_base = gsi_base;
+	mp_ioapic_routing[idx].gsi_end = gsi_base +
+	    io_apic_get_redir_entries(idx);
+
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].mpc_apicid,
+	       mp_ioapics[idx].mpc_apicver, mp_ioapics[idx].mpc_apicaddr,
+	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
+
+	nr_ioapics++;
+}
+
+void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
+{
+	struct mpc_config_intsrc intsrc;
+	int ioapic = -1;
+	int pin = -1;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return;
+	pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+
+	/*
+	 * TBD: This check is for faulty timer entries, where the override
+	 *      erroneously sets the trigger to level, resulting in a HUGE
+	 *      increase of timer interrupts!
+	 */
+	if ((bus_irq == 0) && (trigger == 3))
+		trigger = 1;
+
+	intsrc.mpc_type = MP_INTSRC;
+	intsrc.mpc_irqtype = mp_INT;
+	intsrc.mpc_irqflag = (trigger << 2) | polarity;
+	intsrc.mpc_srcbus = MP_ISA_BUS;
+	intsrc.mpc_srcbusirq = bus_irq;	/* IRQ */
+	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	/* APIC ID */
+	intsrc.mpc_dstirq = pin;	/* INTIN# */
+
+	MP_intsrc_info(&intsrc);
+}
+
+void __init mp_config_acpi_legacy_irqs(void)
+{
+	struct mpc_config_intsrc intsrc;
+	int i = 0;
+	int ioapic = -1;
+
+#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+	/*
+	 * Fabricate the legacy ISA bus (bus #31).
+	 */
+	mp_bus_id_to_type[MP_ISA_BUS] = MP_BUS_ISA;
+#endif
+	set_bit(MP_ISA_BUS, mp_bus_not_pci);
+	Dprintk("Bus #%d is ISA\n", MP_ISA_BUS);
+
+#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
+	/*
+	 * Older generations of ES7000 have no legacy identity mappings
+	 */
+	if (es7000_plat == 1)
+		return;
+#endif
+
+	/*
+	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
+	 */
+	ioapic = mp_find_ioapic(0);
+	if (ioapic < 0)
+		return;
+
+	intsrc.mpc_type = MP_INTSRC;
+	intsrc.mpc_irqflag = 0;	/* Conforming */
+	intsrc.mpc_srcbus = MP_ISA_BUS;
+#ifdef CONFIG_X86_IO_APIC
+	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;
+#endif
+	/*
+	 * Use the default configuration for the IRQs 0-15.  Unless
+	 * overridden by (MADT) interrupt source override entries.
+	 */
+	for (i = 0; i < 16; i++) {
+		int idx;
+
+		for (idx = 0; idx < mp_irq_entries; idx++) {
+			struct mpc_config_intsrc *irq = mp_irqs + idx;
+
+			/* Do we already have a mapping for this ISA IRQ? */
+			if (irq->mpc_srcbus == MP_ISA_BUS
+			    && irq->mpc_srcbusirq == i)
+				break;
+
+			/* Do we already have a mapping for this IOAPIC pin */
+			if ((irq->mpc_dstapic == intsrc.mpc_dstapic) &&
+			    (irq->mpc_dstirq == i))
+				break;
+		}
+
+		if (idx != mp_irq_entries) {
+			printk(KERN_DEBUG "ACPI: IRQ%d used by override.\n", i);
+			continue;	/* IRQ already used */
+		}
+
+		intsrc.mpc_irqtype = mp_INT;
+		intsrc.mpc_srcbusirq = i;	/* Identity mapped */
+		intsrc.mpc_dstirq = i;
+
+		MP_intsrc_info(&intsrc);
+	}
+}
+
+int mp_register_gsi(u32 gsi, int triggering, int polarity)
+{
+	int ioapic;
+	int ioapic_pin;
+#ifdef CONFIG_X86_32
+#define MAX_GSI_NUM	4096
+#define IRQ_COMPRESSION_START	64
+
+	static int pci_irq = IRQ_COMPRESSION_START;
+	/*
+	 * Mapping between Global System Interrupts, which
+	 * represent all possible interrupts, and IRQs
+	 * assigned to actual devices.
+	 */
+	static int gsi_to_irq[MAX_GSI_NUM];
+#else
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return gsi;
+#endif
+
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (acpi_gbl_FADT.sci_interrupt == gsi)
+		return gsi;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0) {
+		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
+		return gsi;
+	}
+
+	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+
+#ifdef CONFIG_X86_32
+	if (ioapic_renumber_irq)
+		gsi = ioapic_renumber_irq(ioapic, gsi);
+#endif
+
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
+	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
+		printk(KERN_ERR "Invalid reference to IOAPIC pin "
+		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+		       ioapic_pin);
+		return gsi;
+	}
+	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
+		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
+			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
+#ifdef CONFIG_X86_32
+		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
+#else
+		return gsi;
+#endif
+	}
+
+	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
+#ifdef CONFIG_X86_32
+	/*
+	 * For GSI >= 64, use IRQ compression
+	 */
+	if ((gsi >= IRQ_COMPRESSION_START)
+	    && (triggering == ACPI_LEVEL_SENSITIVE)) {
+		/*
+		 * For PCI devices assign IRQs in order, avoiding gaps
+		 * due to unused I/O APIC pins.
+		 */
+		int irq = gsi;
+		if (gsi < MAX_GSI_NUM) {
+			/*
+			 * Retain the VIA chipset work-around (gsi > 15), but
+			 * avoid a problem where the 8254 timer (IRQ0) is setup
+			 * via an override (so it's not on pin 0 of the ioapic),
+			 * and at the same time, the pin 0 interrupt is a PCI
+			 * type.  The gsi > 15 test could cause these two pins
+			 * to be shared as IRQ0, and they are not shareable.
+			 * So test for this condition, and if necessary, avoid
+			 * the pin collision.
+			 */
+			gsi = pci_irq++;
+			/*
+			 * Don't assign IRQ used by ACPI SCI
+			 */
+			if (gsi == acpi_gbl_FADT.sci_interrupt)
+				gsi = pci_irq++;
+			gsi_to_irq[irq] = gsi;
+		} else {
+			printk(KERN_ERR "GSI %u is too high\n", gsi);
+			return gsi;
+		}
+	}
+#endif
+	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
+				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
+				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	return gsi;
+}
+
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ff13423..d05b70c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -1,5 +1,5 @@
 /*
-2 *	Intel Multiprocessor Specification 1.1 and 1.4
+ *	Intel Multiprocessor Specification 1.1 and 1.4
  *	compliant MP-table parsing routines.
  *
  *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
@@ -788,300 +788,3 @@ void __init find_smp_config(void)
 {
 	__find_smp_config(1);
 }
-
-/* --------------------------------------------------------------------------
-                            ACPI-based MP Configuration
-   -------------------------------------------------------------------------- */
-
-#ifdef CONFIG_ACPI
-
-#ifdef	CONFIG_X86_IO_APIC
-
-#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
-extern int es7000_plat;
-#endif
-
-#define MP_ISA_BUS		0
-
-static struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
-
-static int mp_find_ioapic(int gsi)
-{
-	int i = 0;
-
-	/* Find the IOAPIC that manages this GSI. */
-	for (i = 0; i < nr_ioapics; i++) {
-		if ((gsi >= mp_ioapic_routing[i].gsi_base)
-		    && (gsi <= mp_ioapic_routing[i].gsi_end))
-			return i;
-	}
-
-	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
-	return -1;
-}
-
-static u8 __init uniq_ioapic_id(u8 id)
-{
-#ifdef CONFIG_X86_32
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return io_apic_get_unique_id(nr_ioapics, id);
-	else
-		return id;
-#else
-	int i;
-	DECLARE_BITMAP(used, 256);
-	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_config_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->mpc_apicid, used);
-	}
-	if (!test_bit(id, used))
-		return id;
-	return find_first_zero_bit(used, 256);
-#endif
-}
-
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
-{
-	int idx = 0;
-
-	if (bad_ioapic(address))
-		return;
-
-	idx = nr_ioapics;
-
-	mp_ioapics[idx].mpc_type = MP_IOAPIC;
-	mp_ioapics[idx].mpc_flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].mpc_apicaddr = address;
-
-	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mpc_apicid = uniq_ioapic_id(id);
-#ifdef CONFIG_X86_32
-	mp_ioapics[idx].mpc_apicver = io_apic_get_version(idx);
-#else
-	mp_ioapics[idx].mpc_apicver = 0;
-#endif
-	/*
-	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
-	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
-	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mpc_apicid;
-	mp_ioapic_routing[idx].gsi_base = gsi_base;
-	mp_ioapic_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
-
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].mpc_apicid,
-	       mp_ioapics[idx].mpc_apicver, mp_ioapics[idx].mpc_apicaddr,
-	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
-
-	nr_ioapics++;
-}
-
-void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
-{
-	struct mpc_config_intsrc intsrc;
-	int ioapic = -1;
-	int pin = -1;
-
-	/*
-	 * Convert 'gsi' to 'ioapic.pin'.
-	 */
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return;
-	pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
-
-	/*
-	 * TBD: This check is for faulty timer entries, where the override
-	 *      erroneously sets the trigger to level, resulting in a HUGE
-	 *      increase of timer interrupts!
-	 */
-	if ((bus_irq == 0) && (trigger == 3))
-		trigger = 1;
-
-	intsrc.mpc_type = MP_INTSRC;
-	intsrc.mpc_irqtype = mp_INT;
-	intsrc.mpc_irqflag = (trigger << 2) | polarity;
-	intsrc.mpc_srcbus = MP_ISA_BUS;
-	intsrc.mpc_srcbusirq = bus_irq;	/* IRQ */
-	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	/* APIC ID */
-	intsrc.mpc_dstirq = pin;	/* INTIN# */
-
-	MP_intsrc_info(&intsrc);
-}
-
-void __init mp_config_acpi_legacy_irqs(void)
-{
-	struct mpc_config_intsrc intsrc;
-	int i = 0;
-	int ioapic = -1;
-
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
-	/*
-	 * Fabricate the legacy ISA bus (bus #31).
-	 */
-	mp_bus_id_to_type[MP_ISA_BUS] = MP_BUS_ISA;
-#endif
-	set_bit(MP_ISA_BUS, mp_bus_not_pci);
-	Dprintk("Bus #%d is ISA\n", MP_ISA_BUS);
-
-#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
-	/*
-	 * Older generations of ES7000 have no legacy identity mappings
-	 */
-	if (es7000_plat == 1)
-		return;
-#endif
-
-	/*
-	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
-	 */
-	ioapic = mp_find_ioapic(0);
-	if (ioapic < 0)
-		return;
-
-	intsrc.mpc_type = MP_INTSRC;
-	intsrc.mpc_irqflag = 0;	/* Conforming */
-	intsrc.mpc_srcbus = MP_ISA_BUS;
-#ifdef CONFIG_X86_IO_APIC
-	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;
-#endif
-	/*
-	 * Use the default configuration for the IRQs 0-15.  Unless
-	 * overridden by (MADT) interrupt source override entries.
-	 */
-	for (i = 0; i < 16; i++) {
-		int idx;
-
-		for (idx = 0; idx < mp_irq_entries; idx++) {
-			struct mpc_config_intsrc *irq = mp_irqs + idx;
-
-			/* Do we already have a mapping for this ISA IRQ? */
-			if (irq->mpc_srcbus == MP_ISA_BUS
-			    && irq->mpc_srcbusirq == i)
-				break;
-
-			/* Do we already have a mapping for this IOAPIC pin */
-			if ((irq->mpc_dstapic == intsrc.mpc_dstapic) &&
-			    (irq->mpc_dstirq == i))
-				break;
-		}
-
-		if (idx != mp_irq_entries) {
-			printk(KERN_DEBUG "ACPI: IRQ%d used by override.\n", i);
-			continue;	/* IRQ already used */
-		}
-
-		intsrc.mpc_irqtype = mp_INT;
-		intsrc.mpc_srcbusirq = i;	/* Identity mapped */
-		intsrc.mpc_dstirq = i;
-
-		MP_intsrc_info(&intsrc);
-	}
-}
-
-int mp_register_gsi(u32 gsi, int triggering, int polarity)
-{
-	int ioapic;
-	int ioapic_pin;
-#ifdef CONFIG_X86_32
-#define MAX_GSI_NUM	4096
-#define IRQ_COMPRESSION_START	64
-
-	static int pci_irq = IRQ_COMPRESSION_START;
-	/*
-	 * Mapping between Global System Interrupts, which
-	 * represent all possible interrupts, and IRQs
-	 * assigned to actual devices.
-	 */
-	static int gsi_to_irq[MAX_GSI_NUM];
-#else
-
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return gsi;
-#endif
-
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
-	}
-
-	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
-
-#ifdef CONFIG_X86_32
-	if (ioapic_renumber_irq)
-		gsi = ioapic_renumber_irq(ioapic, gsi);
-#endif
-
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
-		       ioapic_pin);
-		return gsi;
-	}
-	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
-			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-#ifdef CONFIG_X86_32
-		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
-#else
-		return gsi;
-#endif
-	}
-
-	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
-#ifdef CONFIG_X86_32
-	/*
-	 * For GSI >= 64, use IRQ compression
-	 */
-	if ((gsi >= IRQ_COMPRESSION_START)
-	    && (triggering == ACPI_LEVEL_SENSITIVE)) {
-		/*
-		 * For PCI devices assign IRQs in order, avoiding gaps
-		 * due to unused I/O APIC pins.
-		 */
-		int irq = gsi;
-		if (gsi < MAX_GSI_NUM) {
-			/*
-			 * Retain the VIA chipset work-around (gsi > 15), but
-			 * avoid a problem where the 8254 timer (IRQ0) is setup
-			 * via an override (so it's not on pin 0 of the ioapic),
-			 * and at the same time, the pin 0 interrupt is a PCI
-			 * type.  The gsi > 15 test could cause these two pins
-			 * to be shared as IRQ0, and they are not shareable.
-			 * So test for this condition, and if necessary, avoid
-			 * the pin collision.
-			 */
-			gsi = pci_irq++;
-			/*
-			 * Don't assign IRQ used by ACPI SCI
-			 */
-			if (gsi == acpi_gbl_FADT.sci_interrupt)
-				gsi = pci_irq++;
-			gsi_to_irq[irq] = gsi;
-		} else {
-			printk(KERN_ERR "GSI %u is too high\n", gsi);
-			return gsi;
-		}
-	}
-#endif
-	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
-				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
-				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	return gsi;
-}
-
-#endif /* CONFIG_X86_IO_APIC */
-#endif /* CONFIG_ACPI */

