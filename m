Return-Path: <linux-kernel-owner+w=401wt.eu-S1763187AbYENPDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763187AbYENPDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762720AbYENPCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:02:34 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51232 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031AbYENPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:02:32 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: make struct config_ioapic not MPspec specific
Date: Wed, 14 May 2008 19:03:10 +0400
Message-ID: <20080514150310.24443.72809.stgit@thinkpad>
In-Reply-To: <20080514150251.24443.5516.stgit@thinkpad>
References: <20080514150251.24443.5516.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/acpi/boot.c  |   28 +++++++++++------------
 arch/x86/kernel/apic_32.c    |    2 +-
 arch/x86/kernel/io_apic_32.c |   52 +++++++++++++++++++++---------------------
 arch/x86/kernel/io_apic_64.c |   26 +++++++++++----------
 arch/x86/kernel/mpparse.c    |    8 +++++-
 include/asm-x86/io_apic.h    |   10 +++++++-
 6 files changed, 69 insertions(+), 57 deletions(-)


diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a834a8e..4652475 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -885,8 +885,8 @@ static u8 __init uniq_ioapic_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_config_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->mpc_apicid, used);
+		struct mp_config_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->mp_apicid, used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -918,29 +918,29 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].mpc_type = MP_IOAPIC;
-	mp_ioapics[idx].mpc_flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].mpc_apicaddr = address;
+	mp_ioapics[idx].mp_type = MP_IOAPIC;
+	mp_ioapics[idx].mp_flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].mp_apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mpc_apicid = uniq_ioapic_id(id);
+	mp_ioapics[idx].mp_apicid = uniq_ioapic_id(id);
 #ifdef CONFIG_X86_32
-	mp_ioapics[idx].mpc_apicver = io_apic_get_version(idx);
+	mp_ioapics[idx].mp_apicver = io_apic_get_version(idx);
 #else
-	mp_ioapics[idx].mpc_apicver = 0;
+	mp_ioapics[idx].mp_apicver = 0;
 #endif
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mpc_apicid;
+	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mp_apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].mpc_apicid,
-	       mp_ioapics[idx].mpc_apicver, mp_ioapics[idx].mpc_apicaddr,
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%lx, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].mp_apicid,
+	       mp_ioapics[idx].mp_apicver, mp_ioapics[idx].mp_apicaddr,
 	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
 
 	nr_ioapics++;
@@ -973,7 +973,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irqs[mp_irq_entries].mpc_srcbus = MP_ISA_BUS;
 	mp_irqs[mp_irq_entries].mpc_srcbusirq = bus_irq;	/* IRQ */
 	mp_irqs[mp_irq_entries].mpc_dstapic =
-			mp_ioapics[ioapic].mpc_apicid;	/* APIC ID */
+			mp_ioapics[ioapic].mp_apicid;	/* APIC ID */
 	mp_irqs[mp_irq_entries].mpc_dstirq = pin;	/* INTIN# */
 
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
@@ -1014,7 +1014,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	mp_irqs[mp_irq_entries].mpc_irqflag = 0;	/* Conforming */
 	mp_irqs[mp_irq_entries].mpc_srcbus = MP_ISA_BUS;
 #ifdef CONFIG_X86_IO_APIC
-	mp_irqs[mp_irq_entries].mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;
+	mp_irqs[mp_irq_entries].mpc_dstapic = mp_ioapics[ioapic].mp_apicid;
 #endif
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d5767cb..0bd7c9c 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1206,7 +1206,7 @@ void __init init_apic_mappings(void)
 
 		for (i = 0; i < nr_ioapics; i++) {
 			if (smp_found_config) {
-				ioapic_phys = mp_ioapics[i].mpc_apicaddr;
+				ioapic_phys = mp_ioapics[i].mp_apicaddr;
 				if (!ioapic_phys) {
 					printk(KERN_ERR
 					       "WARNING: bogus zero IO-APIC "
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 76769cc..b7b231c 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -72,7 +72,7 @@ int sis_apic_bug = -1;
 int nr_ioapic_registers[MAX_IO_APICS];
 
 /* I/O APIC entries */
-struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
+struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
@@ -110,7 +110,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mpc_apicaddr & ~PAGE_MASK);
+		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
 }
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -802,7 +802,7 @@ static int find_irq_entry(int apic, int pin, int type)
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].mpc_irqtype == type &&
-		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mpc_apicid ||
+		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mp_apicid ||
 		     mp_irqs[i].mpc_dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].mpc_dstirq == pin)
 			return i;
@@ -844,7 +844,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mpc_apicid == mp_irqs[i].mpc_dstapic)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic)
 				return apic;
 		}
 	}
@@ -872,7 +872,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		int lbus = mp_irqs[i].mpc_srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mpc_apicid == mp_irqs[i].mpc_dstapic ||
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic ||
 			    mp_irqs[i].mpc_dstapic == MP_APIC_ALL)
 				break;
 
@@ -1250,12 +1250,12 @@ static void __init setup_IO_APIC_irqs(void)
 			if (first_notcon) {
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
 						" IO-APIC (apicid-pin) %d-%d",
-						mp_ioapics[apic].mpc_apicid,
+						mp_ioapics[apic].mp_apicid,
 						pin);
 				first_notcon = 0;
 			} else
 				apic_printk(APIC_VERBOSE, ", %d-%d",
-					mp_ioapics[apic].mpc_apicid, pin);
+					mp_ioapics[apic].mp_apicid, pin);
 			continue;
 		}
 
@@ -1357,7 +1357,7 @@ void __init print_IO_APIC(void)
  	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mpc_apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1376,7 +1376,7 @@ void __init print_IO_APIC(void)
 		reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mpc_apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1749,14 +1749,14 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		
-		old_id = mp_ioapics[apic].mpc_apicid;
+		old_id = mp_ioapics[apic].mp_apicid;
 
-		if (mp_ioapics[apic].mpc_apicid >= get_physical_broadcast()) {
+		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].mpc_apicid);
+				apic, mp_ioapics[apic].mp_apicid);
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic].mpc_apicid = reg_00.bits.ID;
+			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -1765,9 +1765,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].mpc_apicid)) {
+					mp_ioapics[apic].mp_apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].mpc_apicid);
+				apic, mp_ioapics[apic].mp_apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -1776,13 +1776,13 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].mpc_apicid = i;
+			mp_ioapics[apic].mp_apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].mpc_apicid);
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic].mpc_apicid);
+					mp_ioapics[apic].mp_apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -1791,11 +1791,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic].mpc_apicid)
+		if (old_id != mp_ioapics[apic].mp_apicid)
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].mpc_dstapic == old_id)
 					mp_irqs[i].mpc_dstapic
-						= mp_ioapics[apic].mpc_apicid;
+						= mp_ioapics[apic].mp_apicid;
 
 		/*
 		 * Read the right value from the MPC table and
@@ -1803,9 +1803,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	 	 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].mpc_apicid);
+			mp_ioapics[apic].mp_apicid);
 
-		reg_00.bits.ID = mp_ioapics[apic].mpc_apicid;
+		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic, 0, reg_00.raw);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -1816,7 +1816,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].mpc_apicid)
+		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2355,8 +2355,8 @@ static int ioapic_resume(struct sys_device *dev)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mpc_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mpc_apicid;
+	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
+		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2789,7 +2789,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int a
 
 	apic_printk(APIC_DEBUG, KERN_DEBUG "IOAPIC[%d]: Set PCI routing entry "
 		"(%d-%d -> 0x%x -> IRQ %d Mode:%i Active:%i)\n", ioapic,
-		mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
+		mp_ioapics[ioapic].mp_apicid, pin, entry.vector, irq,
 		edge_level, active_high_low);
 
 	ioapic_register_intr(irq, entry.vector, edge_level);
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 0081cbd..371ec65 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -108,7 +108,7 @@ DEFINE_SPINLOCK(vector_lock);
 int nr_ioapic_registers[MAX_IO_APICS];
 
 /* I/O APIC entries */
-struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
+struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
@@ -144,7 +144,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mpc_apicaddr & ~PAGE_MASK);
+		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
 }
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -458,7 +458,7 @@ static int find_irq_entry(int apic, int pin, int type)
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].mpc_irqtype == type &&
-		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mpc_apicid ||
+		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mp_apicid ||
 		     mp_irqs[i].mpc_dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].mpc_dstirq == pin)
 			return i;
@@ -500,7 +500,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mpc_apicid == mp_irqs[i].mpc_dstapic)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic)
 				return apic;
 		}
 	}
@@ -528,7 +528,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		int lbus = mp_irqs[i].mpc_srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mpc_apicid == mp_irqs[i].mpc_dstapic ||
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic ||
 			    mp_irqs[i].mpc_dstapic == MP_APIC_ALL)
 				break;
 
@@ -850,7 +850,7 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].mpc_apicid, pin, cfg->vector,
+		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 	/*
@@ -891,10 +891,10 @@ static void __init setup_IO_APIC_irqs(void)
 		idx = find_irq_entry(apic,pin,mp_INT);
 		if (idx == -1) {
 			if (first_notcon) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG " IO-APIC (apicid-pin) %d-%d", mp_ioapics[apic].mpc_apicid, pin);
+				apic_printk(APIC_VERBOSE, KERN_DEBUG " IO-APIC (apicid-pin) %d-%d", mp_ioapics[apic].mp_apicid, pin);
 				first_notcon = 0;
 			} else
-				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mpc_apicid, pin);
+				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mp_apicid, pin);
 			continue;
 		}
 		if (!first_notcon) {
@@ -969,7 +969,7 @@ void __apicdebuginit print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mpc_apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -987,7 +987,7 @@ void __apicdebuginit print_IO_APIC(void)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mpc_apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 
@@ -1845,8 +1845,8 @@ static int ioapic_resume(struct sys_device *dev)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mpc_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mpc_apicid;
+	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
+		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2340,7 +2340,7 @@ void __init ioapic_init_mappings(void)
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].mpc_apicaddr;
+			ioapic_phys = mp_ioapics[i].mp_apicaddr;
 		} else {
 			ioapic_phys = (unsigned long)
 				alloc_bootmem_pages(PAGE_SIZE);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d05b70c..9f1e5bf 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -176,7 +176,11 @@ static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
 	if (bad_ioapic(m->mpc_apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics] = *m;
+	mp_ioapics[nr_ioapics].mp_apicaddr = m->mpc_apicaddr;
+	mp_ioapics[nr_ioapics].mp_apicid = m->mpc_apicid;
+	mp_ioapics[nr_ioapics].mp_type = m->mpc_type;
+	mp_ioapics[nr_ioapics].mp_apicver = m->mpc_apicver;
+	mp_ioapics[nr_ioapics].mp_flags = m->mpc_flags;
 	nr_ioapics++;
 }
 
@@ -426,7 +430,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.mpc_type = MP_INTSRC;
 	intsrc.mpc_irqflag = 0;	/* conforming */
 	intsrc.mpc_srcbus = 0;
-	intsrc.mpc_dstapic = mp_ioapics[0].mpc_apicid;
+	intsrc.mpc_dstapic = mp_ioapics[0].mp_apicid;
 
 	intsrc.mpc_irqtype = mp_INT;
 
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 2ef96f0..ade76c0 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -112,8 +112,16 @@ extern int nr_ioapic_registers[MAX_IO_APICS];
 
 #define MP_MAX_IOAPIC_PIN 127
 
+struct mp_config_ioapic {
+	unsigned long mp_apicaddr;
+	unsigned int mp_apicid;
+	unsigned char mp_type;
+	unsigned char mp_apicver;
+	unsigned char mp_flags;
+};
+
 /* I/O APIC entries */
-extern struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
+extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;

