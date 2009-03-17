Return-Path: <linux-kernel-owner+w=401wt.eu-S1762550AbZCQA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbZCQA37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbZCQA2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:32172 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbZCQA2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="120907283"
Message-Id: <20090317001321.260428000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:03 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 11/13] ioapic: Fix non atomic allocation with interrupts disabled
Content-Disposition: inline; filename=fix_kmalloc_with_irqs_disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save_mask_IO_APIC_setup() was using non atomic memory allocation while getting
called with interrupts disabled. Fix this by splitting this into two different
function. Allocation part save_IO_APIC_setup() now happens before
disabling interrupts.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1338,15 +1338,16 @@ void __init enable_IR_x2apic(void)
 		return;
 	}
 
-	local_irq_save(flags);
-	mask_8259A();
-
-	ret = save_mask_IO_APIC_setup();
+	ret = save_IO_APIC_setup();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
 		goto end;
 	}
 
+	local_irq_save(flags);
+	mask_IO_APIC_setup();
+	mask_8259A();
+
 	ret = enable_intr_remapping(1);
 
 	if (ret && x2apic_preenabled) {
@@ -1371,10 +1372,10 @@ end_restore:
 	else
 		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
 
-end:
 	unmask_8259A();
 	local_irq_restore(flags);
 
+end:
 	if (!ret) {
 		if (!x2apic_preenabled)
 			pr_info("Enabled x2apic and interrupt-remapping\n");
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -853,9 +853,9 @@ __setup("pirq=", ioapic_pirq_setup);
 static struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
 
 /*
- * Saves and masks all the unmasked IO-APIC RTE's
+ * Saves all the IO-APIC RTE's
  */
-int save_mask_IO_APIC_setup(void)
+int save_IO_APIC_setup(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	unsigned long flags;
@@ -880,16 +880,9 @@ int save_mask_IO_APIC_setup(void)
 	}
 
 	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			struct IO_APIC_route_entry entry;
-
-			entry = early_ioapic_entries[apic][pin] =
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+			early_ioapic_entries[apic][pin] =
 				ioapic_read_entry(apic, pin);
-			if (!entry.mask) {
-				entry.mask = 1;
-				ioapic_write_entry(apic, pin, entry);
-			}
-		}
 
 	return 0;
 
@@ -902,6 +895,25 @@ nomem:
 	return -ENOMEM;
 }
 
+void mask_IO_APIC_setup(void)
+{
+	int apic, pin;
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		if (!early_ioapic_entries[apic])
+			break;
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+			struct IO_APIC_route_entry entry;
+
+			entry = early_ioapic_entries[apic][pin];
+			if (!entry.mask) {
+				entry.mask = 1;
+				ioapic_write_entry(apic, pin, entry);
+			}
+		}
+	}
+}
+
 void restore_IO_APIC_setup(void)
 {
 	int apic, pin;
Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -162,7 +162,8 @@ extern int (*ioapic_renumber_irq)(int io
 extern void ioapic_init_mappings(void);
 
 #ifdef CONFIG_X86_64
-extern int save_mask_IO_APIC_setup(void);
+extern int save_IO_APIC_setup(void);
+extern void mask_IO_APIC_setup(void);
 extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif

-- 

