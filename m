Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZHNUkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZHNUkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZHNUkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:40:40 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:56084 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZHNUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:36 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 05/11] ACPI,
 x86: expose some IO-APIC routines when CONFIG_ACPI=n
Date: Fri, 14 Aug 2009 16:38:09 -0400
Message-id: <2a98e7573b83bac1a79292a428090ee352626216.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Some IO-APIC routines are ACPI specific now, but need to
be exposed when CONFIG_ACPI=n for the benefit of SFI.

Remove #ifdef ACPI around these routines:

io_apic_get_unique_id(int ioapic, int apic_id);
io_apic_get_version(int ioapic);
io_apic_get_redir_entries(int ioapic);

Move these routines from ACPI-specific boot.c to io_apic.c:

uniq_ioapic_id(u8 id)
mp_find_ioapic()
mp_find_ioapic_pin()
mp_register_ioapic()

Also, since uniq_ioapic_id() is now no longer static,
re-name it to io_apic_unique_id() for consistency
with the other public io_apic routines.

For simplicity, do not #ifdef the resulting code ACPI || SFI,
thought that could be done in the future if it is important
to optimize the !ACPI !SFI IO-APIC x86 kernel for size.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/io_apic.h |   13 ++++-
 arch/x86/kernel/acpi/boot.c    |  102 +---------------------------------------
 arch/x86/kernel/apic/io_apic.c |  103 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 109 insertions(+), 109 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 330ee80..85232d3 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,11 +150,10 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-#ifdef CONFIG_ACPI
+extern u8 io_apic_unique_id(u8 id);
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-#endif /* CONFIG_ACPI */
 
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
@@ -177,6 +176,16 @@ extern int setup_ioapic_entry(int apic, int irq,
 			      int polarity, int vector, int pin);
 extern void ioapic_write_entry(int apic, int pin,
 			       struct IO_APIC_route_entry e);
+
+struct mp_ioapic_gsi{
+	int gsi_base;
+	int gsi_end;
+};
+extern struct mp_ioapic_gsi  mp_gsi_routing[];
+int mp_find_ioapic(int gsi);
+int mp_find_ioapic_pin(int ioapic, int gsi);
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6b8ca3a..7e62d1e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -833,106 +833,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-static struct {
-	int gsi_base;
-	int gsi_end;
-} mp_ioapic_routing[MAX_IO_APICS];
-
-int mp_find_ioapic(int gsi)
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
-int mp_find_ioapic_pin(int ioapic, int gsi)
-{
-	if (WARN_ON(ioapic == -1))
-		return -1;
-	if (WARN_ON(gsi > mp_ioapic_routing[ioapic].gsi_end))
-		return -1;
-
-	return gsi - mp_ioapic_routing[ioapic].gsi_base;
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
-		struct mpc_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->apicid, used);
-	}
-	if (!test_bit(id, used))
-		return id;
-	return find_first_zero_bit(used, 256);
-#endif
-}
-
-static int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_ERR "ERROR: Max # of I/O APICs (%d) exceeded "
-		       "(found %d)\n", MAX_IO_APICS, nr_ioapics);
-		panic("Recompile kernel with bigger MAX_IO_APICS!\n");
-	}
-	if (!address) {
-		printk(KERN_ERR "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
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
-	mp_ioapics[idx].type = MP_IOAPIC;
-	mp_ioapics[idx].flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].apicaddr = address;
-
-	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
-	mp_ioapics[idx].apicver = io_apic_get_version(idx);
-
-	/*
-	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
-	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
-	 */
-	mp_ioapic_routing[idx].gsi_base = gsi_base;
-	mp_ioapic_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
-
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
-	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
-
-	nr_ioapics++;
-}
-
 int __init acpi_probe_gsi(void)
 {
 	int idx;
@@ -947,7 +847,7 @@ int __init acpi_probe_gsi(void)
 
 	max_gsi = 0;
 	for (idx = 0; idx < nr_ioapics; idx++) {
-		gsi = mp_ioapic_routing[idx].gsi_end;
+		gsi = mp_gsi_routing[idx].gsi_end;
 
 		if (gsi > max_gsi)
 			max_gsi = gsi;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d2ed6c5..a8c0232 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -85,6 +85,9 @@ int nr_ioapic_registers[MAX_IO_APICS];
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
+/* IO APIC gsi routing info */
+struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
+
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
@@ -3941,11 +3944,28 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 	return __io_apic_set_pci_routing(dev, irq, irq_attr);
 }
 
-/* --------------------------------------------------------------------------
-                          ACPI-based IOAPIC Configuration
-   -------------------------------------------------------------------------- */
+u8 __init io_apic_unique_id(u8 id)
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
 
-#ifdef CONFIG_ACPI
+	bitmap_zero(used, 256);
+	for (i = 0; i < nr_ioapics; i++) {
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
+	}
+	if (!test_bit(id, used))
+		return id;
+	return find_first_zero_bit(used, 256);
+#endif
+}
 
 #ifdef CONFIG_X86_32
 int __init io_apic_get_unique_id(int ioapic, int apic_id)
@@ -4054,8 +4074,6 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 	return 0;
 }
 
-#endif /* CONFIG_ACPI */
-
 /*
  * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
@@ -4201,3 +4219,76 @@ void __init ioapic_insert_resources(void)
 		r++;
 	}
 }
+
+int mp_find_ioapic(int gsi)
+{
+	int i = 0;
+
+	/* Find the IOAPIC that manages this GSI. */
+	for (i = 0; i < nr_ioapics; i++) {
+		if ((gsi >= mp_gsi_routing[i].gsi_base)
+		    && (gsi <= mp_gsi_routing[i].gsi_end))
+			return i;
+	}
+
+	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+	return -1;
+}
+
+int mp_find_ioapic_pin(int ioapic, int gsi)
+{
+	if (WARN_ON(ioapic == -1))
+		return -1;
+	if (WARN_ON(gsi > mp_gsi_routing[ioapic].gsi_end))
+		return -1;
+
+	return gsi - mp_gsi_routing[ioapic].gsi_base;
+}
+
+static int bad_ioapic(unsigned long address)
+{
+	if (nr_ioapics >= MAX_IO_APICS) {
+		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
+		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		return 1;
+	}
+	if (!address) {
+		printk(KERN_WARNING "WARNING: Bogus (zero) I/O APIC address"
+		       " found in table, skipping!\n");
+		return 1;
+	}
+	return 0;
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
+	mp_ioapics[idx].type = MP_IOAPIC;
+	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].apicaddr = address;
+
+	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	mp_ioapics[idx].apicid = io_apic_unique_id(id);
+	mp_ioapics[idx].apicver = io_apic_get_version(idx);
+
+	/*
+	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
+	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
+	 */
+	mp_gsi_routing[idx].gsi_base = gsi_base;
+	mp_gsi_routing[idx].gsi_end = gsi_base +
+	    io_apic_get_redir_entries(idx);
+
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
+	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
+	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
+
+	nr_ioapics++;
+}
-- 
1.6.0.6

