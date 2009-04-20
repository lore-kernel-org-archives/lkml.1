Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZDTUQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZDTUQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZDTUPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:15:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:39945 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbZDTUPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="683221229"
Message-Id: <20090420200450.271099000@linux-os.sc.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:02:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>
Subject: [patch 2/5] x2apic, IR: Fix compiler warning with !CONFIG_INTR_REMAP
Content-Disposition: inline; filename=fix_ioapic_warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix complier warning:
arch/x86/kernel/apic/io_apic.c:2543: warning: `eoi_ioapic_irq' defined but not used

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
---

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2518,39 +2518,6 @@ static void irq_complete_move(struct irq
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-
-	entry = cfg->irq_2_pin;
-	for (;;) {
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		io_apic_eoi(apic, pin);
-		entry = entry->next;
-	}
-}
-
-static void
-eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ack_apic_edge(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2660,6 +2627,39 @@ static void ack_apic_level(unsigned int 
 }
 
 #ifdef CONFIG_INTR_REMAP
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		io_apic_eoi(apic, pin);
+		entry = entry->next;
+	}
+}
+
+static void
+eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void ir_ack_apic_edge(unsigned int irq)
 {
 	ack_APIC_irq();

-- 

