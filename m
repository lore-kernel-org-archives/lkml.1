Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYHSBPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYHSBPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYHSBP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:15:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:24687 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYHSBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AXsDOMoC0wvmVKOhUJCn0LQ4sjrl4ekK+uc6bzgY9J6qBJ8Rixdw35R9QF/vHiMNSP
         N6xbKx64BtotBoymtd7vDHABoNAL53LJl2ODeLZR+l1OGDgnOBbPLXJ62bJg5F9Fml6u
         L5dsb7eyPSx9sVSqlxX6VkqXTF8c2mZyf1Vmc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: probe nr_irqs even only mptable is used
Date: Mon, 18 Aug 2008 18:14:36 -0700
Message-Id: <1219108476-30501-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for !CONFIG_HAVE_SPARSE_IRQ

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   25 -------------------------
 arch/x86/kernel/io_apic.c   |   43 ++++++++++++++++++++++++++++++-------------
 arch/x86/kernel/setup.c     |    6 +++---
 include/asm-x86/io_apic.h   |    7 +++++++
 include/asm-x86/mpspec.h    |    1 -
 5 files changed, 40 insertions(+), 42 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -961,29 +961,6 @@ void __init mp_register_ioapic(int id, u
 	nr_ioapics++;
 }
 
-int get_nr_irqs_via_madt(void)
-{
-	int idx;
-	int nr = 0;
-
-	for (idx = 0; idx < nr_ioapics; idx++) {
-		if (mp_ioapic_routing[idx].gsi_end > nr)
-			nr = mp_ioapic_routing[idx].gsi_end;
-	}
-
-	nr++;
-
-	/* double it for hotplug and msi and nmi */
-	nr <<= 1;
-
-	/* something wrong ? */
-	if (nr < 32)
-		nr = 32;
-
-	return nr;
-
-}
-
 static void assign_to_mp_irq(struct mp_config_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
@@ -1282,8 +1259,6 @@ static int __init acpi_parse_madt_ioapic
 	}
 
 
-	nr_irqs = get_nr_irqs_via_madt();
-
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
 				  nr_irqs);
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3607,6 +3607,36 @@ int arch_setup_ht_irq(unsigned int irq,
 }
 #endif /* CONFIG_HT_IRQ */
 
+int __init io_apic_get_redir_entries (int ioapic)
+{
+	union IO_APIC_reg_01	reg_01;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	reg_01.raw = io_apic_read(ioapic, 1);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return reg_01.bits.entries;
+}
+
+int __init probe_nr_irqs(void)
+{
+	int idx;
+	int nr = 0;
+
+	for (idx = 0; idx < nr_ioapics; idx++)
+		nr += io_apic_get_redir_entries(idx);
+
+	/* double it for hotplug and msi and nmi */
+	nr <<= 1;
+
+	/* something wrong ? */
+	if (nr < 32)
+		nr = 32;
+
+	return nr;
+}
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
@@ -3701,19 +3731,6 @@ int __init io_apic_get_version(int ioapi
 }
 #endif
 
-int __init io_apic_get_redir_entries (int ioapic)
-{
-	union IO_APIC_reg_01	reg_01;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return reg_01.bits.entries;
-}
-
-
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
 	if (!IO_APIC_IRQ(irq)) {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -873,15 +873,15 @@ void __init setup_arch(char **cmdline_p)
 	prefill_possible_map();
 
 #ifdef CONFIG_X86_64
-	/* need to wait for nr_cpu_ids settle down */
-	if (nr_irqs == NR_IRQS)
-		nr_irqs = 32 * nr_cpu_ids + 224;
 	init_cpu_to_node();
 #endif
 
 	init_apic_mappings();
 	ioapic_init_mappings();
 
+	/* need to wait for io_apic is mapped */
+	nr_irqs = probe_nr_irqs();
+
 	kvm_guest_init();
 
 	res_kernel[0] = &code_resource;
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -59,7 +59,6 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
-extern int get_nr_irqs_via_madt(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
Index: linux-2.6/include/asm-x86/io_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/io_apic.h
+++ linux-2.6/include/asm-x86/io_apic.h
@@ -197,10 +197,17 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
+extern int probe_nr_irqs(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void) { }
+
+static inline int probe_nr_irqs(void)
+{
+	return NR_IRQS;
+}
 #endif
 
 #endif /* ASM_X86__IO_APIC_H */
