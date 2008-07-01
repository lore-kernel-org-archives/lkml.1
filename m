Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYGAANX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYGAANX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYGAANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:13:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62158 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753252AbYGAANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:13:11 -0400
Date: Tue, 1 Jul 2008 01:11:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mpparse: Add a knob to disable IRQ 0 through I/O APIC
Message-ID: <Pine.LNX.4.55.0807010041030.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 As discovered recently some systems exhibit problems when the 8254 timer 
IRQ is routed through the I/O APIC.  These problems do not affect the 
timer IRQ itself and therefore cannot be detected when the correctness of 
operation of the interrupt is verified in check_timer().  Therefore the 
I/O APIC path of the timer IRQ has to be disabled entirely.

 This is a change that lets platforms ask for the timer IRQ not to be 
registered in the I/O APIC interrupt tables.  The local APIC and ExtINTA 
paths are unaffected.  This request is only taken into account for ACPI 
platforms as MP table systems seem unaffected so far.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-mpparse-acpi-noirq0-2
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/mpparse.c linux-2.6.26-rc1-20080505/arch/x86/kernel/mpparse.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/mpparse.c	2008-05-05 02:56:19.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/mpparse.c	2008-06-30 21:53:33.000000000 +0000
@@ -50,6 +50,8 @@ static int mp_current_pci_id;
 
 int pic_mode;
 
+int disable_irq0_through_ioapic __initdata;
+
 /*
  * Intel MP BIOS table parsing routines:
  */
@@ -887,6 +889,10 @@ void __init mp_override_legacy_irq(u8 bu
 	int ioapic = -1;
 	int pin = -1;
 
+	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+	if (bus_irq == 0 && disable_irq0_through_ioapic)
+		return;
+
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -955,6 +961,10 @@ void __init mp_config_acpi_legacy_irqs(v
 	for (i = 0; i < 16; i++) {
 		int idx;
 
+		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+		if (i == 0 && disable_irq0_through_ioapic)
+			continue;
+
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mpc_config_intsrc *irq = mp_irqs + idx;
 
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/mpspec.h linux-2.6.26-rc1-20080505/include/asm-x86/mpspec.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/mpspec.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/mpspec.h	2008-06-30 22:29:23.000000000 +0000
@@ -113,4 +113,15 @@ typedef struct physid_mask physid_mask_t
 
 extern physid_mask_t phys_cpu_present_map;
 
+#ifdef CONFIG_X86_MPPARSE
+static inline void set_disable_irq0_through_ioapic(int v)
+{
+	extern int disable_irq0_through_ioapic;
+
+	disable_irq0_through_ioapic = v;
+}
+#else
+static inline void set_disable_irq0_through_ioapic(int v) { }
+#endif
+
 #endif
