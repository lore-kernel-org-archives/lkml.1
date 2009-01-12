Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZALMuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZALMuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZALMuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:50:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:51889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZALMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:50:22 -0500
Subject: [PULL -tip] x86: replacing mp_config_X with mpc_X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, paul.s.diefenbaugh@intel.com,
       jun.nakajima@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       astarikovskiy@suse.de, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 18:17:58 +0530
Message-Id: <1231764478.10461.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Please pull these cleanup patches.

The following changes since commit 5b47b0188e1da604f9efad2bac96213877e3ddca:
  Ingo Molnar (1):
        Merge branch 'sched/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (2):
      x86: replacing mp_config_ioapic with mpc_ioapic
      x86: replacing mp_config_intsrc with mpc_intsrc

 arch/x86/include/asm/io_apic.h |   26 +--------
 arch/x86/kernel/acpi/boot.c    |   96 ++++++++++++++++-----------------
 arch/x86/kernel/io_apic.c      |  118 ++++++++++++++++++++--------------------
 arch/x86/kernel/mpparse.c      |   80 ++++++++++++++--------------
 4 files changed, 147 insertions(+), 173 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7a1f44a..08ec793 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -114,38 +114,16 @@ struct IR_IO_APIC_route_entry {
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
 
-/*
- * MP-BIOS irq configuration table structures:
- */
-
 #define MP_MAX_IOAPIC_PIN 127
 
-struct mp_config_ioapic {
-	unsigned long mp_apicaddr;
-	unsigned int mp_apicid;
-	unsigned char mp_type;
-	unsigned char mp_apicver;
-	unsigned char mp_flags;
-};
-
-struct mp_config_intsrc {
-	unsigned int mp_dstapic;
-	unsigned char mp_type;
-	unsigned char mp_irqtype;
-	unsigned short mp_irqflag;
-	unsigned char mp_srcbus;
-	unsigned char mp_srcbusirq;
-	unsigned char mp_dstirq;
-};
-
 /* I/O APIC entries */
-extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+extern struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
 
 /* MP IRQ source entries */
-extern struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* non-0 if default (table-less) MP configuration */
 extern int mpc_default_type;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..4cb5964 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -912,8 +912,8 @@ static u8 __init uniq_ioapic_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mp_config_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->mp_apicid, used);
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -945,47 +945,47 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].mp_type = MP_IOAPIC;
-	mp_ioapics[idx].mp_flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].mp_apicaddr = address;
+	mp_ioapics[idx].type = MP_IOAPIC;
+	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mp_apicid = uniq_ioapic_id(id);
+	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
 #ifdef CONFIG_X86_32
-	mp_ioapics[idx].mp_apicver = io_apic_get_version(idx);
+	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 #else
-	mp_ioapics[idx].mp_apicver = 0;
+	mp_ioapics[idx].apicver = 0;
 #endif
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mp_apicid;
+	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%lx, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].mp_apicid,
-	       mp_ioapics[idx].mp_apicver, mp_ioapics[idx].mp_apicaddr,
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
+	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
 	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
 
 	nr_ioapics++;
 }
 
-static void assign_to_mp_irq(struct mp_config_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+static void assign_to_mp_irq(struct mpc_intsrc *m,
+				    struct mpc_intsrc *mp_irq)
 {
-	memcpy(mp_irq, m, sizeof(struct mp_config_intsrc));
+	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static int mp_irq_cmp(struct mp_config_intsrc *mp_irq,
-				struct mp_config_intsrc *m)
+static int mp_irq_cmp(struct mpc_intsrc *mp_irq,
+				struct mpc_intsrc *m)
 {
-	return memcmp(mp_irq, m, sizeof(struct mp_config_intsrc));
+	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static void save_mp_irq(struct mp_config_intsrc *m)
+static void save_mp_irq(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -1003,7 +1003,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
 	int ioapic;
 	int pin;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -1021,13 +1021,13 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	if ((bus_irq == 0) && (trigger == 3))
 		trigger = 1;
 
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (trigger << 2) | polarity;
-	mp_irq.mp_srcbus = MP_ISA_BUS;
-	mp_irq.mp_srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.mp_dstapic = mp_ioapics[ioapic].mp_apicid; /* APIC ID */
-	mp_irq.mp_dstirq = pin;	/* INTIN# */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger << 2) | polarity;
+	mp_irq.srcbus = MP_ISA_BUS;
+	mp_irq.srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
+	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
 }
@@ -1037,7 +1037,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	int ioapic;
 	unsigned int dstapic;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 	/*
@@ -1062,7 +1062,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	ioapic = mp_find_ioapic(0);
 	if (ioapic < 0)
 		return;
-	dstapic = mp_ioapics[ioapic].mp_apicid;
+	dstapic = mp_ioapics[ioapic].apicid;
 
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
@@ -1072,16 +1072,14 @@ void __init mp_config_acpi_legacy_irqs(void)
 		int idx;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
-			struct mp_config_intsrc *irq = mp_irqs + idx;
+			struct mpc_intsrc *irq = mp_irqs + idx;
 
 			/* Do we already have a mapping for this ISA IRQ? */
-			if (irq->mp_srcbus == MP_ISA_BUS
-			    && irq->mp_srcbusirq == i)
+			if (irq->srcbus == MP_ISA_BUS && irq->srcbusirq == i)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->mp_dstapic == dstapic &&
-			    irq->mp_dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == i)
 				break;
 		}
 
@@ -1090,13 +1088,13 @@ void __init mp_config_acpi_legacy_irqs(void)
 			continue;	/* IRQ already used */
 		}
 
-		mp_irq.mp_type = MP_INTSRC;
-		mp_irq.mp_irqflag = 0;	/* Conforming */
-		mp_irq.mp_srcbus = MP_ISA_BUS;
-		mp_irq.mp_dstapic = dstapic;
-		mp_irq.mp_irqtype = mp_INT;
-		mp_irq.mp_srcbusirq = i; /* Identity mapped */
-		mp_irq.mp_dstirq = i;
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqflag = 0;	/* Conforming */
+		mp_irq.srcbus = MP_ISA_BUS;
+		mp_irq.dstapic = dstapic;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.srcbusirq = i; /* Identity mapped */
+		mp_irq.dstirq = i;
 
 		save_mp_irq(&mp_irq);
 	}
@@ -1207,22 +1205,22 @@ int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 			u32 gsi, int triggering, int polarity)
 {
 #ifdef CONFIG_X86_MPPARSE
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 	int ioapic;
 
 	if (!acpi_ioapic)
 		return 0;
 
 	/* print the entry should happen on mptable identically */
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.mp_srcbus = number;
-	mp_irq.mp_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.mp_dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.mp_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
 
 	save_mp_irq(&mp_irq);
 #endif
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 99b5d8a..4deae7f 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -83,11 +83,11 @@ static DEFINE_SPINLOCK(vector_lock);
 int nr_ioapic_registers[MAX_IO_APICS];
 
 /* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* # of MP IRQ source entries */
 int mp_irq_entries;
@@ -387,7 +387,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
+		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
 }
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -945,10 +945,10 @@ static int find_irq_entry(int apic, int pin, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == type &&
-		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mp_dstirq == pin)
+		if (mp_irqs[i].irqtype == type &&
+		    (mp_irqs[i].dstapic == mp_ioapics[apic].apicid ||
+		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
+		    mp_irqs[i].dstirq == pin)
 			return i;
 
 	return -1;
@@ -962,13 +962,13 @@ static int __init find_isa_irq_pin(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 
-			return mp_irqs[i].mp_dstirq;
+			return mp_irqs[i].dstirq;
 	}
 	return -1;
 }
@@ -978,17 +978,17 @@ static int __init find_isa_irq_apic(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 			break;
 	}
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic)
 				return apic;
 		}
 	}
@@ -1013,23 +1013,23 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
-			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mp_irqtype &&
+		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
+		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
 
-			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
+			if (pin == (mp_irqs[i].srcbusirq & 3))
 				return irq;
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -1072,7 +1072,7 @@ static int EISA_ELCR(unsigned int irq)
  * EISA conforming in the MP table, that means its trigger type must
  * be read in from the ELCR */
 
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].srcbusirq))
 #define default_EISA_polarity(idx)	default_ISA_polarity(idx)
 
 /* PCI interrupts are always polarity one level triggered,
@@ -1089,13 +1089,13 @@ static int EISA_ELCR(unsigned int irq)
 
 static int MPBIOS_polarity(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mp_irqflag & 3)
+	switch (mp_irqs[idx].irqflag & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent polarity */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1131,13 +1131,13 @@ static int MPBIOS_polarity(int idx)
 
 static int MPBIOS_trigger(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int trigger;
 
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].irqflag>>2) & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1215,16 +1215,16 @@ int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
-	if (mp_irqs[idx].mp_dstirq != pin)
+	if (mp_irqs[idx].dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
-		irq = mp_irqs[idx].mp_srcbusirq;
+		irq = mp_irqs[idx].srcbusirq;
 	} else {
 		/*
 		 * PCI IRQs are mapped in order
@@ -1567,14 +1567,14 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
+		    apic, mp_ioapics[apic].apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
+	if (setup_ioapic_entry(mp_ioapics[apic].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic].mp_apicid, pin);
+		       mp_ioapics[apic].apicid, pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1605,12 +1605,10 @@ static void __init setup_IO_APIC_irqs(void)
 					notcon = 1;
 					apic_printk(APIC_VERBOSE,
 						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				} else
 					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				continue;
 			}
 			if (notcon) {
@@ -1700,7 +1698,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1720,7 +1718,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -2122,14 +2120,14 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic].mp_apicid;
+		old_id = mp_ioapics[apic].apicid;
 
-		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
+		if (mp_ioapics[apic].apicid >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
+			mp_ioapics[apic].apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -2138,9 +2136,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].mp_apicid)) {
+					mp_ioapics[apic].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2149,13 +2147,13 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].mp_apicid = i;
+			mp_ioapics[apic].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic].mp_apicid);
+					mp_ioapics[apic].apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2164,11 +2162,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic].mp_apicid)
+		if (old_id != mp_ioapics[apic].apicid)
 			for (i = 0; i < mp_irq_entries; i++)
-				if (mp_irqs[i].mp_dstapic == old_id)
-					mp_irqs[i].mp_dstapic
-						= mp_ioapics[apic].mp_apicid;
+				if (mp_irqs[i].dstapic == old_id)
+					mp_irqs[i].dstapic
+						= mp_ioapics[apic].apicid;
 
 		/*
 		 * Read the right value from the MPC table and
@@ -2176,9 +2174,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].mp_apicid);
+			mp_ioapics[apic].apicid);
 
-		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
+		reg_00.bits.ID = mp_ioapics[apic].apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic, 0, reg_00.raw);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2189,7 +2187,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
+		if (reg_00.bits.ID != mp_ioapics[apic].apicid)
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -3118,8 +3116,8 @@ static int ioapic_resume(struct sys_device *dev)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
+	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
+		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -3985,8 +3983,8 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 		return -1;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == mp_INT &&
-		    mp_irqs[i].mp_srcbusirq == bus_irq)
+		if (mp_irqs[i].irqtype == mp_INT &&
+		    mp_irqs[i].srcbusirq == bus_irq)
 			break;
 	if (i >= mp_irq_entries)
 		return -1;
@@ -4101,7 +4099,7 @@ void __init ioapic_init_mappings(void)
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].mp_apicaddr;
+			ioapic_phys = mp_ioapics[i].apicaddr;
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
 				printk(KERN_ERR
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 79dae60..fa6bb26 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -144,11 +144,11 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	if (bad_ioapic(m->apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics].mp_apicaddr = m->apicaddr;
-	mp_ioapics[nr_ioapics].mp_apicid = m->apicid;
-	mp_ioapics[nr_ioapics].mp_type = m->type;
-	mp_ioapics[nr_ioapics].mp_apicver = m->apicver;
-	mp_ioapics[nr_ioapics].mp_flags = m->flags;
+	mp_ioapics[nr_ioapics].apicaddr = m->apicaddr;
+	mp_ioapics[nr_ioapics].apicid = m->apicid;
+	mp_ioapics[nr_ioapics].type = m->type;
+	mp_ioapics[nr_ioapics].apicver = m->apicver;
+	mp_ioapics[nr_ioapics].flags = m->flags;
 	nr_ioapics++;
 }
 
@@ -160,55 +160,55 @@ static void print_MP_intsrc_info(struct mpc_intsrc *m)
 		m->srcbusirq, m->dstapic, m->dstirq);
 }
 
-static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
+static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
-		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
-		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
+		mp_irq->irqtype, mp_irq->irqflag & 3,
+		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
+		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+				    struct mpc_intsrc *mp_irq)
 {
-	mp_irq->mp_dstapic = m->dstapic;
-	mp_irq->mp_type = m->type;
-	mp_irq->mp_irqtype = m->irqtype;
-	mp_irq->mp_irqflag = m->irqflag;
-	mp_irq->mp_srcbus = m->srcbus;
-	mp_irq->mp_srcbusirq = m->srcbusirq;
-	mp_irq->mp_dstirq = m->dstirq;
+	mp_irq->dstapic = m->dstapic;
+	mp_irq->type = m->type;
+	mp_irq->irqtype = m->irqtype;
+	mp_irq->irqflag = m->irqflag;
+	mp_irq->srcbus = m->srcbus;
+	mp_irq->srcbusirq = m->srcbusirq;
+	mp_irq->dstirq = m->dstirq;
 }
 
-static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
+static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	m->dstapic = mp_irq->mp_dstapic;
-	m->type = mp_irq->mp_type;
-	m->irqtype = mp_irq->mp_irqtype;
-	m->irqflag = mp_irq->mp_irqflag;
-	m->srcbus = mp_irq->mp_srcbus;
-	m->srcbusirq = mp_irq->mp_srcbusirq;
-	m->dstirq = mp_irq->mp_dstirq;
+	m->dstapic = mp_irq->dstapic;
+	m->type = mp_irq->type;
+	m->irqtype = mp_irq->irqtype;
+	m->irqflag = mp_irq->irqflag;
+	m->srcbus = mp_irq->srcbus;
+	m->srcbusirq = mp_irq->srcbusirq;
+	m->dstirq = mp_irq->dstirq;
 }
 
-static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
+static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	if (mp_irq->mp_dstapic != m->dstapic)
+	if (mp_irq->dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->mp_type != m->type)
+	if (mp_irq->type != m->type)
 		return 2;
-	if (mp_irq->mp_irqtype != m->irqtype)
+	if (mp_irq->irqtype != m->irqtype)
 		return 3;
-	if (mp_irq->mp_irqflag != m->irqflag)
+	if (mp_irq->irqflag != m->irqflag)
 		return 4;
-	if (mp_irq->mp_srcbus != m->srcbus)
+	if (mp_irq->srcbus != m->srcbus)
 		return 5;
-	if (mp_irq->mp_srcbusirq != m->srcbusirq)
+	if (mp_irq->srcbusirq != m->srcbusirq)
 		return 6;
-	if (mp_irq->mp_dstirq != m->dstirq)
+	if (mp_irq->dstirq != m->dstirq)
 		return 7;
 
 	return 0;
@@ -417,7 +417,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
 	intsrc.srcbus = 0;
-	intsrc.dstapic = mp_ioapics[0].mp_apicid;
+	intsrc.dstapic = mp_ioapics[0].apicid;
 
 	intsrc.irqtype = mp_INT;
 
@@ -809,15 +809,15 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 	/* not legacy */
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
-		if (mp_irqs[i].mp_srcbus != m->srcbus)
+		if (mp_irqs[i].srcbus != m->srcbus)
 			continue;
-		if (mp_irqs[i].mp_srcbusirq != m->srcbusirq)
+		if (mp_irqs[i].srcbusirq != m->srcbusirq)
 			continue;
 		if (irq_used[i]) {
 			/* already claimed */
@@ -922,10 +922,10 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		if (irq_used[i])
 			continue;
 
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
 		if (nr_m_spare > 0) {


