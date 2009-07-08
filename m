Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZGHEQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZGHEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZGHEOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:38 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:42604 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZGHEOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:16 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 06/12] ACPI, x86: remove ACPI dependency on some IO-APIC
 routines
Date: Wed, 08 Jul 2009 00:13:52 -0400
Message-id: <bf8ea7cda3ad3f287f1c9164d366a94eae07a4a5.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Both ACPI and SFI x86 systems will use these io_apic routines:

uniq_ioapic_id(u8 id);
io_apic_get_unique_id(int ioapic, int apic_id);
io_apic_get_version(int ioapic);
io_apic_get_redir_entries(int ioapic);

so move the 1st from acpi/boot.c to io_apic.c,
and remove the #ifdef ACPI around the other three.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/io_apic.h |    3 +--
 arch/x86/kernel/acpi/boot.c    |   22 ----------------------
 arch/x86/kernel/apic/io_apic.c |   28 +++++++++++++++++++++-------
 3 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index daf866e..1a097b9 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,11 +150,10 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-#ifdef CONFIG_ACPI
+extern u8 uniq_ioapic_id(u8 id);
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-#endif /* CONFIG_ACPI */
 
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6b8ca3a..a7f9e89 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -863,28 +863,6 @@ int mp_find_ioapic_pin(int ioapic, int gsi)
 	return gsi - mp_ioapic_routing[ioapic].gsi_base;
 }
 
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
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..5884e60 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3944,11 +3944,27 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 	return __io_apic_set_pci_routing(dev, irq, irq_attr);
 }
 
-/* --------------------------------------------------------------------------
-                          ACPI-based IOAPIC Configuration
-   -------------------------------------------------------------------------- */
-
-#ifdef CONFIG_ACPI
+u8 __init uniq_ioapic_id(u8 id)
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
@@ -4057,8 +4073,6 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 	return 0;
 }
 
-#endif /* CONFIG_ACPI */
-
 /*
  * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
-- 
1.6.0.6

