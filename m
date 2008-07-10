Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbYGJSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbYGJSnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbYGJSlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYGJSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061657"
Message-Id: <20080710182237.772464000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:47 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 13/26] x64, x2apic/intr-remap: ioapic routines which deal with initial io-apic RTE setup
Content-Disposition: inline; filename=ioapic_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic ioapic specific routines which be used later during enabling
interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/io_apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/io_apic_64.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:11.000000000 -0700
@@ -114,6 +114,9 @@
  */
 int nr_ioapic_registers[MAX_IO_APICS];
 
+/* I/O APIC RTE contents at the OS boot up */
+struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+
 /* I/O APIC entries */
 struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
@@ -446,6 +449,69 @@
 			clear_IO_APIC_pin(apic, pin);
 }
 
+/*
+ * Saves and masks all the unmasked IO-APIC RTE's
+ */
+int save_mask_IO_APIC_setup(void)
+{
+	union IO_APIC_reg_01 reg_01;
+	unsigned long flags;
+	int apic, pin;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_01.raw = io_apic_read(apic, 1);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		early_ioapic_entries[apic] =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				nr_ioapic_registers[apic], GFP_KERNEL);
+		if (!early_ioapic_entries[apic])
+			return -ENOMEM;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+			struct IO_APIC_route_entry entry;
+
+			entry = early_ioapic_entries[apic][pin] =
+				ioapic_read_entry(apic, pin);
+			if (!entry.mask) {
+				entry.mask = 1;
+				ioapic_write_entry(apic, pin, entry);
+			}
+		}
+	return 0;
+}
+
+void restore_IO_APIC_setup(void)
+{
+	int apic, pin;
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+			ioapic_write_entry(apic, pin,
+					   early_ioapic_entries[apic][pin]);
+}
+
+void reinit_intr_remapped_IO_APIC(int intr_remapping)
+{
+	/*
+	 * for now plain restore of previous settings.
+	 * TBD: In the case of OS enabling interrupt-remapping,
+	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
+	 * table entries. for now, do a plain restore, and wait for
+	 * the setup_IO_APIC_irqs() to do proper initialization.
+	 */
+	restore_IO_APIC_setup();
+}
+
 int skip_ioapic_setup;
 int ioapic_force;
 
Index: tree-x86/include/asm-x86/io_apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/io_apic.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/io_apic.h	2008-07-10 09:52:11.000000000 -0700
@@ -193,6 +193,12 @@
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
+#ifdef CONFIG_X86_64
+extern int save_mask_IO_APIC_setup(void);
+extern void restore_IO_APIC_setup(void);
+extern void reinit_intr_remapped_IO_APIC(int);
+#endif
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;

-- 

